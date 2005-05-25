From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Update to aacraid sysfs files
Date: Wed, 25 May 2005 13:01:20 -0700
Message-ID: <1117051281.27283.11.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:61128 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261544AbVEYUBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 16:01:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch addresses Christoph's comments about prefixes.  Also, I've
removed the driver version file since there is a patch submitted by Matt
Domsch to address that.

Patch applies to the latest scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -533,26 +533,25 @@ static long aac_compat_cfg_ioctl(struct 
 }
 #endif
 
-static ssize_t aac_show_host_version(struct class_device *class_dev,
+static ssize_t aac_show_model(struct class_device *class_dev,
 		char *buf)
 {
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "Adaptec Raid Controller: %s %s\n",
-		  AAC_DRIVER_VERSION,
-		  AAC_DRIVER_BUILD_DATE);
+	len = snprintf(buf, PAGE_SIZE, "%s\n",
+		  aac_drivers[dev->cardtype].model);
 	return len;
 }
 
-static ssize_t aac_show_model(struct class_device *class_dev,
+static ssize_t aac_show_vendor(struct class_device *class_dev,
 		char *buf)
 {
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "Vendor: %s Model: %s\n",
-		  aac_drivers[dev->cardtype].vname,
-		  aac_drivers[dev->cardtype].model);
+	len = snprintf(buf, PAGE_SIZE, "%s\n",
+		  aac_drivers[dev->cardtype].vname);
 	return len;
 }
 
@@ -563,7 +562,7 @@ static ssize_t aac_show_kernel_version(s
 	int len, tmp;
 
 	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
-	len = snprintf(buf, PAGE_SIZE, "kernel: %d.%d-%d[%d]\n", 
+	len = snprintf(buf, PAGE_SIZE, "%d.%d-%d[%d]\n", 
 	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
 	  le32_to_cpu(dev->adapter_info.kernelbuild));
 	return len;
@@ -576,7 +575,7 @@ static ssize_t aac_show_monitor_version(
 	int len, tmp;
 
 	tmp = le32_to_cpu(dev->adapter_info.monitorrev);
-	len = snprintf(buf, PAGE_SIZE, "monitor: %d.%d-%d[%d]\n", 
+	len = snprintf(buf, PAGE_SIZE, "%d.%d-%d[%d]\n", 
 	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
 	  le32_to_cpu(dev->adapter_info.monitorbuild));
 	return len;
@@ -589,7 +588,7 @@ static ssize_t aac_show_bios_version(str
 	int len, tmp;
 
 	tmp = le32_to_cpu(dev->adapter_info.biosrev);
-	len = snprintf(buf, PAGE_SIZE, "bios: %d.%d-%d[%d]\n", 
+	len = snprintf(buf, PAGE_SIZE, "%d.%d-%d[%d]\n", 
 	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
 	  le32_to_cpu(dev->adapter_info.biosbuild));
 	return len;
@@ -602,58 +601,58 @@ static ssize_t aac_show_serial_number(st
 	int len = 0;
 
 	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
-		len = snprintf(buf, PAGE_SIZE, "serial: %x\n",
+		len = snprintf(buf, PAGE_SIZE, "%x\n",
 		  le32_to_cpu(dev->adapter_info.serial[0]));
 	return len;
 }
 
 
-static struct class_device_attribute aac_host_version = {
+static struct class_device_attribute aac_model = {
 	.attr = {
-		.name = "aac_driver_version",
+		.name = "model",
 		.mode = S_IRUGO,
 	},
-	.show = aac_show_host_version,
+	.show = aac_show_model,
 };
-static struct class_device_attribute aac_model = {
+static struct class_device_attribute aac_vendor = {
 	.attr = {
-		.name = "aac_model",
+		.name = "vendor",
 		.mode = S_IRUGO,
 	},
-	.show = aac_show_model,
+	.show = aac_show_vendor,
 };
 static struct class_device_attribute aac_kernel_version = {
 	.attr = {
-		.name = "aac_kernel_version",
+		.name = "hba_kernel_version",
 		.mode = S_IRUGO,
 	},
 	.show = aac_show_kernel_version,
 };
 static struct class_device_attribute aac_monitor_version = {
 	.attr = {
-		.name = "aac_monitor_version",
+		.name = "hba_monitor_version",
 		.mode = S_IRUGO,
 	},
 	.show = aac_show_monitor_version,
 };
 static struct class_device_attribute aac_bios_version = {
 	.attr = {
-		.name = "aac_bios_version",
+		.name = "hba_bios_version",
 		.mode = S_IRUGO,
 	},
 	.show = aac_show_bios_version,
 };
 static struct class_device_attribute aac_serial_number = {
 	.attr = {
-		.name = "aac_serial_number",
+		.name = "serial_number",
 		.mode = S_IRUGO,
 	},
 	.show = aac_show_serial_number,
 };
 
 static struct class_device_attribute *aac_attrs[] = {
-	&aac_host_version,
 	&aac_model,
+	&aac_vendor,
 	&aac_kernel_version,
 	&aac_monitor_version,
 	&aac_bios_version,


-- 
Mark Haverkamp <markh@osdl.org>

