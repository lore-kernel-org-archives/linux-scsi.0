From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V2 2/2] scsi: implement .cleanup_rq callback
Date: Mon, 22 Jul 2019 08:40:23 -0700
Message-ID: <eed624d5-0585-699c-9084-9f5f0ea09e52@acm.org>
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190720030637.14447-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190720030637.14447-3-ming.lei@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/19/19 8:06 PM, Ming Lei wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e1da8c70a266..52537c145762 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -154,12 +154,9 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
>   
>   static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
>   {
> -	if (cmd->request->rq_flags & RQF_DONTPREP) {
> -		cmd->request->rq_flags &= ~RQF_DONTPREP;
> -		scsi_mq_uninit_cmd(cmd);
> -	} else {
> -		WARN_ON_ONCE(true);
> -	}
> +	WARN_ON_ONCE(!(cmd->request->rq_flags & RQF_DONTPREP));
> +
> +	scsi_mq_uninit_cmd(cmd);
>   	blk_mq_requeue_request(cmd->request, true);
>   }

The above changes are independent of this patch series. Have you 
considered to move these into a separate patch?

> +/*
> + * Only called when the request isn't completed by SCSI, and not freed by
> + * SCSI
> + */
> +static void scsi_cleanup_rq(struct request *rq)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +
> +	scsi_mq_uninit_cmd(cmd);
> +}

Is the comment above this function correct? The previous patch adds an 
unconditional call to mq_ops->cleanup_rq() in blk_mq_free_request().

Thanks,

Bart.
