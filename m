Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3F0C47254
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 15:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D9662078D
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588694335;
	bh=o2LIzcxlJsMgZzkTqZWy8q3OSALQlFIbn9KvjloiHVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=es2aJTIncxSFXqfcSBCnyZDMwCMrGG6JXBHLrE780IjKkIaY3sDs1lV/KevNeZWO2
	 dV2hKhYTw3IFtslUDUXGj91ZLhG149daZ95wEospG9b0N7U/4Tb9F21HN36ZMUOA0Y
	 dGwCtmhjZfcBER8h+PZPcyv92QuKRcqUJGo/hPT0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgEEP6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 11:58:51 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43782 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbgEEP6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2020 11:58:50 -0400
Received: by mail-ot1-f65.google.com with SMTP id g14so2044533otg.10;
        Tue, 05 May 2020 08:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C4mPz/AyaPVad8cEUAI9z6a1p2b2WhQ+aPmzaXcvCIw=;
        b=eCMjjYshLP6SPXtLVrqTDtQNDFi82YoCHSHNgZUehy11IzJN+pGNtwxsVL7L9L1pNy
         aA1lX3CMwUVNADwROzP2Y72blCjyaV8BPtEj9Gnl6xLJnTxDTo6Fb3/hzXzQNgHvDlcU
         W60DUXbTWmisZ1oYUyEAAdhmdRQcc7RWyKvOpDAFC+s9vtSR38yPhfVP+QwSQXk7QPfG
         eNwRf8V+kVIGDW13Zenjg05W1eSGD7wB8u4Jm+C4XZndFPm1WIDGFVeNalTQKjW42gFi
         rECvxtB4+FY6uV83lLBVeGwHesMoKN6VhTi6NOmq22Wb+vYB1RIxzVm6Bo+LIb7+vHEu
         ZMzQ==
X-Gm-Message-State: AGi0Puan6RVhNQYhXlfR4R3kQoc9kWL+7f9NkpcTFzeAIajGZQqe9rjK
        HVuyr2UZ2Gbbfu9Lz4HwsQ==
X-Google-Smtp-Source: APiQypLHsZTLt/aKBMC4QCDg85LU7bi2M/1CCJwS+nndEH4aqg7dBPb/xUhAfI63wXxh4ar1wMmnnw==
X-Received: by 2002:a05:6830:3112:: with SMTP id b18mr2596278ots.97.1588694328410;
        Tue, 05 May 2020 08:58:48 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l37sm687951ota.68.2020.05.05.08.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 08:58:47 -0700 (PDT)
Received: (nullmailer pid 31936 invoked by uid 1000);
        Tue, 05 May 2020 15:58:46 -0000
Date:   Tue, 5 May 2020 10:58:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 08/10] dt-bindings: ufs: Add DT binding documentation
 for ufs
Message-ID: <20200505155846.GA28360@bogus>
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
 <CGME20200426174219epcas5p460c8637629afd930313ae0fa936593cd@epcas5p4.samsung.com>
 <20200426173024.63069-9-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426173024.63069-9-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 26, 2020 at 11:00:22PM +0530, Alim Akhtar wrote:
> This patch adds DT binding for samsung ufs hci
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/ufs/samsung,exynos-ufs.yaml      | 93 +++++++++++++++++++
>  1 file changed, 93 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> new file mode 100644
> index 000000000000..954338b7f37d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -0,0 +1,93 @@
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
> +    maxItems: 2
> +    items:
> +      - description: ufs link core clock
> +      - description: unipro main clock
> +
> +  clock-names:
> +    maxItems: 2
> +    items:
> +      - const: core_clk
> +      - const: sclk_unipro_main
> +
> +  interrupts:
> +    items:
> +      - description: interrupt signal for various ufshc status

Just 'maxItems: 1' is fine for single item cases.

> +
> +  phys:
> +    maxItems: 1
> +    description:
> +      phandle of the ufs phy node

Can drop description.

> +
> +  phy-names:
> +      const: ufs-phy

Not much point to a name when only 1 entry.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phys
> +  - phy-names
> +  - clocks
> +  - clock-names

additionalProperties: false

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
> +       pclk-freq-avail-range = <70000000 133000000>;
> +       phys = <&ufs_phy>;
> +       phy-names = "ufs-phy";
> +    };
> +...
> -- 
> 2.17.1
> 
