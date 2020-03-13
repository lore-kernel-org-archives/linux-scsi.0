Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A51CC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1235220751
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584090340;
	bh=qUbZKtX97cEhrvKQ3iwiRmWM07v4T5YgfJBvRHHdX4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xTblBdiECoG+Sp4qPU0aAG0EkVCNeQNA3Tz+T3QFtKNpjGfPG4KdBI5DR534wmoTD
	 T9/HOLSE1YyjZO9jBCndeMvN+weeVejMhyrk5/4fidwrSVg+of6lhhipyKKqK5Q7f4
	 XXjhIoxSsCIsR5VfJ43wFl6CSTfzcYi4Go+62JeI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCMJFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:05:39 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38001 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCMJFj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 05:05:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id h5so11004702edn.5;
        Fri, 13 Mar 2020 02:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g2JDRt2yUCaKJR+LJgonz8WYOGVSR0jklbXODmQG85o=;
        b=gNbtj6e6xB484Vw+FCUMcu+ukXx6jeQLCAjpRFWCU/6jz2tv0Hwe35DRCNiWL2Meww
         YyYehoP655MIMsjYulSoj9GJFSjl12TYp4TXva7Cz6tAxLGTCdgcTudBiCNQ+j0gzJ1k
         ilzQHcJyD5LAPkd1LwYA0avLUmn8RIzfwid1KKBxD9q5kjRin4weoo9Ve/u456++ehSQ
         vs5DS8hH2FynwDylHC8ZN5bwtjHp0AQGP2Sbw2VBvLwqTWFSXM5TuwFbhfmwMhfyCW/s
         wzuh/vUm/qQN7AL3SyTtl6T08h4x5rcSibOMr6uknLnJ8x8gE2nsaikVHBBR6G3/i76q
         /ceA==
X-Gm-Message-State: ANhLgQ0A2HbMIeTb7XPj4KZVOMZQLjJf0DX8CD5o1NeTAOBxIjC0BWYx
        o/GZYN6dt9vrWa6hknP991k=
X-Google-Smtp-Source: ADFU+vv9kZJ9NcTtH+qwonxAqQU7Lfq9PDb93XF2tGG3Pb8J2fKMcq9pPUdVYy0XX1/6H5ZFybDd/g==
X-Received: by 2002:a17:906:34db:: with SMTP id h27mr10252423ejb.111.1584090336754;
        Fri, 13 Mar 2020 02:05:36 -0700 (PDT)
Received: from pi3 ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id l9sm1149281edt.93.2020.03.13.02.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 02:05:36 -0700 (PDT)
Date:   Fri, 13 Mar 2020 10:05:34 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org
Subject: Re: [PATCH 5/5] arm64: dts: Add node for ufs exynos7
Message-ID: <20200313090534.GC7416@pi3>
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
 <CGME20200306151028epcas5p25ec9ccacedf49fa47ebb94bcdff42c54@epcas5p2.samsung.com>
 <20200306150529.3370-6-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200306150529.3370-6-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 06, 2020 at 08:35:29PM +0530, Alim Akhtar wrote:
> Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../boot/dts/exynos/exynos7-espresso.dts      | 16 ++++++
>  arch/arm64/boot/dts/exynos/exynos7.dtsi       | 56 ++++++++++++++++++-
>  2 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> index 7af288fa9475..dee5a3ae7de3 100644
> --- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> +++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> @@ -410,3 +410,19 @@
>  	vbus-supply = <&usb30_vbus_reg>;
>  	vbus-boost-supply = <&usb3drd_boost_5v>;
>  };
> +
> +&ufs {

Let's keep it in alphabetical order, so before usbdrd_phy.

> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> +	ufs,pwr-attr-mode = "FAST";
> +	ufs,pwr-attr-lane = <2>;
> +	ufs,pwr-attr-gear = <2>;
> +	ufs,pwr-attr-hs-series = "HS_rate_b";
> +	ufs-rx-adv-fine-gran-sup_en = <1>;
> +	ufs-rx-adv-fine-gran-step = <3>;
> +	ufs-rx-adv-min-activate-time-cap = <9>;
> +	ufs-pa-granularity = <6>;
> +	ufs-pa-tacctivate = <3>;
> +	ufs-pa-hibern8time = <20>;
> +};
> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> index 5558045637ac..3edf63d18873 100644
> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> @@ -220,9 +220,14 @@
>  			#clock-cells = <1>;
>  			clocks = <&fin_pll>, <&clock_top1 DOUT_ACLK_FSYS1_200>,
>  				 <&clock_top1 DOUT_SCLK_MMC0>,
> -				 <&clock_top1 DOUT_SCLK_MMC1>;
> +				 <&clock_top1 DOUT_SCLK_MMC1>,
> +				 <&clock_top1 DOUT_SCLK_UFSUNIPRO20>,
> +				 <&clock_top1 DOUT_SCLK_PHY_FSYS1>,
> +				 <&clock_top1 DOUT_SCLK_PHY_FSYS1_26M>;
>  			clock-names = "fin_pll", "dout_aclk_fsys1_200",
> -				      "dout_sclk_mmc0", "dout_sclk_mmc1";
> +				      "dout_sclk_mmc0", "dout_sclk_mmc1",
> +				      "dout_sclk_ufsunipro20", "dout_sclk_phy_fsys1",
> +				      "dout_sclk_phy_fsys1_26m";
>  		};
>  
>  		serial_0: serial@13630000 {
> @@ -634,6 +639,53 @@
>  				phy-names = "usb2-phy", "usb3-phy";
>  			};
>  		};
> +
> +		ufs: ufs@15570000 {
> +			compatible ="samsung,exynos7-ufs";

Space after =.

> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			reg =

No new line after =

> +				<0x15570000 0x100>,  /* 0: HCI standard */
> +				<0x15570100 0x100>,  /* 1: Vendor specificed */
> +				<0x15571000 0x200>,  /* 2: UNIPRO */
> +				<0x15572000 0x300>;  /* 3: UFS protector */
> +			reg-names = "hci", "vs_hci", "unipro", "ufsp";
> +			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =
> +				/* core clock */

Ditto here and further, no new liine after =

Rest looks good. I will need DT's ack on bindings before I will take the
DTS to samsung-soc.

Best regards,
Krzysztof

> +				<&clock_fsys1 ACLK_UFS20_LINK>,
> +				/* unipro clocks */
> +				<&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
> +			clock-names =
> +				/* core clocks */
> +				"core_clk",
> +				/* unipro clocks */
> +				"sclk_unipro_main";
> +			freq-table-hz = <0 0>, <0 0>;
> +			pclk-freq-avail-range = <70000000 133000000>;
> +			ufs,pwr-local-l2-timer = <8000 28000 20000>;
> +			ufs,pwr-remote-l2-timer = <12000 32000 16000>;
> +			phys = <&ufs_phy>;
> +			phy-names = "ufs-phy";
> +			status = "disabled";
> +		};
> +
> +		ufs_phy: ufs-phy@0x15571800 {
> +			compatible = "samsung,exynos7-ufs-phy";
> +			reg = <0x15571800 0x240>;
> +			reg-names = "phy-pma";
> +			samsung,pmu-syscon = <&pmu_system_controller>;
> +			#phy-cells = <0>;
> +			clocks =
> +				/* refclk clocks */
> +				<&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
> +				<&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
> +			clock-names =
> +				/* refclk clocks */
> +				"ref_clk_parent",
> +				"ref_clk";
> +		};
>  	};
>  
>  	timer {
> -- 
> 2.17.1
> 
