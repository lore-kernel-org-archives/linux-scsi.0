From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Sun,  4 Jun 2017 14:42:25 +0200
Message-ID: <20170604124225.27032-7-hch@lst.de>
References: <20170604124225.27032-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Just wire up the generic TCG OPAL infrastructure to the SCSI disk driver
and the Security In/Out commands.

Note that I don't know of any actual SCSI disks that do support TCG OPAL,
but this is required to support ATA disks through libata.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  2 ++
 2 files changed, 46 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b6bb4e0ce0e3..782f909a223c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/sed-opal.h>
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
 #include <linux/t10-pi.h>
@@ -643,6 +644,26 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
+#ifdef CONFIG_BLK_SED_OPAL
+static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
+		size_t len, bool send)
+{
+	struct scsi_device *sdev = data;
+	u8 cdb[12] = { 0, };
+	int ret;
+
+	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
+	cdb[1] = secp;
+	put_unaligned_be16(spsp, &cdb[2]);
+	put_unaligned_be32(len, &cdb[6]);
+
+	ret = scsi_execute_req(sdev, cdb,
+			send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
+			buffer, len, NULL, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+	return ret <= 0 ? ret : -EIO;
+}
+#endif /* CONFIG_BLK_SED_OPAL */
+
 static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
@@ -1454,6 +1475,9 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	if (error)
 		goto out;
 
+	if (is_sed_ioctl(cmd))
+		return sed_ioctl(sdkp->opal_dev, cmd, p);
+
 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
 	 * ioctls to block level and then onto mid level if they can't be
@@ -3014,6 +3038,17 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->ws10 = 1;
 }
 
+static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	struct scsi_device *sdev = sdkp->device;
+
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
+			SECURITY_PROTOCOL_IN) == 1 &&
+	    scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
+			SECURITY_PROTOCOL_OUT) == 1)
+		sdkp->security = 1;
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3067,6 +3102,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
+		sd_read_security(sdkp, buffer);
 	}
 
 	sdkp->first_scan = 0;
@@ -3227,6 +3263,12 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_revalidate_disk(gd);
 
+	if (sdkp->security) {
+		sdkp->opal_dev = init_opal_dev(sdp, &sd_sec_submit);
+		if (sdkp->opal_dev)
+			sd_printk(KERN_NOTICE, sdkp, "supports TCG Opal\n");
+	}
+
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 	scsi_autopm_put_device(sdp);
@@ -3376,6 +3418,8 @@ static int sd_remove(struct device *dev)
 
 	sd_zbc_remove(sdkp);
 
+	free_opal_dev(sdkp->opal_dev);
+
 	blk_register_region(devt, SD_MINORS, NULL,
 			    sd_default_probe, NULL, NULL);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 61d02efd366c..99c4dde9b6bf 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -71,6 +71,7 @@ struct scsi_disk {
 	struct scsi_device *device;
 	struct device	dev;
 	struct gendisk	*disk;
+	struct opal_dev *opal_dev;
 #ifdef CONFIG_BLK_DEV_ZONED
 	unsigned int	nr_zones;
 	unsigned int	zone_blocks;
@@ -114,6 +115,7 @@ struct scsi_disk {
 	unsigned	rc_basis: 2;
 	unsigned	zoned: 2;
 	unsigned	urswrz : 1;
+	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
-- 
2.11.0
