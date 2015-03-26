From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ipr: AF DASD raw mode implementation in ipr driver
Date: Thu, 26 Mar 2015 11:23:58 -0500
Message-ID: <201503261623.t2QGNxP3021634@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:40947 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbbCZQYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 12:24:05 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 26 Mar 2015 10:24:04 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 8935019D803F
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 10:15:07 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2QGO7BA49348676
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 09:24:07 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2QGO0Qv021694
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 10:24:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

This patch implements raw mode support for AF DASD in ipr driver
which allows for tools to send commands directly to physical
devices which are members of RAID arrays when enabled in the firmware.

Signed-off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ipr.h |    3 +
 2 files changed, 88 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sispipe drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_sispipe	2015-03-26 10:53:55.540578199 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 10:57:00.570080498 -0500
@@ -498,6 +498,10 @@ struct ipr_error_table_t ipr_error_table
 	"4061: Multipath redundancy level got better"},
 	{0x066B9200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4060: Multipath redundancy level got worse"},
+	{0x06808100, 0, IPR_DEFAULT_LOG_LEVEL,
+	"9083: Device raw mode enabled"},
+	{0x06808200, 0, IPR_DEFAULT_LOG_LEVEL,
+	"9084: Device raw mode disabled"},
 	{0x07270000, 0, 0,
 	"Failure due to other device"},
 	{0x07278000, 0, IPR_DEFAULT_LOG_LEVEL,
@@ -4496,11 +4500,83 @@ static struct device_attribute ipr_resou
 	.show = ipr_show_resource_type
 };
 
+/**
+ * ipr_show_raw_mode - Show the adapter's raw mode
+ * @dev:	class device struct
+ * @buf:	buffer
+ *
+ * Return value:
+ * 	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_raw_mode(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
+	struct ipr_resource_entry *res;
+	unsigned long lock_flags = 0;
+	ssize_t len;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	res = (struct ipr_resource_entry *)sdev->hostdata;
+	if (res)
+		len = snprintf(buf, PAGE_SIZE, "%d\n", res->raw_mode);
+	else
+		len = -ENXIO;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return len;
+}
+
+/**
+ * ipr_store_raw_mode - Change the adapter's raw mode
+ * @dev:	class device struct
+ * @buf:	buffer
+ *
+ * Return value:
+ * 	number of bytes printed to buffer
+ **/
+static ssize_t ipr_store_raw_mode(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
+	struct ipr_resource_entry *res;
+	unsigned long lock_flags = 0;
+	ssize_t len;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	res = (struct ipr_resource_entry *)sdev->hostdata;
+	if (res) {
+		if (ioa_cfg->sis64 && ipr_is_af_dasd_device(res)) {
+			res->raw_mode = simple_strtoul(buf, NULL, 10);
+			len = strlen(buf);
+			if (res->sdev)
+				sdev_printk(KERN_INFO, res->sdev, "raw mode is %s\n",
+					res->raw_mode ? "enabled" : "disabled");
+		} else
+			len = -EINVAL;
+	} else
+		len = -ENXIO;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return len;
+}
+
+static struct device_attribute ipr_raw_mode_attr = {
+	.attr = {
+		.name =		"raw_mode",
+		.mode =		S_IRUGO | S_IWUSR,
+	},
+	.show = ipr_show_raw_mode,
+	.store = ipr_store_raw_mode
+};
+
 static struct device_attribute *ipr_dev_attrs[] = {
 	&ipr_adapter_handle_attr,
 	&ipr_resource_path_attr,
 	&ipr_device_id_attr,
 	&ipr_resource_type_attr,
+	&ipr_raw_mode_attr,
 	NULL,
 };
 
@@ -6152,6 +6228,13 @@ static void ipr_erp_start(struct ipr_ioa
 		break;
 	case IPR_IOASC_NR_INIT_CMD_REQUIRED:
 		break;
+	case IPR_IOASC_IR_NON_OPTIMIZED:
+		if (res->raw_mode){
+			res->raw_mode = 0;
+			scsi_cmd->result |= (DID_IMM_RETRY << 16);
+		} else
+			scsi_cmd->result |= (DID_ERROR << 16);
+		break;
 	default:
 		if (IPR_IOASC_SENSE_KEY(ioasc) > RECOVERED_ERROR)
 			scsi_cmd->result |= (DID_ERROR << 16);
@@ -6291,6 +6374,8 @@ static int ipr_queuecommand(struct Scsi_
 	    (!ipr_is_gscsi(res) || scsi_cmd->cmnd[0] == IPR_QUERY_RSRC_STATE)) {
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
 	}
+	if (res->raw_mode && ipr_is_af_dasd_device(res))
+		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_PIPE;
 
 	if (ioa_cfg->sis64)
 		rc = ipr_build_ioadl64(ioa_cfg, ipr_cmd);
diff -puN drivers/scsi/ipr.h~ipr_sispipe drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_sispipe	2015-03-26 10:53:58.572559060 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-03-26 10:54:19.108429114 -0500
@@ -138,6 +138,7 @@
 #define IPR_IOASC_BUS_WAS_RESET			0x06290000
 #define IPR_IOASC_BUS_WAS_RESET_BY_OTHER		0x06298000
 #define IPR_IOASC_ABORTED_CMD_TERM_BY_HOST	0x0B5A0000
+#define IPR_IOASC_IR_NON_OPTIMIZED		0x05258200
 
 #define IPR_FIRST_DRIVER_IOASC			0x10000000
 #define IPR_IOASC_IOA_WAS_RESET			0x10000001
@@ -521,6 +522,7 @@ struct ipr_cmd_pkt {
 #define IPR_RQTYPE_IOACMD		0x01
 #define IPR_RQTYPE_HCAM			0x02
 #define IPR_RQTYPE_ATA_PASSTHRU	0x04
+#define IPR_RQTYPE_PIPE			0x05
 
 	u8 reserved2;
 
@@ -1274,6 +1276,7 @@ struct ipr_resource_entry {
 	u8 del_from_ml:1;
 	u8 resetting_device:1;
 	u8 reset_occurred:1;
+	u8 raw_mode:1;
 
 	u32 bus;		/* AKA channel */
 	u32 target;		/* AKA id */
_

