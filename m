From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] scsi: move the writeable from struct scsi_device to struct scsi_cd
Date: Fri, 18 Jul 2014 17:17:18 +0200
Message-ID: <1405696638-23770-4-git-send-email-hch@lst.de>
References: <1405696638-23770-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761838AbaGRPPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 11:15:08 -0400
In-Reply-To: <1405696638-23770-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>

We currently set the field in common code based on the device type,
but then only use it in the cdrom driver which also overrides the
value previously set in the generic code.

Just leave this entirely to the CDROM driver to make everyones life
simpler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c   | 24 ------------------------
 drivers/scsi/sd.c          |  3 ---
 drivers/scsi/sr.c          |  4 ++--
 drivers/scsi/sr.h          |  1 +
 include/scsi/scsi_device.h |  1 -
 5 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b91cfaf..a5a0bde 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -807,30 +807,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->removable = (inq_result[1] & 0x80) >> 7;
 	}
 
-	switch (sdev->type) {
-	case TYPE_RBC:
-	case TYPE_TAPE:
-	case TYPE_DISK:
-	case TYPE_PRINTER:
-	case TYPE_MOD:
-	case TYPE_PROCESSOR:
-	case TYPE_SCANNER:
-	case TYPE_MEDIUM_CHANGER:
-	case TYPE_ENCLOSURE:
-	case TYPE_COMM:
-	case TYPE_RAID:
-	case TYPE_OSD:
-		sdev->writeable = 1;
-		break;
-	case TYPE_ROM:
-	case TYPE_WORM:
-		sdev->writeable = 0;
-		break;
-	default:
-		sdev_printk(KERN_INFO, sdev, "unknown device type %d\n",
-			    sdev->type);
-	}
-
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
 		/* RBC and MMC devices can return SCSI-3 compliance and yet
 		 * still not support REPORT LUNS, so make them act as
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3663e38..377a520 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -992,9 +992,6 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		}
 	}
 	if (rq_data_dir(rq) == WRITE) {
-		if (!sdp->writeable) {
-			goto out;
-		}
 		SCpnt->cmnd[0] = WRITE_6;
 
 		if (blk_integrity_rq(rq))
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cce4771..7eeb936 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -435,7 +435,7 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 	}
 
 	if (rq_data_dir(rq) == WRITE) {
-		if (!cd->device->writeable)
+		if (!cd->writeable)
 			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
 		cd->cdi.media_written = 1;
@@ -927,7 +927,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	 */
 	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
 			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
-		cd->device->writeable = 1;
+		cd->writeable = 1;
 	}
 
 	kfree(buffer);
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 5334e98..1d1f6f4 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -36,6 +36,7 @@ typedef struct scsi_cd {
 	struct scsi_device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
 	unsigned long ms_offset;	/* for reading multisession-CD's        */
+	unsigned writeable : 1;
 	unsigned use:1;		/* is this device still supportable     */
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0f853f2..b895784 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -127,7 +127,6 @@ struct scsi_device {
 				 * pass settings from slave_alloc to scsi
 				 * core. */
 	unsigned int eh_timeout; /* Error handling timeout */
-	unsigned writeable:1;
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
-- 
1.9.1

