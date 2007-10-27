From: Rob Landley <rob@landley.net>
Subject: [PATCH 1/15] Update kerneldoc comments in drivers/scsi/scsi.c
Date: Fri, 26 Oct 2007 23:07:14 -0500
Message-ID: <200710262307.14873.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47464
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750972AbXJ0DHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:07:30 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 58E9A73938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:10:14 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi.c |  195 +++++++++++++++++++++---------------------
 1 file changed, 102 insertions(+), 93 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi.c	Fri Oct 26 22:44:42 2007 -0500
@@ -122,6 +122,11 @@ static const char *const scsi_device_typ
 	"Automation/Drive ",
 };
 
+/**
+ * scsi_device_type - Return 17 char string indicating device type.
+ * @type: type number to look up
+ */
+
 const char * scsi_device_type(unsigned type)
 {
 	if (type == 0x1e)
@@ -156,6 +161,14 @@ static struct scsi_host_cmd_pool scsi_cm
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
+/**
+ * __scsi_get_command - Allocate a struct scsi_cmnd
+ * @shost: host to transmit command
+ * @gfp_mask: allocation mask
+ *
+ * Description: allocate a struct scsi_cmd from host's slab, recycling from the
+ *              host's free_list if necessary.
+ */
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
@@ -179,13 +192,10 @@ struct scsi_cmnd *__scsi_get_command(str
 }
 EXPORT_SYMBOL_GPL(__scsi_get_command);
 
-/*
- * Function:	scsi_get_command()
- *
- * Purpose:	Allocate and setup a scsi command block
- *
- * Arguments:	dev	- parent scsi device
- *		gfp_mask- allocator flags
+/**
+ * scsi_get_command - Allocate and setup a scsi command block
+ * @dev: parent scsi device
+ * @gfp_mask: allocator flags
  *
  * Returns:	The allocated scsi command structure.
  */
@@ -217,6 +227,12 @@ struct scsi_cmnd *scsi_get_command(struc
 }
 EXPORT_SYMBOL(scsi_get_command);
 
+/**
+ * __scsi_put_command - Free a struct scsi_cmnd
+ * @shost: dev->host
+ * @cmd: Command to free
+ * @dev: parent scsi device
+ */
 void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 			struct device *dev)
 {
@@ -237,12 +253,9 @@ void __scsi_put_command(struct Scsi_Host
 }
 EXPORT_SYMBOL(__scsi_put_command);
 
-/*
- * Function:	scsi_put_command()
- *
- * Purpose:	Free a scsi command block
- *
- * Arguments:	cmd	- command block to free
+/**
+ * scsi_put_command - Free a scsi command block
+ * @cmd: command block to free
  *
  * Returns:	Nothing.
  *
@@ -263,12 +276,13 @@ void scsi_put_command(struct scsi_cmnd *
 }
 EXPORT_SYMBOL(scsi_put_command);
 
-/*
- * Function:	scsi_setup_command_freelist()
- *
- * Purpose:	Setup the command freelist for a scsi host.
- *
- * Arguments:	shost	- host to allocate the freelist for.
+/**
+ * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
+ * @shost: host to allocate the freelist for.
+ *
+ * Description: The command freelist protects against system-wide out of memory
+ * deadlock by preallocating one SCSI command structure for each host, so the
+ * system can always write to a swap file on a device associated with that host.
  *
  * Returns:	Nothing.
  */
@@ -282,7 +296,7 @@ int scsi_setup_command_freelist(struct S
 
 	/*
 	 * Select a command slab for this host and create it if not
-	 * yet existant.
+	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
@@ -318,12 +332,9 @@ int scsi_setup_command_freelist(struct S
 
 }
 
-/*
- * Function:	scsi_destroy_command_freelist()
- *
- * Purpose:	Release the command freelist for a scsi host.
- *
- * Arguments:	shost	- host that's freelist is going to be destroyed
+/**
+ * scsi_destroy_command_freelist - Release the command freelist for a scsi host.
+ * @shost: host whose freelist is going to be destroyed
  */
 void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 {
@@ -441,8 +452,12 @@ void scsi_log_completion(struct scsi_cmn
 }
 #endif
 
-/* 
- * Assign a serial number to the request for error recovery
+/**
+ * scsi_cmd_get_serial - Assign a serial number to a command
+ * @host: the scsi host
+ * @cmd: command to assign serial number to
+ *
+ * Description: a serial number identifies a request for error recovery
  * and debugging purposes.  Protected by the Host_Lock of host.
  */
 static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
@@ -452,14 +467,12 @@ static inline void scsi_cmd_get_serial(s
 		cmd->serial_number = host->cmd_serial_number++;
 }
 
-/*
- * Function:    scsi_dispatch_command
- *
- * Purpose:     Dispatch a command to the low-level driver.
- *
- * Arguments:   cmd - command block we are dispatching.
- *
- * Notes:
+/**
+ * scsi_dispatch_command - Dispatch a command to the low-level driver.
+ * @cmd: command block we are dispatching.
+ *
+ * Return: nonzero return request was rejected and device's queue needs to be
+ * plugged.
  */
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
@@ -585,7 +598,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 
 /**
  * scsi_req_abort_cmd -- Request command recovery for the specified command
- * cmd: pointer to the SCSI command of interest
+ * @cmd: pointer to the SCSI command of interest
  *
  * This function requests that SCSI Core start recovery for the
  * command by deleting the timer and adding the command to the eh
@@ -606,9 +619,9 @@ EXPORT_SYMBOL(scsi_req_abort_cmd);
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
  * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
  *
- * This function is the mid-level's (SCSI Core) interrupt routine, which
- * regains ownership of the SCSI command (de facto) from a LLDD, and enqueues
- * the command to the done queue for further processing.
+ * Description: This function is the mid-level's (SCSI Core) interrupt routine,
+ * which regains ownership of the SCSI command (de facto) from a LLDD, and
+ * enqueues the command to the done queue for further processing.
  *
  * This is the producer of the done queue who enqueues at the tail.
  *
@@ -617,7 +630,7 @@ static void scsi_done(struct scsi_cmnd *
 static void scsi_done(struct scsi_cmnd *cmd)
 {
 	/*
-	 * We don't have to worry about this one timing out any more.
+	 * We don't have to worry about this one timing out anymore.
 	 * If we are unable to remove the timer, then the command
 	 * has already timed out.  In which case, we have no choice but to
 	 * let the timeout function run, as we have no idea where in fact
@@ -660,10 +673,11 @@ static struct scsi_driver *scsi_cmd_to_d
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
-/*
- * Function:    scsi_finish_command
- *
- * Purpose:     Pass command off to upper layer for finishing of I/O
+/**
+ * scsi_finish_command
+ * @cmd: the command
+ *
+ * Description: Pass command off to upper layer for finishing of I/O
  *              request, waking processes that are waiting on results,
  *              etc.
  */
@@ -708,18 +722,14 @@ void scsi_finish_command(struct scsi_cmn
 }
 EXPORT_SYMBOL(scsi_finish_command);
 
-/*
- * Function:	scsi_adjust_queue_depth()
- *
- * Purpose:	Allow low level drivers to tell us to change the queue depth
- * 		on a specific SCSI device
- *
- * Arguments:	sdev	- SCSI Device in question
- * 		tagged	- Do we use tagged queueing (non-0) or do we treat
- * 			  this device as an untagged device (0)
- * 		tags	- Number of tags allowed if tagged queueing enabled,
- * 			  or number of commands the low level driver can
- * 			  queue up in non-tagged mode (as per cmd_per_lun).
+/**
+ * scsi_adjust_queue_depth - Let low level drivers change a device's queue depth
+ * @sdev: SCSI Device in question
+ * @tagged: Do we use tagged queueing (non-0) or do we treat
+ *          this device as an untagged device (0)
+ * @tags: Number of tags allowed if tagged queueing enabled,
+ *        or number of commands the low level driver can
+ *        queue up in non-tagged mode (as per cmd_per_lun).
  *
  * Returns:	Nothing
  *
@@ -742,8 +752,8 @@ void scsi_adjust_queue_depth(struct scsi
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 
-	/* Check to see if the queue is managed by the block layer
-	 * if it is, and we fail to adjust the depth, exit */
+	/* Check to see if the queue is managed by the block layer.
+	 * If it is, and we fail to adjust the depth, exit. */
 	if (blk_queue_tagged(sdev->request_queue) &&
 	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
 		goto out;
@@ -772,20 +782,17 @@ void scsi_adjust_queue_depth(struct scsi
 }
 EXPORT_SYMBOL(scsi_adjust_queue_depth);
 
-/*
- * Function:	scsi_track_queue_full()
- *
- * Purpose:	This function will track successive QUEUE_FULL events on a
+/**
+ * scsi_track_queue_full
+ * @sdev: SCSI Device in question
+ * @depth: Current number of outstanding SCSI commands on this device,
+ *         not counting the one returned as QUEUE_FULL.
+ *
+ * Description:	This function will track successive QUEUE_FULL events on a
  * 		specific SCSI device to determine if and when there is a
  * 		need to adjust the queue depth on the device.
  *
- * Arguments:	sdev	- SCSI Device in question
- * 		depth	- Current number of outstanding SCSI commands on
- * 			  this device, not counting the one returned as
- * 			  QUEUE_FULL.
- *
- * Returns:	0 - No change needed
- * 		>0 - Adjust queue depth to this new depth
+ * Returns:	0 - No change needed, >0 - Adjust queue depth to this new depth,
  * 		-1 - Drop back to untagged operation using host->cmd_per_lun
  * 			as the untagged command depth
  *
@@ -824,10 +831,10 @@ EXPORT_SYMBOL(scsi_track_queue_full);
 EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
- * scsi_device_get  -  get an addition reference to a scsi_device
+ * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
- * Gets a reference to the scsi_device and increments the use count
+ * Description: Gets a reference to the scsi_device and increments the use count
  * of the underlying LLDD module.  You must hold host_lock of the
  * parent Scsi_Host or already have a reference when calling this.
  */
@@ -849,8 +856,8 @@ EXPORT_SYMBOL(scsi_device_get);
  * scsi_device_put  -  release a reference to a scsi_device
  * @sdev:	device to release a reference on.
  *
- * Release a reference to the scsi_device and decrements the use count
- * of the underlying LLDD module.  The device is freed once the last
+ * Description: Release a reference to the scsi_device and decrements the use
+ * count of the underlying LLDD module.  The device is freed once the last
  * user vanishes.
  */
 void scsi_device_put(struct scsi_device *sdev)
@@ -867,7 +874,7 @@ void scsi_device_put(struct scsi_device 
 }
 EXPORT_SYMBOL(scsi_device_put);
 
-/* helper for shost_for_each_device, thus not documented */
+/* helper for shost_for_each_device, see that for documentation */
 struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 					   struct scsi_device *prev)
 {
@@ -895,9 +902,11 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
- *
- * This traverses over each devices of @shost.  The devices have
- * a reference that must be released by scsi_host_put when breaking
+ * @data:	Opaque passed to each function call.
+ * @fn:		Function to call on each device
+ *
+ * Description: This traverses over each device of @shost.  The devices have
+ * a reference that must be released by scsi_device_put when breaking
  * out of the loop.
  */
 void starget_for_each_device(struct scsi_target *starget, void * data,
@@ -919,8 +928,8 @@ EXPORT_SYMBOL(starget_for_each_device);
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @lun for a give
- * @starget. The returned scsi_device does not have an additional
+ * Description: Looks up the scsi_device with the specified @lun for a given
+ * @starget.  The returned scsi_device does not have an additional
  * reference.  You must hold the host's host_lock over this call and
  * any access to the returned scsi_device.
  *
@@ -947,9 +956,9 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a given host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 uint lun)
@@ -969,19 +978,19 @@ EXPORT_SYMBOL(scsi_device_lookup_by_targ
 EXPORT_SYMBOL(scsi_device_lookup_by_target);
 
 /**
- * scsi_device_lookup - find a device given the host (UNLOCKED)
+ * __scsi_device_lookup - find a device given the host (UNLOCKED)
  * @shost:	SCSI host pointer
  * @channel:	SCSI channel (zero if only one channel)
- * @pun:	SCSI target number (physical unit number)
+ * @id:		SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host. The returned scsi_device does not have an additional reference.
- * You must hold the host's host_lock over this call and any access to the
- * returned scsi_device.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a given host. The returned scsi_device does not have an additional
+ * reference.  You must hold the host's host_lock over this call and any access
+ * to the returned scsi_device.
  *
  * Note:  The only reason why drivers would want to use this is because
- * they're need to access the device list in irq context.  Otherwise you
+ * they need to access the device list in irq context.  Otherwise you
  * really want to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
@@ -1006,9 +1015,9 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * @id:		SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a given host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, uint lun)

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
