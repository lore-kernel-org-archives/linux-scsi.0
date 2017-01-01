From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Sun, 01 Jan 2017 09:39:24 -0800
Message-ID: <1483292364.2345.5.camel@linux.vnet.ibm.com>
References: <20161229080250.GA11605@infradead.org>
         <1483226343.2518.32.camel@linux.vnet.ibm.com>
         <1483280506.5512.1.camel@sandisk.com>
         <20170101.113311.417107391370623850.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43439 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932153AbdAARjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jan 2017 12:39:35 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v01Hd5cV028210
        for <linux-scsi@vger.kernel.org>; Sun, 1 Jan 2017 12:39:35 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27pvmwe9vp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jan 2017 12:39:34 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Sun, 1 Jan 2017 12:39:34 -0500
In-Reply-To: <20170101.113311.417107391370623850.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>, Bart.VanAssche@sandisk.com
Cc: hch@infradead.org, jbaron@akamai.com, linux-kernel@vger.kernel.org, sagi@grimberg.me, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, Sreekanth.Reddy@broadcom.com, chaitra.basappa@broadcom.com, dledford@redhat.com

On Sun, 2017-01-01 at 11:33 -0500, David Miller wrote:
> From: Bart Van Assche <Bart.VanAssche@sandisk.com>
> Date: Sun, 1 Jan 2017 14:22:11 +0000
> 
> > My recommendation is to revert commit 18f6084a989b ("scsi: mpt3sas: Fix
> > secure erase premature termination"). Since the mpt3sas driver uses the
> > single-queue approach and since the SCSI core unlocks the block layer
> > request queue lock before the .queuecommand callback function is called,
> > multiple threads can execute that callback function (scsih_qcmd() in this
> > case) simultaneously. This means that using scsi_internal_device_block()
> > from inside .queuecommand to serialize SCSI command execution is wrong.
> 
> But this causes a regression for the thing being fixed by that
> commit.

Right, we don't do that; that's why I didn't list it as one of the
options.

> Why don't we figure out what that semantics that commit was trying to
> achieve and implement that properly?

Now that I look at the reviews, each of the reviewers said what the
correct thing to do was: return SAM_STAT_BUSY if SATL commands are
outstanding like the spec says.  You all get negative brownie points
for not insisting on a rework.

Does this patch (compile tested only) fix the problems for everyone?

James

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 394fe13..0983a65 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -393,6 +393,7 @@ struct MPT3SAS_TARGET {
  * @eedp_enable: eedp support enable bit
  * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
  * @eedp_block_length: block size
+ * @ata_command_pending: SATL passthrough outstanding for device
  */
 struct MPT3SAS_DEVICE {
 	struct MPT3SAS_TARGET *sas_target;
@@ -404,6 +405,17 @@ struct MPT3SAS_DEVICE {
 	u8	ignore_delay_remove;
 	/* Iopriority Command Handling */
 	u8	ncq_prio_enable;
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
+	u8 ata_command_pending;
 
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e..1446a0a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3899,9 +3899,12 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+static void set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 {
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+	struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;
+
+	if  (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16)
+		priv->ata_command_pending = pending;
 }
 
 /**
@@ -3925,9 +3928,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
-		if (ata_12_16_cmd(scmd))
-			scsi_internal_device_unblock(scmd->device,
-							SDEV_RUNNING);
+		set_satl_pending(scmd, false);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4063,13 +4064,6 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
 
-	/*
-	 * Lock the device for any subsequent command until command is
-	 * done.
-	 */
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_block(scmd->device);
-
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4083,6 +4077,16 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
+	/*
+	 * Bug work around for firmware SATL handling
+	 */
+	if (sas_device_priv_data->ata_command_pending) {
+		scmd->result = SAM_STAT_BUSY;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+	set_satl_pending(scmd, true);
+
 	sas_target_priv_data = sas_device_priv_data->sas_target;
 
 	/* invalid device handle */
@@ -4650,8 +4654,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+	set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 

