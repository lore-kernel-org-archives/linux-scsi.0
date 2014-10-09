From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Thu, 09 Oct 2014 08:13:14 -0700
Message-ID: <1412867594.13107.28.camel@jarvis.lan>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
	 <9985506.Mg7cltjCP9@wuerfel> <1412862026.32718.19.camel@jarvis>
	 <2518561.k9qJZyWstd@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35668 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaJIPNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 11:13:16 -0400
In-Reply-To: <2518561.k9qJZyWstd@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com

On Thu, 2014-10-09 at 16:29 +0200, Arnd Bergmann wrote:
> On Thursday 09 October 2014 06:40:26 James Bottomley wrote:
> > On Wed, 2014-10-08 at 22:58 +0200, Arnd Bergmann wrote:
> > > On Wednesday 08 October 2014 13:44:55 James Bottomley wrote:
> > > > > diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> > > > > index 45b9566..ff2a0b3 100644
> > > > > --- a/drivers/scsi/ips.h
> > > > > +++ b/drivers/scsi/ips.h
> > > > > @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
> > > > >     uint8_t            active;
> > > > >     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
> > > > >     uint16_t           reset_count;        /* number of resets           */
> > > > > -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> > > > > +   time64_t             last_ffdc;          /* last time we sent ffdc info*/
> > > > >     uint8_t            slot_num;           /* PCI Slot Number            */
> > > > >     int                ioctl_len;          /* size of ioctl buffer       */
> > > > >     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
> > > > 
> > > > This is completely pointless, isn't it?  All the ips driver cares about
> > > > is that we send a FFDC time update every eight hours or so, so we can
> > > > happily truncate the number of seconds to 32 bits for that calculation
> > > > just keep the variable at 32 bits and do a time_after thing for the
> > > > comparison.
> > > 
> > > Good point. The same has come up in a few other places, so I wonder if we
> > > should introduce a proper way to do it that doesn't involve time_t.
> > 
> > We have, it's jiffies ... that's why I'm slightly non-plussed that this
> > driver is using gettimeofday for something like this ... it was clearly
> > a review failure when we put it in.
> 
> Actually there is more to it, as I just found upon reading the code
> again (I had noticed it before when I first looked at the driver but
> then forgotten about it):
> 
> ips_fix_ffdc_time() needs the correct current wall-clock time, no overflow
> allowed, to stick the year/month/day/hour/minute/second value into
> the ffdc command.

true, but we could call do_gettimeofday() in the routine when we know
we're sending it.  And it only does this once every 8 hours.  My
complaint is the do_gettimeofday() sitting in the fast path to see if
the eight hours since the last time we sent the ffdc timestamp have
elapsed.

Actually, isn't there a version of the syscall that does return what
this firmware is looking for (the year, month, day, hour, seconds
values)?

> My comment to Ebru about ktime_get_ts64 for monotonic time was unfortunately
> completely wrong, since that would break whatever timekeeping it is
> in the hardware that wants the correct year/month/day/hour/minute/second
> values.
> 
> > or are you thinking we need a time_t_time_before doing for time_t what
> > we do for jiffies?
> 
> The part I'm interested in is getting rid of any mention of time_t,
> timespec and timeval in the kernel by replacing each use with something
> that is known to be y2038-safe. Using jiffies correctly would solve
> a number of them, but is not sufficient for this driver because of the
> ffdc command.
> 
> We could use jiffies to test whether we need to send ffdc but then
> we still need to read the correct time.

Right, but it has its own wierd conversion formula, which is dictated by
the HW.

> > > While the current code works, we will have to audit 2000 other locations
> > > in which time_t/timespec/timeval are used in the kernel, so we are going
> > > to need some form of annotation to make sure we don't get everyone to
> > > look at the driver again just to come to the same conclusion after working
> > > on a patch first.
> > > 
> > > > However, what the code *should* be doing is using jiffies and
> > > > time_before/after since the interval is so tiny rather than a
> > > > do_gettimeofday() call in the fast path.
> > > 
> > > Yes, this would probably be best for this particular driver, it also
> > > means we end up with a monotonic clock source rather than a wall-clock.
> > 
> > Right, and it's a 32 bit read instead of a system call every time the
> > thing dispatches a command ... to be honest the overhead of 64 bit
> > arithmetic is peanuts to making a syscall in the fast path.
> 
> It's not a system call, all we need is a simple function call that reads
> tk->xtime_sec. We can use get_seconds() today, but it returns an
> 'unsigned long', so that won't be enough on 32-bit architectures.

For an 8 hour interval it is provided we have the proper comparisons.

> It's still slightly more expensive to do the function call and use a 64-bit
> number on a 32-bit CPU, but it's not on the scale of doing a system call
> here. You can probably judge best if it's worth the increase in complexity
> to use jiffies for determining whether to send the update and then
> use get_seconds64 (or similar) to read the wall-clock time, or whether
> always using get_seconds64 would be good enough.

heh, well we need to correct ips_fix_ffdc_time() somehow.  I think
converting the trigger mechanism to jiffies makes sense because the
interval is so small and we already have the jiffies code overflow safe.

James


