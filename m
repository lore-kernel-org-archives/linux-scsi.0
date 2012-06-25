From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Mon, 25 Jun 2012 22:14:49 +0100
Message-ID: <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33476 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823Ab2FYVOx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2012 17:14:53 -0400
In-Reply-To: <4FE8AAB9.9060602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Mon, 2012-06-25 at 18:15 +0000, Bart Van Assche wrote:
> Since scsi_prep_fn() may be invoked concurrently with
> __scsi_remove_device(), keep the queuedata pointer in
> __scsi_remove_device(). This patch fixes a kernel oops that
> can be triggered by USB device removal. See also
> http://www.spinics.net/lists/linux-scsi/msg56254.html.

This patch causes a subtle change of semantics: you're substituting our
signal for dead queue as !sdev with a check of blk_queue_dead(). 

> Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: <stable@kernel.org>
> ---
>  drivers/scsi/hosts.c      |    8 +++++++-
>  drivers/scsi/scsi_lib.c   |   35 ++++++++---------------------------
>  drivers/scsi/scsi_priv.h  |    1 -
>  drivers/scsi/scsi_sysfs.c |    5 +----
>  4 files changed, 16 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index a3a056a..6b9d89a 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -299,9 +299,15 @@ static void scsi_host_dev_release(struct device *dev)
>  		destroy_workqueue(shost->work_q);
>  	q = shost->uspace_req_q;
>  	if (q) {
> +		/*
> +		 * Note: freeing queuedata before invoking blk_cleanup_queue()
> +		 * is safe here because no request function is associated with
> +		 * uspace_req_q. See also the __scsi_alloc_queue() call in
> +		 * drivers/scsi/scsi_tgt_lib.c.
> +		 */

This comment doesn't really make a whole lot of sense.  What I think
it's saying is that it's OK for the commands executed by the drain in
blk_cleanup_queue to have a NULL queuedata and by the time we reach
this, there can be no concurrent racing calls to queuecommand?  Is this
true, and why?

>  		kfree(q->queuedata);
>  		q->queuedata = NULL;
> -		scsi_free_queue(q);
> +		blk_cleanup_queue(q);
>  	}
>  
>  	scsi_destroy_command_freelist(shost);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6dfb978..c26ef49 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -406,10 +406,7 @@ static void scsi_run_queue(struct request_queue *q)
>  	LIST_HEAD(starved_list);
>  	unsigned long flags;
>  
> -	/* if the device is dead, sdev will be NULL, so no queue to run */
> -	if (!sdev)
> -		return;
> -
> +	BUG_ON(!sdev);

Needs to be a blk_queue_dead() check as well.

>  	shost = sdev->host;
>  	if (scsi_target(sdev)->single_lun)
>  		scsi_single_lun_run(sdev);
> @@ -1370,16 +1367,18 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>   * may be changed after request stacking drivers call the function,
>   * regardless of taking lock or not.
>   *
> - * When scsi can't dispatch I/Os anymore and needs to kill I/Os
> - * (e.g. !sdev), scsi needs to return 'not busy'.
> - * Otherwise, request stacking drivers may hold requests forever.
> + * When scsi can't dispatch I/Os anymore and needs to kill I/Os scsi
> + * needs to return 'not busy'. Otherwise, request stacking drivers
> + * may hold requests forever.
>   */
>  static int scsi_lld_busy(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
>  	struct Scsi_Host *shost;
>  
> -	if (!sdev)
> +	BUG_ON(!sdev);
> +
> +	if (blk_queue_dead(q))
>  		return 0;
>  
>  	shost = sdev->host;
> @@ -1490,11 +1489,7 @@ static void scsi_request_fn(struct request_queue *q)
>  	struct scsi_cmnd *cmd;
>  	struct request *req;
>  
> -	if (!sdev) {
> -		while ((req = blk_peek_request(q)) != NULL)
> -			scsi_kill_request(req, q);
> -		return;
> -	}

That means that this hunk of code has to stay, but needs to be gated on
blk_queue_dead(q); there's still a race where this can occur.


> +	BUG_ON(!sdev);

I'm with Tejun, these BUG_ON's are now pretty pointless.

James


