From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 15/15] Add Documentation/DocBook/scsi_midlayer.tmpl and add to Makefile.
Date: Mon, 29 Oct 2007 05:12:10 -0500
Message-ID: <200710290512.11549.rob@landley.net>
References: <200710262318.01021.rob@landley.net> <20071026230557.2ac5f9c8.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7HbJHNzaBrEWmlc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49016
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757566AbXJ2KMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 06:12:17 -0400
In-Reply-To: <20071026230557.2ac5f9c8.rdunlap@xenotime.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

--Boundary-00=_7HbJHNzaBrEWmlc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 27 October 2007 1:05:57 am Randy Dunlap wrote:
> On Fri, 26 Oct 2007 23:18:00 -0500 Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Add Documentation/DocBook/scsi_midlayer.tmpl and add to Makefile.
>
> I have comments for all 15 patches here.
>
> a.  You should cc: the maintainer who you want/expect to apply the
> 	patches.  Always.  Andrew Morton is the only person who
> 	trolls for patches on a mailing list.  :)

I CC: Andrew when I send to linux-kernel.  I was under the impression 
linux-scsi was a lower traffic list.

> b.  The function "Description:" section header is not strictly
> 	required by scripts/kernel-doc.  It will assume that the
> 	first text section after parameters is the Description:
> 	section.  FYI.

Ok.

> c.  Extraneous whitespace.  Git or quilt check for this.
> 	I don't know about hg...

There might be a flag, but I haven't checked any of this in, just used it to 
diff against a current base.

> patch 2:
> Warning: trailing whitespace in line 60 of drivers/scsi/scsicam.c
>
> patch 6:
> Warning: trailing whitespace in line 185 of drivers/scsi/scsi_ioctl.c
>
> patch 15:
> Warning: trailing whitespace in lines 8,43 of
> Documentation/DocBook/scsi_midlayer.tmpl

Got it.

> The docbook builds cleanly and all of my following comments are just
> for cleanups/fixes.
>
>
> General:  SCSI, not scsi (in text descriptions, sentences, etc.)
> General:  IRQ, not irq (in text)
> General:  LLD, not lld (in text) (or LLDD, not lldd)

Changed 3 or 4 instances of lowercase scsi to SCSI in the docbook.  Didn't 
find an irq or lld in there.

Keep in mind I wrote less than half of the kerneldoc comments in these 
files.  "They're" and failing to capitalize the first word of each sentence 
were common patterns I tried to fix up where I could, but I missed a bunch.

These comments need a lot more work in general, and I just moved the 
explanation of that statement to the response to James Bottomley's email.

> Chap. 1:
> Can't SCSI commands also be 32 bytes long?

I have no idea, ask the first paragraph of:
http://sg.torque.net/sg/p/sg_v3_ho.html#what

I was initially trying to integrate that and the 2.4 SCSI howto into this 
document, but I A) just didn't have time this week, B) have idea which parts 
of that are out of date.  (And C) still don't understand large chunks of it, 
although that's mostly just a restatement of A.)

If you can confirm "yes they can be 32 bytes long" I can add it...

> Chap. 3:  Mid-layer:
>
> It would make more sense to me to put extra comments like
> 	Main file for the scsi midlayer.
> just after the source file name instead of after all of the documented
> interfaces in that file.

You mean like:

      <sect2 id="scsi.c">
        <title>drivers/scsi/scsi.c</title>
        <para>Main file for the SCSI midlayer.</para>

Which is what the tmpl file says now?  That's the only instance of it in the 
file that I can find.  I don't understand what you're asking for.

> scsi_finish_command - needs a short description on the first kernel-doc
> line. scsi_track_queue_full - ditto

Ok, took a stab at it.

> __scsi_device_lookup_by_target:  fix text:
> The only reason why drivers would want to use this is because they're need
> to access the device list in irq context.
>
> s/would want to/should/
> s/they're/they/

Got it.

> scsi_eh_finish_cmd:
>
> thus we really
>
> s/thus/Thus/

Ah, missed one.  Got it.

> scsi_eh_get_sense:
> proccessed (sp)

Fixed.

> This has the unfortunate side effect that if a shost adapter does not
> automatically request sense information, that we end up shutting it down
> before we request it.
>
> Ugh.  Fix.

Done.

> scsi_sense_desc_find:
> short function description needs to be all on one line and no blank
> line before parameters.

Yup.  Got it.

> scsi_get_sense_info_fld:
> same comments as above.

And again, fixed.

> scsi_init_devinfo:
> Don't end kernel-doc with **/  (this is just a convention, not a
> syntax rule).

I don't, but this file has a lot of 'em, doesn't it?  Removed...

> HTML output of the function description is there 2 times.
> I'll look into this problem.

Ok...

> scsi_mode_sense:
> function short description must be on one line only (can be a long line
> 	if needed)
> Description text is repeated in html output; this is usually due to
> the function desc. being on multiple lines.
>
> scsi_device_set_state:
> short func desc on one line only.
>
>
> scsi_internal_device_block:
> short func desc on one line only.

Got 'em.

> scsi_kunmap_atomic_sg:
> short func desc on one line only.
>
> scsi_target_reap:
> no blank line before parameter list
>
> scsi_inq_str:
> short func desc on one line only.

Got 'em.

>
> scsi_host_set_state:
> short func desc on one line only.
>
> scsi_host_lookup:
> no blank line before parameter list
>
> fc_host_post_event:
> short func desc on one line only.
>
> fc_host_post_vendor_event:
> a fc_host
>
> s/a/an/

ok

> fc_remove_host:
> short func desc on one line only.
>
> fc_remote_port_add:
> short func desc on one line only.
>
> fc_remote_port_delete:
> short func desc on one line only.
>
> fc_remote_port_rolechg:
> short func desc on one line only.
>
> iscsi_destroy_conn:
> This can be called from a LLD or iscsi_transport.
>
> s/a/an/

Got it.

> sas_remove_children:
> sas_remove_host:
> sas_phy_alloc:
> sas_phy_add:
> sas_phy_free:
> sas_phy_delete:
> scsi_is_sas_phy:
> sas_port_delete:
> scsi_is_sas_port:
> sas_rphy_add:
> sas_rphy_free:
> sas_rphy_delete:
> sas_rphy_remove:
> scsi_is_sas_rphy:
> sas_attach_transport:
> sas_release_transport:
> s/--/-/  in first line of kernel-doc
>
> sas_port_add:
> no blank line before parameter list
>
>
> srp_rport_add:
> no blank line before parameter list
>
> srp_rport_del:
> srp_remove_host:
> srp_attach_transport:
> srp_release_transport:
> s/--/-/  in first line of kernel-doc

Got it.

> ###
> Thanks,
> ---
> ~Randy

Updated drivers/scsi/* patch attached.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_7HbJHNzaBrEWmlc
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="scsi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="scsi.patch"

diff -r a868e8217782 drivers/scsi/constants.c
--- a/drivers/scsi/constants.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/constants.c	Mon Oct 29 05:10:02 2007 -0500
@@ -362,7 +362,6 @@ EXPORT_SYMBOL(scsi_print_command);
 EXPORT_SYMBOL(scsi_print_command);
 
 /**
- *
  *	scsi_print_status - print scsi status description
  *	@scsi_status: scsi status value
  *
diff -r a868e8217782 drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/hosts.c	Mon Oct 29 05:10:03 2007 -0500
@@ -54,8 +54,7 @@ static struct class shost_class = {
 };
 
 /**
- *	scsi_host_set_state - Take the given host through the host
- *		state model.
+ *	scsi_host_set_state - Take the given host through the host state model.
  *	@shost:	scsi host to change the state of.
  *	@state:	state to change to.
  *
@@ -425,7 +424,6 @@ EXPORT_SYMBOL(scsi_unregister);
 
 /**
  * scsi_host_lookup - get a reference to a Scsi_Host by host no
- *
  * @hostnum:	host number to locate
  *
  * Return value:
diff -r a868e8217782 drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi.c	Mon Oct 29 05:10:03 2007 -0500
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
+ * scsi_finish_command - cleanup and pass command back to upper layer
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
+ * scsi_track_queue_full - track QUEUE_FULL events to adjust queue depth
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
@@ -919,13 +928,13 @@ EXPORT_SYMBOL(starget_for_each_device);
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
  * Note:  The only reason why drivers would want to use this is because
- * they're need to access the device list in irq context.  Otherwise you
+ * they need to access the device list in irq context.  Otherwise you
  * really want to use scsi_device_lookup_by_target instead.
  **/
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
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
diff -r a868e8217782 drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_devinfo.c	Mon Oct 29 05:10:03 2007 -0500
@@ -276,11 +276,12 @@ static void scsi_strcpy_devinfo(char *na
 }
 
 /**
- * scsi_dev_info_list_add: add one dev_info list entry.
+ * scsi_dev_info_list_add - add one dev_info list entry.
+ * @compatible: if true, null terminate short strings.  Otherwise space pad.
  * @vendor:	vendor string
  * @model:	model (product) string
  * @strflags:	integer string
- * @flag:	if strflags NULL, use this flag value
+ * @flags:	if strflags NULL, use this flag value
  *
  * Description:
  * 	Create and add one dev_info entry for @vendor, @model, @strflags or
@@ -322,8 +323,7 @@ static int scsi_dev_info_list_add(int co
 }
 
 /**
- * scsi_dev_info_list_add_str: parse dev_list and add to the
- * scsi_dev_info_list.
+ * scsi_dev_info_list_add_str - parse dev_list and add to the scsi_dev_info_list.
  * @dev_list:	string of device flags to add
  *
  * Description:
@@ -374,15 +374,15 @@ static int scsi_dev_info_list_add_str(ch
 }
 
 /**
- * get_device_flags - get device specific flags from the dynamic device
- * list. Called during scan time.
+ * get_device_flags - get device specific flags from the dynamic device list.
+ * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
  * @model:	model name
  *
  * Description:
  *     Search the scsi_dev_info_list for an entry matching @vendor and
  *     @model, if found, return the matching flags value, else return
- *     the host or global default settings.
+ *     the host or global default settings.  Called during scan time.
  **/
 int scsi_get_device_flags(struct scsi_device *sdev,
 			  const unsigned char *vendor,
@@ -483,13 +483,11 @@ stop_output:
 }
 
 /* 
- * proc_scsi_dev_info_write: allow additions to the scsi_dev_info_list via
- * /proc.
- *
- * Use: echo "vendor:model:flag" > /proc/scsi/device_info
- *
- * To add a black/white list entry for vendor and model with an integer
- * value of flag to the scsi device info list.
+ * proc_scsi_dev_info_write - allow additions to scsi_dev_info_list via /proc.
+ *
+ * Description: Adds a black/white list entry for vendor and model with an
+ * integer value of flag to the scsi device info list.
+ * To use, echo "vendor:model:flag" > /proc/scsi/device_info
  */
 static int proc_scsi_devinfo_write(struct file *file, const char __user *buf,
 				   unsigned long length, void *data)
@@ -532,8 +530,7 @@ MODULE_PARM_DESC(default_dev_flags,
 		 "scsi default device flag integer value");
 
 /**
- * scsi_dev_info_list_delete: called from scsi.c:exit_scsi to remove
- * 	the scsi_dev_info_list.
+ * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
  **/
 void scsi_exit_devinfo(void)
 {
@@ -552,13 +549,12 @@ void scsi_exit_devinfo(void)
 }
 
 /**
- * scsi_dev_list_init: set up the dynamic device list.
- * @dev_list:	string of device flags to add
+ * scsi_dev_list_init - set up the dynamic device list.
  *
  * Description:
- * 	Add command line @dev_list entries, then add
+ * 	Add command line entries from scsi_dev_flags, then add
  * 	scsi_static_device_list entries to the scsi device info list.
- **/
+ */
 int __init scsi_init_devinfo(void)
 {
 #ifdef CONFIG_SCSI_PROC_FS
diff -r a868e8217782 drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_error.c	Mon Oct 29 05:10:03 2007 -0500
@@ -780,7 +780,7 @@ static int scsi_request_sense(struct scs
  * Notes:
  *    We don't want to use the normal command completion while we are are
  *    still handling errors - it may cause other commands to be queued,
- *    and that would disturb what we are doing.  thus we really want to
+ *    and that would disturb what we are doing.  Thus we really want to
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  **/
@@ -795,7 +795,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
 /**
  * scsi_eh_get_sense - Get device sense data.
  * @work_q:	Queue of commands to process.
- * @done_q:	Queue of proccessed commands..
+ * @done_q:	Queue of processed commands.
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
@@ -803,7 +803,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
  *
  * Notes:
  *    This has the unfortunate side effect that if a shost adapter does
- *    not automatically request sense information, that we end up shutting
+ *    not automatically request sense information, we end up shutting
  *    it down before we request it.
  *
  *    All drivers should request sense information internally these days,
@@ -859,7 +859,7 @@ EXPORT_SYMBOL_GPL(scsi_eh_get_sense);
 
 /**
  * scsi_eh_tur - Send TUR to device.
- * @scmd:	Scsi cmd to send TUR
+ * @scmd:	&scsi_cmnd to send TUR
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
@@ -888,14 +888,14 @@ retry_tur:
 }
 
 /**
- * scsi_eh_abort_cmds - abort canceled commands.
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * scsi_eh_abort_cmds - abort pending commands.
+ * @work_q:	&list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Decription:
  *    Try and see whether or not it makes sense to try and abort the
- *    running command.  this only works out to be the case if we have one
- *    command that has timed out.  if the command simply failed, it makes
+ *    running command.  This only works out to be the case if we have one
+ *    command that has timed out.  If the command simply failed, it makes
  *    no sense to try and abort the command, since as far as the shost
  *    adapter is concerned, it isn't running.
  **/
@@ -932,7 +932,7 @@ static int scsi_eh_abort_cmds(struct lis
 
 /**
  * scsi_eh_try_stu - Send START_UNIT to device.
- * @scmd:	Scsi cmd to send START_UNIT
+ * @scmd:	&scsi_cmnd to send START_UNIT
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
@@ -957,8 +957,9 @@ static int scsi_eh_try_stu(struct scsi_c
 
  /**
  * scsi_eh_stu - send START_UNIT if needed
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @shost:	&scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
@@ -1009,10 +1010,11 @@ static int scsi_eh_stu(struct Scsi_Host 
 /**
  * scsi_eh_bus_device_reset - send bdr if needed
  * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Notes:
- *    Try a bus device reset.  still, look to see whether we have multiple
+ *    Try a bus device reset.  Still, look to see whether we have multiple
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
  *    a bus_reset instead. 
@@ -1064,8 +1066,9 @@ static int scsi_eh_bus_device_reset(stru
 
 /**
  * scsi_eh_bus_reset - send a bus reset 
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @shost:	&scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  **/
 static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			     struct list_head *work_q,
@@ -1441,7 +1444,8 @@ static void scsi_restart_operations(stru
 /**
  * scsi_eh_ready_devs - check device ready state and recover if not.
  * @shost: 	host to be recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  **/
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
@@ -1825,9 +1829,7 @@ EXPORT_SYMBOL(scsi_command_normalize_sen
 EXPORT_SYMBOL(scsi_command_normalize_sense);
 
 /**
- * scsi_sense_desc_find - search for a given descriptor type in
- *			descriptor sense data format.
- *
+ * scsi_sense_desc_find - search for a given descriptor type in	descriptor sense data format.
  * @sense_buffer:	byte array of descriptor format sense data
  * @sb_len:		number of valid bytes in sense_buffer
  * @desc_type:		value of descriptor type to find
@@ -1866,9 +1868,7 @@ EXPORT_SYMBOL(scsi_sense_desc_find);
 EXPORT_SYMBOL(scsi_sense_desc_find);
 
 /**
- * scsi_get_sense_info_fld - attempts to get information field from
- *			sense data (either fixed or descriptor format)
- *
+ * scsi_get_sense_info_fld - get information field from sense data (either fixed or descriptor format)
  * @sense_buffer:	byte array of sense data
  * @sb_len:		number of valid bytes in sense_buffer
  * @info_out:		pointer to 64 integer where 8 or 4 byte information
diff -r a868e8217782 drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_ioctl.c	Mon Oct 29 05:10:03 2007 -0500
@@ -174,10 +174,15 @@ static int scsi_ioctl_get_pci(struct scs
 }
 
 
-/*
- * the scsi_ioctl() function differs from most ioctls in that it does
- * not take a major/minor number as the dev field.  Rather, it takes
- * a pointer to a scsi_devices[] element, a structure. 
+/**
+ * scsi_ioctl - Dispatch ioctl to scsi device
+ * @sdev: scsi device receiving ioctl
+ * @cmd: which ioctl is it
+ * @arg: data associated with ioctl
+ *
+ * Description: The scsi_ioctl() function differs from most ioctls in that it
+ * does not take a major/minor number as the dev field.  Rather, it takes
+ * a pointer to a &struct scsi_device.
  */
 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
@@ -264,9 +269,12 @@ int scsi_ioctl(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL(scsi_ioctl);
 
-/*
- * the scsi_nonblock_ioctl() function is designed for ioctls which may
- * be executed even if the device is in recovery.
+/**
+ * scsi_nonblock_ioctl() - Handle SG_SCSI_RESET
+ * @sdev: scsi device receiving ioctl
+ * @cmd: Must be SC_SCSI_RESET
+ * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
+ * @filp: either NULL or a &struct file which must have the O_NONBLOCK flag.
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, struct file *filp)
@@ -276,7 +284,7 @@ int scsi_nonblockable_ioctl(struct scsi_
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
 	 * non-blocking */
-	if (filp && filp->f_flags & O_NONBLOCK) {
+	if (filp && (filp->f_flags & O_NONBLOCK)) {
 		if (scsi_host_in_recovery(sdev->host))
 			return -ENODEV;
 	} else if (!scsi_block_when_processing_errors(sdev))
diff -r a868e8217782 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_lib.c	Mon Oct 29 05:10:03 2007 -0500
@@ -175,7 +175,7 @@ int scsi_queue_insert(struct scsi_cmnd *
  *
  * returns the req->errors value which is the scsi_cmnd result
  * field.
- **/
+ */
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
 		 unsigned char *sense, int timeout, int retries, int flags)
@@ -274,7 +274,7 @@ static void scsi_bi_endio(struct bio *bi
 /**
  * scsi_req_map_sg - map a scatterlist into a request
  * @rq:		request to fill
- * @sg:		scatterlist
+ * @sgl:	scatterlist
  * @nsegs:	number of elements
  * @bufflen:	len of buffer
  * @gfp:	memory allocation flags
@@ -365,14 +365,16 @@ free_bios:
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @cmd_len:	length of scsi cdb
- * @data_direction: data direction
+ * @data_direction: DMA_TO_DEVICE, DMA_FROM_DEVICE, or DMA_NONE
  * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
  * @bufflen:	len of buffer
  * @use_sg:	if buffer is a scatterlist this is the number of elements
  * @timeout:	request timeout in seconds
  * @retries:	number of times to retry request
- * @flags:	or into request flags
- **/
+ * @privdata:	data passed to done()
+ * @done:	callback function when done
+ * @gfp:	memory allocation flags
+ */
 int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
 		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
 		       int use_sg, int timeout, int retries, void *privdata,
@@ -1804,7 +1806,7 @@ void scsi_exit_queue(void)
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
- *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if successful; negative error number or scsi
@@ -1871,8 +1873,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
 EXPORT_SYMBOL_GPL(scsi_mode_select);
 
 /**
- *	scsi_mode_sense - issue a mode sense, falling back from 10 to 
- *		six bytes if necessary.
+ *	scsi_mode_sense - issue a mode sense, falling back from 10 to six bytes if necessary.
  *	@sdev:	SCSI device to be queried
  *	@dbd:	set if mode sense will allow block descriptors to be returned
  *	@modepage: mode page being requested
@@ -1881,13 +1882,13 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
- *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if unsuccessful, or the header offset (either 4
  *	or 8 depending on whether a six or ten byte command was
  *	issued) if successful.
- **/
+ */
 int
 scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		  unsigned char *buffer, int len, int timeout, int retries,
@@ -2007,14 +2008,13 @@ EXPORT_SYMBOL(scsi_test_unit_ready);
 EXPORT_SYMBOL(scsi_test_unit_ready);
 
 /**
- *	scsi_device_set_state - Take the given device through the device
- *		state model.
+ *	scsi_device_set_state - Take the given device through the device state model.
  *	@sdev:	scsi device to change the state of.
  *	@state:	state to change to.
  *
  *	Returns zero if unsuccessful or an error if the requested 
  *	transition is illegal.
- **/
+ */
 int
 scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 {
@@ -2128,7 +2128,7 @@ EXPORT_SYMBOL(scsi_device_set_state);
  *	Must be called with user context, may sleep.
  *
  *	Returns zero if unsuccessful or an error if not.
- **/
+ */
 int
 scsi_device_quiesce(struct scsi_device *sdev)
 {
@@ -2153,7 +2153,7 @@ EXPORT_SYMBOL(scsi_device_quiesce);
  *	queues.
  *
  *	Must be called with user context, may sleep.
- **/
+ */
 void
 scsi_device_resume(struct scsi_device *sdev)
 {
@@ -2190,8 +2190,7 @@ EXPORT_SYMBOL(scsi_target_resume);
 EXPORT_SYMBOL(scsi_target_resume);
 
 /**
- * scsi_internal_device_block - internal function to put a device
- *				temporarily into the SDEV_BLOCK state
+ * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
  * @sdev:	device to block
  *
  * Block request made by scsi lld's to temporarily stop all
@@ -2206,7 +2205,7 @@ EXPORT_SYMBOL(scsi_target_resume);
  *	state, all commands are deferred until the scsi lld reenables
  *	the device with scsi_device_unblock or device_block_tmo fires.
  *	This routine assumes the host_lock is held on entry.
- **/
+ */
 int
 scsi_internal_device_block(struct scsi_device *sdev)
 {
@@ -2246,7 +2245,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_b
  *	(which must be a legal transition) allowing the midlayer to
  *	goose the queue for this device.  This routine assumes the 
  *	host_lock is held upon entry.
- **/
+ */
 int
 scsi_internal_device_unblock(struct scsi_device *sdev)
 {
@@ -2324,7 +2323,7 @@ EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
 /**
  * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
- * @sg:		scatter-gather list
+ * @sgl:	scatter-gather list
  * @sg_count:	number of segments in sg
  * @offset:	offset in bytes into sg, on return offset into the mapped area
  * @len:	bytes to map, on return number of bytes mapped
@@ -2373,8 +2372,7 @@ EXPORT_SYMBOL(scsi_kmap_atomic_sg);
 EXPORT_SYMBOL(scsi_kmap_atomic_sg);
 
 /**
- * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously
- *			   mapped with scsi_kmap_atomic_sg
+ * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously mapped with scsi_kmap_atomic_sg
  * @virt:	virtual address to be unmapped
  */
 void scsi_kunmap_atomic_sg(void *virt)
diff -r a868e8217782 drivers/scsi/scsi_netlink.c
--- a/drivers/scsi/scsi_netlink.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_netlink.c	Mon Oct 29 05:10:03 2007 -0500
@@ -32,11 +32,12 @@ EXPORT_SYMBOL_GPL(scsi_nl_sock);
 
 
 /**
- * scsi_nl_rcv_msg -
- *    Receive message handler. Extracts message from a receive buffer.
+ * scsi_nl_rcv_msg - Receive message handler.
+ * @skb:		socket receive buffer
+ *
+ * Description: Extracts message from a receive buffer.
  *    Validates message header and calls appropriate transport message handler
  *
- * @skb:		socket receive buffer
  *
  **/
 static void
@@ -99,9 +100,7 @@ next_msg:
 
 
 /**
- * scsi_nl_rcv_event -
- *    Event handler for a netlink socket.
- *
+ * scsi_nl_rcv_event - Event handler for a netlink socket.
  * @this:		event notifier block
  * @event:		event type
  * @ptr:		event payload
@@ -129,9 +128,7 @@ static struct notifier_block scsi_netlin
 
 
 /**
- * scsi_netlink_init -
- *    Called by SCSI subsystem to intialize the SCSI transport netlink
- *    interface
+ * scsi_netlink_init - Called by SCSI subsystem to intialize the SCSI transport netlink interface
  *
  **/
 void
@@ -160,9 +157,7 @@ scsi_netlink_init(void)
 
 
 /**
- * scsi_netlink_exit -
- *    Called by SCSI subsystem to disable the SCSI transport netlink
- *    interface
+ * scsi_netlink_exit - Called by SCSI subsystem to disable the SCSI transport netlink interface
  *
  **/
 void
diff -r a868e8217782 drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_proc.c	Mon Oct 29 05:10:03 2007 -0500
@@ -45,6 +45,16 @@ static struct proc_dir_entry *proc_scsi;
 /* Protect sht->present and sht->proc_dir */
 static DEFINE_MUTEX(global_host_template_mutex);
 
+/**
+ * proc_scsi_read - handle read from /proc by calling host's proc_info() command
+ * @buffer: passed to proc_info
+ * @start: passed to proc_info
+ * @offset: passed to proc_info
+ * @length: passed to proc_info
+ * @eof: returns whether length read was less than requested
+ * @data: pointer to a &struct Scsi_Host
+ */
+
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
 {
@@ -57,6 +67,13 @@ static int proc_scsi_read(char *buffer, 
 	return n;
 }
 
+/**
+ * proc_scsi_write_proc - Handle write to /proc by calling host's proc_info()
+ * @file: not used
+ * @buf: source of data to write.
+ * @count: number of bytes (at most PROC_BLOCK_SIZE) to write.
+ * @data: pointer to &struct Scsi_Host
+ */
 static int proc_scsi_write_proc(struct file *file, const char __user *buf,
                            unsigned long count, void *data)
 {
@@ -79,6 +96,13 @@ out:
 	free_page((unsigned long)page);
 	return ret;
 }
+
+/**
+ * scsi_proc_hostdir_add - Create directory in /proc for a scsi host
+ * @sht: owner of this directory
+ *
+ * Sets sht->proc_dir to the new directory.
+ */
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
@@ -97,6 +121,10 @@ void scsi_proc_hostdir_add(struct scsi_h
 	mutex_unlock(&global_host_template_mutex);
 }
 
+/**
+ * scsi_proc_hostdir_rm - remove directory in /proc for a scsi host
+ * @sht: owner of directory
+ */
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
 	if (!sht->proc_info)
@@ -110,6 +138,11 @@ void scsi_proc_hostdir_rm(struct scsi_ho
 	mutex_unlock(&global_host_template_mutex);
 }
 
+
+/**
+ * scsi_proc_host_add - Add entry for this host to appropriate /proc dir
+ * @shost: host to add
+ */
 void scsi_proc_host_add(struct Scsi_Host *shost)
 {
 	struct scsi_host_template *sht = shost->hostt;
@@ -133,6 +166,10 @@ void scsi_proc_host_add(struct Scsi_Host
 	p->owner = sht->module;
 }
 
+/**
+ * scsi_proc_host_rm - remove this host's entry from /proc
+ * @shost: which host
+ */
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
 	char name[10];
@@ -143,7 +180,14 @@ void scsi_proc_host_rm(struct Scsi_Host 
 	sprintf(name,"%d", shost->host_no);
 	remove_proc_entry(name, shost->hostt->proc_dir);
 }
-
+/**
+ * proc_print_scsidevice - return data about this host
+ * @dev: A scsi device
+ * @data: &struct seq_file to output to.
+ *
+ * Description: prints Host, Channel, Id, Lun, Vendor, Model, Rev, Type,
+ * and revision.
+ */
 static int proc_print_scsidevice(struct device *dev, void *data)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -189,6 +233,21 @@ static int proc_print_scsidevice(struct 
 	return 0;
 }
 
+/**
+ * scsi_add_single_device - Respond to user request to probe for/add device
+ * @host: user-supplied decimal integer
+ * @channel: user-supplied decimal integer
+ * @id: user-supplied decimal integer
+ * @lun: user-supplied decimal integer
+ *
+ * Description: called by writing "scsi add-single-device" to /proc/scsi/scsi.
+ *
+ * does scsi_host_lookup() and either user_scan() if that transport
+ * type supports it, or else scsi_scan_host_selected()
+ *
+ * Note: this seems to be aimed exclusively at SCSI parallel busses.
+ */
+
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct Scsi_Host *shost;
@@ -206,6 +265,16 @@ static int scsi_add_single_device(uint h
 	return error;
 }
 
+/**
+ * scsi_remove_single_device - Respond to user request to remove a device
+ * @host: user-supplied decimal integer
+ * @channel: user-supplied decimal integer
+ * @id: user-supplied decimal integer
+ * @lun: user-supplied decimal integer
+ *
+ * Description: called by writing "scsi remove-single-device" to
+ * /proc/scsi/scsi.  Does a scsi_device_lookup() and scsi_remove_device()
+ */
 static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev;
@@ -226,6 +295,25 @@ static int scsi_remove_single_device(uin
 	return error;
 }
 
+/**
+ * proc_scsi_write - handle writes to /proc/scsi/scsi
+ * @file: not used
+ * @buf: buffer to write
+ * @length: length of buf, at most PAGE_SIZE
+ * @ppos: not used
+ *
+ * Description: this provides a legacy mechanism to add or remove devices by
+ * Host, Channel, ID, and Lun.  To use,
+ * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
+ * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
+ * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
+ *
+ * Note: this seems to be aimed at parallel SCSI. Most modern busses (USB,
+ * SATA, Firewire, Fibre Channel, etc) dynamically assign these values to
+ * provide a unique identifier and nothing more.
+ */
+
+
 static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 			       size_t length, loff_t *ppos)
 {
@@ -291,6 +379,11 @@ static ssize_t proc_scsi_write(struct fi
 	return err;
 }
 
+/**
+ * proc_scsi_show - show contents of /proc/scsi/scsi (attached devices)
+ * @s: output goes here
+ * @p: not used
+ */
 static int proc_scsi_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "Attached devices:\n");
@@ -298,10 +391,17 @@ static int proc_scsi_show(struct seq_fil
 	return 0;
 }
 
+/**
+ * proc_scsi_open - glue function
+ * @inode: not used
+ * @file: passed to single_open()
+ *
+ * Associates proc_scsi_show with this file
+ */
 static int proc_scsi_open(struct inode *inode, struct file *file)
 {
 	/*
-	 * We don't really needs this for the write case but it doesn't
+	 * We don't really need this for the write case but it doesn't
 	 * harm either.
 	 */
 	return single_open(file, proc_scsi_show, NULL);
@@ -315,6 +415,9 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
+/**
+ * scsi_init_procfs - create scsi and scsi/scsi in procfs
+ */
 int __init scsi_init_procfs(void)
 {
 	struct proc_dir_entry *pde;
@@ -336,6 +439,9 @@ err1:
 	return -ENOMEM;
 }
 
+/**
+ * scsi_exit_procfs - Remove scsi/scsi and scsi from procfs
+ */
 void scsi_exit_procfs(void)
 {
 	remove_proc_entry("scsi/scsi", NULL);
diff -r a868e8217782 drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_scan.c	Mon Oct 29 05:10:03 2007 -0500
@@ -221,6 +221,9 @@ static void scsi_unlock_floptical(struct
 
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
+ * @starget: which target to allocate a &scsi_device for
+ * @lun: which lun
+ * @hostdata: usually NULL and set by ->slave_alloc instead
  *
  * Description:
  *     Allocate, initialize for io, and return a pointer to a scsi_Device.
@@ -469,7 +472,6 @@ static void scsi_target_reap_usercontext
 
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
- *
  * @starget: target to be checked
  *
  * This is used after removing a LUN or doing a last put of the target
@@ -925,8 +927,7 @@ static inline void scsi_destroy_sdev(str
 
 #ifdef CONFIG_SCSI_LOGGING
 /** 
- * scsi_inq_str - print INQUIRY data from min to max index,
- * strip trailing whitespace
+ * scsi_inq_str - print INQUIRY data from min to max index, strip trailing whitespace
  * @buf:   Output buffer with at least end-first+1 bytes of space
  * @inq:   Inquiry buffer (input)
  * @first: Offset of string into inq
@@ -954,9 +955,10 @@ static unsigned char *scsi_inq_str(unsig
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
  * @lun:	LUN of target device
- * @sdevscan:	probe the LUN corresponding to this scsi_device
- * @sdevnew:	store the value of any new scsi_device allocated
  * @bflagsp:	store bflags here if not NULL
+ * @sdevp:	probe the LUN corresponding to this scsi_device
+ * @rescan:     if nonzero skip some code only needed on first scan
+ * @hostdata:	passed to scsi_alloc_sdev()
  *
  * Description:
  *     Call scsi_probe_lun, if a LUN with an attached device is found,
@@ -1107,6 +1109,8 @@ static int scsi_probe_and_add_lun(struct
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
  * @starget:	pointer to target structure to scan
  * @bflags:	black/white list flag for LUN 0
+ * @scsi_level: Which version of the standard does this device adhere to
+ * @rescan:     passed to scsi_probe_add_lun()
  *
  * Description:
  *     Generally, scan from LUN 1 (LUN 0 is assumed to already have been
@@ -1217,7 +1221,7 @@ EXPORT_SYMBOL(scsilun_to_int);
 
 /**
  * int_to_scsilun: reverts an int into a scsi_lun
- * @int:        integer to be reverted
+ * @lun:        integer to be reverted
  * @scsilun:	struct scsi_lun to be set.
  *
  * Description:
@@ -1249,18 +1253,22 @@ EXPORT_SYMBOL(int_to_scsilun);
 
 /**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
- * @sdevscan:	scan the host, channel, and id of this scsi_device
+ * @starget: which target
+ * @bflags: Zero or a mix of BLIST_NOLUN, BLIST_REPORTLUN2, or BLIST_NOREPORTLUN
+ * @rescan: nonzero if we can skip code only needed on first scan
  *
  * Description:
- *     If @sdevscan is for a SCSI-3 or up device, send a REPORT LUN
- *     command, and scan the resulting list of LUNs by calling
- *     scsi_probe_and_add_lun.
- *
- *     Modifies sdevscan->lun.
+ *   Fast scanning for modern (SCSI-3) devices by sending a REPORT LUN command.
+ *   Scan the resulting list of LUNs by calling scsi_probe_and_add_lun.
+ *
+ *   If BLINK_REPORTLUN2 is set, scan a target that supports more than 8
+ *   LUNs even if it's older than SCSI-3.
+ *   If BLIST_NOREPORTLUN is set, return 1 always.
+ *   If BLIST_NOLUN is set, return 0 always.
  *
  * Return:
  *     0: scan completed (or no memory, so further scanning is futile)
- *     1: no report lun scan, or not configured
+ *     1: could not scan with REPORT LUN
  **/
 static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)
diff -r a868e8217782 drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_fc.c	Mon Oct 29 05:10:03 2007 -0500
@@ -481,9 +481,9 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " exceeded, the scsi target is removed. Value should be"
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
 
-/**
+/*
  * Netlink Infrastructure
- **/
+ */
 
 static atomic_t fc_event_seq;
 
@@ -491,10 +491,10 @@ static atomic_t fc_event_seq;
  * fc_get_event_number - Obtain the next sequential FC event number
  *
  * Notes:
- *   We could have inline'd this, but it would have required fc_event_seq to
+ *   We could have inlined this, but it would have required fc_event_seq to
  *   be exposed. For now, live with the subroutine call.
  *   Atomic used to avoid lock/unlock...
- **/
+ */
 u32
 fc_get_event_number(void)
 {
@@ -505,7 +505,6 @@ EXPORT_SYMBOL(fc_get_event_number);
 
 /**
  * fc_host_post_event - called to post an even on an fc_host.
- *
  * @shost:		host the event occurred on
  * @event_number:	fc event number obtained from get_fc_event_number()
  * @event_code:		fc_host event being posted
@@ -513,7 +512,7 @@ EXPORT_SYMBOL(fc_get_event_number);
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 void
 fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
 		enum fc_host_event_code event_code, u32 event_data)
@@ -579,17 +578,16 @@ EXPORT_SYMBOL(fc_host_post_event);
 
 
 /**
- * fc_host_post_vendor_event - called to post a vendor unique event on
- *                             a fc_host
- *
+ * fc_host_post_vendor_event - called to post a vendor unique event on an fc_host
  * @shost:		host the event occurred on
  * @event_number:	fc event number obtained from get_fc_event_number()
  * @data_len:		amount, in bytes, of vendor unique data
  * @data_buf:		pointer to vendor unique data
+ * @vendor_id:          Vendor id
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 void
 fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 		u32 data_len, char * data_buf, u64 vendor_id)
@@ -1900,7 +1898,6 @@ static int fc_vport_match(struct attribu
 
 /**
  * fc_timed_out - FC Transport I/O timeout intercept handler
- *
  * @scmd:	The SCSI command which timed out
  *
  * This routine protects against error handlers getting invoked while a
@@ -1920,7 +1917,7 @@ static int fc_vport_match(struct attribu
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 static enum scsi_eh_timer_return
 fc_timed_out(struct scsi_cmnd *scmd)
 {
@@ -2133,7 +2130,7 @@ EXPORT_SYMBOL(fc_release_transport);
  * 	1 - work queued for execution
  *	0 - work is already queued
  *	-EINVAL - work queue doesn't exist
- **/
+ */
 static int
 fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 {
@@ -2152,7 +2149,7 @@ fc_queue_work(struct Scsi_Host *shost, s
 /**
  * fc_flush_work - Flush a fc_host's workqueue.
  * @shost:	Pointer to Scsi_Host bound to fc_host.
- **/
+ */
 static void
 fc_flush_work(struct Scsi_Host *shost)
 {
@@ -2175,7 +2172,7 @@ fc_flush_work(struct Scsi_Host *shost)
  *
  * Return value:
  * 	1 on success / 0 already queued / < 0 for error
- **/
+ */
 static int
 fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
 				unsigned long delay)
@@ -2195,7 +2192,7 @@ fc_queue_devloss_work(struct Scsi_Host *
 /**
  * fc_flush_devloss - Flush a fc_host's devloss workqueue.
  * @shost:	Pointer to Scsi_Host bound to fc_host.
- **/
+ */
 static void
 fc_flush_devloss(struct Scsi_Host *shost)
 {
@@ -2212,21 +2209,20 @@ fc_flush_devloss(struct Scsi_Host *shost
 
 
 /**
- * fc_remove_host - called to terminate any fc_transport-related elements
- *                  for a scsi host.
- * @rport:	remote port to be unblocked.
+ * fc_remove_host - called to terminate any fc_transport-related elements for a scsi host.
+ * @shost:	Which &Scsi_Host
  *
  * This routine is expected to be called immediately preceeding the
  * a driver's call to scsi_remove_host().
  *
  * WARNING: A driver utilizing the fc_transport, which fails to call
- *   this routine prior to scsi_remote_host(), will leave dangling
+ *   this routine prior to scsi_remove_host(), will leave dangling
  *   objects in /sys/class/fc_remote_ports. Access to any of these
  *   objects can result in a system crash !!!
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 void
 fc_remove_host(struct Scsi_Host *shost)
 {
@@ -2281,10 +2277,10 @@ EXPORT_SYMBOL(fc_remove_host);
 
 /**
  * fc_starget_delete - called to delete the scsi decendents of an rport
- *                  (target and all sdevs)
- *
  * @work:	remote port to be operated on.
- **/
+ *
+ * Deletes target and all sdevs.
+ */
 static void
 fc_starget_delete(struct work_struct *work)
 {
@@ -2303,9 +2299,8 @@ fc_starget_delete(struct work_struct *wo
 
 /**
  * fc_rport_final_delete - finish rport termination and delete it.
- *
  * @work:	remote port to be deleted.
- **/
+ */
 static void
 fc_rport_final_delete(struct work_struct *work)
 {
@@ -2375,7 +2370,7 @@ fc_rport_final_delete(struct work_struct
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 static struct fc_rport *
 fc_rport_create(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
@@ -2462,8 +2457,7 @@ delete_rport:
 }
 
 /**
- * fc_remote_port_add - notifies the fc transport of the existence
- *		of a remote FC port.
+ * fc_remote_port_add - notify fc transport of the existence of a remote FC port.
  * @shost:	scsi host the remote port is connected to.
  * @channel:	Channel on shost port connected to.
  * @ids:	The world wide names, fc address, and FC4 port
@@ -2499,7 +2493,7 @@ delete_rport:
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 struct fc_rport *
 fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
@@ -2683,19 +2677,18 @@ EXPORT_SYMBOL(fc_remote_port_add);
 
 
 /**
- * fc_remote_port_delete - notifies the fc transport that a remote
- *		port is no longer in existence.
+ * fc_remote_port_delete - notifies the fc transport that a remote port is no longer in existence.
  * @rport:	The remote port that no longer exists
  *
  * The LLDD calls this routine to notify the transport that a remote
  * port is no longer part of the topology. Note: Although a port
  * may no longer be part of the topology, it may persist in the remote
  * ports displayed by the fc_host. We do this under 2 conditions:
- * - If the port was a scsi target, we delay its deletion by "blocking" it.
+ * 1) If the port was a scsi target, we delay its deletion by "blocking" it.
  *   This allows the port to temporarily disappear, then reappear without
  *   disrupting the SCSI device tree attached to it. During the "blocked"
  *   period the port will still exist.
- * - If the port was a scsi target and disappears for longer than we
+ * 2) If the port was a scsi target and disappears for longer than we
  *   expect, we'll delete the port and the tear down the SCSI device tree
  *   attached to it. However, we want to semi-persist the target id assigned
  *   to that port if it eventually does exist. The port structure will
@@ -2709,7 +2702,8 @@ EXPORT_SYMBOL(fc_remote_port_add);
  * temporary blocked state. From the LLDD's perspective, the rport no
  * longer exists. From the SCSI midlayer's perspective, the SCSI target
  * exists, but all sdevs on it are blocked from further I/O. The following
- * is then expected:
+ * is then expected.
+ *
  *   If the remote port does not return (signaled by a LLDD call to
  *   fc_remote_port_add()) within the dev_loss_tmo timeout, then the
  *   scsi target is removed - killing all outstanding i/o and removing the
@@ -2731,7 +2725,7 @@ EXPORT_SYMBOL(fc_remote_port_add);
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
@@ -2792,12 +2786,12 @@ EXPORT_SYMBOL(fc_remote_port_delete);
 EXPORT_SYMBOL(fc_remote_port_delete);
 
 /**
- * fc_remote_port_rolechg - notifies the fc transport that the roles
- *		on a remote may have changed.
+ * fc_remote_port_rolechg - notifies the fc transport that the roles on a remote may have changed.
  * @rport:	The remote port that changed.
- *
- * The LLDD calls this routine to notify the transport that the roles
- * on a remote port may have changed. The largest effect of this is
+ * @roles:      New roles for this port.
+ *
+ * Description: The LLDD calls this routine to notify the transport that the
+ * roles on a remote port may have changed. The largest effect of this is
  * if a port now becomes a FCP Target, it must be allocated a
  * scsi target id.  If the port is no longer a FCP target, any
  * scsi target id value assigned to it will persist in case the
@@ -2810,7 +2804,7 @@ EXPORT_SYMBOL(fc_remote_port_delete);
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 void
 fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 {
@@ -2875,12 +2869,12 @@ EXPORT_SYMBOL(fc_remote_port_rolechg);
 EXPORT_SYMBOL(fc_remote_port_rolechg);
 
 /**
- * fc_timeout_deleted_rport - Timeout handler for a deleted remote port,
- * 			which we blocked, and has now failed to return
- * 			in the allotted time.
- *
+ * fc_timeout_deleted_rport - Timeout handler for a deleted remote port.
  * @work:	rport target that failed to reappear in the allotted time.
- **/
+ *
+ * Description: An attempt to delete a remote port blocks, and if it fails
+ *              to return in the allotted time this gets called.
+ */
 static void
 fc_timeout_deleted_rport(struct work_struct *work)
 {
@@ -2984,14 +2978,12 @@ fc_timeout_deleted_rport(struct work_str
 }
 
 /**
- * fc_timeout_fail_rport_io - Timeout handler for a fast io failing on a
- *                       disconnected SCSI target.
- *
+ * fc_timeout_fail_rport_io - Timeout handler for a fast io failing on a disconnected SCSI target.
  * @work:	rport to terminate io on.
  *
  * Notes: Only requests the failure of the io, not that all are flushed
  *    prior to returning.
- **/
+ */
 static void
 fc_timeout_fail_rport_io(struct work_struct *work)
 {
@@ -3008,9 +3000,8 @@ fc_timeout_fail_rport_io(struct work_str
 
 /**
  * fc_scsi_scan_rport - called to perform a scsi scan on a remote port.
- *
  * @work:	remote port to be scanned.
- **/
+ */
 static void
 fc_scsi_scan_rport(struct work_struct *work)
 {
@@ -3047,7 +3038,7 @@ fc_scsi_scan_rport(struct work_struct *w
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 static int
 fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
 	struct fc_vport_identifiers  *ids, struct fc_vport **ret_vport)
@@ -3172,7 +3163,7 @@ delete_vport:
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
- **/
+ */
 int
 fc_vport_terminate(struct fc_vport *vport)
 {
@@ -3232,9 +3223,8 @@ EXPORT_SYMBOL(fc_vport_terminate);
 
 /**
  * fc_vport_sched_delete - workq-based delete request for a vport
- *
  * @work:	vport to be deleted.
- **/
+ */
 static void
 fc_vport_sched_delete(struct work_struct *work)
 {
diff -r a868e8217782 drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_iscsi.c	Mon Oct 29 05:10:03 2007 -0500
@@ -328,9 +328,10 @@ EXPORT_SYMBOL_GPL(iscsi_add_session);
  * iscsi_create_session - create iscsi class session
  * @shost: scsi host
  * @transport: iscsi transport
+ * @target_id: which target
  *
  * This can be called from a LLD or iscsi_transport.
- **/
+ */
 struct iscsi_cls_session *
 iscsi_create_session(struct Scsi_Host *shost,
 		     struct iscsi_transport *transport,
@@ -382,7 +383,7 @@ EXPORT_SYMBOL_GPL(iscsi_free_session);
  *
  * Can be called by a LLD or iscsi_transport. There must not be
  * any running connections.
- **/
+ */
 int iscsi_destroy_session(struct iscsi_cls_session *session)
 {
 	iscsi_remove_session(session);
@@ -418,7 +419,7 @@ static int iscsi_is_conn_dev(const struc
  * for software iscsi we could be trying to preallocate a connection struct
  * in which case there could be two connection structs and cid would be
  * non-zero.
- **/
+ */
 struct iscsi_cls_conn *
 iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
 {
@@ -465,10 +466,10 @@ EXPORT_SYMBOL_GPL(iscsi_create_conn);
 
 /**
  * iscsi_destroy_conn - destroy iscsi class connection
- * @session: iscsi cls session
+ * @conn: iscsi cls session
  *
- * This can be called from a LLD or iscsi_transport.
- **/
+ * This can be called from an LLD or iscsi_transport.
+ */
 int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 {
 	transport_unregister_device(&conn->dev);
@@ -690,7 +691,7 @@ iscsi_if_get_stats(struct iscsi_transpor
  *
  * This is called by HW iscsi LLDs to notify userpsace that its HW has
  * removed a session.
- **/
+ */
 int iscsi_if_destroy_session_done(struct iscsi_cls_conn *conn)
 {
 	struct iscsi_internal *priv;
@@ -751,7 +752,7 @@ EXPORT_SYMBOL_GPL(iscsi_if_destroy_sessi
  *
  * This is called by HW iscsi LLDs to notify userpsace that its HW has
  * created a session or a existing session is back in the logged in state.
- **/
+ */
 int iscsi_if_create_session_done(struct iscsi_cls_conn *conn)
 {
 	struct iscsi_internal *priv;
diff -r a868e8217782 drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_sas.c	Mon Oct 29 05:10:03 2007 -0500
@@ -323,7 +323,7 @@ static int do_sas_phy_delete(struct devi
 }
 
 /**
- * sas_remove_children  --  tear down a devices SAS data structures
+ * sas_remove_children  -  tear down a devices SAS data structures
  * @dev:	device belonging to the sas object
  *
  * Removes all SAS PHYs and remote PHYs for a given object
@@ -336,7 +336,7 @@ EXPORT_SYMBOL(sas_remove_children);
 EXPORT_SYMBOL(sas_remove_children);
 
 /**
- * sas_remove_host  --  tear down a Scsi_Host's SAS data structures
+ * sas_remove_host  -  tear down a Scsi_Host's SAS data structures
  * @shost:	Scsi Host that is torn down
  *
  * Removes all SAS PHYs and remote PHYs for a given Scsi_Host.
@@ -577,7 +577,7 @@ static void sas_phy_release(struct devic
 }
 
 /**
- * sas_phy_alloc  --  allocates and initialize a SAS PHY structure
+ * sas_phy_alloc  -  allocates and initialize a SAS PHY structure
  * @parent:	Parent device
  * @number:	Phy index
  *
@@ -618,7 +618,7 @@ EXPORT_SYMBOL(sas_phy_alloc);
 EXPORT_SYMBOL(sas_phy_alloc);
 
 /**
- * sas_phy_add  --  add a SAS PHY to the device hierarchy
+ * sas_phy_add  -  add a SAS PHY to the device hierarchy
  * @phy:	The PHY to be added
  *
  * Publishes a SAS PHY to the rest of the system.
@@ -638,7 +638,7 @@ EXPORT_SYMBOL(sas_phy_add);
 EXPORT_SYMBOL(sas_phy_add);
 
 /**
- * sas_phy_free  --  free a SAS PHY
+ * sas_phy_free  -  free a SAS PHY
  * @phy:	SAS PHY to free
  *
  * Frees the specified SAS PHY.
@@ -655,7 +655,7 @@ EXPORT_SYMBOL(sas_phy_free);
 EXPORT_SYMBOL(sas_phy_free);
 
 /**
- * sas_phy_delete  --  remove SAS PHY
+ * sas_phy_delete  -  remove SAS PHY
  * @phy:	SAS PHY to remove
  *
  * Removes the specified SAS PHY.  If the SAS PHY has an
@@ -677,7 +677,7 @@ EXPORT_SYMBOL(sas_phy_delete);
 EXPORT_SYMBOL(sas_phy_delete);
 
 /**
- * scsi_is_sas_phy  --  check if a struct device represents a SAS PHY
+ * scsi_is_sas_phy  -  check if a struct device represents a SAS PHY
  * @dev:	device to check
  *
  * Returns:
@@ -843,7 +843,6 @@ EXPORT_SYMBOL(sas_port_alloc_num);
 
 /**
  * sas_port_add - add a SAS port to the device hierarchy
- *
  * @port:	port to be added
  *
  * publishes a port to the rest of the system
@@ -868,7 +867,7 @@ EXPORT_SYMBOL(sas_port_add);
 EXPORT_SYMBOL(sas_port_add);
 
 /**
- * sas_port_free  --  free a SAS PORT
+ * sas_port_free  -  free a SAS PORT
  * @port:	SAS PORT to free
  *
  * Frees the specified SAS PORT.
@@ -885,7 +884,7 @@ EXPORT_SYMBOL(sas_port_free);
 EXPORT_SYMBOL(sas_port_free);
 
 /**
- * sas_port_delete  --  remove SAS PORT
+ * sas_port_delete  -  remove SAS PORT
  * @port:	SAS PORT to remove
  *
  * Removes the specified SAS PORT.  If the SAS PORT has an
@@ -924,7 +923,7 @@ EXPORT_SYMBOL(sas_port_delete);
 EXPORT_SYMBOL(sas_port_delete);
 
 /**
- * scsi_is_sas_port --  check if a struct device represents a SAS port
+ * scsi_is_sas_port -  check if a struct device represents a SAS port
  * @dev:	device to check
  *
  * Returns:
@@ -1309,6 +1308,7 @@ static void sas_rphy_initialize(struct s
 
 /**
  * sas_end_device_alloc - allocate an rphy for an end device
+ * @parent: which port
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
  *
@@ -1345,6 +1345,8 @@ EXPORT_SYMBOL(sas_end_device_alloc);
 
 /**
  * sas_expander_alloc - allocate an rphy for an end device
+ * @parent: which port
+ * @type: SAS_EDGE_EXPANDER_DEVICE or SAS_FANOUT_EXPANDER_DEVICE
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
  *
@@ -1383,7 +1385,7 @@ EXPORT_SYMBOL(sas_expander_alloc);
 EXPORT_SYMBOL(sas_expander_alloc);
 
 /**
- * sas_rphy_add  --  add a SAS remote PHY to the device hierarchy
+ * sas_rphy_add  -  add a SAS remote PHY to the device hierarchy
  * @rphy:	The remote PHY to be added
  *
  * Publishes a SAS remote PHY to the rest of the system.
@@ -1430,8 +1432,8 @@ EXPORT_SYMBOL(sas_rphy_add);
 EXPORT_SYMBOL(sas_rphy_add);
 
 /**
- * sas_rphy_free  --  free a SAS remote PHY
- * @rphy	SAS remote PHY to free
+ * sas_rphy_free  -  free a SAS remote PHY
+ * @rphy: SAS remote PHY to free
  *
  * Frees the specified SAS remote PHY.
  *
@@ -1459,7 +1461,7 @@ EXPORT_SYMBOL(sas_rphy_free);
 EXPORT_SYMBOL(sas_rphy_free);
 
 /**
- * sas_rphy_delete  --  remove and free SAS remote PHY
+ * sas_rphy_delete  -  remove and free SAS remote PHY
  * @rphy:	SAS remote PHY to remove and free
  *
  * Removes the specified SAS remote PHY and frees it.
@@ -1473,7 +1475,7 @@ EXPORT_SYMBOL(sas_rphy_delete);
 EXPORT_SYMBOL(sas_rphy_delete);
 
 /**
- * sas_rphy_remove  --  remove SAS remote PHY
+ * sas_rphy_remove  -  remove SAS remote PHY
  * @rphy:	SAS remote phy to remove
  *
  * Removes the specified SAS remote PHY.
@@ -1504,7 +1506,7 @@ EXPORT_SYMBOL(sas_rphy_remove);
 EXPORT_SYMBOL(sas_rphy_remove);
 
 /**
- * scsi_is_sas_rphy  --  check if a struct device represents a SAS remote PHY
+ * scsi_is_sas_rphy  -  check if a struct device represents a SAS remote PHY
  * @dev:	device to check
  *
  * Returns:
@@ -1604,7 +1606,7 @@ static int sas_user_scan(struct Scsi_Hos
 	SETUP_TEMPLATE(expander_attrs, expander_##field, S_IRUGO, 1)
 
 /**
- * sas_attach_transport  --  instantiate SAS transport template
+ * sas_attach_transport  -  instantiate SAS transport template
  * @ft:		SAS transport class function template
  */
 struct scsi_transport_template *
@@ -1715,7 +1717,7 @@ EXPORT_SYMBOL(sas_attach_transport);
 EXPORT_SYMBOL(sas_attach_transport);
 
 /**
- * sas_release_transport  --  release SAS transport template instance
+ * sas_release_transport  -  release SAS transport template instance
  * @t:		transport template instance
  */
 void sas_release_transport(struct scsi_transport_template *t)
diff -r a868e8217782 drivers/scsi/scsi_transport_srp.c
--- a/drivers/scsi/scsi_transport_srp.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_srp.c	Mon Oct 29 05:10:03 2007 -0500
@@ -242,8 +242,8 @@ EXPORT_SYMBOL_GPL(srp_rport_add);
 EXPORT_SYMBOL_GPL(srp_rport_add);
 
 /**
- * srp_rport_del  --  remove a SRP remote port
- * @port:	SRP remote port to remove
+ * srp_rport_del  -  remove a SRP remote port
+ * @rport:	SRP remote port to remove
  *
  * Removes the specified SRP remote port.
  */
@@ -270,7 +270,7 @@ static int do_srp_rport_del(struct devic
 }
 
 /**
- * srp_remove_host  --  tear down a Scsi_Host's SRP data structures
+ * srp_remove_host  -  tear down a Scsi_Host's SRP data structures
  * @shost:	Scsi Host that is torn down
  *
  * Removes all SRP remote ports for a given Scsi_Host.
@@ -296,7 +296,7 @@ static int srp_it_nexus_response(struct 
 }
 
 /**
- * srp_attach_transport  --  instantiate SRP transport template
+ * srp_attach_transport  -  instantiate SRP transport template
  * @ft:		SRP transport class function template
  */
 struct scsi_transport_template *
@@ -336,7 +336,7 @@ EXPORT_SYMBOL_GPL(srp_attach_transport);
 EXPORT_SYMBOL_GPL(srp_attach_transport);
 
 /**
- * srp_release_transport  --  release SRP transport template instance
+ * srp_release_transport  -  release SRP transport template instance
  * @t:		transport template instance
  */
 void srp_release_transport(struct scsi_transport_template *t)
diff -r a868e8217782 drivers/scsi/scsicam.c
--- a/drivers/scsi/scsicam.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsicam.c	Mon Oct 29 05:10:03 2007 -0500
@@ -24,6 +24,14 @@ static int setsize(unsigned long capacit
 static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs);
 
+/**
+ * scsi_bios_ptable - Read PC partition table out of first sector of device.
+ * @dev: from this device
+ *
+ * Description: Reads the first sector from the device and returns %0x42 bytes
+ *              starting at offset %0x1be.
+ * Returns: partition table in kmalloc(GFP_KERNEL) memory, or NULL on error.
+ */
 unsigned char *scsi_bios_ptable(struct block_device *dev)
 {
 	unsigned char *res = kmalloc(66, GFP_KERNEL);
@@ -43,15 +51,17 @@ unsigned char *scsi_bios_ptable(struct b
 }
 EXPORT_SYMBOL(scsi_bios_ptable);
 
-/*
- * Function : int scsicam_bios_param (struct block_device *bdev, ector_t capacity, int *ip)
- *
- * Purpose : to determine the BIOS mapping used for a drive in a 
+/**
+ * scsicam_bios_param - Determine geometry of a disk in cylinders/heads/sectors.
+ * @bdev: which device
+ * @capacity: size of the disk in sectors
+ * @ip: return value: ip[0]=heads, ip[1]=sectors, ip[2]=cylinders
+ *
+ * Description : determine the BIOS mapping/geometry used for a drive in a
  *      SCSI-CAM system, storing the results in ip as required
  *      by the HDIO_GETGEO ioctl().
  *
  * Returns : -1 on failure, 0 on success.
- *
  */
 
 int scsicam_bios_param(struct block_device *bdev, sector_t capacity, int *ip)
@@ -98,15 +108,18 @@ int scsicam_bios_param(struct block_devi
 }
 EXPORT_SYMBOL(scsicam_bios_param);
 
-/*
- * Function : static int scsi_partsize(unsigned char *buf, unsigned long 
- *     capacity,unsigned int *cyls, unsigned int *hds, unsigned int *secs);
- *
- * Purpose : to determine the BIOS mapping used to create the partition
+/**
+ * scsi_partsize - Parse cylinders/heads/sectors from PC partition table
+ * @buf: partition table, see scsi_bios_ptable()
+ * @capacity: size of the disk in sectors
+ * @cyls: put cylinders here
+ * @hds: put heads here
+ * @secs: put sectors here
+ *
+ * Description: determine the BIOS mapping/geometry used to create the partition
  *      table, storing the results in *cyls, *hds, and *secs 
  *
- * Returns : -1 on failure, 0 on success.
- *
+ * Returns: -1 on failure, 0 on success.
  */
 
 int scsi_partsize(unsigned char *buf, unsigned long capacity,
@@ -194,7 +207,7 @@ EXPORT_SYMBOL(scsi_partsize);
  *
  * WORKING                                                    X3T9.2
  * DRAFT                                                        792D
- *
+ * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
  *
  *                                                        Revision 6
  *                                                         10-MAR-94

--Boundary-00=_7HbJHNzaBrEWmlc--
