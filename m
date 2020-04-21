Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDF3C55184
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD002071C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJCwEkkT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgDUQ41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 12:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729522AbgDUQ4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 12:56:20 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D537C061A41;
        Tue, 21 Apr 2020 09:56:20 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id o3so8888093vsd.4;
        Tue, 21 Apr 2020 09:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=37fOrxE1fKmyrZcZ9uj9U00yYV6qcOdwlC6FHpWLz5o=;
        b=aJCwEkkTS7Lf+D5PtLNfxTG06ZCZMDnPCk2mronKD6jrzO3Pswn7YY1gtpWoVzO3IL
         F36IrlqgVicFqfIITTdcnj62P2dkVycu/TZrL51HyFU0l0BsX1x1LGxaIDT6IztoovH6
         bh4EwbmXnBInbOmk2EBYO7cApQ3YNW23VPmCqcUglyV1mFZoD0ZH/XADATAupn44qJy7
         DPFFErwP6gc1INmcHzDV0iZrrHvLu4aSktpONVbLZtk/ulBon2tTEnpUmd4TX0zkFZcq
         oq0vPn06xkcepeP2I1GOQ4wXJP/R8gURQ43Ri211jz/dNwRKmp7bZZ6o5uTYsfDvEUGN
         wIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=37fOrxE1fKmyrZcZ9uj9U00yYV6qcOdwlC6FHpWLz5o=;
        b=cp6SM6RFoueFJSZFI+6EGBbIHmRsi5qeM8GL1JFajpXiZ0A6mIvgt6ckf8QoSoo+//
         MxnolvD6lKG7A+ldisMGychkUYv8fGenRnb/6qz5mhi9qMjrQ779tBTo4VISDBEWIDOl
         5tOPa0d9MJ0uXsXtmhmG+Y2pqTkabjlcL3fUzDF1sQ119TqQykPdvRhUIRRYhy/HI9eG
         gEnQiMr8ftN8i2mVNzn2cpy6FW2RQGW4oUZNSK4z3qdW2Pv/uoBdaChB/y15AQHfbLLI
         kJvQDCq8P59J5rKvc2/QBv5aOef6LGedvFaRoG8ez3ovdK2q0QaCZgbrVHAozxIM2QMe
         15vQ==
X-Gm-Message-State: AGi0PubxRa2O7n+CWpdmxDQLPWpu9QdSnfRzBIlKWXaGSY6JaKKoEkbd
        kbHVYdhAARr3mgQ4RDTK890z/bu9LKT3ppEoEow=
X-Google-Smtp-Source: APiQypIY18Sf6NoiOtOYbIxR9HPlyKzHoHfzV8rfCvZ4e9oUlqLt/eeDj+mCotV8G5ALwPIda1o4A6En/JPCDyZus3w=
X-Received: by 2002:a67:2dcb:: with SMTP id t194mr10831926vst.136.1587488178955;
 Tue, 21 Apr 2020 09:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200417181018epcas5p1e51c7ca0fe81df16554548df5b82e3e4@epcas5p1.samsung.com>
 <20200417175944.47189-1-alim.akhtar@samsung.com> <20200417175944.47189-7-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-7-alim.akhtar@samsung.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 21 Apr 2020 22:25:43 +0530
Message-ID: <CAGOxZ51jnbnHjVDQitbvSkrPH2=OdBKQHPnnT8yr+nKARud-WQ@mail.gmail.com>
Subject: Re: [PATCH v6 06/10] dt-bindings: phy: Document Samsung UFS PHY bindings
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob
Request you to comment on this dt-bindings documentation.
Thanks

On Fri, Apr 17, 2020 at 11:43 PM Alim Akhtar <alim.akhtar@samsung.com> wrot=
e:
>
> This patch documents Samsung UFS PHY device tree bindings
>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Tested-by: Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>  .../bindings/phy/samsung,ufs-phy.yaml         | 74 +++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy=
.yaml
>
> diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b=
/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> new file mode 100644
> index 000000000000..352d5dda320d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> @@ -0,0 +1,74 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/samsung,ufs-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Samsung SoC series UFS PHY Device Tree Bindings
> +
> +maintainers:
> +  - Alim Akhtar <alim.akhtar@samsung.com>
> +
> +properties:
> +  "#phy-cells":
> +    const: 0
> +
> +  compatible:
> +    enum:
> +      - samsung,exynos7-ufs-phy
> +
> +  reg:
> +    maxItems: 1
> +    description: PHY base register address
> +
> +  reg-names:
> +    items:
> +      - const: phy-pma
> +
> +  clocks:
> +    items:
> +      - description: PLL reference clock
> +      - description: symbol clock for input symbol ( rx0-ch0 symbol cloc=
k)
> +      - description: symbol clock for input symbol ( rx1-ch1 symbol cloc=
k)
> +      - description: symbol clock for output symbol ( tx0 symbol clock)
> +
> +  clock-names:
> +    items:
> +      - const: ref_clk
> +      - const: rx1_symbol_clk
> +      - const: rx0_symbol_clk
> +      - const: tx0_symbol_clk
> +
> +  samsung,pmu-syscon:
> +    $ref: '/schemas/types.yaml#/definitions/phandle'
> +    description: phandle for PMU system controller interface, used to
> +                 control pmu registers bits for ufs m-phy
> +
> +required:
> +  - "#phy-cells"
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +  - clock-names
> +  - samsung,pmu-syscon
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/exynos7-clk.h>
> +
> +    ufs_phy: ufs-phy@15571800 {
> +        compatible =3D "samsung,exynos7-ufs-phy";
> +        reg =3D <0x15571800 0x240>;
> +        reg-names =3D "phy-pma";
> +        samsung,pmu-syscon =3D <&pmu_system_controller>;
> +        #phy-cells =3D <0>;
> +        clocks =3D <&clock_fsys1 SCLK_COMBO_PHY_EMBEDDED_26M>,
> +                 <&clock_fsys1 PHYCLK_UFS20_RX1_SYMBOL_USER>,
> +                 <&clock_fsys1 PHYCLK_UFS20_RX0_SYMBOL_USER>,
> +                 <&clock_fsys1 PHYCLK_UFS20_TX0_SYMBOL_USER>;
> +        clock-names =3D "ref_clk", "rx1_symbol_clk",
> +                      "rx0_symbol_clk", "tx0_symbol_clk";
> +
> +    };
> +...
> --
> 2.17.1
>


--=20
Regards,
Alim
