From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Wed, 08 Oct 2014 22:58:32 +0200
Message-ID: <9985506.Mg7cltjCP9@wuerfel>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com> <1412801095.32718.13.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412801095.32718.13.camel@jarvis>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wednesday 08 October 2014 13:44:55 James Bottomley wrote:
> > diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> > index 45b9566..ff2a0b3 100644
> > --- a/drivers/scsi/ips.h
> > +++ b/drivers/scsi/ips.h
> > @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
> >     uint8_t            active;
> >     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
> >     uint16_t           reset_count;        /* number of resets           */
> > -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> > +   time64_t             last_ffdc;          /* last time we sent ffdc info*/
> >     uint8_t            slot_num;           /* PCI Slot Number            */
> >     int                ioctl_len;          /* size of ioctl buffer       */
> >     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
> 
> This is completely pointless, isn't it?  All the ips driver cares about
> is that we send a FFDC time update every eight hours or so, so we can
> happily truncate the number of seconds to 32 bits for that calculation
> just keep the variable at 32 bits and do a time_after thing for the
> comparison.

Good point. The same has come up in a few other places, so I wonder if we
should introduce a proper way to do it that doesn't involve time_t.

While the current code works, we will have to audit 2000 other locations
in which time_t/timespec/timeval are used in the kernel, so we are going
to need some form of annotation to make sure we don't get everyone to
look at the driver again just to come to the same conclusion after working
on a patch first.

> However, what the code *should* be doing is using jiffies and
> time_before/after since the interval is so tiny rather than a
> do_gettimeofday() call in the fast path.

Yes, this would probably be best for this particular driver, it also
means we end up with a monotonic clock source rather than a wall-clock.

Ebru, when I explained the various data types we have for timekeeping,
I failed to mention jiffies. That is one that is very fast to access
and has a resolution between 1 and 10 milliseconds but will overflow
within a few months, so it can only be used in places where overflow
is known to be handled safely, as time_before() does.

	Arnd
