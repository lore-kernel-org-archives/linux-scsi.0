Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D767DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 10:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbiEaKbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 06:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343538AbiEaKaq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 06:30:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094819C2C1
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 03:30:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c2so12475180plh.2
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 03:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=711b+vMSd9N7VItmuBp99caF8ivrK9rtXPChlUcTho4=;
        b=vm230eWEdDbv5BiB4b54Jy/+ZGa1KmIMWM+yx/vWv5npwnAT8/kHBc2bKte22HQZOZ
         SL+67MZwF7JfNdzCzGDEZ5Q9FM7k13iKe3s+dlPIALKauZO/acmVUXDdv+nbNUj1atlL
         WCU80Jf5m6PxsCj3I6ALR0v+GPNou3Ju2KyElCiOvykJbA5X05gVpv/Y5jCFWBgBTvCY
         wuAL5JxIry5IptvwNYnjLExrrcIIZfGVBsOYD+6tjvm4za8vyTEFrDj9/cZHm/YUgJVF
         7d7xjo/WKFMmkCfcSkoEjJCYBrb3VH27l83f/kXihKjhrBldsIc9R8mmUTlYO/kp88tT
         fImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=711b+vMSd9N7VItmuBp99caF8ivrK9rtXPChlUcTho4=;
        b=ibUVWVPAJDzupnNmpuO75ucMvrlpuF6y97S3aMstq79gq8zSV4vapcucHVe/UYTdCa
         vMdyZertpvm+5ADKmWMQ0IJB9EZGgvIJsLbIByFo77520R6uqh82TjZFkopwDYp1GjEM
         r+eokxAcJv67Et4jgsJAaFg6ppbd5LeUO2LzcO5LkyD6TZD/GSERKez0AvnN+hE/WCER
         WI9UFXP0e2hDYerw99j4T5IbqLrrQmxYN7ZOaP6JbL79Bno5+5l2RD3gjfDJjXL4Dp9p
         KjsCFqZvlXZWx2S447mfxH4GjEFO2bZ6Un/q6jM/Ine5y+RMbQJDFYiEKBmNgb0UYnh+
         gFjg==
X-Gm-Message-State: AOAM5320R48hMJk4B3sfkwGRRY8xynZJJJRjL8zwoVHgmbCVC54jutuc
        DTPKy3kXXfERypsRv56nzHXMTA==
X-Google-Smtp-Source: ABdhPJytfEQGqw0/fi9ndEo5U6lc52PaAfW/t8oY9N5mCvL8FUAfI0qz9VezW/OEJpzmDIjzLd8p9w==
X-Received: by 2002:a17:90a:d3c7:b0:1e0:d55e:35eb with SMTP id d7-20020a17090ad3c700b001e0d55e35ebmr27946118pjw.105.1653993031320;
        Tue, 31 May 2022 03:30:31 -0700 (PDT)
Received: from localhost ([122.162.234.2])
        by smtp.gmail.com with ESMTPSA id i22-20020a63e916000000b003c14af50623sm9934652pgh.59.2022.05.31.03.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 03:30:30 -0700 (PDT)
Date:   Tue, 31 May 2022 16:00:29 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/6] PM: opp: allow control of multiple clocks
Message-ID: <20220531103029.ntoypaafnd6447ag@vireshk-i7>
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
 <20220411154347.491396-5-krzysztof.kozlowski@linaro.org>
 <20220425072710.v6gwo4gu3aouezg4@vireshk-i7>
 <dea39b1f-0091-2690-7f07-108d07ef9f3c@linaro.org>
 <20220510044053.ykn6ygnbeokhzrsa@vireshk-i7>
 <1e533194-7047-8342-b426-f607fddbfaa3@linaro.org>
 <20220511050643.hd5tcrojb3wkbg7t@vireshk-i7>
 <20220518235708.1A04CC385A9@smtp.kernel.org>
 <65a4c28d-6702-3a9f-f837-1ea69a428777@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65a4c28d-6702-3a9f-f837-1ea69a428777@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19-05-22, 10:03, Krzysztof Kozlowski wrote:
> Yes, true. The clock frequencies are still changed with each gear, but
> in general the UFS indeed operates on gear concept.

Hi Krzysztof,

I have redesigned the OPP core a bit (two patchsets until now) to make
it easier to add multiple clock support going forward. I need some
inputs from you before moving forward with it now. Will this work for
your use case:

- Add support for multiple clocks, where none of them is primary.

- Which means you won't be able to use dev_pm_opp_set_rate() but will
  need something like dev_pm_opp_set_level(), will add it.

- That is, your OPP table will need to implement levels (I think of
  them as UFS gears) and then call dev_pm_opp_set_level() instead.

- This new API will work just like dev_pm_opp_set_rate(), except that
  it will find the target OPP based on level instead of freq and
  support configuration of multiple clock frequencies.

- Of course both these APIs will share most of the code.

-- 
viresh
