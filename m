From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 11:42:37 -0600
Message-ID: <45DB330D.2070501@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0702201056040.4992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54854 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953AbXBTRnB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Feb 2007 12:43:01 -0500
In-Reply-To: <Pine.LNX.4.44L0.0702201056040.4992-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> This patch (as857) modifies the SG_GET_RESERVED_SIZE and
> SG_SET_RESERVED_SIZE ioctls in the sg driver, capping the values at
> the device's request_queue's max_sectors value.  This will permit
> cdrecord to obtain a legal value for the maximum transfer length,
> fixing Bugzilla #7026.
> 
> The patch also caps the initial reserved_size value.  There's no
> reason to have a reserved buffer larger than max_sectors, since it
> would be impossible to use the extra space.
> 
> The corresponding ioctls in the block layer are modified similarly,
> and the initial value for the reserved_size is set as large as
> possible.  This will effectively make it default to max_sectors.
> Note that the actual value is meaningless anyway, since block devices
> don't have a reserved buffer.
> 
> Finally, the BLKSECTGET ioctl is added to sg, so that there will be a
> uniform way for users to determine the actual max_sectors value for
> any raw SCSI transport.

I think you actually want max_hw_sectors. Well, you might and you might
not :) I think a estimate of the max transfer length would be more like:

unsigned int max_segment_size, max_xfer,
int max_segments;

/*
 * does not account for any weird arch segments boundary limits
 * or vmerge limits
 */
if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
	max_segment_size = PAGE_SIZE;
else
	max_segment_size = q->max_segment_size;

max_segments = min(q->max_hw_segments, q->max_phys_segments);

max_xfer = min(q->max_hw_sectors * 512,
		max_segments * max_segment_size);

return max_xfer;


The problem is that we assume we will get nice large segments. When
using sg it will try to allocate multiple pages and make large segments.
We could hit a bad case where we cannot allocate enough large segments,
so a worst case would result in a max_segment_size of PAGE_SIZE:

max_segments = min(q->max_hw_segments, q->max_phys_segments);

max_xfer = min(q->max_hw_sectors * 512,
		max_segments * PAGE_SIZE);

return max_xfer;

I think you have to take into account the scatterlist limits because
some drivers like lpfc have a small sht->sg_tablesize/q->max_hw_segments
(64), but have a large q->max_hw_sectors (0xFFFF) and uses the default
q->max_sectors (1024). So in the worst case we could end up with a max
transfer size of only 64 * PAGE_SIZE and this a lot smaller than
q->max_sectors.
