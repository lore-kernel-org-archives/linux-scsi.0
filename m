Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF224C2D0A7
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 19:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB01207DE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 19:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vm1V/tMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbgIHTtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:49:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44108 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731021AbgIHTtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 15:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599594545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ALhtEWOEC7gkdKOYPAZ7zsMJaLqsX3jNIt6ep7ZONeQ=;
        b=Vm1V/tMCh3cCDejV4N6SQsZH35p1ivdOuyadIg31VpLlUHOcuz1hHPbmHdC3P4qWgdRE4o
        TFcQMZF9Nnt7XsfWifHYpBcF8ReXbpLpnWLpiKaP5WbDiRrU27YNHFNAfscs/+U/lKamvs
        CI5R3j1vR5rKE1XgzP5jdDZUECN9crg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-reAhSy72OduifBzAkGiIgg-1; Tue, 08 Sep 2020 15:49:01 -0400
X-MC-Unique: reAhSy72OduifBzAkGiIgg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D8851009444;
        Tue,  8 Sep 2020 19:48:54 +0000 (UTC)
Received: from ovpn-113-26.phx2.redhat.com (ovpn-113-26.phx2.redhat.com [10.3.113.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E609D8246C;
        Tue,  8 Sep 2020 19:48:50 +0000 (UTC)
Message-ID: <f2cb32ca8db9445bbf51b48a4e03167e8dd5fdf4.camel@redhat.com>
Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
Date:   Tue, 08 Sep 2020 15:48:49 -0400
In-Reply-To: <20200817100840.2496976-1-ming.lei@redhat.com>
References: <20200817100840.2496976-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So we ran a whole bunch of tests with this patch applied, to see if
it would cause any problems, and it ran OK.  The V5 patch just posted
yesterday does not appear to change the logic functionally.

See below for comments.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Mon, 2020-08-17 at 18:08 +0800, Ming Lei wrote:
> Now the request queue is run in scsi_end_request() unconditionally if both
> target queue and host queue is ready. We should have re-run request queue
> only after this device queue becomes busy for restarting this LUN only.
> 
> Recently Long Li reported that cost of run queue may be very heavy in
> case of high queue depth. So improve this situation by only running
> the request queue when this LUN is busy.
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Long Li <longli@microsoft.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: linux-block@vger.kernel.org
> Reported-by: Long Li <longli@microsoft.com>
> Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V4:
> 	- fix one race reported by Kashyap, and simplify the implementation
> 	a bit; also pass Kashyap's both function and performance test
> V3:
> 	- add one smp_mb() in scsi_mq_get_budget() and comment
> 
> V2:
> 	- commit log change, no any code change
> 	- add reported-by tag
> 
>  drivers/scsi/scsi_lib.c    | 51 +++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_device.h |  1 +
>  2 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7c6dd6f75190..a62c29058d26 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -551,8 +551,27 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
>  	if (scsi_target(sdev)->single_lun ||
>  	    !list_empty(&sdev->host->starved_list))
>  		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> -		blk_mq_run_hw_queues(sdev->request_queue, true);
> +	else {
> +		/*
> +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
> +		 * is for ordering writing .device_busy in scsi_device_unbusy()
> +		 * and reading sdev->restarts.
> +		 */
> +		int old = atomic_read(&sdev->restarts);
> +
> +		if (old) {
> +			/*
> +			 * ->restarts has to be kept as non-zero if there is
> +			 *  new budget contention comes.
> +			 *
> +			 *  No need to run queue when either another re-run
> +			 *  queue wins in updating ->restarts or one new budget
> +			 *  contention comes.
> +			 */
> +			if (atomic_cmpxchg(&sdev->restarts, old, 0) == old)
> +				blk_mq_run_hw_queues(sdev->request_queue, true);
> +		}
> +	}
>  }
>  
>  /* Returns false when no more bytes to process, true if there are more */
> @@ -1611,8 +1630,34 @@ static void scsi_mq_put_budget(struct request_queue *q)
>  static bool scsi_mq_get_budget(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
> +	int ret = scsi_dev_queue_ready(q, sdev);
> +
> +	if (ret)
> +		return true;

I think this should just be:

	if (scsi_dev_queue_ready(q, sdev))
		return true;

There's no particular reason to call the function in a local variable
initializer, this just makes the code less clear to me.  And "ret"
isn't needed for any other reason.

> +
> +	atomic_inc(&sdev->restarts);
>  
> -	return scsi_dev_queue_ready(q, sdev);
> +	/*
> +	 * Order writing .restarts and reading .device_busy, and make sure
> +	 * .restarts is visible to scsi_end_request(). Its pair is implied by
> +	 * __blk_mq_end_request() in scsi_end_request() for ordering
> +	 * writing .device_busy in scsi_device_unbusy() and reading .restarts.
> +	 *
> +	 */
> +	smp_mb__after_atomic();

I'm not sure how this helps, if you're trying to ensure consistency
between sdev->device_busy and sdev->restarts.  Another thread could be
in scsi_dev_queue_ready(), right?  And scsi_run_queue_async() in the
scsi_end_request() path is doing an atomic_read() of ->restarts anyway.

> +
> +	/*
> +	 * If all in-flight requests originated from this LUN are completed
> +	 * before setting .restarts, sdev->device_busy will be observed as
> +	 * zero, then blk_mq_delay_run_hw_queues() will dispatch this request
> +	 * soon. Otherwise, completion of one of these request will observe
> +	 * the .restarts flag, and the request queue will be run for handling
> +	 * this request, see scsi_end_request().
> +	 */
> +	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
> +				!scsi_device_blocked(sdev)))
> +		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
> +	return false;
>  }
>  
>  static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index bc5909033d13..1a5c9a3df6d6 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -109,6 +109,7 @@ struct scsi_device {
>  	atomic_t device_busy;		/* commands actually active on LLDD */
>  	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
>  
> +	atomic_t restarts;
>  	spinlock_t list_lock;
>  	struct list_head starved_entry;
>  	unsigned short queue_depth;	/* How deep of a queue we want */

