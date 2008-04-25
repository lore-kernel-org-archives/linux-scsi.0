From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 13 of 16] Support for SCSI disk (SBC) Data Integrity Field
Date: Fri, 25 Apr 2008 19:12:15 -0400
Message-ID: <b912d7bb3c47dbbefd1c.1209165135@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44320 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760703AbYDYXRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:30 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2 files changed, 53 insertions(+), 7 deletions(-)
drivers/scsi/sd.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++-------
include/scsi/sd.h |    2 +


Configure DMA of protection information and issue READ/WRITE commands
with RDPROTECT/WRPROTECT set accordingly.

Force READ CAPACITY(16) if the target has the PROTECT bit set and grab
an extra byte of response (P_TYPE and PROT_EN are in byte 12).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 5262eba570f4 -r b912d7bb3c47 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/sd.c	Fri Apr 25 17:39:29 2008 -0400
@@ -59,6 +59,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/sd.h>
+#include <scsi/scsi_dif.h>
 
 #include "scsi_logging.h"
 
@@ -233,6 +234,24 @@
 	return snprintf(buf, 40, "%d\n", sdkp->device->allow_restart);
 }
 
+static ssize_t
+sd_show_protection_type(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->protection_type);
+}
+
+static ssize_t
+sd_show_app_tag_own(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->ATO);
+}
+
 static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(cache_type, S_IRUGO|S_IWUSR, sd_show_cache_type,
 	       sd_store_cache_type),
@@ -241,6 +260,8 @@
 	       sd_store_allow_restart),
 	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
 	       sd_store_manage_start_stop),
+	__ATTR(protection_type, S_IRUGO, sd_show_protection_type, NULL),
+	__ATTR(app_tag_own, S_IRUGO, sd_show_app_tag_own, NULL),
 	__ATTR_NULL,
 };
 
@@ -353,6 +374,7 @@
 	struct scsi_cmnd *SCpnt;
 	struct scsi_device *sdp = q->queuedata;
 	struct gendisk *disk = rq->rq_disk;
+	struct scsi_disk *sdkp;
 	sector_t block = rq->sector;
 	unsigned int this_count = rq->nr_sectors;
 	unsigned int timeout = sdp->timeout;
@@ -369,6 +391,7 @@
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
+	sdkp = scsi_disk(disk);
 
 	/* from here on until we're complete, any goto out
 	 * is used for a killable error condition */
@@ -458,6 +481,11 @@
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
+
+		if (blk_integrity_rq(rq) && 
+		    scsi_dif_prepare(rq, block, sdp->sector_size) == -EIO)
+			goto out;
+
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
@@ -472,8 +500,11 @@
 					"writing" : "reading", this_count,
 					rq->nr_sectors));
 
-	SCpnt->cmnd[1] = 0;
-	
+	if (scsi_host_dif_type(sdp->host, sdkp->protection_type))
+		SCpnt->cmnd[1] = 1 << 5;
+	else
+		SCpnt->cmnd[1] = 0;
+
 	if (block > 0xffffffff) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
@@ -491,6 +522,7 @@
 		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
 		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
+		   SCpnt->device->protection ||
 		   SCpnt->device->use_10_for_rw) {
 		if (this_count > 0xffff)
 			this_count = 0xffff;
@@ -516,6 +548,8 @@
 				    "FUA write on READ/WRITE(6) drive\n");
 			goto out;
 		}
+
+		BUG_ON(sdkp->protection_type);
 
 		SCpnt->cmnd[1] |= (unsigned char) ((block >> 16) & 0x1f);
 		SCpnt->cmnd[2] = (unsigned char) ((block >> 8) & 0xff);
@@ -1005,7 +1039,8 @@
 		good_bytes = xfer_size;
 		break;
 	case ILLEGAL_REQUEST:
-		if (SCpnt->device->use_10_for_rw &&
+		if (SCpnt->device->protection == 0 &&
+		    SCpnt->device->use_10_for_rw &&
 		    (SCpnt->cmnd[0] == READ_10 ||
 		     SCpnt->cmnd[0] == WRITE_10))
 			SCpnt->device->use_10_for_rw = 0;
@@ -1018,6 +1053,9 @@
 		break;
 	}
  out:
+	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
+		scsi_dif_complete(SCpnt, good_bytes);
+
 	return good_bytes;
 }
 
@@ -1172,7 +1210,8 @@
 	unsigned char cmd[16];
 	int the_result, retries;
 	int sector_size = 0;
-	int longrc = 0;
+	/* Force READ CAPACITY(16) when PROTECT=1 */
+	int longrc = sdkp->device->protection ? 1 : 0;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
@@ -1184,8 +1223,8 @@
 			memset((void *) cmd, 0, 16);
 			cmd[0] = SERVICE_ACTION_IN;
 			cmd[1] = SAI_READ_CAPACITY_16;
-			cmd[13] = 12;
-			memset((void *) buffer, 0, 12);
+			cmd[13] = 13;
+			memset((void *) buffer, 0, 13);
 		} else {
 			cmd[0] = READ_CAPACITY;
 			memset((void *) &cmd[1], 0, 9);
@@ -1193,7 +1232,7 @@
 		}
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					      buffer, longrc ? 12 : 8, &sshdr,
+					      buffer, longrc ? 13 : 8, &sshdr,
 					      SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (media_not_present(sdkp, &sshdr))
@@ -1268,6 +1307,8 @@
 			
 		sector_size = (buffer[8] << 24) |
 			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
+
+		scsi_dif_config_disk(sdkp, buffer);
 	}	
 
 	/* Some devices return the total number of sectors, not the
@@ -1565,6 +1606,7 @@
 	sdkp->write_prot = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
+	sdkp->ATO = 0;
 
 	sd_spinup_disk(sdkp);
 
@@ -1576,6 +1618,7 @@
 		sd_read_capacity(sdkp, buffer);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
+		scsi_dif_app_tag_own(sdkp, buffer);
 	}
 
 	/*
@@ -1709,6 +1752,7 @@
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	scsi_dif_config_host(sdkp);
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
diff -r 5262eba570f4 -r b912d7bb3c47 include/scsi/sd.h
--- a/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
@@ -43,7 +43,9 @@
 	u32		index;
 	u8		media_present;
 	u8		write_prot;
+	u8		protection_type;/* Data Integrity Field */
 	unsigned	previous_state : 1;
+	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */


