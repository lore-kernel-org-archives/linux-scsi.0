From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5] scsi: Avoid dangling pointer in scsi_requeue_command()
Date: Fri, 29 Jun 2012 11:06:21 -0500
Message-ID: <4FEDD27D.4010803@cs.wisc.edu>
References: <4FEDCA26.90804@acm.org> <4FEDCB02.6070600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33463 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2F2QOn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jun 2012 12:14:43 -0400
In-Reply-To: <4FEDCB02.6070600@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Muthukumar Ratty <muthur@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

On 06/29/2012 10:34 AM, Bart Van Assche wrote:
> Reported-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: <stable@kernel.org>
> ---
>   drivers/scsi/scsi_lib.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7ebe167..af6357a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -479,15 +479,24 @@ void scsi_requeue_run_queue(struct work_struct *work)
>    */
>   static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
>   {
> +	struct scsi_device *sdev = cmd->device;
>   	struct request *req = cmd->request;
>   	unsigned long flags;
>
> +	/*
> +	 * We need to hold a reference on the device to avoid that the queue
> +	 * gets killed after the unlock and before scsi_run_queue is invoked.
> +	 */
> +	get_device(&sdev->sdev_gendev);
> +
>   	spin_lock_irqsave(q->queue_lock, flags);
>   	scsi_unprep_request(req);
>   	blk_requeue_request(q, req);
>   	spin_unlock_irqrestore(q->queue_lock, flags);
>
>   	scsi_run_queue(q);
> +
> +	put_device(&sdev->sdev_gendev);
>   }
>
>   void scsi_next_command(struct scsi_cmnd *cmd)
>

Looks ok to me

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
