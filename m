Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F71C4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 12:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiLEMB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 07:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiLEMB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 07:01:58 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00135EE1B
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 04:01:57 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so14568125pje.5
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 04:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1ZssqNs7pInPJStfO2e2atX8UAeVUe46DyiwPRJ0RFE=;
        b=gTBYAJ1Ma45a7BHMHwGS1ZHQV1LzleQ4PEZfCy/Ms1jqJq/R7XCBojvZSjVwDytGBl
         tN14rL/HENx9Q5LlPX4WuMwJJWzclkPHBO9+LZKJTz/HIKA4jprkU1CfYiI1uAJTkXd7
         bAgZYDgbFWJKn4v/rY41b572E1K6UC569OXTBdMo7U+3FZQDQEdsTjILrOy+rVYjyOs/
         YCycs2rfLeKfHd6aBIwTaX0NPMV979GVAoutZb5kZ50M/ShuegX+x0jDvwsyTBcUTBRO
         ODLrgTt2ljReb36H/LfPWCcaIYRTLWo+a1qfjZdYigWKef8l/KWzX9x0AUIGEgfzvD5G
         OIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZssqNs7pInPJStfO2e2atX8UAeVUe46DyiwPRJ0RFE=;
        b=7eeaaW4bd1HYssfD4SWjwm4BMU+qvHzei9yLqbvEVV+OtnnxqTO/QiJne8UMxvGzJ5
         lkyjoqbd7XR+y1eB/fjONXa7W+vJgNh/6q02KivQWcw2SoqLbNiIo9m9vy8kdkY5Tanu
         Z/jQ6UlgV7I3nTov19nmMJypE+RkQvcdTUmQTqZlXPG9raJw53+iwRX5UQ1WTXZKppv5
         A2yFD8CnZAciFqAV9wwRYhn6fckhmB9HzCzMPZHt+4Zt6Wgveh2lYZuOFoqyTupkdwvY
         UrwQ9rMY+VAb2R7d+Wfgh2Z6P+JTwnbJKz/6U+a56kVj9w3KjyrZfiQ0HEvKjFPuinoy
         SYJw==
X-Gm-Message-State: ANoB5pkNiQziTsj54elNz1rtPeein1JGtySAi3jm2YHEcJIZUFdpyvkw
        4fNxPOrvu/cLdWENTZgiszEq
X-Google-Smtp-Source: AA0mqf4DBEnBQ8pyT7ohyPkzU+t1mQ/uJBWCKhtQbdoYDM2WCK+EWk0MTEIdyx8km5XU4ssgP5EsjQ==
X-Received: by 2002:a17:902:d0c9:b0:189:9cfd:be76 with SMTP id n9-20020a170902d0c900b001899cfdbe76mr30410742pln.21.1670241717355;
        Mon, 05 Dec 2022 04:01:57 -0800 (PST)
Received: from thinkpad ([59.92.98.136])
        by smtp.gmail.com with ESMTPSA id p8-20020aa79e88000000b005743b5ebd7csm3318672pfq.92.2022.12.05.04.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:01:55 -0800 (PST)
Date:   Mon, 5 Dec 2022 17:31:48 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sc8280xp: fix UFS DMA coherency
Message-ID: <20221205120148.GB20192@thinkpad>
References: <20221205100837.29212-1-johan+linaro@kernel.org>
 <20221205100837.29212-3-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221205100837.29212-3-johan+linaro@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2022 at 11:08:37AM +0100, Johan Hovold wrote:
> The SC8280XP UFS controllers are cache coherent and must be marked as
> such in the devicetree to avoid potential data corruption.
> 
> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> Cc: stable@vger.kernel.org      # 6.0
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index c4947c563099..23d1f51527aa 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -1430,6 +1430,7 @@ ufs_mem_hc: ufs@1d84000 {
>  			required-opps = <&rpmhpd_opp_nom>;
>  
>  			iommus = <&apps_smmu 0xe0 0x0>;
> +			dma-coherent;
>  
>  			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>  				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> @@ -1491,6 +1492,7 @@ ufs_card_hc: ufs@1da4000 {
>  			power-domains = <&gcc UFS_CARD_GDSC>;
>  
>  			iommus = <&apps_smmu 0x4a0 0x0>;
> +			dma-coherent;
>  
>  			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
>  				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
> -- 
> 2.37.4
> 

-- 
மணிவண்ணன் சதாசிவம்
