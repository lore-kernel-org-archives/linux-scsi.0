Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800A8C742A7
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 10:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCHKSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 05:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCHKSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 05:18:06 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E071C584
        for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2023 02:18:03 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id t14so16027446ljd.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2023 02:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678270681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=krZQpr7uIm4vLx88h00ljILNedqe5S23Jc9CthZt6vU=;
        b=PEerjSzms92KVfFhY/EDDlsfRjdHx3uWqwcch/aK80fwALOeLAy74p2WPgAFoQNSSr
         sonOqt17DNZvs3NnL7QFpRcFnb/rklcHvxjsoXqPYtgwyQe8ahAiuPmtrYNDQLWG+XTb
         tbvH0r/yU5DXqsZxHw4ggMmgkQgS/DOmH2q3TLWciwkiXcnwB7pQFO8y78XRgdoK+v0H
         2FT7VtiOankxEG3I3fZUkq6pNqY5MQJtuGBlLYr88pEuOw2Q/ddpZz6JPf+1gtzX8KqH
         +WizrEyfHbtEKvSwd8SG6RyPFdt273usiyvAh84KpFdLTG2bDzvdZeoGpfg3xL3nqSsf
         NMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678270681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krZQpr7uIm4vLx88h00ljILNedqe5S23Jc9CthZt6vU=;
        b=WZ1vD/lgDOTJEW/5IUKe+24z3cR9GIrftjeoowq+SbjTyXUDXzBXPjFZJdozvxlNrS
         93nOdHgRk29AqxMIEfEJpv62RLBcelCaiV5YU+zpI2mq/CqhtMiestj49P9pd+pvwEf7
         j/DfB6Lb5xp1smuVvjjJx4V6rwst+9k0XzUOCSx23QLdcI1V3UfOzL+08VgDC0rUJFtW
         Al6mfvWBRXfFExrrfo1E+ArdnJWlxQayUeu1Bj0+GDKiBrAQFVEJFZKtYkhk8Gc8hIrU
         HtbMrheH90Z6SGfoicHOD8u+W2PEkBYmmAjP2huaVO3SahThjAqBm52LADl6GCE+3zMG
         +fBA==
X-Gm-Message-State: AO0yUKUoyqE4Ca6vxZzhsZZC1KTwV1tXYOZ5+pUgL7JphAPpsFpHaSP3
        XhveORcsH/9Ija4iJNUCIwVTdQ==
X-Google-Smtp-Source: AK7set9n1U1YMBH0wlOoSKEkMVTtc4syUR8K40rQA+XD5LofbKGrhDBmIn2Es6laJf5Gpzy+YqdFcg==
X-Received: by 2002:a2e:3111:0:b0:290:6e3b:be34 with SMTP id x17-20020a2e3111000000b002906e3bbe34mr4957732ljx.42.1678270681440;
        Wed, 08 Mar 2023 02:18:01 -0800 (PST)
Received: from [192.168.1.101] (abyj16.neoplus.adsl.tpnet.pl. [83.9.29.16])
        by smtp.gmail.com with ESMTPSA id c19-20020ac244b3000000b004cc9c2932a9sm2304433lfm.302.2023.03.08.02.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 02:18:01 -0800 (PST)
Message-ID: <b72d54ac-5152-bc6c-55a9-dd59d32614d6@linaro.org>
Date:   Wed, 8 Mar 2023 11:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v7 4/6] arm64: dts: qcom: sm6125: Add UFS nodes
Content-Language: en-US
To:     Lux Aliaga <they@mint.lgbt>, agross@kernel.org,
        andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        kishon@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, keescook@chromium.org, tony.luck@intel.com,
        gpiccoli@igalia.com
Cc:     ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org
References: <20230306170817.3806-1-they@mint.lgbt>
 <20230306170817.3806-5-they@mint.lgbt>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230306170817.3806-5-they@mint.lgbt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6.03.2023 18:08, Lux Aliaga wrote:
> Adds a UFS host controller node and its corresponding PHY to
> the sm6125 platform.
> 
> Signed-off-by: Lux Aliaga <they@mint.lgbt>
> ---
[...]

> +		ufs_mem_phy: phy@4807000 {
> +			compatible = "qcom,sm6125-qmp-ufs-phy";
> +			reg = <0x04807000 0xdb8>;
> +
> +			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>, <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
> +			clock-names = "ref", "ref_aux";
Please wrap it into

clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
	 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
clock-names = "ref",
	      "ref_aux";


and resolve the binding/offset situation. Otherwise, LGTM!

Konrad
> +
> +			resets = <&ufs_mem_hc 0>;
> +			reset-names = "ufsphy";
> +
> +			power-domains = <&gcc UFS_PHY_GDSC>;
> +
> +			#phy-cells = <0>;
> +
> +			status = "disabled";
> +		};
> +
>  		gpi_dma0: dma-controller@4a00000 {
>  			compatible = "qcom,sm6125-gpi-dma", "qcom,sdm845-gpi-dma";
>  			reg = <0x04a00000 0x60000>;
