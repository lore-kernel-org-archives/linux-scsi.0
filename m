From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Sun, 12 Feb 2012 21:00:05 +0100
Message-ID: <201202122100.05349.oliver@neukum.org>
References: <Pine.LNX.4.44L0.1202121255400.18114-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:37448 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2BLT5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2012 14:57:40 -0500
In-Reply-To: <Pine.LNX.4.44L0.1202121255400.18114-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>

Am Sonntag, 12. Februar 2012, 19:05:51 schrieb Alan Stern:
> On Sat, 11 Feb 2012, Oliver Neukum wrote:
> 
> > > Your whole approach is at the wrong level.  Runtime PM between I/O 
> > > requests for block devices should be implemented in the block layer, 
> > > not in the SCSI layer.
> > 
> > I must disagree. The block layer has no more information than the SCSI
> > layer and lacks everything the lower layers know.
> 
> But the block layer handles all block devices, not just SCSI ones.  You 
> would end up duplicating code unnecessarily.
> 
> What pertinent information is known by the SCSI and lower layers but
> not the block layer?

It doesn't know what consequences suspending a host controller
has for the devices attached to it. It simply cannot know because
that depends on the hardware.

A very good example is the media change problem of the media readers.
For example an iSCSI virtual host controller can suspend while a command
is in flight if the network controller used can do remote wakeup well enough.

> > It seems to me that most of these difficulties go away if we strictly
> > differentiate between host adapter and disks.
> 
> To be more precise, you mean "disk drives".  You can suspend a drive,
> but you can't suspend a disk.

Yes.
 
> > It is true, that the sr driver probably does have a few conditions under
> > which a device should not be suspended (eg. error handling) but it
> > lacks positive knowledge about when we may suspend.
> > 
> > The same is also true for any higher layer.
> 
> Then what's wrong with handling runtime suspend in the higher layers?

They know some reasons to not suspend, but not all reasons.
 
> > The problem of needing to do IO for suspension goes away if we
> > treat the disk as always suspendable and use an active command
> > as a condition for not suspending the storage device as opposed to the disk
> > the problem goes away.
> 
> I don't entirely understand.  What's the difference between "the
> storage device" and "the disk"?

The storage device == a USB device that implements the storage class
the disk == a SCSI disk drive
 
> However, using an active command as the condition is not the right 
> thing to do.  It would use extra energy and slow everything down to 
> suspend and resume the device between every pair of commands that were 
> separated by a slight time delay.  There needs to be a timeout.

Yes, we can use the same heuristics as everywhere.
command queued -> autopm_get
command finished -> autopm_put

but for the USB host adapter, not the sr device

> Furthermore, if you use active commands as the condition for 
> suspending, what do you do when the act of suspending causes a command 
> to be sent?  It is necessary to distinguish between ordinary commands 
> and those that are PM-related.

No. This problem goes away if you correctly make the distinction between
host controller/storage device and the disk drive.
You use the "active command standard" for the host controller.
Then you need not care about the commands needed to suspend a disk drive.
You cannot suspend the host controller while the disk drive is being suspended
anyway, as the tree constraint prevents it.

For the disk drive you just declare them busy restarting the timeout as a command
goes down to the hardware. There is an interesting case about what you do if
the generic layer wants to autosuspend an sr device which has a command queued.
I propose we catch that case in sr_suspend() and return -EBUSY in
the autosuspend with command in flight case.

And I admit we will need to special case the stupid card readers.

	Regards
		Oliver
