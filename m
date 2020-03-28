Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E49C2D0EF
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 17:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076E0208E4
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 17:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5uMGh0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgC1Rqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 13:46:49 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36964 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgC1Rqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 13:46:49 -0400
Received: by mail-lj1-f196.google.com with SMTP id r24so13550253ljd.4;
        Sat, 28 Mar 2020 10:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=eK2xMlkSWwsuoup1xvKWf+yPR2CEQQ2vN7P0h9G7Y7A=;
        b=E5uMGh0+4kyqfkZTdjNe39L6qj3St9yarWA0+4O08SdZ6MTraqjXxE5EwwccSq+WQ5
         Ix6cyX8LRqGxc4EEfXWxi3UMkSakPNRv1JqJR3rKq7spWvSbEzTyqNRsKCmQ0zkoqZhp
         3zAuT0uagqpWFYZ1cb9uW/hZFGg2zB6EVnNOpbyMtmkq1jzkiv6Jz36Kkr0VJmqsofoX
         MoM4mdoIhqT19pHIsulSqLKL8na4Z8toXyJh7R0Ad8kp2ZpYabmJNVFoTRR+pr5vo0h+
         J1mnD2HT3RBLCgdhBhzawPFR/fZVqpmQhPYvoSyEEX1wWKdsWpKSYKt4I1GINukfhTN9
         abCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eK2xMlkSWwsuoup1xvKWf+yPR2CEQQ2vN7P0h9G7Y7A=;
        b=OvdTFl/Qe9jSBOlQJqpnmBscaIPshTIwZT8XLGIbK92AmI0PRK6mrr99ychpsklZcl
         tR/slDhtZ4JLG1mIyNcLCMWLRlTnqYlcnBowLuv56g2SMu6GuuWBpdSx39SmQt4PT4ln
         3lExIvgxu75QasVFmjzfW/s4XWOcReXIZYwuWqUhdvfdxT5QiDeZ4fcl9zyz0A832gSJ
         fZyiVPh6yknDP/q8btv5GMJKQDQOm88CiTDyx0lPwdovA42attKpdN70tnkJ7RuZu65T
         ldtD+84EAPKgwIUu0iL4fGSHf2t7IEfUDPTA+D3YXXiBKwcS4z54UnsyEuNWD6xinY/v
         zDHw==
X-Gm-Message-State: AGi0PuY8Ql0RjpeXmBn5G2vXJ5zcewYpvplVLhWBgHPp7jAwXdUaOl0d
        nZf2tLAHECOgNfTZPJRWycy5E6E3
X-Google-Smtp-Source: APiQypLFzEddHHaJzorgKc18UscDVl6cJm94rT1S69oiZIu+3ev0M1QL9NrUonSfP2069pj5gqclRQ==
X-Received: by 2002:a2e:8914:: with SMTP id d20mr2612659lji.148.1585417604581;
        Sat, 28 Mar 2020 10:46:44 -0700 (PDT)
Received: from pablo-laptop ([2a02:a315:5445:5300:4882:9b4e:5eda:ceec])
        by smtp.googlemail.com with ESMTPSA id i18sm4801119lfe.15.2020.03.28.10.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 10:46:43 -0700 (PDT)
Message-ID: <838a17416b4ed59903ae153e09842ac62584616f.camel@gmail.com>
Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
From:   =?UTF-8?Q?Pawe=C5=82?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 28 Mar 2020 18:46:42 +0100
In-Reply-To: <000801d60516$823fd890$86bf89b0$@samsung.com>
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
         <CGME20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a@epcas5p4.samsung.com>
         <20200327170638.17670-6-alim.akhtar@samsung.com>
         <ac67cfc3736cf50c716b823a59af878d59b7198f.camel@gmail.com>
         <000801d60516$823fd890$86bf89b0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-03-28 at 21:05 +0530, Alim Akhtar wrote:
> Hi Pawel
> 
> > -----Original Message-----
> > From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> > Sent: 28 March 2020 19:00
> > To: Alim Akhtar <alim.akhtar@samsung.com>; robh+dt@kernel.org;
> > devicetree@vger.kernel.org; linux-scsi@vger.kernel.org
> > Cc: krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> > kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> > cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
> > 
> > On Fri, 2020-03-27 at 22:36 +0530, Alim Akhtar wrote:
> > > Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> > > 
> > > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > > ---
> > >  .../boot/dts/exynos/exynos7-espresso.dts      | 16 +++++++
> > >  arch/arm64/boot/dts/exynos/exynos7.dtsi       | 43 ++++++++++++++++++-
> > >  2 files changed, 57 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > index 7af288fa9475..b59a0a32620a 100644
> > > --- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > +++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > @@ -406,6 +406,22 @@
> > >  	};
> > >  };
> > > 
> > > +&ufs {
> > > +	status = "okay";
> > > +	pinctrl-names = "default";
> > > +	pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> > > +	ufs,pwr-attr-mode = "FAST";
> > > +	ufs,pwr-attr-lane = <2>;
> > > +	ufs,pwr-attr-gear = <2>;
> > > +	ufs,pwr-attr-hs-series = "HS_rate_b";
> > > +	ufs-rx-adv-fine-gran-sup_en = <1>;
> > > +	ufs-rx-adv-fine-gran-step = <3>;
> > > +	ufs-rx-adv-min-activate-time-cap = <9>;
> > > +	ufs-pa-granularity = <6>;
> > > +	ufs-pa-tacctivate = <3>;
> > > +	ufs-pa-hibern8time = <20>;
> > > +};
> > > +
> > >  &usbdrd_phy {
> > >  	vbus-supply = <&usb30_vbus_reg>;
> > >  	vbus-boost-supply = <&usb3drd_boost_5v>; diff --git
> > > a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > index 5558045637ac..9d16c90edd07 100644
> > > --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > @@ -220,9 +220,14 @@
> > >  			#clock-cells = <1>;
> > >  			clocks = <&fin_pll>, <&clock_top1
> > DOUT_ACLK_FSYS1_200>,
> > >  				 <&clock_top1 DOUT_SCLK_MMC0>,
> > > -				 <&clock_top1 DOUT_SCLK_MMC1>;
> > > +				 <&clock_top1 DOUT_SCLK_MMC1>,
> > > +				 <&clock_top1 DOUT_SCLK_UFSUNIPRO20>,
> > > +				 <&clock_top1 DOUT_SCLK_PHY_FSYS1>,
> > > +				 <&clock_top1 DOUT_SCLK_PHY_FSYS1_26M>;
> > >  			clock-names = "fin_pll", "dout_aclk_fsys1_200",
> > > -				      "dout_sclk_mmc0", "dout_sclk_mmc1";
> > > +				      "dout_sclk_mmc0", "dout_sclk_mmc1",
> > > +				      "dout_sclk_ufsunipro20",
> > "dout_sclk_phy_fsys1",
> > > +				      "dout_sclk_phy_fsys1_26m";
> > >  		};
> > > 
> > >  		serial_0: serial@13630000 {
> > > @@ -601,6 +606,40 @@
> > >  			};
> > >  		};
> > > 
> > > +		ufs: ufs@15570000 {
> > > +			compatible = "samsung,exynos7-ufs";
> > > +			#address-cells = <1>;
> > > +			#size-cells = <1>;
> > > +			ranges;
> > > +			reg = <0x15570000 0x100>,  /* 0: HCI standard */
> > > +				<0x15570100 0x100>,  /* 1: Vendor specificed
> > */
> > > +				<0x15571000 0x200>,  /* 2: UNIPRO */
> > > +				<0x15572000 0x300>;  /* 3: UFS protector */
> > > +			reg-names = "hci", "vs_hci", "unipro", "ufsp";
> > > +			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
> > > +			clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
> > > +				<&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
> > > +			clock-names = "core_clk", "sclk_unipro_main";
> > > +			freq-table-hz = <0 0>, <0 0>;
> > > +			pclk-freq-avail-range = <70000000 133000000>;
> > > +			ufs,pwr-local-l2-timer = <8000 28000 20000>;
> > > +			ufs,pwr-remote-l2-timer = <12000 32000 16000>;
> > > +			phys = <&ufs_phy>;
> > > +			phy-names = "ufs-phy";
> > > +			status = "disabled";
> > > +		};
> > > +
> > > +		ufs_phy: ufs-phy@0x15571800 {
> > > +			compatible = "samsung,exynos7-ufs-phy";
> > > +			reg = <0x15571800 0x240>;
> > > +			reg-names = "phy-pma";
> > > +			samsung,pmu-syscon = <&pmu_system_controller>;
> > > +			#phy-cells = <0>;
> > > +			clocks = <&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
> > > +				<&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
> > > +			clock-names = "ref_clk_parent", "ref_clk";
> > Hi
> > Is this correct (aren't child and parent clock swapped)?
> > This will set MOUT_FSYS1_PHYCLK_SEL1 to be parent clock of
> > CLK_SCLK_PHY_FSYS1_26M.
> 
> Looks like in one of my rebase it got swap, will correct it.  Thanks for pointing out.
> 
> > I've tested this on Exynos7420 (which looks like can use the same clock driver as
> > exynos7) and after adding some debug code (because currently we're not
> > handling result of samsung_ufs_phy_clks_init) i got
> > 
> > samsung-ufs-phy 15571800.ufs-phy: clk_set_parent result: -22
> > 
> I will check if I overlooked this error.
> > On vendor sources for this device, driver was setting CLK_SCLK_PHY_FSYS1_26M
> > to be parent of MOUT_FSYS1_PHYCLK_SEL1, and then it did run without error.
> > 
> > samsung-ufs-phy 15571800.ufs-phy: clk_set_parent result: 0
> > 
> With this change, does linkup worked for you?
Hi
Sadly not yet, so someone needs to check it on different hw.

I've added some debug code to ufshcd and it looks like it fails (in my
case) at ufshcd_dme_link_startup which returns 1 (because
ufshcd_wait_for_uic_cmd returns 1). The same for second retry and at
third retry it's getting -110 from ufshcd_wait_for_uic_cmd.

Need to check:
- in vendor there was 10 clocks used by ufs/ufs-phy (where this driver
uses 4)
- if calibration is the same in this driver vs vendor

Maybe it's because of missing EXYNOS FMP Driver (my device has
secureos) and/or some missing smc calls (like in case of smu config)?
> 
> > Also looking at clk-exynos7 driver seems to confirm this.
> > 
> > > +		};
> > > +
> > >  		usbdrd_phy: phy@15500000 {
> > >  			compatible = "samsung,exynos7-usbdrd-phy";
> > >  			reg = <0x15500000 0x100>;
> 
> 

