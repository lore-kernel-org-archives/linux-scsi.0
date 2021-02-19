Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3A5C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F406023B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhBSTle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBSTld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:41:33 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2330AC061574;
        Fri, 19 Feb 2021 11:40:52 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id lu16so15600967ejb.9;
        Fri, 19 Feb 2021 11:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UHxn+GBJfrOwY63CaBV7H+9/hgtDcl3/nwI6Xa6ler4=;
        b=BihUddmVIWY8ySHKFzp/2J672oWxnkAGUarnxZSdm10VxNE0CC7ppKDpt3GrWwxLzP
         ILZJrqPFUQA5+Z9cUgPrwWEx2wPnsfQrFoDaH1MPCrnKiOaNUCzHA65URwslj5UXEm7V
         l60PMHLv4zeg+DuqwS4mzdBemXez2X4jZB5Dzjz9ub04JmrWS1LSIJ39V77JtIysEuo5
         Lz2m34+csIWBZ4BqGuHe9yxuJ03E+vmemJEBAo3rYUoNX3JbKtt8YlJ8a7mzV2e9TiIA
         Ymhe09KDVri3J1xHqULjMiBcm0pvTZ+832Zih2Ggl7Z2dH3n8JU6mFQ+pMvcmi/f1CID
         anjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UHxn+GBJfrOwY63CaBV7H+9/hgtDcl3/nwI6Xa6ler4=;
        b=Y8u7DdGpZmIbJXShpMPWuTmM/w0lrggbaxJ3zfnDNtwuolmwclKdyy1f985ddhbcPz
         870nbH0uma07mmoDWJGVVJaRKPg1POO8KSBvjMh7GF0D/V5VHVyr5fA81Qrvw8s3Jcwt
         Hrn2s/5MQdw/NTmlLnsy68KrV1E/Tx39NCnskal0WUk30v6M1/rTLNzUDYHKtRVULhBl
         SULUupHjH/K8II9abF7xWq+7uKpdCoAhOzer58eqHrGtTY1ZAe49a46KViRo7sFkhHLv
         Zk24K8F9dTDomZIZQKnnCbkka60AR3UPnXAKiSJFqd+WMAiOaX6zuzrByC33TMi4riMS
         gLBw==
X-Gm-Message-State: AOAM531/9TTvVZ0pBK+IlOqiwYmrlc0G99piu8dsUF7c1pBpWyI0FI1k
        8+OkIIuH5u8HCZdetZW4OiIbuCnzANY=
X-Google-Smtp-Source: ABdhPJyLkAB4P8fKlh7kY7AjSm2RuB6J3pM/gpifKMmhjXi2cGi4XfuJ9g4T4VRTjawpzu8D7Ksg0A==
X-Received: by 2002:a17:906:384e:: with SMTP id w14mr9921211ejc.285.1613763650791;
        Fri, 19 Feb 2021 11:40:50 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id d23sm3376844ejw.109.2021.02.19.11.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 11:40:50 -0800 (PST)
Subject: Re: [PATCH 21/25] target: fix backend plugging
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-22-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <7b026850-a38b-be61-63f0-9d185d76b5eb@gmail.com>
Date:   Fri, 19 Feb 2021 20:40:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-22-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.02.21 21:28, Mike Christie wrote:
> target_core_iblock is plugging and unplugging on every command and this
> is causing perf issues for drivers that prefer batched cmds. With the
> last patches we can now take multiple cmds from a fabric driver queue
> and then pass them down the backend drivers in a batch. This patch adds
> this support by adding 2 callouts to the backend for plugging and
> unplugging the device. The next 2 patches add support for iblock and
> tcmu device plugging.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_transport.c | 43 +++++++++++++++++++++++++-
>   include/target/target_core_backend.h   |  2 ++
>   include/target/target_core_base.h      |  4 +++
>   3 files changed, 48 insertions(+), 1 deletion(-)
> 

Looks good.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
