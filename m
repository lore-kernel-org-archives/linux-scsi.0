From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Sun, 12 Feb 2012 20:42:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202122013300.24811-100000@netrider.rowland.org>
References: <201202122100.05349.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:38236 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753064Ab2BMBmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2012 20:42:25 -0500
In-Reply-To: <201202122100.05349.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>

On Sun, 12 Feb 2012, Oliver Neukum wrote:

> Yes, we can use the same heuristics as everywhere.
> command queued -> autopm_get
> command finished -> autopm_put
> 
> but for the USB host adapter, not the sr device

I still don't fully understand.  Are you suggesting that we use the 
normal autosuspend timeout mechanism for the disk drive (for example, 
spin down the disk if it hasn't been used for five minutes), and then 
autosuspend a USB mass-storage device whenever its children are 
suspended and no commands are in progress?  (In fact, there can't be 
any commands in progress if all the children are suspended.)

Or are you suggesting that we autosuspend a USB mass-storage device 
between commands, regardless of the state of its children?  Didn't we 
discuss this approach a year or two ago and decide against it?

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
> 
> For the disk drive you just declare them busy restarting the timeout as a command
> goes down to the hardware. There is an interesting case about what you do if
> the generic layer wants to autosuspend an sr device which has a command queued.
> I propose we catch that case in sr_suspend() and return -EBUSY in
> the autosuspend with command in flight case.

The SCSI drivers don't know much about the request queue -- the block
layer manages it.  That's another reason for handling this at the block
layer.

Is there some special reason you're talking about sr (the SCSI CD/DVD
driver) instead of sd (the SCSI disk driver)?

Alan Stern

