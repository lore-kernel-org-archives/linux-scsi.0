Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9D1C64ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 12:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjBNMsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 07:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjBNMsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 07:48:01 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252AD1C7E5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 04:47:56 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lf10so7882132ejc.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 04:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jsROFjprG4Xl36pcS1K66/aOat/B9AhxJ+NImNDHdwc=;
        b=PdHbf38Wvl91YA+1E2a/l7nsc552pJ9qYn2fLvbEGIde+eE23STmcpYhOuE04Nlc0Q
         WsWLmSiv2nZ84zyYw+Qq6bI9mm193UJdmzRhTbc73jOo24zL5BK1jZThVTAyeYxVI3q6
         lFm0oU/GsHFRVt/FyrGghBe0qP3CkGsSRlsnwWNDPh1Psnp1PNsOhWbCaE1TllxdkqM/
         3q46+ONn2aX/RdEbrt1NKDcobU6nI1Lewa5hVzwG6rk/ddie88lDgzxjY2CxxW1uv0Ii
         sdxLnY6VaTrN1ziEp7nDHItrMIwFQIkyn6oesjr54ruio9W4ni1H0rrb9njOxV214gOW
         8Www==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsROFjprG4Xl36pcS1K66/aOat/B9AhxJ+NImNDHdwc=;
        b=QX2v69krNN3wa02yu9EGuJVD5dWrvBCo/xyOYjxVt6gJDfhk38gRS6dIp+vtpevMaM
         58lIhkT3s7ks5LHu5AN2BUKN9ZeOOFkwYyFDLH8KjO5W3mj3QLnhnXU8CLsipbzJrxtF
         nYK4jHyQ2oBPssZLzwvBvq9KGXdN5HM7UFK4izx4q2EDh25x8khfGsB0kxqwSdWJC9pW
         4KcAv08XLxrpu3NK2NY+RnPX2R0Kkx9v28Ab5HDGoGDx7T5hveTJ0oClikmbP5qJN3PP
         fhRky83qO1H5fGJ/mkFbQm/MwTUOkQ+VusP4z1rsjPaPkX8ROvQoae04BlWLbS/DO3Gn
         ihtg==
X-Gm-Message-State: AO0yUKU4Mkou9i/KltJcLYDf+w2uu1JqrjsqWP+CjdhhvJ6lFFqRGtjJ
        VUutJXcqbhomN1yIL5V5EALrfg==
X-Google-Smtp-Source: AK7set9jyGp94y8TyLok1fks1vM7ImjaNQoGtaKpAIMbLu0entXzsVRmdjkYuvWZKOJiD7A+habAuA==
X-Received: by 2002:a17:907:75c3:b0:8aa:502c:44d3 with SMTP id jl3-20020a17090775c300b008aa502c44d3mr2498124ejc.41.1676378874618;
        Tue, 14 Feb 2023 04:47:54 -0800 (PST)
Received: from [192.168.1.101] (abxh117.neoplus.adsl.tpnet.pl. [83.9.1.117])
        by smtp.gmail.com with ESMTPSA id le3-20020a170907170300b0087be1055f83sm8173782ejc.206.2023.02.14.04.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 04:47:54 -0800 (PST)
Message-ID: <3b746166-e165-23c4-fc90-a6ba77ac4d7a@linaro.org>
Date:   Tue, 14 Feb 2023 13:47:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 2/5] arm64: dts: qcom: sm8450: Add the Inline Crypto
 Engine node
Content-Language: en-US
To:     Abel Vesa <abel.vesa@linaro.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20230214120253.1098426-1-abel.vesa@linaro.org>
 <20230214120253.1098426-3-abel.vesa@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230214120253.1098426-3-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 14.02.2023 13:02, Abel Vesa wrote:
> Drop all values related to the ICE from the UFS HC node and add a
> dedicated ICE node. Also enable it in HDK board dts.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8450-hdk.dts |  4 ++++
>  arch/arm64/boot/dts/qcom/sm8450.dtsi    | 24 +++++++++++++++---------
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8450-hdk.dts b/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
> index feef3837e4cd..de631deef1e8 100644
> --- a/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
> @@ -461,6 +461,10 @@ lt9611_out: endpoint {
>  	};
>  };
>  
> +&ice {
> +	status = "okay";
> +};
> +
>  &mdss {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> index 1a744a33bcf4..34d569f6c239 100644
> --- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> @@ -3989,9 +3989,8 @@ system-cache-controller@19200000 {
>  		ufs_mem_hc: ufshc@1d84000 {
>  			compatible = "qcom,sm8450-ufshc", "qcom,ufshc",
>  				     "jedec,ufs-2.0";
> -			reg = <0 0x01d84000 0 0x3000>,
> -			      <0 0x01d88000 0 0x8000>;
> -			reg-names = "std", "ice";
> +			reg = <0 0x01d84000 0 0x3000>;
> +			reg-names = "std";
>  			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
>  			phys = <&ufs_mem_phy_lanes>;
>  			phy-names = "ufsphy";
> @@ -4015,8 +4014,7 @@ ufs_mem_hc: ufshc@1d84000 {
>  				"ref_clk",
>  				"tx_lane0_sync_clk",
>  				"rx_lane0_sync_clk",
> -				"rx_lane1_sync_clk",
> -				"ice_core_clk";
> +				"rx_lane1_sync_clk";
>  			clocks =
>  				<&gcc GCC_UFS_PHY_AXI_CLK>,
>  				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> @@ -4025,8 +4023,7 @@ ufs_mem_hc: ufshc@1d84000 {
>  				<&rpmhcc RPMH_CXO_CLK>,
>  				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>  				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
> -				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
> -				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
>  			freq-table-hz =
>  				<75000000 300000000>,
>  				<0 0>,
> @@ -4035,8 +4032,17 @@ ufs_mem_hc: ufshc@1d84000 {
>  				<75000000 300000000>,
>  				<0 0>,
>  				<0 0>,
> -				<0 0>,
> -				<75000000 300000000>;
> +				<0 0>;
> +			qcom,ice = <&ice>;
> +
> +			status = "disabled";
> +		};
> +
> +		ice: inline-crypto-engine {
> +			compatible = "qcom,inline-crypto-engine";
> +			reg = <0 0x01d88000 0 0x8000>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +
>  			status = "disabled";
Any reason for this guy to be disabled?

Konrad
>  		};
>  
