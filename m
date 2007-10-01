From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors,
	cmd_per_lun
Date: Mon, 01 Oct 2007 11:51:48 -0400
Message-ID: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60310 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXJCUea (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 16:34:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

Adding module parameters to configure max sectors per request & # of cmds per lun.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   68 ++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    2
 2 files changed, 68 insertions(+), 2 deletions(-)

diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 00:14:29.000000000 -0700
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 02:15:16.000000000 -0700
@@ -62,6 +62,23 @@ MODULE_PARM_DESC(fast_load,
 	"megasas: Faster loading of the driver, skips physical devices! "\
 	"(default = 0)");
 
+/*
+ * Number of sectors per IO command will be set in megasas_init_mfi
+ * if user does not provide
+ */
+static unsigned int max_sectors;
+module_param_named(max_sectors, max_sectors, int, 0);
+MODULE_PARM_DESC(max_sectors,
+	"Maximum number of sectors per IO command");
+
+/*
+ * Number of cmds per logical unit
+ */
+static unsigned int cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
+module_param_named(cmd_per_lun, cmd_per_lun, int, 0);
+MODULE_PARM_DESC(cmd_per_lun,
+	"Maximum number of commands per logical unit (default=128)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -1148,6 +1165,24 @@ static int megasas_slave_alloc(struct sc
 	return 0;
 }
 
+static ssize_t
+megasas_sysfs_max_sectors_read(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct megasas_instance *instance =
+				(struct megasas_instance *)shost->hostdata;
+
+	return snprintf(buf, 8, "%u\n", instance->max_sectors_per_req);
+}
+
+CLASS_DEVICE_ATTR(max_sectors, S_IRUGO, megasas_sysfs_max_sectors_read,
+		NULL);
+
+static struct class_device_attribute *megasas_shost_attrs[] = {
+	&class_device_attr_max_sectors,
+	NULL,
+};
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -1165,6 +1200,7 @@ static struct scsi_host_template megasas
 	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = megasas_shost_attrs,
 };
 
 /**
@@ -2310,15 +2346,43 @@ static int megasas_io_attach(struct mega
 	struct Scsi_Host *host = instance->host;
 
 	/*
-	 * Export parameters required by SCSI mid-layer
+	 * Export host parameters required by SCSI
+	 * mid-layer
 	 */
 	host->irq = instance->pdev->irq;
 	host->unique_id = instance->unique_id;
 	host->can_queue = instance->max_fw_cmds - MEGASAS_INT_CMDS;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
+
+	/*
+	 * Check if the module parameter value for max_sectors can be used
+	 */
+	if (max_sectors && max_sectors <= instance->max_sectors_per_req)
+		instance->max_sectors_per_req = max_sectors;
+	else if (max_sectors) {
+		printk(KERN_INFO
+			"megasas: max_sectors should be > 0 and <= %d\n",
+			instance->max_sectors_per_req);
+	}
+
 	host->max_sectors = instance->max_sectors_per_req;
-	host->cmd_per_lun = 128;
+
+	/*
+	 * Check if the module parameter value for cmd_per_lun can be used
+	 */
+	instance->cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
+	if (cmd_per_lun && cmd_per_lun <= MEGASAS_DEFAULT_CMD_PER_LUN)
+		instance->cmd_per_lun = cmd_per_lun;
+	else
+		printk(KERN_INFO "megasas: cmd_per_lun should be > 0 and "
+			"<= %d\n", MEGASAS_DEFAULT_CMD_PER_LUN);
+
+	host->cmd_per_lun = instance->cmd_per_lun;
+
+	printk(KERN_DEBUG "megasas: max_sectors : 0x%x, cmd_per_lun : 0x%x\n",
+			instance->max_sectors_per_req, instance->cmd_per_lun);
+
 	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
 	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
 	host->max_lun = MEGASAS_MAX_LUN;
diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-10-01 00:03:59.000000000 -0700
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-10-01 00:03:59.000000000 -0700
@@ -537,6 +537,7 @@ struct megasas_ctrl_info {
 #define MEGASAS_DEFAULT_INIT_ID			-1
 #define MEGASAS_MAX_LUN				8
 #define MEGASAS_MAX_LD				64
+#define MEGASAS_DEFAULT_CMD_PER_LUN		128
 
 #define MEGASAS_DBG_LVL				1
 
@@ -1080,6 +1081,7 @@ struct megasas_instance {
 	u16 max_num_sge;
 	u16 max_fw_cmds;
 	u32 max_sectors_per_req;
+	u32 cmd_per_lun;
 
 	struct megasas_cmd **cmd_list;
 	struct list_head cmd_pool;


