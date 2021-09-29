Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22781C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 17:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 014FB61440
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 17:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344662AbhI2Rgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244721AbhI2Rgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 13:36:51 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B20C06161C;
        Wed, 29 Sep 2021 10:35:10 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j27so2487068wms.0;
        Wed, 29 Sep 2021 10:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n8HsfV7RFQWoa5/TFlxFufaedtFCNha3XC2H4rDNQEw=;
        b=dTMB3JlFoZDI53nuVwIENnq/dXA5ultZwJbnG/iLS1y3AHpEsc82O4yU1r4gKIQ3tg
         Lur+dstLEbIcEeBTv7Hvj78kVY1OO7KnWrhDqwZCNbpVg265sGX8K6cgEAe6lP+QEjnB
         ftY1I6YclRwDcbRuiL1vD4BZa3QWUgYapW8EsawKzdndVOavplv78DVU6rnTG63tqrVt
         fRPMd7cqJO6fuVp5UpwLGfvJtmuib68fBTHA6r0iWEj4crfz6eEOvuqH31B8xbwamUiu
         l6sDMMr0lDCqp6cRYxacKYaaWyBxt67plFSGZEHW73rzT0EHPrtO+YSVo/syngnV56uj
         yqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n8HsfV7RFQWoa5/TFlxFufaedtFCNha3XC2H4rDNQEw=;
        b=Gy5xwbyGRkURPSbiok6us1at+sblxA+hxR3JcYSWDfqi4lyZFJbcVTGHRWjfxsvRBb
         9FQ0EY0/aaXTgXdsRdTJL8tq2JwmziYMwBD+iHvtmdBSPQVLjE5ruWPISb1JI03tmp3N
         2MuG9rZ4mvrqk1hJIWcznDLvN9fBACq3kgM/4K1jJ9CqcPshNZTw07ScVOhF5ReW4BB/
         43qbe3dxFGHjpuABp1wOo8DK5lqRHCSMjP1dcgrFYbPgBRzPuKAiGs43i1cMyv+iJ9Pf
         +hCUzVxSQVaS4188o0Wmm4uiAim8YrRMbigROMyVDnBwrb7FqV0sjM2yPmvPN5YEEjz8
         Ehnw==
X-Gm-Message-State: AOAM531hw2W2RDXzNRTLvnPPOzy+q8nHebrReVq6wSLSoQmqboixx8v6
        IuPe7SsYt2vRJVqjks1GYNtz0CMEMa4=
X-Google-Smtp-Source: ABdhPJyATJPwbEg/doeTmrol2GqI/583Jn1pVMHc8sQzIjAK5xGXGIUUIjklCtqxz6mUCv6ObbLl9w==
X-Received: by 2002:a1c:a94a:: with SMTP id s71mr11527424wme.32.1632936908571;
        Wed, 29 Sep 2021 10:35:08 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc061e7.dynamic.kabel-deutschland.de. [188.192.97.231])
        by smtp.gmail.com with ESMTPSA id u2sm512802wrr.35.2021.09.29.10.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 10:35:08 -0700 (PDT)
Subject: Re: [PATCH][next] scsi: target: tcmu: Use struct_size() helper in
 kmalloc()
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210927224344.GA190701@embeddedor>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <289a7052-7062-ce88-7cbd-dd29f23b4c60@gmail.com>
Date:   Wed, 29 Sep 2021 19:35:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927224344.GA190701@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28.09.21 00:43, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows
> that, in the worst scenario, could lead to heap overflows.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/target/target_core_user.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 9f552f48084c..dc220fad06fa 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1255,7 +1255,6 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>   {
>   	int i = 0, cmd_cnt = 0;
>   	bool unqueued = false;
> -	uint16_t *cmd_ids = NULL;
>   	struct tcmu_cmd *cmd;
>   	struct se_cmd *se_cmd;
>   	struct tcmu_tmr *tmr;
> @@ -1292,7 +1291,7 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>   	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
>   		 tcmu_tmr_type(tmf), udev->name, i, cmd_cnt);
>   
> -	tmr = kmalloc(sizeof(*tmr) + cmd_cnt * sizeof(*cmd_ids), GFP_NOIO);
> +	tmr = kmalloc(struct_size(tmr, tmr_cmd_ids, cmd_cnt), GFP_NOIO);
>   	if (!tmr)
>   		goto unlock;
>   
> 

Looks good. Thank you.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
