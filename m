From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing
 a device
Date: Mon, 25 Jun 2012 13:42:37 -0700
Message-ID: <20120625204237.GK3869@google.com>
References: <4FE8A9FC.6040805@acm.org>
 <4FE8AB2E.10400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2FYUmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 16:42:42 -0400
Received: by pbbrp8 with SMTP id rp8so7050219pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2012 13:42:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FE8AB2E.10400@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Joe Lawrence <jdl1291@gmail.com>

On Mon, Jun 25, 2012 at 06:17:18PM +0000, Bart Van Assche wrote:
> Avoid that the code for requeueing SCSI requests triggers a
> crash by making sure that that code isn't scheduled anymore
> after a device has been removed.
> 
> Also, source code inspection of __scsi_remove_device() revealed
> a race condition in this function: no new SCSI requests must be
> accepted for a SCSI device after device removal started.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Joe Lawrence <jdl1291@gmail.com>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: <stable@kernel.org>
> ---
>  drivers/scsi/scsi_lib.c   |    7 ++++---
>  drivers/scsi/scsi_sysfs.c |   11 +++++++++--
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 082c1e5..fc2b9f4 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -155,13 +155,14 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
>  
>  	/*
>  	 * Requeue this command.  It will go before all other commands
> -	 * that are already in the queue.
> +	 * that are already in the queue. Schedule requeue work under
> +	 * lock such that the kblockd_schedule_work() call happens
> +	 * before blk_cleanup_queue() finishes.
>  	 */
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	blk_requeue_request(q, cmd->request);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
>  	kblockd_schedule_work(q, &device->requeue_work);
> +	spin_unlock_irqrestore(q->queue_lock, flags);

This is rather subtle but yeah it would achieve proper
synchronization.  Can't think of a better way ATM.

Aside from the nits, for all patches in this series

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
