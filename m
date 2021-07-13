Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CF4C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 12:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE2761006
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 12:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhGMMjM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 08:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbhGMMjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 08:39:10 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70CBC0613E9;
        Tue, 13 Jul 2021 05:36:19 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g22so26986475iom.1;
        Tue, 13 Jul 2021 05:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYnGjrlZ5z/fC91mEpEO1zoqRsMy8U9xbP5qH086+PE=;
        b=dgn2pqjreoanGsyrB/5b5aW4oR/3rEwqjyxxVdIGbG8Rr6V3zCkjRy3u/wIWk6V5Mp
         ud+RUEJX+DJ+H+RPVPf2uaEae/WqnHpy3KhCJlmKZ3pSGtkukJp3nG2lu9VqnlK5Ex8q
         SzXL18Mhk2HgCGf6DD0yMvC0onR1BhnxtmLjyBDkxyo4yDZQ5Rdrj0c5MktU7rfUGHH4
         WwZPZBZxC4FxIT5MEYCU+7U2lOVQTQ6LUhcDQ5AIKuar63k5aORKsXtoPpCECDGgCTge
         cHfRXkX7O7ItFfoM6o57O4ohE8zEyd3S310F7pbfvaIpLLmzh2RG2bInEO2rP6hLTMQ4
         kdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYnGjrlZ5z/fC91mEpEO1zoqRsMy8U9xbP5qH086+PE=;
        b=MHYiQPoyw364W+/o63XexiLZ+MH0x3rjbaTsHTlYGVTOimVh5g35MgQp89Sk2I13LW
         yYDPgeWq773FGDXPLVovt3KXUlcA3HotqLVFBEYbiTEZvMxb8jV7UfxnZs9dB4MHl4i5
         U+qujPfVBn8rgXPGZptpXROxxA6u7xX9vcI+c4jguM1Wv+SoC3Kxr5bJMRGLyw/PJIGA
         CrS/tobt93Z/n31oH1w+rCt7/GgnqSQ5+WZcaRY03FCTdge4Ybs8zI37iqj+NHhwDU46
         tVJAUh2llwS71sgFVpdHSmMpy5DXCGEtnd41AWwUlld2KtNuIvIHeAlZ+GkPrtN3A8Th
         UUZQ==
X-Gm-Message-State: AOAM533RR4BxfwnPQOFD76//EjUa44lFh3eLc8yNiMVHiP7um/Mw0Cn9
        /EzCo+3i72JdxZPUZ+mBuwsw8Oe0NX7pdsKHWHA=
X-Google-Smtp-Source: ABdhPJyCH72MaLOUyK+oviLVcOUdG02yNIXFra02A0athWVli80Y0AfHt0J4YT0PBTp2pvX1uVqwErfDvtEApyglFDM=
X-Received: by 2002:a6b:ef01:: with SMTP id k1mr2979640ioh.102.1626179779105;
 Tue, 13 Jul 2021 05:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8@epcas5p4.samsung.com>
 <20200613024706.27975-1-alim.akhtar@samsung.com> <20200613024706.27975-9-alim.akhtar@samsung.com>
In-Reply-To: <20200613024706.27975-9-alim.akhtar@samsung.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 13 Jul 2021 12:35:41 +0530
Message-ID: <CAGOxZ500JD5xNWb0xFyEgaUH0qwQKm+kn1Ng71_1SM1wmJFxKg@mail.gmail.com>
Subject: Re: [RESEND PATCH v10 08/10] dt-bindings: ufs: Add bindings for
 Samsung ufs host
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob
Anything else needs to be done for this patch?

On Sat, Jun 13, 2020 at 8:36 AM Alim Akhtar <alim.akhtar@samsung.com> wrote:
>
> This patch adds DT bindings for Samsung ufs hci
>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/ufs/samsung,exynos-ufs.yaml      | 89 +++++++++++++++++++
>  1 file changed, 89 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
>
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> new file mode 100644
> index 000000000000..38193975c9f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -0,0 +1,89 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/samsung,exynos-ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Samsung SoC series UFS host controller Device Tree Bindings
> +
> +maintainers:
> +  - Alim Akhtar <alim.akhtar@samsung.com>
> +
> +description: |
> +  Each Samsung UFS host controller instance should have its own node.
> +  This binding define Samsung specific binding other then what is used
> +  in the common ufshcd bindings
> +  [1] Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +
> +properties:
> +
> +  compatible:
> +    enum:
> +      - samsung,exynos7-ufs
> +
> +  reg:
> +    items:
> +     - description: HCI register
> +     - description: vendor specific register
> +     - description: unipro register
> +     - description: UFS protector register
> +
> +  reg-names:
> +    items:
> +      - const: hci
> +      - const: vs_hci
> +      - const: unipro
> +      - const: ufsp
> +
> +  clocks:
> +    items:
> +      - description: ufs link core clock
> +      - description: unipro main clock
> +
> +  clock-names:
> +    items:
> +      - const: core_clk
> +      - const: sclk_unipro_main
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  phys:
> +    maxItems: 1
> +
> +  phy-names:
> +    const: ufs-phy
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phys
> +  - phy-names
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/exynos7-clk.h>
> +
> +    ufs: ufs@15570000 {
> +       compatible = "samsung,exynos7-ufs";
> +       reg = <0x15570000 0x100>,
> +             <0x15570100 0x100>,
> +             <0x15571000 0x200>,
> +             <0x15572000 0x300>;
> +       reg-names = "hci", "vs_hci", "unipro", "ufsp";
> +       interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
> +       clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
> +                <&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
> +       clock-names = "core_clk", "sclk_unipro_main";
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> +       phys = <&ufs_phy>;
> +       phy-names = "ufs-phy";
> +    };
> +...
> --
> 2.17.1
>


-- 
Regards,
Alim
