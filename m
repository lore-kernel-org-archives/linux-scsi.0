Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAE2C41514
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 19:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD93B22CF8
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 19:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="maPufM3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfH1TUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 15:20:36 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:35457 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfH1TUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 15:20:36 -0400
Received: by mail-pg1-f176.google.com with SMTP id n4so250241pgv.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2019 12:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6kz64WPR5o1Q4AyMxm75GxnjjAd9OnblS1d0DwAS3hE=;
        b=maPufM3b2GW/WW2eYxV3spCqbQ/OiVsFNKs7xEeMrxJpnX9JttlEDG/CNhy7kMZn/E
         /mMXa5FZrJnl10AVFTJTknKKuDwxRPlYVe+RVRF03giDhZuvvM/EaInmKzIFIMd7plks
         GUp8aeDH/nmNXFvp33PIJTUHFTLQPZfoS1xScH3s1ZmzRE7kRfAsinmEL4578K3SuKmt
         SgEqvnVIAJL5NP+3P5I66jWW5Kjh/7+B3/w6Wzue121dxqJQ5/pS4epYyBgFLyvV9ODZ
         kJovUY9YzLxaFKS9HewjB9cqeYWUMOeZEYdHZ/z6G38jIHDCXD+9LzV9TXE1hILdPqms
         BivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6kz64WPR5o1Q4AyMxm75GxnjjAd9OnblS1d0DwAS3hE=;
        b=XQcunWEzeSC0LoRl9IMbOTcjUQgR+VrGKNNdQoizcT2ahd8DxEV6p9qSQULeQ2uzaU
         mtgxkV3naOIWUq7t9VVnO2/cvnlAr4WT0SVcm8jthC0abXykxm+VP8qvPx3mtbMTheHa
         s3xLNm5ML0Evsy44USwJZbDmSX/991Fp+vBiE78XppM4OO72/HTGoAJaoMYv6QycdrE0
         EsB+p8mTCI3xwdydHdWsD3eqVd+NVEgKlDY5o4d05umU3u++t+ms/IL1PuDziZCL2LJ7
         8povDqdVp67Ocm4jX63g54iSEOxymt2gxRJXN62nvL+C2EeC3BDpHSRtD3YFwzSKrdIV
         dqsg==
X-Gm-Message-State: APjAAAWR2XkXVCdk/2frqCEsLyT4Ak2RDe/faSk/8aOgKS8iHzYwqWMw
        H+u74EV0NnyZAusDiu63tZTF4vCF1Ag=
X-Google-Smtp-Source: APXvYqxGkpufd8ugKJa0yqrlg3/rV+EExtqowo2wXSn4Ycv3kX5FnTodo8WAMly2yFrm6DTmmdmTqw==
X-Received: by 2002:a65:534c:: with SMTP id w12mr4832416pgr.51.1567020034478;
        Wed, 28 Aug 2019 12:20:34 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id c23sm2810819pgj.62.2019.08.28.12.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 12:20:33 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:20:31 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc:     SCSI <linux-scsi@vger.kernel.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Evan Green <evgreen@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Vivek Gautam <vivek.gautam@codeaurora.org>,
        Nikita Shvets <runetmember@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: ufshcd_abort: Device abort task at tag 7
Message-ID: <20190828192031.GN6167@minitux>
References: <9f3ed253-5f6b-1893-531d-085f881956dd@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f3ed253-5f6b-1893-531d-085f881956dd@free.fr>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 28 Aug 02:09 PDT 2019, Marc Gonzalez wrote:

> Hello,
> 
> Someone posted a bug report for UFS on an sdm850 tablet:
> https://bugzilla.kernel.org/show_bug.cgi?id=204685
> 
> If I'm reading the boot logs right, this board is EFI rather than DT.

It's UEFI-based and Linux will either operate based on DT or ACPI
tables, depending on what was provided.

> (Lee: EFI on qcom is one of your areas, right?
> The UFSHC driver is DT-aware, but is it EFI-aware?)
> 
> [    0.000000] efi: memattr: Unexpected EFI Memory Attributes table version -1347440721
> I suppose this may be safely ignored?
> 
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-5.2.0-99-generic root=UUID=66e85825-5c21-4120-b4ee-e17e4cdc1e58 ro efi=novamap ignore_loglevel clk_ignore_unused pd_ignore_unused console=tty0
> IIUC, the kernel is supposed to boot successfully even without
> "clk_ignore_unused pd_ignore_unused" (tangential, unrelated)
> 
> Bjorn, any ideas? Ever see this issue?
> 

I don't remember the exact splats seen, but I would suggest that this is
retested after applying the following series:

https://lore.kernel.org/linux-arm-msm/20190828191756.24312-1-bjorn.andersson@linaro.org/T/#u

Regards,
Bjorn

> Regards.
> 
> 
> Notable events:
> 
> [    2.438780] geni_se_qup 8c0000.geniqup: Err getting AHB clks -517
> [    2.439030] geni_se_qup ac0000.geniqup: Err getting AHB clks -517
> 
> [    2.453050] ufshcd-qcom 1d84000.ufshc: ufshcd_get_vreg: vcc get failed, err=-517
> [    2.458477] ufshcd-qcom 1d84000.ufshc: Initialization failed
> 
> [    2.540980] ufshcd-qcom 1d84000.ufshc: ufs_qcom_init: required phy device. hasn't probed yet. err = -517
> [    2.540986] ufshcd-qcom 1d84000.ufshc: ufshcd_variant_hba_init: variant qcom init failed err -517
> [    2.541052] ufshcd-qcom 1d84000.ufshc: Initialization failed
> 
> [    2.695052] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find vdd-hba-supply regulator, assuming enabled
> [    2.699182] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find vccq-supply regulator, assuming enabled
> [    2.706287] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find vccq2-supply regulator, assuming enabled
> [    2.866207] ufshcd-qcom 1d84000.ufshc: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
> 
> [   33.772190] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 7
> [   33.774946] sd 0:0:0:5: [sdf] tag#7 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> [   33.805525] ufshcd-qcom 1d84000.ufshc: hba->ufs_version = 0x210, hba->capabilities = 0x1587031f
> [   33.808338] ufshcd-qcom 1d84000.ufshc: hba->outstanding_reqs = 0xab000080, hba->outstanding_tasks = 0x0
> 
> [   34.045961] ufshcd-qcom 1d84000.ufshc: UPIU[7] - issue time 3165714 us
> [   34.047069] ufshcd-qcom 1d84000.ufshc: UPIU[7] - complete time 0 us
> [   34.048196] ufshcd-qcom 1d84000.ufshc: UPIU[7] - Transfer Request Descriptor phys@0x2661cd0e0
> [   34.051799] ufshcd-qcom 1d84000.ufshc: UPIU[7] - Request UPIU phys@0xdf045400
> [   34.055715] ufshcd-qcom 1d84000.ufshc: UPIU[7] - Response UPIU phys@0xdf045600
> [   34.062761] ufshcd-qcom 1d84000.ufshc: UPIU[7] - PRDT - 1 entries  phys@0xdf045800
> [   34.065836] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: cmd pending in the device. tag = 7
> [   34.168171] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x01 timed-out
> [   34.169822] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: failed with err -110
> [   34.171497] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 29
> [   34.174951] ufshcd-qcom 1d84000.ufshc: UPIU[29] - issue time 3036529 us
> [   34.176740] ufshcd-qcom 1d84000.ufshc: UPIU[29] - complete time 0 us
> [   34.178534] ufshcd-qcom 1d84000.ufshc: UPIU[29] - Transfer Request Descriptor phys@0x2661cd3a0
> [   34.184172] ufshcd-qcom 1d84000.ufshc: UPIU[29] - Request UPIU phys@0xdf055c00
> [   34.190105] ufshcd-qcom 1d84000.ufshc: UPIU[29] - Response UPIU phys@0xdf055e00
> [   34.200535] ufshcd-qcom 1d84000.ufshc: UPIU[29] - PRDT - 1 entries  phys@0xdf056000
> [   34.202707] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: failed with err -5
> [   34.204910] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 25
> [   34.209414] ufshcd-qcom 1d84000.ufshc: UPIU[25] - issue time 3017240 us
> [   34.211722] ufshcd-qcom 1d84000.ufshc: UPIU[25] - complete time 0 us
> [   34.214048] ufshcd-qcom 1d84000.ufshc: UPIU[25] - Transfer Request Descriptor phys@0x2661cd320
> [   34.221259] ufshcd-qcom 1d84000.ufshc: UPIU[25] - Request UPIU phys@0xdf052c00
> [   34.228788] ufshcd-qcom 1d84000.ufshc: UPIU[25] - Response UPIU phys@0xdf052e00
> [   34.241869] ufshcd-qcom 1d84000.ufshc: UPIU[25] - PRDT - 1 entries  phys@0xdf053000
> [   34.244578] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: failed with err -5
> [   34.247307] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 24
> [   34.252877] ufshcd-qcom 1d84000.ufshc: UPIU[24] - issue time 3018666 us
> [   34.255718] ufshcd-qcom 1d84000.ufshc: UPIU[24] - complete time 0 us
> [   34.258540] ufshcd-qcom 1d84000.ufshc: UPIU[24] - Transfer Request Descriptor phys@0x2661cd300
> [   34.266987] ufshcd-qcom 1d84000.ufshc: UPIU[24] - Request UPIU phys@0xdf052000
> [   34.275500] ufshcd-qcom 1d84000.ufshc: UPIU[24] - Response UPIU phys@0xdf052200
> [   34.289559] ufshcd-qcom 1d84000.ufshc: UPIU[24] - PRDT - 1 entries  phys@0xdf052400
> [   34.292343] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: failed with err -5
> [   34.295114] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 27
> [   34.300650] ufshcd-qcom 1d84000.ufshc: UPIU[27] - issue time 3040502 us
> [   34.303419] ufshcd-qcom 1d84000.ufshc: UPIU[27] - complete time 0 us
> [   34.306159] ufshcd-qcom 1d84000.ufshc: UPIU[27] - Transfer Request Descriptor phys@0x2661cd360
> [   34.314450] ufshcd-qcom 1d84000.ufshc: UPIU[27] - Request UPIU phys@0xdf054400
> [   34.322892] ufshcd-qcom 1d84000.ufshc: UPIU[27] - Response UPIU phys@0xdf054600
> [   34.336707] ufshcd-qcom 1d84000.ufshc: UPIU[27] - PRDT - 1 entries  phys@0xdf054800
> [   34.339447] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: failed with err -5
> [   34.342173] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 31
> [   34.347604] ufshcd-qcom 1d84000.ufshc: UPIU[31] - issue time 3036762 us
> [   34.350345] ufshcd-qcom 1d84000.ufshc: UPIU[31] - complete time 0 us
> [   34.353042] ufshcd-qcom 1d84000.ufshc: UPIU[31] - Transfer Request Descriptor phys@0x2661cd3e0
> [   34.361194] ufshcd-qcom 1d84000.ufshc: UPIU[31] - Request UPIU phys@0xdf057400
> [   34.369347] ufshcd-qcom 1d84000.ufshc: UPIU[31] - Response UPIU phys@0xdf057600
> [   34.383041] ufshcd-qcom 1d84000.ufshc: UPIU[31] - PRDT - 1 entries  phys@0xdf057800
> [   34.385789] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: failed with err -5
> [   34.508188] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   34.511533] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   34.616170] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   34.619542] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   34.724170] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   34.727563] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   34.832169] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   34.835539] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   34.940170] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   34.943576] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   35.048171] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   35.051618] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   35.095792] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   35.099829] ufshcd-qcom 1d84000.ufshc: UPIU[7] - issue time 3165714 us
> [   35.103402] ufshcd-qcom 1d84000.ufshc: UPIU[7] - complete time 0 us
> [   35.106937] ufshcd-qcom 1d84000.ufshc: UPIU[7] - Transfer Request Descriptor phys@0x2661cd0e0
> [   35.117587] ufshcd-qcom 1d84000.ufshc: UPIU[7] - Request UPIU phys@0xdf045400
> [   35.128237] ufshcd-qcom 1d84000.ufshc: UPIU[7] - Response UPIU phys@0xdf045600
> [   35.145785] ufshcd-qcom 1d84000.ufshc: UPIU[7] - PRDT - 1 entries  phys@0xdf045800
> [   35.152773] ufshcd-qcom 1d84000.ufshc: UPIU[24] - issue time 3018666 us
> [   35.156346] ufshcd-qcom 1d84000.ufshc: UPIU[24] - complete time 0 us
> [   35.159906] ufshcd-qcom 1d84000.ufshc: UPIU[24] - Transfer Request Descriptor phys@0x2661cd300
> [   35.170605] ufshcd-qcom 1d84000.ufshc: UPIU[24] - Request UPIU phys@0xdf052000
> [   35.181279] ufshcd-qcom 1d84000.ufshc: UPIU[24] - Response UPIU phys@0xdf052200
> [   35.198877] ufshcd-qcom 1d84000.ufshc: UPIU[24] - PRDT - 1 entries  phys@0xdf052400
> [   35.205904] ufshcd-qcom 1d84000.ufshc: UPIU[25] - issue time 3017240 us
> [   35.209398] ufshcd-qcom 1d84000.ufshc: UPIU[25] - complete time 0 us
> [   35.212913] ufshcd-qcom 1d84000.ufshc: UPIU[25] - Transfer Request Descriptor phys@0x2661cd320
> [   35.223656] ufshcd-qcom 1d84000.ufshc: UPIU[25] - Request UPIU phys@0xdf052c00
> [   35.234408] ufshcd-qcom 1d84000.ufshc: UPIU[25] - Response UPIU phys@0xdf052e00
> [   35.252106] ufshcd-qcom 1d84000.ufshc: UPIU[25] - PRDT - 1 entries  phys@0xdf053000
> [   35.259137] ufshcd-qcom 1d84000.ufshc: UPIU[27] - issue time 3040502 us
> [   35.262691] ufshcd-qcom 1d84000.ufshc: UPIU[27] - complete time 0 us
> [   35.266202] ufshcd-qcom 1d84000.ufshc: UPIU[27] - Transfer Request Descriptor phys@0x2661cd360
> [   35.276857] ufshcd-qcom 1d84000.ufshc: UPIU[27] - Request UPIU phys@0xdf054400
> [   35.287652] ufshcd-qcom 1d84000.ufshc: UPIU[27] - Response UPIU phys@0xdf054600
> [   35.305317] ufshcd-qcom 1d84000.ufshc: UPIU[27] - PRDT - 1 entries  phys@0xdf054800
> [   35.312298] ufshcd-qcom 1d84000.ufshc: UPIU[29] - issue time 3036529 us
> [   35.315788] ufshcd-qcom 1d84000.ufshc: UPIU[29] - complete time 0 us
> [   35.319240] ufshcd-qcom 1d84000.ufshc: UPIU[29] - Transfer Request Descriptor phys@0x2661cd3a0
> [   35.329591] ufshcd-qcom 1d84000.ufshc: UPIU[29] - Request UPIU phys@0xdf055c00
> [   35.339727] ufshcd-qcom 1d84000.ufshc: UPIU[29] - Response UPIU phys@0xdf055e00
> [   35.356361] ufshcd-qcom 1d84000.ufshc: UPIU[29] - PRDT - 1 entries  phys@0xdf056000
> [   35.363009] ufshcd-qcom 1d84000.ufshc: UPIU[31] - issue time 3036762 us
> [   35.366321] ufshcd-qcom 1d84000.ufshc: UPIU[31] - complete time 0 us
> [   35.369646] ufshcd-qcom 1d84000.ufshc: UPIU[31] - Transfer Request Descriptor phys@0x2661cd3e0
> [   35.379815] ufshcd-qcom 1d84000.ufshc: UPIU[31] - Request UPIU phys@0xdf057400
> [   35.389919] ufshcd-qcom 1d84000.ufshc: UPIU[31] - Response UPIU phys@0xdf057600
> [   35.406573] ufshcd-qcom 1d84000.ufshc: UPIU[31] - PRDT - 1 entries  phys@0xdf057800
> [   35.506995] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
