From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: implement change_queue_depth
Date: Sat, 25 Dec 2004 01:36:17 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0412240126400.27610@poirot.grange>
References: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
 <1103826862.5290.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:63400 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261467AbULYAg4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2004 19:36:56 -0500
In-Reply-To: <1103826862.5290.39.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 23 Dec 2004, James Bottomley wrote:

> On Wed, 2004-12-22 at 13:15 +0100, Guennadi Liakhovetski wrote:
> > Further to my recent doubts wrt change_queue_depth semantics, I decided to 
> > just implement this function for tmscsim following comments in 
> > scsi_host.h. If this gets accepted in this form (returning -EIO if depth 
> > != sdev->queue_depth after scsi_adjust_depth_queue), I'll submit patches 
> > to 53c700.c and a comment-modification to scsi_host.h.
> 
> Actually, there's currently no way for scsi_adjust_queue_depth to fail,
> so the check really isn't necessary.

Well, I didn't look in the block layer command queue handling, I just saw 
this in scsi_adjust_queue_depth

	/* Check to see if the queue is managed by the block layer
	 * if it is, and we fail to adjust the depth, exit */
	if (blk_queue_tagged(sdev->request_queue) &&
	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
		goto out;

and thought that this failure case has to be reported back... Like, if 
somebody was trying to set queue depth for a device that doesn't support 
it. Or would this be impossible for another reason?

> Also, even if it were, the correct return would be either -EINVAL, or
> the true nature of the error (most likely -ENOMEM).

The return value from the blk_queue_resize_tags in the error case is not 
returned, so, it is either -ENXIO, in which case, I guess, the 
blk_queue_tagged test would just fail.

Am I missing anything?

> The idea of the error return is more for drivers that have to allocate
> internal resources to tag queues, so they can fail in those allocations.

Thanks
Guennadi
---
Guennadi Liakhovetski

