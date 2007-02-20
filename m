From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 12:03:48 -0600
Message-ID: <45DB3804.7020201@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0702201056040.4992-100000@iolanthe.rowland.org> <45DB330D.2070501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54936 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030328AbXBTSEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Feb 2007 13:04:06 -0500
In-Reply-To: <45DB330D.2070501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

Mike Christie wrote:
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
> 
Oh yeah, you could also check how large the reserved buffer is already.
The estimate above does not take into account if we had already
allocated a nice large reserved buffer with large segments.
