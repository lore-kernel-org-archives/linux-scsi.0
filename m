Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C3EC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25AF5222DE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKRXkK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 18:40:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35979 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfKRXkK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 18:40:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so11161338pfd.3;
        Mon, 18 Nov 2019 15:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QE0DflMJIebiiSRqjO86AgxqOg/iiY+uLfhSwtSzvFw=;
        b=aLP8nawi3d4Ts8kRoxpKt7NeiZTwSe7iqXYrNqlq5WJ2qc003ztB0FOP+GDlFpXbLP
         B6O4+GwtLcchC4d2ov7/xn84GE+PHdFFR2646fbE1e8uMhr9GzHdNgNYVQ070FWuzVR2
         uWvgcjttreiQoYJ7a4lQI9oo/Wiy+JXF8vqLgvXTV9AQnwlyDmR33IH+7YmN9/jIk0+7
         njdZWdye83S8RJ93ff+Pb4w8z4z2b0oLhsOFwuXr4wa5g+F/0PVleyeEFBVsXOxSFErg
         dxBrGuKyjuyAdudPyiW/J7ZvnZFZT9RANMdqz+2UfXUkA9lz3ur4qar2AFrI26Dhl9zK
         3LIw==
X-Gm-Message-State: APjAAAXjIAqFZKHa+aLZgWFJKfvKcZrkpByW8nsuWYcpFRSD3ytlskEw
        9Tosp2A4e7Vfsx+EXau3FwywEnLUlrU=
X-Google-Smtp-Source: APXvYqz/FG8H/xbXybPHKMkegpGzlIZwyK+Za/YDwrS4HXqvKHhX9mRVAajVnU/oR89Ub3e0hmhUiA==
X-Received: by 2002:a62:fb02:: with SMTP id x2mr2218109pfm.254.1574120408662;
        Mon, 18 Nov 2019 15:40:08 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b82sm22222316pfb.33.2019.11.18.15.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 15:40:07 -0800 (PST)
Subject: Re: [PATCH V2] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Long Li <longli@microsoft.com>, linux-block@vger.kernel.org
References: <20191118100640.3673-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9e7b1a1c-f125-b359-4b59-675368e100f2@acm.org>
Date:   Mon, 18 Nov 2019 15:40:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118100640.3673-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 2:06 AM, Ming Lei wrote:
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
> Cc: linux-block@vger.kernel.org
> Reported-by: Long Li <longli@microsoft.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- commit log change, no any code change
> 	- add reported-by tag
> 
> 
>   drivers/scsi/scsi_lib.c    | 29 +++++++++++++++++++++++++++--
>   include/scsi/scsi_device.h |  1 +
>   2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 379533ce8661..62a86a82c38d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -612,7 +612,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   	if (scsi_target(sdev)->single_lun ||
>   	    !list_empty(&sdev->host->starved_list))
>   		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> +	else if (READ_ONCE(sdev->restart))
>   		blk_mq_run_hw_queues(q, true);
>   
>   	percpu_ref_put(&q->q_usage_counter);
> @@ -1632,8 +1632,33 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
>   	struct request_queue *q = hctx->queue;
>   	struct scsi_device *sdev = q->queuedata;
>   
> -	if (scsi_dev_queue_ready(q, sdev))
> +	if (scsi_dev_queue_ready(q, sdev)) {
> +		WRITE_ONCE(sdev->restart, 0);
>   		return true;
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

Hi Ming,

Are any memory barriers needed?

Should WRITE_ONCE(sdev->restart, 1) perhaps be moved above the 
scsi_dev_queue_ready()? Consider e.g. the following scenario:

sdev->restart == 0

scsi_mq_get_budget() calls scsi_dev_queue_ready() and that last function 
returns false.

scsi_end_request() calls __blk_mq_end_request()
scsi_end_request() skips the blk_mq_run_hw_queues() call

scsi_mq_get_budget() changes sdev->restart into 1.

Can this race happen with the above patch applied? Will this scenario 
result in a queue stall?

Thanks,

Bart.
