From: damien.lemoal@wdc.com
Subject: [PATCH v2 1/7] sd: Fix functions description
Date: Mon, 24 Apr 2017 16:51:09 +0900
Message-ID: <20170424075115.30337-2-damien.lemoal@wdc.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:21848 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166246AbdDXHvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 03:51:32 -0400
In-Reply-To: <20170424075115.30337-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

Fix argument names and description of functions documentation comments.
No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 00b168b..ce62d2c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -705,11 +705,10 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 /**
  * sd_setup_discard_cmnd - unmap blocks on thinly provisioned device
- * @sdp: scsi device to operate on
- * @rq: Request to prepare
+ * @cmd: command to prepare
  *
- * Will issue either UNMAP or WRITE SAME(16) depending on preference
- * indicated by target device.
+ * Will setup either UNMAP, WRITE SAME(16) or WRITE SAME(10) depending
+ * on the provisioning mode of the target device.
  **/
 static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 {
@@ -827,8 +826,8 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
  * sd_setup_write_same_cmnd - write the same data to multiple blocks
  * @cmd: command to prepare
  *
- * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
- * preference indicated by target device.
+ * Will setup either WRITE SAME(10) or WRITE SAME(16) depending on
+ * the preference indicated by the target device.
  **/
 static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 {
@@ -1190,8 +1189,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 
 /**
  *	sd_open - open a scsi disk device
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
+ *	@bdev: Block device of the scsi disk to open
+ *	@mode: FMODE_* mask
  *
  *	Returns 0 if successful. Returns a negated errno value in case 
  *	of error.
@@ -1267,8 +1266,8 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 /**
  *	sd_release - invoked when the (last) close(2) is called on this
  *	scsi disk.
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
+ *	@disk: disk to release
+ *	@mode: FMODE_* mask
  *
  *	Returns 0. 
  *
@@ -1324,8 +1323,8 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 /**
  *	sd_ioctl - process an ioctl
- *	@inode: only i_rdev/i_bdev members may be used
- *	@filp: only f_mode and f_flags may be used
+ *	@bdev: target block device
+ *	@mode: FMODE_* mask
  *	@cmd: ioctl command number
  *	@arg: this is third argument given to ioctl(2) system call.
  *	Often contains a pointer.
@@ -2713,7 +2712,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 /**
  * sd_read_block_limits - Query disk device for preferred I/O sizes.
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
@@ -2779,7 +2778,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 /**
  * sd_read_block_characteristics - Query block dev. characteristics
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
@@ -2827,7 +2826,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 /**
  * sd_read_block_provisioning - Query provisioning VPD page
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 {
-- 
2.9.3
