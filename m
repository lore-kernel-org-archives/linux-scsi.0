Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB94C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 00:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376757AbiDDAET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 20:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376747AbiDDAES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 20:04:18 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C9F32EDF
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 17:02:22 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id h11so10911328ljb.2
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 17:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=5bWvZkBQTfXdI0SB8SrDEX7zVm6LPWgDXAasm42CGY4=;
        b=mN4zhps0NYYwmzS+FQLFXsSlPjyZn4j7aifukivVkBYHBHCYVat5c393ANERlwS+7A
         +83MnCatCAO/ik4twzmymo3YzTuoGyP12vZH+3V8jxmpEsyxce4Sk0+6b7MXsxn/SWCR
         /W9m3DFc/k/ES0I/nlcU2OKweBRHd1+w6BFYBH+88mNzTpWAo+IU+/YNwIKngyPZmlWf
         rNs/TbIpuF68TLMsbggVlOMYb1TqG/ieQhG3u4ltAXBkgsDOVpnZfy7fkUFyaBzghike
         q452JJwoLzWM+wa6JJh73l72T208+rFuUniEw411oxQPWZkO8ZAgbYAZMA+QXo1OCX79
         Htnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5bWvZkBQTfXdI0SB8SrDEX7zVm6LPWgDXAasm42CGY4=;
        b=pk8mzCQXrfA7+OTJqTRb/i3Py4MzKHHLUpoCwoAuafMP2JVNF/e6FAJX6mB3fQj/a/
         PULzqvI580hKbmb0HwZgzqmra2XwLbeEmb4vKeFR8O9MaYkYVB1lEz1LbuHPg/KP94ym
         T1bd6W4VvghP9cyrDEsnkrhpE+A7cn1JAoR/t5BgOdP2UCM0QJSExxgK3AN63+/yPufG
         h+nzTrXHZc8cMZqP6I22/pIrKNQu7nmthsuotPFeubir6mdgERyZe/RwL14BEfdmFFhm
         MDElOaYon1lr+9/6lbotBPsFBXZNni+7iZJ48FUyWOsoG8Ef1z8Kb/6fjpYPhetY9IFf
         fYAw==
X-Gm-Message-State: AOAM531Vq8tGnThIZ6/+r7QHcPOX4vMMsnbFWv6rTBnkux68Qgi5O21n
        XAcGwAdYsUia1ZVHSnuFVrVbgw==
X-Google-Smtp-Source: ABdhPJwJWW8ulMLQITy0BpOLSJpg+fSPWC4n1v41PvGfawZsK+O5iwbPlB0c7173GPk7Gu/Amuskog==
X-Received: by 2002:a2e:546:0:b0:24a:c194:ba34 with SMTP id 67-20020a2e0546000000b0024ac194ba34mr19549918ljf.146.1649030540783;
        Sun, 03 Apr 2022 17:02:20 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id y12-20020a2e978c000000b0024b11369f20sm543441lji.126.2022.04.03.17.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 17:02:20 -0700 (PDT)
Message-ID: <0da0b229-3493-967d-c14d-60d3246b07b2@linaro.org>
Date:   Mon, 4 Apr 2022 03:02:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 3/4] arm64: dts: qcom: sdm845: control RPMHPD
 performance states with UFS
Content-Language: en-GB
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220401145820.1003826-1-krzysztof.kozlowski@linaro.org>
 <20220401145820.1003826-4-krzysztof.kozlowski@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220401145820.1003826-4-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/04/2022 17:58, Krzysztof Kozlowski wrote:
> UFS, when scaling gears, should choose appropriate performance state of
> RPMHPD power domain controller.  Since UFS belongs to UFS_PHY_GDSC power
> domain, add necessary parent power domain to GCC.

This will cause all gcc GDSCs to be rooted in the CX. Are we sure that 
this is an expected (and correct) change?

> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   arch/arm64/boot/dts/qcom/sdm845.dtsi | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index b31bf62e8680..c999b41c2605 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -1078,6 +1078,7 @@ gcc: clock-controller@100000 {
>   			#clock-cells = <1>;
>   			#reset-cells = <1>;
>   			#power-domain-cells = <1>;
> +			power-domains = <&rpmhpd SDM845_CX>;
>   		};
>   
>   		qfprom@784000 {
> @@ -2336,8 +2337,22 @@ ufs_mem_hc: ufshc@1d84000 {
>   				<0 0>,
>   				<0 0>,
>   				<0 300000000>;
> -
> +			operating-points-v2 = <&ufs_opp_table>;
>   			status = "disabled";
> +
> +			ufs_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +
> +				opp-50000000 {
> +					opp-hz = /bits/ 64 <50000000>;
> +					required-opps = <&rpmhpd_opp_svs>;
> +				};
> +
> +				opp-200000000 {
> +					opp-hz = /bits/ 64 <200000000>;
> +					required-opps = <&rpmhpd_opp_nom>;
> +				};
> +			};
>   		};
>   
>   		ufs_mem_phy: phy@1d87000 {


-- 
With best wishes
Dmitry
