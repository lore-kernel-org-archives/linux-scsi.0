Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED500C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9F264EED
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhBZImc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhBZImW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:42:22 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA218C061756;
        Fri, 26 Feb 2021 00:41:41 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w21so9961296edc.7;
        Fri, 26 Feb 2021 00:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+lM/SFeDdrVac2jsq0UgCe1DVfeaA2cpst9paOfK+/Q=;
        b=tjXZxwascR/8rqFRNA7nG8uFy3TlQkPYDzLKbUv0azTwcxL2IOXM/fSUS6OIDgQ292
         NzC1TAla4TmOC9BtgrAMwo7CscRMAAMoFA5DunHz1P0KDnSyebfiTok0s4mXYQzGr4Er
         P++4HDRbUJFV5n8PykFZdh/jpvkV1WvXBiKho23zexIn4D6sx333IlKgQq6rmlBWGevp
         o6L8VVgfqurUAL2cnLWx5d56BfnKgNbVsaMDjP8BoUKVAJlZ2z+mNyG7EnD5XZaRUOXO
         3IccTIAysQW9RJ9GrjugpP4wTmLsclcME9kzpMkGucQdTRVlNHWvJhhyUexsRDSypLKl
         3tvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+lM/SFeDdrVac2jsq0UgCe1DVfeaA2cpst9paOfK+/Q=;
        b=JzT37SSc1p2xd4PEskRWgrPdjsFDChYhyZdJa0enGXErPNhEGYJB6j3rxggD19oTXW
         mMmzEAPjYv1SDxeMKcGRxWzTx5cP7Rp5a+A8y9qOGHHusq4m7O0/FO8PNtb9pBi/fPgY
         dqmiOvNTsVs82M1YT+JwN0TYIHyGiGqqLUdxAgRMcagDv7ZtKb5g/YybyZ1cgh24WwWO
         NM0s5Ugtfl4UskQG5Yib73toMzwPEuPiGe75RfPweNO6cY3uss+fiKiJzKAdj2kpqsTo
         j0+f0TdEWFHVa5zjjKEthBAyizaLBkYH2Mo+HRm99Ih1s3dA8UN9BXINxo1tIzU7T5/L
         FiBA==
X-Gm-Message-State: AOAM531qdEptVsqh+Qd24aArpL99EtlnxXePwUIHBbwJbMIenvfG7ijP
        OXXtBBKBJ2kQJbV/51Omp9Y=
X-Google-Smtp-Source: ABdhPJwPtzPA4V3kCt7anccPeV5gV4Co62QrCTtA8cvu+T5AZccoav34PDswv4Z7hRaIpFFsaT6Z6g==
X-Received: by 2002:a05:6402:3553:: with SMTP id f19mr2092790edd.271.1614328900703;
        Fri, 26 Feb 2021 00:41:40 -0800 (PST)
Received: from [192.168.178.40] (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id s18sm5535567edc.21.2021.02.26.00.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 00:41:40 -0800 (PST)
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with
 XArray
To:     michael.christie@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210224185335.13844-1-bostroesser@gmail.com>
 <b36fee7f-6fdc-b5de-3a7b-4396e5f9aab1@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <4a1fece0-fc3e-9588-6494-aaf2270d6ccd@gmail.com>
Date:   Fri, 26 Feb 2021 09:41:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b36fee7f-6fdc-b5de-3a7b-4396e5f9aab1@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26.02.21 04:59, michael.christie@oracle.com wrote:
> On 2/24/21 12:53 PM, Bodo Stroesser wrote:
>> This small series is based on Martin's for-next.
>>
>> Future patches will need something like the - meanwhile removed -
>> radix_tree_for_each_contig macro.
>> Since general direction is to use xarray as replacement for
>> radix_tree and IDR, instead of re-introducing or open coding the
>> removed macro, with this series we switch over to xarray API.
>> Based on xarray a future patch easily can implement an analog
>> to radix_tree_for_each_contig.
>>
>> Bodo Stroesser (2):
>>    scsi: target: tcmu: Replace IDR by XArray
>>    scsi: target: tcmu: Replace radix_tree with XArray
>>
>>   drivers/target/target_core_user.c | 64 +++++++++++++++++++--------------------
>>   1 file changed, 31 insertions(+), 33 deletions(-)
>>
> 
> Looks ok to me.
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 
> I think in a separate patch we need to change:
> 
> +		if (xa_store(&udev->data_blocks, dbi, page, GFP_KERNEL))
>   			goto err_insert;
> 
> to GFP_NOIO. There were some users doing tcm loop  + tcmu and
> were hitting issues when GFP_KERNEL lead to write backs back on
> to the same tcmu device. We tried to change all the gfp flags but
> we missed that one, because it was hidden in the radix tree's
> xa_flags.
> 

But then, for consistency reasons, shouldn't we change

+	if (xa_alloc(&udev->commands, &cmd_id, tcmu_cmd, XA_LIMIT(1, 0xffff),
+		     GFP_NOWAIT) < 0) {

to GFP_NOIO also?

Additionally I have to change memory allocation in tcmu_tmr_notify from
GFP_KERNEL to GFP_NOIO, since it happens while holding cmdr_lock mutex,
which could also cause the problems you desribed.

Shouldn't we better change to new API memalloc_noio_save and
memalloc_noio_restore in that new patch?


