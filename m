From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] scsi.c: fix some typos in comments
Date: Sun, 19 Mar 2006 20:32:54 +0100 (CET)
Message-ID: <tkrat.a2a8c48d7848de8d@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:28061 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750727AbWCSTdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Mar 2006 14:33:19 -0500
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

--- linux-2.6.16-rc6/drivers/scsi/scsi.c.orig	2006-02-14 22:58:16.000000000 +0100
+++ linux-2.6.16-rc6/drivers/scsi/scsi.c	2006-03-19 20:26:57.000000000 +0100
@@ -328,9 +328,9 @@ int scsi_setup_command_freelist(struct S
 	INIT_LIST_HEAD(&shost->free_list);
 
 	/*
 	 * Select a command slab for this host and create it if not
-	 * yet existant.
+	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
 	if (!pool->users) {
@@ -369,9 +369,9 @@ int scsi_setup_command_freelist(struct S
  * Function:	scsi_destroy_command_freelist()
  *
  * Purpose:	Release the command freelist for a scsi host.
  *
- * Arguments:	shost	- host that's freelist is going to be destroyed
+ * Arguments:	shost	- host whose freelist is going to be destroyed
  */
 void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 {
 	while (!list_empty(&shost->free_list)) {
@@ -735,9 +735,9 @@ static DEFINE_PER_CPU(struct list_head, 
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
 	/*
-	 * We don't have to worry about this one timing out any more.
+	 * We don't have to worry about this one timing out anymore.
 	 * If we are unable to remove the timer, then the command
 	 * has already timed out.  In which case, we have no choice but to
 	 * let the timeout function run, as we have no idea where in fact
 	 * that function could really be.  It might be on another processor,
@@ -892,10 +892,10 @@ void scsi_adjust_queue_depth(struct scsi
 		return;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 
-	/* Check to see if the queue is managed by the block layer
-	 * if it is, and we fail to adjust the depth, exit */
+	/* Check to see if the queue is managed by the block layer.
+	 * If it is, and we fail to adjust the depth, exit. */
 	if (blk_queue_tagged(sdev->request_queue) &&
 	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
 		goto out;
 
@@ -974,9 +974,9 @@ int scsi_track_queue_full(struct scsi_de
 }
 EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
- * scsi_device_get  -  get an addition reference to a scsi_device
+ * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
  * Gets a reference to the scsi_device and increments the use count
  * of the underlying LLDD module.  You must hold host_lock of the
@@ -1039,10 +1039,10 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
  *
- * This traverses over each devices of @shost.  The devices have
- * a reference that must be released by scsi_host_put when breaking
+ * This traverses over each device of @shost.  The devices have a
+ * reference that must be released by scsi_device_put when breaking
  * out of the loop.
  */
 void starget_for_each_device(struct scsi_target *starget, void * data,
 		     void (*fn)(struct scsi_device *, void *))
@@ -1062,15 +1062,15 @@ EXPORT_SYMBOL(starget_for_each_device);
  * __scsi_device_lookup_by_target - find a device given the target (UNLOCKED)
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @lun for a give
+ * Looks up the scsi_device with the specified @lun for a given
  * @starget. The returned scsi_device does not have an additional
  * reference.  You must hold the host's host_lock over this call and
  * any access to the returned scsi_device.
  *
  * Note:  The only reason why drivers would want to use this is because
- * they're need to access the device list in irq context.  Otherwise you
+ * they need to access the device list in irq context.  Otherwise you
  * really want to use scsi_device_lookup_by_target instead.
  **/
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 						   uint lun)
@@ -1091,10 +1091,10 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
  * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * given host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 uint lun)
 {
@@ -1112,22 +1112,22 @@ struct scsi_device *scsi_device_lookup_b
 }
 EXPORT_SYMBOL(scsi_device_lookup_by_target);
 
 /**
- * scsi_device_lookup - find a device given the host (UNLOCKED)
+ * __scsi_device_lookup - find a device given the host (UNLOCKED)
  * @shost:	SCSI host pointer
  * @channel:	SCSI channel (zero if only one channel)
  * @pun:	SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
  * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host. The returned scsi_device does not have an additional reference.
+ * given host. The returned scsi_device does not have an additional reference.
  * You must hold the host's host_lock over this call and any access to the
  * returned scsi_device.
  *
- * Note:  The only reason why drivers would want to use this is because
- * they're need to access the device list in irq context.  Otherwise you
- * really want to use scsi_device_lookup instead.
+ * Note:  The only reason why drivers would want to use this is because they
+ * need to access the device list in irq context.  Otherwise you really want
+ * to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, uint lun)
 {
@@ -1150,10 +1150,10 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * @id:		SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
  * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * given host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, uint lun)
 {


