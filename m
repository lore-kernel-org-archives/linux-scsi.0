Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77238C83012
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 15:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425462076C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 15:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgK3PEW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 10:04:22 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:36703 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgK3PEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 10:04:22 -0500
Received: by mail-pf1-f178.google.com with SMTP id n137so10581530pfd.3;
        Mon, 30 Nov 2020 07:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=REuaHRfQ6lUG1VyVz+GPAZs3F/7wD140xnooNLXR5Sw=;
        b=IG5vSop5SYM29ZYx4guPqVzy50yBky7ChZPhvkUbinAAR6kCl8EIEXtaEOFDm9Qd2P
         JfdHoj/8rg2LbWfNDFvXYGkr+9Kb+7dbXSEDO4XWIRMhwiS/gcaU1br51BL5ttiY23l9
         M18NvzVAZtd61HJ294YcKr6iVMRcZC8ua9cByVNSHL0CXA6JM1h66l7cFyhEGTfkKBZS
         64EWetBbSW7k/ssKXihnXz923Yx2SlcTzZolCzkG5XSPGyLkW6xVr5vuHoFg7LqZNbDM
         6Kq7ghXKZTQePToLVOO+n15vsQcp4D3eYuLD/xoD91dmrfhC7UWagIQfETnAjD98upob
         eeBg==
X-Gm-Message-State: AOAM5302QrJZ+U1es0+9AF2+qJO+T8Izk/re+jQgahtQ6AzYrXclnRUH
        UB9lpkju3yVY0On6ql/1KSpR+G94Ol0=
X-Google-Smtp-Source: ABdhPJyTLUMgD8w3mPOroVZojndK/fgA4n3GeoDnK4bzdtlLt7OPW0EwtlqRmv8bD3Gix2iNSHxK8g==
X-Received: by 2002:a05:6a00:13a4:b029:18b:cfc9:1ea1 with SMTP id t36-20020a056a0013a4b029018bcfc91ea1mr19006753pfg.25.1606748621579;
        Mon, 30 Nov 2020 07:03:41 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b5sm22962185pjg.28.2020.11.30.07.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 07:03:33 -0800 (PST)
Subject: Re: [RFC] blk-mq/scsi: deadlock found on usb driver
To:     Yufen Yu <yuyufen@huawei.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Cc:     john.garry@huawei.com, "axboe@kernel.dk" <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, osandov@fb.com,
        wubo40@huawei.com, yanaijie <yanaijie@huawei.com>
References: <d6266f2e-9cc7-d222-dedd-15a1a0a6571f@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c52d3938-920a-3618-269f-4eee129a96e8@acm.org>
Date:   Mon, 30 Nov 2020 07:03:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <d6266f2e-9cc7-d222-dedd-15a1a0a6571f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/29/20 11:23 PM, Yufen Yu wrote:
>   We reported IO stuck on a scsi usb driver recently and any IO issued
> to the device cannot return. The usb driver just have **one** driver tag
> and  **two** sched tag. After debugging, we found there is a deadlock
> race as following:
> 
> cpu0(scsi_eh)       cpu1                          cpu2
>                     get sched tag(internal_tag=0)
>                     get driver tag(tag=0)
>                                                   get sched
> tag(internal_tag=1)
>                                                   wait for driver tag
> scsi_error_handler try issue io
> wait for sched tag
>                     try to dispatch the request
>                     wait for setting shost state as SHOST_RUNNING
> //scsi_host_set_state(shost, SHOST_RUNNING)
> 
> The scsi_eh thread stack as following:
> PID: 945745  TASK: ffff950a8f2f0000  CPU: 42  COMMAND: "scsi_eh_15"
>   [ffffbbee8d5b3ce0] __schedule at ffffffffa506ebac
>   [ffffbbee8d5b3d00] sbitmap_get at ffffffffa4c4684f
>   [ffffbbee8d5b3d48] schedule at ffffffffa506f208
>   [ffffbbee8d5b3d50] io_schedule at ffffffffa506f5d2
>   [ffffbbee8d5b3d60] blk_mq_get_tag at ffffffffa4bf5277
>   [ffffbbee8d5b3d88] autoremove_wake_function at ffffffffa48ffe40
>   [ffffbbee8d5b3db8] autoremove_wake_function at ffffffffa48ffe40
>   [ffffbbee8d5b3e08] blk_mq_get_request at ffffffffa4bef14c
>   [ffffbbee8d5b3e20] eh_lock_door_done at ffffffffa4da5580
>   [ffffbbee8d5b3e38] blk_mq_alloc_request at ffffffffa4bef494
>   [ffffbbee8d5b3e80] blk_get_request at ffffffffa4be5042
>   [ffffbbee8d5b3e98] scsi_error_handler at ffffffffa4da8670
>   [ffffbbee8d5b3ea0] __schedule at ffffffffa506ebb4
>   [ffffbbee8d5b3f08] scsi_error_handler at ffffffffa4da8430
>   [ffffbbee8d5b3f10] kthread at ffffffffa48d6d7d
>   [ffffbbee8d5b3f20] kthread at ffffffffa48d6c70
>   [ffffbbee8d5b3f50] ret_from_fork at ffffffffa520023f
> 
> Since there are no more available sched tag and driver tag. All of
> threads will wait forever. We found the bug on 4.18 kernel, but the
> latest kernel code also have the problem.
> 
> I don't have good idea about how to fix the bug. So, any suggestions are
> welcome.

Please take a look at
https://lore.kernel.org/linux-scsi/20201130024615.29171-6-bvanassche@acm.org/T/#u.

Thanks,

Bart.

