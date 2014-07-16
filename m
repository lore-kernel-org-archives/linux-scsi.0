From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 13/14] scsi: add support for a blk-mq based I/O path.
Date: Wed, 16 Jul 2014 06:13:21 -0500
Message-ID: <53C65E51.3090003@cs.wisc.edu>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-14-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-14-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 11:52 AM, Christoph Hellwig wrote:
> +static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> +{
> +	struct request_queue *q = req->q;
> +	struct scsi_device *sdev = q->queuedata;
> +	struct Scsi_Host *shost = sdev->host;
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +	int ret;
> +	int reason;
> +
> +	ret = prep_to_mq(scsi_prep_state_check(sdev, req));
> +	if (ret)
> +		goto out;
> +
> +	ret = BLK_MQ_RQ_QUEUE_BUSY;
> +	if (!get_device(&sdev->sdev_gendev))
> +		goto out;
> +
> +	if (!scsi_dev_queue_ready(q, sdev))
> +		goto out_put_device;
> +	if (!scsi_target_queue_ready(shost, sdev))
> +		goto out_dec_device_busy;
> +	if (!scsi_host_queue_ready(q, shost, sdev))
> +		goto out_dec_target_busy;
> +
> +	if (!(req->cmd_flags & REQ_DONTPREP)) {
> +		ret = prep_to_mq(scsi_mq_prep_fn(req));
> +		if (ret)
> +			goto out_dec_host_busy;
> +		req->cmd_flags |= REQ_DONTPREP;
> +	}
> +
> +	scsi_init_cmd_errh(cmd);
> +	cmd->scsi_done = scsi_mq_done;
> +
> +	reason = scsi_dispatch_cmd(cmd);
> +	if (reason) {
> +		scsi_set_blocked(cmd, reason);
> +		ret = BLK_MQ_RQ_QUEUE_BUSY;
> +		goto out_dec_host_busy;
> +	}
> +
> +	return BLK_MQ_RQ_QUEUE_OK;
> +
> +out_dec_host_busy:
> +	cancel_delayed_work(&cmd->abort_work);

Hey Christoph,

I see the request timer is started before calling queue_rq, but I could
not figure out what the cancel_delayed_work here is for exactly. It
seems if the request were to time out and the eh started while queue_rq
was running we could end up some nasty bugs like the requested requeued
twice.

Is the cancel_delayed_work call just to be safe or is supposed to be
handling a case where the abort_work could be queued at this time up due
to a request timing out while queue_rq is running? Is this case mq specific?
