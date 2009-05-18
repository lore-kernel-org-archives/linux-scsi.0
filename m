From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/5] mpt2sas: LUN Reset Support
Date: Mon, 18 May 2009 13:00:45 -0600
Message-ID: <20090518190043.GC26609@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:34182 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZERSzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2009 14:55:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Adding new eh_target_reset_handler for target reset. Change the
eh_device_reset_handler so its sending
MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, instead of
MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET.  Add new function
_scsih_scsi_lookup_find_by_lun as a sanity check to insure I_T_L commands are
completed upon completing lun reset.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-05-18 12:23:24.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-05-18 12:23:24.000000000 -0600
@@ -884,6 +884,41 @@ _scsih_scsi_lookup_find_by_target(struct
 }
 
 /**
+ * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
+ * @ioc: per adapter object
+ * @id: target id
+ * @lun: lun number
+ * @channel: channel
+ * Context: This function will acquire ioc->scsi_lookup_lock.
+ *
+ * This will search for a matching channel:id:lun in the scsi_lookup array,
+ * returning 1 if found.
+ */
+static u8
+_scsih_scsi_lookup_find_by_lun(struct MPT2SAS_ADAPTER *ioc, int id,
+    unsigned int lun, int channel)
+{
+	u8 found;
+	unsigned long	flags;
+	int i;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	found = 0;
+	for (i = 0 ; i < ioc->request_depth; i++) {
+		if (ioc->scsi_lookup[i].scmd &&
+		    (ioc->scsi_lookup[i].scmd->device->id == id &&
+		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
+		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
+			found = 1;
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return found;
+}
+
+/**
  * _scsih_get_chain_buffer_dma - obtain block of chains (dma address)
  * @ioc: per adapter object
  * @smid: system request message index
@@ -1889,7 +1924,6 @@ scsih_abort(struct scsi_cmnd *scmd)
 	return r;
 }
 
-
 /**
  * scsih_dev_reset - eh threads main device reset routine
  * @sdev: scsi device struct
@@ -1906,7 +1940,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	u16	handle;
 	int r;
 
-	printk(MPT2SAS_INFO_FMT "attempting target reset! scmd(%p)\n",
+	printk(MPT2SAS_INFO_FMT "attempting device reset! scmd(%p)\n",
 	    ioc->name, scmd);
 	scsi_print_command(scmd);
 
@@ -1941,6 +1975,78 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 
 	mutex_lock(&ioc->tm_cmds.mutex);
 	mpt2sas_scsih_issue_tm(ioc, handle, 0,
+	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, scmd->device->lun,
+	    30);
+
+	/*
+	 *  sanity check see whether all commands to this device been
+	 *  completed
+	 */
+	if (_scsih_scsi_lookup_find_by_lun(ioc, scmd->device->id,
+	    scmd->device->lun, scmd->device->channel))
+		r = FAILED;
+	else
+		r = SUCCESS;
+	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
+	mutex_unlock(&ioc->tm_cmds.mutex);
+
+ out:
+	printk(MPT2SAS_INFO_FMT "device reset: %s scmd(%p)\n",
+	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	return r;
+}
+
+/**
+ * scsih_target_reset - eh threads main target reset routine
+ * @sdev: scsi device struct
+ *
+ * Returns SUCCESS if command aborted else FAILED
+ */
+static int
+scsih_target_reset(struct scsi_cmnd *scmd)
+{
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	u16	handle;
+	int r;
+
+	printk(MPT2SAS_INFO_FMT "attempting target reset! scmd(%p)\n",
+	    ioc->name, scmd);
+	scsi_print_command(scmd);
+
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+		printk(MPT2SAS_INFO_FMT "target been deleted! scmd(%p)\n",
+		    ioc->name, scmd);
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
+	/* for hidden raid components obtain the volume_handle */
+	handle = 0;
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = _scsih_sas_device_find_by_handle(ioc,
+		   sas_device_priv_data->sas_target->handle);
+		if (sas_device)
+			handle = sas_device->volume_handle;
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	} else
+		handle = sas_device_priv_data->sas_target->handle;
+
+	if (!handle) {
+		scmd->result = DID_RESET << 16;
+		r = FAILED;
+		goto out;
+	}
+
+	mutex_lock(&ioc->tm_cmds.mutex);
+	mpt2sas_scsih_issue_tm(ioc, handle, 0,
 	    MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 30);
 
 	/*
@@ -5255,6 +5361,7 @@ static struct scsi_host_template scsih_d
 	.change_queue_type		= scsih_change_queue_type,
 	.eh_abort_handler		= scsih_abort,
 	.eh_device_reset_handler	= scsih_dev_reset,
+	.eh_target_reset_handler	= scsih_target_reset,
 	.eh_host_reset_handler		= scsih_host_reset,
 	.bios_param			= scsih_bios_param,
 	.can_queue			= 1,
