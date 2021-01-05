Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B12C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E304B225AC
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbhAENYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 08:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbhAENYK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 08:24:10 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BD6C061574
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jan 2021 05:23:30 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jx16so41110724ejb.10
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 05:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+kv8JkMkAKYyYj1sHFj3HOeJpM4Y8ZByc0a39UZrjU=;
        b=P4PN1aKSVhc0nrA5/96bbab2C9sek/rTUjpO+/U2MHSYNpSTCyiIi++Ofny+EYIDTC
         ESJcrFwaRl/TALTzfbcHmsX2eNsmlV+osYEha0+N/Fcip2Yk2nVI7PC+vCmn2+009VR3
         SScEBxAT2ypsPLnRprIEG9oSZkAlJUit5KBR8mqcfFmE3oL76hllXi9n/G4w4iNp7bkw
         9s34mQnTnG0PpX+bAG6XpN9uNXYc3qE/GrDR9v0B2/tvl98nzejcg4bw1n5WZ44kwVBy
         dneZA84PSLEosH7/gHgm/yGbvmT3UITmYBHlQ7mnZCtKfJuyo1RgJJWFc5O5hmHLecZY
         3l9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+kv8JkMkAKYyYj1sHFj3HOeJpM4Y8ZByc0a39UZrjU=;
        b=SsCKq4OPj4qlbRu184vgZT+RsM/Bdup6PpN2wfPvIHrY06ZuKiAeyNnfebwqD3BhJe
         tJlPNm9WRvpRCrnSEV3BeNtzVZucY3oYvA49UMQKfeDGiN65pev9I3OJHYuiq8rwor5e
         vRjh7LVL+greoDP8LFyQDTuNI3KTQMd9mqKt7R8KQQdHJ22VLTUiDnA/yrRtpAII2Ajt
         Fw2dB8FjUxFeXp1pupD+FtscL5ze1Yq1nAXOEVLr79J4FPTYFwB8FHSofgjUJvgljW+n
         bNJy4dczLUQBxdPE0jIaJ2y2qyvSqTKlQjUNrAFZ4QecYyDD2y3CQOrwvtFn7eymlpEo
         wugg==
X-Gm-Message-State: AOAM5306O1/iCCPe2eTVFLl90wCSnbhcu6CdjdJ+J/B/dJkP1Fa5Y6E/
        kRbHBI385a+s6HO3xyfwYG+Ejglw7k18TEIX/DDN2A==
X-Google-Smtp-Source: ABdhPJw/jjN58A5s1qukp1cQhg5q9f0XbmHI1hMoVT8W6xxqSW27M0pIyJzcLz2T/atPBT/BHeYO6uqzO4MLubHKzPc=
X-Received: by 2002:a17:907:4243:: with SMTP id np3mr69705862ejb.212.1609853008637;
 Tue, 05 Jan 2021 05:23:28 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-4-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-4-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 5 Jan 2021 14:23:17 +0100
Message-ID: <CAMGffEmUNxLuB9y9GrkZ8ek36AH6mkVD=X3+OGwrZ5aXMHfYnQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] pm80xx: check main config table address
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com,
        bjashnani@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 30, 2020 at 5:47 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: akshatzen <akshatzen@google.com>
>
> pm8001 driver initializes main configuration, general status, inbound
> queue and outbound queue table address based on value read from
> MSGU_SCRATCH_PAD_0 register.
>
> We should validate these addresses before dereferencing them.
>
> This change adds two validations:
> 1. Check if main configuration table offset lies within the pcibar
> mapped
> 2. Check if first dword of main configuration table reads "PMCS"
>
> There are two calls to init_pci_device_addresses() done during
> pm8001_pci_probe() in this sequence:
> 1. First inside chip_soft_rst, where if init_pci_device_addresses fails
> we will go ahead assuming MPI state is not ready and reset the device as
> long as bootloader is okay.  This gives chance to second call of
> init_pci_device_addresses to set up the addresses after reset.
>
> 2. The second call is via pm80xx_chip_init, after soft reset is done and
> firmware is checked to be ready. Once that is done we are safe to go
> ahead and initialize default table values and use them.
>
> Tested:
>
> 1. Enabled debugging logs and observed no issues during initialization,
> with a controller with No issues.
>
> pm80xx0:: pm8001_setup_msix 1034: pci_alloc_irq_vectors request ret:64
> no of intr 64
> pm80xx0:: init_pci_device_addresses 917: Scratchpad 0 Offset: 0x2000
> value 0x40002000
> pm80xx0:: init_pci_device_addresses 925: Scratchpad 0 PCI BAR: 0
> pm80xx0:: init_pci_device_addresses 952: VALID main config signature
> 0x53434d50
> pm80xx0:: init_pci_device_addresses 975: GST OFFSET 0xc4
> pm80xx0:: init_pci_device_addresses 978: INBND OFFSET 0x20000128
> pm80xx0:: init_pci_device_addresses 981: OBND OFFSET 0x24000928
> pm80xx0:: init_pci_device_addresses 984: IVT OFFSET 0x8001408
> pm80xx0:: init_pci_device_addresses 987: PSPA OFFSET 0x8001608
> pm80xx0:: init_pci_device_addresses 991: addr - main cfg (ptrval)
> general status (ptrval)
> pm80xx0:: init_pci_device_addresses 995: addr - inbnd (ptrval) obnd
> (ptrval)
> pm80xx0:: init_pci_device_addresses 999: addr - pspa (ptrval) ivt
> (ptrval)
> pm80xx0:: pm80xx_chip_soft_rst 1446: reset register before write : 0x0
> pm80xx0:: pm80xx_chip_soft_rst 1478: reset register after write 0x40
> pm80xx0:: pm80xx_chip_soft_rst 1544: SPCv soft reset Complete
> pm80xx0:: init_pci_device_addresses 917: Scratchpad 0 Offset: 0x2000
> value 0x40002000
> pm80xx0:: init_pci_device_addresses 925: Scratchpad 0 PCI BAR: 0
> pm80xx0:: init_pci_device_addresses 952: VALID main config signature
> 0x53434d50
> pm80xx0:: init_pci_device_addresses 975: GST OFFSET 0xc4
> pm80xx0:: init_pci_device_addresses 978: INBND OFFSET 0x20000128
> pm80xx0:: init_pci_device_addresses 981: OBND OFFSET 0x24000928
> pm80xx0:: init_pci_device_addresses 984: IVT OFFSET 0x8001408
> pm80xx0:: init_pci_device_addresses 987: PSPA OFFSET 0x8001608
> pm80xx0:: init_pci_device_addresses 991: addr - main cfg (ptrval)
> general status (ptrval)
> pm80xx0:: init_pci_device_addresses 995: addr - inbnd (ptrval) obnd
> (ptrval)
> pm80xx0:: init_pci_device_addresses 999: addr - pspa (ptrval) ivt
> (ptrval)
> pm80xx0:: pm80xx_chip_init 1329: MPI initialize successful!
>
> 2. Tested controller with firmware known to have initialization issue
> and observed no crashes with this fix
>
> pm80xx 0000:01:00.0: pm80xx: driver version 0.1.38
> pm80xx 0000:01:00.0: Removing from 1:1 domain
> pm80xx 0000:01:00.0: Requesting non-1:1 mappings
> pm80xx0:: init_pci_device_addresses 948: BAD main config signature 0x0
> pm80xx0:: mpi_uninit_check 1365: Failed to init pci addresses
> pm80xx0:: pm80xx_chip_soft_rst 1435: MPI state is not ready
> scratch:0:8:62a01000:0
> pm80xx0:: pm80xx_chip_soft_rst 1518: Firmware is not ready!
> pm80xx0:: pm80xx_chip_soft_rst 1532: iButton Feature is not Available!!!
> pm80xx0:: pm80xx_chip_init 1301: Firmware is not ready!
> pm80xx0:: pm8001_pci_probe 1215: chip_init failed [ret: -16]
> pm80xx: probe of 0000:01:00.0 failed with error -16
> pm80xx 0000:07:00.0: pm80xx: driver version 0.1.38
> pm80xx 0000:07:00.0: Removing from 1:1 domain
> pm80xx 0000:07:00.0: Requesting non-1:1 mappings
> scsi host6: pm80xx
> pm80xx1:: pm8001_setup_sgpio 5568: failed sgpio_req timeout
> pm80xx1:: mpi_phy_start_resp 3447: phy start resp status:0x0, phyid:0x0
> pm80xx 0000:08:00.0: pm80xx: driver version 0.1.38
> pm80xx 0000:08:00.0: Removing from 1:1 domain
> pm80xx 0000:08:00.0: Requesting non-1:1 mappings
>
> 3. Without this fix we observe crash on the same controller.
>
> pm80xx 0000:01:00.0: pm80xx: driver version 0.1.38
> pm80xx 0000:01:00.0: Removing from 1:1 domain
> pm80xx 0000:01:00.0: Requesting non-1:1 mappings
> [<ffffffffc0451b3b>] pm80xx_chip_soft_rst+0x6b/0x4c0 [pm80xx]
> [<ffffffffc043a933>] pm8001_pci_probe+0xa43/0x1630 [pm80xx]
> RIP: 0010:pm80xx_chip_soft_rst+0x71/0x4c0 [pm80xx]
> [<ffffffffc0451b3b>] ? pm80xx_chip_soft_rst+0x6b/0x4c0 [pm80xx]
> [<ffffffffc043a933>] pm8001_pci_probe+0xa43/0x1630 [pm80xx]
> pm80xx0:: mpi_uninit_check 1339: TIMEOUT:IBDB value/=2
> pm80xx0:: pm80xx_chip_soft_rst 1387: MPI state is not ready
> scratch:0:8:62a01000:0
> pm80xx0:: pm80xx_chip_soft_rst 1470: Firmware is not ready!
> pm80xx0:: pm80xx_chip_soft_rst 1484: iButton Feature is not Available!!!
> pm80xx0:: pm80xx_chip_init 1266: Firmware is not ready!
> pm80xx0:: pm8001_pci_probe 1207: chip_init failed [ret: -16]
> pm80xx: probe of 0000:01:00.0 failed with error -16
>
> Signed-off-by: akshatzen <akshatzen@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 11 +++++---
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 53 ++++++++++++++++++++++++++++++++++++---
>  2 files changed, 58 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index ee2de177d0d0..d21078ca7fb3 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -466,9 +466,12 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
>                         pm8001_ha->io_mem[logicalBar].memvirtaddr =
>                                 ioremap(pm8001_ha->io_mem[logicalBar].membase,
>                                 pm8001_ha->io_mem[logicalBar].memsize);
> -                       pm8001_dbg(pm8001_ha, INIT,
> -                                  "PCI: bar %d, logicalBar %d\n",
> +                       if (!pm8001_ha->io_mem[logicalBar].memvirtaddr) {
> +                               pm8001_dbg(pm8001_ha, INIT,
> +                                       "Failed to ioremap bar %d, logicalBar %d",
>                                    bar, logicalBar);
> +                               return -ENOMEM;
> +                       }
>                         pm8001_dbg(pm8001_ha, INIT,
>                                    "base addr %llx virt_addr=%llx len=%d\n",
>                                    (u64)pm8001_ha->io_mem[logicalBar].membase,
> @@ -540,9 +543,11 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>                         tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
>                                 (unsigned long)&(pm8001_ha->irq_vector[j]));
>  #endif
> -       pm8001_ioremap(pm8001_ha);
> +       if (pm8001_ioremap(pm8001_ha))
> +               goto failed_pci_alloc;
>         if (!pm8001_alloc(pm8001_ha, ent))
>                 return pm8001_ha;
> +failed_pci_alloc:
>         pm8001_free(pm8001_ha);
>         return NULL;
>  }
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 86a3d483749c..7d0eada11d3c 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1115,7 +1115,7 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>         return ret;
>  }
>
> -static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
> +static int init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
>  {
>         void __iomem *base_addr;
>         u32     value;
> @@ -1124,15 +1124,48 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
>         u32     pcilogic;
>
>         value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
> +
> +       /**
> +        * lower 26 bits of SCRATCHPAD0 register describes offset within the
> +        * PCIe BAR where the MPI configuration table is present
> +        */
>         offset = value & 0x03FFFFFF; /* scratch pad 0 TBL address */
>
>         pm8001_dbg(pm8001_ha, DEV, "Scratchpad 0 Offset: 0x%x value 0x%x\n",
>                    offset, value);
> +       /**
> +        * Upper 6 bits describe the offset within PCI config space where BAR
> +        * is located.
> +        */
>         pcilogic = (value & 0xFC000000) >> 26;
>         pcibar = get_pci_bar_index(pcilogic);
>         pm8001_dbg(pm8001_ha, INIT, "Scratchpad 0 PCI BAR: %d\n", pcibar);
> +
> +       /**
> +        * Make sure the offset falls inside the ioremapped PCI BAR
> +        */
> +       if (offset > pm8001_ha->io_mem[pcibar].memsize) {
> +               pm8001_dbg(pm8001_ha, FAIL,
> +                       "Main cfg tbl offset outside %u > %u\n",
> +                               offset, pm8001_ha->io_mem[pcibar].memsize);
> +               return -EBUSY;
> +       }
>         pm8001_ha->main_cfg_tbl_addr = base_addr =
>                 pm8001_ha->io_mem[pcibar].memvirtaddr + offset;
> +
> +       /**
> +        * Validate main configuration table address: first DWord should read
> +        * "PMCS"
> +        */
> +       value = pm8001_mr32(pm8001_ha->main_cfg_tbl_addr, 0);
> +       if (memcmp(&value, "PMCS", 4) != 0) {
> +               pm8001_dbg(pm8001_ha, FAIL,
> +                       "BAD main config signature 0x%x\n",
> +                               value);
> +               return -EBUSY;
> +       }
> +       pm8001_dbg(pm8001_ha, INIT,
> +                       "VALID main config signature 0x%x\n", value);
>         pm8001_ha->general_stat_tbl_addr =
>                 base_addr + (pm8001_cr32(pm8001_ha, pcibar, offset + 0x18) &
>                                         0xFFFFFF);
> @@ -1171,6 +1204,7 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
>         pm8001_dbg(pm8001_ha, INIT, "addr - pspa %p ivt %p\n",
>                    pm8001_ha->pspa_q_tbl_addr,
>                    pm8001_ha->ivt_tbl_addr);
> +       return 0;
>  }
>
>  /**
> @@ -1438,7 +1472,12 @@ static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
>         pm8001_ha->controller_fatal_error = false;
>
>         /* Initialize pci space address eg: mpi offset */
> -       init_pci_device_addresses(pm8001_ha);
> +       ret = init_pci_device_addresses(pm8001_ha);
> +       if (ret) {
> +               pm8001_dbg(pm8001_ha, FAIL,
> +                       "Failed to init pci addresses");
> +               return ret;
> +       }
>         init_default_table_values(pm8001_ha);
>         read_main_config_table(pm8001_ha);
>         read_general_status_table(pm8001_ha);
> @@ -1482,7 +1521,15 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
>         u32 max_wait_count;
>         u32 value;
>         u32 gst_len_mpistate;
> -       init_pci_device_addresses(pm8001_ha);
> +       int ret;
> +
> +       ret = init_pci_device_addresses(pm8001_ha);
> +       if (ret) {
> +               pm8001_dbg(pm8001_ha, FAIL,
> +                       "Failed to init pci addresses");
> +               return ret;
> +       }
> +
>         /* Write bit1=1 to Inbound DoorBell Register to tell the SPC FW the
>         table is stop */
>         pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPCv_MSGU_CFG_TABLE_RESET);
> --
> 2.16.3
>
