From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: blk request timeout handler against 2.6.26
Date: Thu, 19 Jun 2008 10:17:41 -0700
Message-ID: <20080619171741.GB819@linux.vnet.ibm.com>
References: <20080503020000.GU14976@parisc-linux.org> <20080507074357.GP329@kernel.dk> <20080513032012.GC9511@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60163 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbYFSRSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2008 13:18:03 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5JHHtHU022615
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2008 13:17:55 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5JHHjkV233156
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2008 13:17:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5JHHjue019567
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2008 13:17:45 -0400
Content-Disposition: inline
In-Reply-To: <20080513032012.GC9511@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Jens,

What is the status of the blk request timeout handler patches? I noticed
the branch is showing no update for 7 months and the updates sent to the
list received no response.

I was working on a abort function patch on top of the timeout patches to
see if I could speed up some multipath failure over cases and wanted to
understand if the blk timeout patch set was still a valid patch set.


malahal@us.ibm.com <malahal@us.ibm.com> wrote:
> Add missing queue lock in blk_complete_request(). Ran disktest for few
> hours and it works fine with this patch.
> 
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> diff -r c06b3eb1f516 block/blk-core.c
> --- a/block/blk-core.c	Wed May 07 20:07:12 2008 -0700
> +++ b/block/blk-core.c	Wed May 07 20:17:03 2008 -0700
> @@ -1856,6 +1856,10 @@
>   */
>  void blk_complete_request(struct request *req)
>  {
> +	unsigned long flags;
> +	struct request_queue *q = req->q;
> +	int rc;
> +
>  	/*
>  	 * We don't have to worry about this one timing out any more.
>  	 * If we are unable to remove the timer, then the command
> @@ -1864,7 +1868,10 @@
>  	 * that function could really be.  It might be on another processor,
>  	 * etc, etc.
>  	 */
> -	if (!blk_delete_timer(req))
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	rc = blk_delete_timer(req);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +	if (!rc)
>  		return;
> 
>  	__blk_complete_request(req);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
