Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C396FC19425
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 18:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B4D230F9
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 18:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgLFS4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 13:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLFS4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 13:56:18 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65ADC0613D0;
        Sun,  6 Dec 2020 10:55:37 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id q16so11336105edv.10;
        Sun, 06 Dec 2020 10:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bSjGFy+0vhLZy2IsDVFq+TblAJIGVbsdDHyc1WrU4a4=;
        b=UQsDEiC/QRbM4LeVvmYS9ML+mp4yyYURSheR3hr3nTGqVmdZRD+YGxwf8KQq9ohfQH
         bInRnGnk9OhGUCZw1d0Gfa4EgEiS8D7XOSQ3LCYDUeShN7GlUzMb55PNHCNAFhl95rMi
         X3SAUhj/feEsB+e0f3BOJZIYEZHX5R5PsbGCrwzpkdzfLuYztSZ0NKUABJ5jApXxEk2F
         +d+EAss1soKWNAwjpJf5NMdTldXTcMlpEy1XRPAB/0PgbXXV/bRbyJswYSQ9Ph5FXwZa
         TwGyGWv9l679kui8YiISEkBj4cbfAc1NVrogKCF9KEBSNyo70rAM+TrtNhpiGdVFobOS
         AOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bSjGFy+0vhLZy2IsDVFq+TblAJIGVbsdDHyc1WrU4a4=;
        b=RHZn9H55fisWunXIBdE8/8l5u42yuuJGXoVuzmXb/d299N7YxcvHCpdJY8z8kUHkal
         +zwaFVbNL+Vk6ePM8x8Nqu1mzqiAp1Gs6cj+1u04ZmRyZxva/5w/xR/au8fYJycmTpvu
         1AIT1dPwnpADqZN+YfRA+H3MuBcAsEQOLUrtSOLZcp08tqvTUF5bgGjLOS73CvgBJtRw
         /8iXpL4OHaeuDdvq6ZJmEM+73zpon68WhRRdJOYZfxtOTsEogg5KA+EhAvc4heniCsUG
         HcyESXITkHFZ7nQC96FkU5gKvETOmH4/vCnp8+lKZWvkhNHcNiea7OZbBGHMHZ5i8L/r
         ZZvw==
X-Gm-Message-State: AOAM5319oOrxOoUYIIXv2OFh+OzVpUBVIo0pSscp5RMN0n49nUMS1Fjw
        LYFu/ZM9lLHEAWIZf7zBeFsQSI0QO24=
X-Google-Smtp-Source: ABdhPJxJYPv++kOwrhEbfjOdG5+eSKNnNnvfuGDRWU7y/+4IC9ob4506ThTaYV/pCom6K+OlAZKBSQ==
X-Received: by 2002:a05:6402:845:: with SMTP id b5mr17246576edz.38.1607280936425;
        Sun, 06 Dec 2020 10:55:36 -0800 (PST)
Received: from [192.168.178.40] (ipbcc05d1b.dynamic.kabel-deutschland.de. [188.192.93.27])
        by smtp.gmail.com with ESMTPSA id o17sm9644483edz.10.2020.12.06.10.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 10:55:35 -0800 (PST)
Subject: Re: [PATCH 1/1] target: Make sure no zero value in the buffer
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201203114040.12656-1-ruc_zhangxiaohui@163.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <ddc0f1ab-03bb-2e66-280d-0dcea9042b5c@gmail.com>
Date:   Sun, 6 Dec 2020 19:55:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203114040.12656-1-ruc_zhangxiaohui@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03.12.20 12:40, Xiaohui Zhang wrote:
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> 
> The fix makes sure no zero value in the buffer, by comparing the
> strlen() of the original buffer with the size variable.

What problem do you want to fix here?
I think, presently iblock_set_configfs_dev_params() just ignores input after a possible zero byte, which AFAICS is the usual way to handle such 'abnormal' input.

Of course, strictly taken it is a bug to return 'count' without having processed count bytes. OTOH, iblock_set_configfs_dev_params also silently ignores unknown parameter strings.
If you want to have strict error handling in such sys- or config-FS callbacks, you have to do a lot of work ...

> 
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>   drivers/target/target_core_iblock.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index f2bd2e207..b23e92449 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -537,6 +537,8 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
>   	int ret = 0, token;
>   	unsigned long tmp_readonly;
>   
> +	if (strlen(page) < count)
> +		return -EOVERFLOW;
>   	opts = kstrdup(page, GFP_KERNEL);
>   	if (!opts)
>   		return -ENOMEM;
> 
