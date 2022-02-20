Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDFAC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 17:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244331AbiBTRHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Feb 2022 12:07:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbiBTRHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Feb 2022 12:07:08 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B1C33E39
        for <linux-scsi@vger.kernel.org>; Sun, 20 Feb 2022 09:06:44 -0800 (PST)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 233423F1CA
        for <linux-scsi@vger.kernel.org>; Sun, 20 Feb 2022 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645376803;
        bh=WBnOQoWPjOARSkiKCXtTlNVMckDodu4ejT0rDiafNjA=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=Ni5srko/AZ2mtmUIYas70FeEUGC0SSP+jNegpXG4/aj+lJsPe5baYorJkDQxxDGab
         pf2AI7atdsaGg1CXV672O2b5rfxI2OrD2kUU12u7tvtScvSXnuGxEbUP+JxRVLnr4M
         zfj+A/H6RQraaJSL2yEppnA8M3533+K9QgoBCjejAkDynheMiJOAFDR+za5hBzSuFy
         TMVTv3Bf/Ftz+7VwLXoeknLYf8kDDRQudaR2CN7cNa9W4IevaRaxFvgGpf8U++3Cr8
         qNGD37H3i/mrcsBGVhQNQ8aELDUrGWJwYMMdTCUu8o2S9p1N5VpMVbVikcuCn0MjJE
         y9Gkm5pOoIwHQ==
Received: by mail-wr1-f72.google.com with SMTP id e11-20020adf9bcb000000b001e316b01456so6107545wrc.21
        for <linux-scsi@vger.kernel.org>; Sun, 20 Feb 2022 09:06:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WBnOQoWPjOARSkiKCXtTlNVMckDodu4ejT0rDiafNjA=;
        b=QpOr39xASeHTtivVAGfhcNTUyUduTyINH/P3jGfdUq88y8ZAZLBD3H+IaxcbeDZKqI
         DlTME+oBng5bDQD5OhnhsvetYBm3UcIee3EL9Z5eWthaZa+u2oFObwcR+l2QQTmQvZRh
         XH4hyJDbb02xikyYuTVotFtlSiHpyNlriMLcuGDWfB8KhyWBD/TMXNn8toSFsC+khjY2
         I0MaiyTzCw0HpM9b6zZwEMpp4bo+sKdtlvM7Nd5EV7/mUM2Bz+39k4iVrQH7y0Y+T1WK
         pATjJyWsHFEaMi1envqUKuFmg+N+EjNFyj6eO2sqlBj4m7CJZiWAb4i3Uk/QrZ/I8cG8
         oY+g==
X-Gm-Message-State: AOAM533IExoNQxgN6B8gJ0Z8uh6kV25ot8pA6q5JoVYbagn9Sx8S1KAr
        JNy+QJFG0gfQ3jKQATBRWcfxbt7zsCpY6H7xxnM9PA+i3dK5KVxHVDk6rbQ/Mi0kKd1s+LBKi5b
        YLy3v7DUphq3uDnifE4FpZo6DdwbHOgw7TnyH7f4=
X-Received: by 2002:a5d:6701:0:b0:1e3:3ba6:d2e8 with SMTP id o1-20020a5d6701000000b001e33ba6d2e8mr12749084wru.221.1645376802721;
        Sun, 20 Feb 2022 09:06:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+T9JJCGKV5qwlPuZcr/TUyFN6JvUfkDiFzvlppDQW5HEFlxqK6x/k5fxQNEwOPo0Zx2NtKA==
X-Received: by 2002:a5d:6701:0:b0:1e3:3ba6:d2e8 with SMTP id o1-20020a5d6701000000b001e33ba6d2e8mr12749069wru.221.1645376802468;
        Sun, 20 Feb 2022 09:06:42 -0800 (PST)
Received: from [192.168.0.118] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id ba14sm25464009wrb.56.2022.02.20.09.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 09:06:41 -0800 (PST)
Message-ID: <d47a91e6-228a-38ea-fd55-8a3a61d1f63e@canonical.com>
Date:   Sun, 20 Feb 2022 18:06:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 3/8] dt-bindings: ufs: cdns,ufshc: convert to dtschema
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wei Xu <xuwei5@hisilicon.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jan Kotas <jank@cadence.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
 <20220219184224.44339-4-krzysztof.kozlowski@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220219184224.44339-4-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/02/2022 19:42, Krzysztof Kozlowski wrote:
> Convert the Cadence Universal Flash Storage (UFS) Controlle to DT schema
> format.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../devicetree/bindings/ufs/cdns,ufshc.txt    | 32 -----------
>  .../devicetree/bindings/ufs/cdns,ufshc.yaml   | 56 +++++++++++++++++++
>  2 files changed, 56 insertions(+), 32 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
>  create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> deleted file mode 100644
> index 02347b017abd..000000000000
> --- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> +++ /dev/null
> @@ -1,32 +0,0 @@
> -* Cadence Universal Flash Storage (UFS) Controller
> -
> -UFS nodes are defined to describe on-chip UFS host controllers.
> -Each UFS controller instance should have its own node.
> -Please see the ufshcd-pltfrm.txt for a list of all available properties.
> -
> -Required properties:
> -- compatible	: Compatible list, contains one of the following controllers:
> -			"cdns,ufshc" - Generic CDNS HCI,
> -			"cdns,ufshc-m31-16nm" - CDNS UFS HC + M31 16nm PHY
> -		  complemented with the JEDEC version:
> -			"jedec,ufs-2.0"
> -
> -- reg		: Address and length of the UFS register set.
> -- interrupts	: One interrupt mapping.
> -- freq-table-hz	: Clock frequency table.
> -		  See the ufshcd-pltfrm.txt for details.
> -- clocks	: List of phandle and clock specifier pairs.
> -- clock-names	: List of clock input name strings sorted in the same
> -		  order as the clocks property. "core_clk" is mandatory.
> -		  Depending on a type of a PHY,
> -		  the "phy_clk" clock can also be added, if needed.
> -
> -Example:
> -	ufs@fd030000 {
> -		compatible = "cdns,ufshc", "jedec,ufs-2.0";
> -		reg = <0xfd030000 0x10000>;
> -		interrupts = <0 1 IRQ_TYPE_LEVEL_HIGH>;
> -		freq-table-hz = <0 0>, <0 0>;
> -		clocks = <&ufs_core_clk>, <&ufs_phy_clk>;
> -		clock-names = "core_clk", "phy_clk";
> -	};
> diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
> new file mode 100644
> index 000000000000..68ae5663cd25
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/cdns,ufshc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Cadence Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Jan Kotas <jank@cadence.com>
> +

This will require a "select:" to avoid clash with qcom (and maybe other)
schemas.

Best regards,
Krzysztof
