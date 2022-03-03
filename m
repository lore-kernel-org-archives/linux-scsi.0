Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DE7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 20:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiCCUwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 15:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiCCUwG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 15:52:06 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A47483BC;
        Thu,  3 Mar 2022 12:51:20 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so8870094pjb.3;
        Thu, 03 Mar 2022 12:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BpgkWjnWuEgp3Cu6bAQ0FzKlFx/Hz9hUby+++zqWYJ0=;
        b=tgGa+lHE+IZN6YppmNnx8QAfM6Fj3M1yq2WOhTq/3ZligKRpoZE5dPvlqDY4dPba0X
         bQ5Hug4K0oWELfmZg1oCSlx299DAHRpGwgjVcArX08ZaAiTpucKJLiBLhqlWtqAcsjIA
         p60JdAWSeAkRVDaWXu5TLbRbfrjQGqs+jNI3JXwuesSI7xg4C9jMEU4eyEyPJtUVuqZo
         26DTiStDGDscNtkKsWeMuv9llOkSkvfptuF1ygvW+zP0As/e+fArbA0HqgGdSkJG40/l
         WhjfIGN/IfTeIz16AHU4cwt599MAVqQLTq4vzSYb8ctqasuc5HauGqUpkmoZiG2z22IL
         ZF4A==
X-Gm-Message-State: AOAM531STuH+e69ZBUBOGytUrL5B9r8cW0wbtUPDUnluVxhI3edKf0c4
        98ZycpYwHCFdIPXQKCljdTk=
X-Google-Smtp-Source: ABdhPJw6To/8cw2ZGMm8I7mQ4sIahkk1H/eRR1uUPPoUOYX8L9Cxt3rRitLy4XVFfea5Qdjf8/k/Dg==
X-Received: by 2002:a17:902:f701:b0:14d:7cea:82af with SMTP id h1-20020a170902f70100b0014d7cea82afmr37656097plo.71.1646340679915;
        Thu, 03 Mar 2022 12:51:19 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y12-20020a056a00190c00b004f39e28fb87sm3507488pfi.98.2022.03.03.12.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 12:51:19 -0800 (PST)
Message-ID: <7b1daba2-3ff8-d4ee-9499-89d46d756bb9@acm.org>
Date:   Thu, 3 Mar 2022 12:51:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: move more work to disk_release v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220227172144.508118-1-hch@lst.de>
 <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org> <20220301125632.GA3911@lst.de>
 <c61b6a0d-c3b5-30e2-14c5-efa7ea475c23@acm.org>
 <20220302150319.GA30076@lst.de>
 <9e818df5-e8c0-b397-ae21-1a0745074094@acm.org>
 <20220303105455.GA14991@lst.de>
 <7b4ba630-b51c-9675-88b4-d79649756abd@acm.org>
 <20220303192338.GA23351@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220303192338.GA23351@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/22 11:23, Christoph Hellwig wrote:
> Can you try this patch on top of the series?
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 6a072543bde4d..73b8bc9d67cf6 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -883,7 +883,10 @@ static inline void blk_account_io_done(struct request *req, u64 now)
>   
>   static void __blk_account_io_start(struct request *rq)
>   {
> -	rq->part = rq->bio->bi_bdev;
> +	if (rq->bio)
> +		rq->part = rq->bio->bi_bdev;
> +	else /* should only happen for dm-mpath flush requests */
> +		rq->part = rq->q->disk->part0;
>   
>   	part_stat_lock();
>   	update_io_ticks(rq->part, jiffies, false);

Hi Christoph,

This patch fixes the crash I reported. With this patch applied on top of the 
hch-block/freeze-for-next branch blktests produces the same results on my setup 
as for Jens' for-next branch.

Thanks!

Bart.
