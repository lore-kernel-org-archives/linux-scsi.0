From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Fri, 28 Sep 2007 10:17:56 +0200
Message-ID: <200709281017.56901.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:54250 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXI1IQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 04:16:58 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Donnerstag 27 September 2007 schrieb Alan Stern:
> On Thu, 27 Sep 2007, Oliver Neukum wrote:
> 
> > > > 1. autosuspend should not be specific to USB
> > > 
> > > Correct.  Which means support for it should be added to the SCSI
> > > drivers.  SCSI autosuspend shouldn't be kluged into usb-storage in a
> > > way that basically ignores what the SCSI layer is doing.
> > 
> > It isn't. The decision to autosuspend is based on activity on the bus.
> > Now you might argue that the decision to do an autosuspend should
> > always propagate upwards from the lowest level of the device tree.
> > Then I ask why?
> 
> Because that's how I have always thought of it...  :-)
> 
> You're right; there's no showstopping reason particular subsystems like
> SCSI can't use a different approach.  However bus activity alone isn't
> a sufficient criterion.  For example, suppose somebody sends a PLAY
> AUDIO command to a SCSI cdrom drive.  There won't be any bus activity
> while the music is playing, but the device will be active and so it
> shouldn't be suspended.  Thus the sr driver would want to fail an
> autosuspend call.

sr isn't a device driver. Furthermore it is generic. It can't know whether
any power saving measure would prevent some activity from being carried
out. It seems to me that we need to be conservative. Any device that
is opened by user space must not be autosuspended. But how to fit this
into SCSI?

> Anyway, if we do end up going this route then there should be a routine
> added to the SCSI core which would call the suspend methods for all the
> attached devices.  This doesn't belong in usb-storage (and even worse, 
> it shouldn't be duplicated in all the other low-level drivers); rather,
> usb-storage should simply be able to call the new routine.

We are moving in circles. In an earlier thread you argued that a suspend
call should not walk the device tree in case of runtime power management.
 
> Have you thought about how autoresume would fit into this picture?  I
> don't think you can rely on usb-storage telling the SCSI core to resume
> devices when it gets handed a command, because the commands to spin-up
> the drives would have to be transmitted first.  (The sample patch you
> posted will deadlock: The other command can't begin until the spin-up
> command completes, and the spin-up command won't get sent to
> usb-storage until the original command completes.)  In other words,
> autoresume must be handled at the level of the SCSI core.

That's a difficult one. I need to ponder this a bit.
 
[..]

> There's also a philosophical objection.  Who is in a better position to
> judge when a device like a SCSI drive should be autosuspended: its own
> driver (sd) or someone else (usb-storage)?

SCSI doesn't know about power management. It cannot, it is not a notion
native to SCSI. It just knows how to safely put drives into a state other
than fully active (flushing buffers/spin down)
You are expecting too much of SCSI core.

	Regards
		Oliver

