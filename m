Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5257AC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 16:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18C462073B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 16:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oa3ujD0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404446AbgDCQwT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 12:52:19 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38768 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404148AbgDCQwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 12:52:19 -0400
Received: by mail-lf1-f68.google.com with SMTP id c5so6388797lfp.5;
        Fri, 03 Apr 2020 09:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4sdtu+9UWvjIPnQzAP5v2KXps/S8fgVtv1WbMqqNn5Q=;
        b=oa3ujD0Xfh/e2z0KHjmhm6xQWIB0jC393ouHIJwoDIuGWcQaM7iJoU02JA0CpT6EpY
         0cA74VECPnMU9ZtpJXU36CJLoEr53pcx7GOxKsOiQUtDeIE0a0m438n3BlvcdRWfvvRd
         tmd1SuaBfs3E/pLtsOKN0tFpPZV87j+/3XYs1F4xpVELS4C7YiOpdcMpDe9rwtj61pB5
         mKtkvPPpFL4nOvHEkgEiCj3u3NkfnoWjUmjnFf64ZjOakgFNphQBbGRbTyo7QyKv8/zY
         nFuwRSVEHnNhlvGElMZySGPIXn8kWXN/sW7bwzibovdtCKb05yQ6dsWtATrg1FmLa6i+
         a48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4sdtu+9UWvjIPnQzAP5v2KXps/S8fgVtv1WbMqqNn5Q=;
        b=ORrEV1Kkmx8ZDSrdDI5p3bZjRJyYBREbOzumXpuYMBC9olXkPtpUe59RtIsmqv3ay3
         azKV9cX7swrJenQ3t/gf388PzEiTNssaGTdEfDU9X8oZ67BUppboFKqH0Ua0+CuGmAeX
         cNAgDlbztgTVODcjRj1jXKKaAfHt8XW8M++UlHNAglNDrG9NOfs1VeXvx8Z+gP4bzKr8
         t0xfPvktA2CGpBsxTcnbd7IjC6jWhmiPcGYGvXY7niyeEHdFju9ot1BmriIxukbr24dw
         jEmu8/0zjzL8v/n5t2464k3SQZ1Lwoc5QfqdXbO8YpWnpUxSwbF1l2zPCIxz04OTtHXM
         qI3g==
X-Gm-Message-State: AGi0PubhcTvDjEUHy1ZL+l5AqUK6vbhaiNbn+VGCsZPab57ozo/uqJ5m
        ombMyZDHN5SirT02lfUAkuk=
X-Google-Smtp-Source: APiQypLUggKajdIL7zWjFvOHfSpEBUY1Ad4tTQHIxBBcmbE5zFZwgA63olE+pNGMDgECyI/qnfG20A==
X-Received: by 2002:ac2:559c:: with SMTP id v28mr5689428lfg.148.1585932735678;
        Fri, 03 Apr 2020 09:52:15 -0700 (PDT)
Received: from pablo-laptop ([2a02:a315:5445:5300:1dba:1edf:b69:f4bd])
        by smtp.googlemail.com with ESMTPSA id w12sm5262135lji.14.2020.04.03.09.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:52:15 -0700 (PDT)
Message-ID: <1182150aff8140a82af17979a09c81676c719e2f.camel@gmail.com>
Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
From:   =?UTF-8?Q?Pawe=C5=82?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 03 Apr 2020 18:52:13 +0200
In-Reply-To: <002e01d605df$af658440$0e308cc0$@samsung.com>
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
         <CGME20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a@epcas5p4.samsung.com>
         <20200327170638.17670-6-alim.akhtar@samsung.com>
         <ac67cfc3736cf50c716b823a59af878d59b7198f.camel@gmail.com>
         <000801d60516$823fd890$86bf89b0$@samsung.com>
         <838a17416b4ed59903ae153e09842ac62584616f.camel@gmail.com>
         <002e01d605df$af658440$0e308cc0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-03-29 at 21:05 +0530, Alim Akhtar wrote:
> Hi Pawel
> 
> > -----Original Message-----
> > From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> > Sent: 28 March 2020 23:17
> > To: Alim Akhtar <alim.akhtar@samsung.com>; robh+dt@kernel.org;
> > devicetree@vger.kernel.org; linux-scsi@vger.kernel.org
> > Cc: krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> > kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> > cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
> > 
> > On Sat, 2020-03-28 at 21:05 +0530, Alim Akhtar wrote:
> > > Hi Pawel
> > > 
> > > > -----Original Message-----
> > > > From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> > > > Sent: 28 March 2020 19:00
> > > > To: Alim Akhtar <alim.akhtar@samsung.com>; robh+dt@kernel.org;
> > > > devicetree@vger.kernel.org; linux-scsi@vger.kernel.org
> > > > Cc: krzk@kernel.org; avri.altman@wdc.com;
> > > > martin.petersen@oracle.com; kwmad.kim@samsung.com;
> > > > stanley.chu@mediatek.com; cang@codeaurora.org;
> > > > linux-samsung-soc@vger.kernel.org; linux-arm-
> > > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
> > > > 
> > > > On Fri, 2020-03-27 at 22:36 +0530, Alim Akhtar wrote:
> > > > > Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> > > > > 
> > > > > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > > > > ---
> > > > >  .../boot/dts/exynos/exynos7-espresso.dts      | 16 +++++++
> > > > >  arch/arm64/boot/dts/exynos/exynos7.dtsi       | 43 ++++++++++++++++++-
> > > > >  2 files changed, 57 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > > > b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > > > index 7af288fa9475..b59a0a32620a 100644
> > > > > --- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > > > +++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
> > > > > @@ -406,6 +406,22 @@
> > > > >  	};
> > > > >  };
> > > > > 
> > > > > +&ufs {
> > > > > +	status = "okay";
> > > > > +	pinctrl-names = "default";
> > > > > +	pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> > > > > +	ufs,pwr-attr-mode = "FAST";
> > > > > +	ufs,pwr-attr-lane = <2>;
> > > > > +	ufs,pwr-attr-gear = <2>;
> > > > > +	ufs,pwr-attr-hs-series = "HS_rate_b";
> > > > > +	ufs-rx-adv-fine-gran-sup_en = <1>;
> > > > > +	ufs-rx-adv-fine-gran-step = <3>;
> > > > > +	ufs-rx-adv-min-activate-time-cap = <9>;
> > > > > +	ufs-pa-granularity = <6>;
> > > > > +	ufs-pa-tacctivate = <3>;
> > > > > +	ufs-pa-hibern8time = <20>;
> > > > > +};
> > > > > +
> > > > >  &usbdrd_phy {
> > > > >  	vbus-supply = <&usb30_vbus_reg>;
> > > > >  	vbus-boost-supply = <&usb3drd_boost_5v>; diff --git
> > > > > a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > > > b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > > > index 5558045637ac..9d16c90edd07 100644
> > > > > --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > > > +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> > > > > @@ -220,9 +220,14 @@
> > > > >  			#clock-cells = <1>;
> > > > >  			clocks = <&fin_pll>, <&clock_top1
> > > > DOUT_ACLK_FSYS1_200>,
> > > > >  				 <&clock_top1 DOUT_SCLK_MMC0>,
> > > > > -				 <&clock_top1 DOUT_SCLK_MMC1>;
> > > > > +				 <&clock_top1 DOUT_SCLK_MMC1>,
> > > > > +				 <&clock_top1 DOUT_SCLK_UFSUNIPRO20>,
> > > > > +				 <&clock_top1 DOUT_SCLK_PHY_FSYS1>,
> > > > > +				 <&clock_top1 DOUT_SCLK_PHY_FSYS1_26M>;
> > > > >  			clock-names = "fin_pll", "dout_aclk_fsys1_200",
> > > > > -				      "dout_sclk_mmc0", "dout_sclk_mmc1";
> > > > > +				      "dout_sclk_mmc0", "dout_sclk_mmc1",
> > > > > +				      "dout_sclk_ufsunipro20",
> > > > "dout_sclk_phy_fsys1",
> > > > > +				      "dout_sclk_phy_fsys1_26m";
> > > > >  		};
> > > > > 
> > > > >  		serial_0: serial@13630000 {
> > > > > @@ -601,6 +606,40 @@
> > > > >  			};
> > > > >  		};
> > > > > 
> > > > > +		ufs: ufs@15570000 {
> > > > > +			compatible = "samsung,exynos7-ufs";
> > > > > +			#address-cells = <1>;
> > > > > +			#size-cells = <1>;
> > > > > +			ranges;
> > > > > +			reg = <0x15570000 0x100>,  /* 0: HCI standard */
> > > > > +				<0x15570100 0x100>,  /* 1: Vendor specificed
> > > > */
> > > > > +				<0x15571000 0x200>,  /* 2: UNIPRO */
> > > > > +				<0x15572000 0x300>;  /* 3: UFS protector */
> > > > > +			reg-names = "hci", "vs_hci", "unipro", "ufsp";
> > > > > +			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
> > > > > +			clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
> > > > > +				<&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
> > > > > +			clock-names = "core_clk", "sclk_unipro_main";
> > > > > +			freq-table-hz = <0 0>, <0 0>;
> > > > > +			pclk-freq-avail-range = <70000000 133000000>;
> > > > > +			ufs,pwr-local-l2-timer = <8000 28000 20000>;
> > > > > +			ufs,pwr-remote-l2-timer = <12000 32000 16000>;
> > > > > +			phys = <&ufs_phy>;
> > > > > +			phy-names = "ufs-phy";
> > > > > +			status = "disabled";
> > > > > +		};
> > > > > +
> > > > > +		ufs_phy: ufs-phy@0x15571800 {
> > > > > +			compatible = "samsung,exynos7-ufs-phy";
> > > > > +			reg = <0x15571800 0x240>;
> > > > > +			reg-names = "phy-pma";
> > > > > +			samsung,pmu-syscon = <&pmu_system_controller>;
> > > > > +			#phy-cells = <0>;
> > > > > +			clocks = <&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
> > > > > +				<&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
> > > > > +			clock-names = "ref_clk_parent", "ref_clk";
> > > > Hi
> > > > Is this correct (aren't child and parent clock swapped)?
> > > > This will set MOUT_FSYS1_PHYCLK_SEL1 to be parent clock of
> > > > CLK_SCLK_PHY_FSYS1_26M.
> > > 
> > > Looks like in one of my rebase it got swap, will correct it.  Thanks for pointing
> > out.
> > > > I've tested this on Exynos7420 (which looks like can use the same
> > > > clock driver as
> > > > exynos7) and after adding some debug code (because currently we're
> > > > not handling result of samsung_ufs_phy_clks_init) i got
> > > > 
> > > > samsung-ufs-phy 15571800.ufs-phy: clk_set_parent result: -22
> > > > 
> > > I will check if I overlooked this error.
> > > > On vendor sources for this device, driver was setting
> > > > CLK_SCLK_PHY_FSYS1_26M to be parent of MOUT_FSYS1_PHYCLK_SEL1,
> > and then it did run without error.
> > > > samsung-ufs-phy 15571800.ufs-phy: clk_set_parent result: 0
> > > > 
> > > With this change, does linkup worked for you?
> > Hi
> > Sadly not yet, so someone needs to check it on different hw.
> > 
> > I've added some debug code to ufshcd and it looks like it fails (in my
> > case) at ufshcd_dme_link_startup which returns 1 (because
> > ufshcd_wait_for_uic_cmd returns 1). The same for second retry and at third
> > retry it's getting -110 from ufshcd_wait_for_uic_cmd.
> > 
> Mostly device is not responding to any UIC commands.
> 
> > Need to check:
> > - in vendor there was 10 clocks used by ufs/ufs-phy (where this driver uses 4)
> > - if calibration is the same in this driver vs vendor
> > 
> All clocks are not mandatory, what I have mentioned is only UFS HCI core clock, unipro clock and MPHY clocks.
> 
> > Maybe it's because of missing EXYNOS FMP Driver (my device has
> > secureos) and/or some missing smc calls (like in case of smu config)?
> FMP will come into picture a little later, it does not affect _link_startup though.
> SMU does matter, so make sure SMU is by passed initially.
> 
> Another think that comes into my mind is, if possible just disabled PMIC (intension is to keep all the rails __always_on__)
> The reason is sometime UFS_RST_N which is hooked to RESET_N of the UFS device is also controlled via one of the PMIC LDO.
> (In your case I don't know which LDO, so keep all the rails always ON).
> Also cross check if you have these gpios configured properly.
> pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> Give it a try.
Hi Alim

Looking at vendor sources, my device is using the same gpios for
urfs_rst_n and ufs_refclk_out like Espresso (with one difference -
ufs_rst_n shouldn't be pulled up).

About regulators (it would be easier if dts would have all regulators).
It's also using s2mps15 as Espresso, but it vendor dts had only 8 (of
10 possible bucks, one missing was for UFS) and 14 ldos (of 27
possible), where almost all rails are connected to something.

I'm wondering how it's working on Espresso, because when adding correct
regulators for ufs (vccq = buck10 from s2mps15, always enabled for
testing plus vccq2 and vccq = two regulators enabled by one gpio,
enabled at boot by firmware), ufs wasn't still working because it was
then failing at defer probe (s2mps15 was probed after ufs)

[    0.962482] exynos-ufshc 15570000.ufs: ufshcd_get_vreg: vccq get
failed, err=-517

After that boot would just stop/hang.

After making a "dirty fix" by making s2mps15 regulator driver use
subsys_initcall (like in vendor sources) and ufs late_initcall (to give
it more time to setup and get it working and solve it later),
i had to mark following clocks as CLK_IGNORE_UNUSED to be able to bring
link up (it replicates setting done by vendor kernel, which enables
them on boot):
- "phyclk_ufs20_rx1_symbol_user"
- "phyclk_ufs20_rx0_symbol_user"
- "phyclk_ufs20_tx0_symbol_user"

Now it's able to bring both device and link, but it fails at
ufshcd_uic_change_pwr_mode.

[    1.411547] exynos-ufshc 15570000.ufs: ufshcd_init_clocks: clk:
core_clk, rate: 100000000
[    1.419698] exynos-ufshc 15570000.ufs: ufshcd_init_clocks: clk:
sclk_unipro_main, rate: 167000000
[    1.428550] exynos-ufshc 15570000.ufs: __ufshcd_setup_clocks: clk:
core_clk enabled
[    1.436200] exynos-ufshc 15570000.ufs: __ufshcd_setup_clocks: clk:
sclk_unipro_main enabled
[    1.445704] scsi host0: ufshcd
[    1.465684] exynos-ufshc 15570000.ufs: ufshcd_print_pwr_info:[RX,
TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate =
0
[    2.023699] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd041 val
0x1fff error code 1
[    2.023846] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd041 val
0x1fff failed 0 retries
[    2.024025] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd042 val
0xffff error code 1
[    2.025457] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd042 val
0xffff failed 0 retries
[    2.033777] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd043 val
0x7fff error code 1
[    2.041607] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd043 val
0x7fff failed 0 retries
[    2.067809] exynos-ufshc 15570000.ufs: pwr ctrl cmd 0x2 failed, host
upmcrs:0x5
[    2.067953] exynos-ufshc 15570000.ufs: UFS Host state=0
[    2.068056] exynos-ufshc 15570000.ufs: outstanding reqs=0x0
tasks=0x0
[    2.068759] exynos-ufshc 15570000.ufs: saved_err=0x0,
saved_uic_err=0x0
[    2.075368] exynos-ufshc 15570000.ufs: Device power mode=1, UIC link
state=1
[    2.082392] exynos-ufshc 15570000.ufs: PM in progress=0, sys.
suspended=0
[    2.089158] exynos-ufshc 15570000.ufs: Auto BKOPS=0, Host self-
block=0
[    2.095667] exynos-ufshc 15570000.ufs: Clk gate=1
[    2.100354] exynos-ufshc 15570000.ufs: error handling flags=0x0,
req. abort count=0
[    2.107987] exynos-ufshc 15570000.ufs: Host capabilities=0x383ff0f,
caps=0x0
[    2.115018] exynos-ufshc 15570000.ufs: quirks=0x780, dev.
quirks=0xc4
[    2.121443] exynos-ufshc 15570000.ufs: ufshcd_print_pwr_info:[RX,
TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate =
0
[    2.133960] host_regs: 00000000: 0383ff0f 00000000 00000200 00000000
[    2.140268] host_regs: 00000010: 00000101 00007fce 00000000 00000000
[    2.146604] host_regs: 00000020: 00000000 00030a75 00000000 00000000
[    2.152940] host_regs: 00000030: 0000050f 00000000 80000010 00000000
[    2.159271] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    2.165609] host_regs: 00000050: f9587000 00000000 00000000 00000000
[    2.171944] host_regs: 00000060: 00000001 00000000 00000000 00000000
[    2.178278] host_regs: 00000070: f958a000 00000000 00000000 00000000
[    2.184609] host_regs: 00000080: 00000001 00000000 00000000 00000000
[    2.190945] host_regs: 00000090: 00000002 15710000 00000000 00000000
[    2.197282] exynos-ufshc 15570000.ufs: hba->ufs_version = 0x200,
hba->capabilities = 0x383ff0f
[    2.205869] exynos-ufshc 15570000.ufs: hba->outstanding_reqs = 0x0,
hba->outstanding_tasks = 0x0
[    2.214636] exynos-ufshc 15570000.ufs: last_hibern8_exit_tstamp at 0
us, hibern8_exit_cnt = 0
[    2.223141] exynos-ufshc 15570000.ufs: No record of pa_err
[    2.228606] exynos-ufshc 15570000.ufs: No record of dl_err
[    2.234071] exynos-ufshc 15570000.ufs: No record of nl_err
[    2.239540] exynos-ufshc 15570000.ufs: No record of tl_err
[    2.245007] exynos-ufshc 15570000.ufs: No record of dme_err
[    2.250558] exynos-ufshc 15570000.ufs: No record of auto_hibern8_err
[    2.256895] exynos-ufshc 15570000.ufs: No record of fatal_err
[    2.262624] exynos-ufshc 15570000.ufs: No record of
link_startup_fail
[    2.269044] exynos-ufshc 15570000.ufs: No record of resume_fail
[    2.274942] exynos-ufshc 15570000.ufs: No record of suspend_fail
[    2.280931] exynos-ufshc 15570000.ufs: No record of dev_reset
[    2.286659] exynos-ufshc 15570000.ufs: No record of host_reset
[    2.292475] exynos-ufshc 15570000.ufs: No record of task_abort
[    2.298290] exynos-ufshc 15570000.ufs: ufshcd_change_power_mode:
power mode change failed 5
[    2.306619] exynos-ufshc 15570000.ufs: ufshcd_probe_hba: Failed
setting power mode, err = 5
[    2.315144] exynos-ufshc 15570000.ufs: __ufshcd_setup_clocks: clk:
core_clk disabled

And here boot would just stop/hang.

Thanks for all hints.

> 
> 
> > > > Also looking at clk-exynos7 driver seems to confirm this.
> > > > 
> > > > > +		};
> > > > > +
> > > > >  		usbdrd_phy: phy@15500000 {
> > > > >  			compatible = "samsung,exynos7-usbdrd-phy";
> > > > >  			reg = <0x15500000 0x100>;
> 
> 

