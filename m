From: David Rientjes <rientjes@google.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 15:49:59 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1404251547020.6936@chino.kir.corp.google.com>
References: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57433 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaDYWuC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2014 18:50:02 -0400
Received: by mail-pb0-f50.google.com with SMTP id md12so3710637pbc.9
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2014 15:50:01 -0700 (PDT)
In-Reply-To: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Fri, 25 Apr 2014, James Bottomley wrote:

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 65a123d..9db097a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -137,6 +137,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
>  	 * lock such that the kblockd_schedule_work() call happens
>  	 * before blk_cleanup_queue() finishes.
>  	 */
> +	cmd->result = 0;
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	blk_requeue_request(q, cmd->request);
>  	kblockd_schedule_work(q, &device->requeue_work);
> @@ -1044,6 +1045,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>   */
>  int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  {
> +	struct scsi_device *sdev = cmd->device;
>  	struct request *rq = cmd->request;
>  
>  	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
> @@ -1091,7 +1093,7 @@ err_exit:
>  	scsi_release_buffers(cmd);
>  	cmd->request->special = NULL;
>  	scsi_put_command(cmd);
> -	put_device(&cmd->device->sdev_gendev);
> +	put_device(&sdev->sdev_gendev);
>  	return error;
>  }
>  EXPORT_SYMBOL(scsi_init_io);

Hmm, I see why this is needed because of the scsi_put_command(cmd), but I 
think you need to do struct scsi_device *sdev = ACCESS_ONCE(cmd->device) 
instead to prevent gcc from messing with the code generation.
