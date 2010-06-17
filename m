From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/17] mpt2sas: Added sysfs counter for ioc reset
Date: Thu, 17 Jun 2010 13:36:53 +0530
Message-ID: <20100617080645.GG28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:38042 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756059Ab0FQIm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:42:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Added a new sysfs shost attribute called ioc_reset_count. This will
keep count of host resets (both diagnostic and message unit).

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d978c8a..e298303 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3402,6 +3402,7 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
     enum reset_type type)
 {
 	u32 ioc_state;
+	int rc;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
@@ -3430,11 +3431,15 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
 		if (!(_base_send_ioc_reset(ioc,
-		    MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET, 15, CAN_SLEEP)))
+		    MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET, 15, CAN_SLEEP))) {
+			ioc->ioc_reset_count++;
 			return 0;
+	}
 
  issue_diag_reset:
-	return _base_diag_reset(ioc, CAN_SLEEP);
+	rc = _base_diag_reset(ioc, CAN_SLEEP);
+	ioc->ioc_reset_count++;
+	return rc;
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index d950e7d..ad277f3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -615,6 +615,7 @@ struct MPT2SAS_ADAPTER {
 	u16		msix_vector_count;
 	u32		*msix_table;
 	u32		*msix_table_backup;
+	u32		ioc_reset_count;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index d88e975..53857c0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2581,6 +2581,29 @@ _ctl_fwfault_debug_store(struct device *cdev,
 static DEVICE_ATTR(fwfault_debug, S_IRUGO | S_IWUSR,
     _ctl_fwfault_debug_show, _ctl_fwfault_debug_store);
 
+
+/**
+ * _ctl_ioc_reset_count_show - ioc reset count
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * This is firmware queue depth limit
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t
+_ctl_ioc_reset_count_show(struct device *cdev, struct device_attribute *attr,
+    char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%08d\n", ioc->ioc_reset_count);
+}
+static DEVICE_ATTR(ioc_reset_count, S_IRUGO,
+    _ctl_ioc_reset_count_show, NULL);
+
+
 struct device_attribute *mpt2sas_host_attrs[] = {
 	&dev_attr_version_fw,
 	&dev_attr_version_bios,
@@ -2597,6 +2620,7 @@ struct device_attribute *mpt2sas_host_attrs[] = {
 	&dev_attr_fwfault_debug,
 	&dev_attr_fw_queue_depth,
 	&dev_attr_host_sas_address,
+	&dev_attr_ioc_reset_count,
 	NULL,
 };
 
