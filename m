Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1F7C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 02:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C48EA207EA
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 02:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTfR0zFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIOCtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:49:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbgIOCti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 22:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600138169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dt6gEg4DJbP9BboMil2HecU1dwz+NeBzkA81EnxZJAM=;
        b=FTfR0zFVAs30WUVPJj9+tlnqmYujrm90lhwvGC2So+wRDNLknGAUzJakSUn/H/gZbYDa7Z
        2bLNhD5p7da6pnTphacxsEHVERrvqMmhzBNg6ahfyQERcN6PCDgEbzepERc2TIVrcuKgzD
        78ZvDp7UApXm0wXq4/Gx47avXkVR2v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-nPpX3s_kPXSY1cBnK7Qbkw-1; Mon, 14 Sep 2020 22:49:27 -0400
X-MC-Unique: nPpX3s_kPXSY1cBnK7Qbkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 712631084D66;
        Tue, 15 Sep 2020 02:49:25 +0000 (UTC)
Received: from T590 (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E22247B7AC;
        Tue, 15 Sep 2020 02:49:16 +0000 (UTC)
Date:   Tue, 15 Sep 2020 10:49:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Long Li <longli@microsoft.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH V7] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Message-ID: <20200915024913.GC738570@T590>
References: <20200910075056.36509-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910075056.36509-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 10, 2020 at 03:50:56PM +0800, Ming Lei wrote:
> Now the request queue is run in scsi_end_request() unconditionally if both
> target queue and host queue is ready. We should have re-run request queue
> only after this device queue becomes busy for restarting this LUN only.
> 
> Recently Long Li reported that cost of run queue may be very heavy in
> case of high queue depth. So improve this situation by only running
> the request queue when this LUN is busy.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Tested-by: Long Li <longli@microsoft.com>
> Reported-by: Long Li <longli@microsoft.com>
> Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V7:
>         - patch style && comment change, as suggested by Bart
>         - add reviewed-by tag
> V6:
>         - patch style && comment change, as suggested by Bart
>         - add reviewed-by & tested-by tag
> V5:
>    	- patch style && comment change, as suggested by Bart
>         - add reviewed-by & tested-by tag
> V4:
>         - fix one race reported by Kashyap, and simplify the implementation
>         a bit; also pass Kashyap's both function and performance test
> V3:
>         - add one smp_mb() in scsi_mq_get_budget() and comment
> V2:
>         - commit log change, no any code change
>         - add reported-by tag
> 
> 
>  drivers/scsi/scsi_lib.c    | 48 ++++++++++++++++++++++++++++++++++----
>  include/scsi/scsi_device.h |  1 +
>  2 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7affaaf8b98e..4fb624744ae6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -549,10 +549,27 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
>  static void scsi_run_queue_async(struct scsi_device *sdev)
>  {
>  	if (scsi_target(sdev)->single_lun ||
> -	    !list_empty(&sdev->host->starved_list))
> +	    !list_empty(&sdev->host->starved_list)) {
>  		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> -		blk_mq_run_hw_queues(sdev->request_queue, true);
> +	} else {
> +		/*
> +		 * smp_mb() present in sbitmap_queue_clear() or implied in
> +		 * .end_io is for ordering writing .device_busy in
> +		 * scsi_device_unbusy() and reading sdev->restarts.
> +		 */
> +		int old = atomic_read(&sdev->restarts);
> +
> +		/*
> +		 * ->restarts has to be kept as non-zero if new budget
> +		 *  contention comes.
> +		 *
> +		 *  No need to run queue when either another re-run
> +		 *  queue wins in updating ->restarts or one new budget
> +		 *  contention comes.
> +		 */
> +		if (old && atomic_cmpxchg(&sdev->restarts, old, 0) == old)
> +			blk_mq_run_hw_queues(sdev->request_queue, true);
> +	}
>  }
>  
>  /* Returns false when no more bytes to process, true if there are more */
> @@ -1612,7 +1629,30 @@ static bool scsi_mq_get_budget(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
>  
> -	return scsi_dev_queue_ready(q, sdev);
> +	if (scsi_dev_queue_ready(q, sdev))
> +		return true;
> +
> +	atomic_inc(&sdev->restarts);
> +
> +	/*
> +	 * Orders atomic_inc(&sdev->restarts) and atomic_read(&sdev->device_busy).
> +	 * .restarts must be incremented before .device_busy is read because the
> +	 * code in scsi_run_queue_async() depends on the order of these operations.
> +	 */
> +	smp_mb__after_atomic();
> +
> +	/*
> +	 * If all in-flight requests originated from this LUN are completed
> +	 * before reading .device_busy, sdev->device_busy will be observed as
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
> -- 
> 2.25.2
> 

Hello Martin,

Ping...


thanks,
Ming

