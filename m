From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Another updated patch for aacraid sysfs files
Date: Wed, 01 Jun 2005 10:24:38 -0700
Message-ID: <1117646678.7578.2.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:8607 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261484AbVFARYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 13:24:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

James,
The update patch that I sent last week applied to the original sysfs
patch that was in the scsi-misc-2.6 tree.  I see that it was removed.
Here is a patch that should apply to the current scsi-misc-2.6 tree.
--

This patch adds some files into the /sys/class/scsi_host/hostN
directories for aacraid adapters:

model
vendor
hba_kernel_version
hba_monitor_version
hba_bios_version
serial_number

Signed-off-by: Mark Haverkamp <markh@osdl.org>

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -533,6 +533,134 @@ static long aac_compat_cfg_ioctl(struct 
 }
 #endif
 
+static ssize_t aac_show_model(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%s\n",
+		  aac_drivers[dev->cardtype].model);
+	return len;
+}
+
+static ssize_t aac_show_vendor(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%s\n",
+		  aac_drivers[dev->cardtype].vname);
+	return len;
+}
+
+static ssize_t aac_show_kernel_version(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len, tmp;
+
+	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
+	len = snprintf(buf, PAGE_SIZE, "%d.%d-%d[%d]\n", 
+	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
+	  le32_to_cpu(dev->adapter_info.kernelbuild));
+	return len;
+}
+
+static ssize_t aac_show_monitor_version(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len, tmp;
+
+	tmp = le32_to_cpu(dev->adapter_info.monitorrev);
+	len = snprintf(buf, PAGE_SIZE, "%d.%d-%d[%d]\n", 
+	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
+	  le32_to_cpu(dev->adapter_info.monitorbuild));
+	return len;
+}
+
+static ssize_t aac_show_bios_version(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len, tmp;
+
+	tmp = le32_to_cpu(dev->adapter_info.biosrev);
+	len = snprintf(buf, PAGE_SIZE, "%d.%d-%d[%d]\n", 
+	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
+	  le32_to_cpu(dev->adapter_info.biosbuild));
+	return len;
+}
+
+static ssize_t aac_show_serial_number(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len = 0;
+
+	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
+		len = snprintf(buf, PAGE_SIZE, "%x\n",
+		  le32_to_cpu(dev->adapter_info.serial[0]));
+	return len;
+}
+
+
+static struct class_device_attribute aac_model = {
+	.attr = {
+		.name = "model",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_model,
+};
+static struct class_device_attribute aac_vendor = {
+	.attr = {
+		.name = "vendor",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_vendor,
+};
+static struct class_device_attribute aac_kernel_version = {
+	.attr = {
+		.name = "hba_kernel_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_kernel_version,
+};
+static struct class_device_attribute aac_monitor_version = {
+	.attr = {
+		.name = "hba_monitor_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_monitor_version,
+};
+static struct class_device_attribute aac_bios_version = {
+	.attr = {
+		.name = "hba_bios_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_bios_version,
+};
+static struct class_device_attribute aac_serial_number = {
+	.attr = {
+		.name = "serial_number",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_serial_number,
+};
+
+static struct class_device_attribute *aac_attrs[] = {
+	&aac_model,
+	&aac_vendor,
+	&aac_kernel_version,
+	&aac_monitor_version,
+	&aac_bios_version,
+	&aac_serial_number,
+	NULL
+};
+
+
 static struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= aac_cfg_ioctl,
@@ -553,6 +681,7 @@ static struct scsi_host_template aac_dri
 #endif
 	.queuecommand   		= aac_queuecommand,
 	.bios_param     		= aac_biosparm,	
+	.shost_attrs			= aac_attrs,
 	.slave_configure		= aac_slave_configure,
 	.eh_abort_handler		= aac_eh_abort,
 	.eh_host_reset_handler		= aac_eh_reset,


-- 
Mark Haverkamp <markh@osdl.org>

