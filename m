From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 11/37] cxlflash: Refine host/device attributes
Date: Wed, 21 Oct 2015 15:12:39 -0500
Message-ID: <1445458359-33508-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:43747 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbbJUUOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:14:14 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:14:13 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 98A9138C8046
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:14:10 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKEACV61669468
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:14:10 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKE6OO028317
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:14:10 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Shane Seymour <shane.seymour@hp.com>, Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Implement the following suggestions and add two new attributes
to allow for debugging the port LUN table.

 - use scnprintf() instead of snprintf()
 - use DEVICE_ATTR_RO and DEVICE_ATTR_RW

Suggested-by: Shane Seymour <shane.seymour@hp.com>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 180 +++++++++++++++++++++++++++++++++----------
 1 file changed, 138 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 226cefe..b44212b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1995,33 +1995,24 @@ static int cxlflash_change_queue_depth(struct scsi_device *sdev, int qdepth)
 
 /**
  * cxlflash_show_port_status() - queries and presents the current port status
- * @dev:	Generic device associated with the host owning the port.
- * @attr:	Device attribute representing the port.
+ * @port:	Desired port for status reporting.
+ * @afu:	AFU owning the specified port.
  * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
  *
  * Return: The size of the ASCII string returned in @buf.
  */
-static ssize_t cxlflash_show_port_status(struct device *dev,
-					 struct device_attribute *attr,
-					 char *buf)
+static ssize_t cxlflash_show_port_status(u32 port, struct afu *afu, char *buf)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
-	struct afu *afu = cfg->afu;
-
 	char *disp_status;
-	int rc;
-	u32 port;
 	u64 status;
-	u64 *fc_regs;
+	__be64 __iomem *fc_regs;
 
-	rc = kstrtouint((attr->attr.name + 4), 10, &port);
-	if (rc || (port >= NUM_FC_PORTS))
+	if (port >= NUM_FC_PORTS)
 		return 0;
 
 	fc_regs = &afu->afu_map->global.fc_regs[port][0];
-	status =
-	    (readq_be(&fc_regs[FC_MTIP_STATUS / 8]) & FC_MTIP_STATUS_MASK);
+	status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	status &= FC_MTIP_STATUS_MASK;
 
 	if (status == FC_MTIP_STATUS_ONLINE)
 		disp_status = "online";
@@ -2030,31 +2021,69 @@ static ssize_t cxlflash_show_port_status(struct device *dev,
 	else
 		disp_status = "unknown";
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", disp_status);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", disp_status);
+}
+
+/**
+ * port0_show() - queries and presents the current status of port 0
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port0_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return cxlflash_show_port_status(0, afu, buf);
 }
 
 /**
- * cxlflash_show_lun_mode() - presents the current LUN mode of the host
+ * port1_show() - queries and presents the current status of port 1
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port1_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return cxlflash_show_port_status(1, afu, buf);
+}
+
+/**
+ * lun_mode_show() - presents the current LUN mode of the host
  * @dev:	Generic device associated with the host.
- * @attr:	Device attribute representing the lun mode.
+ * @attr:	Device attribute representing the LUN mode.
  * @buf:	Buffer of length PAGE_SIZE to report back the LUN mode in ASCII.
  *
  * Return: The size of the ASCII string returned in @buf.
  */
-static ssize_t cxlflash_show_lun_mode(struct device *dev,
-				      struct device_attribute *attr, char *buf)
+static ssize_t lun_mode_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
 	struct afu *afu = cfg->afu;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
 }
 
 /**
- * cxlflash_store_lun_mode() - sets the LUN mode of the host
+ * lun_mode_store() - sets the LUN mode of the host
  * @dev:	Generic device associated with the host.
- * @attr:	Device attribute representing the lun mode.
+ * @attr:	Device attribute representing the LUN mode.
  * @buf:	Buffer of length PAGE_SIZE containing the LUN mode in ASCII.
  * @count:	Length of data resizing in @buf.
  *
@@ -2073,9 +2102,9 @@ static ssize_t cxlflash_show_lun_mode(struct device *dev,
  *
  * Return: The size of the ASCII string returned in @buf.
  */
-static ssize_t cxlflash_store_lun_mode(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t count)
+static ssize_t lun_mode_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
@@ -2094,58 +2123,125 @@ static ssize_t cxlflash_store_lun_mode(struct device *dev,
 }
 
 /**
- * cxlflash_show_ioctl_version() - presents the hosts current ioctl version
+ * ioctl_version_show() - presents the current ioctl version of the host
  * @dev:	Generic device associated with the host.
  * @attr:	Device attribute representing the ioctl version.
  * @buf:	Buffer of length PAGE_SIZE to report back the ioctl version.
  *
  * Return: The size of the ASCII string returned in @buf.
  */
-static ssize_t cxlflash_show_ioctl_version(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
+static ssize_t ioctl_version_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%u\n", DK_CXLFLASH_VERSION_0);
 }
 
 /**
- * cxlflash_show_dev_mode() - presents the current mode of the device
+ * cxlflash_show_port_lun_table() - queries and presents the port LUN table
+ * @port:	Desired port for status reporting.
+ * @afu:	AFU owning the specified port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_port_lun_table(u32 port,
+					    struct afu *afu,
+					    char *buf)
+{
+	int i;
+	ssize_t bytes = 0;
+	__be64 __iomem *fc_port;
+
+	if (port >= NUM_FC_PORTS)
+		return 0;
+
+	fc_port = &afu->afu_map->global.fc_port[port][0];
+
+	for (i = 0; i < CXLFLASH_NUM_VLUNS; i++)
+		bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
+				   "%03d: %016llX\n", i, readq_be(&fc_port[i]));
+	return bytes;
+}
+
+/**
+ * port0_lun_table_show() - presents the current LUN table of port 0
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port0_lun_table_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return cxlflash_show_port_lun_table(0, afu, buf);
+}
+
+/**
+ * port1_lun_table_show() - presents the current LUN table of port 1
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port1_lun_table_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)shost->hostdata;
+	struct afu *afu = cfg->afu;
+
+	return cxlflash_show_port_lun_table(1, afu, buf);
+}
+
+/**
+ * mode_show() - presents the current mode of the device
  * @dev:	Generic device associated with the device.
  * @attr:	Device attribute representing the device mode.
  * @buf:	Buffer of length PAGE_SIZE to report back the dev mode in ASCII.
  *
  * Return: The size of the ASCII string returned in @buf.
  */
-static ssize_t cxlflash_show_dev_mode(struct device *dev,
-				      struct device_attribute *attr, char *buf)
+static ssize_t mode_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			sdev->hostdata ? "superpipe" : "legacy");
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+			 sdev->hostdata ? "superpipe" : "legacy");
 }
 
 /*
  * Host attributes
  */
-static DEVICE_ATTR(port0, S_IRUGO, cxlflash_show_port_status, NULL);
-static DEVICE_ATTR(port1, S_IRUGO, cxlflash_show_port_status, NULL);
-static DEVICE_ATTR(lun_mode, S_IRUGO | S_IWUSR, cxlflash_show_lun_mode,
-		   cxlflash_store_lun_mode);
-static DEVICE_ATTR(ioctl_version, S_IRUGO, cxlflash_show_ioctl_version, NULL);
+static DEVICE_ATTR_RO(port0);
+static DEVICE_ATTR_RO(port1);
+static DEVICE_ATTR_RW(lun_mode);
+static DEVICE_ATTR_RO(ioctl_version);
+static DEVICE_ATTR_RO(port0_lun_table);
+static DEVICE_ATTR_RO(port1_lun_table);
 
 static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port0,
 	&dev_attr_port1,
 	&dev_attr_lun_mode,
 	&dev_attr_ioctl_version,
+	&dev_attr_port0_lun_table,
+	&dev_attr_port1_lun_table,
 	NULL
 };
 
 /*
  * Device attributes
  */
-static DEVICE_ATTR(mode, S_IRUGO, cxlflash_show_dev_mode, NULL);
+static DEVICE_ATTR_RO(mode);
 
 static struct device_attribute *cxlflash_dev_attrs[] = {
 	&dev_attr_mode,
-- 
2.1.0

