From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Fri, 10 Jun 2016 09:19:01 -0400
Message-ID: <20160610131901.GA28570@redhat.com>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbcFJNTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 09:19:04 -0400
Content-Disposition: inline
In-Reply-To: <1464593093-93527-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>

On Mon, May 30 2016 at  3:24am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> When checking a cloned request there is no need to check
> the overall request size; this won't have changed even
> when resubmitting to another queue.
> Without this patch ppc64le on ibmvfc fails to boot.

By simply removing the check aren't you papering over the real problem?
Looking at Martin's commit f31dc1cd490539 (which introduced the current
variant of the limits check) I'm not convinced it is equivalent to what
he replaced.  I'll look closer in a bit.

Also you categorized your fix was for "ppc64le on ibmvfc"; whereas Mark
has reported this issue (off-list) against x86_64.  By making it seem
ppc64le specific I didn't take this patch to be generally applicable.

Mike

> ---
>  block/blk-core.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2475b1c7..e108bf0 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2160,11 +2160,6 @@ EXPORT_SYMBOL(submit_bio);
>  static int blk_cloned_rq_check_limits(struct request_queue *q,
>  				      struct request *rq)
>  {
> -	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
> -		printk(KERN_ERR "%s: over max size limit.\n", __func__);
> -		return -EIO;
> -	}
> -
>  	/*
>  	 * queue's settings related to segment counting like q->bounce_pfn
>  	 * may differ from that of other stacking queues.
> -- 
> 1.8.5.6
> 
