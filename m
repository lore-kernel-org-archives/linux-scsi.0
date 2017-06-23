From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/35] mptfusion: correct definitions for mptscsih_dev_reset()
Date: Fri, 23 Jun 2017 15:02:46 +0200
Message-ID: <1498222975-71858-27-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752407AbdFWNDb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:31 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

mptscsih_dev_reset() is _not_ a device reset, but rather a
target reset. Nevertheless it's being used for either purpose.
This patch is adding a correct implementation for
mptscsih_dev_reset(), and renames the original function
to mptscsih_target_reset.
And sets the pointer corectly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/message/fusion/mptscsih.c | 55 ++++++++++++++++++++++++++++++++++++++-
 drivers/message/fusion/mptscsih.h |  1 +
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a426e89..da1c1e7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1792,7 +1792,7 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
+ *	mptscsih_dev_reset - Perform a SCSI LOGICAL_UNIT_RESET!
  *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
  *	(linux scsi_host_template.eh_dev_reset_handler routine)
@@ -1810,6 +1810,58 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
+		printk(KERN_ERR MYNAM ": lun reset: "
+		   "Can't locate host! (sc=%p)\n", SCpnt);
+		return FAILED;
+	}
+
+	ioc = hd->ioc;
+	printk(MYIOC_s_INFO_FMT "attempting lun reset! (sc=%p)\n",
+	       ioc->name, SCpnt);
+	scsi_print_command(SCpnt);
+
+	vdevice = SCpnt->device->hostdata;
+	if (!vdevice || !vdevice->vtarget) {
+		retval = 0;
+		goto out;
+	}
+
+	retval = mptscsih_IssueTaskMgmt(hd,
+				MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET,
+				vdevice->vtarget->channel,
+				vdevice->vtarget->id, vdevice->lun, 0,
+				mptscsih_get_tm_timeout(ioc));
+
+ out:
+	printk (MYIOC_s_INFO_FMT "lun reset: %s (sc=%p)\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+
+	if (retval == 0)
+		return SUCCESS;
+	else
+		return FAILED;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptscsih_target_reset - Perform a SCSI TARGET_RESET!
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
+ *
+ *	(linux scsi_host_template.eh_target_reset_handler routine)
+ *
+ *	Returns SUCCESS or FAILED.
+ **/
+int
+mptscsih_target_reset(struct scsi_cmnd * SCpnt)
+{
+	MPT_SCSI_HOST	*hd;
+	int		 retval;
+	VirtDevice	 *vdevice;
+	MPT_ADAPTER	*ioc;
+
+	/* If we can't locate our host adapter structure, return FAILED status.
+	 */
+	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
 		printk(KERN_ERR MYNAM ": target reset: "
 		   "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
@@ -3246,6 +3298,7 @@ struct device_attribute *mptscsih_host_attrs[] = {
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
+EXPORT_SYMBOL(mptscsih_target_reset);
 EXPORT_SYMBOL(mptscsih_bus_reset);
 EXPORT_SYMBOL(mptscsih_host_reset);
 EXPORT_SYMBOL(mptscsih_bios_param);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 6ab8254..50af52a 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -120,6 +120,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
-- 
1.8.5.6
