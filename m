Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F06C4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 19:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6CC120752
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 19:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tXlzWPo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgCSTm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 15:42:27 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38480 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgCSTm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 15:42:27 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so3907769ljh.5;
        Thu, 19 Mar 2020 12:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=q4IYSKp2wG/4UoatG1cBrakrAirQHlhWNtEJ23gxzeU=;
        b=tXlzWPo8FHVA2iCI1OepuofmWSvFOcRjqI655Ad7KrpoB1SYoNY4kfnvEdkqgWhg7D
         BV02p7E6FCzklvEvvQSrr2nB0tSfCjiBzUncRuOgsy7+3EQD0KBsshjatZb3voOcVeA0
         ktNgB8hFECqKHU8ssRjCjxBn0hW2jsvbws2b3CRpK2Ell9sz5A4ZfdGjOFDHWhEtjaYJ
         /maqmkui77VcWOnpKXZ1WS2BxPyx4/pXqBxVvfpUAfuq4uRZwEsbUCaOiz6oIha+Q2DQ
         2ltgicyNVpXTIgqi7I+pA67G7cPN8soJgJXh8PqiuP34u1TlzqxW9d1gEPK89Bq8XkvJ
         RB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q4IYSKp2wG/4UoatG1cBrakrAirQHlhWNtEJ23gxzeU=;
        b=KD7awLpB8JGnRprF7Ox2c0Q9+zclpI2zzmtIAx/0+430Xez1/HyxHCtthFiS6WqmF9
         eJhvopzrzqwWrlxkXVN6LkPIe98V4IHJ0/k3pknbrDy7AgFWD9OKwQOKK4IKdwQYSe+L
         9nsLHS3ddjsdnBcp/Ho0C5LPUcOdpEZViq7iAm9C6kGz8C6iU8zlb3AXbPyR5V3Y1Lzv
         fj0CAGgeMwQSKWieRyhRom4wxsSLu3h4dHT9b2ZRyTCxUC/SRevmwt5Thq0xYdXY/LZi
         NtTGFMClRrUXFZo02zmy8YwQNdGVn6EutvQFdjfv1K50/K8WT+fB9EYl4APIeGOB+qK5
         7ZKg==
X-Gm-Message-State: ANhLgQ2dlT6nJ2qVdRyHZ+iRp1DPZReM5sYt4F7CAptkBHohqCWVEHAw
        cU/quKL5qTusROkfaLFfWYE=
X-Google-Smtp-Source: ADFU+vsH9gbaitfQ1D/nFLWS/Hwg7pIopeuQK4wmLy+4Gn+8aqstBHNN0RfbL4hBTLQKx+ivcKrvFw==
X-Received: by 2002:a2e:9284:: with SMTP id d4mr3054679ljh.226.1584646941559;
        Thu, 19 Mar 2020 12:42:21 -0700 (PDT)
Received: from pablo-laptop ([2a02:a315:5445:5300:61c4:1399:8fb5:8d82])
        by smtp.googlemail.com with ESMTPSA id b23sm2065233lff.64.2020.03.19.12.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 12:42:20 -0700 (PDT)
Message-ID: <1d128596eeefb414b7b621b0db5ca0697030dbfc.camel@gmail.com>
Subject: Re: [PATCH v3 0/5] exynos-ufs: Add support for UFS HCI
From:   =?UTF-8?Q?Pawe=C5=82?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date:   Thu, 19 Mar 2020 20:42:19 +0100
In-Reply-To: <20200319150031.11024-1-alim.akhtar@samsung.com>
References: <CGME20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec@epcas5p4.samsung.com>
         <20200319150031.11024-1-alim.akhtar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-03-19 at 20:30 +0530, Alim Akhtar wrote:
> This patch-set introduces UFS (Universal Flash Storage) host controller support
> for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.
> 
> - Changes since v2:
> * fixed build warning by kbuild test robot 
> * Added Reported-by tags
> 
> - Changes since v1:
> * fixed make dt_binding_check error as pointed by Rob
> * Addressed Krzysztof's review comments
> * Added Reviewed-by tags
> 
>  
> patch 1/5: define devicetree bindings for UFS PHY
> patch 2/5: Adds UFS PHY driver
> patch 3/5: define devicetree bindings for UFS HCI 
> patch 4/5: Adds Samsung UFS HCI driver
> patch 5/5: Enabled UFS on exynos7 platform
Hi
Is this compatible with Exynos7420? Looking at u-boot source code,
there is Espresso7420 - isn't it the same device? Also this driver
looks very similar to the one from vendor kernel sources (for my
device). 

I did tried to run this on my Exynos7420 based device (Samsung S6 Edge
phone) with 5.6-rc6, to get any storage working (since it doesn't have sdcard slot).

At first i got error in exynos_ufs_config_smu. Looking at vendor
sources, on my device only secureos is able to write to those registers
so i fixed it by using smc calls and driver probes fine. Will this be
also supported by driver (maybe in future)?

But now got another error
[    1.610464] exynos-ufshc 15570000.ufs: ufshcd_intr: Unhandled
interrupt 0x00000000
[    1.610629] host_regs: 00000000: 0383ff0f 00000000 00000200 00000000
[    1.610747] host_regs: 00000010: 00000101 00007fce 00000000 00000000
[    1.610863] host_regs: 00000020: 00000000 00030e75 00000000 00000000
[    1.614727] host_regs: 00000030: 0000000f 00000000 00000000 00000000
[    1.621061] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    1.627396] host_regs: 00000050: f8c37000 00000000 00000001 00000000
[    1.633730] host_regs: 00000060: 00000001 00000000 00000000 00000000
[    1.640065] host_regs: 00000070: f9644000 00000000 00000000 00000000
[    1.646400] host_regs: 00000080: 00000001 00000000 00000000 00000000
[    1.652734] host_regs: 00000090: 00000002 95290000 00000000 00000000
[    1.747649] exynos-ufshc 15570000.ufs: ufshcd_intr: Unhandled
interrupt 0x00000000
[    1.747807] host_regs: 00000000: 0383ff0f 00000000 00000200 00000000
[    1.747924] host_regs: 00000010: 00000101 00007fce 00000000 00000000
[    1.748041] host_regs: 00000020: 00000000 00030e75 00000000 00000000
[    1.751909] host_regs: 00000030: 0000000f 00000000 00000000 00000000
[    1.758244] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    1.764578] host_regs: 00000050: f8c37000 00000000 00000001 00000000
[    1.770913] host_regs: 00000060: 00000001 00000000 00000000 00000000
[    1.777248] host_regs: 00000070: f9644000 00000000 00000000 00000000
[    1.783582] host_regs: 00000080: 00000001 00000000 00000000 00000000
[    1.789917] host_regs: 00000090: 00000002 95290000 00000000 00000000
[    1.884841] exynos-ufshc 15570000.ufs: ufshcd_intr: Unhandled
interrupt 0x00000000
[    1.884999] host_regs: 00000000: 0383ff0f 00000000 00000200 00000000
[    1.885116] host_regs: 00000010: 00000101 00007fce 00000000 00000000
[    1.885233] host_regs: 00000020: 00000000 00030e75 00000000 00000000
[    1.889100] host_regs: 00000030: 0000000f 00000000 00000000 00000000
[    1.895435] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    1.901770] host_regs: 00000050: f8c37000 00000000 00000001 00000000
[    1.908104] host_regs: 00000060: 00000001 00000000 00000000 00000000
[    1.914439] host_regs: 00000070: f9644000 00000000 00000000 00000000
[    1.920773] host_regs: 00000080: 00000001 00000000 00000000 00000000
[    1.927108] host_regs: 00000090: 00000002 95290000 00000000 00000000
[    2.998155] exynos-ufshc 15570000.ufs: ufshcd_query_flag: Sending
flag query for idn 1 failed, err = -11
[    4.502138] exynos-ufshc 15570000.ufs: ufshcd_query_flag: Sending
flag query for idn 1 failed, err = -11
[    6.006137] exynos-ufshc 15570000.ufs: ufshcd_query_flag: Sending
flag query for idn 1 failed, err = -11
[    6.006311] exynos-ufshc 15570000.ufs: ufshcd_query_flag_retry:
query attribute, opcode 5, idn 1, failed with error -11 after 3 retires
[    6.006545] exynos-ufshc 15570000.ufs: ufshcd_complete_dev_init
reading fDeviceInit flag failed with error -11

Do You have any idea what could be wrong?

Thanks
> 
> Note: This series is based on Linux-5.6-rc6 (commit: fb33c6510d55)
> 
> 
> Alim Akhtar (5):
>   dt-bindings: phy: Document Samsung UFS PHY bindings
>   phy: samsung-ufs: add UFS PHY driver for samsung SoC
>   Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
>     controller
>   scsi: ufs-exynos: add UFS host support for Exynos SoCs
>   arm64: dts: Add node for ufs exynos7
> 
>  .../bindings/phy/samsung,ufs-phy.yaml         |   62 +
>  .../devicetree/bindings/ufs/ufs-exynos.txt    |  104 ++
>  .../boot/dts/exynos/exynos7-espresso.dts      |   16 +
>  arch/arm64/boot/dts/exynos/exynos7.dtsi       |   44 +-
>  drivers/phy/samsung/Kconfig                   |    9 +
>  drivers/phy/samsung/Makefile                  |    1 +
>  drivers/phy/samsung/phy-exynos7-ufs.h         |   85 +
>  drivers/phy/samsung/phy-samsung-ufs.c         |  311 ++++
>  drivers/phy/samsung/phy-samsung-ufs.h         |  100 ++
>  drivers/scsi/ufs/Kconfig                      |   12 +
>  drivers/scsi/ufs/Makefile                     |    1 +
>  drivers/scsi/ufs/ufs-exynos.c                 | 1399 +++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos.h                 |  268 ++++
>  drivers/scsi/ufs/unipro.h                     |   41 +
>  include/linux/phy/phy-samsung-ufs.h           |   70 +
>  15 files changed, 2521 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>  create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
>  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
>  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.h
>  create mode 100644 include/linux/phy/phy-samsung-ufs.h
> 

