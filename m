Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DA9C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 05:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiKKFek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 00:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKKFeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 00:34:37 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E095CD03;
        Thu, 10 Nov 2022 21:34:36 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id a5so6174382edb.11;
        Thu, 10 Nov 2022 21:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=npuUH7t8jZtW/7WS6lnnUhD3GHnWwrPrxxOd+6LRKUc=;
        b=JUyU6npbpKhkqVghfVWeesBOt/qOhUiDgqqbp8mrRdCFv27wKaAFnkeHCM3Yp+3pmu
         cDEI7RtaWI8rnBmWJWuY7qQAYNldWB6eudXK+ecy+num71p/q8CU3t0SXONq5k3+pRxZ
         eyspoRFMUNDd+5WSY0KMR6+tPIaOMhdLjI2Tve+uQAXg8u2HYezxQrh9uqjj81mVjQb4
         P7BQyx9vTpALI5kudise9WO7YbHAD0QxHi45Q9zEpdtsBa+qCffqA5a/+DjYOLyskdfM
         oJITy1+duMIgWACGRdg4uZK/f6dA696CktIgbatgCIGyut2wzdH25Z8ol1sQ5kUB/tb/
         PxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npuUH7t8jZtW/7WS6lnnUhD3GHnWwrPrxxOd+6LRKUc=;
        b=bjkrfPgcv7WdpvrcwQmHs8/MmwCLq1xSN7QpIMhnZzO49FVCljsqlGwyjNKoNgEcv9
         HB9O/hbNMRpgTYvmrMmjtNh1KOTU6T0Xci8cMR52CtMzGZ8qj1iTJcgvDIbXc4LWDt0p
         JqOTIkKeoEI9P8jwB/ACmJXwwcCIJIp3EUZrIkMf/5PuxM4lGNmRq8y0SDAvYALUJPQj
         AGbRv8VD58PTzgDeuHgfMXwy8FQoCneut5hLS0Mu5QsJ/i1s6/CU3nl35V6qcq8T8SiA
         qUAmlATHRG22aiQ4yehPvRgSd39nmFhG1jGoI9hEupA0t9vjrNHlTsVeNEQ71rPtJDZg
         XOaQ==
X-Gm-Message-State: ANoB5plwyuddVBhFwkTU2GyQscbUlE3HKj74szInWcetGfoxi5/kzQBh
        UD7yja4Q/jZeC4Se3kUiG0b2r+uSBxKsjirsYKE=
X-Google-Smtp-Source: AA0mqf7XmZ6slGPr098jHVig861NAEmq6cOQtiNhBCfhcGefQm7tsyj4UD6RNdGWhMcqw75I2fBxtvgM9fJnMZF4Sa8=
X-Received: by 2002:aa7:c649:0:b0:463:b0de:c210 with SMTP id
 z9-20020aa7c649000000b00463b0dec210mr138855edr.10.1668144875220; Thu, 10 Nov
 2022 21:34:35 -0800 (PST)
MIME-Version: 1.0
References: <20221110133640.30522-1-zhewang116@gmail.com> <20221110133640.30522-2-zhewang116@gmail.com>
 <4bee5178-b34c-ec4b-9773-07f368064c48@linaro.org>
In-Reply-To: <4bee5178-b34c-ec4b-9773-07f368064c48@linaro.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Fri, 11 Nov 2022 13:34:24 +0800
Message-ID: <CAJxzgGpAPs5+HFdq=GxR4bd_27XGLdJeTqAairCOhAf-wvj_CQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Krzysztof,

Thank you for your review!

On Thu, Nov 10, 2022 at 10:28 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 10/11/2022 14:36, Zhe Wang wrote:
> > From: Zhe Wang <zhe.wang1@unisoc.com>
> >
> > Add Unisoc ums9620 ufs host controller devicetree document.
> >
> > Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> > ---
> >  .../devicetree/bindings/ufs/sprd,ufs.yaml     | 72 +++++++++++++++++++
> >  1 file changed, 72 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml b/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
> > new file mode 100644
> > index 000000000000..88f2c670b0a4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
>
>
> Filename matching the compatible, so sprd,ums9620-ufs.yaml, unless you
> expect this to grow already? If so, can you post the rest?
>

Currently only ums9620 will be uploaded, I'll fix it.

> > @@ -0,0 +1,72 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/ufs/sprd,ufs.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Unisoc Universal Flash Storage (UFS) Controller
> > +
> > +maintainers:
> > +  - Zhe Wang <zhe.wang1@unisoc.com>
> > +
> > +allOf:
> > +  - $ref: ufs-common.yaml
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - sprd,ums9620-ufs
> > +
> > +  clocks:
> > +    maxItems: 2
> > +
> > +  clock-names:
> > +    items:
> > +      - const: hclk
> > +      - const: hclk_source
>
> Can you make these descriptive? "clk" is redundant, so basically you are
> saying name is "h" and "h_source"?
>

I'll fix it.

> > +
> > +  resets:
> > +    maxItems: 2
> > +
> > +  reset-names:
> > +    items:
> > +      - const: ufs_soft_rst
> > +      - const: ufsdev_soft_rst
>
> Drop "_rst" from both.
>

Will remove this.

> > +
> > +  sprd,ufs-anly-reg-syscon:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description: phandle of syscon used to control ufs analog reg.
>
> It's a reg? Then such syntax is expected:
> https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml#L42
>
>

I will modify it based on this example.

> > +  sprd,aon-apb-syscon:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description: phandle of syscon used to control always-on reg.
>
> It's a reg? Then such syntax is expected:
> https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml#L42
>

I will modify it based on this example.

> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    ufs: ufs@22000000 {
> > +        compatible = "sprd,ums9620-ufs";
> > +        reg = <0x22000000 0x3000>;
> > +        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
> > +        vcc-supply = <&vddemmcore>;
> > +        vdd-mphy-supply = <&vddufs1v2>;
> > +        clocks-name = "ufs_eb", "ufs_cfg_eb",
> > +            "ufs_hclk", "ufs_hclk_source";
>
> Align the lines.
>

I'll fix it.

> > +        clocks = <&apahb_gate CLK_UFS_EB>, <&apahb_gate CLK_UFS_CFG_EB>,
> > +            <&onapb_clk CLK_UFS_AON>, <&g51_pll CLK_TGPLL_256M>;
> > +        freq-table-hz = <0 0>, <0 0>, <0 0>, <0 0>;
>
> Why this is empty? What's the use of empty table?
>

freq-table-hz is used to configure the maximum frequency and minimum
frequency of clk, and an empty table means that no scaling up\down
operation is requiredfor the frequency of these clks.

> > +        reset-names = "ufs_soft_rst", "ufsdev_soft_rst";
> > +        resets = <&apahb_gate RESET_AP_AHB_UFS_SOFT_RST>,
> > +            <&aonapb_gate RESET_AON_APB_UFSDEV_SOFT_RST>;
> > +        sprd,ufs-anly-reg-syscon = <&anly_phy_g12_regs>;
> > +        sprd,aon-apb-syscon = <&aon_apb_regs>;
> > +        status = "disable";
>
> Drop status.
>

Will remove this.

Best regards,
Zhe Wang

> > +    };
>
> Best regards,
> Krzysztof
>
