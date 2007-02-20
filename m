From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 13:17:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702201310340.8957-100000@iolanthe.rowland.org>
References: <45DB330D.2070501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58354 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030347AbXBTSRh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 13:17:37 -0500
In-Reply-To: <45DB330D.2070501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 Feb 2007, Mike Christie wrote:

> I think you actually want max_hw_sectors. Well, you might and you might
> not :)

I think we do not.  We don't care about the maximum transfer length the
driver can theoretically support; we care about the maximum transfer
length the system will allow.  For example, if max_sectors is 240 and
max_hw_sectors is 512 then the system will reject a attempted transfer of
300 sectors, even though the hardware is capable of carrying it out.

> I think a estimate of the max transfer length would be more like:
> 
> unsigned int max_segment_size, max_xfer,
> int max_segments;
> 
> /*
>  * does not account for any weird arch segments boundary limits
>  * or vmerge limits
>  */
> if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
> 	max_segment_size = PAGE_SIZE;
> else
> 	max_segment_size = q->max_segment_size;
> 
> max_segments = min(q->max_hw_segments, q->max_phys_segments);
> 
> max_xfer = min(q->max_hw_sectors * 512,
> 		max_segments * max_segment_size);

Isn't it possible that this multiplication might overflow?

> 
> return max_xfer;
> 
> 
> The problem is that we assume we will get nice large segments. When
> using sg it will try to allocate multiple pages and make large segments.
> We could hit a bad case where we cannot allocate enough large segments,
> so a worst case would result in a max_segment_size of PAGE_SIZE:
> 
> max_segments = min(q->max_hw_segments, q->max_phys_segments);
> 
> max_xfer = min(q->max_hw_sectors * 512,
> 		max_segments * PAGE_SIZE);
> 
> return max_xfer;

That is a very pessimistic estimate.  I don't see any reason for using it, 
especially since sg sets aside a reserved buffer which guarantees that a 
certain minimum amount of memory will always be available.

> I think you have to take into account the scatterlist limits because
> some drivers like lpfc have a small sht->sg_tablesize/q->max_hw_segments
> (64), but have a large q->max_hw_sectors (0xFFFF) and uses the default
> q->max_sectors (1024). So in the worst case we could end up with a max
> transfer size of only 64 * PAGE_SIZE and this a lot smaller than
> q->max_sectors.

Would you care to rewrite the patch?

Keep in mind particularly that the SG_GET_RESERVED_SIZE ioctl is supposed 
to return the size of the reserved area, not the maximum transfer length.

Alan Stern

