From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Sat, 28 Aug 2004 16:31:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828143124.GB2518@suse.de>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org> <Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:39063 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266319AbUH1Obl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 10:31:41 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Aug 27 2004, Alan Stern wrote:
> On Mon, Aug 23 2004, Jens Axboe wrote:
> 
> > Ok, let me try to explain. There are several factors that limit how big
> > a command you can send to a device - some of these are hardware, some of
> > these are just imposed by the driver. If you look inside the
> > request_queue structure in blkdev.h, you'll find such things as:
> > 
> >         unsigned short          max_sectors;
> >         unsigned short          max_phys_segments;
> >         unsigned short          max_hw_segments;
> >         unsigned int            max_segment_size;
> > 
> > which are set by the driver and limit how big a request you can submit
> > through SG_IO.
> 
> Is it then correct to say that max_sectors is limited only by the
> capabilities of the low-level driver and the hardware?  So that within

Yes

> usb-storage, for example, where the protocol only limits us to 4 GB per
> transfer, there would be no problem allowing max_sectors to go as high as
> 65535?

If the hardware and driver can handle it, there's no other limit.

> I wasn't sure whether there were any other limitations somewhere else in 
> the block layer, so for now in usb-storage max_sectors is capped at 
> SCSI_DEFAULT_MAX_SECTORS = 1024.  Allowing it to increase by almost a 
> factor of 64 could remove a lot of latency.

How do you come to that conclusion? 1024 is probably a fine value,
usually there's very little benefit to going higher than that (since
huge requests on slower hardware increases latency quite a lot, and huge
requests only provide little (if any) throughput increase on fast
hardware).

That said, it still wants splitting into two before you should go
higher.

-- 
Jens Axboe

