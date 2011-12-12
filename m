From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal routine fails
Date: Mon, 12 Dec 2011 16:48:42 +0530
Message-ID: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47057 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1LLLNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2011 06:13:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>

It has been observed that a number of USB HDD's do not respond correctly
to SCSI mode sense command(retrieve caching pages) which results in their
Write Cache being discarded by queue requests i.e., WCE if left set to
'0'(disabled).
This results in a number of Filesystem corruptions, when the device
is unplugged abruptly.

So, in order to identify the devices correctly - give it
a last try using ATA_16 after failure from normal routine.
Introduce a mechanism to store write-cache type using /sys/class/
interface, so that the normal code continues to function without errors.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Signed-off-by: Nam-Jae Jeon <namjae.jeon@samsung.com>
---
 drivers/scsi/sd.c          |   49 +++++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h        |   32 ++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |    2 +
 3 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..5227d65 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -124,7 +124,7 @@ static mempool_t *sd_cdb_pool;
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
-	"write back, no read (daft)"
+	"write back, no read (daft)", "write back(ata cmd)"
 };
 
 static ssize_t
@@ -156,8 +156,15 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	}
 	if (ct < 0)
 		return -EINVAL;
+
+	if (ct & 0x04) {
+		sdp->use_ata_cmd = 1;
+		goto revalidate_disk;
+	}
+
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
+
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
 			    SD_MAX_RETRIES, &data, NULL))
 		return -EINVAL;
@@ -175,6 +182,8 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
+
+revalidate_disk:
 	revalidate_disk(sdkp->disk);
 	return count;
 }
@@ -2029,11 +2038,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int old_wce = sdkp->WCE;
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
+	unsigned char cdb[ATA_16_LEN] = {0};
 
 	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
 			goto defaults;
+		else if (sdp->use_ata_cmd) {
+			goto WCE_USING_ATA;
+		}
 		else {
 			if (sdp->skip_ms_page_3f)
 				goto defaults;
@@ -2142,6 +2155,39 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			sdkp->DPOFUA = 0;
 		}
 
+WCE_USING_ATA:
+		if (!sdp->removable && (sdp->use_ata_cmd && !sdkp->WCE)) {
+			sd_printk(KERN_NOTICE, sdkp, "Try to check write cache "
+				"enable/disable using ATA command\n");
+			cdb[0] = ATA_16;
+			/* Packet command, Programmed I/O -
+			 * PIO - Indicates Data in */
+			cdb[1] = ATA_PROTO_PIO_IN;
+			/* Data read sectors from device */
+			cdb[2] = CDB2_TLEN_NSECT |
+				 CDB2_TLEN_SECTORS | CDB2_TDIR_FROM_DEV;
+			cdb[6] = 0x01; /* No. of Sectors To Read */
+			cdb[13] = ATA_USING_LBA;
+			cdb[14] = ATA_OP_IDENTIFY;
+
+			sdkp->WCE = 0;
+			sdkp->RCD = 0;
+			sdkp->DPOFUA = 0;
+
+			if (!scsi_execute_req(sdp, cdb, DMA_FROM_DEVICE,
+				buffer,	SD_BUF_SIZE, &sshdr, SD_TIMEOUT,
+				SD_MAX_RETRIES, NULL)) {
+				/*
+				 * '6th' Bit in Word 85 Corresponds to
+				 * Write Cache being Enabled/disabled,
+				 * Word 85 represnets the features supported
+				 */
+				if (le16_to_cpu(
+					((unsigned short *)buffer)[85]) & 0x20)
+					sdkp->WCE = 1;
+			}
+		}
+
 		if (sdkp->first_scan || old_wce != sdkp->WCE ||
 		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
 			sd_printk(KERN_NOTICE, sdkp,
@@ -2515,6 +2561,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sdkp->RCD = 0;
 	sdkp->ATO = 0;
 	sdkp->first_scan = 1;
+	sdp->use_ata_cmd = 0;
 
 	sd_revalidate_disk(gd);
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8001ae4..9e44805 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -181,6 +181,38 @@ struct scsi_cmnd;
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
 #define	ATA_12		      0xa1	/* 12-byte pass-thru */
 
+#define ATA_16_LEN     16
+#define ATA_OP_IDENTIFY        0xec /* Command to Identify device*/
+
+#define ATA_LBA48            1
+#define ATA_PROTO_NON_DATA   (3 << 1)
+#define ATA_PROTO_PIO_IN     (4 << 1)
+#define ATA_PROTO_PIO_OUT    (5 << 1)
+#define ATA_PROTO_DMA        (6 << 1)
+
+/*
+ * Some useful ATA register bits
+ */
+enum {
+	ATA_USING_LBA   =       (1 << 6),
+	ATA_STAT_DRQ    =       (1 << 3),
+	ATA_STAT_ERR    =       (1 << 0),
+};
+
+enum {
+	CDB2_TLEN_NODATA     = 0 << 0,
+	CDB2_TLEN_FEAT       = 1 << 0,
+	CDB2_TLEN_NSECT      = 2 << 0,
+
+	CDB2_TLEN_BYTES      = 0 << 2,
+	CDB2_TLEN_SECTORS    = 1 << 2,
+
+	CDB2_TDIR_TO_DEV     = 0 << 3,
+	CDB2_TDIR_FROM_DEV   = 1 << 3,
+
+	CDB2_CHECK_COND      = 1 << 5,
+};
+
 /*
  *	SCSI command lengths
  */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5591ed5..edfa981 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -151,6 +151,8 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned use_ata_cmd; /* device which do not responed to normal routine,
+			       * try ATA_16 command on them. */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.2.3

