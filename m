Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02F8C2BA1A
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 08:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D88320780
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 08:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1ID+gkX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDEILL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 04:11:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37796 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgDEILK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 04:11:10 -0400
Received: by mail-lf1-f68.google.com with SMTP id t11so9233565lfe.4;
        Sun, 05 Apr 2020 01:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oNb5v/JEVQtuTn+Z8yj4a1y6rZZiHkDPS2eZvhDzEcU=;
        b=l1ID+gkXoXk8kEwhxh/5AqNOJ+yVC3Z1bUgzRb9A0ZPfGWpAZ+lMP0rNiiXdUv0CGP
         UM8Iv0ZX7UaZFmvsqvs9+HHx0yRxWfLMPolL+Iqhwo6i+OuQYZo/jvt8Hip3cRCCXZr+
         kHGuTpG9oAcHNsnlAN3qxLzKhobyY7nNfZpxeZ7awsFi3H1K/03+1aK2E2WOMo9GTsS1
         nmWuTrzfVZa2yFjFg5mGdO7skz9jCBiL5VlES0zYH8oLvgJtZAi7iBWMOWGRwWrm9T98
         UHxoBbs9uQVSwXKEyvWj46wn5/IvFCBxwrjj+kkHXzSoZ1EzGwCmN4xswmdjQXK+AWAx
         NGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oNb5v/JEVQtuTn+Z8yj4a1y6rZZiHkDPS2eZvhDzEcU=;
        b=iWlUh8Cf7drHMnHoOW0/xKtMrN9XdPQoJtLLaINHtcOw23DRHvH3uOxomoChCGTCxp
         UMza0GZKpv0JR5G0mx4v4Vr9ad5+6uTKXCdpqNBJocBM1bOw6G6A6xs+bGlglVGbp0y9
         hUW/KxVBQbz5WejqIQvA0oGS4ntA6153RhuQXLEY8NJ5hfER5WJbUnjaN9Rx8r7jWi7O
         tCMalzprYJTYUb/5NhHr+xiAA5dNODDKFp8CPAX1ISNYT0iAxcuiIukKzCs5er+tkH1s
         Rvp2RNtw1Bs9rkVNMfBeGi33AZI0qgzFgrvanyihZ2pSJHEsSNu879s/WdB1OfvIC34k
         X2kg==
X-Gm-Message-State: AGi0PubBeCI0FJujaIA6ylFcIQw8Xu0/UhhYo4mG+bkvzRG1wUvqUhZF
        k0ouvMA+9TXTH90j6PSl/2lxWOon
X-Google-Smtp-Source: APiQypJgmXpH5wr5JUKJWKrpxZ3B/kXgTNDx95RVlsH/xHTsjXWjIq9HfiniFpB+2kDCHjNa/EVOYQ==
X-Received: by 2002:a19:9109:: with SMTP id t9mr6569014lfd.10.1586074264489;
        Sun, 05 Apr 2020 01:11:04 -0700 (PDT)
Received: from pablo-laptop ([2a02:a315:5445:5300:81e7:24d:4826:7491])
        by smtp.googlemail.com with ESMTPSA id z23sm7894833ljz.52.2020.04.05.01.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 01:11:03 -0700 (PDT)
Message-ID: <1207f5d5b8fd4a60d6835ca8baca7c8547635bbc.camel@gmail.com>
Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
From:   =?UTF-8?Q?Pawe=C5=82?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sun, 05 Apr 2020 10:11:02 +0200
In-Reply-To: <000001d60aec$5ef39670$1cdac350$@samsung.com>
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
         <CGME20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a@epcas5p4.samsung.com>
         <20200327170638.17670-6-alim.akhtar@samsung.com>
         <ac67cfc3736cf50c716b823a59af878d59b7198f.camel@gmail.com>
         <000801d60516$823fd890$86bf89b0$@samsung.com>
         <838a17416b4ed59903ae153e09842ac62584616f.camel@gmail.com>
         <002e01d605df$af658440$0e308cc0$@samsung.com>
         <1182150aff8140a82af17979a09c81676c719e2f.camel@gmail.com>
         <000001d60aad$05e7b6e0$11b724a0$@samsung.com>
         <17aa7c13a0f5a183158829e9b9af85537a740846.camel@gmail.com>
         <58f2996c7dfe70b226c5cafbd94d7b02a314d77a.camel@gmail.com>
         <000001d60aec$5ef39670$1cdac350$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-04-05 at 07:18 +0530, Alim Akhtar wrote:
Hi Alim
> Hi Pawel,
> 
> > -----Original Message-----
> > From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> > Sent: 05 April 2020 01:56
> > To: Alim Akhtar <alim.akhtar@samsung.com>; robh+dt@kernel.org;
> > devicetree@vger.kernel.org; linux-scsi@vger.kernel.org
> > Cc: krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> > kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> > cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
> > 
> > On Sat, 2020-04-04 at 21:33 +0200, Paweł Chmiel wrote:
> > > On Sat, 2020-04-04 at 23:45 +0530, Alim Akhtar wrote:
> > > Hi Alim,
> > > > Hi Pawel,
> > > > 
> > > > > -----Original Message-----
> > > > > From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> > > > > Sent: 03 April 2020 22:22
> > > > > To: Alim Akhtar <alim.akhtar@samsung.com>; robh+dt@kernel.org;
> > > > > devicetree@vger.kernel.org; linux-scsi@vger.kernel.org
> > > > > Cc: krzk@kernel.org; avri.altman@wdc.com;
> > > > > martin.petersen@oracle.com; kwmad.kim@samsung.com;
> > > > > stanley.chu@mediatek.com; cang@codeaurora.org;
> > > > > linux-samsung-soc@vger.kernel.org; linux-arm-
> > > > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
> > > > > 
> > > > > Hi Alim
> > > > > 
> > > > > Looking at vendor sources, my device is using the same gpios for
> > > > > urfs_rst_n and ufs_refclk_out like Espresso (with one difference -
> > > > > ufs_rst_n shouldn't be pulled up).
> > > > > 
> > > > > About regulators (it would be easier if dts would have all regulators).
> > > > > It's also using s2mps15 as Espresso, but it vendor dts had only 8
> > > > > (of
> > > > > 10 possible bucks, one missing was for UFS) and 14 ldos (of 27
> > > > > possible), where almost all rails are connected to something.
> > > > > 
> > > > > I'm wondering how it's working on Espresso, because when adding
> > > > > correct regulators for ufs (vccq = buck10 from s2mps15, always
> > > > > enabled for testing plus vccq2 and vccq = two regulators enabled
> > > > > by one gpio, enabled at boot by firmware), ufs wasn't still
> > > > > working because it was then failing at defer probe (s2mps15 was
> > > > > probed after ufs)
> > > > > 
> > > > > [    0.962482] exynos-ufshc 15570000.ufs: ufshcd_get_vreg: vccq get
> > > > > failed, err=-517
> > > > > 
> > > > As I said, this is very specific to the board, on Espresso we have LDO12
> > connected to UFS_RESETn.
> > > > Either make all of them as always-on, or just disabled s2mps15
> > > > (default voltage supply should be ok, unless bootloader on your
> > > > board does have messed too much with PMIC)
> > > > 
> > > > > After that boot would just stop/hang.
> > > > > 
> > > > > After making a "dirty fix" by making s2mps15 regulator driver use
> > > > > subsys_initcall (like in vendor sources) and ufs late_initcall (to
> > > > > give it more time to setup and get it working and solve it later),
> > > > > i had to mark following clocks as CLK_IGNORE_UNUSED to be able to
> > > > > bring link up (it replicates setting done by vendor kernel, which
> > > > > enables them on boot):
> > > > > - "phyclk_ufs20_rx1_symbol_user"
> > > > > - "phyclk_ufs20_rx0_symbol_user"
> > > > > - "phyclk_ufs20_tx0_symbol_user"
> > > > > 
> > > > Coming to these clocks, all these are supplied by default, my best
> > > > guess is since you are using an actual product (S6 edge), they might have
> > optimized for power saving And most likely all clock might be  gated initially. In
> > my case all are set to default.
> > > > I have attached a small change in the exynos7 dts and phy driver clock
> > handling, please try this attached patch and let me know if this helps in removing
> > some of your hacks.
> > > > In the later SoCs these clocks are not in this form, so I didn't included in my
> > current patch set, If this works for your, will add as an optional for
> > exynos7/7420.
> > > > I also assume you are using clk-exynos7.c and my posted ufs driver.
> > > Yes, i'm using clk-exynos7 (and other exynos7 drivers/dts/etc).
> > > It would be great if someone could say how exynos7 and exynos7420 are
> > > similar. For now it looks like that only difference is that exynos7
> > > has only 4 cores (a57) where 7420 has 4xa53 + 4xa57.
> > > It would be very valuable information for me so i could know how much
> > > i could reuse my device.
> > > > > Now it's able to bring both device and link, but it fails at
> > > > > ufshcd_uic_change_pwr_mode.
> > > > > 
> > > > Can you please use the exact ufs and ufs-phy device node as in my patch?
> > > With Your patch + removed my changes to clocks (removed fix for wrong
> > > clock order in dts + removed CLK_IGNORE_UNUSED from symbol clocks in
> > > clk-exynos7) it's finally able to detect my UFS device!!
> > > 
> 
> Wow, great to know that UFS device started working for you on S6.
> 
> > > (but of fails later...with constant error spam in kernel log).
> > > 
> > > [    1.383481] exynos-ufshc 15570000.ufs: ufshcd_populate_vreg: Unable
> > > to find vdd-hba-supply regulator, assuming enabled
> > > [    1.390060] exynos-ufshc 15570000.ufs: ufshcd_populate_vreg: unable
> > > to find vcc-max-microamp
> > > [    1.398465] exynos-ufshc 15570000.ufs: ufshcd_populate_vreg: unable
> > > to find vccq-max-microamp
> > > [    1.406968] exynos-ufshc 15570000.ufs: ufshcd_populate_vreg: unable
> > > to find vccq2-max-microamp
> > > [    1.415569] exynos-ufshc 15570000.ufs: ufshcd_init_clocks: clk:
> > > core_clk, rate: 100000000
> > > [    1.423715] exynos-ufshc 15570000.ufs: ufshcd_init_clocks: clk:
> > > sclk_unipro_main, rate: 167000000
> > > [    1.432569] exynos-ufshc 15570000.ufs: __ufshcd_setup_clocks: clk:
> > > core_clk enabled
> > > [    1.440205] exynos-ufshc 15570000.ufs: __ufshcd_setup_clocks: clk:
> > > sclk_unipro_main enabled
> > > [    1.449613] scsi host0: ufshcd
> > > [    1.452179] samsung-ufs-phy 15571800.ufs-phy: MPHY ref_clk_rate =
> > > 26000000
> > > [    1.458448] samsung-ufs-phy 15571800.ufs-phy: MPHY
> > > ref_parent_clk_rate = 26000000
> > > [    1.487288] exynos-ufshc 15570000.ufs: ufshcd_print_pwr_info:[RX,
> > > TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE],
> > rate
> > > =
> > > 0
> > > [    2.025569] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd041 val
> > > 0x1fff error code 1
> > > [    2.025715] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd041 val
> > > 0x1fff failed 0 retries
> > > [    2.025880] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd042 val
> > > 0xffff error code 1
> > > [    2.027354] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd042 val
> > > 0xffff failed 0 retries
> > > [    2.035583] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd043 val
> > > 0x7fff error code 1
> > > [    2.043465] exynos-ufshc 15570000.ufs: dme-set: attr-id 0xd043 val
> > > 0x7fff failed 0 retries
> > > [    2.054049] exynos-ufshc 15570000.ufs: Power mode change 0 : Fast
> > > series_B G_2 L_2
> > > [    2.059261] exynos-ufshc 15570000.ufs: ufshcd_print_pwr_info:[RX,
> > > TX]: gear=[2, 2], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
> > > [    2.071307] exynos-ufshc 15570000.ufs: ufshcd_init_icc_levels:
> > > setting icc_level 0x0
> > > [    2.081624] exynos-ufshc 15570000.ufs: ufshcd_set_queue_depth:
> > > activate tcq with queue depth 1
> > > [    2.087576] scsi 0:0:0:49488: scsi_add_lun: correcting incorrect
> > > peripheral device type 0x0 for W-LUN 0x            c150hN
> > > [    2.098400] scsi 0:0:0:49488: Well-known LUN    SAMSUNG  KLUBG4G1BD-
> > > E0B1  0200 PQ: 0 ANSI: 6
> > > [    2.107585] exynos-ufshc 15570000.ufs: ufshcd_set_queue_depth:
> > > activate tcq with queue depth 16
> > > [    2.115588] scsi 0:0:0:49476: scsi_add_lun: correcting incorrect
> > > peripheral device type 0x0 for W-LUN 0x            c144hN
> > > [    2.126519] scsi 0:0:0:49476: Well-known LUN    SAMSUNG  KLUBG4G1BD-
> > > E0B1  0200 PQ: 0 ANSI: 6
> > > [    2.135534] exynos-ufshc 15570000.ufs: ufshcd_set_queue_depth:
> > > activate tcq with queue depth 1
> > > [    2.143612] scsi 0:0:0:49456: scsi_add_lun: correcting incorrect
> > > peripheral device type 0x0 for W-LUN 0x            c130hN
> > > [    2.154543] scsi 0:0:0:49456: Well-known LUN    SAMSUNG  KLUBG4G1BD-
> > > E0B1  0200 PQ: 0 ANSI: 6
> > > [    2.163597] exynos-ufshc 15570000.ufs: ufshcd_set_queue_depth:
> > > activate tcq with queue depth 16
> > > [    2.171721] scsi 0:0:0:0: Direct-Access     SAMSUNG  KLUBG4G1BD-
> > > E0B1  0200 PQ: 0 ANSI: 6
> > > [    2.180352] exynos-ufshc 15570000.ufs: OCS error from controller = 7
> > > for tag 0
> > > [    2.186921] host_regs: 00000000: 0383ff0f 00000000 00000200 00000000
> > > [    2.193230] host_regs: 00000010: 00000101 00007fce 00000c96 00000000
> > > [    2.199565] host_regs: 00000020: 00000000 00030e75 00000000 00000000
> > > [    2.205899] host_regs: 00000030: 0000010f 00000000 80000010 00000000
> > > [    2.212234] host_regs: 00000040: 00000000 00000000 00000000 00000000
> > > [    2.218568] host_regs: 00000050: f8d64000 00000000 00000000 00000000
> > > [    2.224903] host_regs: 00000060: 00000001 00000000 00000000 00000000
> > > [    2.231237] host_regs: 00000070: f8da2000 00000000 00000000 00000000
> > > [    2.237572] host_regs: 00000080: 00000001 00000000 00000000 00000000
> > > [    2.243907] host_regs: 00000090: 00000002 95190000 00000000 00000000
> > > [    2.250242] exynos-ufshc 15570000.ufs: hba->ufs_version = 0x200,
> > > hba->capabilities = 0x383ff0f
> > > 
> > > Full bootlog
> > > https://protect2.fireeye.com/url?k=edbae146-b069b8f8-edbb6a09-0cc47a31
> > > ba82-
> > 8b13b1e4caed34d7&q=1&u=https%3A%2F%2Fgist.github.com%2FPabloPL%2F
> > > 0bcb24492f4ab6e9703c2a4ea20ceb18 kernel source:
> > > https://protect2.fireeye.com/url?k=75038dec-28d0d452-750206a3-0cc47a31
> > > ba82-
> > 4c366bec6fc01e64&q=1&u=https%3A%2F%2Fgithub.com%2FPabloPL%2Flinux
> > > %2Ftree%2Fufs-mainline dts file: exynos7-zeroflt.dts (it should be
> > > zerolt, but will be fixed/changed later).
> > 
> > Actually, after waiting enough time (about 15 or even more sec of that error
> > "spam"), was able to mount partitions and manipulate files there.
> > 
> You need below patch and  a change in the ufs driver:
> https://www.spinics.net/lists/linux-scsi/msg138501.html
> 
> And
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index ce2c3d674e4b..c6332deff03a 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -1359,7 +1359,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
>         .quirks                 = UFSHCD_QUIRK_PRDT_BYTE_GRAN |
>                                   UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
>                                   UFSHCI_QUIRK_BROKEN_HCE |
> -                                 UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR,
> +                                 UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
> +                                 UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR,
>         .opts                   = EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
>                                   EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
>                                   EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> 
> > So for me the only issue to solve are defered probe when regulators are not yet
> > found (for example when pmic is probed after ufs) and not sure what about that
> > errors (despite working ufs).
> > 
> The error will go away with the above changes, about regulators, you need to figure it out, as I am not aware of Galaxy S6 PMIC schemes.
> I also seek your Tested-by tag on these patches .
Checked with those two patches applied, error is gone.
You can add my Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
to all patches.

Thanks
> 
> > Thanks for all
> 
> Thanks for helping in testing.
> > > Thanks
> 
> 

