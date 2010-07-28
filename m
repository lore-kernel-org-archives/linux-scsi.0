From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Patch added to scsi-misc-2.6:  [SCSI] implement runtime Power
 Management
Date: Wed, 28 Jul 2010 11:52:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1007281143380.1744-100000@iolanthe.rowland.org>
References: <201007281314.o6SDE7bO019816@hera.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45183 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752808Ab0G1Pwg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 11:52:36 -0400
In-Reply-To: <201007281314.o6SDE7bO019816@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 28 Jul 2010, James Bottomley wrote:

> Your commit:
> 
>     [SCSI] implement runtime Power Management
>     
>     This patch (as1398b) adds runtime PM support to the SCSI layer.  Only
>     the machanism is provided; use of it is up to the various high-level
>     drivers, and the patch doesn't change any of them.  Except for sg --
>     the patch expicitly prevents a device from being runtime-suspended
>     while its sg device file is open.

...

> has been added to the upstream SCSI tree
> You can find it here:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=e6eb7b8684d579a920fb2a4c5cfeaae715e0167d
> 
> This patch is scheduled to be pushed when the merge window opens for 2.6.36

James:

You haven't applied the 7-part patch series submitted here

	http://marc.info/?l=linux-scsi&m=127551093014580&w=2

and in the following emails.  For the most part it doesn't matter;  
those patches are pretty trivial clean-ups.  However it does matter in
one regard: The 6/7 patch in that series interacts with this commit
here.  The logic for setting the task state in scsi_error_handler() was
simplified, and without that change this
implement-runtime-power-management patch leaves the state set wrong.

This is a potential bug.  Of course, my preference is for those seven
patches to be accepted.  But if you prefer, you could simply add a line
setting the state to TASK_INTERRUPTIBLE before the "continue" statement
added here.

Alan Stern

