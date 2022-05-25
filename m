Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9B2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 07:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243891AbiEYHM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 03:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbiEYHMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 03:12:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309C862FB
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 00:05:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gk22so455806pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 00:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GQOgQwVQ/waUJffCDtcivwSbqH5M+zW3KVOXOzVg+3I=;
        b=hfxeN4TuHwZ+F26aVi1nDnyqqj9hzVXzKQLyUTyyseJ1iA2d76wNddPr+Rs8dRaw8U
         6g2vsfECGDI/zklJP00Pvjz5teG9nmAJS5uNj3rHFuswYrxKgIoBmlWZoWXCgNjj86Nw
         Vkffw8Z9LaoNwuAhLW48PfDj+fbdlnQyCDUcNUnhZPqLLqxucNyPXCbFCdNp7qMzjthM
         mymx77ceQo5I2XfTuxYjsKmFpGcIReYXyG8UMB03cIeWtS+6g/6It1c3bKwQKOmb7bt/
         dSvKqMiBn0YuUFNtMVFi8MhtNg134bEF2gpV9ILEW7JMJzgsd+aafYU9xoXS2GUdN3qU
         /ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQOgQwVQ/waUJffCDtcivwSbqH5M+zW3KVOXOzVg+3I=;
        b=AicmrKmPwz2lt5u91vA9U0Sz06o3EOY4HLxVQInJfEct0dyYS4pGRSYtKE2MX06wR4
         xaEv5Q7ng7YKYfu7okSrjp1tK+wRyqQyRqs+9CmhR6LXcManhUY5pMXE1qS+9f4bZ8vx
         ZuEFjwyXOLGKtYLfUqzV06ak38xKx5pd7yFQXQXEL/HsaiWHX0SDWXwDTjBHFpHl5Tnl
         e7cG2H3Y2TLUmRqpIkp4ve/KkW5DK3NvlKiXvXc6MjUz+ThhK6LSIOlPmTAbx67C11bh
         pOkcMQtraSmAzX6NCrB90/jQ29tYKxgYP/XgLkFv/SXKPZUnQDvMIWka0Cnh1ligpuTB
         a+0w==
X-Gm-Message-State: AOAM532y3uczMcONhe6PKPmywBsEkUG9QXwdLkHS77PGRSnPo4Vd9QmQ
        qJpgLxy1OmwLy/C51Y2T6xaHfQ==
X-Google-Smtp-Source: ABdhPJxXwWFCbgZ5LyQsmogKN6LaNXPGnyZsOSm+FR1qUQynXNNGcC3+iJkueuoaM9Wz9sT5XQO9IQ==
X-Received: by 2002:a17:902:cf05:b0:156:9d:ca01 with SMTP id i5-20020a170902cf0500b00156009dca01mr30978527plg.111.1653462354436;
        Wed, 25 May 2022 00:05:54 -0700 (PDT)
Received: from localhost ([122.162.234.2])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001624f2b71b4sm2310001plk.152.2022.05.25.00.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 00:05:53 -0700 (PDT)
Date:   Wed, 25 May 2022 12:35:51 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
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
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/6] PM: opp: allow control of multiple clocks
Message-ID: <20220525070551.guv3csxi5kkqfr4f@vireshk-i7>
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
 <20220411154347.491396-5-krzysztof.kozlowski@linaro.org>
 <20220425072710.v6gwo4gu3aouezg4@vireshk-i7>
 <dea39b1f-0091-2690-7f07-108d07ef9f3c@linaro.org>
 <20220510044053.ykn6ygnbeokhzrsa@vireshk-i7>
 <1e533194-7047-8342-b426-f607fddbfaa3@linaro.org>
 <20220511050643.hd5tcrojb3wkbg7t@vireshk-i7>
 <20220518235708.1A04CC385A9@smtp.kernel.org>
 <65a4c28d-6702-3a9f-f837-1ea69a428777@linaro.org>
 <20220520005934.8AB1DC385AA@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520005934.8AB1DC385AA@smtp.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19-05-22, 17:59, Stephen Boyd wrote:
> This is a general problem with OPP. It is single clk frequency centric,
> which works well for CPU/GPU devices that work with cpufreq/devfreq.
> When it comes to other devices though we have to fit OPP into what those
> devices want, which is something like gears for UFS, or "4k@60" (a
> resolution) for display hardware.
> 
> Would adding string labels and/or using an index based API work better
> for these devices? I think we'd want to extend OPP for display devices
> to have whatever set of use-cases the device driver wants to handle with
> string labels. That naturally follows how some SoC manufacturers setup
> their OPP tables anyway. They may want to bump only the bus bandwidth
> for different display resolutions while maxing out the clk frequency.
> Then we could let drivers either construct a string at probe time to get
> a handle to those OPP entries or index directly. The frequency APIs
> would stick around for OPP tables that have frequencies and for drivers
> that want to do cpufreq/devfreq stuff.
> 
> UFS may want to use an index based API that matches the gears per the
> spec. I think it could do that with dev_pm_opp_find_level_exact(),
> right?

I think we can use "level" for all these use cases to find the OPP, if
it aligns well with the requirements of all these frameworks.

FWIW, we already have three ways to find the OPP currently, via
frequency, level and bandwidth.

> Then the primary problem is the subject of this patch,
> controlling multiple clks per OPP table. Could that be done by linking
> one OPP table (for the gears) to an OPP table for each clk? Maybe
> through 'required-opps'?

Even in that case we will have an OPP table which will have multiple
clocks. So it may not matter much which OPP table contains all the
clocks.

-- 
viresh
