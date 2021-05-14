Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A8CC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4279061442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhENEUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 00:20:41 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:45841 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhENEUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 00:20:41 -0400
Received: by mail-pg1-f178.google.com with SMTP id q15so19067971pgg.12
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 21:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUjKxtOzE1P+04R18LVHbZDGaGCzFIe0+Y76Kg4IJTE=;
        b=S4EON4PQNYIpPCF063mpWIJCtEnZ2pCBEn3rP8ZLnrUKh+57HD9ogCztHodPFGa+qh
         shGRCdNlmbgho8GRyJE5axqbabqYhSY8DFonQ44A+q6bbeWicG4B2yGqOvsB0J19FJcC
         YFOdm9VuvUu4Mx6LYInZxhNwgYuzQ3kr434LM6rvt1aHv0bxN9JQ3OUzesYxV5svqKhJ
         pautW2nBCKzv6w4Q2m8wXKEBCqJxmLEglOOcBBVD4fAv3ERNNwHvF/ip5ilq19o3h1XK
         z0IiT5IOEmCMRdAEcM0f9NYps8YvEjn/rV4pADv7+wIU1cZSkH6KzK87kRoa45dVA0Je
         QbrQ==
X-Gm-Message-State: AOAM530INiR84A0xB0KmUn3MA0hvcvTmXylT9QQR4RFDCGV9Qv0kMeou
        5CHEQ22XYWROK3UF1qtPXbk=
X-Google-Smtp-Source: ABdhPJx+tpLCfoAwWna1lwi8FyS3pc0gsxzHZR7TC87+0RxhYR61v5T9x0u7u+++qg7PFfUdHppbRg==
X-Received: by 2002:a63:f965:: with SMTP id q37mr44816659pgk.132.1620965970190;
        Thu, 13 May 2021 21:19:30 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:53a7:2faa:e07b:6134? ([2601:647:4000:d7:53a7:2faa:e07b:6134])
        by smtp.gmail.com with ESMTPSA id u17sm3074498pfm.113.2021.05.13.21.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 21:19:29 -0700 (PDT)
Subject: Re: [PATCH] ufs: Increase the usable queue depth
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20210513164912.5683-1-bvanassche@acm.org>
 <c8932f54e6e95797c2969a16d07fd926@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <10919d97-9a11-b0f9-c786-31d56b22d74a@acm.org>
Date:   Thu, 13 May 2021 21:19:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <c8932f54e6e95797c2969a16d07fd926@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 9:04 PM, Can Guo wrote:
> Hi Bart,
> 
> On 2021-05-14 00:49, Bart Van Assche wrote:
>> With the current implementation of the UFS driver active_queues is 1
>> instead of 0 if all UFS request queues are idle. That causes
>> hctx_may_queue() to divide the queue depth by 2 when queueing a request
>> and hence reduces the usable queue depth.
> 
> This is interesting. When all UFS queues are idle, in hctx_may_queue(),
> active_queues reads 1 (users == 1, depth == 32), where is it divided by 2?
> 
> static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>                                  struct sbitmap_queue *bt)
> {
>        unsigned int depth, users;
> 
> ....
>                users = atomic_read(&hctx->tags->active_queues);
>        }
> 
>        if (!users)
>                return true;
> 
>        /*
>         * Allow at least some tags
>         */
>        depth = max((bt->sb.depth + users - 1) / users, 4U);
>        return __blk_mq_active_requests(hctx) < depth;
> }

Hi Can,

If no I/O scheduler has been configured then the active_queues counter
is increased from inside blk_get_request() by blk_mq_tag_busy() before
hctx_may_queue() is called. So if active_queues == 1 when the UFS device
is idle, the active_queues counter will be increased to 2 if a request
is submitted to another request queue than hba->cmd_queue. This will
cause the hctx_may_queue() calls from inside __blk_mq_alloc_request()
and __blk_mq_get_driver_tag() to limit the queue depth to 32 / 2 = 16.

If an I/O scheduler has been configured then __blk_mq_get_driver_tag()
will be the first function to call blk_mq_tag_busy() while processing a
request. The hctx_may_queue() call in __blk_mq_get_driver_tag() will
limit the queue depth to 32 / 2 = 16 if an I/O scheduler has been
configured.

Bart.
