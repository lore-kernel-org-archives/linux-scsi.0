Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C926CC43217
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 08:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbiKQIpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 03:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbiKQIpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 03:45:25 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA0F5FAB;
        Thu, 17 Nov 2022 00:45:15 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id gv23so3371534ejb.3;
        Thu, 17 Nov 2022 00:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=basFVZ/+OAjZQ+bU9lZZNayqlEJwnc7m7i2mGDGiNgw=;
        b=JCvN/P0K70CRKEX1WCsmmbV3oS/EEn3ae9PsKN+mHiWECU3hQkNgH3RdpGEK/U3wx4
         TBK5YqN3sjOxOVckWmXSh82sfqLM/WZLouKx/GV+3YzsgaE3hK7/HwQcUBvoe/S7CvDV
         Q9Gkx5cjFmw2VBBSn8Y3AcRXF0wX1CPFPQw5FW1xpBI7MkZPoWLVXrN1XQAiq/s5tOsv
         9vuDmRDdFoiLi2Z5D4YDSLLMtkGlVEPgcUjXm+d85ox2iIwigRTYSgDZvr7i62L6BYbs
         /3yGyji9Ra8cNGO0gJKs6BjzeMHBccojU5f+8vvrULoLXqpMYN0ijy7oFQyiWD5K9ILK
         8p+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=basFVZ/+OAjZQ+bU9lZZNayqlEJwnc7m7i2mGDGiNgw=;
        b=6LU7V0rYa6GdcM2tkLNCTVaqfPKrzXkuO0a83JD+wSQImXITKyLPV2pcKgbS0PqWwM
         o6OD4Jr9WCa+TgkIPUX5ygpld3ieg4mtmimUrs+8YcCT/f/lhMfEWDk3mWIrKSdtilLr
         JNYtsNGOmDrSVdvZ56ZLPrN2wkObFa3jfBGKl3lJ3JEkpXt9jTsNcltqUzs7+lGkvoiU
         VLgS28KE11VR7zw3izeKXTeiD6fZb6Is5xIk7k2YPoqRL8yHitJZCxFMJGXx/Dk4hqmK
         T+DxiW1SPK5/n7G30Zv9p+JPenQXnPu7y2WZue+XOdwN1gB61IJA5GyeZP+MDHXeGYwu
         u5jg==
X-Gm-Message-State: ANoB5pnZGFNZXK2fz/m7ATN/xuRLxLclPcJ5ELHG2xtru/zewsKTl6Wk
        5TzxtkKhwXcVqULB2FXNDHScsRdgNEkYEGtdPQY=
X-Google-Smtp-Source: AA0mqf73o6bvreYL/RuxsjD2JKn0dNuEXjzmSyqwDCjAUgPcCpqx34cZLtiSpbwSboF8b31qWoGQPepRNY/X0mGwmyI=
X-Received: by 2002:a17:906:ecaf:b0:78d:981a:d997 with SMTP id
 qh15-20020a170906ecaf00b0078d981ad997mr1322921ejb.654.1668674713912; Thu, 17
 Nov 2022 00:45:13 -0800 (PST)
MIME-Version: 1.0
References: <20221116133131.6809-1-zhe.wang1@unisoc.com> <20221116133131.6809-2-zhe.wang1@unisoc.com>
 <87312b40-548d-dc60-588f-3583e496dcb3@linaro.org>
In-Reply-To: <87312b40-548d-dc60-588f-3583e496dcb3@linaro.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Thu, 17 Nov 2022 16:45:02 +0800
Message-ID: <CAJxzgGoebXFxeWa7TXe5yD+xAme=6YxTC-E9emUw2kG2zpH6+A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi Krzysztof

On Thu, Nov 17, 2022 at 1:11 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 16/11/2022 14:31, Zhe Wang wrote:
> > Add Unisoc ums9620 ufs host controller devicetree document.
> >
> > Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
>
> Thank you for your patch. There is something to discuss/improve.
>
> > +
> > +  clock-names:
> > +    items:
> > +      - const: ufs_eb
> > +      - const: ufs_cfg_eb
> > +      - const: ufsh
> > +      - const: ufsh_source
> > +
> > +  resets:
> > +    maxItems: 2
> > +
> > +  reset-names:
> > +    items:
> > +      - const: ufs
> > +      - const: ufsdev
>
> Both clock names and resets are still not useful. "ufs" is the name of
> the block, so reset name of "ufs" and "ufsdev" says nothing. This is the
> dev right?
>

Yes, this means reset on the device side. How about the modification below?

+  clock-names:
+    items:
+      - const: controller_eb
+      - const: cfg_eb
+      - const: core
+      - const: core_source
+
+  resets:
+    maxItems: 2
+
+  reset-names:
+    items:
+      - const: controller
+      - const: device

> > +
> > +  vdd-mphy-supply:
> > +    description:
> > +      Phandle to vdd-mphy supply regulator node.
> > +
> > +  sprd,ufs-anlg-syscon:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description: phandle of syscon used to control ufs analog regs.
> > +
> > +  sprd,aon-apb-syscon:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description: phandle of syscon used to control always-on regs.
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +  - reset-names
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    ufs: ufs@22000000 {
> > +        compatible = "sprd,ums9620-ufs";
> > +        reg = <0x22000000 0x3000>;
> > +        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
> > +        vcc-supply = <&vddemmccore>;
> > +        vdd-mphy-supply = <&vddufs1v2>;
> > +        clock-names = "ufs_eb", "ufs_cfg_eb", "ufsh", "ufsh_source";
> > +        clocks = <&apahb_gate 5>, <&apahb_gate 22>, <&aonapb_clk 52>, <&g5l_pll 12>;
>
> First clocks, then names.
>

I'll fix it.

> > +        reset-names = "ufs", "ufsdev";
> > +        resets = <&apahb_gate 4>, <&aonapb_gate 69>;
>
> First resets, then names.
>

I'll fix it.

Best regards,
Zhe

> > +        sprd,ufs-anlg-syscon = <&anlg_phy_g12_regs>;
> > +        sprd,aon-apb-syscon = <&aon_apb_regs>;
> > +    };
>
> Best regards,
> Krzysztof
>
