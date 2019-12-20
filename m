Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3B9C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B20B62072B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 23:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9JWXw6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLTXiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 18:38:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726470AbfLTXiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 18:38:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576885089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a1K7UMnwlYeyHcRtSvSMlJAlO4Y/BBB4Ac0xrO2mUgg=;
        b=h9JWXw6m+nGjKB8+Pu/nLLJL9ZxthKjvq1XinUfpeMUZEBNAJ8z0ZcX9typ/TiDTeSkPae
        ekKoEC81KnxVxsCK8eluGyUMrrtE/HRy3eaMmCewGefW8zfHHyhfDEmVtq83NSMQ/dF5oU
        aksgvAvkLF/A1E3mXAvNaPGMNItv8nQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-Z7qfQJR_OfSeyx-1e4N5fw-1; Fri, 20 Dec 2019 18:37:59 -0500
X-MC-Unique: Z7qfQJR_OfSeyx-1e4N5fw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5E7477;
        Fri, 20 Dec 2019 23:37:57 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C678160C81;
        Fri, 20 Dec 2019 23:37:49 +0000 (UTC)
Date:   Sat, 21 Dec 2019 07:37:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Long Li <longli@microsoft.com>
Subject: Re: [PATCH V3] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Message-ID: <20191220233744.GC12403@ming.t460p>
References: <20191121032634.32650-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121032634.32650-1-ming.lei@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 21, 2019 at 11:26:34AM +0800, Ming Lei wrote:
> Now the request queue is run in scsi_end_request() unconditionally if both
> target queue and host queue is ready. We should have re-run request queue
> only after this device queue becomes busy for restarting this LUN only.
> 
> Recently Long Li reported that cost of run queue may be very heavy in
> case of high queue depth. So improve this situation by only running
> the request queue when this LUN is busy.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Long Li <longli@microsoft.com>
> Reported-by: Long Li <longli@microsoft.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V3:
> 	- add one smp_mb() in scsi_mq_get_budget() and comment
> 
> V2:
> 	- commit log change, no any code change
> 	- add reported-by tag
> 
> 
>  drivers/scsi/scsi_lib.c    | 43 ++++++++++++++++++++++++++++++++++++--
>  include/scsi/scsi_device.h |  1 +
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 379533ce8661..d3d237a09a78 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -607,12 +607,17 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>  	 */
>  	percpu_ref_get(&q->q_usage_counter);
>  
> +	/*
> +	 * One smp_mb() is implied by either rq->end_io or
> +	 * blk_mq_free_request for ordering writing .device_busy in
> +	 * scsi_device_unbusy() and reading sdev->restart.
> +	 */
>  	__blk_mq_end_request(req, error);
>  
>  	if (scsi_target(sdev)->single_lun ||
>  	    !list_empty(&sdev->host->starved_list))
>  		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> +	else if (READ_ONCE(sdev->restart))
>  		blk_mq_run_hw_queues(q, true);
>  
>  	percpu_ref_put(&q->q_usage_counter);
> @@ -1632,8 +1637,42 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
>  	struct request_queue *q = hctx->queue;
>  	struct scsi_device *sdev = q->queuedata;
>  
> -	if (scsi_dev_queue_ready(q, sdev))
> +	if (scsi_dev_queue_ready(q, sdev)) {
> +		WRITE_ONCE(sdev->restart, 0);
>  		return true;
> +	}
> +
> +	/*
> +	 * If all in-flight requests originated from this LUN are completed
> +	 * before setting .restart, sdev->device_busy will be observed as
> +	 * zero, then blk_mq_delay_run_hw_queue() will dispatch this request
> +	 * soon. Otherwise, completion of one of these request will observe
> +	 * the .restart flag, and the request queue will be run for handling
> +	 * this request, see scsi_end_request().
> +	 *
> +	 * However, the .restart flag may be cleared from other dispatch code
> +	 * path after one inflight request is completed, then:
> +	 *
> +	 * 1) if this request is dispatched from scheduler queue or sw queue one
> +	 * by one, this request will be handled in that dispatch path too given
> +	 * the request still stays at scheduler/sw queue when calling .get_budget()
> +	 * callback.
> +	 *
> +	 * 2) if this request is dispatched from hctx->dispatch or
> +	 * blk_mq_flush_busy_ctxs(), this request will be put into hctx->dispatch
> +	 * list soon, and blk-mq will be responsible for covering it, see
> +	 * blk_mq_dispatch_rq_list().
> +	 */
> +	WRITE_ONCE(sdev->restart, 1);
> +
> +	/*
> +	 * Order writting .restart and reading .device_busy, and make sure
> +	 * .restart is visible to scsi_end_request(). Its pair is implied by
> +	 * __blk_mq_end_request() in scsi_end_request() for ordering
> +	 * writing .device_busy in scsi_device_unbusy() and reading .restart.
> +	 *
> +	 */
> +	smp_mb();
>  
>  	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
>  		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 202f4d6a4342..9d8ca662ae86 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -109,6 +109,7 @@ struct scsi_device {
>  	atomic_t device_busy;		/* commands actually active on LLDD */
>  	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
>  
> +	unsigned int restart;
>  	spinlock_t list_lock;
>  	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
>  	struct list_head starved_entry;
> -- 
> 2.20.1
> 

Ping...

Thanks,
Ming

