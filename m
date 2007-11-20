From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: SCSI dynamic power management
Date: Tue, 20 Nov 2007 08:53:07 -0600
Message-ID: <1195570387.3131.12.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:46362 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758160AbXKTOxK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 09:53:10 -0500
In-Reply-To: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>


On Mon, 2007-11-19 at 14:16 -0500, Alan Stern wrote:
> On Mon, 19 Nov 2007, James Bottomley wrote:
> 
> > > Here's how it will work: scsi_prep_state_check() will see that the
> > > device is in a suspended state (probably a substate of SDEV_QUIESCE).  
> > > The return value will depend on the type of suspend:
> > > 
> > > 	For manual suspend or system suspend, the routine simply 
> > > 	returns BLKPREP_KILL.
> > > 
> > > 	For autosuspend, the routine will submit a workqueue request
> > > 	to autoresume the device and will return BLKPREP_DEFER.
> > > 
> > > The trick is somehow to allow the START-STOP UNIT commands get past 
> > > this filter.  Is this what the REQ_PREEMPT flag is intended for?
> > 
> > Um, that model is pretty host centric ... we wouldn't be able to use
> > that for power management of shared devices like SAS/SATA devices in an
> > expander or FC devices.  The basic problem with power management of
> > external devices (whether shared or not) is that it's not just what the
> > host did to them, it's also what the environment or administrator did to
> > them.
> 
> Well, think of this as "idle-device" management rather than power 
> management.

Sure ... but surely that's a subset of proper power management?

> It's no more host-centric than the existing code in sd_suspend().  
> When I mentioned sending START-STOP UNIT commands above, that was a bit
> sloppy.  What the code would actually do is call the high-level
> driver's suspend method, which would then send the appropriate commands
> to the device.  (Or maybe the code would simply call scsi_bus_suspend.)  
> If sending START-STOP UNIT during a suspend is host-centric then
> sd_suspend() is already guilty.

Ah, but if you look, sd_suspend by default doesn't do anything ... it
has to be enabled on a per device basis by the manage_start_stop
attribute ... that's precisely because we can't have the sd ULD idling a
SAN device when others are trying to use it.

> Regarding this thread's original question, the best idea I've come up
> with so far is to store an extra flag in the scsi_device structure
> indicating that a suspend or resume transition is underway.  When the
> flag is set, commands with REQ_PREEMPT would be accepted.  If the
> device is "suspended" and the flag is clear, then commands would be
> delayed or killed in the prep function regardless of REQ_PREEMPT.  This 
> scheme could potentially let unwanted commands go through, but I 
> haven't been able to think of anything more suitable.

I don't understand why you want to do this.  Power management is a
layered issue on SCSI, divided (as always) into host, device and
transport.  The idle you're talking about is a pure device thing, so it
can be managed by the ULD (and currently is).  When a unit is stopped,
it automatically returns correct NOT_READY sense to most commands.  The
sd_done post processing could decide to wake the device and retry or
return an error without ever troubling the mid layer or even block for
anything.    All the hooks are already in sd, why does this now need to
go into block (unless there's some longer scheme for incorporating the
transport and other elements into this?)

James


