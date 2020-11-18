Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A53C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE352465E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="xShNvBEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgKRBMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:12:52 -0500
Received: from z5.mailgun.us ([104.130.96.5]:21442 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbgKRBMw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 20:12:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605661971; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xTyjQ9toNaO+YIybc97CIcLboXOhzdbqCV8FHhGdOaY=;
 b=xShNvBEfzb4io1h07RVEnHb+H2JaJmZbmshKkymAN+huDdDPyAcziSnI+txPtL359Sg85/9u
 f4pHl09GSCMV7GtnYgZwgY1zaikQuv3duGKeWTC/SBp8+j6hctTx0EJzDHQGChChwA9NdoYH
 it3Pzve/gWD77EE/TvMF5Id+pW8=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fb4750fba0e43f35506012c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 01:12:47
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 928EAC43460; Wed, 18 Nov 2020 01:12:47 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC6EEC433C6;
        Wed, 18 Nov 2020 01:12:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 09:12:45 +0800
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
Subject: Re: [PATCH v2 9/9] block: Do not accept any requests while suspended
In-Reply-To: <20201116030459.13963-10-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
 <20201116030459.13963-10-bvanassche@acm.org>
Message-ID: <066dc92a56adcbf90fa5f7e460459f5e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-16 11:04, Bart Van Assche wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> blk_queue_enter() accepts BLK_MQ_REQ_PREEMPT independent of the runtime
> power management state. Since SCSI domain validation no longer depends 
> on
> this behavior, modify the behavior of blk_queue_enter() as follows:
> - Do not accept any requests while suspended.
> - Only process power management requests while suspending or resuming.
> 
> Submitting BLK_MQ_REQ_PREEMPT requests to a device that is runtime-
> suspended causes runtime-suspended block devices not to resume as they
> should. The request which should cause a runtime resume instead gets
> issued directly, without resuming the device first. Of course the 
> device
> can't handle it properly, the I/O fails, and the device remains 
> suspended.
> 
> The problem is fixed by checking that the queue's runtime-PM status
> isn't RPM_SUSPENDED before allowing a request to be issued, and
> queuing a runtime-resume request if it is.  In particular, the inline
> blk_pm_request_resume() routine is renamed blk_pm_resume_queue() and
> the code is unified by merging the surrounding checks into the
> routine.  If the queue isn't set up for runtime PM, or there currently
> is no restriction on allowed requests, the request is allowed.
> Likewise if the BLK_MQ_REQ_PREEMPT flag is set and the status isn't
> RPM_SUSPENDED.  Otherwise a runtime resume is queued and the request
> is blocked until conditions are more suitable.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> [ bvanassche: modified commit message and removed Cc: stable because 
> without
>   the previous patches from this series this patch would break parallel 
> SCSI
>   domain validation ]
> ---
>  block/blk-core.c |  6 +++---
>  block/blk-pm.h   | 14 +++++++++-----
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a00bce9f46d8..230880cbf8c8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -440,7 +440,8 @@ int blk_queue_enter(struct request_queue *q,
> blk_mq_req_flags_t flags)
>  			 * responsible for ensuring that that counter is
>  			 * globally visible before the queue is unfrozen.
>  			 */
> -			if (pm || !blk_queue_pm_only(q)) {
> +			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
> +			    !blk_queue_pm_only(q)) {
>  				success = true;
>  			} else {
>  				percpu_ref_put(&q->q_usage_counter);
> @@ -465,8 +466,7 @@ int blk_queue_enter(struct request_queue *q,
> blk_mq_req_flags_t flags)
> 
>  		wait_event(q->mq_freeze_wq,
>  			   (!q->mq_freeze_depth &&
> -			    (pm || (blk_pm_request_resume(q),
> -				    !blk_queue_pm_only(q)))) ||
> +			    blk_pm_resume_queue(pm, q)) ||
>  			   blk_queue_dying(q));
>  		if (blk_queue_dying(q))
>  			return -ENODEV;
> diff --git a/block/blk-pm.h b/block/blk-pm.h
> index ea5507d23e75..a2283cc9f716 100644
> --- a/block/blk-pm.h
> +++ b/block/blk-pm.h
> @@ -6,11 +6,14 @@
>  #include <linux/pm_runtime.h>
> 
>  #ifdef CONFIG_PM
> -static inline void blk_pm_request_resume(struct request_queue *q)
> +static inline int blk_pm_resume_queue(const bool pm, struct 
> request_queue *q)
>  {
> -	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
> -		       q->rpm_status == RPM_SUSPENDING))
> -		pm_request_resume(q->dev);
> +	if (!q->dev || !blk_queue_pm_only(q))
> +		return 1;	/* Nothing to do */
> +	if (pm && q->rpm_status != RPM_SUSPENDED)
> +		return 1;	/* Request allowed */
> +	pm_request_resume(q->dev);
> +	return 0;
>  }
> 
>  static inline void blk_pm_mark_last_busy(struct request *rq)
> @@ -44,8 +47,9 @@ static inline void blk_pm_put_request(struct request 
> *rq)
>  		--rq->q->nr_pending;
>  }
>  #else
> -static inline void blk_pm_request_resume(struct request_queue *q)
> +static inline int blk_pm_resume_queue(const bool pm, struct 
> request_queue *q)
>  {
> +	return 1;
>  }
> 
>  static inline void blk_pm_mark_last_busy(struct request *rq)
