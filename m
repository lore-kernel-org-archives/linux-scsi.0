From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 13:49:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425134955.A10975@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <20030425093718.A8776@beaverton.ibm.com> <1051289862.1756.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:14655 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263984AbTDYUlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 16:41:31 -0400
Content-Disposition: inline
In-Reply-To: <1051289862.1756.34.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Apr 25, 2003 at 12:57:42PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 25, 2003 at 12:57:42PM -0400, James Bottomley wrote:
> On Fri, 2003-04-25 at 12:37, Patrick Mansfield wrote:

> > So we are guaranteed to be able to have at least one IO in flight for all
> > devices. With a per-host spare, some device(s) might have to wait
> > (generally polling based on an interval dependent on whatever blk_plug_device
> > gives us) for a command to become available, and it is not clear what the
> > IO behaviour - especially for swap - will be in such cases.
> 
> Yes, but we all agreed that we really only needed one guaranteed
> commmand for the system to make forward progress.  It could be argued
> that we only need one globally.  One per host seems a reasonable
> compromise.
> 
> I don't really buy the in flight I/O argument because under normal
> circumstances the slab allocation will cope correctly.  The slab
> allocation only fails when we need to grow the slab *and* we're out of
> readily available pages, so the system tips into paging mode anyway and
> its throughput tanks.
> 
> Just the act of pre-allocating a single command means that we pin a slab
> page and thus have at least a page full of commands to throw about even
> in an out of memory situation.
> 
> James

But we do not have fair arbitration to the scsi_get_command. When there
are many commands in flight, and when one IO finishes, the command is
freed, then we immediately try to send another command to the same device
and in doing so we try to allocate another command, independent of any
other devices trying to send IO.

If a little or not recently used device (device_busy == 0) then tries to
get a command at this point and fails, it will effectively poll at some
interval, and (generally) race with any devices that have IO in flight.
But the device with IO in flight will try and get a command at a point
that is much more likely to succeed. If the little-used device is trying
to free memory (for swap or page cache, using only swap in my previous
examples was wrong), it might not make progress.

Adding the device that failed to get a command to the starved list would
solve the problem (though might be a bit hard now without creating a lock
hiearchy), as does having a per-device spare/cached command.

I do not have time now to code up something using the starved list in such
cases, or to try and actually hit the problem. This does not mean I agree
that the current code is sufficient in all cases.

I will re-work and resend the first patch (of the three) to use sdev_lock,
and to work for !GFP_ATOMIC, and not push for a per-device spare_cmd or
related patch at this time.

-- Patrick Mansfield
