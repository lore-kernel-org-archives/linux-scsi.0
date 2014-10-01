From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/8] scsi: remove scsi_next_command
Date: Wed, 01 Oct 2014 14:06:03 +0200
Message-ID: <542BEE2B.6030105@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:40253 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAMGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:06:05 -0400
In-Reply-To: <1410107469-896-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> There's only one caller left, so inline it and reduce the blk-mq vs !blk-mq
> diff a litte bit.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c  | 18 ++++--------------
>   drivers/scsi/scsi_priv.h |  1 -
>   2 files changed, 4 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8b76231..f21e661 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -542,17 +542,6 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
>   	put_device(&sdev->sdev_gendev);
>   }
>
> -void scsi_next_command(struct scsi_cmnd *cmd)
> -{
> -	struct scsi_device *sdev = cmd->device;
> -	struct request_queue *q = sdev->request_queue;
> -
> -	scsi_put_command(cmd);
> -	scsi_run_queue(q);
> -
> -	put_device(&sdev->sdev_gendev);
> -}
> -
>   void scsi_run_host_queues(struct Scsi_Host *shost)
>   {
>   	struct scsi_device *sdev;
> @@ -730,8 +719,6 @@ static bool scsi_end_request(struct request *req, int error,
>   			kblockd_schedule_work(&sdev->requeue_work);
>   		else
>   			blk_mq_start_stopped_hw_queues(q, true);
> -
> -		put_device(&sdev->sdev_gendev);
>   	} else {
>   		unsigned long flags;
>
> @@ -742,9 +729,12 @@ static bool scsi_end_request(struct request *req, int error,
>   		if (bidi_bytes)
>   			scsi_release_bidi_buffers(cmd);
>   		scsi_release_buffers(cmd);
> -		scsi_next_command(cmd);
> +
> +		scsi_put_command(cmd);
> +		scsi_run_queue(q);
>   	}
>
> +	put_device(&sdev->sdev_gendev);
>   	return false;
>   }
>
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 12b8e1b..2a382c1 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -84,7 +84,6 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
>   extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
>   extern void scsi_device_unbusy(struct scsi_device *sdev);
>   extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
> -extern void scsi_next_command(struct scsi_cmnd *cmd);
>   extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
>   extern void scsi_run_host_queues(struct Scsi_Host *shost);
>   extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
>


Reviewed-by: Bart Van Assche <bvanassche@acm.org>
