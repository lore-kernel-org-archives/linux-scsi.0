From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/2] scsi: retrieve cache mode using ATA_16 cmd if normal routine fails
Date: Thu, 16 Feb 2012 12:22:21 +0530
Message-ID: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

It has been observed that a number of USB HDD's do not respond correctly
to SCSI mode sense command(retrieve caching pages) which results in their
Write Cache being discarded by queue requests i.e., WCE if left set to
'0'(disabled).
This results in a number of Filesystem corruptions, when the device
is unplugged abruptly.

So, in order to identify the devices correctly - give it
a last try using ATA_16 cmd after failure from normal routine.

Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 drivers/ata/libata-scsi.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c         |   18 ++++++++++++++++++
 include/linux/libata.h    |    1 +
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 508a60b..218df4f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -561,6 +561,45 @@ error:
 	return rc;
 }
 
+int ata_get_cachestatus(struct scsi_device *scsidev)
+{
+	int rc = 0;
+	u8 scsi_cmd[MAX_COMMAND_SIZE] = {0};
+	u8 *sensebuf = NULL, *argbuf = NULL;
+	enum dma_data_direction data_dir;
+	int cmd_result;
+	sensebuf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+	if (!sensebuf)
+		return rc;
+
+	argbuf = kzalloc(ATA_SECT_SIZE, GFP_KERNEL);
+	if (!argbuf)
+		goto error;
+
+	scsi_cmd[0] = ATA_16;
+	scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
+	scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
+				block count in sector count field */
+	data_dir = DMA_FROM_DEVICE;
+	scsi_cmd[14] = ATA_CMD_ID_ATA;
+
+	if (!scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, ATA_SECT_SIZE,
+					sensebuf, (10*HZ), 5, 0, NULL)) {
+		/*
+		 * 6th Bit in Word 85 Corresponds to Write Cache
+		 * being Enabled/disabled, Word 85 represnets the
+		 * features supported
+		 */
+		 if (le16_to_cpu(((unsigned short *)argbuf)[85]) & 0x20)
+			rc = 1;
+	}
+
+error:
+	kfree(sensebuf);
+	kfree(argbuf);
+	return rc;
+}
+
 /**
  *	ata_task_ioctl - Handler for HDIO_DRIVE_TASK ioctl
  *	@scsidev: Device to which we are issuing command
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..3ca507a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,11 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+
+#ifdef CONFIG_ATA
+#include <linux/libata.h>
+#endif
+
 #include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
@@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		if (modepage == 0x3F) {
 			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
 				  "present\n");
+#ifdef CONFIG_ATA
+			goto WCE_USING_ATA;
+#else
 			goto defaults;
+#endif
 		} else if ((buffer[offset] & 0x3f) != modepage) {
 			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
 			goto defaults;
@@ -2149,6 +2158,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA = 0;
 		}
+#ifdef CONFIG_ATA
+WCE_USING_ATA:
+		if (!sdp->removable && !sdkp->WCE) {
+			sd_printk(KERN_NOTICE, sdkp, "Try to check write cache"
+				" enable/disable using ATA command\n");
+			sdkp->WCE = ata_get_cachestatus(sdp);
+		}
+#endif
+
 
 		if (sdkp->first_scan || old_wce != sdkp->WCE ||
 		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index cafc09a..20c5c33 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -990,6 +990,7 @@ extern void ata_host_init(struct ata_host *, struct device *,
 			  unsigned long, struct ata_port_operations *);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
+extern int ata_get_cachestatus(struct scsi_device *scsidev);
 extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 			    int cmd, void __user *arg);
-- 
1.7.2.3

