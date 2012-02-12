From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Sun, 12 Feb 2012 13:05:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202121255400.18114-100000@netrider.rowland.org>
References: <201202112037.07173.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:58927 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755678Ab2BLSFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2012 13:05:52 -0500
In-Reply-To: <201202112037.07173.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>

On Sat, 11 Feb 2012, Oliver Neukum wrote:

> > Your whole approach is at the wrong level.  Runtime PM between I/O 
> > requests for block devices should be implemented in the block layer, 
> > not in the SCSI layer.
> 
> I must disagree. The block layer has no more information than the SCSI
> layer and lacks everything the lower layers know.

But the block layer handles all block devices, not just SCSI ones.  You 
would end up duplicating code unnecessarily.

What pertinent information is known by the SCSI and lower layers but
not the block layer?

> It seems to me that most of these difficulties go away if we strictly
> differentiate between host adapter and disks.

To be more precise, you mean "disk drives".  You can suspend a drive,
but you can't suspend a disk.

> First, the sr driver cannot really suspend a disk. It can spin down a disk,
> but that is not the same thing as suspending, because the disk is still
> functional. It may just return special sense codes. The sr driver just
> prepares devices for suspension.

True.  This is because the SCSI standard does not include any notion of 
device suspension -- at least, not in the versions I'm aware of.

> It is true, that the sr driver probably does have a few conditions under
> which a device should not be suspended (eg. error handling) but it
> lacks positive knowledge about when we may suspend.
> 
> The same is also true for any higher layer.

Then what's wrong with handling runtime suspend in the higher layers?

> The problem of needing to do IO for suspension goes away if we
> treat the disk as always suspendable and use an active command
> as a condition for not suspending the storage device as opposed to the disk
> the problem goes away.

I don't entirely understand.  What's the difference between "the
storage device" and "the disk"?

However, using an active command as the condition is not the right 
thing to do.  It would use extra energy and slow everything down to 
suspend and resume the device between every pair of commands that were 
separated by a slight time delay.  There needs to be a timeout.

Furthermore, if you use active commands as the condition for 
suspending, what do you do when the act of suspending causes a command 
to be sent?  It is necessary to distinguish between ordinary commands 
and those that are PM-related.

Alan Stern

