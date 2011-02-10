From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/06] mptfusion: (New Feature)Added new sysfs parameters for handle and firmware id
Date: Thu, 10 Feb 2011 11:49:43 +0530
Message-ID: <20110210061934.GB31424@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43267 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab1BJHGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 02:06:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

New feature is added.  sas_device_hanlde and firmware id will be visible from 
sysfs parameters. handle and firmware id is internal to LSI firmware.
It is merely debugging purpose.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index f71f229..0f3e8fd 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -399,6 +399,7 @@ typedef struct _VirtTarget {
 	u8			 inDMD;		/* currently in the device
 						   removal delay timer */
 	u32			 num_luns;
+	u16     		 handle;
 } VirtTarget;
 
 typedef struct _VirtDevice {
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d48c2c6..482e97f 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1758,6 +1758,7 @@ mptsas_target_alloc(struct scsi_target *starget)
 			id = p->phy_info[i].attached.id;
 			channel = p->phy_info[i].attached.channel;
 			mptsas_set_starget(&p->phy_info[i], starget);
+			vtarget->handle = p->phy_info[i].attached.handle;
 
 			/*
 			 * Exposing hidden raid components
@@ -1983,6 +1984,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
+	.sdev_attrs			= mptscsih_dev_attrs,
 };
 
 static int mptsas_get_linkerrors(struct sas_phy *phy)
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..07946aa 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -3333,7 +3333,66 @@ struct device_attribute *mptscsih_host_attrs[] = {
 	NULL,
 };
 
+/* device attributes */
+
+
+/**
+ * mptscsih_device_handle_show - device handle
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * This is the firmware assigned device handle
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t
+mptscsih_device_handle_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	VirtDevice *vdevice = sdev->hostdata;
+
+	if (vdevice && vdevice->vtarget)
+		return snprintf(buf, PAGE_SIZE, "0x%04x\n",
+		    vdevice->vtarget->handle);
+	else
+		return snprintf(buf, PAGE_SIZE, "0x0\n");
+}
+static DEVICE_ATTR(sas_device_handle, S_IRUGO, mptscsih_device_handle_show,
+ 		NULL);
+/**
+ * mptscsih_fw_id_show - device handle
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * This is the firmware assigned id.
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t
+mptscsih_device_fw_id_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	VirtDevice *vdevice = sdev->hostdata;
+
+	if (vdevice && vdevice->vtarget)
+		return snprintf(buf, PAGE_SIZE, "0x%04x\n",
+		    vdevice->vtarget->id);
+	else
+		return snprintf(buf, PAGE_SIZE, "0x0\n");
+}
+static DEVICE_ATTR(fw_id, S_IRUGO, mptscsih_device_fw_id_show,
+ 		NULL);
+
+struct device_attribute *mptscsih_dev_attrs[] = {
+	&dev_attr_sas_device_handle,
+	&dev_attr_fw_id,
+	NULL,
+};
+
 EXPORT_SYMBOL(mptscsih_host_attrs);
+EXPORT_SYMBOL(mptscsih_dev_attrs);
 
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 45a5ff3..d9839ca 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -133,5 +133,6 @@ extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth,
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
+extern struct device_attribute *mptscsih_dev_attrs[];
 extern struct scsi_cmnd	*mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
