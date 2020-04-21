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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF09C54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A812070B
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:57:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoQpa52k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgDUQ5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 12:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729626AbgDUQ46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 12:56:58 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941D7C061A41;
        Tue, 21 Apr 2020 09:56:58 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id v24so5331446uak.0;
        Tue, 21 Apr 2020 09:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+roaZY0aQq5IerWYrtAtqtTIyLi3/oukkignYdqQ2gM=;
        b=OoQpa52k6Fd4P7opyBenigG8zgeRF6Am+UbnctENdxTHpjt3uX/wsSqtr+hw2usoNW
         +wzlwcoFKjhAphlxohZZ7wpwF5Qrc9fV8XHooELQipt2XAUOhINX8t+af9K/NAe/1ouI
         9B5rYdBhepuERj8H1W00szQjqhiZ71Zijh3deNhrAUcIYTzkpt3TrImmmRojGpU7e4I5
         dlqQFXd3nIKJ1xY2u/LfU+WMZ3ldnJh6TD+T0KVTo0n8k6aPAK9y7J8ulWGGHuYr6+/U
         +AeUSSRpOYhzyNyrNpH11Hnjn80OeP68bBoIu46OSmWBeuBfK0PCUDwO6ffn01bzJe6L
         Z6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+roaZY0aQq5IerWYrtAtqtTIyLi3/oukkignYdqQ2gM=;
        b=ZMHPaVMc0e54MdxNEz/TU58/sgorpLt0Umfqmfnc7GMvJst+Kz7bFnydjn+f02zXhh
         polU8T7NuUOyIlK1VXmrMFTJKrANbMue+VDI5WjFgMsshZvee2YMGHy14GRTeb/Kptmj
         qxz+6seBgK/yauFNegb7vZpRIJYQ3PMI4ek1/FENCLrlhebNQ6c6q5ebVASSUP/SPIlA
         nS7EYXPgeYDc/dE7ITxu+ak0oTDByfJ9LcUMKPQNRaj4Gs/K9OlVMtcYF1URofKD3fT8
         6h6d3Y3p4C0d/YXyqb7myqWJkDAYSgDVMgNHlJq9pvnk0bY2jnDG5QqnnozSZFYKmqzr
         uEJw==
X-Gm-Message-State: AGi0Pua2E7QoLUScFQvx6vdM4/UELyE6aY8HINm9HZy7RwU0Srx2Z4EO
        63kTv8KXcskxT6Mt7gGQGxPFH+PEhDmL3fEDa7o=
X-Google-Smtp-Source: APiQypIpbVZ62pOPQuT8rk9YlJ0othDRtz8/TGgGxaOQSXcQd4x9m2DNm9aXz3E3Sig+Sy4/vsuBK0ISisEBtxdsnGY=
X-Received: by 2002:ab0:7298:: with SMTP id w24mr13269756uao.95.1587488217689;
 Tue, 21 Apr 2020 09:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200417181022epcas5p1f83138da6e76ff0917de88e913ef8e32@epcas5p1.samsung.com>
 <20200417175944.47189-1-alim.akhtar@samsung.com> <20200417175944.47189-9-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-9-alim.akhtar@samsung.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 21 Apr 2020 22:26:21 +0530
Message-ID: <CAGOxZ52mQ=H5DR7nWJY3RMBuJMr9SXERukJs1UK_Wr1XHP9TZg@mail.gmail.com>
Subject: Re: [PATCH v6 08/10] dt-bindings: ufs: Add DT binding documentation
 for ufs
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
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob
Request to comment on this dt-bindings documentation.
Thanks

On Fri, Apr 17, 2020 at 11:41 PM Alim Akhtar <alim.akhtar@samsung.com> wrote:
>
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
> +
> +  phys:
> +    maxItems: 1
> +    description:
> +      phandle of the ufs phy node
> +
> +  phy-names:
> +      const: ufs-phy
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


-- 
Regards,
Alim
