From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] [SCSI] sd: update kernel doc comments
Date: Tue,  2 Aug 2011 12:50:53 +0900
Message-ID: <1312257053-2522-3-git-send-email-namhyung@gmail.com>
References: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-scsi@vger.kernel.org

Fix a typo and update argument names.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/sd.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fbb522add124..496a4d9ca670 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -529,7 +529,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 /**
  * scsi_setup_discard_cmnd - unmap blocks on thinly provisioned device
- * @sdp: scsi device to operate one
+ * @sdp: scsi device to operate on
  * @rq: Request to prepare
  *
  * Will issue either UNMAP or WRITE SAME(16) depending on preference
@@ -635,8 +635,8 @@ static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
- *	@SCpnt: pointer to mid-level's per scsi command structure that
- *	contains request and into which the scsi command is written
+ *	@q: pointer to request queue structure
+ *	@rq: request to prepare
  *
  *	Returns 1 if successful and 0 if error (or cannot be done now).
  **/
@@ -890,17 +890,12 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 
 /**
  *	sd_open - open a scsi disk device
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
+ *	@bdev: block device to open
+ *	@mode: file open mode
  *
  *	Returns 0 if successful. Returns a negated errno value in case 
  *	of error.
  *
- *	Note: This can be called from a user context (e.g. fsck(1) )
- *	or from within the kernel (e.g. as a result of a mount(1) ).
- *	In the latter case @inode and @filp carry an abridged amount
- *	of information as noted above.
- *
  *	Locking: called with bdev->bd_mutex held.
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
@@ -973,8 +968,8 @@ error_autopm:
 /**
  *	sd_release - invoked when the (last) close(2) is called on this
  *	scsi disk.
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
+ *	@disk: generic disk structure
+ *	@mode: file open mode
  *
  *	Returns 0. 
  *
@@ -1031,8 +1026,8 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 /**
  *	sd_ioctl - process an ioctl
- *	@inode: only i_rdev/i_bdev members may be used
- *	@filp: only f_mode and f_flags may be used
+ *	@bdev: block device to process
+ *	@mode: file open mode
  *	@cmd: ioctl command number
  *	@arg: this is third argument given to ioctl(2) system call.
  *	Often contains a pointer.
@@ -2198,7 +2193,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 /**
  * sd_read_block_limits - Query disk device for preferred I/O sizes.
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
@@ -2264,7 +2259,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 /**
  * sd_read_block_characteristics - Query block dev. characteristics
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
@@ -2290,7 +2285,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 /**
  * sd_read_block_provisioning - Query provisioning VPD page
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 {
@@ -2629,7 +2624,7 @@ static int sd_probe(struct device *dev)
  *	sd_remove - called whenever a scsi disk (previously recognized by
  *	sd_probe) is detached from the system. It is called (potentially
  *	multiple times) during sd module unload.
- *	@sdp: pointer to mid level scsi device object
+ *	@dev: pointer to device object
  *
  *	Note: this function is invoked from the scsi mid-level.
  *	This function potentially frees up a device name (e.g. /dev/sdc)
-- 
1.7.6
