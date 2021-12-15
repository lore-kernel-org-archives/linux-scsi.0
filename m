Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6437C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 17:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhLORkm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 12:40:42 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:44712 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhLORkm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 12:40:42 -0500
Received: by mail-pf1-f175.google.com with SMTP id k64so21305847pfd.11;
        Wed, 15 Dec 2021 09:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDrjWN5ruNrGoDAY9CVUHMI8SlAW1hpfxfnP6D8B77I=;
        b=YhMSuxCdzIfxp9sMsscKAQBZu+cjRprnf3vv97jf1zGj6HV8UK14yMx/aCayh72UoO
         OUq41r8lBaVGKoLBky3r33Q5bqZBbfEpxXUTUbZLNPc0JnRzC8g4kGYUIC/LR2LH4jR1
         GlQt/50wJAmEZNTU+z47CdQUgimTjt4BU4ZioJNmTUVaaiV4fSviqK+w32Lxl1jfOZZX
         o27mV7ane5s8sdOoZBwgl9i5v7DNbgmNm3jBKi1TOW+bOYDJt8pu28eOBTI6bvydQaC5
         HNvPDWl+Ip8rbgwtOaKB34cnG5YPe0XzMjIbC+Q5o7xTXYJptvmpnO/HHLr1jZBbNecf
         IW6Q==
X-Gm-Message-State: AOAM533cbKgX91oHjha2ksCvL4OyUjkjr4o3NIUaxJaqaYMaynzdLLXA
        7g6NjntW4smwslLC5dKZMa8=
X-Google-Smtp-Source: ABdhPJxB+CTdYtPteOYff7q1DnYRfnGx9BFlf641vdqagp9DpvIhc24DXEUyGCKXb4m26qvDxHSOXQ==
X-Received: by 2002:a62:7c8b:0:b0:49f:a8ae:de33 with SMTP id x133-20020a627c8b000000b0049fa8aede33mr9989868pfc.29.1639590041462;
        Wed, 15 Dec 2021 09:40:41 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:6f47:6f2c:fba9:e717? ([2620:0:1000:2514:6f47:6f2c:fba9:e717])
        by smtp.gmail.com with ESMTPSA id q18sm3085937pfn.83.2021.12.15.09.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:40:40 -0800 (PST)
Subject: Re: [PATCH] block: reduce kblockd_mod_delayed_work_on() CPU
 consumption
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <bc529a3e-31d5-c266-8633-91095b346b19@kernel.dk>
 <YbiyhcbZmnNbed3O@infradead.org>
 <53b6fac0-10cb-80ab-16e7-ee851b720d5e@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <883ad44e-8421-1cb5-f3f4-4a8d193e2d5a@acm.org>
Date:   Wed, 15 Dec 2021 09:40:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <53b6fac0-10cb-80ab-16e7-ee851b720d5e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/21 7:59 AM, Jens Axboe wrote:
> On 12/14/21 8:04 AM, Christoph Hellwig wrote:
>> So why not do a non-delayed queue_work for that case?  Might be good
>> to get the scsi and workqueue maintaines involved to understand the
>> issue a bit better first.
> 
> We can probably get by with doing just that, and just ignore if a delayed
> work timer is already running.
> 
> Dexuan, can you try this one?
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1378d084c770..c1833f95cb97 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1484,6 +1484,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
>   int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
>   				unsigned long delay)
>   {
> +	if (!delay)
> +		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
>   	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
>   }
>   EXPORT_SYMBOL(kblockd_mod_delayed_work_on);

As Christoph already mentioned, it would be great to receive feedback from the
workqueue maintainer about this patch since I'm not aware of other kernel code
that queues delayed_work in a similar way.
Regarding the feedback from the view of the SCSI subsystem: I'd like to see the
block layer core track whether or not a queue needs to be run such that the
scsi_run_queue_async() call can be removed from scsi_end_request(). No such call
was present in the original conversion of the SCSI core from the legacy block
layer to blk-mq. See also commit d285203cf647 ("scsi: add support for a blk-mq
based I/O path.").

Bart.
