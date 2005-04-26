From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter
	information access
Date: Tue, 26 Apr 2005 13:31:07 -0700
Message-ID: <1114547467.14717.14.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:2237 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261644AbVDZUbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2005 16:31:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Re-send of recent patch diffed against the scsi-misc-2.6 git tree.


This patch adds some files into the /sys/class/scsi_host/hostN
directories for aacraid adapters.  The file names are pretty much self-
explanitory:

aac_driver_version: Driver version and date
aac_bios_version: Adapter's bios version
aac_kernel_version: Adapter's kernel version
aac_monitor_version: Adapter's monitor version
aac_model: Adapter's model name/number
aac_serial_number: Adapter's serial number

This is information that used to be supplied by the /proc interface.

Signed-off-by: Mark Haverkamp <markh@osdl.org>


diff -Nru -X scsi-misc-2.6/Documentation/dontdiff -x .git scsi-misc-2.6/drivers/scsi/aacraid/linit.c scsi-misc-work/drivers/scsi/aacraid/linit.c
--- scsi-misc-2.6/drivers/scsi/aacraid/linit.c	2005-04-26 11:24:01.000000000 -0700
+++ scsi-misc-work/drivers/scsi/aacraid/linit.c	2005-04-26 12:55:48.000000000 -0700
@@ -524,8 +524,137 @@
 {
 	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
 }
+
 #endif
 
+static ssize_t aac_show_host_version(struct class_device *class_dev,
+		char *buf)
+{
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "Adaptec Raid Controller: %s %s\n",
+		  AAC_DRIVER_VERSION,
+		  AAC_DRIVER_BUILD_DATE);
+	return len;
+}
+
+static ssize_t aac_show_model(struct class_device *class_dev,
+		char *buf)
+{
+	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "Vendor: %s Model: %s\n",
+		  aac_drivers[dev->cardtype].vname,
+		  aac_drivers[dev->cardtype].model);
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
+	len = snprintf(buf, PAGE_SIZE, "kernel: %d.%d-%d[%d]\n", 
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
+	len = snprintf(buf, PAGE_SIZE, "monitor: %d.%d-%d[%d]\n", 
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
+	len = snprintf(buf, PAGE_SIZE, "bios: %d.%d-%d[%d]\n", 
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
+		len = snprintf(buf, PAGE_SIZE, "serial: %x\n",
+		  le32_to_cpu(dev->adapter_info.serial[0]));
+	return len;
+}
+
+
+static struct class_device_attribute aac_host_version = {
+	.attr = {
+		.name = "aac_driver_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_host_version,
+};
+static struct class_device_attribute aac_model = {
+	.attr = {
+		.name = "aac_model",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_model,
+};
+static struct class_device_attribute aac_kernel_version = {
+	.attr = {
+		.name = "aac_kernel_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_kernel_version,
+};
+static struct class_device_attribute aac_monitor_version = {
+	.attr = {
+		.name = "aac_monitor_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_monitor_version,
+};
+static struct class_device_attribute aac_bios_version = {
+	.attr = {
+		.name = "aac_bios_version",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_bios_version,
+};
+static struct class_device_attribute aac_serial_number = {
+	.attr = {
+		.name = "aac_serial_number",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_serial_number,
+};
+
+static struct class_device_attribute *aac_attrs[] = {
+	&aac_host_version,
+	&aac_model,
+	&aac_kernel_version,
+	&aac_monitor_version,
+	&aac_bios_version,
+	&aac_serial_number,
+	NULL
+};
+
 static struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= aac_cfg_ioctl,
@@ -538,7 +667,7 @@
 static struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name           		= "AAC",
-	.proc_name			= "aacraid",
+	.proc_name			= AAC_DRIVERNAME,
 	.info           		= aac_info,
 	.ioctl          		= aac_ioctl,
 #ifdef CONFIG_COMPAT
@@ -546,6 +675,7 @@
 #endif
 	.queuecommand   		= aac_queuecommand,
 	.bios_param     		= aac_biosparm,	
+	.shost_attrs			= aac_attrs,
 	.slave_configure		= aac_slave_configure,
 	.eh_abort_handler		= aac_eh_abort,
 	.eh_host_reset_handler		= aac_eh_reset,

-- 
Mark Haverkamp <markh@osdl.org>

