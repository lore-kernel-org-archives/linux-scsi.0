From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: implement change_queue_depth
Date: Sun, 26 Dec 2004 09:49:26 -0600
Message-ID: <1104076166.5268.22.camel@mulgrave>
References: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
	 <1103826862.5290.39.camel@mulgrave>
	 <Pine.LNX.4.60.0412240126400.27610@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16564 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261681AbULZPuU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Dec 2004 10:50:20 -0500
In-Reply-To: <Pine.LNX.4.60.0412240126400.27610@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-12-25 at 01:36 +0100, Guennadi Liakhovetski wrote:
> Well, I didn't look in the block layer command queue handling, I just saw 
> this in scsi_adjust_queue_depth
> 
> 	/* Check to see if the queue is managed by the block layer
> 	 * if it is, and we fail to adjust the depth, exit */
> 	if (blk_queue_tagged(sdev->request_queue) &&
> 	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
> 		goto out;
> 
> and thought that this failure case has to be reported back... Like, if 
> somebody was trying to set queue depth for a device that doesn't support 
> it. Or would this be impossible for another reason?

No, it's not impossible.  However trying to second guess what went wrong
in an API when it doesn't return an error condition to you is a bad
thing.  You can return errors from things you know about or from things
you're told about, but you shouldn't do it by using heuristics to guess
that there was an error in certain cases (well unless the heuristics are
a documented part of the API).

James


