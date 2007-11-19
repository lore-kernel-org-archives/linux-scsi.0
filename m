From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: SCSI dynamic power management
Date: Mon, 19 Nov 2007 14:16:12 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org>
References: <1195491182.3283.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35342 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751053AbXKSTQN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 14:16:13 -0500
In-Reply-To: <1195491182.3283.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 19 Nov 2007, James Bottomley wrote:

> > Here's how it will work: scsi_prep_state_check() will see that the
> > device is in a suspended state (probably a substate of SDEV_QUIESCE).  
> > The return value will depend on the type of suspend:
> > 
> > 	For manual suspend or system suspend, the routine simply 
> > 	returns BLKPREP_KILL.
> > 
> > 	For autosuspend, the routine will submit a workqueue request
> > 	to autoresume the device and will return BLKPREP_DEFER.
> > 
> > The trick is somehow to allow the START-STOP UNIT commands get past 
> > this filter.  Is this what the REQ_PREEMPT flag is intended for?
> 
> Um, that model is pretty host centric ... we wouldn't be able to use
> that for power management of shared devices like SAS/SATA devices in an
> expander or FC devices.  The basic problem with power management of
> external devices (whether shared or not) is that it's not just what the
> host did to them, it's also what the environment or administrator did to
> them.

Well, think of this as "idle-device" management rather than power 
management.

It's no more host-centric than the existing code in sd_suspend().  
When I mentioned sending START-STOP UNIT commands above, that was a bit
sloppy.  What the code would actually do is call the high-level
driver's suspend method, which would then send the appropriate commands
to the device.  (Or maybe the code would simply call scsi_bus_suspend.)  
If sending START-STOP UNIT during a suspend is host-centric then
sd_suspend() is already guilty.


Regarding this thread's original question, the best idea I've come up
with so far is to store an extra flag in the scsi_device structure
indicating that a suspend or resume transition is underway.  When the
flag is set, commands with REQ_PREEMPT would be accepted.  If the
device is "suspended" and the flag is clear, then commands would be
delayed or killed in the prep function regardless of REQ_PREEMPT.  This 
scheme could potentially let unwanted commands go through, but I 
haven't been able to think of anything more suitable.

Alan Stern

