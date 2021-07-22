Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3229CC6377D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0848961279
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhGVQ5F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:57:05 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:34472 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhGVQ5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 12:57:05 -0400
Received: by mail-pl1-f181.google.com with SMTP id u8so31276plr.1;
        Thu, 22 Jul 2021 10:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GfbMUusXBHrumJlAvCbY64pDhu/vVnMzWyS6Xy93Kng=;
        b=KTlW4I6KDm5picz+aYVBshiXD3DJxt3J8xcigESyTdl3UVzvclD/+vgWPGIgZUcmtr
         m7aUGc09bT5uB2MCfzvztW2TADNXV2FD8S8XUMOKPcYdk4sgwbDOHXDwjb13dcD4KDJX
         M/w1pobzqfD3cbbalkWmsMvnPsQ7AFl21RGy3qPt7YWseCW2hEUcGNJsGnedWT/034at
         5lh1QVXfnw+kfYjDcTGmKdsJT8yDWi1LM86Y+lsBIcgX42atKnuVcSmfR2Y4A2wVKmiW
         vkPvDq8kZwKarZs25nnkpbPRh2s3d9gcpl4qcGQBjqvbBh8sYgP45APwUUSVh2XVzAzY
         bXrg==
X-Gm-Message-State: AOAM533vQI7re1k84qRXnEeR2Ajf5mEIs4PijpTCLmHYJ8h+rExnK50U
        rZfD197+j4z80Q99TQ6JeuS/frUx5R5lnipqRQA=
X-Google-Smtp-Source: ABdhPJwDAC3nd/78Yv5a9LrsNYGesd50MtdXdWilSvetp394j2TPH3jQIxWgICuhHWmfRweIDb5YTQ==
X-Received: by 2002:a17:902:7610:b029:12b:f9f:727 with SMTP id k16-20020a1709027610b029012b0f9f0727mr585872pll.65.1626975458138;
        Thu, 22 Jul 2021 10:37:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:6539:4b6a:66a5:486f])
        by smtp.gmail.com with ESMTPSA id c83sm5994123pfb.164.2021.07.22.10.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:37:37 -0700 (PDT)
Subject: Re: [PATCH 12/24] block: add a queue_max_sectors_bytes helper
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210712054816.4147559-1-hch@lst.de>
 <20210712054816.4147559-13-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f09654a9-a3aa-d75b-0f2a-666cdb02917e@acm.org>
Date:   Thu, 22 Jul 2021 10:37:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712054816.4147559-13-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/21 10:48 PM, Christoph Hellwig wrote:
> +static inline int queue_max_sectors_bytes(struct request_queue *q)
> +{
> +	return min_t(unsigned int, queue_max_sectors(q), INT_MAX >> 9) << 9;
> +}

Should this function return a signed or an unsigned integer? I'm asking 
because I see 'unsigned int' as the first argument for min_t().

Thanks,

Bart.
