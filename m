From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] sd: Optionally attach to ZBC devices
Date: Tue, 29 Jul 2014 16:45:17 +0200
Message-ID: <1406645117-53088-5-git-send-email-hare@suse.de>
References: <1406645117-53088-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1406645117-53088-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hsh@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

ZBC drives are close to disk devices, so sd.c is well
suited as a testbed for ZBC devices.
This patch introduces a module option 'attach_zbc' to
sd which will make the sd driver accept ZBC
devices as normal disk drives.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 377a520..f957a85 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -91,6 +91,13 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
+
+static bool sd_attach_zbc;
+
+module_param_named(attach_zbc, sd_attach_zbc, bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(attach_zbc,
+		  "Attach to ZBC devices (default=0)");
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
@@ -161,7 +168,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	static const char temp[] = "temporary ";
 	int len;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
 		 * can do it, but there's probably so many exceptions
 		 * it's not worth the risk */
@@ -259,7 +266,7 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
@@ -389,7 +396,7 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	if (!strncmp(buf, lbp_mode[SD_LBP_UNMAP], 20))
@@ -456,7 +463,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &max);
@@ -2537,7 +2544,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return;
 
 	if (sdkp->protection_type == 0)
@@ -2957,7 +2964,13 @@ static int sd_probe(struct device *dev)
 	int error;
 
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
+	if (sdp->type != TYPE_DISK &&
+	    sdp->type != TYPE_MOD &&
+	    sdp->type != TYPE_RBC &&
+	    sdp->type != TYPE_ZBC)
+		goto out;
+
+	if (sdp->type == TYPE_ZBC && !sd_attach_zbc)
 		goto out;
 
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
-- 
1.7.12.4

