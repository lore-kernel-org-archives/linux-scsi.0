From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Fri, 27 Aug 2004 11:09:18 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:9220 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266069AbUH0PJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 11:09:20 -0400
In-Reply-To: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 23 2004, Jens Axboe wrote:

> Ok, let me try to explain. There are several factors that limit how big
> a command you can send to a device - some of these are hardware, some of
> these are just imposed by the driver. If you look inside the
> request_queue structure in blkdev.h, you'll find such things as:
> 
>         unsigned short          max_sectors;
>         unsigned short          max_phys_segments;
>         unsigned short          max_hw_segments;
>         unsigned int            max_segment_size;
> 
> which are set by the driver and limit how big a request you can submit
> through SG_IO.

Is it then correct to say that max_sectors is limited only by the
capabilities of the low-level driver and the hardware?  So that within
usb-storage, for example, where the protocol only limits us to 4 GB per
transfer, there would be no problem allowing max_sectors to go as high as
65535?

I wasn't sure whether there were any other limitations somewhere else in 
the block layer, so for now in usb-storage max_sectors is capped at 
SCSI_DEFAULT_MAX_SECTORS = 1024.  Allowing it to increase by almost a 
factor of 64 could remove a lot of latency.

Alan Stern

