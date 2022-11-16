Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5650CC43217
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 17:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbiKPREL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 12:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiKPREF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 12:04:05 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ABE24F24
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 09:03:55 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id d3so22645044ljl.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 09:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n2wcVN4J1tlPV+AnzZftcSxUop+5QUHzY6UpVrjVgB4=;
        b=qSCI/Ap9+bY+OClBVM/hGbIgAW6bxfs6GLL/gFVLdw0rg+e4T5y9bro336vZFMXwWr
         ejPJs6VxMDFRuBGn2xoWXrTUalv6MedN0AZNl0IXkUAvIk9AGllsl0dyLYjXZ7g7gRB7
         gDaRwXl1HUK80QoVZw673BHz1azHO8rNimQhtxkJMC6FfgcewCJTMuVmtZY2dXaOEIDg
         6AQyBOiIyu1tIb8BYrt3rNgThGagWxbj1bXhUUjO4/1g9p10usSa85nDzOiLhzpitPsK
         /3k+9sSviOMDHkKAVN6FE4POlEPUQaKUnWc+MtUEkAKaZvIvdiCGy6dXu5K9GTg3Jc0Z
         N7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2wcVN4J1tlPV+AnzZftcSxUop+5QUHzY6UpVrjVgB4=;
        b=M1/sxPFIQ8zLshYgTTMvbtqRNPgsumKRRi3lRBhMSYEyJUUUOfDB4MfORzt74RWdHy
         pFrUWrXA8vbWMrVGjdrrwu+ezOP8c8pD7bWpwnG3YbapWKRqD0Ams/3SKqrMq7o9NwqC
         BgZtnTKara0Xt+EdJWsYfxEMivWKKYyO9cTmmiHycDhbJAhEMFg/AfW8YbHb2Rtofyg0
         MROLXKzKvg/9u1erpbnoTQjqswuZ4jyyRzfRb0V+ZMIwK69PqwvHCHfyuzqJqiiAfkgw
         fI2WGDzq7A9qGPR7FD9oVJIS3cO/gRl0qh4OziStBNEFNS/HI13bzjFnPPh9CkME+XRd
         T/Fg==
X-Gm-Message-State: ANoB5pnx2VChjAZCKi6jrIw8mKe3P5inOm6rU/7tOgFczUYAgbfMOtOh
        95OVPIp9K29Qa7NEfLIpnHKtAQ==
X-Google-Smtp-Source: AA0mqf43BimP4m8KN0QSNc/gcqbkkuIydkNRTjo8awyHvTjZCw6qIVb6HTwXZGJIOSBtyCiP0FXF6A==
X-Received: by 2002:a2e:9941:0:b0:277:5059:82c9 with SMTP id r1-20020a2e9941000000b00277505982c9mr8606686ljj.218.1668618234274;
        Wed, 16 Nov 2022 09:03:54 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id cf30-20020a056512281e00b00492ca820e15sm2671479lfb.270.2022.11.16.09.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 09:03:53 -0800 (PST)
Message-ID: <87312b40-548d-dc60-588f-3583e496dcb3@linaro.org>
Date:   Wed, 16 Nov 2022 18:03:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Add document for Unisoc UFS host
 controller
Content-Language: en-US
To:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com
References: <20221116133131.6809-1-zhe.wang1@unisoc.com>
 <20221116133131.6809-2-zhe.wang1@unisoc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221116133131.6809-2-zhe.wang1@unisoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/11/2022 14:31, Zhe Wang wrote:
> Add Unisoc ums9620 ufs host controller devicetree document.
> 
> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>

Thank you for your patch. There is something to discuss/improve.

> +
> +  clock-names:
> +    items:
> +      - const: ufs_eb
> +      - const: ufs_cfg_eb
> +      - const: ufsh
> +      - const: ufsh_source
> +
> +  resets:
> +    maxItems: 2
> +
> +  reset-names:
> +    items:
> +      - const: ufs
> +      - const: ufsdev

Both clock names and resets are still not useful. "ufs" is the name of
the block, so reset name of "ufs" and "ufsdev" says nothing. This is the
dev right?

> +
> +  vdd-mphy-supply:
> +    description:
> +      Phandle to vdd-mphy supply regulator node.
> +
> +  sprd,ufs-anlg-syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: phandle of syscon used to control ufs analog regs.
> +
> +  sprd,aon-apb-syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: phandle of syscon used to control always-on regs.
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ufs: ufs@22000000 {
> +        compatible = "sprd,ums9620-ufs";
> +        reg = <0x22000000 0x3000>;
> +        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
> +        vcc-supply = <&vddemmccore>;
> +        vdd-mphy-supply = <&vddufs1v2>;
> +        clock-names = "ufs_eb", "ufs_cfg_eb", "ufsh", "ufsh_source";
> +        clocks = <&apahb_gate 5>, <&apahb_gate 22>, <&aonapb_clk 52>, <&g5l_pll 12>;

First clocks, then names.

> +        reset-names = "ufs", "ufsdev";
> +        resets = <&apahb_gate 4>, <&aonapb_gate 69>;

First resets, then names.

> +        sprd,ufs-anlg-syscon = <&anlg_phy_g12_regs>;
> +        sprd,aon-apb-syscon = <&aon_apb_regs>;
> +    };

Best regards,
Krzysztof

