From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: implement change_queue_depth
Date: Sun, 26 Dec 2004 22:49:47 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0412262034030.3808@poirot.grange>
References: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
 <1103826862.5290.39.camel@mulgrave>  <Pine.LNX.4.60.0412240126400.27610@poirot.grange>
 <1104076166.5268.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:8908 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261360AbULZX6U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Dec 2004 18:58:20 -0500
In-Reply-To: <1104076166.5268.22.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 26 Dec 2004, James Bottomley wrote:

> On Sat, 2004-12-25 at 01:36 +0100, Guennadi Liakhovetski wrote:
> > Well, I didn't look in the block layer command queue handling, I just saw 
> > this in scsi_adjust_queue_depth
> > 
> > 	/* Check to see if the queue is managed by the block layer
> > 	 * if it is, and we fail to adjust the depth, exit */
> > 	if (blk_queue_tagged(sdev->request_queue) &&
> > 	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
> > 		goto out;
> > 
> > and thought that this failure case has to be reported back... Like, if 
> > somebody was trying to set queue depth for a device that doesn't support 
> > it. Or would this be impossible for another reason?
> 
> No, it's not impossible.  However trying to second guess what went wrong
> in an API when it doesn't return an error condition to you is a bad
> thing.

Ok. Would it make sense / be accepted to change this sitation by either 1) 
adding a new function __scsi_adjust_queue_depth() which would pass the 
return code of the block-layer, or 2) modifying the existing function to 
return an error? 1) has disadvantages, that it's a) confusing, b) even 
more confusing, because that other function also has to be exported. 2) 
has the disadvantage of changing an exported API in the "stable" series... 
I would go for 2) especially with the current extended understanding of 
the "stable" kernel series. I could roll a patch for either of these 2 
possibilities, if the latter is chosen I could try to fix the current 
users to check the return code.

As it is, the worst that can happen is that somebody tries to set 
queue_depth to a value through sysfs, we return positive return code, but 
the value is unchanged, which can be confirmed by cat'ing the same file. 
How bad is this? Does any other caller of scsi_adjust_queue_depth care if 
it really succeeded?

Thanks
Guennadi
---
Guennadi Liakhovetski

