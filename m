Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9516AC63697
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BAA24682
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="hhHFSfTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgKRBNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:13:53 -0500
Received: from z5.mailgun.us ([104.130.96.5]:21442 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgKRBNw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 20:13:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605662032; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cUxMn5imX17kKTIZQZbc5Bzgw1YI/s6GNR1N/ZV6Dis=;
 b=hhHFSfTrNIekI/DM6ujqPzNEMIOupeBcS3Bm+1IiNuAKTGQFaV7WVpdAYGhXEPOEJixijZ/7
 YdKX74brW6xveUqiu7E5Pz6pVkGaT43Vlb14hssX6odmhR7BzbGbMjrBPgZ6m0zrQ0RYC2k4
 YQWXD56oaYosse//dIYQKQ6IWCA=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-west-2.postgun.com with SMTP id
 5fb4754e8e090a888672b62a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 01:13:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 184F8C43461; Wed, 18 Nov 2020 01:13:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18B13C433C6;
        Wed, 18 Nov 2020 01:13:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 09:13:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: Re: [PATCH v2 8/9] block, scsi, ide: Only process PM requests if
 rpm_status != RPM_ACTIVE
In-Reply-To: <20201116030459.13963-9-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
 <20201116030459.13963-9-bvanassche@acm.org>
Message-ID: <d6d49ba6b3ddbc4537c6eee8b72ea436@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-16 11:04, Bart Van Assche wrote:
> Instead of submitting all SCSI commands submitted with scsi_execute() 
> to
> a SCSI device if rpm_status != RPM_ACTIVE, only submit RQF_PM (power
> management requests) if rpm_status != RPM_ACTIVE. Remove flag
> RQF_PREEMPT since it is no longer necessary.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  block/blk-core.c        |  6 +++---
>  block/blk-mq-debugfs.c  |  1 -
>  block/blk-mq.c          |  4 ++--
>  drivers/ide/ide-io.c    |  3 +--
>  drivers/ide/ide-pm.c    |  2 +-
>  drivers/scsi/scsi_lib.c | 27 ++++++++++++++-------------
>  include/linux/blk-mq.h  |  4 ++--
>  include/linux/blkdev.h  |  6 +-----
>  8 files changed, 24 insertions(+), 29 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2db8bda43b6e..a00bce9f46d8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
>  /**
>   * blk_queue_enter() - try to increase q->q_usage_counter
>   * @q: request queue pointer
> - * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
> + * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
>   */
>  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  {
> -	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
> +	const bool pm = flags & BLK_MQ_REQ_PM;
> 
>  	while (true) {
>  		bool success = false;
> @@ -630,7 +630,7 @@ struct request *blk_get_request(struct
> request_queue *q, unsigned int op,
>  	struct request *req;
> 
>  	WARN_ON_ONCE(op & REQ_NOWAIT);
> -	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
> +	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
> 
>  	req = blk_mq_alloc_request(q, op, flags);
>  	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 3094542e12ae..9336a6f8d6ef 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -297,7 +297,6 @@ static const char *const rqf_name[] = {
>  	RQF_NAME(MIXED_MERGE),
>  	RQF_NAME(MQ_INFLIGHT),
>  	RQF_NAME(DONTPREP),
> -	RQF_NAME(PREEMPT),
>  	RQF_NAME(FAILED),
>  	RQF_NAME(QUIET),
>  	RQF_NAME(ELVPRIV),
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 1b25ec2fe9be..d50504888b68 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -292,8 +292,8 @@ static struct request *blk_mq_rq_ctx_init(struct
> blk_mq_alloc_data *data,
>  	rq->mq_hctx = data->hctx;
>  	rq->rq_flags = 0;
>  	rq->cmd_flags = data->cmd_flags;
> -	if (data->flags & BLK_MQ_REQ_PREEMPT)
> -		rq->rq_flags |= RQF_PREEMPT;
> +	if (data->flags & BLK_MQ_REQ_PM)
> +		rq->rq_flags |= RQF_PM;
>  	if (blk_queue_io_stat(data->q))
>  		rq->rq_flags |= RQF_IO_STAT;
>  	INIT_LIST_HEAD(&rq->queuelist);
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index 1a53c7a75224..beb850679fa9 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -522,8 +522,7 @@ blk_status_t ide_issue_rq(ide_drive_t *drive,
> struct request *rq,
>  		 * state machine.
>  		 */
>  		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
> -		    ata_pm_request(rq) == 0 &&
> -		    (rq->rq_flags & RQF_PREEMPT) == 0) {
> +		    ata_pm_request(rq) == 0) {
>  			/* there should be no pending command at this point */
>  			ide_unlock_port(hwif);
>  			goto plug_device;
> diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
> index 192e6c65d34e..82ab308f1aaf 100644
> --- a/drivers/ide/ide-pm.c
> +++ b/drivers/ide/ide-pm.c
> @@ -77,7 +77,7 @@ int generic_ide_resume(struct device *dev)
>  	}
> 
>  	memset(&rqpm, 0, sizeof(rqpm));
> -	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, 
> BLK_MQ_REQ_PREEMPT);
> +	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
>  	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
>  	ide_req(rq)->special = &rqpm;
>  	rqpm.pm_step = IDE_PM_START_RESUME;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index df1f22b32964..fd8d2f4d71f8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -248,7 +248,8 @@ int __scsi_execute(struct request_queue *q, const
> unsigned char *cmd,
>  	int ret = DRIVER_ERROR << 24;
> 
>  	req = blk_get_request(q, data_direction == DMA_TO_DEVICE ?
> -			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
> +			      REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
> +			      rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
>  	if (IS_ERR(req))
>  		return ret;
>  	rq = scsi_req(req);
> @@ -1204,6 +1205,8 @@ static blk_status_t
>  scsi_device_state_check(struct scsi_device *sdev, struct request *req)
>  {
>  	switch (sdev->sdev_state) {
> +	case SDEV_CREATED:
> +		return BLK_STS_OK;
>  	case SDEV_OFFLINE:
>  	case SDEV_TRANSPORT_OFFLINE:
>  		/*
> @@ -1230,18 +1233,18 @@ scsi_device_state_check(struct scsi_device
> *sdev, struct request *req)
>  		return BLK_STS_RESOURCE;
>  	case SDEV_QUIESCE:
>  		/*
> -		 * If the devices is blocked we defer normal commands.
> +		 * If the device is blocked we only accept power management
> +		 * commands.
>  		 */
> -		if (req && !(req->rq_flags & RQF_PREEMPT))
> +		if (req && WARN_ON_ONCE(!(req->rq_flags & RQF_PM)))
>  			return BLK_STS_RESOURCE;
>  		return BLK_STS_OK;
>  	default:
>  		/*
>  		 * For any other not fully online state we only allow
> -		 * special commands.  In particular any user initiated
> -		 * command is not allowed.
> +		 * power management commands.
>  		 */
> -		if (req && !(req->rq_flags & RQF_PREEMPT))
> +		if (req && !(req->rq_flags & RQF_PM))
>  			return BLK_STS_IOERR;
>  		return BLK_STS_OK;
>  	}
> @@ -2517,15 +2520,13 @@ void sdev_evt_send_simple(struct scsi_device 
> *sdev,
>  EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
> 
>  /**
> - *	scsi_device_quiesce - Block user issued commands.
> + *	scsi_device_quiesce - Block all commands except power management.
>   *	@sdev:	scsi device to quiesce.
>   *
>   *	This works by trying to transition to the SDEV_QUIESCE state
>   *	(which must be a legal transition).  When the device is in this
> - *	state, only special requests will be accepted, all others will
> - *	be deferred.  Since special requests may also be requeued requests,
> - *	a successful return doesn't guarantee the device will be
> - *	totally quiescent.
> + *	state, only power management requests will be accepted, all others 
> will
> + *	be deferred.
>   *
>   *	Must be called with user context, may sleep.
>   *
> @@ -2586,12 +2587,12 @@ void scsi_device_resume(struct scsi_device 
> *sdev)
>  	 * device deleted during suspend)
>  	 */
>  	mutex_lock(&sdev->state_mutex);
> +	if (sdev->sdev_state == SDEV_QUIESCE)
> +		scsi_device_set_state(sdev, SDEV_RUNNING);
>  	if (sdev->quiesced_by) {
>  		sdev->quiesced_by = NULL;
>  		blk_clear_pm_only(sdev->request_queue);
>  	}
> -	if (sdev->sdev_state == SDEV_QUIESCE)
> -		scsi_device_set_state(sdev, SDEV_RUNNING);
>  	mutex_unlock(&sdev->state_mutex);
>  }
>  EXPORT_SYMBOL(scsi_device_resume);
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index b23eeca4d677..1fa350592830 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -444,8 +444,8 @@ enum {
>  	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
>  	/* allocate from reserved pool */
>  	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
> -	/* set RQF_PREEMPT */
> -	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
> +	/* set RQF_PM */
> +	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 3),
>  };
> 
>  struct request *blk_mq_alloc_request(struct request_queue *q, unsigned 
> int op,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 639cae2c158b..7d4b746f7e6a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -79,9 +79,6 @@ typedef __u32 __bitwise req_flags_t;
>  #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
>  /* don't call prep for this one */
>  #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
> -/* set for "ide_preempt" requests and also for requests for which the 
> SCSI
> -   "quiesce" state must be ignored. */
> -#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
>  /* vaguely specified driver internal error.  Ignored by the block 
> layer */
>  #define RQF_FAILED		((__force req_flags_t)(1 << 10))
>  /* don't warn about errors */
> @@ -430,8 +427,7 @@ struct request_queue {
>  	unsigned long		queue_flags;
>  	/*
>  	 * Number of contexts that have called blk_set_pm_only(). If this
> -	 * counter is above zero then only RQF_PM and RQF_PREEMPT requests 
> are
> -	 * processed.
> +	 * counter is above zero then only RQF_PM requests are processed.
>  	 */
>  	atomic_t		pm_only;
