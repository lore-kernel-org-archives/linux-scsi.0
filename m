Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B914C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 10:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiDLKEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377816AbiDLJ7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 05:59:20 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE5C13E0E
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 02:04:17 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bh17so35961687ejb.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 02:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0zbxI/ib4mJ1wAKwasv9a8XEMpxsdHx9KOUkKJeNjyc=;
        b=iPDESGSdefhx3WHl3UInb7oISwRqS0QoJI2JHspUFFmMnYInKpmWBT1ex2UHs5TdnG
         vDnp1pUIwYXF7FOqyOQz2S/bhv9gALNLTuE34KYk0rBLkgToOt7CfoFNK7C/LhhKGQ/+
         GaAeH/nwhmBElKJkqVEYLJ0g6T+55I2wO+I9ZXWTOlwms7cWGmpGJloZ9rfhM9vjsysZ
         3XjRuC4Vj8Zx1KozHvau8sM83o/XTnFI+ow0APLWuTfFKWFIE2VC3Qo4I+KIqjlUKNNT
         f9Ax1hsfsQ82nJWH+kvdYb2ccs8x9exbynejbcUODNU7ibhMcq8Mcl+h+MkTPTu04TLx
         /zPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0zbxI/ib4mJ1wAKwasv9a8XEMpxsdHx9KOUkKJeNjyc=;
        b=f5CWc2emI7nHhnv5V04/fJ4Vt0L26CskyHnrV1Hf8UYywfIZoPVGQWzx+nQlJSjJvX
         Gy2gNpJFRXGJPYAvNcXFMF55M266MtTx2z/36+LPuBnvjK9Jh7BjCpiGqvUqAtlIDKBB
         SvaXVikriFCOIqQWmt6Mspb00fOa3Ie4dPkQxwTCLUy/nEltDB1YW2Ye2JN9aIwjthre
         jD+MjwV6+rjONhmNSB8S8w0MNTOL70jYf2cJ+zmTuQ/18s2Cfx0ju1LmOMuBtuoWny/W
         3vSxM3EYK0xLOeOFqW5igITiHvcTIKVr7Vj9XbUJVkCHe/hWS/1svLk39UfpOUcEHqkW
         ic8w==
X-Gm-Message-State: AOAM5317WucYToHGYcoFNx20ph4GSt2KsJyNofksZHNLtmgQo5G0Oqmm
        BlPeNi1BKxfMnwKW6GTBsGC+Og==
X-Google-Smtp-Source: ABdhPJyErGvhOFNiJ61usdXAps8FK2Vg+GNwV0o4wtQnbyq0kE0lJzdjV4sPTfJL9Hy/4xhDaVt/yQ==
X-Received: by 2002:a17:906:730c:b0:6e6:c512:49c8 with SMTP id di12-20020a170906730c00b006e6c51249c8mr33870825ejc.405.1649754255559;
        Tue, 12 Apr 2022 02:04:15 -0700 (PDT)
Received: from [192.168.0.194] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id bj13-20020a170906b04d00b006e742719b9fsm11004863ejb.7.2022.04.12.02.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 02:04:15 -0700 (PDT)
Message-ID: <b189e6fc-98b5-9668-d22c-1144d5741071@linaro.org>
Date:   Tue, 12 Apr 2022 11:04:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 6/7] arm64: dts: renesas: r8a779f0: Add UFS node
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, robh+dt@kernel.org,
        krzk+dt@kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20220412073647.3808493-1-yoshihiro.shimoda.uh@renesas.com>
 <20220412073647.3808493-7-yoshihiro.shimoda.uh@renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220412073647.3808493-7-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/04/2022 09:36, Yoshihiro Shimoda wrote:
> Add UFS node for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git

Thank you for your patch. There is something to discuss/improve.

 a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> index b0241aa29fc8..8bf418a4232f 100644
> --- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> @@ -40,6 +40,13 @@ extalr_clk: extalr {
>  		clock-frequency = <0>;
>  	};
>  
> +	ufs30_clk: ufs30_refclk_v {

No underscores in node names. Node names should be generic, so if you
insist on prefix, it could be "ufs30-clk".

> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		/* This value must be overridden by the board */
> +		clock-frequency = <0>;
> +	};
> +
>  	pmu_a55 {
>  		compatible = "arm,cortex-a55-pmu";
>  		interrupts-extended = <&gic GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
> @@ -258,6 +265,18 @@ i2c5: i2c@e66e0000 {
>  			status = "disabled";
>  		};
>  
> +		ufs: scsi@e6860000 {

Node name: ufs (it is not a SCSI device, AFAIK).

> +			compatible = "renesas,r8a779f0-ufs";
> +			reg = <0 0xe6860000 0 0x100>;
> +			interrupts = <GIC_SPI 235 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&cpg CPG_MOD 1514>, <&ufs30_clk>;
> +			clock-names = "fck", "ref_clk";


Best regards,
Krzysztof
