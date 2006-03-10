From: Doug Ledford <dledford@redhat.com>
Subject: Re: scsi_track_queue_full function - static values ?
Date: Fri, 10 Mar 2006 13:20:32 -0500
Message-ID: <20060310182032.GA1841@redhat.com>
References: <440D8B7C.9020001@ext.bull.net> <20060310164027.GA6397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:25534 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751844AbWCJSUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 13:20:55 -0500
Content-Disposition: inline
In-Reply-To: <20060310164027.GA6397@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>, linux-scsi@vger.kernel.org

On Fri, Mar 10, 2006 at 04:40:27PM +0000, Christoph Hellwig wrote:
> On Tue, Mar 07, 2006 at 02:32:44PM +0100, Frederic TEMPORELLI wrote:
> > I was looking at the scsi_track_queue_full (driver/scsi/scsi.c) function.
> > 
> > Can someone tell me how have been defined all the static values in this 
> > function ?

Painful experience is how they were defined.  That said, I'll explain said
experience.

> > - we may have (max) 16 (>>4) jiffies between calls (else there's no need to 
> > call this function...),

QUEUE_FULLs happen in bunches.  When you have 10 commands waiting to go to a
drive, and you fill its queue, depending on the driver you will either block
the remaining 9 commands or all 10 commands will end up getting sent back to
back and all 10 will QUEUE_FULL out.  You want these mass QUEUE_FULL events
to be treated as a single QUEUE_FULL for the purpose of tracking the
device's queue depth.  In addition, you want to know the depth the device
was at, not how many commands the mid layer has created.  Only the driver
can now that since different drivers queue things differently internally,
there may be commands that are paused and not yet sent to the device but are
present on the card, etc.  Only the driver can know how many commands are
*truly* outstanding, and even then it can only really know when it has
confirmed that all currently outstanding commands besides the one it is
currently processing have been accepted by the device and not returned with
QUEUE_FULL as well.

> > - queue_full_depth_count should be > 10 (else queue depth still not 
> > changed),

There are three distinct scenarios resulting in QUEUE_FULL issues:

1)  A fixed command depth on a device.  This is the same each and every
time.

2) A variable command depth on a device (Quantum Atlas II/III drives with
write behind caching are really bad here).

3) Multi-initiator mixed with both of the above where the depth that we see
may not be the depth the device sees due to other SCSI hosts also sending
commands.

In order to avoid artificially throttling drives for momentary issues versus
fixed issues, track the queue depth count of the last queue full and if it
is the same repeatedly, then assume it's a fixed depth.  With the Quantum
drives previously mentioned, they have a fixed depth of 64, but will reduce
that as needed when too many write commands have been cached.  The heuristic
in that code will take a while (usually within a few minutes of starting
heavy load) to get the 64 hard limit on those drives, but it eventually
succeeds.

> > - if lun queue depth < 8, lun queue depth is set with cmd_per_lun
> > (what's happen if cmd_per_lun > 8 ???)

cmd_per_lun is (was?) defined as the driver's allowable queue depth on
untagged devices.  Since all untagged devices can never have more than 1
command outstanding at a time, any driver that sets cmd_per_lun > 1 must, by
definition, be able to do it's own internal queueing and respect the limit
of 1 command at a time on untagged devices.  In addition, we are clearing
the tagged operation bit for the device when we set it to cmd_per_lun.  This
is based on more experience, specifically that I have, in all my testing of
some really *crappy* scsi drives, never found a single drive that both A)
supported tagged queueing and B) had a hard limit of less than 8 (although a
few models, Quantum Fireballs in particular, did have a limit of 8, even
that was a rarity and most drives were either 32 or 64 or higher).  So, if
we ever get a drive that tells us a limit of less than 8 repeatedly, we
either have a bogus firmware that's horked, or we have a heavily
multi-initiator environment with starvation issues.  So, be on the safe side
and go untagged in case it's the firmware problem.

> > 
> > May someone add some #define for these values ?
> > Is it a way to use 'auto-adapted' values ?
> 
> I think Doug Ledford wrote that code, I've added him to the cc list
> as he's probably the best one to answer your question.
> 
> While we're at it, it would be nice if more drivers used this functionality..

Using it well requires a little care.  Due to the jitter problem you get
when you have a queue full barrage, the driver should really only call this
once it has a final count for the real depth, not on each QUEUE_FULL.  If
the driver doesn't want to do that, then the other option would be to modify
this routine so that at the beginning it does something like this:

	/*
	 * Catch repeated QUEUE_FULLs in a short period of time, but
	 * if depth is 1 less than previous depth, assume we are
	 * trickling in all the QUEUE_FULLs from a single batch and
	 * we need the lowest number, so let it fall through.
	 */
        if ((jiffies >> 4) == sdev->last_queue_full_time &&
	    (sdev->last_queue_full_depth - 1) != depth)
		return 0;

But doing this *greatly* increases the complexity of tracking the final
queue full depth as now you need a current queue full depth and a last final
queue full depth so you can compare where the trickling stops to where it
stopped last time in order to see if you have a repeat of the same depth.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
