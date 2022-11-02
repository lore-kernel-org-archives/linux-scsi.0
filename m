Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92997C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 20:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiKBUFk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiKBUFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 16:05:38 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BC4EB0
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 13:05:37 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id hh9so12049320qtb.13
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2022 13:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SbIgqqObVXdUI+2kRb0g0D7mPHoI2Zb5+1JVblPI98M=;
        b=J9SWxs9gKCeEeRjMUQ2pArglxl+xWOM5y+UgWQ4aXBy+oT1b0DvFjJA6HSbAs58P0P
         faMXLJQ+6PG40rsKk+qgm1cT96B/O8CJG9zDpGZWegdooaas7UAAU+c7zokYd5wADFgZ
         SCQkws/e3fFB4G+8wYMdf+yQkicFHISIXZwr51cs9Cg8aiJ10wUIVYwCIOAvCWZJ4DXL
         HC9dWKPEu36+7S+/mGym/F7sNxDpGTvmMGT14/AgaKnUW59Mp0muiWDsQxiMSMKeyhAz
         vA6eSYR0uCQLad1ATj/7Udra//Lgnyp3tLsKwo6CYHdwNOVQfx7mHBvX/Y11kBXkjgpb
         vm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SbIgqqObVXdUI+2kRb0g0D7mPHoI2Zb5+1JVblPI98M=;
        b=CC8IyM34dR6LrUKbcUx25zw/IBXVvjQuUrXIO2d1tR8wkIqdXSSeLND09vUWk5VxOe
         DRDSoAJ9+OfLJGfFnUnhYMoIMoo0Bk5gtTM/JX3fQ0wmBdSV/6yW623bDmOdvV8c8IXf
         PemJkvECpH2Vt+FmoVT2UNQxTwJiumal5iKbUl/6c3ekLCN3m0EeiMEVx80RS/CAfC4u
         IpAbslP+kWwczAwFIsIRge3LIW7crURxEfgzClXLrbaPfGry6q1DlJJQYHbc9cMb1LCO
         XdGBRutnl+uWrN8T+JdDFPaGkmqFNE15J8fPQwxNSUoulLosdqgystXWardnY4E3tSux
         dYng==
X-Gm-Message-State: ACrzQf0QCv22Pnq5EvcUBzytIezadLKmxzUWmaNmJkMltr6lOWCrLUy7
        AafzHkDPX7gIftzzjiIJpKzlEw==
X-Google-Smtp-Source: AMsMyM4t71OGBZ8EeEH9/n3fCJ+rJhQVOX1h4DQDN3U3XpmX88UiFX8Mkf2I2k7xBe76iGkg4rBHnQ==
X-Received: by 2002:ac8:4893:0:b0:3a5:18ce:c034 with SMTP id i19-20020ac84893000000b003a518cec034mr18715622qtq.137.1667419536060;
        Wed, 02 Nov 2022 13:05:36 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:28d9:4790:bc16:cc93? ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id q21-20020a05620a0d9500b006eec09eed39sm9157848qkl.40.2022.11.02.13.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 13:05:35 -0700 (PDT)
Message-ID: <d11609d5-963a-de41-86f9-7451f460b6fa@linaro.org>
Date:   Wed, 2 Nov 2022 16:05:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 14/15] scsi: ufs: ufs-qcom: Add support for finding HS
 gear on new UFS versions
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@somainline.org,
        robh+dt@kernel.org, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
 <20221029141633.295650-15-manivannan.sadhasivam@linaro.org>
 <cf8dcf53-f131-68f4-c6aa-d41e02ac6d5c@linaro.org>
 <20221031145647.GC10515@thinkpad>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221031145647.GC10515@thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/10/2022 10:56, Manivannan Sadhasivam wrote:
>>>   		if (hs_gear > UFS_HS_G2)
>>>   			return UFS_HS_G2;
>>> +	} else if (host->hw_ver.major > 0x3) {
>>> +		/*
>>> +		 * Starting from UFS controller v4, Qcom supports dual gear mode (i.e., the
>>> +		 * controller/PHY can be configured to run in two gear speeds). But that
>>> +		 * requires an agreement between the UFS controller and the device. Below
>>> +		 * code tries to find the max gear of both and decides which gear to use.
>>> +		 *
>>> +		 * First get the max gear supported by the UFS device if available.
>>> +		 * If the property is not defined in devicetree, then use the default gear.
>>> +		 */
>>> +		ret = of_property_read_u32(dev->of_node, "max-gear", &max_gear);
>>> +		if (ret)
>>> +			goto err_out;
>>
>> Can we detect the UFS device's max gear somehow? If not, the 'max-gear'
>> property name doesn't sound good. Maybe calling it 'device-gear' would be
>> better.
>>
> 
> UFS device probing depends on PHY init sequence. So technically we cannot know
> the max gear of the device without using an init sequence, but this information
> is static and should be known to a board manufacturer. That's why I decided to
> use this property. Another option is to use a fixed init sequence for probing
> the device and do a re-init after knowing it's max gear but that is not
> recommended.
> 

Why it is not recommended? By whom? You init on some default low gear
(support for some is mandated by UFS spec) and then allow faster gears
while you know the capabilities.

> We need "max" keyword because this property specifies the maximum gear at which
> the device could operate and not necessarily the gear at which it operates.
> Maybe, "max-device-gear" would make it clear.


Best regards,
Krzysztof

