From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] scsi: sd: Separate zeroout and discard command choices
Date: Wed,  5 Apr 2017 07:41:10 -0400
Message-ID: <20170405114111.26864-1-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23400 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbdDELlW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 07:41:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>

Now that zeroout and discards are distinct operations we need to
separate the policy of choosing the appropriate command. Create a
zeroing_mode which can be one of:

write:			Zeroout assist not present, use regular WRITE
writesame:		Allow WRITE SAME(10/16) with a zeroed payload
writesame_16_unmap:	Allow WRITE SAME(16) with UNMAP
writesame_10_unmap:	Allow WRITE SAME(10) with UNMAP

The last two are conditional on the device being thin provisioned with
LBPRZ=1 and LBPWS=1 or LBPWS10=1 respectively.

Whether to set the UNMAP bit or not depends on the REQ_NOUNMAP flag. And
if none of the _unmap variants are supported, regular WRITE SAME will be
used if the device supports it.

The zeroout_mode is exported in sysfs and the detected mode for a given
device can be overridden using the string constants above.

With this change in place we can now issue WRITE SAME(16) with UNMAP set
for block zeroing applications that require hard guarantees and
logical_block_size granularity. And at the same time use the UNMAP
command with the device's preferred granulary and alignment for discard
operations.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/sd.h |  8 ++++++++
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bcb0cb020fd2..acf9d17b05d8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -418,6 +418,46 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(provisioning_mode);
 
+static const char *zeroing_mode[] = {
+	[SD_ZERO_WRITE]		= "write",
+	[SD_ZERO_WS]		= "writesame",
+	[SD_ZERO_WS16_UNMAP]	= "writesame_16_unmap",
+	[SD_ZERO_WS10_UNMAP]	= "writesame_10_unmap",
+};
+
+static ssize_t
+zeroing_mode_show(struct device *dev, struct device_attribute *attr,
+		  char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%s\n", zeroing_mode[sdkp->zeroing_mode]);
+}
+
+static ssize_t
+zeroing_mode_store(struct device *dev, struct device_attribute *attr,
+		   const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE], 20))
+		sdkp->zeroing_mode = SD_ZERO_WRITE;
+	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS], 20))
+		sdkp->zeroing_mode = SD_ZERO_WS;
+	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP], 20))
+		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
+	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP], 20))
+		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
+	else
+		return -EINVAL;
+
+	return count;
+}
+static DEVICE_ATTR_RW(zeroing_mode);
+
 static ssize_t
 max_medium_access_timeouts_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -496,6 +536,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_app_tag_own.attr,
 	&dev_attr_thin_provisioning.attr,
 	&dev_attr_provisioning_mode.attr,
+	&dev_attr_zeroing_mode.attr,
 	&dev_attr_max_write_same_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
 	NULL,
@@ -799,10 +840,10 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
-		switch (sdkp->provisioning_mode) {
-		case SD_LBP_WS16:
+		switch (sdkp->zeroing_mode) {
+		case SD_ZERO_WS16_UNMAP:
 			return sd_setup_write_same16_cmnd(cmd, true);
-		case SD_LBP_WS10:
+		case SD_ZERO_WS10_UNMAP:
 			return sd_setup_write_same10_cmnd(cmd, true);
 		}
 	}
@@ -840,6 +881,15 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 		sdkp->max_ws_blocks = 0;
 	}
 
+	if (sdkp->lbprz && sdkp->lbpws)
+		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
+	else if (sdkp->lbprz && sdkp->lbpws10)
+		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
+	else if (sdkp->max_ws_blocks)
+		sdkp->zeroing_mode = SD_ZERO_WS;
+	else
+		sdkp->zeroing_mode = SD_ZERO_WRITE;
+
 out:
 	blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks *
 					 (logical_block_size >> 9));
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e96a75..a2c4b5c35379 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -59,6 +59,13 @@ enum {
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
 };
 
+enum {
+	SD_ZERO_WRITE = 0,	/* Use WRITE(10/16) command */
+	SD_ZERO_WS,		/* Use WRITE SAME(10/16) command */
+	SD_ZERO_WS16_UNMAP,	/* Use WRITE SAME(16) with UNMAP */
+	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
+};
+
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
@@ -89,6 +96,7 @@ struct scsi_disk {
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
+	u8		zeroing_mode;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.12.0
