From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] scsi: fix shared tag map setup
Date: Fri, 11 Jul 2008 15:58:26 -0500
Message-ID: <4877C972.9070706@cs.wisc.edu>
References: <1214721027-32426-1-git-send-email-michaelc@cs.wisc.edu> <1214721027-32426-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49140 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbYGKU6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 16:58:35 -0400
In-Reply-To: <1214721027-32426-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> Currently qla4xxx and stex pass in their can_queue values into
> scsi_activate_tcq because they wanted the tag map that large.
> The problem with this is that it ends up also setting the queue
> depth to that large value. All we want to do this in this case
> is set the device queue depth and the other device settings.
> We do not need to touch the tag map sizing because the drivers
> had setup that map according to their can_queue limits when the
> shared map was created.
> 
> The scsi mid layer in request_fn will then handle the case where we
> have more requests than available tags when it checks the host
> queue ready function.
> 

Actually, I think this code needs one more fix to scsi_request_fn.

If we hit this in scsi_request_fn:

if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
	blkdev_dequeue_request(req);

blk_queue_tagged would be 1. blk_queue_start_tag could return 1 if we 
have too many commands. And then we will accidentally dequeue the 
request, and when we get to the host queue ready function, we could have 
raced with a completion which would have decreased the host_busy and so 
the command will be queued to the driver without a tag.

I will reroll these patches and add a fix to request_fn for this other 
problem and resend it all in one patchset.
