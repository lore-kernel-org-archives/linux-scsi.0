From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 23:39:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924233941.A9952@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020924123250.A5890@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 24, 2002 at 12:32:50PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Ok, as promised here's the first patch.

This completely solves the door locking issues for host drivers that
use the new error handling code, and preserves the old behaviour for
drivers that use the old error handler.  If I decide to resurect my
old WD33C93 card, I'll look at the old error handler issues.

The patch is arranged so that you can read the notes in order, and
the patch in order, and the two tie up.  Please take the time to read
the whole thing.

I don't recommend incorporating this into mainline currently; there
are a few minor build issues with it that I'd like to get cleaned up
first (for example, a missing function prototype.)  At this point,
I think it is more important to get this looked over, and to provide
a basis for ideas.

Please note that this patch is against vanilla 2.4.19.

The ideas and method behind this came out of discussion with James
Bottomley.  James should therefore take some credit for this.

1. We introduce a new per-device flag - "locked".  When this flag is
   set, it means that user space wanted the door locked, and we have
   successfully locked it.  When clear, it means something user space
   wanted the door unlocked, and we have successfully unlocked it.

2. Introduce "scsi_set_medium_removal".  This handles all door locking
   and unlocking requests that essentially originate from user space.
   ie, when a device is opened or closed, or an ioctl is received.
   This function takes care of issuing the ALLOW_MEDIUM_REMOVAL command
   via the ioctl layers.

   This function ins't really anything new; its existing code moved
   into a function.  It also removes code duplication.

   The new bit is what it does after the command has completed.  If
   the command was successful, we update the device "locked" flag to
   indicate the new state.

3. Rather than indirecting via scsi_ioctl() from the various drivers,
   we now call scsi_set_medium_removal directly.

So far so good; the above changes are all about tracking the current
door lock state.  Now for its use.  We use it in two places.  Ideally,
this should become one place in the long run.

4. The "new" error handling code.  Just before we attempt to restart
   operations on a host in scsi_restart_operations(), we loop through
   all devices on the host.  At this point, we don't have much idea
   which devices received a reset.

   Any device that is online (something the old code never checked for)
   and was locked, we try to re-lock the door.  Note how we handle this.
   We create a request structure, and fill in all the relevant values,
   and insert this request at the _head_ of the queue.

   The requests done function merely frees the command.  If the command
   fails, we can't really do much to recover from it.  We could retry,
   but the generic SCSI command handling will have done that for us
   already.

5. The "old" code.  Yes, suggestion: read the comment.  Since we have
   the "new" error handling code in place, we must not to lock the
   door while processing requests.  If we do, we'll certainly deadlock.

   However, we do take note of the currently requested lock state, and
   only ask for the door to be locked if it was previously locked.

Now, as I say, this is only _half_ of my fixes.  This fixes the SCSI
door locking problem.  It doesn't fix the complete bus hangs when the
new error handing kicks in, fails, and takes devices off line.  We'll
deal with that can of worms when we've got this one out of the way.

diff -u orig/drivers/scsi/scsi.h linux-rpc/drivers/scsi/scsi.h
--- orig/drivers/scsi/scsi.h	Mon Aug  5 13:31:23 2002
+++ linux-rpc/drivers/scsi/scsi.h	Tue Sep 24 15:57:54 2002
@@ -597,6 +597,7 @@
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
 	unsigned lockable:1;	/* Able to prevent media removal */
+	unsigned locked:1;	/* Media removal disabled */
 	unsigned borken:1;	/* Tell the Seagate driver to be 
 				 * painfully slow on this device */
 	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
diff -u orig/drivers/scsi/scsi_ioctl.c linux-rpc/drivers/scsi/scsi_ioctl.c
--- orig/drivers/scsi/scsi_ioctl.c	Mon Aug  5 13:31:24 2002
+++ linux-rpc/drivers/scsi/scsi_ioctl.c	Tue Sep 24 16:38:24 2002
@@ -153,6 +153,29 @@
 	return result;
 }
 
+int scsi_set_medium_removal(Scsi_Device *dev, char state)
+{
+	char scsi_cmd[MAX_COMMAND_SIZE];
+	int ret;
+
+	if (!dev->removable || !dev->lockable)
+		return 0;
+
+	scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;
+	scsi_cmd[1] = (dev->scsi_level <= SCSI_2) ? (dev->lun << 5) : 0;
+	scsi_cmd[2] = 0;
+	scsi_cmd[3] = 0;
+	scsi_cmd[4] = state;
+	scsi_cmd[5] = 0;
+
+	ret = ioctl_internal_command(dev, scsi_cmd, IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
+
+	if (ret == 0)
+		dev->locked = state == SCSI_REMOVAL_PREVENT;
+
+	return ret;
+}
+
 /*
  * This interface is depreciated - users should use the scsi generic (sg)
  * interface instead, as this is a more flexible approach to performing
@@ -449,24 +472,9 @@
 		return scsi_ioctl_send_command((Scsi_Device *) dev,
 					     (Scsi_Ioctl_Command *) arg);
 	case SCSI_IOCTL_DOORLOCK:
-		if (!dev->removable || !dev->lockable)
-			return 0;
-		scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;
-		scsi_cmd[1] = cmd_byte1;
-		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
-		scsi_cmd[4] = SCSI_REMOVAL_PREVENT;
-		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
-				   IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
-		break;
+		return scsi_set_medium_removal(dev, SCSI_REMOVAL_PREVENT);
 	case SCSI_IOCTL_DOORUNLOCK:
-		if (!dev->removable || !dev->lockable)
-			return 0;
-		scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;
-		scsi_cmd[1] = cmd_byte1;
-		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
-		scsi_cmd[4] = SCSI_REMOVAL_ALLOW;
-		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
-				   IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
+		return scsi_set_medium_removal(dev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		scsi_cmd[0] = TEST_UNIT_READY;
 		scsi_cmd[1] = cmd_byte1;
diff -u orig/drivers/scsi/sd.c linux-rpc/drivers/scsi/sd.c
--- orig/drivers/scsi/sd.c	Mon Aug  5 13:31:25 2002
+++ linux-rpc/drivers/scsi/sd.c	Tue Sep 24 16:07:45 2002
@@ -524,7 +524,7 @@
 	if (SDev->removable)
 		if (SDev->access_count==1)
 			if (scsi_block_when_processing_errors(SDev))
-				scsi_ioctl(SDev, SCSI_IOCTL_DOORLOCK, NULL);
+				scsi_set_medium_removal(SDev, SCSI_REMOVAL_PREVENT);
 
 	
 	return 0;
@@ -553,7 +553,7 @@
 	if (SDev->removable) {
 		if (!SDev->access_count)
 			if (scsi_block_when_processing_errors(SDev))
-				scsi_ioctl(SDev, SCSI_IOCTL_DOORUNLOCK, NULL);
+				scsi_set_medium_removal(SDev, SCSI_REMOVAL_ALLOW);
 	}
 	if (SDev->host->hostt->module)
 		__MOD_DEC_USE_COUNT(SDev->host->hostt->module);
diff -u orig/drivers/scsi/sr_ioctl.c linux-rpc/drivers/scsi/sr_ioctl.c
--- orig/drivers/scsi/sr_ioctl.c	Mon Aug  5 13:31:26 2002
+++ linux-rpc/drivers/scsi/sr_ioctl.c	Tue Sep 24 16:09:08 2002
@@ -216,9 +216,8 @@
 
 int sr_lock_door(struct cdrom_device_info *cdi, int lock)
 {
-	return scsi_ioctl(scsi_CDs[MINOR(cdi->dev)].device,
-		      lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK,
-			  0);
+	return scsi_set_medium_removal(scsi_CDs[MINOR(cdi->dev)].device,
+		      lock ? SCSI_REMOVAL_PREVENT : SCSI_REMOVAL_ALLOW);
 }
 
 int sr_drive_status(struct cdrom_device_info *cdi, int slot)
diff -u orig/drivers/scsi/scsi_error.c linux-rpc/drivers/scsi/scsi_error.c
--- orig/drivers/scsi/scsi_error.c	Mon Aug  5 13:31:24 2002
+++ linux-rpc/drivers/scsi/scsi_error.c	Tue Sep 24 17:03:58 2002
@@ -35,6 +35,8 @@
 #include "hosts.h"
 #include "constants.h"
 
+#include <scsi/scsi_ioctl.h> /* grr */
+
 /*
  * We must always allow SHUTDOWN_SIGS.  Even if we are not a module,
  * the host drivers that we are using may be loaded as modules, and
@@ -1219,6 +1221,43 @@
 }
 
 
+static void scsi_eh_lock_done(struct scsi_cmnd *SCpnt)
+{
+	struct scsi_request *SRpnt = SCpnt->sc_request;
+
+	SCpnt->sc_request = NULL;
+	SRpnt->sr_command = NULL;
+
+	scsi_release_command(SCpnt);
+	scsi_release_request(SRpnt);
+}
+
+STATIC void scsi_eh_lock_door(struct scsi_device *dev)
+{
+	struct scsi_request *SRpnt = scsi_allocate_request(dev);
+
+	if (SRpnt == NULL) {
+		/* what now? */
+		return;
+	}
+
+	SRpnt->sr_cmnd[0] = ALLOW_MEDIUM_REMOVAL;
+	SRpnt->sr_cmnd[1] = (dev->scsi_level <= SCSI_2) ? (dev->lun << 5) : 0;
+	SRpnt->sr_cmnd[2] = 0;
+	SRpnt->sr_cmnd[3] = 0;
+	SRpnt->sr_cmnd[4] = SCSI_REMOVAL_PREVENT;
+	SRpnt->sr_cmnd[5] = 0;
+	SRpnt->sr_data_direction = SCSI_DATA_NONE;
+	SRpnt->sr_bufflen = 0;
+	SRpnt->sr_buffer = NULL;
+	SRpnt->sr_allowed = 5;
+	SRpnt->sr_done = scsi_eh_lock_done;
+	SRpnt->sr_timeout_per_command = 10 * HZ;
+	SRpnt->sr_cmd_len = COMMAND_SIZE(SRpnt->sr_cmnd[0]);
+
+	scsi_insert_special_req(SRpnt, 1);
+}
+
 /*
  * Function:  scsi_restart_operations
  *
@@ -1241,6 +1280,18 @@
 	ASSERT_LOCK(&io_request_lock, 0);
 
 	/*
+	 * If the door was locked, we need to insert a door lock request
+	 * onto the head of the SCSI request queue for the device.  There
+	 * is no point trying to lock the door of an off-line device.
+	 */
+	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next) {
+		if (!SDpnt->online || !SDpnt->locked)
+			continue;
+
+		scsi_eh_lock_door(SDpnt);
+	}
+
+	/*
 	 * Next free up anything directly waiting upon the host.  This will be
 	 * requests for character device operations, and also for ioctls to queued
 	 * block devices.
diff -u orig/drivers/scsi/scsi_lib.c linux-rpc/drivers/scsi/scsi_lib.c
--- orig/drivers/scsi/scsi_lib.c	Mon Aug  5 13:31:24 2002
+++ linux-rpc/drivers/scsi/scsi_lib.c	Tue Sep 24 17:27:00 2002
@@ -901,8 +926,17 @@
 		 * space.   Technically the error handling thread should be
 		 * doing this crap, but the error handler isn't used by
 		 * most hosts.
+		 *
+		 * (rmk)
+		 * Trying to lock the door can cause deadlocks.  We therefore
+		 * only use this for old hosts; our door locking is now done
+		 * by the error handler in scsi_restart_operations for new
+		 * eh hosts.
+		 *
+		 * Note that we don't clear was_reset here; this is used by
+		 * st.c, and either one or other has to die.
 		 */
-		if (SDpnt->was_reset) {
+		if (SHpnt->hostt->use_new_eh_code == 0 && SDpnt->was_reset) {
 			/*
 			 * We need to relock the door, but we might
 			 * be in an interrupt handler.  Only do this
@@ -913,7 +947,7 @@
 			 * this work.
 			 */
 			SDpnt->was_reset = 0;
-			if (SDpnt->removable && !in_interrupt()) {
+			if (SDpnt->removable && SDpnt->locked && !in_interrupt()) {
 				spin_unlock_irq(&io_request_lock);
 				scsi_ioctl(SDpnt, SCSI_IOCTL_DOORLOCK, 0);
 				spin_lock_irq(&io_request_lock);


-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

