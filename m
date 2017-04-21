From: damien.lemoal@wdc.com
Subject: [PATCH 2/9] sd: Fix functions description
Date: Fri, 21 Apr 2017 18:16:42 +0900
Message-ID: <20170421091649.25287-3-damien.lemoal@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48820 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037284AbdDUJRW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 05:17:22 -0400
In-Reply-To: <20170421091649.25287-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

Use regular format comments documenting functions, fix argument names,
etc

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 272 +++++++++++++++++++++++++++---------------------------
 1 file changed, 136 insertions(+), 136 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index db362da..935ce34 100644
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
+ * Will set either UNMAP, WRITE SAME(10) or WRITE SAME(16) depending
+ * on preference indicated by target device.
  **/
 static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 {
@@ -827,7 +826,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
  * sd_setup_write_same_cmnd - write the same data to multiple blocks
  * @cmd: command to prepare
  *
- * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
+ * Will setup either WRITE SAME(10) or WRITE SAME(16) depending on
  * preference indicated by target device.
  **/
 static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
@@ -1189,20 +1188,18 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 }
 
 /**
- *	sd_open - open a scsi disk device
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
+ * sd_open - open a scsi disk device
+ * @bdev: Block device of the scsi disk to open
+ * @mode: FMODE_* mask
  *
- *	Returns 0 if successful. Returns a negated errno value in case
- *	of error.
+ * Returns 0 if successful. Returns a negated errno value in case
+ * of error.
  *
- *	Note: This can be called from a user context (e.g. fsck(1) )
- *	or from within the kernel (e.g. as a result of a mount(1) ).
- *	In the latter case @inode and @filp carry an abridged amount
- *	of information as noted above.
+ * Note: This can be called from a user context (e.g. fsck(1) )
+ * or from within the kernel (e.g. as a result of a mount(1) ).
  *
- *	Locking: called with bdev->bd_mutex held.
- **/
+ * Locking: called with bdev->bd_mutex held.
+ */
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
 	struct scsi_disk *sdkp = scsi_disk_get(bdev->bd_disk);
@@ -1265,18 +1262,16 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 }
 
 /**
- *	sd_release - invoked when the (last) close(2) is called on this
- *	scsi disk.
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
- *
- *	Returns 0.
+ * sd_release - invoked when the (last) close(2) is called on this
+ * scsi disk.
+ * @disk: disk to release
+ * @mode: FMODE_* mask
  *
- *	Note: may block (uninterruptible) if error recovery is underway
- *	on this disk.
+ * Note: may block (uninterruptible) if error recovery is underway
+ * on this disk.
  *
- *	Locking: called with bdev->bd_mutex held.
- **/
+ * Locking: called with bdev->bd_mutex held.
+ */
 static void sd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -1323,19 +1318,19 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 }
 
 /**
- *	sd_ioctl - process an ioctl
- *	@inode: only i_rdev/i_bdev members may be used
- *	@filp: only f_mode and f_flags may be used
- *	@cmd: ioctl command number
- *	@arg: this is third argument given to ioctl(2) system call.
- *	Often contains a pointer.
+ * sd_ioctl - process an ioctl
+ * @bdev: target block device
+ * @mode: FMODE_* mask
+ * @cmd: ioctl command number
+ * @arg: this is third argument given to ioctl(2) system call.
+ *       Often contains a pointer.
  *
- *	Returns 0 if successful (some ioctls return positive numbers on
- *	success as well). Returns a negated errno value in case of error.
+ * Returns 0 if successful (some ioctls return positive numbers on
+ * success as well). Returns a negated errno value in case of error.
  *
- *	Note: most ioctls are forward onto the block subsystem or further
- *	down in the scsi subsystem.
- **/
+ * Note: most ioctls are forward onto the block subsystem or further
+ * down in the scsi subsystem.
+ */
 static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -1415,14 +1410,14 @@ static int media_not_present(struct scsi_disk *sdkp,
 }
 
 /**
- *	sd_check_events - check media events
- *	@disk: kernel device descriptor
- *	@clearing: disk events currently being cleared
+ * sd_check_events - check media events
+ * @disk: kernel device descriptor
+ * @clearing: disk events currently being cleared
  *
- *	Returns mask of DISK_EVENT_*.
+ * Returns mask of DISK_EVENT_*.
  *
- *	Note: this function is invoked from the block subsystem.
- **/
+ * Note: this function is invoked from the block subsystem.
+ */
 static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct scsi_disk *sdkp = scsi_disk_get(disk);
@@ -1688,17 +1683,17 @@ static const struct block_device_operations sd_fops = {
 };
 
 /**
- *	sd_eh_reset - reset error handling callback
- *	@scmd:		sd-issued command that has failed
+ * sd_eh_reset - reset error handling callback
+ * @scmd: sd-issued command that has failed
  *
- *	This function is called by the SCSI midlayer before starting
- *	SCSI EH. When counting medium access failures we have to be
- *	careful to register it only only once per device and SCSI EH run;
- *	there might be several timed out commands which will cause the
- *	'max_medium_access_timeouts' counter to trigger after the first
- *	SCSI EH run already and set the device to offline.
- *	So this function resets the internal counter before starting SCSI EH.
- **/
+ * This function is called by the SCSI midlayer before starting
+ * SCSI EH. When counting medium access failures we have to be
+ * careful to register it only only once per device and SCSI EH run;
+ * there might be several timed out commands which will cause the
+ * 'max_medium_access_timeouts' counter to trigger after the first
+ * SCSI EH run already and set the device to offline.
+ * So this function resets the internal counter before starting SCSI EH.
+ */
 static void sd_eh_reset(struct scsi_cmnd *scmd)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
@@ -1708,17 +1703,17 @@ static void sd_eh_reset(struct scsi_cmnd *scmd)
 }
 
 /**
- *	sd_eh_action - error handling callback
- *	@scmd:		sd-issued command that has failed
- *	@eh_disp:	The recovery disposition suggested by the midlayer
+ * sd_eh_action - error handling callback
+ * @scmd: sd-issued command that has failed
+ * @eh_disp: The recovery disposition suggested by the midlayer
  *
- *	This function is called by the SCSI midlayer upon completion of an
- *	error test command (currently TEST UNIT READY). The result of sending
- *	the eh command is passed in eh_disp.  We're looking for devices that
- *	fail medium access commands but are OK with non access commands like
- *	test unit ready (so wrongly see the device as having a successful
- *	recovery)
- **/
+ * This function is called by the SCSI midlayer upon completion of an
+ * error test command (currently TEST UNIT READY). The result of sending
+ * the eh command is passed in eh_disp.  We're looking for devices that
+ * fail medium access commands but are OK with non access commands like
+ * test unit ready (so wrongly see the device as having a successful
+ * recovery)
+ */
 static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
@@ -1798,12 +1793,14 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 }
 
 /**
- *	sd_done - bottom half handler: called when the lower level
- *	driver has completed (successfully or otherwise) a scsi command.
- *	@SCpnt: mid-level's per command structure.
+ * sd_done - bottom half command completion handler
+ * @SCpnt: mid-level's per command structure.
  *
- *	Note: potentially run from within an ISR. Must not block.
- **/
+ * Called when the lower level driver has completed (successfully
+ * or otherwise) a scsi command.
+ *
+ * Note: potentially run from within an ISR. Must not block.
+ */
 static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
@@ -2713,7 +2710,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 /**
  * sd_read_block_limits - Query disk device for preferred I/O sizes.
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
@@ -2779,7 +2776,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 /**
  * sd_read_block_characteristics - Query block dev. characteristics
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
@@ -2827,7 +2824,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 /**
  * sd_read_block_provisioning - Query provisioning VPD page
- * @disk: disk to query
+ * @sdkp: disk to query
  */
 static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 {
@@ -2883,10 +2880,11 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 }
 
 /**
- *	sd_revalidate_disk - called the first time a new disk is seen,
- *	performs disk spin up, read_capacity, etc.
- *	@disk: struct gendisk we care about
- **/
+ * sd_revalidate_disk - called the first time a new disk is seen
+ * @disk: struct gendisk we care about
+ *
+ * Performs disk spin up, read_capacity, etc.
+ */
 static int sd_revalidate_disk(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -2978,16 +2976,16 @@ static int sd_revalidate_disk(struct gendisk *disk)
 }
 
 /**
- *	sd_unlock_native_capacity - unlock native capacity
- *	@disk: struct gendisk to set capacity for
+ * sd_unlock_native_capacity - unlock native capacity
+ * @disk: struct gendisk to set capacity for
  *
- *	Block layer calls this function if it detects that partitions
- *	on @disk reach beyond the end of the device.  If the SCSI host
- *	implements ->unlock_native_capacity() method, it's invoked to
- *	give it a chance to adjust the device capacity.
+ * Block layer calls this function if it detects that partitions
+ * on @disk reach beyond the end of the device.  If the SCSI host
+ * implements ->unlock_native_capacity() method, it's invoked to
+ * give it a chance to adjust the device capacity.
  *
- *	CONTEXT:
- *	Defined by block layer.  Might sleep.
+ * CONTEXT:
+ * Defined by block layer.  Might sleep.
  */
 static void sd_unlock_native_capacity(struct gendisk *disk)
 {
@@ -2998,26 +2996,26 @@ static void sd_unlock_native_capacity(struct gendisk *disk)
 }
 
 /**
- *	sd_format_disk_name - format disk name
- *	@prefix: name prefix - ie. "sd" for SCSI disks
- *	@index: index of the disk to format name for
- *	@buf: output buffer
- *	@buflen: length of the output buffer
+ * sd_format_disk_name - format disk name
+ * @prefix: name prefix - ie. "sd" for SCSI disks
+ * @index: index of the disk to format name for
+ * @buf: output buffer
+ * @buflen: length of the output buffer
  *
- *	SCSI disk names starts at sda.  The 26th device is sdz and the
- *	27th is sdaa.  The last one for two lettered suffix is sdzz
- *	which is followed by sdaaa.
+ * SCSI disk names starts at sda.  The 26th device is sdz and the
+ * 27th is sdaa.  The last one for two lettered suffix is sdzz
+ * which is followed by sdaaa.
  *
- *	This is basically 26 base counting with one extra 'nil' entry
- *	at the beginning from the second digit on and can be
- *	determined using similar method as 26 base conversion with the
- *	index shifted -1 after each digit is computed.
+ * This is basically 26 base counting with one extra 'nil' entry
+ * at the beginning from the second digit on and can be
+ * determined using similar method as 26 base conversion with the
+ * index shifted -1 after each digit is computed.
  *
- *	CONTEXT:
- *	Don't care.
+ * CONTEXT:
+ * Don't care.
  *
- *	RETURNS:
- *	0 on success, -errno on failure.
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
 static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 {
@@ -3101,23 +3099,23 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 }
 
 /**
- *	sd_probe - called during driver initialization and whenever a
- *	new scsi device is attached to the system. It is called once
- *	for each scsi device (not just disks) present.
- *	@dev: pointer to device object
+ * sd_probe - called during driver initialization and whenever a
+ * new scsi device is attached to the system. It is called once
+ * for each scsi device (not just disks) present.
+ * @dev: pointer to device object
  *
- *	Returns 0 if successful (or not interested in this scsi device
- *	(e.g. scanner)); 1 when there is an error.
+ * Returns 0 if successful (or not interested in this scsi device
+ * (e.g. scanner)); 1 when there is an error.
  *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function sets up the mapping between a given
- *	<host,channel,id,lun> (found in sdp) and new device name
- *	(e.g. /dev/sda). More precisely it is the block device major
- *	and minor number that is chosen here.
+ * Note: this function is invoked from the scsi mid-level.
+ * This function sets up the mapping between a given
+ * <host,channel,id,lun> (found in sdp) and new device name
+ * (e.g. /dev/sda). More precisely it is the block device major
+ * and minor number that is chosen here.
  *
- *	Assume sd_probe is not re-entrant (for time being)
- *	Also think about sd_probe() and sd_remove() running coincidentally.
- **/
+ * Assume sd_probe is not re-entrant (for time being)
+ * Also think about sd_probe() and sd_remove() running coincidentally.
+ */
 static int sd_probe(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
@@ -3216,16 +3214,18 @@ static int sd_probe(struct device *dev)
 }
 
 /**
- *	sd_remove - called whenever a scsi disk (previously recognized by
- *	sd_probe) is detached from the system. It is called (potentially
- *	multiple times) during sd module unload.
- *	@dev: pointer to device object
+ * sd_remove - called whenever a scsi disk is detached from the system
+ * @dev: pointer to device object
  *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function potentially frees up a device name (e.g. /dev/sdc)
- *	that could be re-used by a subsequent sd_probe().
- *	This function is not called when the built-in sd driver is "exit-ed".
- **/
+ * Called whenever a scsi disk (previously recognized by sd_probe) is
+ * detached from the system. It is called (potentially multiple times)
+ * during sd module unload.
+ *
+ * Note: this function is invoked from the scsi mid-level.
+ * This function potentially frees up a device name (e.g. /dev/sdc)
+ * that could be re-used by a subsequent sd_probe().
+ * This function is not called when the built-in sd driver is "exit-ed".
+ */
 static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
@@ -3255,14 +3255,14 @@ static int sd_remove(struct device *dev)
 }
 
 /**
- *	scsi_disk_release - Called to free the scsi_disk structure
- *	@dev: pointer to embedded class device
+ * scsi_disk_release - Called to free the scsi_disk structure
+ * @dev: pointer to embedded class device
  *
- *	sd_ref_mutex must be held entering this routine.  Because it is
- *	called on last put, you should always use the scsi_disk_get()
- *	scsi_disk_put() helpers which manipulate the semaphore directly
- *	and never do a direct put_device.
- **/
+ * sd_ref_mutex must be held entering this routine.  Because it is
+ * called on last put, you should always use the scsi_disk_get()
+ * scsi_disk_put() helpers which manipulate the semaphore directly
+ * and never do a direct put_device.
+ */
 static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
@@ -3396,11 +3396,11 @@ static int sd_resume(struct device *dev)
 }
 
 /**
- *	init_sd - entry point for this driver (both when built in or when
- *	a module).
+ * init_sd - entry point for this driver (both when built in or when
+ * a module).
  *
- *	Note: this function registers this driver with the scsi mid-level.
- **/
+ * Note: this function registers this driver with the scsi mid-level.
+ */
 static int __init init_sd(void)
 {
 	int majors = 0, i, err;
@@ -3458,10 +3458,10 @@ static int __init init_sd(void)
 }
 
 /**
- *	exit_sd - exit point for this driver (when it is a module).
+ * exit_sd - exit point for this driver (when it is a module).
  *
- *	Note: this function unregisters this driver from the scsi mid-level.
- **/
+ * Note: this function unregisters this driver from the scsi mid-level.
+ */
 static void __exit exit_sd(void)
 {
 	int i;
-- 
2.9.3
