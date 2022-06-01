Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D56C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 11:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352797AbiFALYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 07:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352816AbiFALX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 07:23:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D95E77B
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 04:23:11 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id er5so1690898edb.12
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jun 2022 04:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EmX78kZDbpi7zDJcl5NRBNnxEqWkEcLfuWB3zLytvQ4=;
        b=r55wWxDb8gLLLDShPuOiJjmUz1D5Xgin/ldr6b/Tnulo5/FyaoiTrGCFmJK10iRxpl
         /b5twD1DES3+6TJftiXJLlEH5MTxw6tzyqTXWS49/e4fUXACwFeWmyPUdl79bB1ZMm28
         1EQZtIGbcpDoxuCn3othqQWKg+D6efafEyLZYTIBuSeyngpnqUPZSWp0zb/eRJWQMD+4
         W6q5xcRyZJBNbHcwT564fW1iOCfBexrbxseQQNfQI9zG+QVQGtdYMM8Iugx4ALnbLNtu
         EfIQzbvmIUrpisGyxuU8pS95ihIaVEMR2VjCfh69jDHQWuXdYfHfC7+QL1vDtMre9YvW
         WOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EmX78kZDbpi7zDJcl5NRBNnxEqWkEcLfuWB3zLytvQ4=;
        b=Dbnm0YRnMmbqVIXIYdPijU2uLHvJVjH4icSbi0UKUS0AuxIg1uLo2mHBEy0XURN3VX
         E048edjpCyZxlQs/MRRd3OL8GtpEcfrMj8YLyJANOOgIwpOJFHTG8RmedJ27okjDRLkg
         BP5oft03TBDmBgKlGCN2DOqBwDLUx9lYTgDS1K4bbwMfeU+asRl2/99OFg4ZuXyppdVB
         GsIEibSGt81XHjdKd7XsXzO5cmf4xfWrWUbgWQDX7xwS+bb/LOeAz6wRl7bjCy2QZVEi
         kog5utUfwxLjNhCPC6gOsfm8WY566ZD+epAuyxQ9mKquI+7r5q98OBE/wS7lFg/V8+Ch
         +EdA==
X-Gm-Message-State: AOAM531aOLrapqAkVtA6Hf9gzQkht19PRXou8t3K3j64cAd42NSAlBUb
        ZdoGJrVtvqUUnmZd75qmfu5TfA==
X-Google-Smtp-Source: ABdhPJzOJxGalCbiJf1Q2Q8zI2vrTUHr2z0fwXYzl5tTyez6dQrB/mI0xzVPeI2IOWLC/p/Lwqsvsw==
X-Received: by 2002:a05:6402:1907:b0:42d:e90e:337 with SMTP id e7-20020a056402190700b0042de90e0337mr7327648edz.405.1654082589971;
        Wed, 01 Jun 2022 04:23:09 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id p19-20020a056402155300b0042617ba638esm823008edx.24.2022.06.01.04.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 04:23:09 -0700 (PDT)
Message-ID: <7a66f2e2-1a2a-a262-138c-f535499984ae@linaro.org>
Date:   Wed, 1 Jun 2022 13:23:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 4/6] PM: opp: allow control of multiple clocks
Content-Language: en-US
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Stephen Boyd <sboyd@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
 <20220411154347.491396-5-krzysztof.kozlowski@linaro.org>
 <20220425072710.v6gwo4gu3aouezg4@vireshk-i7>
 <dea39b1f-0091-2690-7f07-108d07ef9f3c@linaro.org>
 <20220510044053.ykn6ygnbeokhzrsa@vireshk-i7>
 <1e533194-7047-8342-b426-f607fddbfaa3@linaro.org>
 <20220511050643.hd5tcrojb3wkbg7t@vireshk-i7>
 <20220518235708.1A04CC385A9@smtp.kernel.org>
 <65a4c28d-6702-3a9f-f837-1ea69a428777@linaro.org>
 <20220531103029.ntoypaafnd6447ag@vireshk-i7>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220531103029.ntoypaafnd6447ag@vireshk-i7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/05/2022 12:30, Viresh Kumar wrote:
> On 19-05-22, 10:03, Krzysztof Kozlowski wrote:
>> Yes, true. The clock frequencies are still changed with each gear, but
>> in general the UFS indeed operates on gear concept.
> 
> Hi Krzysztof,
> 
> I have redesigned the OPP core a bit (two patchsets until now) to make
> it easier to add multiple clock support going forward. I need some
> inputs from you before moving forward with it now. Will this work for
> your use case:
> 
> - Add support for multiple clocks, where none of them is primary.
> 
> - Which means you won't be able to use dev_pm_opp_set_rate() but will
>   need something like dev_pm_opp_set_level(), will add it.
> 
> - That is, your OPP table will need to implement levels (I think of
>   them as UFS gears) and then call dev_pm_opp_set_level() instead.
> 
> - This new API will work just like dev_pm_opp_set_rate(), except that
>   it will find the target OPP based on level instead of freq and
>   support configuration of multiple clock frequencies.
> 
> - Of course both these APIs will share most of the code.

Hi Viresh,

In general this looks reasonable and matches how the UFS gears should be
modeled. It does not match how UFS drivers implemented the clock
scaling, but that's the internal problem of UFS drivers. They scale the
clocks only max or min, even though there are multiple gears in between.
The new approach looks therefore appropriate.

Best regards,
Krzysztof
