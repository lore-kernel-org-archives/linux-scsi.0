Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C149C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 14:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiKJO2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 09:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiKJO2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 09:28:37 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1222F11802
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 06:28:32 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id f37so3556374lfv.8
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 06:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DW2ynzAX3T8hS3kgzhGkodXLMpgmtoMDTc1baAsaHJg=;
        b=MmPRU0x93phY73/IoNE+yZ3Zp3CUZAEkKsiw9afPfa3ejvEGuzrd0ZmhFgY3bIH3SV
         L04EZBo9d5vc8BP0ZmBrrePhS7lyQR5UJnsp4tdLx4ERLQ2knaLrFM7Tg43KxwxuqtH6
         m6DRU/OBYZPKkrRP3ogYd8Oj1cENt1DQlNM0LLW1g3ZTNp6/k+F2RIqzz74hfxtPIlYa
         uQ+NbFGOg45JdVFoFni/jCdXAt6epOVeiQd8V2NJqEWIHWLPYe6umT6rA0fQOM46XZWE
         yncW/+p0w1entL63j8D6FaMAVNL9YCAUrxXjO+/G7fjjodj5mFmc6hhYncY+0HdRwDW0
         weTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DW2ynzAX3T8hS3kgzhGkodXLMpgmtoMDTc1baAsaHJg=;
        b=KJeBvGuJSuHk8D84/QVaNUkMgcMyKIhDuo/sw48momvkkiPkzZWGfdnhMzvth06fd7
         CXjk9c0ePSzkXwE4dhndh5lvh2Zsw/W6aAJrsIdgJdB396ua4izxy/BV2O/PnMre7/xB
         eRyvAj1cQ0/IOE+lVyTrGQyDqPrvMH7tbEJkOvnZmeiHMbcT80xboUssUjRq1rp0v5Ad
         Q1zOwe2Tc/ZHJnXEjNBWKmY9mlapA84X1FUe5eGUcNAMGIwWT+oK1khne8NjDBGmJEC6
         ofjMviWhIDwFJmSYDZqayVc0HsYUUWopyypUGYPE8csYJMqH8HHEYb7fOZyUWbl8EmyM
         uZ/A==
X-Gm-Message-State: ACrzQf0VdtteQRSEeDWwwHdMhXa4VTG9SyRQV3/ay2wIvwtR+QthGw3O
        FsN/61p9R3NfOJ2ok2N7zYMW4g==
X-Google-Smtp-Source: AMsMyM6a+xV9yQY2k+2bxw1rUGyzDkX/TlF9AlBJpzvLaAcRnxItthiLV6oVHjA5/0WrDnWPHq2Izw==
X-Received: by 2002:a05:6512:25c:b0:4b1:753b:e671 with SMTP id b28-20020a056512025c00b004b1753be671mr1301918lfo.441.1668090510687;
        Thu, 10 Nov 2022 06:28:30 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id bd10-20020a05651c168a00b0026e04cc88cfsm2762219ljb.124.2022.11.10.06.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:28:28 -0800 (PST)
Message-ID: <4bee5178-b34c-ec4b-9773-07f368064c48@linaro.org>
Date:   Thu, 10 Nov 2022 15:28:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Add document for Unisoc UFS host
 controller
Content-Language: en-US
To:     Zhe Wang <zhewang116@gmail.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
References: <20221110133640.30522-1-zhewang116@gmail.com>
 <20221110133640.30522-2-zhewang116@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221110133640.30522-2-zhewang116@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2022 14:36, Zhe Wang wrote:
> From: Zhe Wang <zhe.wang1@unisoc.com>
> 
> Add Unisoc ums9620 ufs host controller devicetree document.
> 
> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> ---
>  .../devicetree/bindings/ufs/sprd,ufs.yaml     | 72 +++++++++++++++++++
>  1 file changed, 72 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml b/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
> new file mode 100644
> index 000000000000..88f2c670b0a4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml


Filename matching the compatible, so sprd,ums9620-ufs.yaml, unless you
expect this to grow already? If so, can you post the rest?

> @@ -0,0 +1,72 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/sprd,ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Unisoc Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Zhe Wang <zhe.wang1@unisoc.com>
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +properties:
> +  compatible:
> +    enum:
> +      - sprd,ums9620-ufs
> +
> +  clocks:
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: hclk
> +      - const: hclk_source

Can you make these descriptive? "clk" is redundant, so basically you are
saying name is "h" and "h_source"?

> +
> +  resets:
> +    maxItems: 2
> +
> +  reset-names:
> +    items:
> +      - const: ufs_soft_rst
> +      - const: ufsdev_soft_rst

Drop "_rst" from both.

> +
> +  sprd,ufs-anly-reg-syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: phandle of syscon used to control ufs analog reg.

It's a reg? Then such syntax is expected:
https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml#L42


> +  sprd,aon-apb-syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: phandle of syscon used to control always-on reg.

It's a reg? Then such syntax is expected:
https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml#L42

> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - resets
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufs: ufs@22000000 {
> +        compatible = "sprd,ums9620-ufs";
> +        reg = <0x22000000 0x3000>;
> +        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
> +        vcc-supply = <&vddemmcore>;
> +        vdd-mphy-supply = <&vddufs1v2>;
> +        clocks-name = "ufs_eb", "ufs_cfg_eb",
> +            "ufs_hclk", "ufs_hclk_source";

Align the lines.

> +        clocks = <&apahb_gate CLK_UFS_EB>, <&apahb_gate CLK_UFS_CFG_EB>,
> +            <&onapb_clk CLK_UFS_AON>, <&g51_pll CLK_TGPLL_256M>;
> +        freq-table-hz = <0 0>, <0 0>, <0 0>, <0 0>;

Why this is empty? What's the use of empty table?

> +        reset-names = "ufs_soft_rst", "ufsdev_soft_rst";
> +        resets = <&apahb_gate RESET_AP_AHB_UFS_SOFT_RST>,
> +            <&aonapb_gate RESET_AON_APB_UFSDEV_SOFT_RST>;
> +        sprd,ufs-anly-reg-syscon = <&anly_phy_g12_regs>;
> +        sprd,aon-apb-syscon = <&aon_apb_regs>;
> +        status = "disable";

Drop status.

> +    };

Best regards,
Krzysztof

