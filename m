From: Alan Stern <stern@rowland.harvard.edu>
Subject: Bugs in scsi system, need help to fix
Date: Sat, 12 Apr 2003 16:10:03 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304121546330.3290-100000@netrider.rowland.org>
References: <3E982DDE.7010002@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:18959 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S263388AbTDLT6R (for <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Apr 2003 15:58:17 -0400
In-Reply-To: <3E982DDE.7010002@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

While tracking down some problems involving usb-storage, I traced them to
a couple of bugs in the scsi system.  Unfortunately, I don't know enough
about how things are supposed to work to fix them; I'm hoping to attract
some help.

The first problem is in the error-handling code in scsi_error.c.  The
scsi_eh_lock_done() function is the callback for a special request
inserted at the beginning of the queue while restarting normal operations.  
(It locks the drive's door.)  But this function does not call
scsi_io_completion(), scsi_end_request(), or scsi_queue_next_request(),
with the result that the device's request queue stops once the door-lock
command has been processed.  The callback needs to do _something_ to keep
the queue going, but I don't know what.

Maybe I'm wrong about that, and the problem doesn't lie in 
scsi_eh_lock_done().  But there is no doubt that at the end of error 
recovery, after the door-lock command finishes up no other commands are 
processed.  Logging just stops after the "Notifying upper driver of 
completion" message.


The second problem is a coding mistake in scsi_check_device_busy(), in
hosts.c.  Here is an excerpt from the source:

---------------

static int scsi_check_device_busy(struct scsi_device *sdev)
{
	struct Scsi_Host *shost = sdev->host;
	struct scsi_cmnd *scmd;
	unsigned long flags;

	/*
	 * Loop over all of the commands associated with the
	 * device.  If any of them are busy, then set the state
	 * back to inactive and bail.
	 */
	spin_lock_irqsave(&sdev->list_lock, flags);
	list_for_each_entry(scmd, &sdev->cmd_list, list) {
		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE)
			goto active;

<snip>

active:
	printk(KERN_ERR "SCSI device not inactive - rq_status=%d, target=%d, "
			"pid=%ld, state=%d, owner=%d.\n",
			scmd->request->rq_status, scmd->device->id,
			scmd->pid, scmd->state, scmd->owner);

(A)	list_for_each_entry(sdev, &shost->my_devices, siblings) {
		list_for_each_entry(scmd, &sdev->cmd_list, list) {
(B)			if (scmd->request->rq_status == RQ_SCSI_DISCONNECTING)
				scmd->request->rq_status = RQ_INACTIVE;
		}
	}

(C)	spin_unlock_irqrestore(&sdev->list_lock, flags);
	printk(KERN_ERR "Device busy???\n");
	return 1;
}

---------------

The line labelled (A) is definitely wrong.  Maybe it doesn't belong there
at all -- I don't see any reason why a function devoted to checking
whether a particular device is busy needs to look at any other devices on
the same host.  Furthermore, line (A) changes the value of the sdev
variable, which means that line (C) unlocks the wrong spinlock.  Finally,
judging from the style of the code earlier on, line (B) needs to test that
scmd->request is non-NULL before dereferencing it.


The third problem is very minor.  In scsi_lib.c, line 716 contains an 
extra blank space at the end of a logging text string, just following a 
\n.  This messes up whatever log message follows, because the severity 
indicator (KERN_ERR or whatever) then doesn't fall at the start of a line.  
Here's the line in question, with a few extra lines of context.

---------------

	if (good_sectors >= 0) {
		SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, %d sectors done.\n",
					      req->nr_sectors, good_sectors));
		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n ", cmd->use_sg));

		if (clear_errors)
			req->errors = 0;

---------------

While I feel perfectly capable of fixing that third bug by myself, I 
certainly need help fixing the first two.

Alan Stern

