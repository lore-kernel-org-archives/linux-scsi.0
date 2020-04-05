Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB14C2BA15
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 01:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 024872071C
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 01:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586051663;
	bh=Qav5O+xTvyNZpe7gOK4lOAZ2IcXF9s4w0lOEbfXZHjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0vA2jDnVPClMRpPCYVTK2hN1ioU0HWxAeulKP/ULscbuvvWgo77OrTGVFttZt7l1w
	 osU0nJzGxnexpEtOcMesEFX1HYVtXKSjH5fcfMqGWa4tKiGT7hBJRaZOs+NtgCMqaL
	 o+w25FfEy1/shsIE/B5/tOeeOkPXnkIyGxshqwUs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgDEByT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Apr 2020 21:54:19 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40744 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgDEByT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2020 21:54:19 -0400
Received: by mail-io1-f67.google.com with SMTP id s15so11965665ioj.7;
        Sat, 04 Apr 2020 18:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WGZ1QR60q1jU80/fYr0WWBey1aNSa19nwxnAnET5oVo=;
        b=qiu2adu0Ji6UtryfNjKfsHWLdoqfwWCx8LSRL+QaT3mS7DfsEqmp5A2rdtEKc7Webg
         e67LIQHTA2kHMkoeaYZcIKhN7XY2OZDTGlrrZwQg/eTb73hSB6DauQcKq16v8vST6LUV
         TxAYGVjvLaGzRs5IS096ZweX8f3xqlOtZv2NuhRYI9FJzekw9ZZRDDzAZqekRWhSKHh4
         xrqBk2BC2l+Qgx6D63fCuhDS6YzeghwUbmSU0/8d3lHN6i70a9xp7sWh+9JS1WfGA0gq
         +2aEKEN/R/12xPtCrNgyyLSgQzHfddEjuw3zTKlHzm9QANITwqhOACoOv2tIoh+wOEuj
         mZRQ==
X-Gm-Message-State: AGi0PuacIblL2Jdqdv2Yuh7KaglTyjaO7q/0SC6551xlog2Bxp6D2Iko
        NqJ/74+GALGyQ2DjXoTEf14oYSk=
X-Google-Smtp-Source: APiQypImWqTBdmNG/vwTJJkqNRHISPAzw3peoR+pvIb61So8Pv/Sabd7lThe+FpmDbwepybmiIZcQA==
X-Received: by 2002:a6b:e316:: with SMTP id u22mr13881852ioc.1.1586051658393;
        Sat, 04 Apr 2020 18:54:18 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id x10sm4570896ili.88.2020.04.04.18.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 18:54:17 -0700 (PDT)
Received: (nullmailer pid 22378 invoked by uid 1000);
        Sun, 05 Apr 2020 01:54:16 -0000
Date:   Sat, 4 Apr 2020 19:54:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/5] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Message-ID: <20200405015416.GA16616@bogus>
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
 <CGME20200327171414epcas5p1460e932c0bc98f31ebdd115218b4fd49@epcas5p1.samsung.com>
 <20200327170638.17670-2-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327170638.17670-2-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 27, 2020 at 10:36:34PM +0530, Alim Akhtar wrote:
> This patch documents Samsung UFS PHY device tree bindings
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/phy/samsung,ufs-phy.yaml         | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> new file mode 100644
> index 000000000000..41ba481ecc76
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: (GPL-2.0)

Dual license new bindings:

(GPL-2.0-only OR BSD-2-Clause)

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
> +      - description: Referencec clock parrent
> +
> +  clock-names:
> +    items:
> +      - const: ref_clk_parent
> +      - const: ref_clk

Doesn't match what 'clocks' says.

Also, why do you need the parent in DT? Just use clk_get_parent(). DT 
should reflect actual h/w clock connections (not what the driver 
happens to need). Also, there's the assigned-clocks binding.

> +
> +  samsung,pmu-syscon:
> +    $ref: '/schemas/types.yaml#/definitions/phandle'
> +    description: phandle for PMU system controller interface, used to
> +                 control pmu registers for power isolation

We have a binding for power domains. Use that for power isolation.

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
> +        compatible = "samsung,exynos7-ufs-phy";
> +        reg = <0x15571800 0x240>;
> +        reg-names = "phy-pma";
> +        samsung,pmu-syscon = <&pmu_system_controller>;
> +        #phy-cells = <0>;
> +        clocks = <&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
> +                 <&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
> +        clock-names = "ref_clk_parent",
> +                      "ref_clk";
> +    };
> +...
> 
> base-commit: fb33c6510d5595144d585aa194d377cf74d31911
> -- 
> 2.17.1
> 
