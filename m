Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7378CC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 07:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiFWHQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 03:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiFWHQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 03:16:05 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83645ACF
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 00:16:03 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id c65so4157702edf.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 00:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Cll48XQjSTk7Px9A3T9Ss8n7MDZa7XaBt+noA+sIkX0=;
        b=lfUMk/6WWkQfd1u6eIEAt5S6MO04bvoWQpmpBKEIaEYfIL1pY4UIBGPNPqOvjJ1v2a
         hqH4reyTh97v+KohVSS4u+dsf3AuqB87nyxyRevUaGammMtU6g+Xk4OJaDI46ItneMfX
         ikHeHDp/TzScw3BOUiq5KLaJKyrBBJNWaxa52jwTclMLPVZhaLBy7fpXHj6Q1kehPIXY
         +5wN/GMku84YN4yrYABNIGEgcvjmGKdFvXCeHVWKHwEt4qfZkoiqwbMUa6Aw/rhHIuZB
         EZQ5X+zmNWObZEKBCO7NrXe6EyDlYS0jVqyZEOX6nlkk854dtYc9YRbxK1jrZkEsuml3
         Ks9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Cll48XQjSTk7Px9A3T9Ss8n7MDZa7XaBt+noA+sIkX0=;
        b=rMZ+vhhM+++6F1ZXxYhWndGYNgH4ym2IWmPrhepgOKgPN6coVVUr3RzbyiSPev34kw
         6zf5dR/Wh2L1jCY3P/zakxN52TBvc8HjR7th4D6H/EjTq1LBNL0aj+JqpAcyvxY0bpfX
         p6mzucEEUPrHY0ic0GmsmLFENxl54p651R1TjNAFxbxLDcqg7fTl2yTXJz45Q5mnDkUp
         nOI0ThtKn6Q+y+5RGexU3A/wzD3DW5QuUWndO6rhbWKBeRm42q+ZPWIhfGhuebUa2fqW
         tuQ42J73CislFlnXbDBWPIZJz7rxVb5ZuUaIucbq/UHlX5YzHGo+tz3tfO/QqdK8XucC
         Ze4Q==
X-Gm-Message-State: AJIora8JPWZMAMDcRJSibplYW1tGOo8YfWl2Yevw/Gt6LTYJs1VMEpS4
        c4ZnXfFNXowZKLoOrvDsw/HKJNOKF89OnQ==
X-Google-Smtp-Source: AGRyM1tK/+zU1nkRE73+oAyAzR1niE0FCivKu9SrXPJ6oaNUJvOowbMlui+VsaW/AcUv17K0T2LlBg==
X-Received: by 2002:a05:6402:430a:b0:435:8ec9:31ec with SMTP id m10-20020a056402430a00b004358ec931ecmr8812330edc.248.1655968562421;
        Thu, 23 Jun 2022 00:16:02 -0700 (PDT)
Received: from [192.168.0.226] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id g5-20020a50d5c5000000b004356c0d7436sm13430643edj.42.2022.06.23.00.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 00:16:02 -0700 (PDT)
Message-ID: <c155d5ab-f765-e547-3d1d-62df54c615ac@linaro.org>
Date:   Thu, 23 Jun 2022 09:16:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 3/3] scsi: ufs: ufshcd: constify pointed data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
 <20220613100655.105301-4-krzysztof.kozlowski@linaro.org>
 <08544601-3364-0352-415f-2e3576b84976@acm.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <08544601-3364-0352-415f-2e3576b84976@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/06/2022 18:13, Bart Van Assche wrote:
> On 6/13/22 03:06, Krzysztof Kozlowski wrote:
>> Constify arrays and pointers to data which is not modified for code
>                                               ^^
>> safety.
> 
> is -> are?
> 
>> @@ -7848,7 +7850,7 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
>>   	u32 granularity, peer_granularity;
>>   	u32 pa_tactivate, peer_pa_tactivate;
>>   	u32 pa_tactivate_us, peer_pa_tactivate_us;
>> -	u8 gran_to_us_table[] = {1, 4, 8, 16, 32, 100};
>> +	const u8 gran_to_us_table[] = {1, 4, 8, 16, 32, 100};
> 
> Can this array be declared static? Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Could be, it's a kind of optimization, so a bit different problem. I'll
send v4 with language fix, static and your review.

Best regards,
Krzysztof
