Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C520C47257
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 15:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B03024956
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588694180;
	bh=MDboIcWn0tHCNAdgxLoKPDIK0vBj6CqTE8OXdAfH+64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lYndaYVHO0X9CBQqJmqZsTSCFzhECl1tjiAxRU9BGib2W5Wv+tHfMp/ISB+ZFWYaI
	 iTvCVpNkZ4ezlUlXwbO0jAHfDas3yCS9TNlJGgyceZTHqDOKGnTwNbobWMDv5dqd+Q
	 d0i7PRHikhvxsSVZeig7zS380Jw1DAHgs0jujJrE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgEEP4O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 11:56:14 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36708 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgEEP4O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2020 11:56:14 -0400
Received: by mail-oi1-f194.google.com with SMTP id s202so2396940oih.3;
        Tue, 05 May 2020 08:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=2kiU15T4JIvVcoMlu+le17FQfvQThvbLdJjc19jX2Pk=;
        b=HGwJTRVOuiqnIm1d0nhGkCIXB+Coi+shEvzBLxwyPbziapsCbQ+5UIs6SpAMl29MOC
         KYfNvZcWXXzxyUwlbGNfRKxK0VDQbk/7ixiv/NfCQ9eMud+WhnPuZ9wMWVdt5oiykjSw
         rlYJeWwpurCdUhBGEHpjWiGZmBzKabVTOMBuY9MrED1pmh1fgAt7AJhwUQr1rUG83p3p
         Yxz2/y0XcTkIirDr1l52ie7MMnqUIXeapj2bNETqqbfxvC39DbGDTr3QTUOwl3C5AEC/
         VlUGYt0FmzHN02WQyJIiP6cYuqqeNu8HpABEEY6/2TxOfmYlULIwyGkdq7FT2rxv9U1y
         8vow==
X-Gm-Message-State: AGi0PuY1LloqqLUJsEtnBxuaQLYnKzGYvco6xRBLW3/pnPT3yltp7Nad
        TqQzbpD/gNphuEdhuosHZw==
X-Google-Smtp-Source: APiQypL/3RVkUyjq56uhA77LSXMjBmXxLpVZ4c6aORzu4bgyRIUs2mZIy6cT9sC787m49IaPcEJGCg==
X-Received: by 2002:aca:1904:: with SMTP id l4mr3005182oii.106.1588694173239;
        Tue, 05 May 2020 08:56:13 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 85sm653166oie.17.2020.05.05.08.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 08:56:12 -0700 (PDT)
Received: (nullmailer pid 28089 invoked by uid 1000);
        Tue, 05 May 2020 15:56:11 -0000
Date:   Tue, 5 May 2020 10:56:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Message-ID: <20200505155611.GA23690@bogus>
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
 <CGME20200426174215epcas5p3e87abccf47976f6318eb470efef9db39@epcas5p3.samsung.com>
 <20200426173024.63069-7-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200426173024.63069-7-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 26, 2020 at 11:00:20PM +0530, Alim Akhtar wrote:
> This patch documents Samsung UFS PHY device tree bindings
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>  .../bindings/phy/samsung,ufs-phy.yaml         | 74 +++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
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

Can drop the description. Doesn't add anything special.

> +
> +  reg-names:
> +    items:
> +      - const: phy-pma
> +
> +  clocks:
> +    items:
> +      - description: PLL reference clock
> +      - description: symbol clock for input symbol ( rx0-ch0 symbol clock)
> +      - description: symbol clock for input symbol ( rx1-ch1 symbol clock)
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

Add:

additionalProperties: false

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/exynos7-clk.h>
> +
> +    ufs_phy: ufs-phy@15571800 {
> +        compatible = "samsung,exynos7-ufs-phy";
> +        reg = <0x15571800 0x240>;
> +        reg-names = "phy-pma";
> +        samsung,pmu-syscon = <&pmu_system_controller>;
> +        #phy-cells = <0>;
> +        clocks = <&clock_fsys1 SCLK_COMBO_PHY_EMBEDDED_26M>,
> +                 <&clock_fsys1 PHYCLK_UFS20_RX1_SYMBOL_USER>,
> +                 <&clock_fsys1 PHYCLK_UFS20_RX0_SYMBOL_USER>,
> +                 <&clock_fsys1 PHYCLK_UFS20_TX0_SYMBOL_USER>;
> +        clock-names = "ref_clk", "rx1_symbol_clk",
> +                      "rx0_symbol_clk", "tx0_symbol_clk";
> +
> +    };
> +...
> -- 
> 2.17.1
> 
