From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Thu, 30 May 2019 08:36:30 -0700
Message-ID: <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 5/30/19 4:28 AM, Paolo Bonzini wrote:
> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
> +	.get_budget	= scsi_mq_get_budget,
> +	.put_budget	= scsi_mq_put_budget,
> +	.queue_rq	= scsi_queue_rq,
> +	.complete	= scsi_softirq_done,
> +	.timeout	= scsi_timeout,
> +#ifdef CONFIG_BLK_DEBUG_FS
> +	.show_rq	= scsi_show_rq,
> +#endif
> +	.init_request	= scsi_mq_init_request,
> +	.exit_request	= scsi_mq_exit_request,
> +	.initialize_rq_fn = scsi_initialize_rq,
> +	.busy		= scsi_mq_lld_busy,
> +	.map_queues	= scsi_map_queues,
> +};
> +
> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +	struct request_queue *q = hctx->queue;
> +	struct scsi_device *sdev = q->queuedata;
> +	struct Scsi_Host *shost = sdev->host;
> +
> +	shost->hostt->commit_rqs(shost, hctx->queue_num);
> +}
> +
>   static const struct blk_mq_ops scsi_mq_ops = {
>   	.get_budget	= scsi_mq_get_budget,
>   	.put_budget	= scsi_mq_put_budget,
>   	.queue_rq	= scsi_queue_rq,
> +	.commit_rqs	= scsi_commit_rqs,
>   	.complete	= scsi_softirq_done,
>   	.timeout	= scsi_timeout,
>   #ifdef CONFIG_BLK_DEBUG_FS

Hi Paolo,

Have you considered to modify the block layer such that a single 
scsi_mq_ops structure can be used for all SCSI LLD types?

Thanks,

Bart.
