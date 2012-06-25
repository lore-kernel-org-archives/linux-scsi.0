From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Mon, 25 Jun 2012 13:36:07 -0700
Message-ID: <20120625203607.GJ3869@google.com>
References: <4FE8A9FC.6040805@acm.org>
 <4FE8AAB9.9060602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64236 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2FYUgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 16:36:12 -0400
Received: by dady13 with SMTP id y13so5816714dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2012 13:36:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FE8AAB9.9060602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

Hello,

This generally looks good to me but a couple comments.

On Mon, Jun 25, 2012 at 06:15:21PM +0000, Bart Van Assche wrote:
>  	if (q) {
> +		/*
> +		 * Note: freeing queuedata before invoking blk_cleanup_queue()
> +		 * is safe here because no request function is associated with
> +		 * uspace_req_q. See also the __scsi_alloc_queue() call in
> +		 * drivers/scsi/scsi_tgt_lib.c.
> +		 */
>  		kfree(q->queuedata);
>  		q->queuedata = NULL;
> -		scsi_free_queue(q);
> +		blk_cleanup_queue(q);

Why not just do blk_cleanup_queue() first and then free queuedata
using a local variable?  It's easier to grasp and less error-prone to
shut down the queue before destroying it.

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

Do these BUG_ON()s actually add anything?  Kernel is gonna oops in a
few lines on NULL sdev anyway.

Thanks.

-- 
tejun
