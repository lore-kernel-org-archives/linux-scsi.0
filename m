From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Thu, 09 Oct 2014 06:40:26 -0700
Message-ID: <1412862026.32718.19.camel@jarvis>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
	 <1412801095.32718.13.camel@jarvis> <9985506.Mg7cltjCP9@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34947 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbaJINk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 09:40:28 -0400
In-Reply-To: <9985506.Mg7cltjCP9@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com

On Wed, 2014-10-08 at 22:58 +0200, Arnd Bergmann wrote:
> On Wednesday 08 October 2014 13:44:55 James Bottomley wrote:
> > > diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> > > index 45b9566..ff2a0b3 100644
> > > --- a/drivers/scsi/ips.h
> > > +++ b/drivers/scsi/ips.h
> > > @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
> > >     uint8_t            active;
> > >     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
> > >     uint16_t           reset_count;        /* number of resets           */
> > > -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> > > +   time64_t             last_ffdc;          /* last time we sent ffdc info*/
> > >     uint8_t            slot_num;           /* PCI Slot Number            */
> > >     int                ioctl_len;          /* size of ioctl buffer       */
> > >     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
> > 
> > This is completely pointless, isn't it?  All the ips driver cares about
> > is that we send a FFDC time update every eight hours or so, so we can
> > happily truncate the number of seconds to 32 bits for that calculation
> > just keep the variable at 32 bits and do a time_after thing for the
> > comparison.
> 
> Good point. The same has come up in a few other places, so I wonder if we
> should introduce a proper way to do it that doesn't involve time_t.

We have, it's jiffies ... that's why I'm slightly non-plussed that this
driver is using gettimeofday for something like this ... it was clearly
a review failure when we put it in.

or are you thinking we need a time_t_time_before doing for time_t what
we do for jiffies?

> While the current code works, we will have to audit 2000 other locations
> in which time_t/timespec/timeval are used in the kernel, so we are going
> to need some form of annotation to make sure we don't get everyone to
> look at the driver again just to come to the same conclusion after working
> on a patch first.
> 
> > However, what the code *should* be doing is using jiffies and
> > time_before/after since the interval is so tiny rather than a
> > do_gettimeofday() call in the fast path.
> 
> Yes, this would probably be best for this particular driver, it also
> means we end up with a monotonic clock source rather than a wall-clock.

Right, and it's a 32 bit read instead of a system call every time the
thing dispatches a command ... to be honest the overhead of 64 bit
arithmetic is peanuts to making a syscall in the fast path.

James

> Ebru, when I explained the various data types we have for timekeeping,
> I failed to mention jiffies. That is one that is very fast to access
> and has a resolution between 1 and 10 milliseconds but will overflow
> within a few months, so it can only be used in places where overflow
> is known to be handled safely, as time_before() does.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


