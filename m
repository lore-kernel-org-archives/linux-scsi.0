Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1027C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 May 2022 10:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiEZK1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 May 2022 06:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242223AbiEZK1x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2022 06:27:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D912FC9679
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2022 03:27:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id bo5so1359663pfb.4
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2022 03:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oUe5qjHE746YsZEG88fvj0C8TBLZdImHAFuEEdYBkXw=;
        b=Stw9e/v85gPO2N1vgvwURGj/CxdNR6Azaiv97JK6NQnC940NOP+Clev15pCSWT4xyT
         3JzT+Y/NldWIOhGkH1iJqwkzCdGZULf3Jy1FLhuYQz6ZmBZhplHx+175DIwVM9mU1baw
         LnVRP0b4ZQkGQjpGggN05t64QoKodEh7UMgifBA1ciK8hvfP/aYqxHkeHiUpIF64qYNs
         uDrdr7Wu9tKkzkP8TShGWX+QWTLRZKGKq3tKCENZMoL9b6QfXXvSfDwk+EexkJFASX+V
         laexhG2eygNOfgCYl+xvNJRcnpj7IqUSrx5mam9sPOeapbpMZQAi3yJELV9xFAjLOyG3
         kEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oUe5qjHE746YsZEG88fvj0C8TBLZdImHAFuEEdYBkXw=;
        b=4w8KRF5Kkv0BzhdgvuuGzw5ce2Z5RUvQ2AlxqXPogdImSs+Nfzb7KKtHGgIZUAetrh
         V9hIltNluIYEdeDJIJRqRsz08xWUQTRf4BPvIvCUSjcNkGHBg927aT6hmGAOlLTnMaKO
         YKGsoUsmAGEbnHOWBfVALCgS8yAcd3pAIvFEI4vH6n5drdiXluRdfQEBRy1ZrZu7zX7C
         9FFeR4TwmKxIE6BXMP6Ao71tcO+ENzv9yLmKL0d7C+gT1LVizFzt26c52L/4vlzxJ/ob
         9Fxmx9Z0HveU0GXnPzx2w6/HTyYpNxgy47siC7FowAK8COOvKeD05j1R+NBEEh0lxFOX
         KHmg==
X-Gm-Message-State: AOAM531pEv4NppwM8nema6fXhN53sPj+iiwyYCAsjUoi8Pkniy+uJKYr
        ikOspdk6v3OewbHHh0gt6SwwOw==
X-Google-Smtp-Source: ABdhPJzk/4qznsz2eXu4MQ8+yKPx64W3doEbD81UmTDqITtBAoa74V+NV5H6kgRfZ3+aohJyYyt5sw==
X-Received: by 2002:a63:488:0:b0:3f5:e6da:4619 with SMTP id 130-20020a630488000000b003f5e6da4619mr32218957pge.6.1653560871342;
        Thu, 26 May 2022 03:27:51 -0700 (PDT)
Received: from localhost ([122.162.234.2])
        by smtp.gmail.com with ESMTPSA id k2-20020a170902f28200b0015e8d4eb1dcsm1134696plc.38.2022.05.26.03.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 03:27:50 -0700 (PDT)
Date:   Thu, 26 May 2022 15:57:49 +0530
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
Message-ID: <20220526102749.5tj5ttr5wxwfdrhh@vireshk-i7>
References: <20220425072710.v6gwo4gu3aouezg4@vireshk-i7>
 <dea39b1f-0091-2690-7f07-108d07ef9f3c@linaro.org>
 <20220510044053.ykn6ygnbeokhzrsa@vireshk-i7>
 <1e533194-7047-8342-b426-f607fddbfaa3@linaro.org>
 <20220511050643.hd5tcrojb3wkbg7t@vireshk-i7>
 <20220518235708.1A04CC385A9@smtp.kernel.org>
 <65a4c28d-6702-3a9f-f837-1ea69a428777@linaro.org>
 <20220520005934.8AB1DC385AA@smtp.kernel.org>
 <20220525070551.guv3csxi5kkqfr4f@vireshk-i7>
 <20220525160455.67E2BC385B8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525160455.67E2BC385B8@smtp.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25-05-22, 09:04, Stephen Boyd wrote:
> I'm saying that each OPP table would be for a single clk, but they would
> be connected through required-opps for the device's OPP table.

Ahh, okay.

> It would
> mean that dev_pm_opp_set_clkname() would need extension to let a driver
> indicate which clk is associated with an OPP table.

Hmm, just that it complicates simple cases. Lets see.

> From your other
> reply on v3 it seems that you're leaning towards having an array of
> frequency values in the OPP table instead of doing table linking?

I am not against that to be honest, we have done that for voltages and
current already. I am just not fine with having any one of them as the
primary clock. I liked your idea of reusing "level" for that.

I have started some rewriting of the core, to simplify things and
reduce the number of ever increasing APIs (which you suggested earlier
once). Lets see where we land eventually.

-- 
viresh
