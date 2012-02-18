From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Sat, 18 Feb 2012 15:44:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202121855090.23796-100000@netrider.rowland.org>
References: <201202122100.05349.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201202122100.05349.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 12 Feb 2012, Oliver Neukum wrote:

> Am Sonntag, 12. Februar 2012, 19:05:51 schrieb Alan Stern:
> > On Sat, 11 Feb 2012, Oliver Neukum wrote:
> > 
> > > > Your whole approach is at the wrong level.  Runtime PM between I/O 
> > > > requests for block devices should be implemented in the block layer, 
> > > > not in the SCSI layer.
> > > 
> > > I must disagree. The block layer has no more information than the SCSI
> > > layer and lacks everything the lower layers know.
> > 
> > But the block layer handles all block devices, not just SCSI ones.  You 
> > would end up duplicating code unnecessarily.
> > 
> > What pertinent information is known by the SCSI and lower layers but
> > not the block layer?
> 
> It doesn't know what consequences suspending a host controller
> has for the devices attached to it. It simply cannot know because
> that depends on the hardware.
> 
> A very good example is the media change problem of the media readers.
> For example an iSCSI virtual host controller can suspend while a command
> is in flight if the network controller used can do remote wakeup well enough.

I don't see how this is relevant.  We're talking about suspending the
drive, not suspending the host adapter.  Runtime PM for an iSCSI host
adapter can be implemented to suspend in the middle of commands if it
wants; that has no bearing on this discussion and patch set.

> > Then what's wrong with handling runtime suspend in the higher layers?
> 
> They know some reasons to not suspend, but not all reasons.

So the lower layers can do their own autopm_get when necessary.

> > > The problem of needing to do IO for suspension goes away if we
> > > treat the disk as always suspendable and use an active command
> > > as a condition for not suspending the storage device as opposed to the disk
> > > the problem goes away.
> > 
> > I don't entirely understand.  What's the difference between "the
> > storage device" and "the disk"?
> 
> The storage device == a USB device that implements the storage class
> the disk == a SCSI disk drive

And in the case of some other sort of SCSI transport, I suppose "the 
storage device" includes the host adapter or equivalent.

> > However, using an active command as the condition is not the right 
> > thing to do.  It would use extra energy and slow everything down to 
> > suspend and resume the device between every pair of commands that were 
> > separated by a slight time delay.  There needs to be a timeout.
> 
> Yes, we can use the same heuristics as everywhere.
> command queued -> autopm_get
> command finished -> autopm_put
> 
> but for the USB host adapter, not the sr device

Didn't we discuss this a long time ago and decide it was a bad 
approach?

> > Furthermore, if you use active commands as the condition for 
> > suspending, what do you do when the act of suspending causes a command 
> > to be sent?  It is necessary to distinguish between ordinary commands 
> > and those that are PM-related.
> 
> No. This problem goes away if you correctly make the distinction between
> host controller/storage device and the disk drive.
> You use the "active command standard" for the host controller.
> Then you need not care about the commands needed to suspend a disk drive.
> You cannot suspend the host controller while the disk drive is being suspended
> anyway, as the tree constraint prevents it.

Heh, you're talking about ignoring the tree constraint anyway if you're 
going to suspend the USB device while the children beneath it remain 
unchanged.

> 
> For the disk drive you just declare them busy restarting the timeout as a command
> goes down to the hardware. There is an interesting case about what you do if
> the generic layer wants to autosuspend an sr device which has a command queued.
> I propose we catch that case in sr_suspend() and return -EBUSY in
> the autosuspend with command in flight case.
> 
> And I admit we will need to special case the stupid card readers.
> 
> 	Regards
> 		Oliver
> 
