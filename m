From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Bugs in scsi system, need help to fix
Date: Sun, 13 Apr 2003 23:23:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414062333.GA11487@beaverton.ibm.com>
References: <3E982DDE.7010002@pacbell.net> <Pine.LNX.4.44L0.0304121546330.3290-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:49804 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262763AbTDNGKC (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 02:10:02 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0304121546330.3290-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> The first problem is in the error-handling code in scsi_error.c.  The
> scsi_eh_lock_done() function is the callback for a special request
> inserted at the beginning of the queue while restarting normal operations.  
> (It locks the drive's door.)  But this function does not call
> scsi_io_completion(), scsi_end_request(), or scsi_queue_next_request(),
> with the result that the device's request queue stops once the door-lock
> command has been processed.  The callback needs to do _something_ to keep
> the queue going, but I don't know what.

The problem you are hitting is related to missing calls to
scsi_queue_next_request. Patrick created a patch in a previous thread:
http://marc.theaimsgroup.com/?l=linux-scsi&m=104855818826887&w=2

though it did not cover the path scsi_eh_lock_done takes. It appears
that we should add a call to scsi_queue_next_request in
scsi_release_request if sr_command is set.

> 
> Maybe I'm wrong about that, and the problem doesn't lie in 
> scsi_eh_lock_done().  But there is no doubt that at the end of error 
> recovery, after the door-lock command finishes up no other commands are 
> processed.  Logging just stops after the "Notifying upper driver of 
> completion" message.
> 
> 
> The second problem is a coding mistake in scsi_check_device_busy(), in
> hosts.c.  Here is an excerpt from the source:
> 
> ---------------
> 
> static int scsi_check_device_busy(struct scsi_device *sdev)
> {
> 	struct Scsi_Host *shost = sdev->host;
> 	struct scsi_cmnd *scmd;
> 	unsigned long flags;
> 
> 	/*
> 	 * Loop over all of the commands associated with the
> 	 * device.  If any of them are busy, then set the state
> 	 * back to inactive and bail.
> 	 */
> 	spin_lock_irqsave(&sdev->list_lock, flags);
> 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
> 		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE)
> 			goto active;
> 
> <snip>
> 
> active:
> 	printk(KERN_ERR "SCSI device not inactive - rq_status=%d, target=%d, "
> 			"pid=%ld, state=%d, owner=%d.\n",
> 			scmd->request->rq_status, scmd->device->id,
> 			scmd->pid, scmd->state, scmd->owner);
> 
> (A)	list_for_each_entry(sdev, &shost->my_devices, siblings) {
> 		list_for_each_entry(scmd, &sdev->cmd_list, list) {
> (B)			if (scmd->request->rq_status == RQ_SCSI_DISCONNECTING)
> 				scmd->request->rq_status = RQ_INACTIVE;
> 		}
> 	}
> 
> (C)	spin_unlock_irqrestore(&sdev->list_lock, flags);
> 	printk(KERN_ERR "Device busy???\n");
> 	return 1;
> }
> 
> ---------------
> 
> The line labelled (A) is definitely wrong.  Maybe it doesn't belong there
> at all -- I don't see any reason why a function devoted to checking
> whether a particular device is busy needs to look at any other devices on
> the same host.  Furthermore, line (A) changes the value of the sdev
> variable, which means that line (C) unlocks the wrong spinlock.  Finally,
> judging from the style of the code earlier on, line (B) needs to test that
> scmd->request is non-NULL before dereferencing it.
> 

The code you point to is incorrect. It looks like the migration of the
2.4 code left a few lines behind. The short term fix if you are hitting
a problem here is to remove (A) add "scmd->request" to (B). The better
fix is to not call this code anymore.

-andmike
--
Michael Anderson
andmike@us.ibm.com

