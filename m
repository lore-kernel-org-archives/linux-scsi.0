Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4D5C6FD1D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbjDDSji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbjDDSjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:39:15 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711B14EE2
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2023 11:38:32 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id g17so43554764lfv.4
        for <linux-scsi@vger.kernel.org>; Tue, 04 Apr 2023 11:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680633511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2zoliSShtGMXIRHrPAfEi4BT+9ugNs+lckUNg852jU=;
        b=vDemHso1O2NSLhxzarWRb+ghDX3K6v58ohwizFiONiCGKWXoGhvNEArGC3duNw0q68
         HM+tLKcgThcNKUAh92+QQm1/zJDdPFr1L/MhZ6ljcSJau8uyRKHsvG83LJHUZA7wfMWF
         X2UHhbjkO0MT/KQY6JlAXZYDlKbFt0TYnrsYYRZGDgDjv6+wolyDQA3n5B4966zIjyE9
         Ynp1zYJvrE9XjY09qrfd+8GChvLuNPat/gCnxoLKCtQaJJSzRw58TvSVA1iNghaHiuAP
         VnoRk7+L8Na2yM4IVOi1KgVG7PduBOZS0k18qVb2n2P0BU39PnnYj/VJymzTcOXj/uQE
         R+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P2zoliSShtGMXIRHrPAfEi4BT+9ugNs+lckUNg852jU=;
        b=d7NPGddi1LQ69pxePcIh/lspagx8tZVSRqol9SYURXi66Uq4tHBFVsdvProUylD6iL
         wlj7p5gasCG5UwQxZJz9dLOu+n2vUDW22hrmLitLcibvbiDSnQzwXkIuqoIllF7IEnfV
         CeAVGsBUnQH657zaJCbsjZlnzK7pKg5UaqkJgh1qyLrk+1sqDHhvaoVB+3W0jPvolO0p
         DoHX7e5TR1EYz7igjmuVuOKiN7WuHIRyBg3jzibc2mz9qlJevs477Vx6/ZG188XdFLhr
         ut6Xm//29CVPl17tQSyjalQzg9lVe2H/Jz658qNai9HK+Dn6qsVgOLt5ePP2WDhmX4d7
         1fPw==
X-Gm-Message-State: AAQBX9eAzQfAuC7khQgqtaQmujnmLcgQDvpZm7oGlgw3IaYHOBehFyOQ
        VAaysr7LfXPYFHUMD8yA7Vh0LqdHIB20JLkEc1A=
X-Google-Smtp-Source: AKy350YjZCZii7ybiLwTbgy/zyyVocMqbzVcRl/iekuFVpcB8tWo5nhJ96zCqtU2PWckOMfnt29m1g==
X-Received: by 2002:ac2:596b:0:b0:4e9:609c:e901 with SMTP id h11-20020ac2596b000000b004e9609ce901mr853735lfp.21.1680633510678;
        Tue, 04 Apr 2023 11:38:30 -0700 (PDT)
Received: from [192.168.1.101] (abxh37.neoplus.adsl.tpnet.pl. [83.9.1.37])
        by smtp.gmail.com with ESMTPSA id t26-20020ac24c1a000000b004b5480edf67sm2466044lfq.36.2023.04.04.11.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 11:38:30 -0700 (PDT)
Message-ID: <11b87394-610b-f6e3-8e55-4b5cc6121396@linaro.org>
Date:   Tue, 4 Apr 2023 20:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5/5] arm64: dts: qcom: sa8775p-ride: enable UFS
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230331195920.582620-1-brgl@bgdev.pl>
 <20230331195920.582620-6-brgl@bgdev.pl>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230331195920.582620-6-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 31.03.2023 21:59, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Enable the UFS and its PHY on sa8775p-ride.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> index fdd229d232d1..e921093a9f08 100644
> --- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> @@ -5,6 +5,7 @@
>  
>  /dts-v1/;
>  
> +#include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
>  
>  #include "sa8775p.dtsi"
> @@ -20,6 +21,7 @@ aliases {
>  		serial2 = &uart17;
>  		i2c18 = &i2c18;
>  		spi16 = &spi16;
> +		ufshc1 = &ufs_mem_hc;
>  	};
>  
>  	chosen {
> @@ -426,6 +428,23 @@ &uart17 {
>  	status = "okay";
>  };
>  
> +&ufs_mem_hc {
> +	reset-gpios = <&tlmm 149 GPIO_ACTIVE_LOW>;
> +	vcc-supply = <&vreg_l8a>;
> +	vcc-max-microamp = <1100000>;
> +	vccq-supply = <&vreg_l4c>;
> +	vccq-max-microamp = <1200000>;
> +
> +	status = "okay";
> +};
> +
> +&ufs_mem_phy {
> +	vdda-phy-supply = <&vreg_l4a>;
> +	vdda-pll-supply = <&vreg_l1c>;
> +
> +	status = "okay";
> +};
> +
>  &xo_board_clk {
>  	clock-frequency = <38400000>;
>  };
