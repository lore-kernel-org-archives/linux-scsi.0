From: Rob Landley <rob@landley.net>
Subject: Questions about scsi.c
Date: Thu, 25 Oct 2007 06:06:03 -0500
Message-ID: <200710250606.03301.rob@landley.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_biHIHrdxnvsduxl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48006
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753174AbXJYKGs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 06:06:48 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 4247C7392C
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 06:09:25 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Boundary-00=_biHIHrdxnvsduxl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ok, I'm reading the code and trying to update the kerneldoc comments (first 
stab at it attached, a Documentation/DocBook/scsi_midlayer.tmpl is in the 
works), and I have a few random questions from the read-through:

Why does __scsi_put_command() pass in both a Scsi_Host * and struct device * 
when scsi_get_command() uses dev->host?  Is dev->host not guaranteed to be 
set?

scsi_put_command() notes "the command must not belong to any lists" but then 
inside the function it says "serious error if the command hasn't come form a 
device list" and does a BUG_ON(list_empty(&cmd->list));

scsi_setup_command_freelist() is protection against OOM locking the system 
solid, right?  Makes sure there's always preallocated memory to send at least 
one SCSI command at a time to each host so we can swap enough to free more?

scsi_dispatch_command() I _think_ a nonzero return means the command was 
rejected and the device queue needs to be plugged, but I'm not 100% certain 
what that means.

The rest sort of seems to make sense, although the kerneldoc comments in 
include/scsi/scsi_device.h are before #defines instead of before function 
definitions so the make xmldocs infrastructure (something in either 
scripts/basic/docproc.c or scripts/kernel-doc) skips right over it
because it can't figure out the argument types.  Separate issue, todo item for 
later...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_biHIHrdxnvsduxl
Content-Type: text/x-diff;
  charset="utf-8";
  name="scsikdocs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="scsikdocs.patch"

diff -r a868e8217782 drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi.c	Thu Oct 25 06:01:43 2007 -0500
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
+ * @shost: host that's freelist is going to be destroyed
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
@@ -895,8 +902,10 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
- *
- * This traverses over each devices of @shost.  The devices have
+ * @data:	Opaque passed to each function call.
+ * @fn:		Function to call on each device
+ *
+ * Description: This traverses over each device of @shost.  The devices have
  * a reference that must be released by scsi_host_put when breaking
  * out of the loop.
  */
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
+ * needs to be released with scsi_host_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 uint lun)
@@ -972,13 +981,13 @@ EXPORT_SYMBOL(scsi_device_lookup_by_targ
  * scsi_device_lookup - find a device given the host (UNLOCKED)
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
+ * for a give host. The returned scsi_device does not have an additional
+ * reference.  You must hold the host's host_lock over this call and any access
+ * to the returned scsi_device.
  *
  * Note:  The only reason why drivers would want to use this is because
  * they're need to access the device list in irq context.  Otherwise you
@@ -1006,9 +1015,9 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * @id:		SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a give host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_host_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, uint lun)

--Boundary-00=_biHIHrdxnvsduxl--
