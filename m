Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B62C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 18:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F6A22249
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 18:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgLBSLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 13:11:15 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34733 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLBSLP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 13:11:15 -0500
Received: by mail-pl1-f194.google.com with SMTP id l11so1585300plt.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 10:10:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FQk6NXRx7Mwr6gK/uXUeynHy9lZUYrVvflCpRueBLI8=;
        b=r5T2HtT3hNEJh4U/fXopUkg1aQjVpVQFy85SA8cNLf9wJiyHxQuqp6hlTYQFIePEAX
         NplKDJIvaYf1Qzuw55QnnCwJ6kHTuKwpQ1gtswwrC1TNGDlI8YBKoB9d0IepA6DfbTOi
         o4FfyEPUeJz3MbzlzrpE6V6qJFBJ6Fl61mnlF/G/4YAvhhLjOk21asGv6jmotDYhkm2o
         3QC+JxJ9+BRBEpB02n5J4XdBPSO1hQbQxXZdHm9prhhevipIyZcCxW14dO9SjoppYPMk
         BGuHzIdJFUH2IgMo1V1GykAOB71irKg/Supx23lNoCId+Q09VSamlEXpawvyk43dIDl8
         tXoQ==
X-Gm-Message-State: AOAM530kZBQtOkGSeYUi/1JI1qr/MXxbuqO2EYgQbe9HwNkc6sUhDz7W
        VenEz9hMeSrTwqpRTxS32BI=
X-Google-Smtp-Source: ABdhPJzEfhugBmJY0DZZgtCjJ1WkH/P+dE3Eih3APa4qgZpf8GTpecuCE9VQkRv7vjqSJYFvaJPjhw==
X-Received: by 2002:a17:902:c401:b029:da:6fa4:d208 with SMTP id k1-20020a170902c401b02900da6fa4d208mr3753778plk.33.1606932633973;
        Wed, 02 Dec 2020 10:10:33 -0800 (PST)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j19sm444808pff.74.2020.12.02.10.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 10:10:33 -0800 (PST)
Subject: Re: [PATCH] scsi: core: fix race between handling STS_RESOURCE and
 completion
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
References: <20201202100419.525144-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5f17e0b1-2bee-7dd2-6049-58088691204b@acm.org>
Date:   Wed, 2 Dec 2020 10:10:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202100419.525144-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/20 2:04 AM, Ming Lei wrote:
> When queuing IO request to LLD, STS_RESOURCE may be returned because:
> 
> - host in recovery or blocked
> - target queue throttling or blocked
> - LLD rejection
> 
> Any one of the above doesn't happen frequently enough.
> 
> BLK_STS_DEV_RESOURCE is returned to block layer for avoiding unnecessary
> re-run queue, and it is just one small optimization. However, all
> in-flight requests originated from this scsi device may be completed
> just after reading 'sdev->device_busy', so BLK_STS_DEV_RESOURCE is
> returned to block layer. And the current failed IO won't get chance
> to be queued any more, since it is invisible at that time for either
> scsi_run_queue_async() or blk-mq's RESTART.
> 
> Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Ewan Milne <emilne@redhat.com>
> Cc: Long Li <longli@microsoft.com>
> Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
> Reported-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/scsi_lib.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 60c7a7d74852..03c6d0620bfd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1703,8 +1703,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		break;
>   	case BLK_STS_RESOURCE:
>   	case BLK_STS_ZONE_RESOURCE:
> -		if (atomic_read(&sdev->device_busy) ||
> -		    scsi_device_blocked(sdev))
> +		if (scsi_device_blocked(sdev))
>   			ret = BLK_STS_DEV_RESOURCE;
>   		break;
>   	default:

Since this patch modifies code introduced in commit 86ff7c2a80cd 
("blk-mq: introduce BLK_STS_DEV_RESOURCE"), does this patch perhaps 
needs a Fixes: tag?

Thanks,

Bart.
