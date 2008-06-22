From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Sun, 22 Jun 2008 08:38:51 -0500
Message-ID: <1214141931.4047.5.camel@localhost.localdomain>
References: <20080619160342.GJ4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37406 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbYFVNiy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2008 09:38:54 -0400
In-Reply-To: <20080619160342.GJ4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-06-19 at 10:03 -0600, Matthew Wilcox wrote:
> Use the noop elevator by default for drives that do not spin
> 
> [Not for applying]
> 
> SSDs do not benefit from the elevator.  It just wastes precious CPU cycles.
> By selecting the noop elevator by default, we can shave a few microseconds
> off each IO.
> 
> I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
> 
> http://marc.info/?l=linux-scsi&m=121264354724277&w=2
> 
> No need to have two copies of that ... but this will conflict with his code.
> 
> On to the self-criticism:
> 
> I don't intend the final version of this patch to include a printk for
> the RPM or even a printk to say we switched IO elevator.  I think we're
> too verbose in SCSI as it is.
> 
> I think there's an opportunity to improve sd_vpd_inquiry() to remove
> some of the duplicate code between sd_set_elevator() and sd_block_limits,
> but it's not terribly important.

and actually ses.c as well.

> The switching of the elevators isn't particularly nice.  I assume that
> elevator_init("noop") cannot fail, which isn't true.  It would be nice
> to use the #if 0 block instead, but that causes a null ptr dereference
> inside sysfs -- I suspect something isn't set up correctly.

I'm really not very keen on this patch, since it's implementing elevator
policy from sd which is a bit of a layering violation (and a policy
should be in userspace one).

What's wrong with doing this entirely from udev (it already issues the
vpd's today, that's how it gets the id from page 0x83 ... it could
easily look at 0xb1 and set the elevator
using /sys/block/<>/queue/scheduler)?.

James


