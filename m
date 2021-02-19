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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A74EC433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9FCD64EB3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBSTCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhBSTCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:02:00 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19E0C061574;
        Fri, 19 Feb 2021 11:01:19 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id t11so15439692ejx.6;
        Fri, 19 Feb 2021 11:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=k+zc6wIpg2MHiGYYkgbWwjMqC5EFo3O9/MN09M1dTLM=;
        b=Y38yWHpU4digjrgNBrQBRJ61mIY0kSikxgM2ItbkGECrMS+h/XA/kBDDKvcRboYq3o
         JyvXFYUcx/Kjn5bgDJW6USgb1jFiSRPrwl66LEstfzrYoqjXpywBEBO+p6skVOO25LG1
         54K7qS4H0rp5PTVbuj1a5vnclSzcZL3wPi5nMi3nUMuFJfUY93pBfHmlG2F9TsT9lUdH
         C63C+oetdpgqbfN29qvpHuncV/KS+8DR1J7VYwzFIMZUMkPcG1yUemV93NdRSt0AerDP
         6X3cHA/KZWh17EayBdOk5pPPRe5OEphfUB0CHa5fId2eSTLy5eP/4DR2wgxs1L7OiorX
         +/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+zc6wIpg2MHiGYYkgbWwjMqC5EFo3O9/MN09M1dTLM=;
        b=n3OuffynfOVA5UHmcTGQB72TJWAgWyEFM4kWVSXr+XNQDstYVrSDY3MmU/vLqCtXtu
         7tyxFZj9W2nM1yB8K50O/QgT9NyyP/yF4DcMansoteSCJ/bVirc2zGux0DeKU9GBa9sS
         jjPIMVWy2Icd/nUkiI/xhZaKYYMKX7yhb8eYKaW/J8/7oIYLmrJT54qvDO0NkUaCpxHG
         I6RnCYh03t8WsnqPP/GjHBt+SZ4UnLxNNwXOmdrKZO0m2AO3Lc97pdmx5VNU4Yu5uR5z
         1yOnvIEL5D0m25UZ2BY8KboP/h9uHhLG2lUgn7ymnROMjftUZmSMV6oLh1nUHAQevuCN
         9lpA==
X-Gm-Message-State: AOAM5330dCAQJNY142Xd5eL0Fya8iZGL8HPHExA7Jqlfq0empNipqBjZ
        l5MAAVZHcWwZuDfMMgbcj1Yz4xEdB3M=
X-Google-Smtp-Source: ABdhPJy/r5UStOE8wn09sLTutkxohssEOIJP6THzTTq9h6in+FHzpgavgu4Hq2ewHH/lOjPVTVK57g==
X-Received: by 2002:a17:906:380b:: with SMTP id v11mr10206299ejc.183.1613761278631;
        Fri, 19 Feb 2021 11:01:18 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id h10sm5830614edk.45.2021.02.19.11.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 11:01:18 -0800 (PST)
Subject: Re: [PATCH 14/25] target: remove target_submit_cmd_map_sgls
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-15-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <f930f1f4-4e97-98fb-c013-d117764c265a@gmail.com>
Date:   Fri, 19 Feb 2021 20:01:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-15-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.02.21 21:28, Mike Christie wrote:
> Convert target_submit_cmd to do its own calls and then remove
> target_submit_cmd_map_sgls since no one uses it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>   drivers/target/target_core_transport.c | 76 ++++++--------------------
>   include/target/target_core_fabric.h    |  6 +-
>   2 files changed, 18 insertions(+), 64 deletions(-)
> 

Looks good.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
