From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: fix resource type update and add sdev and shost
 attributes
Date: Wed, 14 Jul 2010 10:50:14 -0700
Message-ID: <4C3DF8D6.5080906@linux.vnet.ibm.com>
References: <20100714174755.049189590@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34763 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0GNRug (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2010 13:50:36 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6EHk2ED009857
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2010 11:46:02 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6EHoRCt118028
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2010 11:50:27 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6EHoJ5X013315
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2010 11:50:20 -0600
In-Reply-To: <20100714174755.049189590@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

Setting the resource type in the ipr_update_res_entry function was incorrect in
that the top 4 bits were masked off.  The assignment has been updated to no
longer mask those bits.

Then, two new attributes were added to allow the user space utilities to more
easily get information.  The resource_type sdev attribute is set for all devices
in the adapter's configuration table and indicates the type of device.  The
fw_type shost attribute indicates the firmware type supported by the adapter.

Finally, the resource_path attribute was changed to be mode S_IRUGO.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-07-14 10:21:28.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-07-14 10:47:17.000000000 -0700
@@ -1168,7 +1168,7 @@ static void ipr_update_res_entry(struct 
 	if (res->ioa_cfg->sis64) {
 		res->flags = cfgtew->u.cfgte64->flags;
 		res->res_flags = cfgtew->u.cfgte64->res_flags;
-		res->type = cfgtew->u.cfgte64->res_type & 0x0f;
+		res->type = cfgtew->u.cfgte64->res_type;

 		memcpy(&res->std_inq_data, &cfgtew->u.cfgte64->std_inq_data,
 			sizeof(struct ipr_std_inq_data));
@@ -3761,6 +3761,36 @@ static struct device_attribute ipr_updat
 	.store = ipr_store_update_fw
 };

+/**
+ * ipr_show_fw_type - Show the adapter's firmware type.
+ * @dev:	class device struct
+ * @buf:	buffer
+ *
+ * Return value:
+ *	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_fw_type(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	unsigned long lock_flags = 0;
+	int len;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	len = snprintf(buf, PAGE_SIZE, "%d\n", ioa_cfg->sis64);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return len;
+}
+
+static struct device_attribute ipr_ioa_fw_type_attr = {
+	.attr = {
+		.name =		"fw_type",
+		.mode =		S_IRUGO,
+	},
+	.show = ipr_show_fw_type
+};
+
 static struct device_attribute *ipr_ioa_attrs[] = {
 	&ipr_fw_version_attr,
 	&ipr_log_level_attr,
@@ -3768,6 +3798,7 @@ static struct device_attribute *ipr_ioa_
 	&ipr_ioa_state_attr,
 	&ipr_ioa_reset_attr,
 	&ipr_update_fw_attr,
+	&ipr_ioa_fw_type_attr,
 	NULL,
 };

@@ -4119,14 +4150,49 @@ static ssize_t ipr_show_resource_path(st
 static struct device_attribute ipr_resource_path_attr = {
 	.attr = {
 		.name = 	"resource_path",
-		.mode =		S_IRUSR,
+		.mode =		S_IRUGO,
 	},
 	.show = ipr_show_resource_path
 };

+/**
+ * ipr_show_resource_type - Show the resource type for this device.
+ * @dev:	device struct
+ * @buf:	buffer
+ *
+ * Return value:
+ *	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_resource_type(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
+	struct ipr_resource_entry *res;
+	unsigned long lock_flags = 0;
+	ssize_t len = -ENXIO;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	res = (struct ipr_resource_entry *)sdev->hostdata;
+
+	if (res)
+		len = snprintf(buf, PAGE_SIZE, "%x\n", res->type);
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return len;
+}
+
+static struct device_attribute ipr_resource_type_attr = {
+	.attr = {
+		.name =		"resource_type",
+		.mode =		S_IRUGO,
+	},
+	.show = ipr_show_resource_type
+};
+
 static struct device_attribute *ipr_dev_attrs[] = {
 	&ipr_adapter_handle_attr,
 	&ipr_resource_path_attr,
+	&ipr_resource_type_attr,
 	NULL,
 };


