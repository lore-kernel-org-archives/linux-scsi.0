From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 3.10 141/319] scsi: mpt3sas: Fix secure erase premature
 termination
Date: Wed, 8 Feb 2017 07:53:56 +0100
Message-ID: <20170208065356.GA4838@1wt.eu>
References: <1486322541-8206-1-git-send-email-w@1wt.eu>
 <1486322541-8206-42-git-send-email-w@1wt.eu>
 <ae8ffc4f86c5af1caf97dfa9a6493443@mail.gmail.com>
 <20170206222623.GA4769@1wt.eu>
 <1486449528.2474.125.camel@HansenPartnership.com>
 <20170207065946.GC4850@1wt.eu>
 <1486486971.2488.19.camel@HansenPartnership.com>
 <20170207171234.GB4041@1wt.eu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170207171234.GB4041@1wt.eu>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux@roeck-us.net, Andrey Grodzovsky <andrey2805@gmail.com>, linux-scsi@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 06:12:34PM +0100, Willy Tarreau wrote:
> On Tue, Feb 07, 2017 at 09:02:51AM -0800, James Bottomley wrote:
> > On Tue, 2017-02-07 at 07:59 +0100, Willy Tarreau wrote:
> > > Hi James,
> > > 
> > > On Mon, Feb 06, 2017 at 10:38:48PM -0800, James Bottomley wrote:
> > > > On Mon, 2017-02-06 at 23:26 +0100, Willy Tarreau wrote:
> > > (...)
> > > > > We don't have the referenced commit above in 3.10 so we should be
> > > > > safe. Additionally I checked that neither 4.4 nor 3.12 have them 
> > > > > either, so that makes me feel confident that we can skip it in 
> > > > > 3.10 as well.
> > > > 
> > > > The original was also racy with respect to multiple commands, so 
> > > > the above fixed the race as well.
> > > 
> > > OK so I tried to backport it to 3.10. I dropped a few parts which 
> > > were addressing this one marked for stable 4.4+ :
> > >     7ff723a ("scsi: mpt3sas: Unblock device after controller reset")
> > > 
> > > And I got the attached patch. All I know is that it builds. I'd 
> > > appreciate it if someone could confirm its validity, in which case
> > > I'll add it.
> > 
> > The two patches apply without fuzz to your tree and the combination is
> > a far better bug fix than the original regardless of whether 7ff723a
> > exists in your tree or not.  By messing with the patches all you do is
> > add the potential for introducing new bugs for no benefit, so why take
> > risk for no upside?
> 
> Just because I'm suggested to apply this fix which is supposed to fix
> a regression brought by 7ff723a which itself is marked to fix 4.4+ only
> and which doesn't apply to 3.10. So now I'm getting confused because
> you say that these patches apply without fuzz but one part definitely
> is rejected and the other one has to be applied by hand. I want not
> to take a risk but I'm faced with these options :
>   - drop all these patches and stay as 3.10.104 is
>   - merge the "secure erase premature" + the the part of the patch
>     that supposedly fixes the regression it introduced
>   - merge this fix + 7ff723a + whatever it depends on (not fond of
>     it)
> 
> In all cases I don't even have the hardware to validate anything. I'd
> be more tempted with the first two options. If you think I'm taking
> risks by backporting the relevant part of the fix, I'll simply drop
> them all and leave the code as it is now.

So I could backport the fix marked for 4.4+ (7ff723a) and the one
suggested by Sathya (ffb5845). The context was slightly different
but the changes obvious enough to look good. If everyone is OK, I'll
add these two commits. Here are the backports.

Willy

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-scsi-mpt3sas-Unblock-device-after-controller-reset.patch"

>From acd34b89fe261c88398e26bd3055000052eb7808 Mon Sep 17 00:00:00 2001
From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Date: Thu, 17 Nov 2016 16:15:58 +0530
Subject: scsi: mpt3sas: Unblock device after controller reset

commit 7ff723ad0f87feba43dda45fdae71206063dd7d4 upstream.

While issuing any ATA passthrough command to firmware the driver will
block the device. But it will unblock the device only if the I/O
completes through the ISR path. If a controller reset occurs before
command completion the device will remain in blocked state.

Make sure we unblock the device following a controller reset if an ATA
passthrough command was queued.

[mkp: clarified patch description]

Cc: <stable@vger.kernel.org> # v4.4+
Fixes: ac6c2a93bd07 ("mpt3sas: Fix for SATA drive in blocked state, after diag reset")
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[wt: adjust context]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e414b71..8979403 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3390,6 +3390,11 @@ _scsih_check_volume_delete_events(struct MPT3SAS_ADAPTER *ioc,
 		    le16_to_cpu(event_data->VolDevHandle));
 }
 
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
+
 /**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
@@ -3411,6 +3416,9 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
+		if (ata_12_16_cmd(scmd))
+			scsi_internal_device_unblock(scmd->device,
+							SDEV_RUNNING);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -3515,11 +3523,6 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
-{
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
-}
-
 /**
  * _scsih_qcmd_lck - main scsi request entry point
  * @scmd: pointer to scsi command object
-- 
2.8.0.rc2.1.gbe9624a


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-scsi-mpt3sas-fix-hang-on-ata-passthrough-commands.patch"

>From 4367c8585788a98b1cc2f36af40a3d4f1fef86d0 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 1 Jan 2017 09:39:24 -0800
Subject: scsi: mpt3sas: fix hang on ata passthrough commands

commit ffb58456589443ca572221fabbdef3db8483a779 upstream.

mpt3sas has a firmware failure where it can only handle one pass through
ATA command at a time.  If another comes in, contrary to the SAT
standard, it will hang until the first one completes (causing long
commands like secure erase to timeout).  The original fix was to block
the device when an ATA command came in, but this caused a regression
with

commit 669f044170d8933c3d66d231b69ea97cb8447338
Author: Bart Van Assche <bart.vanassche@sandisk.com>
Date:   Tue Nov 22 16:17:13 2016 -0800

    scsi: srp_transport: Move queuecommand() wait code to SCSI core

So fix the original fix of the secure erase timeout by properly
returning SAM_STAT_BUSY like the SAT recommends.  The original patch
also had a concurrency problem since scsih_qcmd is lockless at that
point (this is fixed by using atomic bitops to set and test the flag).

[mkp: addressed feedback wrt. test_bit and fixed whitespace]

Fixes: 18f6084a989ba1b (mpt3sas: Fix secure erase premature termination)
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[wt: adjust context]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 12 +++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 40 +++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 14 deletions(-)

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
index 8979403..1d6e115 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3390,9 +3390,18 @@ _scsih_check_volume_delete_events(struct MPT3SAS_ADAPTER *ioc,
 		    le16_to_cpu(event_data->VolDevHandle));
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
@@ -3416,9 +3425,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
-		if (ata_12_16_cmd(scmd))
-			scsi_internal_device_unblock(scmd->device,
-							SDEV_RUNNING);
+		_scsih_set_satl_pending(scmd, false);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -3550,13 +3557,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
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
@@ -3571,6 +3571,19 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
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
@@ -4060,8 +4073,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+	_scsih_set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
-- 
2.8.0.rc2.1.gbe9624a


--zhXaljGHf11kAtnf--
