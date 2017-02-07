From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 3.10 141/319] scsi: mpt3sas: Fix secure erase premature
 termination
Date: Tue, 7 Feb 2017 07:59:46 +0100
Message-ID: <20170207065946.GC4850@1wt.eu>
References: <1486322541-8206-1-git-send-email-w@1wt.eu>
 <1486322541-8206-42-git-send-email-w@1wt.eu>
 <ae8ffc4f86c5af1caf97dfa9a6493443@mail.gmail.com>
 <20170206222623.GA4769@1wt.eu>
 <1486449528.2474.125.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486449528.2474.125.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux@roeck-us.net, Andrey Grodzovsky <andrey2805@gmail.com>, linux-scsi@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

On Mon, Feb 06, 2017 at 10:38:48PM -0800, James Bottomley wrote:
> On Mon, 2017-02-06 at 23:26 +0100, Willy Tarreau wrote:
(...)
> > We don't have the referenced commit above in 3.10 so we should be 
> > safe. Additionally I checked that neither 4.4 nor 3.12 have them 
> > either, so that makes me feel confident that we can skip it in 3.10
> > as well.
> 
> The original was also racy with respect to multiple commands, so the
> above fixed the race as well.

OK so I tried to backport it to 3.10. I dropped a few parts which were
addressing this one marked for stable 4.4+ :
    7ff723a ("scsi: mpt3sas: Unblock device after controller reset")

And I got the attached patch. All I know is that it builds. I'd appreciate
it if someone could confirm its validity, in which case I'll add it.

Thanks,
Willy

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 994656c..997e13f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -219,6 +219,7 @@ struct MPT3SAS_TARGET {
  * @eedp_enable: eedp support enable bit
  * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
  * @eedp_block_length: block size
+ * @ata_command_pending: SATL passthrough outstanding for device
  */
 struct MPT3SAS_DEVICE {
 	struct MPT3SAS_TARGET *sas_target;
@@ -227,6 +228,17 @@ struct MPT3SAS_DEVICE {
 	u8	configured_lun;
 	u8	block;
 	u8	tlr_snoop_check;
+	/*
+	 * Bug workaround for SATL handling: the mpt2/3sas firmware
+	 * doesn't return BUSY or TASK_SET_FULL for subsequent
+	 * commands while a SATL pass through is in operation as the
+	 * spec requires, it simply does nothing with them until the
+	 * pass through completes, causing them possibly to timeout if
+	 * the passthrough is a long executing command (like format or
+	 * secure erase).  This variable allows us to do the right
+	 * thing while a SATL command is pending.
+	 */
+	unsigned long ata_command_pending;
 };
 
 #define MPT3_CMD_NOT_USED	0x8000	/* free */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e414b71..db38f70 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3515,9 +3515,18 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 {
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+	struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;
+
+	if (scmd->cmnd[0] != ATA_12 && scmd->cmnd[0] != ATA_16)
+		return 0;
+
+	if (pending)
+		return test_and_set_bit(0, &priv->ata_command_pending);
+
+	clear_bit(0, &priv->ata_command_pending);
+	return 0;
 }
 
 /**
@@ -3547,13 +3556,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		scsi_print_command(scmd);
 #endif
 
-	/*
-	 * Lock the device for any subsequent command until command is
-	 * done.
-	 */
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_block(scmd->device);
-
 	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
@@ -3568,6 +3570,19 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		return 0;
 	}
 
+	/*
+	 * Bug work around for firmware SATL handling.  The loop
+	 * is based on atomic operations and ensures consistency
+	 * since we're lockless at this point
+	 */
+	do {
+		if (test_bit(0, &sas_device_priv_data->ata_command_pending)) {
+			scmd->result = SAM_STAT_BUSY;
+			scmd->scsi_done(scmd);
+			return 0;
+		}
+	} while (_scsih_set_satl_pending(scmd, true));
+
 	sas_target_priv_data = sas_device_priv_data->sas_target;
 
 	/* invalid device handle */
@@ -4057,8 +4072,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+	_scsih_set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
