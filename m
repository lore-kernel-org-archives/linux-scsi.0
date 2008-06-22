From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Sun, 22 Jun 2008 08:03:24 -0600
Message-ID: <20080622140323.GZ4392@parisc-linux.org>
References: <20080619160342.GJ4392@parisc-linux.org> <1214141931.4047.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46650 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYFVODk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jun 2008 10:03:40 -0400
Content-Disposition: inline
In-Reply-To: <1214141931.4047.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 22, 2008 at 08:38:51AM -0500, James Bottomley wrote:
> > I think there's an opportunity to improve sd_vpd_inquiry() to remove
> > some of the duplicate code between sd_set_elevator() and sd_block_limits,
> > but it's not terribly important.
> 
> and actually ses.c as well.

Ah yes.  I'll rip it out of ses.c.  Thanks.

A question of policy ... should we interrogate page 0 to find out if
page 0x83 exists?  You don't currently, but ses.c is limited to devices
with an enclosure ... which is presumably only newer devices.  Do we
have any idea if devices blow up on being asked for random VPD that they
might not have?

> > The switching of the elevators isn't particularly nice.  I assume that
> > elevator_init("noop") cannot fail, which isn't true.  It would be nice
> > to use the #if 0 block instead, but that causes a null ptr dereference
> > inside sysfs -- I suspect something isn't set up correctly.
> 
> I'm really not very keen on this patch, since it's implementing elevator
> policy from sd which is a bit of a layering violation (and a policy
> should be in userspace one).

It's only choosing a default, not implementing policy.

> What's wrong with doing this entirely from udev (it already issues the
> vpd's today, that's how it gets the id from page 0x83 ... it could
> easily look at 0xb1 and set the elevator
> using /sys/block/<>/queue/scheduler)?.

I'll take a look at udev on Monday.  It certainly seems less
controversial than this patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
