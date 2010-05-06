From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 5/7] scsi: megaraid_sas - Add input parameter for
 max_sectors
Date: Thu, 6 May 2010 10:17:01 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3CDB80C1A@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39459 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932293Ab0EFQRU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2010 12:17:20 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

Driver add the input parameters support for max_sectors for our gen2 chip.  Customer can
Set the max_sectors support to 1MB for gen2 chip during the driver load.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
megaraid_sas.h |    1
 2 files changed, 75 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-05-03 05:50:40.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-05-03 09:55:58.000000000 -0400
@@ -57,6 +57,15 @@ module_param_named(poll_mode_io, poll_mo
 MODULE_PARM_DESC(poll_mode_io,
 	"Complete cmds from IO path, (default=0)");
 
+/*
+ * Number of sectors per IO command
+ * Will be set in megasas_init_mfi if user does not provide
+ */
+static unsigned int max_sectors = 0;
+module_param_named(max_sectors, max_sectors, int, 0);
+MODULE_PARM_DESC(max_sectors,
+	"Maximum number of sectors per IO command");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -3566,6 +3575,32 @@ static int megasas_start_aen(struct mega
 				    class_locale.word);
 }
 
+static ssize_t
+sysfs_max_sectors_read(struct kobject *kobj, struct bin_attribute *bin_attr, 
+			char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	
+	struct Scsi_Host *host = class_to_shost(dev);
+
+	struct megasas_instance *instance = 
+				(struct megasas_instance *)host->hostdata;
+
+	count = sprintf(buf,"%u\n", instance->max_sectors_per_req);
+
+	return count+1;
+}
+
+static struct bin_attribute sysfs_max_sectors_attr = {
+	.attr = {
+		.name = "max_sectors",
+		.mode = S_IRUSR|S_IRGRP|S_IROTH,
+		.owner = THIS_MODULE,
+	},
+	.size = 7,
+	.read = sysfs_max_sectors_read,
+};
+
 /**
  * megasas_io_attach -	Attaches this driver to SCSI mid-layer
  * @instance:		Adapter soft state
@@ -3573,6 +3608,7 @@ static int megasas_start_aen(struct mega
 static int megasas_io_attach(struct megasas_instance *instance)
 {
 	struct Scsi_Host *host = instance->host;
+	u32		error;
 
 	/*
 	 * Export parameters required by SCSI mid-layer
@@ -3588,6 +3624,27 @@ static int megasas_io_attach(struct mega
 			instance->max_fw_cmds - MEGASAS_INT_CMDS;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
+	/*
+	 * Check if the module parameter value for max_sectors can be used
+	 */
+	if (max_sectors && max_sectors < instance->max_sectors_per_req)
+		instance->max_sectors_per_req = max_sectors;
+	else {
+		if (max_sectors) {
+			if (((instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
+				(instance->pdev->device == 
+				PCI_DEVICE_ID_LSI_SAS0079GEN2)) && 
+				(max_sectors <= MEGASAS_MAX_SECTORS)) {
+					instance->max_sectors_per_req = max_sectors;
+			} else {
+				printk(KERN_INFO "megasas: max_sectors should be > 0 and"
+			 		"<= %d (or < 1MB for GEN2 controller)\n",
+					instance->max_sectors_per_req);
+			}
+		}
+	}
+
 	host->max_sectors = instance->max_sectors_per_req;
 	host->cmd_per_lun = 128;
 	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
@@ -3604,10 +3661,27 @@ static int megasas_io_attach(struct mega
 	}
 
 	/*
+	 * Create sysfs entries for module paramaters
+	 */
+	error = sysfs_create_bin_file(&instance->host->shost_dev.kobj,
+			&sysfs_max_sectors_attr);
+	
+	if (error) {
+		printk(KERN_INFO "megasas: Error in creating the sysfs entry"
+				" max_sectors.\n");
+		goto out_remove_host;
+	}
+
+	/*
 	 * Trigger SCSI to scan our drives
 	 */
 	scsi_scan_host(host);
 	return 0;
+
+out_remove_host:
+        scsi_remove_host(host);
+        return error;
+
 }
 
 static int
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-05-03 05:50:40.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-05-03 09:56:08.000000000 -0400
@@ -706,6 +706,7 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 
+#define MEGASAS_MAX_SECTORS                    (2*1024)
 #define MEGASAS_DBG_LVL				1
 
 #define MEGASAS_FW_BUSY				1
