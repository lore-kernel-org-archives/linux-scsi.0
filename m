From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 11:08:45 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408201048030.1063-100000@ida.rowland.org>
References: <4125EEE4.50102@optonline.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:18948 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268169AbUHTPIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 11:08:50 -0400
In-Reply-To: <4125EEE4.50102@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Aug 2004, Nathan Bryant wrote:

> Thanks for the feedback, looks like you've found a real problem with the 
> patch: that is, due to the unconditonal spinup call on resume, we clear 
> any UNIT ATTENTION state before any of the upper layers ever see it, so 
> nobody will notice a possible media change.
> 
> Unfortunately, I think that the current media change detection code in 
> the Linux kernel can not distinguish power-on events from media change 
> events. I'm not sure doing so is even possible for SCSI devices. 
> (Comments on that?) Proposed solutions:

I don't know to what extent the sd driver detects and handles power-on or 
media change events.  I'm also not sure how much point there is in trying 
to distinguish them.  If you can't tell whether the medium was changed 
while the power was off, you should assume that it was for safety's 
sake.  Shucks, the entire drive may have been cold-swapped.

> Approach #1:
> * Continue to do the unconditional spinup, but only for devices that are 
> already mounted.
> This may miss some media change events, but if we really can't 
> distinguish power-on from media change, maybe that's somebody else's 
> problem if the device was already mounted. (Changing mounted media is 
> the user's fault.)

It doesn't matter whose fault it is; if a mounted medium is changed the
driver should be careful to invalidate the existing file references so
that the new medium isn't corrupted and the errors can be propagated back
up to the user.  That's how it seems to me, anyway -- existing kernel 
policy might be different.  How does the floppy driver handle these 
things?

Also bear in mind, while a user may be smart enough not to change a
mounted medium, when the system is suspended it's not so easy to tell
what's mounted.  Mistakes are much more likely to happen during suspend
than during normal operations.

> (Hmm, what about devices that are opened for read/write but not mounted?)

IMHO they should be treated equivalently.  Neither the new medium nor the
I/O stream should be allowed to get corrupted.  Does sd.c even know 
whether or not an open file handle refers to a mounted volume?

> Approach #2:
> * Test for UNIT_ATTENTION before spinning up and report this as a media 
> change.
> Safer, but may report "false positive" media change events if the device 
> was only powered down/up.

Or test _during_ spin-up.  But note that not all Unit Attentions are bad.
Anyway the driver should already be checking for UAs that indicate
power-on or media change (but I don't know whether it actually does so).

For that matter, the driver doesn't seem to care very much about 
PREVENT-ALLOW MEDIUM REMOVAL.  Sure, it issues the PREVENT command when 
the device is opened, but it doesn't recognize that the drive forgets the 
prevent/allow state whenever it is reset.

Also remember, some devices can't be spun up and actively dislike the 
START-STOP UNIT command (to the point of crashing when they receive it).  
I mention this just to make your life more difficult.  :-)

Alan Stern

P.S.: Slightly off-topic for this thread...  Why does sd.c probe for
write-protect only on devices with removable media?  Some fixed-media
devices can also be write-protected.

