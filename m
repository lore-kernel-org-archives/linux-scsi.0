From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Sun, 22 Jun 2008 12:26:52 -0500
Message-ID: <1214155613.4047.15.camel@localhost.localdomain>
References: <20080619160342.GJ4392@parisc-linux.org>
	 <1214141931.4047.5.camel@localhost.localdomain>
	 <20080622140323.GZ4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52147 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbYFVR04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2008 13:26:56 -0400
In-Reply-To: <20080622140323.GZ4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 2008-06-22 at 08:03 -0600, Matthew Wilcox wrote:
> On Sun, Jun 22, 2008 at 08:38:51AM -0500, James Bottomley wrote:
> > > I think there's an opportunity to improve sd_vpd_inquiry() to remove
> > > some of the duplicate code between sd_set_elevator() and sd_block_limits,
> > > but it's not terribly important.
> > 
> > and actually ses.c as well.
> 
> Ah yes.  I'll rip it out of ses.c.  Thanks.
> 
> A question of policy ... should we interrogate page 0 to find out if
> page 0x83 exists?  You don't currently, but ses.c is limited to devices
> with an enclosure ... which is presumably only newer devices.  Do we
> have any idea if devices blow up on being asked for random VPD that they
> might not have?

It's wise to.  For true SCSI devices (going all the way back to my 8"
HVD FAST-10 ones of ca 1989) the answer is that they respond correctly
(as in ILLEGAL REQUEST).  For the ATA devices through SAT, the answer's
also that.  Unfortunately, for devices which have their own eccentric
SCSI interpreters (glares at USB) the answer is that they can do
horrible things: we had a bug filed only this year where a VPD inquiry
was crashing a USB device.  This is another reason for punting this to
userspace.  The heuristics of what works are already embedded into udev.

I think the solution is eventually just to push all VPD stuff to
userspace (including ses), but that's long term.

> > > The switching of the elevators isn't particularly nice.  I assume that
> > > elevator_init("noop") cannot fail, which isn't true.  It would be nice
> > > to use the #if 0 block instead, but that causes a null ptr dereference
> > > inside sysfs -- I suspect something isn't set up correctly.
> > 
> > I'm really not very keen on this patch, since it's implementing elevator
> > policy from sd which is a bit of a layering violation (and a policy
> > should be in userspace one).
> 
> It's only choosing a default, not implementing policy.
> 
> > What's wrong with doing this entirely from udev (it already issues the
> > vpd's today, that's how it gets the id from page 0x83 ... it could
> > easily look at 0xb1 and set the elevator
> > using /sys/block/<>/queue/scheduler)?.
> 
> I'll take a look at udev on Monday.  It certainly seems less
> controversial than this patch.

Thanks!

James


