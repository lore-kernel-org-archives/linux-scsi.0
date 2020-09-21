Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02317C43463
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 08:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77A9320EDD
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 08:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ToG4+08b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIUIMW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgIUIMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 04:12:21 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C19C061755
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 01:12:20 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d15so12971291lfq.11
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 01:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axyDXZrd9JlbtR6qw9MSYpIK/jHWx2ZuT3u0ZzUibG4=;
        b=ToG4+08brBISgzFqVk/7M+ckKMSgZ+YwURe2ksxJCnfszLrHoec5cua87EmKQQTDQs
         mXVGtxieqwGq6o548BWlIRHe5V9AM9I/tAEtk5dYkKXCId2M0v+HuTJfyQh1E4SMpoI+
         ty+0iit477wLB5oWx9gLcdNuCIcW90cUg+QeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axyDXZrd9JlbtR6qw9MSYpIK/jHWx2ZuT3u0ZzUibG4=;
        b=gLtnbOtIVi9sorB6HpEy2/gHTTseGZUxrh5//MnIIBk7tzwsq1OGW6CkEwOhY3w2QI
         Em7YKlwm6HA6IMbCyfSbWxUJBtgtbaLSdMncFR0Kx78hQWuIp/udqxwO9saOqB6TWkAi
         Stvoo+GIHLtbDbhCwb2KC8eljjtxbdexmpkmJXqdB4FQYO+52jrnlkycNf08jmsy7b3y
         H2kWN6iKw9FcPWOtNwWha3/wtnCr9ECFqVuKN93D6ZIglRO8vxikGMafluf93AZuCwM7
         2h+1k/dhsiIl5aYA/zf5JVKgEr1/zWReLd3SMvU1DJrnPSdKwrAu1CSkos28b77Uj9WT
         Qnqg==
X-Gm-Message-State: AOAM5319h61T2Zp5bbZ8xVYnAfACGdtHfYBJeHimtqLjSKyx7NWgh9Ny
        FRR6fiDt6jFipRVv0olQZulTxtZJ99SjxMGrwRLMGltbcoU=
X-Google-Smtp-Source: ABdhPJw7SG9KJ3kAv/gjmBFppDB0cdeVkrYgPbPqNnsoSyFvgLN8x+dWq302ICZBY/CPcBcCTtyyI303e5jlWEv60Y4=
X-Received: by 2002:a19:7e8d:: with SMTP id z135mr16703947lfc.158.1600675937588;
 Mon, 21 Sep 2020 01:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <a29522ab-6246-00b6-57b9-cd8d7c8766dc@domedata.com>
 <CA+RiK66O-0giupGduKOvTEoSmn1H21u_1ROjqZRGFy4+JX2gmA@mail.gmail.com> <caf5a889-4235-1610-6476-305898d01a75@domedata.com>
In-Reply-To: <caf5a889-4235-1610-6476-305898d01a75@domedata.com>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Mon, 21 Sep 2020 13:46:09 +0530
Message-ID: <CA+RiK67Jt8QP-TMNi_QzcO=12Q51Nqm7UmwGgHP6jOdnu92=-Q@mail.gmail.com>
Subject: Re: bug in mpt3sas vs Lenovo 530-8i
To:     Adam Schrotenboer <adam@domedata.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c2f3ee05afce6832"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c2f3ee05afce6832
Content-Type: text/plain; charset="UTF-8"

HI Adam,

From driver logs, I could see "fw_upload" ioctl command got timeout
and triggered controller reset.
This issue is not due to memset in mpt3sas_ctl.c but with the patch
applied proper command will be
sent to FW.
Please contact Broadcom support team as this needs to be debugged from
the HBA FW side and
support team may also provide the latest FW / access to download
related components.

FW used is very old "02.00.05.00" It is recommended to have the same
phase FW and Driver.
Driver:      [    4.670962] mpt3sas version 31.100.00.00 loaded.
Firmware: [    6.126215] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00).

Thanks,
Suganath

On Fri, Sep 18, 2020 at 11:46 PM Adam Schrotenboer <adam@domedata.com> wrote:
>
> On 09/18/2020 06:45 AM, Suganath Prabu Subramani wrote:
> > Hi Adam,
> >
> > Provide complete driver log with driver logging_level=0x83f8. From the
> > log snippet, I could see the controller reset and it may be due to
> > ioctl timeout also?.
>
> certainly seen "cmd timeout" depending on the kernel version.
>
> > Complete driver log will help to have a better understanding.
> >
> > Thanks,
> > Suganath
> >
> [    0.000000] Linux version 5.4.0-0.bpo.4-amd64
> (debian-kernel@lists.debian.org) (gcc version 8.3.0 (Debian 8.3.0-6)) #1
> SMP Debian 5.4.19-1~bpo10+1 (2020-03-09)
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-5.4.0-0.bpo.4-amd64
> root=UUID=3def0939-f671-431e-9aa4-d6e51dc9afa2 ro
> mpt3sas.logging_level=0x83f8
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating
> point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832
> bytes, using 'compacted' format.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009bfefff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000009bff000-0x0000000009ffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x000000000a000000-0x000000000a1fffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000a200000-0x000000000a212fff]
> ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000000a213000-0x00000000ca43dfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000ca43e000-0x00000000ca792fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ca793000-0x00000000ca8e6fff]
> ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000ca8e7000-0x00000000cafa3fff]
> ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cafa4000-0x00000000cbb63fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cbb64000-0x00000000cbbfefff]
> type 20
> [    0.000000] BIOS-e820: [mem 0x00000000cbbff000-0x00000000ccffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cd000000-0x00000000cfffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fd100000-0x00000000fd1fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fd300000-0x00000000fd4fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000fea0ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feb80000-0x00000000fec01fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fedc2000-0x00000000fedcffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fedd4000-0x00000000fedd5fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000102f37ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000102f380000-0x000000102fffffff]
> reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] efi: EFI v2.70 by American Megatrends
> [    0.000000] efi:  ACPI=0xca8e6000  ACPI 2.0=0xca8e6014
> SMBIOS=0xcba0d000  SMBIOS 3.0=0xcba0c000  MEMATTR=0xc5f5e018
> ESRT=0xc885f218
> [    0.000000] secureboot: Secure boot could not be determined (mode 0)
> [    0.000000] SMBIOS 3.2.0 present.
> [    0.000000] DMI: System manufacturer System Product Name/PRIME
> X570-PRO, BIOS 2606 08/13/2020
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 3892.736 MHz processor
> [    0.000963] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000964] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000968] last_pfn = 0x102f380 max_arch_pfn = 0x400000000
> [    0.000971] MTRR default type: uncachable
> [    0.000971] MTRR fixed ranges enabled:
> [    0.000971]   00000-9FFFF write-back
> [    0.000972]   A0000-BFFFF write-through
> [    0.000972]   C0000-FFFFF write-protect
> [    0.000973] MTRR variable ranges enabled:
> [    0.000973]   0 base 000000000000 mask FFFF80000000 write-back
> [    0.000974]   1 base 000080000000 mask FFFFC0000000 write-back
> [    0.000974]   2 base 0000C0000000 mask FFFFF0000000 write-back
> [    0.000975]   3 base 0000CB320000 mask FFFFFFFF0000 uncachable
> [    0.000975]   4 disabled
> [    0.000975]   5 disabled
> [    0.000975]   6 disabled
> [    0.000976]   7 disabled
> [    0.000976] TOM2: 0000001030000000 aka 66304M
> [    0.001753] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC-
> WT
> [    0.001909] e820: update [mem 0xcb320000-0xcb32ffff] usable ==> reserved
> [    0.001911] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
> [    0.001913] last_pfn = 0xcd000 max_arch_pfn = 0x400000000
> [    0.004742] esrt: Reserving ESRT space from 0x00000000c885f218 to
> 0x00000000c885f250.
> [    0.004747] e820: update [mem 0xc885f000-0xc885ffff] usable ==> reserved
> [    0.004758] Using GB pages for direct mapping
> [    0.004760] BRK [0xc54801000, 0xc54801fff] PGTABLE
> [    0.004761] BRK [0xc54802000, 0xc54802fff] PGTABLE
> [    0.004762] BRK [0xc54803000, 0xc54803fff] PGTABLE
> [    0.004773] BRK [0xc54804000, 0xc54804fff] PGTABLE
> [    0.004773] BRK [0xc54805000, 0xc54805fff] PGTABLE
> [    0.004774] BRK [0xc54806000, 0xc54806fff] PGTABLE
> [    0.004888] BRK [0xc54807000, 0xc54807fff] PGTABLE
> [    0.004902] BRK [0xc54808000, 0xc54808fff] PGTABLE
> [    0.004916] BRK [0xc54809000, 0xc54809fff] PGTABLE
> [    0.004940] BRK [0xc5480a000, 0xc5480afff] PGTABLE
> [    0.004985] BRK [0xc5480b000, 0xc5480bfff] PGTABLE
> [    0.005054] BRK [0xc5480c000, 0xc5480cfff] PGTABLE
> [    0.005095] RAMDISK: [mem 0x370a9000-0x3784bfff]
> [    0.005101] ACPI: Early table checksum verification disabled
> [    0.005104] ACPI: RSDP 0x00000000CA8E6014 000024 (v02 ALASKA)
> [    0.005106] ACPI: XSDT 0x00000000CA8E5728 0000BC (v01 ALASKA A M I
> 01072009 AMI  01000013)
> [    0.005110] ACPI: FACP 0x00000000CA8D6000 000114 (v06 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.005113] ACPI: DSDT 0x00000000CA8C7000 00E2F5 (v02 ALASKA A M I
> 01072009 INTL 20120913)
> [    0.005115] ACPI: FACS 0x00000000CAF87000 000040
> [    0.005116] ACPI: SSDT 0x00000000CA8DC000 008C98 (v02 AMD    AmdTable
> 00000002 MSFT 04000000)
> [    0.005118] ACPI: SSDT 0x00000000CA8D8000 003ACB (v01 AMD    AMD AOD
> 00000001 INTL 20120913)
> [    0.005120] ACPI: SSDT 0x00000000CA8D7000 0000FC (v02 ALASKA CPUSSDT
> 01072009 AMI  01072009)
> [    0.005121] ACPI: FIDT 0x00000000CA8C6000 00009C (v01 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.005123] ACPI: FPDT 0x00000000CA7D8000 000044 (v01 ALASKA A M I
> 01072009 AMI  01000013)
> [    0.005124] ACPI: MCFG 0x00000000CA8C4000 00003C (v01 ALASKA A M I
> 01072009 MSFT 00010013)
> [    0.005126] ACPI: HPET 0x00000000CA8C3000 000038 (v01 ALASKA A M I
> 01072009 AMI  00000005)
> [    0.005127] ACPI: SSDT 0x00000000CA8C2000 000024 (v01 AMD    BIXBY
> 00001000 INTL 20120913)
> [    0.005129] ACPI: BGRT 0x00000000CA8C0000 000038 (v01 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.005130] ACPI: WPBT 0x00000000CA7E7000 00003C (v01 ALASKA A M I
> 00000001 ASUS 00000001)
> [    0.005132] ACPI: PCCT 0x00000000CA7E6000 00006E (v02 AMD    AmdTable
> 00000001 AMD  00000000)
> [    0.005133] ACPI: SSDT 0x00000000CA7E2000 003EC9 (v02 AMD    AmdTable
> 00000001 AMD  00000001)
> [    0.005135] ACPI: CRAT 0x00000000CA7E1000 000ED8 (v01 AMD    AmdTable
> 00000001 AMD  00000001)
> [    0.005136] ACPI: CDIT 0x00000000CA7E0000 000029 (v01 AMD    AmdTable
> 00000001 AMD  00000001)
> [    0.005138] ACPI: SSDT 0x00000000CA7DF000 00052C (v01 AMD    QOGIRNOI
> 00000001 INTL 20120913)
> [    0.005139] ACPI: SSDT 0x00000000CA7DB000 003445 (v01 AMD    QOGIRN
> 00000001 INTL 20120913)
> [    0.005141] ACPI: WSMT 0x00000000CA7DA000 000028 (v01 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.005142] ACPI: APIC 0x00000000CA7D9000 00015E (v03 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.005147] ACPI: Local APIC address 0xfee00000
> [    0.005223] No NUMA configuration found
> [    0.005224] Faking a node at [mem 0x0000000000000000-0x000000102f37ffff]
> [    0.005226] NODE_DATA(0) allocated [mem 0x102f37b000-0x102f37ffff]
> [    0.005267] Zone ranges:
> [    0.005268]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.005269]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.005270]   Normal   [mem 0x0000000100000000-0x000000102f37ffff]
> [    0.005270]   Device   empty
> [    0.005271] Movable zone start for each node
> [    0.005271] Early memory node ranges
> [    0.005272]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
> [    0.005273]   node   0: [mem 0x0000000000100000-0x0000000009bfefff]
> [    0.005273]   node   0: [mem 0x000000000a000000-0x000000000a1fffff]
> [    0.005274]   node   0: [mem 0x000000000a213000-0x00000000ca43dfff]
> [    0.005274]   node   0: [mem 0x00000000cbbff000-0x00000000ccffffff]
> [    0.005275]   node   0: [mem 0x0000000100000000-0x000000102f37ffff]
> [    0.005377] Zeroed struct page in unavailable ranges: 22710 pages
> [    0.005378] Initmem setup node 0 [mem
> 0x0000000000001000-0x000000102f37ffff]
> [    0.005379] On node 0 totalpages: 16754506
> [    0.005380]   DMA zone: 64 pages used for memmap
> [    0.005380]   DMA zone: 50 pages reserved
> [    0.005381]   DMA zone: 3999 pages, LIFO batch:0
> [    0.005412]   DMA32 zone: 12945 pages used for memmap
> [    0.005413]   DMA32 zone: 828459 pages, LIFO batch:63
> [    0.012604]   Normal zone: 248782 pages used for memmap
> [    0.012606]   Normal zone: 15922048 pages, LIFO batch:63
> [    0.134874] ACPI: PM-Timer IO Port: 0x808
> [    0.134877] ACPI: Local APIC address 0xfee00000
> [    0.134882] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.134894] IOAPIC[0]: apic_id 17, version 33, address 0xfec00000,
> GSI 0-23
> [    0.134899] IOAPIC[1]: apic_id 18, version 33, address 0xfec01000,
> GSI 24-55
> [    0.134900] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.134901] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.134902] ACPI: IRQ0 used by override.
> [    0.134903] ACPI: IRQ9 used by override.
> [    0.134904] Using ACPI (MADT) for SMP configuration information
> [    0.134905] ACPI: HPET id: 0x10228201 base: 0xfed00000
> [    0.134913] e820: update [mem 0xc5a27000-0xc5a6cfff] usable ==> reserved
> [    0.134920] smpboot: Allowing 32 CPUs, 16 hotplug CPUs
> [    0.134938] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.134939] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
> [    0.134940] PM: Registered nosave memory: [mem 0x09bff000-0x09ffffff]
> [    0.134941] PM: Registered nosave memory: [mem 0x0a200000-0x0a212fff]
> [    0.134942] PM: Registered nosave memory: [mem 0xc5a27000-0xc5a6cfff]
> [    0.134943] PM: Registered nosave memory: [mem 0xc885f000-0xc885ffff]
> [    0.134944] PM: Registered nosave memory: [mem 0xca43e000-0xca792fff]
> [    0.134945] PM: Registered nosave memory: [mem 0xca793000-0xca8e6fff]
> [    0.134945] PM: Registered nosave memory: [mem 0xca8e7000-0xcafa3fff]
> [    0.134946] PM: Registered nosave memory: [mem 0xcafa4000-0xcbb63fff]
> [    0.134946] PM: Registered nosave memory: [mem 0xcbb64000-0xcbbfefff]
> [    0.134947] PM: Registered nosave memory: [mem 0xcd000000-0xcfffffff]
> [    0.134948] PM: Registered nosave memory: [mem 0xd0000000-0xefffffff]
> [    0.134948] PM: Registered nosave memory: [mem 0xf0000000-0xf7ffffff]
> [    0.134948] PM: Registered nosave memory: [mem 0xf8000000-0xfd0fffff]
> [    0.134949] PM: Registered nosave memory: [mem 0xfd100000-0xfd1fffff]
> [    0.134949] PM: Registered nosave memory: [mem 0xfd200000-0xfd2fffff]
> [    0.134950] PM: Registered nosave memory: [mem 0xfd300000-0xfd4fffff]
> [    0.134950] PM: Registered nosave memory: [mem 0xfd500000-0xfe9fffff]
> [    0.134951] PM: Registered nosave memory: [mem 0xfea00000-0xfea0ffff]
> [    0.134951] PM: Registered nosave memory: [mem 0xfea10000-0xfeb7ffff]
> [    0.134951] PM: Registered nosave memory: [mem 0xfeb80000-0xfec01fff]
> [    0.134952] PM: Registered nosave memory: [mem 0xfec02000-0xfec0ffff]
> [    0.134952] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
> [    0.134953] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
> [    0.134953] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
> [    0.134953] PM: Registered nosave memory: [mem 0xfed01000-0xfed3ffff]
> [    0.134954] PM: Registered nosave memory: [mem 0xfed40000-0xfed44fff]
> [    0.134954] PM: Registered nosave memory: [mem 0xfed45000-0xfed7ffff]
> [    0.134955] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
> [    0.134955] PM: Registered nosave memory: [mem 0xfed90000-0xfedc1fff]
> [    0.134955] PM: Registered nosave memory: [mem 0xfedc2000-0xfedcffff]
> [    0.134956] PM: Registered nosave memory: [mem 0xfedd0000-0xfedd3fff]
> [    0.134956] PM: Registered nosave memory: [mem 0xfedd4000-0xfedd5fff]
> [    0.134957] PM: Registered nosave memory: [mem 0xfedd6000-0xfeffffff]
> [    0.134957] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
> [    0.134959] [mem 0xd0000000-0xefffffff] available for PCI devices
> [    0.134960] Booting paravirtualized kernel on bare hardware
> [    0.134962] clocksource: refined-jiffies: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
> [    0.191478] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
> nr_cpu_ids:32 nr_node_ids:1
> [    0.192368] percpu: Embedded 53 pages/cpu s178584 r8192 d30312 u262144
> [    0.192374] pcpu-alloc: s178584 r8192 d30312 u262144 alloc=1*2097152
> [    0.192374] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11
> 12 13 14 15
> [    0.192377] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 [0] 24 25 26 27
> 28 29 30 31
> [    0.192398] Built 1 zonelists, mobility grouping on.  Total pages:
> 16492665
> [    0.192398] Policy zone: Normal
> [    0.192399] Kernel command line:
> BOOT_IMAGE=/vmlinuz-5.4.0-0.bpo.4-amd64
> root=UUID=3def0939-f671-431e-9aa4-d6e51dc9afa2 ro
> mpt3sas.logging_level=0x83f8
> [    0.192426] printk: log_buf_len individual max cpu contribution: 4096
> bytes
> [    0.192427] printk: log_buf_len total cpu_extra contributions: 126976
> bytes
> [    0.192427] printk: log_buf_len min size: 131072 bytes
> [    0.192451] printk: log_buf_len: 262144 bytes
> [    0.192452] printk: early log buf free: 116708(89%)
> [    0.197371] Dentry cache hash table entries: 8388608 (order: 14,
> 67108864 bytes, linear)
> [    0.199963] Inode-cache hash table entries: 4194304 (order: 13,
> 33554432 bytes, linear)
> [    0.200022] mem auto-init: stack:off, heap alloc:off, heap free:off
> [    0.204895] Calgary: detecting Calgary via BIOS EBDA area
> [    0.204897] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.298570] Memory: 65697280K/67018024K available (10243K kernel
> code, 1188K rwdata, 3752K rodata, 1664K init, 2064K bss, 1320744K
> reserved, 0K cma-reserved)
> [    0.298734] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
> [    0.298746] ftrace: allocating 33964 entries in 133 pages
> [    0.306293] rcu: Hierarchical RCU implementation.
> [    0.306294] rcu:     RCU restricting CPUs from NR_CPUS=512 to
> nr_cpu_ids=32.
> [    0.306295] rcu: RCU calculated value of scheduler-enlistment delay
> is 25 jiffies.
> [    0.306295] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=32
> [    0.307868] NR_IRQS: 33024, nr_irqs: 1224, preallocated irqs: 16
> [    0.308152] random: crng done (trusting CPU's manufacturer)
> [    0.308173] Console: colour dummy device 80x25
> [    0.308300] printk: console [tty0] enabled
> [    0.308314] ACPI: Core revision 20190816
> [    0.308436] clocksource: hpet: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 133484873504 ns
> [    0.308451] APIC: Switch to symmetric I/O mode setup
> [    0.308454] Switched APIC routing to physical flat.
> [    0.309052] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.328453] clocksource: tsc-early: mask: 0xffffffffffffffff
> max_cycles: 0x7039182c1a4, max_idle_ns: 881590644438 ns
> [    0.328456] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 7785.47 BogoMIPS (lpj=15570944)
> [    0.328458] pid_max: default: 32768 minimum: 301
> [    0.330001] LSM: Security Framework initializing
> [    0.330005] Yama: disabled by default; enable with sysctl kernel.yama.*
> [    0.330030] AppArmor: AppArmor initialized
> [    0.330031] TOMOYO Linux initialized
> [    0.330130] Mount-cache hash table entries: 131072 (order: 8, 1048576
> bytes, linear)
> [    0.330212] Mountpoint-cache hash table entries: 131072 (order: 8,
> 1048576 bytes, linear)
> [    0.330386] x86/cpu: User Mode Instruction Prevention (UMIP) activated
> [    0.330430] LVT offset 1 assigned for vector 0xf9
> [    0.330658] LVT offset 2 assigned for vector 0xf4
> [    0.330693] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
> [    0.330694] Last level dTLB entries: 4KB 2048, 2MB 2048, 4MB 1024, 1GB 0
> [    0.330697] Spectre V1 : Mitigation: usercopy/swapgs barriers and
> __user pointer sanitization
> [    0.330698] Spectre V2 : Mitigation: Full AMD retpoline
> [    0.330699] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling
> RSB on context switch
> [    0.330701] Spectre V2 : mitigation: Enabling conditional Indirect
> Branch Prediction Barrier
> [    0.330703] Spectre V2 : User space: Mitigation: STIBP via seccomp
> and prctl
> [    0.330704] Speculative Store Bypass: Mitigation: Speculative Store
> Bypass disabled via prctl and seccomp
> [    0.330838] Freeing SMP alternatives memory: 24K
> [    0.444261] smpboot: CPU0: AMD Ryzen 7 3800XT 8-Core Processor
> (family: 0x17, model: 0x71, stepping: 0x0)
> [    0.444332] Performance Events: Fam17h core perfctr, AMD PMU driver.
> [    0.444335] ... version:                0
> [    0.444336] ... bit width:              48
> [    0.444337] ... generic registers:      6
> [    0.444337] ... value mask:             0000ffffffffffff
> [    0.444338] ... max period:             00007fffffffffff
> [    0.444339] ... fixed-purpose events:   0
> [    0.444340] ... event mask:             000000000000003f
> [    0.444358] rcu: Hierarchical SRCU implementation.
> [    0.444454] NMI watchdog: Enabled. Permanently consumes one hw-PMU
> counter.
> [    0.444454] smp: Bringing up secondary CPUs ...
> [    0.444454] x86: Booting SMP configuration:
> [    0.444454] .... node  #0, CPUs:        #1
> [    0.004410] do_IRQ: 1.55 No irq handler for vector
> [    0.444454]   #2
> [    0.004410] do_IRQ: 2.55 No irq handler for vector
> [    0.444498]   #3
> [    0.004410] do_IRQ: 3.55 No irq handler for vector
> [    0.446607]   #4
> [    0.004410] do_IRQ: 4.55 No irq handler for vector
> [    0.448500]   #5
> [    0.004410] do_IRQ: 5.55 No irq handler for vector
> [    0.452498]   #6
> [    0.004410] do_IRQ: 6.55 No irq handler for vector
> [    0.454643]   #7
> [    0.004410] do_IRQ: 7.55 No irq handler for vector
> [    0.456496]   #8
> [    0.004410] do_IRQ: 8.55 No irq handler for vector
> [    0.458649]   #9
> [    0.004410] do_IRQ: 9.55 No irq handler for vector
> [    0.460500]  #10
> [    0.004410] do_IRQ: 10.55 No irq handler for vector
> [    0.462594]  #11 #12 #13 #14 #15
> [    0.474639] smp: Brought up 1 node, 16 CPUs
> [    0.474639] smpboot: Max logical packages: 2
> [    0.474639] smpboot: Total of 16 processors activated (124567.55
> BogoMIPS)
> [    0.476680] devtmpfs: initialized
> [    0.476680] x86/mm: Memory block size: 128MB
> [    0.481256] PM: Registering ACPI NVS region [mem
> 0x0a200000-0x0a212fff] (77824 bytes)
> [    0.481256] PM: Registering ACPI NVS region [mem
> 0xca8e7000-0xcafa3fff] (7065600 bytes)
> [    0.481256] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.481256] futex hash table entries: 8192 (order: 7, 524288 bytes,
> linear)
> [    0.481256] pinctrl core: initialized pinctrl subsystem
> [    0.481256] NET: Registered protocol family 16
> [    0.481256] audit: initializing netlink subsys (disabled)
> [    0.481256] audit: type=2000 audit(1600450966.172:1):
> state=initialized audit_enabled=0 res=1
> [    0.481256] cpuidle: using governor ladder
> [    0.481256] cpuidle: using governor menu
> [    0.481256] Detected 1 PCC Subspaces
> [    0.481256] Registering PCC driver as Mailbox controller
> [    0.481256] ACPI: bus type PCI registered
> [    0.481256] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.481256] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem
> 0xf0000000-0xf7ffffff] (base 0xf0000000)
> [    0.481256] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
> [    0.481256] PCI: Using configuration type 1 for base access
> [    0.484605] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
> [    0.484605] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    0.556478] ACPI: Added _OSI(Module Device)
> [    0.556480] ACPI: Added _OSI(Processor Device)
> [    0.556481] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.556482] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.556483] ACPI: Added _OSI(Linux-Dell-Video)
> [    0.556484] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
> [    0.556485] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
> [    0.562483] ACPI: 8 ACPI AML tables successfully acquired and loaded
> [    0.563226] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
> [    0.564497] ACPI: EC: EC started
> [    0.564498] ACPI: EC: interrupt blocked
> [    0.564534] ACPI: \_SB_.PCI0.SBRG.EC0_: Used as first EC
> [    0.564536] ACPI: \_SB_.PCI0.SBRG.EC0_: GPE=0x2, EC_CMD/EC_SC=0x66,
> EC_DATA=0x62
> [    0.564537] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC used to handle
> transactions
> [    0.564538] ACPI: Interpreter enabled
> [    0.564548] ACPI: (supports S0 S3 S4 S5)
> [    0.564549] ACPI: Using IOAPIC for interrupt routing
> [    0.564741] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=nocrs" and report a bug
> [    0.564893] ACPI: Enabled 2 GPEs in block 00 to 1F
> [    0.568090] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.568090] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
> ClockPM Segments MSI HPX-Type3]
> [    0.568090] acpi PNP0A08:00: _OSC: platform does not support
> [PCIeHotplug SHPCHotplug PME LTR]
> [    0.568090] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
> [    0.568090] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain
> 0000 [bus 00-7f] only partially covers this bridge
> [    0.568090] PCI host bridge to bus 0000:00
> [    0.568090] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
> [    0.568090] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
> [    0.568090] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
> [    0.568090] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.568090] pci_bus 0000:00: root bus resource [mem
> 0x000a0000-0x000bffff window]
> [    0.568090] pci_bus 0000:00: root bus resource [mem
> 0x000c0000-0x000dffff window]
> [    0.568090] pci_bus 0000:00: root bus resource [mem
> 0xd0000000-0xfec02fff window]
> [    0.568090] pci_bus 0000:00: root bus resource [mem
> 0xfee00000-0xffffffff window]
> [    0.568090] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.568090] pci 0000:00:00.0: [1022:1480] type 00 class 0x060000
> [    0.568090] pci 0000:00:01.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:01.2: [1022:1483] type 01 class 0x060400
> [    0.568090] pci 0000:00:01.2: enabling Extended Tags
> [    0.568090] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
> [    0.568090] pci 0000:00:02.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:03.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:03.2: [1022:1483] type 01 class 0x060400
> [    0.568090] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
> [    0.568090] pci 0000:00:04.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:05.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:07.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:07.1: [1022:1484] type 01 class 0x060400
> [    0.568090] pci 0000:00:07.1: enabling Extended Tags
> [    0.568090] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
> [    0.568090] pci 0000:00:08.0: [1022:1482] type 00 class 0x060000
> [    0.568090] pci 0000:00:08.1: [1022:1484] type 01 class 0x060400
> [    0.568090] pci 0000:00:08.1: enabling Extended Tags
> [    0.568090] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
> [    0.568090] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
> [    0.568090] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
> [    0.568090] pci 0000:00:18.0: [1022:1440] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.1: [1022:1441] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.2: [1022:1442] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.3: [1022:1443] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.4: [1022:1444] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.5: [1022:1445] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.6: [1022:1446] type 00 class 0x060000
> [    0.568090] pci 0000:00:18.7: [1022:1447] type 00 class 0x060000
> [    0.568090] pci 0000:01:00.0: [1022:57ad] type 01 class 0x060400
> [    0.568090] pci 0000:01:00.0: enabling Extended Tags
> [    0.568090] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> [    0.568090] pci 0000:01:00.0: 63.012 Gb/s available PCIe bandwidth,
> limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 126.024 Gb/s with
> 16 GT/s x8 link)
> [    0.568090] pci 0000:00:01.2: PCI bridge to [bus 01-08]
> [    0.568090] pci 0000:00:01.2:   bridge window [io  0xd000-0xefff]
> [    0.568090] pci 0000:00:01.2:   bridge window [mem 0xfbf00000-0xfcafffff]
> [    0.568090] pci 0000:00:01.2:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> [    0.568461] pci 0000:02:02.0: [1022:57a3] type 01 class 0x060400
> [    0.568568] pci 0000:02:02.0: enabling Extended Tags
> [    0.568790] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
> [    0.569009] pci 0000:02:05.0: [1022:57a3] type 01 class 0x060400
> [    0.569116] pci 0000:02:05.0: enabling Extended Tags
> [    0.569337] pci 0000:02:05.0: PME# supported from D0 D3hot D3cold
> [    0.569557] pci 0000:02:06.0: [1022:57a3] type 01 class 0x060400
> [    0.569663] pci 0000:02:06.0: enabling Extended Tags
> [    0.569884] pci 0000:02:06.0: PME# supported from D0 D3hot D3cold
> [    0.570093] pci 0000:02:08.0: [1022:57a4] type 01 class 0x060400
> [    0.570185] pci 0000:02:08.0: enabling Extended Tags
> [    0.570339] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
> [    0.570490] pci 0000:02:09.0: [1022:57a4] type 01 class 0x060400
> [    0.570582] pci 0000:02:09.0: enabling Extended Tags
> [    0.570736] pci 0000:02:09.0: PME# supported from D0 D3hot D3cold
> [    0.570878] pci 0000:02:0a.0: [1022:57a4] type 01 class 0x060400
> [    0.570970] pci 0000:02:0a.0: enabling Extended Tags
> [    0.571124] pci 0000:02:0a.0: PME# supported from D0 D3hot D3cold
> [    0.571290] pci 0000:01:00.0: PCI bridge to [bus 02-08]
> [    0.571297] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
> [    0.571300] pci 0000:01:00.0:   bridge window [mem 0xfbf00000-0xfcafffff]
> [    0.571307] pci 0000:01:00.0:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> [    0.571398] pci 0000:03:00.0: [1657:0014] type 00 class 0x0c0400
> [    0.571436] pci 0000:03:00.0: reg 0x10: [mem 0xfc3c0000-0xfc3fffff 64bit]
> [    0.571454] pci 0000:03:00.0: reg 0x18: [mem 0xfc40c000-0xfc40ffff 64bit]
> [    0.571487] pci 0000:03:00.0: reg 0x30: [mem 0xfc200000-0xfc2fffff pref]
> [    0.571578] pci 0000:03:00.0: PME# supported from D0 D3hot
> [    0.571639] pci 0000:03:00.0: 16.000 Gb/s available PCIe bandwidth,
> limited by 5 GT/s x4 link at 0000:02:02.0 (capable of 32.000 Gb/s with 5
> GT/s x8 link)
> [    0.571687] pci 0000:03:00.1: [1657:0014] type 00 class 0x0c0400
> [    0.571723] pci 0000:03:00.1: reg 0x10: [mem 0xfc380000-0xfc3bffff 64bit]
> [    0.571741] pci 0000:03:00.1: reg 0x18: [mem 0xfc408000-0xfc40bfff 64bit]
> [    0.571775] pci 0000:03:00.1: reg 0x30: [mem 0xfc100000-0xfc1fffff pref]
> [    0.571858] pci 0000:03:00.1: PME# supported from D0 D3hot
> [    0.571933] pci 0000:03:00.2: [1657:0014] type 00 class 0x020000
> [    0.571969] pci 0000:03:00.2: reg 0x10: [mem 0xfc340000-0xfc37ffff 64bit]
> [    0.571987] pci 0000:03:00.2: reg 0x18: [mem 0xfc404000-0xfc407fff 64bit]
> [    0.572020] pci 0000:03:00.2: reg 0x30: [mem 0xfc000000-0xfc0fffff pref]
> [    0.572102] pci 0000:03:00.2: PME# supported from D0 D3hot
> [    0.572177] pci 0000:03:00.3: [1657:0014] type 00 class 0x020000
> [    0.572213] pci 0000:03:00.3: reg 0x10: [mem 0xfc300000-0xfc33ffff 64bit]
> [    0.572231] pci 0000:03:00.3: reg 0x18: [mem 0xfc400000-0xfc403fff 64bit]
> [    0.572265] pci 0000:03:00.3: reg 0x30: [mem 0xfbf00000-0xfbffffff pref]
> [    0.572346] pci 0000:03:00.3: PME# supported from D0 D3hot
> [    0.572521] pci 0000:02:02.0: PCI bridge to [bus 03]
> [    0.572530] pci 0000:02:02.0:   bridge window [mem 0xfbf00000-0xfc4fffff]
> [    0.572638] pci 0000:04:00.0: [8086:1539] type 00 class 0x020000
> [    0.572682] pci 0000:04:00.0: reg 0x10: [mem 0xfca00000-0xfca1ffff]
> [    0.572716] pci 0000:04:00.0: reg 0x18: [io  0xe000-0xe01f]
> [    0.572733] pci 0000:04:00.0: reg 0x1c: [mem 0xfca20000-0xfca23fff]
> [    0.572908] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
> [    0.573088] pci 0000:02:05.0: PCI bridge to [bus 04]
> [    0.573094] pci 0000:02:05.0:   bridge window [io  0xe000-0xefff]
> [    0.573098] pci 0000:02:05.0:   bridge window [mem 0xfca00000-0xfcafffff]
> [    0.573198] pci 0000:05:00.0: [1002:7143] type 00 class 0x030000
> [    0.573240] pci 0000:05:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff
> 64bit pref]
> [    0.573264] pci 0000:05:00.0: reg 0x18: [mem 0xfc930000-0xfc93ffff 64bit]
> [    0.573279] pci 0000:05:00.0: reg 0x20: [io  0xd000-0xd0ff]
> [    0.573308] pci 0000:05:00.0: reg 0x30: [mem 0xfc900000-0xfc91ffff pref]
> [    0.573320] pci 0000:05:00.0: enabling Extended Tags
> [    0.573332] pci 0000:05:00.0: BAR 0: assigned to efifb
> [    0.573399] pci 0000:05:00.0: supports D1 D2
> [    0.573440] pci 0000:05:00.0: 2.000 Gb/s available PCIe bandwidth,
> limited by 2.5 GT/s x1 link at 0000:02:06.0 (capable of 32.000 Gb/s with
> 2.5 GT/s x16 link)
> [    0.573488] pci 0000:05:00.1: [1002:7163] type 00 class 0x038000
> [    0.573524] pci 0000:05:00.1: reg 0x10: [mem 0xfc920000-0xfc92ffff 64bit]
> [    0.573642] pci 0000:05:00.1: supports D1 D2
> [    0.573696] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.
> You can enable it with 'pcie_aspm=force'
> [    0.573710] pci 0000:02:06.0: PCI bridge to [bus 05]
> [    0.573716] pci 0000:02:06.0:   bridge window [io  0xd000-0xdfff]
> [    0.573720] pci 0000:02:06.0:   bridge window [mem 0xfc900000-0xfc9fffff]
> [    0.573727] pci 0000:02:06.0:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> [    0.573832] pci 0000:06:00.0: [1022:1485] type 00 class 0x130000
> [    0.573913] pci 0000:06:00.0: enabling Extended Tags
> [    0.574047] pci 0000:06:00.0: 63.012 Gb/s available PCIe bandwidth,
> limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 252.048 Gb/s with
> 16 GT/s x16 link)
> [    0.574178] pci 0000:06:00.1: [1022:149c] type 00 class 0x0c0330
> [    0.574573] pci 0000:06:00.1: reg 0x10: [mem 0xfc600000-0xfc6fffff 64bit]
> [    0.575310] pci 0000:06:00.1: enabling Extended Tags
> [    0.575941] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
> [    0.576218] pci 0000:06:00.3: [1022:149c] type 00 class 0x0c0330
> [    0.576252] pci 0000:06:00.3: reg 0x10: [mem 0xfc500000-0xfc5fffff 64bit]
> [    0.576311] pci 0000:06:00.3: enabling Extended Tags
> [    0.576385] pci 0000:06:00.3: PME# supported from D0 D3hot D3cold
> [    0.576527] pci 0000:02:08.0: PCI bridge to [bus 06]
> [    0.576536] pci 0000:02:08.0:   bridge window [mem 0xfc500000-0xfc6fffff]
> [    0.576628] pci 0000:07:00.0: [1022:7901] type 00 class 0x010601
> [    0.576712] pci 0000:07:00.0: reg 0x24: [mem 0xfc800000-0xfc8007ff]
> [    0.576732] pci 0000:07:00.0: enabling Extended Tags
> [    0.576824] pci 0000:07:00.0: PME# supported from D3hot D3cold
> [    0.576886] pci 0000:07:00.0: 63.012 Gb/s available PCIe bandwidth,
> limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 252.048 Gb/s with
> 16 GT/s x16 link)
> [    0.576958] pci 0000:02:09.0: PCI bridge to [bus 07]
> [    0.576967] pci 0000:02:09.0:   bridge window [mem 0xfc800000-0xfc8fffff]
> [    0.577059] pci 0000:08:00.0: [1022:7901] type 00 class 0x010601
> [    0.577143] pci 0000:08:00.0: reg 0x24: [mem 0xfc700000-0xfc7007ff]
> [    0.577162] pci 0000:08:00.0: enabling Extended Tags
> [    0.577254] pci 0000:08:00.0: PME# supported from D3hot D3cold
> [    0.577315] pci 0000:08:00.0: 63.012 Gb/s available PCIe bandwidth,
> limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 252.048 Gb/s with
> 16 GT/s x16 link)
> [    0.577387] pci 0000:02:0a.0: PCI bridge to [bus 08]
> [    0.577395] pci 0000:02:0a.0:   bridge window [mem 0xfc700000-0xfc7fffff]
> [    0.577477] pci 0000:09:00.0: [1000:00af] type 00 class 0x010700
> [    0.577506] pci 0000:09:00.0: reg 0x10: [mem 0xe0100000-0xe01fffff
> 64bit pref]
> [    0.577518] pci 0000:09:00.0: reg 0x18: [mem 0xe0000000-0xe00fffff
> 64bit pref]
> [    0.577526] pci 0000:09:00.0: reg 0x20: [mem 0xfcf00000-0xfcffffff]
> [    0.577535] pci 0000:09:00.0: reg 0x24: [io  0xf000-0xf0ff]
> [    0.577543] pci 0000:09:00.0: reg 0x30: [mem 0xfce00000-0xfcefffff pref]
> [    0.577606] pci 0000:09:00.0: supports D1 D2
> [    0.577687] pci 0000:00:03.2: PCI bridge to [bus 09]
> [    0.577691] pci 0000:00:03.2:   bridge window [io  0xf000-0xffff]
> [    0.577693] pci 0000:00:03.2:   bridge window [mem 0xfce00000-0xfcffffff]
> [    0.577697] pci 0000:00:03.2:   bridge window [mem
> 0xe0000000-0xe01fffff 64bit pref]
> [    0.577727] pci 0000:0a:00.0: [1022:148a] type 00 class 0x130000
> [    0.577761] pci 0000:0a:00.0: enabling Extended Tags
> [    0.577856] pci 0000:00:07.1: PCI bridge to [bus 0a]
> [    0.577899] pci 0000:0b:00.0: [1022:1485] type 00 class 0x130000
> [    0.577939] pci 0000:0b:00.0: enabling Extended Tags
> [    0.578026] pci 0000:0b:00.1: [1022:1486] type 00 class 0x108000
> [    0.578048] pci 0000:0b:00.1: reg 0x18: [mem 0xfcc00000-0xfccfffff]
> [    0.578059] pci 0000:0b:00.1: reg 0x24: [mem 0xfcd00000-0xfcd01fff]
> [    0.578068] pci 0000:0b:00.1: enabling Extended Tags
> [    0.578149] pci 0000:0b:00.3: [1022:149c] type 00 class 0x0c0330
> [    0.578168] pci 0000:0b:00.3: reg 0x10: [mem 0xfcb00000-0xfcbfffff 64bit]
> [    0.578198] pci 0000:0b:00.3: enabling Extended Tags
> [    0.578241] pci 0000:0b:00.3: PME# supported from D0 D3hot D3cold
> [    0.578311] pci 0000:00:08.1: PCI bridge to [bus 0b]
> [    0.578316] pci 0000:00:08.1:   bridge window [mem 0xfcb00000-0xfcdfffff]
> [    0.578547] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578574] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578597] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578626] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578651] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578673] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578694] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
> [    0.578715] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
> [    0.580456] ACPI: EC: interrupt unblocked
> [    0.580456] ACPI: EC: event unblocked
> [    0.580456] ACPI: \_SB_.PCI0.SBRG.EC0_: GPE=0x2, EC_CMD/EC_SC=0x66,
> EC_DATA=0x62
> [    0.580456] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC used to handle
> transactions and events
> [    0.580456] iommu: Default domain type: Translated
> [    0.580466] pci 0000:05:00.0: vgaarb: setting as boot VGA device
> [    0.580466] pci 0000:05:00.0: vgaarb: VGA device added:
> decodes=io+mem,owns=io+mem,locks=none
> [    0.580468] pci 0000:05:00.0: vgaarb: bridge control possible
> [    0.580469] vgaarb: loaded
> [    0.580516] EDAC MC: Ver: 3.0.0
> [    0.580646] Registered efivars operations
> [    0.580646] PCI: Using ACPI for IRQ routing
> [    0.583184] PCI: pci_cache_line_size set to 64 bytes
> [    0.583296] e820: reserve RAM buffer [mem 0x09bff000-0x0bffffff]
> [    0.583296] e820: reserve RAM buffer [mem 0x0a200000-0x0bffffff]
> [    0.583297] e820: reserve RAM buffer [mem 0xc5a27000-0xc7ffffff]
> [    0.583297] e820: reserve RAM buffer [mem 0xc885f000-0xcbffffff]
> [    0.583298] e820: reserve RAM buffer [mem 0xca43e000-0xcbffffff]
> [    0.583298] e820: reserve RAM buffer [mem 0xcd000000-0xcfffffff]
> [    0.583298] e820: reserve RAM buffer [mem 0x102f380000-0x102fffffff]
> [    0.584460] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.584460] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
> [    0.588484] clocksource: Switched to clocksource tsc-early
> [    0.594191] VFS: Disk quotas dquot_6.6.0
> [    0.594205] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
> bytes)
> [    0.594284] AppArmor: AppArmor Filesystem Enabled
> [    0.594290] pnp: PnP ACPI init
> [    0.594339] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserved
> [    0.594342] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.594360] system 00:01: [mem 0xfeb80000-0xfebfffff] has been reserved
> [    0.594362] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.594399] system 00:02: [mem 0xfd100000-0xfd1fffff] has been reserved
> [    0.594401] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.594420] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.594489] system 00:04: [io  0x0290-0x029f] has been reserved
> [    0.594491] system 00:04: [io  0x0200-0x021f] has been reserved
> [    0.594493] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.594621] pnp 00:05: [dma 0 disabled]
> [    0.594639] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.594771] system 00:06: [io  0x04d0-0x04d1] has been reserved
> [    0.594772] system 00:06: [io  0x040b] has been reserved
> [    0.594773] system 00:06: [io  0x04d6] has been reserved
> [    0.594775] system 00:06: [io  0x0c00-0x0c01] has been reserved
> [    0.594776] system 00:06: [io  0x0c14] has been reserved
> [    0.594777] system 00:06: [io  0x0c50-0x0c51] has been reserved
> [    0.594778] system 00:06: [io  0x0c52] has been reserved
> [    0.594780] system 00:06: [io  0x0c6c] has been reserved
> [    0.594781] system 00:06: [io  0x0c6f] has been reserved
> [    0.594782] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
> [    0.594783] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
> [    0.594785] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
> [    0.594786] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
> [    0.594787] system 00:06: [io  0x0cd8-0x0cdf] has been reserved
> [    0.594788] system 00:06: [io  0x0800-0x089f] has been reserved
> [    0.594790] system 00:06: [io  0x0b00-0x0b0f] has been reserved
> [    0.594791] system 00:06: [io  0x0b20-0x0b3f] has been reserved
> [    0.594792] system 00:06: [io  0x0900-0x090f] has been reserved
> [    0.594793] system 00:06: [io  0x0910-0x091f] has been reserved
> [    0.594795] system 00:06: [mem 0xfec00000-0xfec00fff] could not be
> reserved
> [    0.594796] system 00:06: [mem 0xfec01000-0xfec01fff] could not be
> reserved
> [    0.594798] system 00:06: [mem 0xfedc0000-0xfedc0fff] has been reserved
> [    0.594799] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.594801] system 00:06: [mem 0xfed80000-0xfed8ffff] could not be
> reserved
> [    0.594802] system 00:06: [mem 0xfec10000-0xfec10fff] has been reserved
> [    0.594803] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
> [    0.594806] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.595046] pnp: PnP ACPI: found 7 devices
> [    0.595682] thermal_sys: Registered thermal governor 'fair_share'
> [    0.595682] thermal_sys: Registered thermal governor 'bang_bang'
> [    0.595683] thermal_sys: Registered thermal governor 'step_wise'
> [    0.595684] thermal_sys: Registered thermal governor 'user_space'
> [    0.600189] clocksource: acpi_pm: mask: 0xffffff max_cycles:
> 0xffffff, max_idle_ns: 2085701024 ns
> [    0.600213] pci 0000:02:02.0: PCI bridge to [bus 03]
> [    0.600219] pci 0000:02:02.0:   bridge window [mem 0xfbf00000-0xfc4fffff]
> [    0.600229] pci 0000:02:05.0: PCI bridge to [bus 04]
> [    0.600231] pci 0000:02:05.0:   bridge window [io  0xe000-0xefff]
> [    0.600236] pci 0000:02:05.0:   bridge window [mem 0xfca00000-0xfcafffff]
> [    0.600246] pci 0000:02:06.0: PCI bridge to [bus 05]
> [    0.600248] pci 0000:02:06.0:   bridge window [io  0xd000-0xdfff]
> [    0.600254] pci 0000:02:06.0:   bridge window [mem 0xfc900000-0xfc9fffff]
> [    0.600258] pci 0000:02:06.0:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> [    0.600265] pci 0000:02:08.0: PCI bridge to [bus 06]
> [    0.600270] pci 0000:02:08.0:   bridge window [mem 0xfc500000-0xfc6fffff]
> [    0.600279] pci 0000:02:09.0: PCI bridge to [bus 07]
> [    0.600284] pci 0000:02:09.0:   bridge window [mem 0xfc800000-0xfc8fffff]
> [    0.600293] pci 0000:02:0a.0: PCI bridge to [bus 08]
> [    0.600299] pci 0000:02:0a.0:   bridge window [mem 0xfc700000-0xfc7fffff]
> [    0.600308] pci 0000:01:00.0: PCI bridge to [bus 02-08]
> [    0.600310] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
> [    0.600315] pci 0000:01:00.0:   bridge window [mem 0xfbf00000-0xfcafffff]
> [    0.600319] pci 0000:01:00.0:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> [    0.600326] pci 0000:00:01.2: PCI bridge to [bus 01-08]
> [    0.600328] pci 0000:00:01.2:   bridge window [io  0xd000-0xefff]
> [    0.600331] pci 0000:00:01.2:   bridge window [mem 0xfbf00000-0xfcafffff]
> [    0.600333] pci 0000:00:01.2:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> [    0.600337] pci 0000:00:03.2: PCI bridge to [bus 09]
> [    0.600339] pci 0000:00:03.2:   bridge window [io  0xf000-0xffff]
> [    0.600341] pci 0000:00:03.2:   bridge window [mem 0xfce00000-0xfcffffff]
> [    0.600344] pci 0000:00:03.2:   bridge window [mem
> 0xe0000000-0xe01fffff 64bit pref]
> [    0.600348] pci 0000:00:07.1: PCI bridge to [bus 0a]
> [    0.600354] pci 0000:00:08.1: PCI bridge to [bus 0b]
> [    0.600357] pci 0000:00:08.1:   bridge window [mem 0xfcb00000-0xfcdfffff]
> [    0.600362] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
> [    0.600363] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
> [    0.600364] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
> [    0.600365] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
> [    0.600367] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff
> window]
> [    0.600368] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff
> window]
> [    0.600369] pci_bus 0000:00: resource 10 [mem 0xd0000000-0xfec02fff
> window]
> [    0.600371] pci_bus 0000:00: resource 11 [mem 0xfee00000-0xffffffff
> window]
> [    0.600372] pci_bus 0000:01: resource 0 [io  0xd000-0xefff]
> [    0.600373] pci_bus 0000:01: resource 1 [mem 0xfbf00000-0xfcafffff]
> [    0.600374] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff
> 64bit pref]
> [    0.600376] pci_bus 0000:02: resource 0 [io  0xd000-0xefff]
> [    0.600377] pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfcafffff]
> [    0.600378] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff
> 64bit pref]
> [    0.600380] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfc4fffff]
> [    0.600381] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
> [    0.600382] pci_bus 0000:04: resource 1 [mem 0xfca00000-0xfcafffff]
> [    0.600383] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
> [    0.600384] pci_bus 0000:05: resource 1 [mem 0xfc900000-0xfc9fffff]
> [    0.600386] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xdfffffff
> 64bit pref]
> [    0.600387] pci_bus 0000:06: resource 1 [mem 0xfc500000-0xfc6fffff]
> [    0.600388] pci_bus 0000:07: resource 1 [mem 0xfc800000-0xfc8fffff]
> [    0.600390] pci_bus 0000:08: resource 1 [mem 0xfc700000-0xfc7fffff]
> [    0.600391] pci_bus 0000:09: resource 0 [io  0xf000-0xffff]
> [    0.600392] pci_bus 0000:09: resource 1 [mem 0xfce00000-0xfcffffff]
> [    0.600393] pci_bus 0000:09: resource 2 [mem 0xe0000000-0xe01fffff
> 64bit pref]
> [    0.600395] pci_bus 0000:0b: resource 1 [mem 0xfcb00000-0xfcdfffff]
> [    0.600446] NET: Registered protocol family 2
> [    0.600531] tcp_listen_portaddr_hash hash table entries: 32768
> (order: 7, 524288 bytes, linear)
> [    0.600576] TCP established hash table entries: 524288 (order: 10,
> 4194304 bytes, linear)
> [    0.600963] TCP bind hash table entries: 65536 (order: 8, 1048576
> bytes, linear)
> [    0.601044] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.601076] UDP hash table entries: 32768 (order: 8, 1048576 bytes,
> linear)
> [    0.601162] UDP-Lite hash table entries: 32768 (order: 8, 1048576
> bytes, linear)
> [    0.601294] NET: Registered protocol family 1
> [    0.601297] NET: Registered protocol family 44
> [    0.601354] pci 0000:05:00.0: Video device with shadowed ROM at [mem
> 0x000c0000-0x000dffff]
> [    0.744420] pci 0000:0b:00.3: quirk_usb_early_handoff+0x0/0x644 took
> 139437 usecs
> [    0.744422] PCI: CLS 64 bytes, default 64
> [    0.744444] Trying to unpack rootfs image as initramfs...
> [    0.811479] Freeing initrd memory: 7820K
> [    0.811485] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.811486] software IO TLB: mapped [mem 0xbd943000-0xc1943000] (64MB)
> [    0.811514] amd_uncore: AMD NB counters detected
> [    0.811536] amd_uncore: AMD LLC counters detected
> [    0.811688] LVT offset 0 assigned for vector 0x400
> [    0.811760] perf: AMD IBS detected (0x000003ff)
> [    0.812110] Initialise system trusted keyrings
> [    0.812119] Key type blacklist registered
> [    0.812149] workingset: timestamp_bits=40 max_order=24 bucket_order=0
> [    0.812816] zbud: loaded
> [    0.812955] Platform Keyring initialized
> [    0.812956] Key type asymmetric registered
> [    0.812957] Asymmetric key parser 'x509' registered
> [    0.812962] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 250)
> [    0.812998] io scheduler mq-deadline registered
> [    0.813573] pcieport 0000:00:01.2: AER: enabled with IRQ 26
> [    0.813672] pcieport 0000:00:03.2: AER: enabled with IRQ 27
> [    0.813811] pcieport 0000:00:07.1: AER: enabled with IRQ 29
> [    0.813897] pcieport 0000:00:08.1: AER: enabled with IRQ 30
> [    0.815168] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    0.815175] efifb: probing for efifb
> [    0.815186] efifb: framebuffer at 0xd0000000, using 3072k, total 3072k
> [    0.815188] efifb: mode is 1024x768x32, linelength=4096, pages=1
> [    0.815189] efifb: scrolling: redraw
> [    0.815190] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.831789] Console: switching to colour frame buffer device 128x48
> [    0.848655] fb0: EFI VGA frame buffer device
> [    0.848842] Monitor-Mwait will be used to enter C-1 state
> [    0.849945] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.870569] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
> is a 16550A
> [    0.870890] Linux agpgart interface v0.103
> [    0.871248] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
> [    0.871354] AMD-Vi: AMD IOMMUv2 functionality not available on this
> system
> [    0.872089] i8042: PNP: No PS/2 controller found.
> [    0.872159] mousedev: PS/2 mouse device common for all mice
> [    0.872326] rtc_cmos 00:03: RTC can wake from S4
> [    0.872568] rtc_cmos 00:03: registered as rtc0
> [    0.872610] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes
> nvram, hpet irqs
> [    0.872943] ledtrig-cpu: registered to indicate activity on CPUs
> [    0.873187] drop_monitor: Initializing network drop monitor service
> [    0.873376] NET: Registered protocol family 10
> [    0.877537] Segment Routing with IPv6
> [    0.877554] mip6: Mobile IPv6
> [    0.877643] NET: Registered protocol family 17
> [    0.877796] mpls_gso: MPLS GSO support
> [    0.878469] microcode: CPU0: patch_level=0x08701021
> [    0.878516] microcode: CPU1: patch_level=0x08701021
> [    0.878673] microcode: CPU2: patch_level=0x08701021
> [    0.878826] microcode: CPU3: patch_level=0x08701021
> [    0.878981] microcode: CPU4: patch_level=0x08701021
> [    0.884795] microcode: CPU5: patch_level=0x08701021
> [    0.890562] microcode: CPU6: patch_level=0x08701021
> [    0.896234] microcode: CPU7: patch_level=0x08701021
> [    0.901809] microcode: CPU8: patch_level=0x08701021
> [    0.907302] microcode: CPU9: patch_level=0x08701021
> [    0.912716] microcode: CPU10: patch_level=0x08701021
> [    0.918070] microcode: CPU11: patch_level=0x08701021
> [    0.923283] microcode: CPU12: patch_level=0x08701021
> [    0.928428] microcode: CPU13: patch_level=0x08701021
> [    0.933514] microcode: CPU14: patch_level=0x08701021
> [    0.938511] microcode: CPU15: patch_level=0x08701021
> [    0.943343] microcode: Microcode Update Driver: v2.2.
> [    0.943346] IPI shorthand broadcast: enabled
> [    0.952798] sched_clock: Marking stable (952383032,
> 410817)->(1064737271, -111943422)
> [    0.957776] registered taskstats version 1
> [    0.962648] Loading compiled-in X.509 certificates
> [    0.984792] Loaded X.509 cert 'Debian Secure Boot CA:
> 6ccece7e4c6c0d1f6149f3dd27dfcc5cbb419ea1'
> [    0.990108] Loaded X.509 cert 'Debian Secure Boot Signer: 00a7468def'
> [    0.995418] zswap: loaded using pool lzo/zbud
> [    1.000755] Key type ._fscrypt registered
> [    1.005859] Key type .fscrypt registered
> [    1.011003] AppArmor: AppArmor sha1 policy hashing enabled
> [    1.016251] integrity: Loading X.509 certificate: UEFI:db
> [    1.021504] integrity: Loaded X.509 cert 'ASUSTeK MotherBoard SW Key
> Certificate: da83b990422ebc8c441f8d8b039a65a2'
> [    1.026859] integrity: Loading X.509 certificate: UEFI:db
> [    1.032338] integrity: Loaded X.509 cert 'ASUSTeK Notebook SW Key
> Certificate: b8e581e4df77a5bb4282d5ccfc00c071'
> [    1.037860] integrity: Loading X.509 certificate: UEFI:db
> [    1.043391] integrity: Loaded X.509 cert 'Microsoft Corporation UEFI
> CA 2011: 13adbf4309bd82709c8cd54f316ed522988a1bd4'
> [    1.049145] integrity: Loading X.509 certificate: UEFI:db
> [    1.054827] integrity: Loaded X.509 cert 'Microsoft Windows
> Production PCA 2011: a92902398e16c49778cd90f99e4f9ae17c55af53'
> [    1.060799] integrity: Loading X.509 certificate: UEFI:db
> [    1.066797] integrity: Loaded X.509 cert 'Canonical Ltd. Master
> Certificate Authority: ad91990bc22ab1f517048c23b6655a268e345a63'
> [    1.079529] rtc_cmos 00:03: setting system clock to
> 2020-09-18T17:42:47 UTC (1600450967)
> [    1.086508] Freeing unused kernel image memory: 1664K
> [    1.099508] Write protecting the kernel read-only data: 16384k
> [    1.106185] Freeing unused kernel image memory: 2036K
> [    1.112542] Freeing unused kernel image memory: 344K
> [    1.123508] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    1.129763] Run /init as init process
> [    1.196584] SCSI subsystem initialized
> [    1.203017] ACPI: bus type USB registered
> [    1.209367] usbcore: registered new interface driver usbfs
> [    1.215895] usbcore: registered new interface driver hub
> [    1.222504] usbcore: registered new device driver usb
> [    1.226425] libata version 3.00 loaded.
> [    1.231351] ahci 0000:07:00.0: version 3.0
> [    1.231506] ahci 0000:07:00.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps
> 0x1 impl SATA mode
> [    1.238305] ahci 0000:07:00.0: flags: 64bit ncq sntf ilck pm led clo
> only pmp fbs pio slum part
> [    1.245658] scsi host0: ahci
> [    1.252721] ata1: SATA max UDMA/133 abar m2048@0xfc800000 port
> 0xfc800100 irq 39
> [    1.260287] ahci 0000:08:00.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps
> 0x10 impl SATA mode
> [    1.260820] xhci_hcd 0000:06:00.1: xHCI Host Controller
> [    1.267793] ahci 0000:08:00.0: flags: 64bit ncq sntf ilck pm led clo
> only pmp fbs pio slum part
> [    1.275416] xhci_hcd 0000:06:00.1: new USB bus registered, assigned
> bus number 1
> [    1.289221] scsi host1: ahci
> [    1.298695] xhci_hcd 0000:06:00.1: hcc params 0x0278ffe5 hci version
> 0x110 quirks 0x0000000000000410
> [    1.302009] scsi host2: ahci
> [    1.315252] usb usb1: New USB device found, idVendor=1d6b,
> idProduct=0002, bcdDevice= 5.04
> [    1.319394] scsi host3: ahci
> [    1.325450] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.337072] scsi host4: ahci
> [    1.343118] usb usb1: Product: xHCI Host Controller
> [    1.353523] scsi host5: ahci
> [    1.360655] usb usb1: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
> [    1.369344] ata2: DUMMY
> [    1.378055] usb usb1: SerialNumber: 0000:06:00.1
> [    1.386705] ata3: DUMMY
> [    1.386706] ata4: DUMMY
> [    1.395562] hub 1-0:1.0: USB hub found
> [    1.404121] ata5: DUMMY
> [    1.404208] ata6: SATA max UDMA/133 abar m2048@0xfc700000 port
> 0xfc700300 irq 40
> [    1.413439] hub 1-0:1.0: 6 ports detected
> [    1.446648] xhci_hcd 0000:06:00.1: xHCI Host Controller
> [    1.454766] xhci_hcd 0000:06:00.1: new USB bus registered, assigned
> bus number 2
> [    1.462928] xhci_hcd 0000:06:00.1: Host supports USB 3.1 Enhanced
> SuperSpeed
> [    1.471061] usb usb2: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    1.478582] ata1: SATA link down (SStatus 0 SControl 300)
> [    1.479568] usb usb2: New USB device found, idVendor=1d6b,
> idProduct=0003, bcdDevice= 5.04
> [    1.494832] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.502563] usb usb2: Product: xHCI Host Controller
> [    1.510163] usb usb2: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
> [    1.517738] usb usb2: SerialNumber: 0000:06:00.1
> [    1.525311] hub 2-0:1.0: USB hub found
> [    1.532796] hub 2-0:1.0: 4 ports detected
> [    1.540425] xhci_hcd 0000:06:00.3: xHCI Host Controller
> [    1.547813] xhci_hcd 0000:06:00.3: new USB bus registered, assigned
> bus number 3
> [    1.555565] xhci_hcd 0000:06:00.3: hcc params 0x0278ffe5 hci version
> 0x110 quirks 0x0000000000000410
> [    1.563405] usb usb3: New USB device found, idVendor=1d6b,
> idProduct=0002, bcdDevice= 5.04
> [    1.571120] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.578952] usb usb3: Product: xHCI Host Controller
> [    1.586786] usb usb3: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
> [    1.594683] usb usb3: SerialNumber: 0000:06:00.3
> [    1.602673] hub 3-0:1.0: USB hub found
> [    1.610676] hub 3-0:1.0: 6 ports detected
> [    1.618666] xhci_hcd 0000:06:00.3: xHCI Host Controller
> [    1.626360] xhci_hcd 0000:06:00.3: new USB bus registered, assigned
> bus number 4
> [    1.634142] xhci_hcd 0000:06:00.3: Host supports USB 3.1 Enhanced
> SuperSpeed
> [    1.642085] usb usb4: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    1.649746] usb usb4: New USB device found, idVendor=1d6b,
> idProduct=0003, bcdDevice= 5.04
> [    1.657499] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.665176] usb usb4: Product: xHCI Host Controller
> [    1.672722] usb usb4: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
> [    1.680282] usb usb4: SerialNumber: 0000:06:00.3
> [    1.681473] tsc: Refined TSC clocksource calibration: 3892.629 MHz
> [    1.692423] hub 4-0:1.0: USB hub found
> [    1.695168] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
> 0x70385052568, max_idle_ns: 881591050251 ns
> [    1.703815] hub 4-0:1.0: 4 ports detected
> [    1.717089] clocksource: Switched to clocksource tsc
> [    1.724459] usb: port power management may be unreliable
> [    1.731950] xhci_hcd 0000:0b:00.3: xHCI Host Controller
> [    1.739209] xhci_hcd 0000:0b:00.3: new USB bus registered, assigned
> bus number 5
> [    1.746688] xhci_hcd 0000:0b:00.3: hcc params 0x0278ffe5 hci version
> 0x110 quirks 0x0000000000000410
> [    1.754201] usb usb5: New USB device found, idVendor=1d6b,
> idProduct=0002, bcdDevice= 5.04
> [    1.761666] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.765728] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.769251] usb usb5: Product: xHCI Host Controller
> [    1.783495] ata6.00: ATA-11: SAMSUNG MZ7LH960HAJR-00005, HXT7404Q,
> max UDMA/133
> [    1.784745] usb usb5: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
> [    1.784746] usb usb5: SerialNumber: 0000:0b:00.3
> [    1.792691] ata6.00: 1875385008 sectors, multi 16: LBA48 NCQ (depth
> 32), AA
> [    1.804055] hub 5-0:1.0: USB hub found
> [    1.814462] ata6.00: configured for UDMA/133
> [    1.816414] hub 5-0:1.0: 4 ports detected
> [    1.824461] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG MZ7LH960
> 404Q PQ: 0 ANSI: 5
> [    1.836236] xhci_hcd 0000:0b:00.3: xHCI Host Controller
> [    1.855448] xhci_hcd 0000:0b:00.3: new USB bus registered, assigned
> bus number 6
> [    1.863218] xhci_hcd 0000:0b:00.3: Host supports USB 3.1 Enhanced
> SuperSpeed
> [    1.870987] usb usb6: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    1.878790] usb usb6: New USB device found, idVendor=1d6b,
> idProduct=0003, bcdDevice= 5.04
> [    1.886682] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.886813] sd 5:0:0:0: [sda] 1875385008 512-byte logical blocks:
> (960 GB/894 GiB)
> [    1.894601] usb usb6: Product: xHCI Host Controller
> [    1.894602] usb usb6: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
> [    1.902671] sd 5:0:0:0: [sda] 4096-byte physical blocks
> [    1.910721] usb usb6: SerialNumber: 0000:0b:00.3
> [    1.910828] hub 6-0:1.0: USB hub found
> [    1.918838] sd 5:0:0:0: [sda] Write Protect is off
> [    1.926898] hub 6-0:1.0: 4 ports detected
> [    1.934802] sd 5:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.952472] usb 3-4: new full-speed USB device number 2 using xhci_hcd
> [    1.958197] sd 5:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.993395]  sda: sda1 sda2 sda3 sda4 sda5
> [    2.001657] sd 5:0:0:0: [sda] Attached SCSI disk
> [    2.129989] usb 3-4: config 1 has an invalid interface number: 2 but
> max is 1
> [    2.138112] usb 3-4: config 1 has no interface number 1
> [    2.156988] usb 3-4: New USB device found, idVendor=0b05,
> idProduct=18f3, bcdDevice= 1.00
> [    2.165098] usb 3-4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    2.172901] usb 5-2: new high-speed USB device number 2 using xhci_hcd
> [    2.173240] usb 3-4: Product: AURA LED Controller
> [    2.189428] usb 3-4: Manufacturer: AsusTek Computer Inc.
> [    2.197462] usb 3-4: SerialNumber: 9876543210
> [    2.211860] usb 5-2: New USB device found, idVendor=05e3,
> idProduct=0608, bcdDevice= 7.02
> [    2.219890] usb 5-2: New USB device strings: Mfr=0, Product=1,
> SerialNumber=0
> [    2.227996] usb 5-2: Product: USB2.0 Hub
> [    2.236028] hidraw: raw HID events driver (C) Jiri Kosina
> [    2.252027] usbcore: registered new interface driver usbhid
> [    2.259752] usbhid: USB HID core driver
> [    2.268154] hid-generic 0003:0B05:18F3.0001: hiddev0,hidraw0: USB HID
> v1.11 Device [AsusTek Computer Inc. AURA LED Controller] on
> usb-0000:06:00.3-4/input2
> [    2.287381] hub 5-2:1.0: USB hub found
> [    2.295735] hub 5-2:1.0: 4 ports detected
> [    2.406610] SGI XFS with ACLs, security attributes, realtime, no
> debug enabled
> [    2.415285] XFS (sda3): Mounting V5 Filesystem
> [    2.441398] XFS (sda3): Starting recovery (logdev: internal)
> [    2.453904] XFS (sda3): Ending recovery (logdev: internal)
> [    2.505724] Not activating Mandatory Access Control as
> /sbin/tomoyo-init does not exist.
> [    2.561681] systemd[1]: Inserted module 'autofs4'
> [    2.585050] systemd[1]: systemd 241 running in system mode. (+PAM
> +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP
> +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN
> -PCRE2 default-hierarchy=hybrid)
> [    2.608473] usb 5-2.1: new low-speed USB device number 3 using xhci_hcd
> [    2.624483] systemd[1]: Detected architecture x86-64.
> [    2.686158] systemd[1]: Set hostname to <mercury>.
> [    2.744061] usb 5-2.1: New USB device found, idVendor=0b39,
> idProduct=0d04, bcdDevice= 1.60
> [    2.752177] usb 5-2.1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.760408] usb 5-2.1: Product: USB KVM Switch 4 PORT V2.7
> [    2.768637] usb 5-2.1: Manufacturer: USB KVM Switch 4 PORT V2.7
> [    2.874445] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
> V2.7 as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.0/0003:0B39:0D04.0002/input/input0
> [    2.948519] hid-generic 0003:0B39:0D04.0002: input,hidraw1: USB HID
> v1.10 Keyboard [USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT V2.7]
> on usb-0000:0b:00.3-2.1/input0
> [    2.972221] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
> V2.7 Mouse as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input1
> [    2.990273] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
> V2.7 System Control as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input2
> [    3.068482] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
> V2.7 Consumer Control as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input3
> [    3.087990] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
> V2.7 as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input4
> [    3.108429] hid-generic 0003:0B39:0D04.0003: input,hidraw2: USB HID
> v1.10 Mouse [USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT V2.7] on
> usb-0000:0b:00.3-2.1/input1
> [    3.208463] usb 5-2.2: new low-speed USB device number 4 using xhci_hcd
> [    3.338082] usb 5-2.2: New USB device found, idVendor=046d,
> idProduct=c31c, bcdDevice=64.00
> [    3.348677] usb 5-2.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    3.359371] usb 5-2.2: Product: USB Keyboard
> [    3.369834] usb 5-2.2: Manufacturer: Logitech
> [    3.484185] input: Logitech USB Keyboard as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.2/5-2.2:1.0/0003:046D:C31C.0004/input/input5
> [    3.564527] hid-generic 0003:046D:C31C.0004: input,hidraw3: USB HID
> v1.10 Keyboard [Logitech USB Keyboard] on usb-0000:0b:00.3-2.2/input0
> [    3.596191] input: Logitech USB Keyboard Consumer Control as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.2/5-2.2:1.1/0003:046D:C31C.0005/input/input6
> [    3.676473] input: Logitech USB Keyboard System Control as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.2/5-2.2:1.1/0003:046D:C31C.0005/input/input7
> [    3.700014] hid-generic 0003:046D:C31C.0005: input,hidraw4: USB HID
> v1.10 Device [Logitech USB Keyboard] on usb-0000:0b:00.3-2.2/input1
> [    3.752627] systemd[1]: Condition check resulted in Root Slice being
> skipped.
> [    3.764823] systemd[1]: Condition check resulted in System Slice
> being skipped.
> [    3.777616] systemd[1]: Listening on udev Control Socket.
> [    3.802058] systemd[1]: Started Dispatch Password Requests to Console
> Directory Watch.
> [    3.806035] usb 5-2.3: new low-speed USB device number 5 using xhci_hcd
> [    3.839488] systemd[1]: Created slice system-postfix.slice.
> [    3.863506] systemd[1]: Listening on udev Kernel Socket.
> [    3.887444] systemd[1]: Listening on initctl Compatibility Named Pipe.
> [    3.938532] usb 5-2.3: New USB device found, idVendor=0430,
> idProduct=0100, bcdDevice= 1.07
> [    3.938568] usb 5-2.3: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    3.996539] input: HID 0430:0100 as
> /devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.3/5-2.3:1.0/0003:0430:0100.0006/input/input8
> [    4.020270] hid-generic 0003:0430:0100.0006: input,hidraw5: USB HID
> v1.10 Mouse [HID 0430:0100] on usb-0000:0b:00.3-2.3/input0
> [    4.285236] xfs filesystem being remounted at / supports timestamps
> until 2038 (0x7fffffff)
> [    4.319560] nct6775: Found NCT6798D or compatible chip at 0x2e:0x290
> [    4.327574] ACPI Warning: SystemIO range
> 0x0000000000000295-0x0000000000000296 conflicts with OpRegion
> 0x0000000000000290-0x0000000000000299 (\AMW0.SHWM) (20190816/utaddress-213)
> [    4.327577] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [    4.454513] systemd-journald[313]: Received request to flush runtime
> journal from PID 1
> [    4.504371] acpi_cpufreq: overriding BIOS provided _PSD data
> [    4.511592] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input9
> [    4.518987] ACPI: Power Button [PWRB]
> [    4.519684] acpi PNP0C14:02: duplicate WMI GUID
> 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
> [    4.526349] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input10
> [    4.534216] acpi PNP0C14:03: duplicate WMI GUID
> 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
> [    4.542832] ACPI: Power Button [PWRF]
> [    4.551978] acpi PNP0C14:04: duplicate WMI GUID
> 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
> [    4.567070] acpi PNP0C14:05: duplicate WMI GUID
> 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
> [    4.578768] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00,
> revision 0
> [    4.587112] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus
> port selection
> [    4.595797] input: PC Speaker as /devices/platform/pcspkr/input/input11
> [    4.604340] EFI Variables Facility v0.08 2004-May-17
> [    4.613530] sd 5:0:0:0: Attached scsi generic sg0 type 0
> [    4.644992] ccp 0000:0b:00.1: enabling device (0000 -> 0002)
> [    4.653851] dca service started, version 1.12.1
> [    4.663760] ccp 0000:0b:00.1: ccp enabled
> [    4.665098] cryptd: max_cpu_qlen set to 1000
> [    4.669676] setting logging_level(0x000083f8)
> [    4.670962] mpt3sas version 31.100.00.00 loaded
> [    4.672164] mpt3sas_cm0: mpt3sas_base_attach
> [    4.672164] mpt3sas_cm0: mpt3sas_base_map_resources
> [    4.672330] mpt3sas_cm0: 63 BIT PCI BUS DMA ADDRESSING SUPPORTED,
> total mem (65777060 kB)
> [    4.672374] mpt3sas_cm0: _base_get_ioc_facts
> [    4.672374] mpt3sas_cm0: _base_wait_for_iocstate
> [    4.682797]     offset:data
> [    4.722068] bna: QLogic BR-series 10G Ethernet driver - version: 3.2.25.1
> [    4.722140] pstore: Using crash dump compression: deflate
> [    4.730271]     [0x00]:03110206
> [    4.730272]     [0x04]:00002e00
> [    4.730272]     [0x08]:00000000
> [    4.730272]     [0x0c]:00000000
> [    4.730273]     [0x10]:00000000
> [    4.744702] bna 0000:03:00.2: firmware: direct-loading firmware
> ctfw-3.2.5.1.bin
> [    4.746697]     [0x14]:80010280
> [    4.749147] pstore: Registered efi as persistent store backend
> [    4.755437] bna 0000:03:00.2: bar0 mapped to 00000000d5f9a5ca, len 262144
> [    4.762760]     [0x18]:22312200
> [    4.762762]     [0x1c]:000fa84c
> [    4.859177]     [0x20]:02000500
> [    4.859177]     [0x24]:00080020
> [    4.859177]     [0x28]:0280001d
> [    4.859177]     [0x2c]:00d100d0
> [    4.859177]     [0x30]:0074000b
> [    4.859178]     [0x34]:0020ffe0
> [    4.859178]     [0x38]:00800375
> [    4.859178]     [0x3c]:000c0009
> [    4.859178]     [0x40]:00000000
> [    4.859179] mpt3sas_cm0: CurrentHostPageSize(12)
> [    4.859179] mpt3sas_cm0: hba queue depth(8704), max chains per io(128)
> [    4.859180] mpt3sas_cm0: request frame size(128), reply frame size(128)
> [    4.859187] mpt3sas_cm0: msix is supported, vector_count(128)
> [    4.859187] mpt3sas_cm0: MSI-X vectors supported: 128
> [    4.859188]      no of cores: 16, max_msix_vectors: -1
> [    4.859188] mpt3sas_cm0:  0 128
> [    4.860156] mpt3sas_cm0: High IOPs queues : disabled
> [    4.860156] mpt3sas0-msix0: PCI-MSI-X enabled: IRQ 81
> [    4.860157] mpt3sas0-msix1: PCI-MSI-X enabled: IRQ 82
> [    4.860157] mpt3sas0-msix2: PCI-MSI-X enabled: IRQ 83
> [    4.860157] mpt3sas0-msix3: PCI-MSI-X enabled: IRQ 84
> [    4.860157] mpt3sas0-msix4: PCI-MSI-X enabled: IRQ 85
> [    4.860158] mpt3sas0-msix5: PCI-MSI-X enabled: IRQ 86
> [    4.860158] mpt3sas0-msix6: PCI-MSI-X enabled: IRQ 87
> [    4.860158] mpt3sas0-msix7: PCI-MSI-X enabled: IRQ 88
> [    4.860158] mpt3sas0-msix8: PCI-MSI-X enabled: IRQ 89
> [    4.860158] mpt3sas0-msix9: PCI-MSI-X enabled: IRQ 90
> [    4.860159] mpt3sas0-msix10: PCI-MSI-X enabled: IRQ 91
> [    4.860159] mpt3sas0-msix11: PCI-MSI-X enabled: IRQ 92
> [    4.860159] mpt3sas0-msix12: PCI-MSI-X enabled: IRQ 93
> [    4.860159] mpt3sas0-msix13: PCI-MSI-X enabled: IRQ 94
> [    4.860160] mpt3sas0-msix14: PCI-MSI-X enabled: IRQ 95
> [    4.860160] mpt3sas0-msix15: PCI-MSI-X enabled: IRQ 96
> [    4.860160] mpt3sas0-msix16: PCI-MSI-X enabled: IRQ 97
> [    4.860160] mpt3sas0-msix17: PCI-MSI-X enabled: IRQ 98
> [    4.860161] mpt3sas0-msix18: PCI-MSI-X enabled: IRQ 99
> [    4.860161] mpt3sas0-msix19: PCI-MSI-X enabled: IRQ 100
> [    4.860161] mpt3sas0-msix20: PCI-MSI-X enabled: IRQ 101
> [    4.860161] mpt3sas0-msix21: PCI-MSI-X enabled: IRQ 102
> [    4.860161] mpt3sas0-msix22: PCI-MSI-X enabled: IRQ 103
> [    4.860162] mpt3sas0-msix23: PCI-MSI-X enabled: IRQ 104
> [    4.860162] mpt3sas0-msix24: PCI-MSI-X enabled: IRQ 105
> [    4.860162] mpt3sas0-msix25: PCI-MSI-X enabled: IRQ 106
> [    4.860162] mpt3sas0-msix26: PCI-MSI-X enabled: IRQ 107
> [    4.860163] mpt3sas0-msix27: PCI-MSI-X enabled: IRQ 108
> [    4.860163] mpt3sas0-msix28: PCI-MSI-X enabled: IRQ 109
> [    4.860163] mpt3sas0-msix29: PCI-MSI-X enabled: IRQ 110
> [    4.860163] mpt3sas0-msix30: PCI-MSI-X enabled: IRQ 111
> [    4.860164] mpt3sas0-msix31: PCI-MSI-X enabled: IRQ 112
> [    4.860165] mpt3sas_cm0: iomem(0x00000000e0100000),
> mapped(0x00000000459c7887), size(1048576)
> [    4.860166] mpt3sas_cm0: ioport(0x000000000000f000), size(256)
> [    4.860484] mpt3sas_cm0: _base_get_ioc_facts
> [    4.860485] mpt3sas_cm0: _base_wait_for_iocstate
> [    4.867615]     offset:data
> [    4.867616]     [0x00]:03110206
> [    4.867616]     [0x04]:00002e00
> [    4.867616]     [0x08]:00000000
> [    4.867616]     [0x0c]:00000000
> [    4.867616]     [0x10]:00000000
> [    4.867617]     [0x14]:80010280
> [    4.867617]     [0x18]:22312200
> [    4.867617]     [0x1c]:000fa84c
> [    4.867617]     [0x20]:02000500
> [    4.867617]     [0x24]:00080020
> [    4.867618]     [0x28]:0280001d
> [    4.867618]     [0x2c]:00d100d0
> [    4.867618]     [0x30]:0074000b
> [    4.867618]     [0x34]:0020ffe0
> [    4.867618]     [0x38]:00800375
> [    4.867618]     [0x3c]:000c0009
> [    4.867619]     [0x40]:00000000
> [    4.867619] mpt3sas_cm0: CurrentHostPageSize(12)
> [    4.867619] mpt3sas_cm0: hba queue depth(8704), max chains per io(128)
> [    4.867620] mpt3sas_cm0: request frame size(128), reply frame size(128)
> [    4.867620] mpt3sas_cm0: _base_make_ioc_ready
> [    4.867625] mpt3sas_cm0: sending message unit reset !!
> [    4.869147] mpt3sas_cm0: message unit reset: SUCCESS
> [    4.869148] mpt3sas_cm0: _base_get_port_facts
> [    4.869437]     offset:data
> [    4.869438]     [0x00]:05070000
> [    4.869438]     [0x04]:00000000
> [    4.869438]     [0x08]:00000000
> [    4.869439]     [0x0c]:00000000
> [    4.869439]     [0x10]:00000000
> [    4.869439]     [0x14]:00004000
> [    4.869440]     [0x18]:000000e8
> [    4.869440] mpt3sas_cm0: _base_allocate_memory_pools
> [    4.869442] mpt3sas_cm0: scatter gather: sge_in_main_msg(1),
> sge_per_chain(7), sge_per_io(128), chains_per_io(19)
> [    4.869457] mpt3sas_cm0: reply post free pool (0x00000000f14f24c8):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869458] mpt3sas_cm0: reply_post_free_dma = (0x37000000)
> [    4.869481] mpt3sas_cm0: reply post free pool (0x000000006a229df0):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869481] mpt3sas_cm0: reply_post_free_dma = (0x37040000)
> [    4.869495] mpt3sas_cm0: reply post free pool (0x00000000bcc04f00):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869496] mpt3sas_cm0: reply_post_free_dma = (0x37080000)
> [    4.869509] mpt3sas_cm0: reply post free pool (0x0000000038b7061a):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869509] mpt3sas_cm0: reply_post_free_dma = (0x370c0000)
> [    4.869523] mpt3sas_cm0: reply post free pool (0x00000000bc80b8a4):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869524] mpt3sas_cm0: reply_post_free_dma = (0x37100000)
> [    4.869537] mpt3sas_cm0: reply post free pool (0x00000000e4eefaee):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869538] mpt3sas_cm0: reply_post_free_dma = (0x37140000)
> [    4.869551] mpt3sas_cm0: reply post free pool (0x000000002cc7f8b5):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869552] mpt3sas_cm0: reply_post_free_dma = (0x37180000)
> [    4.869566] mpt3sas_cm0: reply post free pool (0x00000000f7ab63e2):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869566] mpt3sas_cm0: reply_post_free_dma = (0x371c0000)
> [    4.869582] mpt3sas_cm0: reply post free pool (0x00000000e4d0829b):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869582] mpt3sas_cm0: reply_post_free_dma = (0x37200000)
> [    4.869608] mpt3sas_cm0: reply post free pool (0x00000000e1ef38cd):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869609] mpt3sas_cm0: reply_post_free_dma = (0x37240000)
> [    4.869622] mpt3sas_cm0: reply post free pool (0x00000000e314dcdb):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869623] mpt3sas_cm0: reply_post_free_dma = (0x37280000)
> [    4.869637] mpt3sas_cm0: reply post free pool (0x00000000c721b4f5):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869637] mpt3sas_cm0: reply_post_free_dma = (0x372c0000)
> [    4.869652] mpt3sas_cm0: reply post free pool (0x0000000081958009):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869652] mpt3sas_cm0: reply_post_free_dma = (0x37300000)
> [    4.869667] mpt3sas_cm0: reply post free pool (0x000000005bd18d42):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869667] mpt3sas_cm0: reply_post_free_dma = (0x37340000)
> [    4.869681] mpt3sas_cm0: reply post free pool (0x00000000c701a724):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869681] mpt3sas_cm0: reply_post_free_dma = (0x37380000)
> [    4.869695] mpt3sas_cm0: reply post free pool (0x0000000014701f10):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869696] mpt3sas_cm0: reply_post_free_dma = (0x373c0000)
> [    4.869719] mpt3sas_cm0: reply post free pool (0x0000000032b61596):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869719] mpt3sas_cm0: reply_post_free_dma = (0xc2400000)
> [    4.869737] mpt3sas_cm0: reply post free pool (0x00000000d5897401):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869737] mpt3sas_cm0: reply_post_free_dma = (0xc2440000)
> [    4.869752] mpt3sas_cm0: reply post free pool (0x00000000879105c4):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869753] mpt3sas_cm0: reply_post_free_dma = (0xc2480000)
> [    4.869768] mpt3sas_cm0: reply post free pool (0x00000000ce2e2aec):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869768] mpt3sas_cm0: reply_post_free_dma = (0xc24c0000)
> [    4.869782] mpt3sas_cm0: reply post free pool (0x00000000b09fe51b):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869782] mpt3sas_cm0: reply_post_free_dma = (0xc2500000)
> [    4.869796] mpt3sas_cm0: reply post free pool (0x000000001731eb9f):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869796] mpt3sas_cm0: reply_post_free_dma = (0xc2540000)
> [    4.869811] mpt3sas_cm0: reply post free pool (0x00000000a8c37817):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869811] mpt3sas_cm0: reply_post_free_dma = (0xc2580000)
> [    4.869829] mpt3sas_cm0: reply post free pool (0x00000000bb254aea):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869829] mpt3sas_cm0: reply_post_free_dma = (0xc25c0000)
> [    4.869853] mpt3sas_cm0: reply post free pool (0x00000000198674d9):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869853] mpt3sas_cm0: reply_post_free_dma = (0xc2600000)
> [    4.869867] mpt3sas_cm0: reply post free pool (0x000000009697534a):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869867] mpt3sas_cm0: reply_post_free_dma = (0xc2640000)
> [    4.869881] mpt3sas_cm0: reply post free pool (0x00000000add69645):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869881] mpt3sas_cm0: reply_post_free_dma = (0xc2680000)
> [    4.869907] mpt3sas_cm0: reply post free pool (0x00000000d03ec73a):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869907] mpt3sas_cm0: reply_post_free_dma = (0xc26c0000)
> [    4.869934] mpt3sas_cm0: reply post free pool (0x000000007e0bba8a):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869934] mpt3sas_cm0: reply_post_free_dma = (0xc2700000)
> [    4.869948] mpt3sas_cm0: reply post free pool (0x00000000dade2cb3):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869949] mpt3sas_cm0: reply_post_free_dma = (0xc2740000)
> [    4.869963] mpt3sas_cm0: reply post free pool (0x00000000513ce9a4):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869963] mpt3sas_cm0: reply_post_free_dma = (0xc2780000)
> [    4.869978] mpt3sas_cm0: reply post free pool (0x00000000b7b9c1af):
> depth(17712), element_size(8), pool_size(138 kB)
> [    4.869979] mpt3sas_cm0: reply_post_free_dma = (0xc27c0000)
> [    4.869979] mpt3sas_cm0: scsi host: can_queue depth (8580)
> [    4.870110] mpt3sas_cm0: request pool(0x00000000e166287e):
> depth(8820), frame_size(128), pool_size(1102 kB)
> [    4.870110] mpt3sas_cm0: request pool: dma(0xfdbe00000)
> [    4.870111] mpt3sas_cm0: scsiio(0x00000000e166287e): depth(8583)
> [    4.872676] mpt3sas_cm0: hi_priority(0x00000000ca256a32): depth(116),
> start smid(8584)
> [    4.872677] mpt3sas_cm0: internal(0x000000001da5d167): depth(121),
> start smid(8700)
> [    4.974024] mpt3sas_cm0: PCIe sgl pool depth(8583),
> element_size(4096), pool_size(34332 kB)
> [    5.031834] pps_core: LinuxPPS API ver. 1 registered
> [    5.035421] mpt3sas_cm0: Number of chains can fit in a PRP page(19)
> [    5.035458] mpt3sas_cm0: chain pool depth(100000), frame_size(128),
> pool_size(12500 kB)
> [    5.038944] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
> Rodolfo Giometti <giometti@linux.it>
> [    5.042454] mpt3sas_cm0: sense pool(0x000000007961ebe2): depth(8583),
> element_size(96), pool_size(804 kB)
> [    5.445874] bna 0000:03:00.3: bar0 mapped to 000000001c4b2719, len 262144
> [    5.452650] mpt3sas_cm0: sense_dma(0xfd9700000)
> [    5.452887] mpt3sas_cm0: reply pool(0x00000000d032ecfd): depth(8884),
> frame_size(128), pool_size(1110 kB)
> [    5.800914] mpt3sas_cm0: reply_dma(0xfd8c00000)
> [    5.800936] mpt3sas_cm0: reply_free pool(0x00000000d7014206):
> depth(8884), element_size(4), pool_size(34 kB)
> [    5.800938] mpt3sas_cm0: reply_free_dma (0xfdc110000)
> [    5.800941] mpt3sas_cm0: config page(0x000000005329e894): size(512)
> [    5.839792] mpt3sas_cm0: config_page_dma(0xfdcd9f000)
> [    5.839792] mpt3sas_cm0: Allocated physical memory: size(42885 kB)
> [    5.839793] mpt3sas_cm0: Current Controller Queue Depth(8580),Max
> Controller Queue Depth(8704)
> [    5.839794] mpt3sas_cm0: Scatter Gather Elements per IO(128)
> [    5.839813] mpt3sas_cm0: _base_make_ioc_operational
> [    5.888037] mpt3sas_cm0: _base_send_ioc_init
> [    5.888038]     offset:data
> [    5.888039]     [0x00]:02000004
> [    5.888040]     [0x04]:01000000
> [    5.888040]     [0x08]:00000000
> [    5.888040]     [0x0c]:36000206
> [    5.888041]     [0x10]:00000000
> [    5.888041]     [0x14]:200c0000
> [    5.888042]     [0x18]:00200000
> [    5.888042]     [0x1c]:22b44530
> [    5.888043]     [0x20]:0000000f
> [    5.888043]     [0x24]:0000000f
> [    5.888044]     [0x28]:dbe00000
> [    5.888044]     [0x2c]:0000000f
> [    5.888044]     [0x30]:e4a34000
> [    5.888045]     [0x34]:0000000f
> [    5.888045]     [0x38]:dc110000
> [    5.888046]     [0x3c]:0000000f
> [    5.888046]     [0x40]:a24fca94
> [    5.888046]     [0x44]:00000174
> [    5.888604] AVX2 version of gcm_enc/dec engaged.
> [    5.888605] AES CTR mode by8 optimization enabled
> [    5.893524]     offset:data
> [    5.893525]     [0x00]:02050004
> [    5.893525]     [0x04]:01000000
> [    5.893525]     [0x08]:00000000
> [    5.893526]     [0x0c]:00000000
> [    5.893526]     [0x10]:00000000
> [    5.893588] mpt3sas_cm0: _base_display_fwpkg_version
> [    5.895074] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver
> [    5.896934] sp5100-tco sp5100-tco: Using 0xfed80b00 for watchdog MMIO
> address
> [    5.897035] bna 0000:03:00.2 ethEXT: renamed from eth0
> [    5.965957] mpt3sas_cm0: _base_display_fwpkg_version: complete
> [    5.972002] sp5100-tco sp5100-tco: Watchdog hardware is disabled
> [    5.979462] mpt3sas_cm0: FW Package Version (02.00.05.02)
> [    5.981609] PTP clock support registered
> [    6.126215] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00),
> ChipRevision(0x01), BiosVersion(09.03.00.00)
> [    6.126262] NVMe
> [    6.126270] mpt3sas_cm0: Protocol=(Initiator,Target),
> Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
> [    6.126533] mpt3sas_cm0: _base_event_notification
> [    6.126641] mpt3sas_cm0: _base_event_notification: complete
> [    6.126752] scsi host6: Fusion MPT SAS Host
> [    6.126944] bna 0000:03:00.3 ethLAN: renamed from eth1
> [    6.172199] mpt3sas_cm0: sending port enable !!
> [    6.172315] mpt3sas_cm0: Discovery: (start)
> [    6.172323] mpt3sas_cm0: discovery event: (start)
> [    6.172325] mpt3sas_cm0: SAS Enclosure Device Status Change
> [    6.172328] mpt3sas_cm0: SAS Topology Change List
> [    6.172329] mpt3sas_cm0: SAS Enclosure Device Status Change
> [    6.172337] mpt3sas_cm0: SAS Topology Change List
> [    6.172363] mpt3sas_cm0: SAS Topology Change List
> [    6.172365] mpt3sas_cm0: Discovery: (stop)
> [    6.172367] mpt3sas_cm0: Discovery: (start)
> [    6.172368] mpt3sas_cm0: SAS Enclosure Device Status Change
> [    6.172370] mpt3sas_cm0: SAS Topology Change List
> [    6.172372] mpt3sas_cm0: SAS Topology Change List
> [    6.172374] mpt3sas_cm0: Discovery: (stop)
> [    6.177335] mpt3sas_cm0: host_add: handle(0x0001),
> sas_addr(0x500605b00cf4d920), phys(9)
> [    6.177467] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0001), enclosure logical
> id(0x500605b00cf4d920) number slots(0)
> [    6.177599] mpt3sas_cm0: sas topology change: (responding)
> [    6.177599]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(00), count(9)
> [    6.177600]     phy(00), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177600]     phy(01), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177601]     phy(02), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177601]     phy(03), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177601]     phy(04), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177602]     phy(05), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177602]     phy(06), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177602]     phy(07), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.177603]     phy(08), attached_handle(0x0009): target add: link
> rate: new(0x08), old(0x00)
> [    6.177604] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [    6.181655] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x0009),
> sas_addr(0x510600b00cf4d920)
> [    6.181656] mpt3sas_cm0: enclosure logical id(0x500605b00cf4d920),
> slot(8)
> [    6.181657] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.181659] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0002), enclosure logical
> id(0x500151b0000020bf) number slots(0)
> [    6.182155] mpt3sas_cm0: sas topology change: (add)
> [    6.182156]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(00), count(22)
> [    6.182157]     phy(06), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.182158]     phy(07), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.182159]     phy(08), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.182159]     phy(09), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.182160]     phy(19), attached_handle(0x000b): target add: link
> rate: new(0x0a), old(0x0a)
> [    6.182161] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [    6.183763] mpt3sas_cm0: expander_add: handle(0x000a),
> parent(0x0001), sas_addr(0x500151b0000020bf), phys(26)
> [    6.190346] igb: Intel(R) Gigabit Ethernet Network Driver - version
> 5.6.0-k
> [    6.193557] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x000b),
> sas_addr(0x500151b0000020b3)
> [    6.197616] igb: Copyright (c) 2007-2014 Intel Corporation.
> [    6.335796] asus_wmi: ASUS WMI generic driver loaded
> [    6.340933] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    6.340934] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.340934] mpt3sas_cm0: _scsih_determine_boot_device:
> current_boot_device(0x500151b0000020b3)
> [    6.340940] mpt3sas_cm0: sas topology change: (responding)
> [    6.349764] pps pps0: new PPS source ptp0
> [    6.358844]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(22), count(4)
> [    6.358846]     phy(24), attached_handle(0x000c): target add: link
> rate: new(0x0a), old(0x00)
> [    6.367295] igb 0000:04:00.0: added PHC on eth0
> [    6.370876] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [    6.372463] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x000c),
> sas_addr(0x500151b0000020bd)
> [    6.377054] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network
> Connection
> [    6.383081] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(0)
> [    6.383081] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.383086] mpt3sas_cm0: discovery event: (stop)
> [    6.388972] igb 0000:04:00.0: eth0: (PCIe:2.5Gb/s:Width x1)
> 24:4b:fe:5e:68:bf
> [    6.388974] igb 0000:04:00.0: eth0: PBA No: FFFFFF-0FF
> [    6.394735] mpt3sas_cm0: discovery event: (start)
> [    6.400362] igb 0000:04:00.0: Using MSI-X interrupts. 2 rx queue(s),
> 2 tx queue(s)
> [    6.434815] [drm] radeon kernel modesetting enabled.
> [    6.440499] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0003), enclosure logical
> id(0x500151b0000000bf) number slots(0)
> [    6.446531] radeon 0000:05:00.0: remove_conflicting_pci_framebuffers:
> bar 0: 0xd0000000 -> 0xdfffffff
> [    6.458805] mpt3sas_cm0: sas topology change: (add)
> [    6.458812] radeon 0000:05:00.0: remove_conflicting_pci_framebuffers:
> bar 2: 0xfc930000 -> 0xfc93ffff
> [    6.464989]     handle(0x000d), enclosure_handle(0x0003)
> start_phy(00), count(22)
> [    6.471365] checking generic (d0000000 300000) vs hw (d0000000 10000000)
> [    6.476289] asus_wmi: Initialization: 0x0
> [    6.477487] asus_wmi: BIOS WMI version: 0.9
> [    6.477586] asus_wmi: SFUN value: 0x0
> [    6.477655] eeepc-wmi eeepc-wmi: Detected ASUSWMI, use DCTS
> [    6.479350]     phy(06), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.479419] input: Eee PC WMI hotkeys as
> /devices/platform/eeepc-wmi/input/input12
> [    6.484512] fb0: switching to radeondrmfb from EFI VGA
> [    6.669271]     phy(07), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.669272]     phy(08), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.669273]     phy(09), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [    6.669274] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [    6.673474] mpt3sas_cm0: expander_add: handle(0x000d),
> parent(0x0002), sas_addr(0x500151b0000000bf), phys(26)
> [    6.711841] Console: switching to colour dummy device 80x25
> [    6.711869] radeon 0000:05:00.0: vgaarb: deactivate vga console
> [    6.712056] [drm] initializing kernel modesetting (RV515
> 0x1002:0x7143 0x17AF:0x204E 0x00).
> [    6.712138] ATOM BIOS: 113
> [    6.712161] [drm] Generation 2 PCI interface, using max accessible memory
> [    6.712170] radeon 0000:05:00.0: VRAM: 256M 0x0000000000000000 -
> 0x000000000FFFFFFF (256M used)
> [    6.712174] radeon 0000:05:00.0: GTT: 512M 0x0000000010000000 -
> 0x000000002FFFFFFF
> [    6.712184] [drm] Detected VRAM RAM=256M, BAR=256M
> [    6.712186] [drm] RAM width 64bits DDR
> [    6.712244] [TTM] Zone  kernel: Available graphics memory: 32888530 KiB
> [    6.712246] [TTM] Zone   dma32: Available graphics memory: 2097152 KiB
> [    6.712249] [TTM] Initializing pool allocator
> [    6.712254] [TTM] Initializing DMA pool allocator
> [    6.712270] [drm] radeon: 256M of VRAM memory ready
> [    6.712272] [drm] radeon: 512M of GTT memory ready.
> [    6.712280] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    6.712994] [drm] Possible lm63 thermal controller at 0x4c
> [    6.713000] [drm] radeon: power management initialized
> [    6.714418] mpt3sas_cm0: port enable: complete from worker thread
> [    6.714420] mpt3sas_cm0: sas topology change: (responding)
> [    6.714421]     handle(0x000d), enclosure_handle(0x0003)
> start_phy(22), count(4)
> [    6.714423]     phy(24), attached_handle(0x000e): target add: link
> rate: new(0x0a), old(0x00)
> [    6.714424] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [    6.714827] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x000e),
> sas_addr(0x500151b0000000bd)
> [    6.714828] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
> slot(0)
> [    6.714829] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
> [    6.714831] mpt3sas_cm0: discovery event: (stop)
> [    6.719591] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [    6.720471] mpt3sas_cm0: port enable: SUCCESS
> [    6.722260] scsi 6:0:0:0: Direct-Access     ATA      WDC WD5003AZEX-0
> 1A01 PQ: 0 ANSI: 6
> [    6.722268] scsi 6:0:0:0: SATA: handle(0x000b),
> sas_addr(0x500151b0000020b3), phy(19), device_name(0x50014ee20e11ea3d)
> [    6.722271] scsi 6:0:0:0: enclosure logical id (0x500151b0000020bf),
> slot(6)
> [    6.722274] scsi 6:0:0:0: enclosure level(0x0000), connector name( C1  )
> [    6.722326] scsi 6:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
> fua(y), sw_preserve(y)
> [    6.722435] [drm] PCIE GART of 512M enabled (table at
> 0x0000000000040000).
> [    6.722462] radeon 0000:05:00.0: WB enabled
> [    6.722466] radeon 0000:05:00.0: fence driver on ring 0 use gpu addr
> 0x0000000010000000 and cpu addr 0x000000001d35a778
> [    6.722471] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    6.722474] [drm] Driver supports precise vblank timestamp query.
> [    6.722477] radeon 0000:05:00.0: radeon: MSI limited to 32-bit
> [    6.722507] [drm] radeon: irq initialized.
> [    6.722521] [drm] Loading R500 Microcode
> [    6.724438] scsi 6:0:1:0: Enclosure         LSI      VirtualSES
> 01   PQ: 0 ANSI: 6
> [    6.724446] scsi 6:0:1:0: set ignore_delay_remove for handle(0x0009)
> [    6.724448] scsi 6:0:1:0: SES: handle(0x0009),
> sas_addr(0x510600b00cf4d920), phy(8), device_name(0x0000000000000000)
> [    6.724454] scsi 6:0:1:0: enclosure logical id (0x500605b00cf4d920),
> slot(8)
> [    6.724456] scsi 6:0:1:0: enclosure level(0x0000), connector name( C1  )
> [    6.724492] scsi 6:0:1:0: tag#3334 CDB: Mode Sense(6) 1a 00 19 00 40 00
> [    6.724495] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [    6.724497] mpt3sas_cm0: enclosure logical id(0x500605b00cf4d920),
> slot(8)
> [    6.724500] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.724503] mpt3sas_cm0:     handle(0x0009),
> ioc_status(success)(0x0000), smid(3335)
> [    6.724505] mpt3sas_cm0:     request_len(64), underflow(0), resid(64)
> [    6.724508] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    6.724510] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    6.724513] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x20,0x00],
> count(18)
> [    6.724517] mpt3sas_cm0: log_info(0x31200206): originator(PL),
> code(0x20), sub_code(0x0206)
> [    6.725106] scsi 6:0:2:0: Enclosure         Isilon   SEFC SAS2X24 E1
> 0910 PQ: 0 ANSI: 5
> [    6.725112] scsi 6:0:2:0: set ignore_delay_remove for handle(0x000c)
> [    6.725114] scsi 6:0:2:0: SES: handle(0x000c),
> sas_addr(0x500151b0000020bd), phy(24), device_name(0x500151b0000020bd)
> [    6.725119] scsi 6:0:2:0: enclosure logical id (0x500151b0000020bf),
> slot(0)
> [    6.725120] scsi 6:0:2:0: enclosure level(0x0000), connector name( C1  )
> [    6.725186] scsi 6:0:2:0: tag#3341 CDB: Mode Sense(6) 1a 00 19 00 40 00
> [    6.725188] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [    6.725190] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(0)
> [    6.725191] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.725194] mpt3sas_cm0:     handle(0x000c), ioc_status(scsi data
> underrun)(0x0045), smid(3342)
> [    6.725196] mpt3sas_cm0:     request_len(64), underflow(0), resid(64)
> [    6.725197] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    6.725199] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    6.725202] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x24,0x00],
> count(96)
> [    6.726518] radeon 0000:05:00.0: firmware: direct-loading firmware
> radeon/R520_cp.bin
> [    6.726654] [drm] radeon: ring at 0x0000000010001000
> [    6.726694] [drm] ring test succeeded in 3 usecs
> [    6.726847] [drm] ib test succeeded in 0 usecs
> [    6.727250] scsi 6:0:3:0: Enclosure         Isilon   SEFC SAS2X24 E0
> 0910 PQ: 0 ANSI: 5
> [    6.727254] scsi 6:0:3:0: set ignore_delay_remove for handle(0x000e)
> [    6.727257] scsi 6:0:3:0: SES: handle(0x000e),
> sas_addr(0x500151b0000000bd), phy(24), device_name(0x500151b0000000bd)
> [    6.727261] scsi 6:0:3:0: enclosure logical id (0x500151b0000000bf),
> slot(0)
> [    6.727264] scsi 6:0:3:0: enclosure level(0x0000), connector name( C0  )
> [    6.727322] [drm] Radeon Display Connectors
> [    6.727329] scsi 6:0:3:0: tag#3348 CDB: Mode Sense(6) 1a 00 19 00 40 00
> [    6.727331] [drm] Connector 0:
> [    6.727334] [drm]   DVI-I-1
> [    6.727335] [drm]   HPD1
> [    6.727337] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
> 0x7e4c 0x7e4c
> [    6.727339] [drm]   Encoders:
> [    6.727341] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [    6.727346] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [    6.727348] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
> [    6.727349] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
> slot(0)
> [    6.727352] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
> [    6.727355] [drm] Connector 1:
> [    6.727357] mpt3sas_cm0:     handle(0x000e), ioc_status(scsi data
> underrun)(0x0045), smid(3349)
> [    6.727359] mpt3sas_cm0:     request_len(64), underflow(0), resid(64)
> [    6.727363] [drm]   SVIDEO-1
> [    6.727365] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    6.727367] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    6.727371] [drm]   Encoders:
> [    6.727374] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x24,0x00],
> count(96)
> [    6.727393] [drm]     TV1: INTERNAL_KLDSCP_DAC2
> [    6.727397] [drm] Connector 2:
> [    6.727399] [drm]   DVI-I-2
> [    6.727403] [drm]   HPD2
> [    6.727406] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58
> 0x7e5c 0x7e5c
> [    6.727411] [drm]   Encoders:
> [    6.727414] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
> [    6.727416] [drm]     DFP3: INTERNAL_LVTM1
> [    6.729016] sd 6:0:0:0: Attached scsi generic sg1 type 0
> [    6.729130] scsi 6:0:1:0: Attached scsi generic sg2 type 13
> [    6.729229] scsi 6:0:2:0: Attached scsi generic sg3 type 13
> [    6.729351] scsi 6:0:3:0: Attached scsi generic sg4 type 13
> [    6.731196] sd 6:0:0:0: [sdb] 976773168 512-byte logical blocks: (500
> GB/466 GiB)
> [    6.731202] sd 6:0:0:0: [sdb] 4096-byte physical blocks
> [    6.734934] sd 6:0:0:0: [sdb] Write Protect is off
> [    6.734938] sd 6:0:0:0: [sdb] Mode Sense: 9b 00 10 08
> [    6.735819] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, supports DPO and FUA
> [    6.735871] sd 6:0:0:0: tag#2632 CDB: Report supported operation
> codes a3 0c 01 12 00 00 00 00 02 00 00 00
> [    6.735876] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    6.735880] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    6.735883] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.735886] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(2633)
> [    6.735890] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
> [    6.735893] mpt3sas_cm0:     tag(65535), transfer_count(0),
> sc->result(0x00000002)
> [    6.735897] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    6.735901] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x20,0x00],
> count(18)
> [    6.753527] XFS (sda4): Mounting V5 Filesystem
> [    6.757895] kvm: disabled by bios
> [    6.772663] XFS (sda4): Ending clean mount
> [    6.774348] xfs filesystem being mounted at /home supports timestamps
> until 2038 (0x7fffffff)
> [    6.817034]  sdb: sdb1 sdb2 sdb3 sdb4 sdb5
> [    6.825081] sd 6:0:0:0: [sdb] Attached SCSI disk
> [    6.856253] MCE: In-kernel MCE decoding enabled.
> [    6.865907] EDAC amd64: Node 0: DRAM ECC enabled.
> [    6.865911] EDAC amd64: F17h_M70h detected (node 0).
> [    6.866904] EDAC MC: UMC0 chip selects:
> [    6.866905] EDAC amd64: MC: 0:  8192MB 1:  8192MB
> [    6.866907] EDAC amd64: MC: 2:  8192MB 3:  8192MB
> [    6.866961] EDAC MC: UMC1 chip selects:
> [    6.866961] EDAC amd64: MC: 0:  8192MB 1:  8192MB
> [    6.866962] EDAC amd64: MC: 2:  8192MB 3:  8192MB
> [    6.866963] EDAC amd64: using x16 syndromes.
> [    6.866965] EDAC amd64: MCT channel count: 2
> [    6.867220] EDAC MC0: Giving out device to module amd64_edac
> controller F17h_M70h: DEV 0000:00:18.3 (INTERRUPT)
> [    6.867228] EDAC PCI0: Giving out device to module amd64_edac
> controller EDAC PCI controller: DEV 0000:00:18.0 (POLLED)
> [    6.867230] AMD64 EDAC driver v3.5.0
> [    6.875930] kvm: disabled by bios
> [    6.889531] [drm] fb mappable at 0xD00C0000
> [    6.889534] [drm] vram apper at 0xD0000000
> [    6.889535] [drm] size 9216000
> [    6.889536] [drm] fb depth is 24
> [    6.889537] [drm]    pitch is 7680
> [    6.889601] fbcon: radeondrmfb (fb0) is primary device
> [    6.891023] sd 6:0:0:0: [sdb] tag#832 CDB: ATA command pass
> through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
> [    6.891026] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    6.891026] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    6.891027] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.891028] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(833)
> [    6.891029] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
> [    6.891029] mpt3sas_cm0:     tag(0), transfer_count(512),
> sc->result(0x00000002)
> [    6.891030] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    6.891031] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
> count(22)
> [    6.891534] scsi 6:0:1:0: tag#3463 CDB: Receive Diagnostic 1c 01 07
> 00 20 00
> [    6.891535] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [    6.891536] mpt3sas_cm0: enclosure logical id(0x500605b00cf4d920),
> slot(8)
> [    6.891537] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    6.891537] mpt3sas_cm0:     handle(0x0009),
> ioc_status(success)(0x0000), smid(3464)
> [    6.891538] mpt3sas_cm0:     request_len(32), underflow(0), resid(32)
> [    6.891538] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    6.891539] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    6.891539] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x26,0x00],
> count(18)
> [    6.891540] mpt3sas_cm0: log_info(0x31200205): originator(PL),
> code(0x20), sub_code(0x0205)
> [    6.896634] ses 6:0:1:0: Attached Enclosure device
> [    6.896644] ses 6:0:2:0: Attached Enclosure device
> [    6.896650] ses 6:0:3:0: Attached Enclosure device
> [    6.909222] EXT4-fs (sda1): mounting ext2 file system using the ext4
> subsystem
> [    6.909618] EXT4-fs (sda1): mounted filesystem without journal. Opts:
> (null)
> [    6.909621] ext2 filesystem being mounted at /boot supports
> timestamps until 2038 (0x7fffffff)
> [    6.929509] Console: switching to colour frame buffer device 240x75
> [    6.984066] radeon 0000:05:00.0: fb0: radeondrmfb frame buffer device
> [    7.036501] [drm] Initialized radeon 2.50.0 20080528 for 0000:05:00.0
> on minor 0
> [    7.053620] kvm: disabled by bios
> [    7.100352] FAT-fs (sda2): Volume was not properly unmounted. Some
> data may be corrupt. Please run fsck.
> [    7.123108] sd 6:0:0:0: [sdb] tag#1426 CDB: ATA command pass
> through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
> [    7.123333] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    7.123526] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    7.123741] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    7.123948] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(1427)
> [    7.124182] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
> [    7.124377] mpt3sas_cm0:     tag(0), transfer_count(512),
> sc->result(0x00000002)
> [    7.124600] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    7.124876] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
> count(22)
> [    7.125499] audit: type=1400 audit(1600450973.541:2):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="nvidia_modprobe" pid=689 comm="apparmor_parser"
> [    7.125878] audit: type=1400 audit(1600450973.541:3):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="nvidia_modprobe//kmod" pid=689 comm="apparmor_parser"
> [    7.137713] audit: type=1400 audit(1600450973.541:4):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="/usr/bin/man" pid=690 comm="apparmor_parser"
> [    7.149345] audit: type=1400 audit(1600450973.541:5):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="man_filter" pid=690 comm="apparmor_parser"
> [    7.149347] audit: type=1400 audit(1600450973.541:6):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="man_groff" pid=690 comm="apparmor_parser"
> [    7.149350] audit: type=1400 audit(1600450973.549:7):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="/usr/sbin/ntpd" pid=691 comm="apparmor_parser"
> [    7.185702] kvm: disabled by bios
> [    7.292119] kvm: disabled by bios
> [    7.359061] kvm: disabled by bios
> [    7.450526] kvm: disabled by bios
> [    7.546800] kvm: disabled by bios
> [    7.601959] sd 6:0:0:0: [sdb] tag#278 CDB: ATA command pass
> through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
> [    7.601962] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    7.601963] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    7.601964] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    7.601965] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(279)
> [    7.601966] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
> [    7.601967] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    7.601968] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    7.601969] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
> count(22)
> [    7.610237] sd 6:0:0:0: [sdb] tag#284 CDB: ATA command pass
> through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [    7.727125] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    7.727125] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    7.727126] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    7.727127] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(285)
> [    7.727127] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
> [    7.727128] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    7.727128] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    7.727129] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
> count(22)
> [    7.734211] sd 6:0:0:0: [sdb] tag#354 CDB: ATA command pass
> through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [    7.838779] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    7.838780] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    7.838781] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    7.838782] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(355)
> [    7.838783] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
> [    7.838783] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    7.838784] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    7.838785] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
> count(22)
> [    7.885268] sd 6:0:0:0: [sdb] tag#1427 CDB: ATA command pass
> through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
> [    7.951419] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    7.951419] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
> slot(6)
> [    7.951420] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
> [    7.951420] mpt3sas_cm0:     handle(0x000b),
> ioc_status(success)(0x0000), smid(1428)
> [    7.951421] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
> [    7.951421] mpt3sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [    7.951421] mpt3sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [    7.951421] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
> count(22)
> [    8.052627] kvm: disabled by bios
> [    8.146950] mpt3sas_cm0: _ctl_getiocinfo: enter
> [    8.158984] mpt3sas_cm0: ctl_request: ioc_facts, smid(8581)
> [    8.171051] mpt3sas_cm0: ctl_done: ioc_facts, smid(8581)
> [    8.183184] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.195402] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.207636] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.219908] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.219918] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.244861] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.244977] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.270004] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.270081] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.295472] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.295513] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.321310] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.321319] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.347465] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.347521] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.374058] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.374097] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.400984] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.401000] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.427990] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.428001] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.428019] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.469069] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.469103] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.496705] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.496721] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.524986] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.525022] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553582] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553614] kvm: disabled by bios
> [    8.553819] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553858] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553960] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553973] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553991] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.553996] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554049] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554170] mpt3sas_cm0: _ctl_btdh_mapping
> [    8.554174] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554186] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554191] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554207] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554212] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.554228] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.554229] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.554230] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [    8.554230] mpt3sas_cm0:
> enclosure_logical_id(0x500605b00cf4d920), slot(8)
> [    8.554236] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.554251] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.554251] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.554252] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [    8.554252] mpt3sas_cm0:
> enclosure_logical_id(0x500605b00cf4d920), slot(8)
> [    8.554257] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554270] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554274] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554290] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554295] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554307] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554413] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554444] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554447] mpt3sas_cm0: _ctl_btdh_mapping
> [    8.554450] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554463] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554467] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554483] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.554488] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.554946] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.554946] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.554947] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    8.554947] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [    8.554961] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.555383] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.555383] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.555384] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    8.555384] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [    8.555457] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
> cdb_len(10), smid(8581)
> [    8.555511] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
> smid(8581)
> [    8.555522] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556001] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556002] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.556002] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    8.556002] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [    8.556007] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556420] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556420] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.556420] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [    8.556421] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [    8.556425] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556467] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556512] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556553] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556565] mpt3sas_cm0: _ctl_btdh_mapping
> [    8.556568] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556580] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556591] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556613] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556620] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556776] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556776] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.556776] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [    8.556777] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(0)
> [    8.556781] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556892] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.556892] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.556893] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [    8.556893] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(0)
> [    8.556898] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556910] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556915] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556931] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556936] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556948] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.556952] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557005] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557021] mpt3sas_cm0: _ctl_btdh_mapping
> [    8.557024] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557046] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557056] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557080] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557088] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.557265] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.557271] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.557272] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [    8.557272] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000000bf), slot(0)
> [    8.557291] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.557372] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [    8.557372] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [    8.557372] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [    8.557373] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000000bf), slot(0)
> [    8.557377] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557390] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557395] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557417] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [    8.557418] mpt3sas_cm0:     iocstatus(0x0022), loginfo(0x310f0400)
> [    8.557423] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [    8.557469] mpt3sas_cm0: ctl_done: fw_upload, smid(8581)
> [    8.557596] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [    8.557618] mpt3sas_cm0: ctl_done: fw_upload, smid(8581)
> [    8.557626] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [    9.160394] bna 0000:03:00.3 ethLAN: link up
> [   10.067792] IPv6: ADDRCONF(NETDEV_CHANGE): ethLAN: link becomes ready
> [   10.148328] kvm: disabled by bios
> [   10.187178] kvm: disabled by bios
> [   10.242453] kvm: disabled by bios
> [   10.309501] kvm: disabled by bios
> [   10.369883] kvm: disabled by bios
> [   10.425949] kvm: disabled by bios
> [   68.879752] mpt3sas_cm0: Command Timeout
> [   68.887309] mf:
>
> [   68.887309] 12000002
> [   68.901510] 00000000
> [   68.908379] 00000000
> [   68.908379] 00000000
> [   68.908379] 00000000
> [   68.908380] 000c0000
> [   68.908380] 00000000
> [   68.908380] 00010000
> [   68.908381]
>
> [   68.908381] 00010000
>
> [   68.908383] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: enter
> [   68.908391] mpt3sas_cm0: mpt3sas_scsih_pre_reset_handler:
> MPT3_IOC_PRE_RESET
> [   68.989895] mpt3sas_cm0: mpt3sas_ctl_pre_reset_handler:
> MPT3_IOC_PRE_RESET
> [   68.989896] mpt3sas_cm0: _base_pre_reset_handler: MPT3_IOC_PRE_RESET
> [   68.989900] mpt3sas_cm0: _base_make_ioc_ready
> [   68.989901] mpt3sas_cm0: sending diag reset !!
> [   69.745230] mpt3sas_cm0: diag reset: SUCCESS
> [   69.751663] mpt3sas_cm0: mpt3sas_scsih_after_reset_handler:
> MPT3_IOC_AFTER_RESET
> [   69.758505] mpt3sas_cm0: completing 0 cmds
> [   69.765288] mpt3sas_cm0: mpt3sas_ctl_after_reset_handler:
> MPT3_IOC_AFTER_RESET
> [   69.772370] mpt3sas_cm0: _base_after_reset_handler: MPT3_IOC_AFTER_RESET
> [   69.772371] mpt3sas_cm0: _base_get_ioc_facts
> [   69.772371] mpt3sas_cm0: _base_wait_for_iocstate
> [   69.811726]     offset:data
> [   69.818874]     [0x00]:03110206
> [   69.826173]     [0x04]:00002e00
> [   69.833499]     [0x08]:00000000
> [   69.833500]     [0x0c]:00000000
> [   69.833501]     [0x10]:00000000
> [   69.833502]     [0x14]:80010080
> [   69.833504]     [0x18]:22312200
> [   69.833506]     [0x1c]:000fa84c
> [   69.833507]     [0x20]:02000500
> [   69.833510]     [0x24]:00080020
> [   69.892476]     [0x28]:0280001d
> [   69.892477]     [0x2c]:00d100d0
> [   69.892477]     [0x30]:0074000b
> [   69.892478]     [0x34]:0020ffe0
> [   69.892478]     [0x38]:00800375
> [   69.892479]     [0x3c]:00000009
> [   69.892479]     [0x40]:00000000
> [   69.892480] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default
> host page size to 4k
> [   69.892480] mpt3sas_cm0: CurrentHostPageSize(0)
> [   69.892481] mpt3sas_cm0: hba queue depth(8704), max chains per io(128)
> [   69.892482] mpt3sas_cm0: request frame size(128), reply frame size(128)
> [   69.892483] mpt3sas_cm0: _base_make_ioc_operational
> [   69.893121] mpt3sas_cm0: _base_send_ioc_init
> [   69.991186]     offset:data
> [   69.991186]     [0x00]:02000004
> [   69.991187]     [0x04]:01000000
> [   69.991187]     [0x08]:00000000
> [   69.991188]     [0x0c]:36000206
> [   69.991188]     [0x10]:00000000
> [   69.991188]     [0x14]:200c0000
> [   69.991189]     [0x18]:00200000
> [   69.991189]     [0x1c]:22b44530
> [   69.991189]     [0x20]:0000000f
> [   69.991190]     [0x24]:0000000f
> [   69.991190]     [0x28]:dbe00000
> [   69.991191]     [0x2c]:0000000f
> [   69.991191]     [0x30]:e4a34000
> [   69.991191]     [0x34]:0000000f
> [   69.991192]     [0x38]:dc110000
> [   69.991192]     [0x3c]:0000000f
> [   69.991192]     [0x40]:a250c7b5
> [   69.991193]     [0x44]:00000174
> [   70.022796]     offset:data
> [   70.118934]     [0x00]:02050004
> [   70.118935]     [0x04]:01000000
> [   70.118935]     [0x08]:00000000
> [   70.118936]     [0x0c]:00000000
> [   70.118936]     [0x10]:00000000
> [   70.118939] mpt3sas_cm0: _base_display_fwpkg_version
> [   70.191290] mpt3sas_cm0: _base_display_fwpkg_version: complete
> [   70.195623] mpt3sas_cm0: FW Package Version (02.00.05.02)
> [   70.200410] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00),
> ChipRevision(0x01), BiosVersion(09.03.00.00)
> [   70.205150] NVMe
> [   70.205150] mpt3sas_cm0: Protocol=(Initiator,Target),
> Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
> [   70.210036] mpt3sas_cm0: _base_event_notification
> [   70.220814] mpt3sas_cm0: _base_event_notification: complete
> [   70.220814] mpt3sas_cm0: sending port enable !!
> [   71.853536] mpt3sas_cm0: Discovery: (start)
> [   71.859026] mpt3sas_cm0: SAS Enclosure Device Status Change
> [   71.859030] mpt3sas_cm0: discovery event: (start)
> [   71.864731] mpt3sas_cm0: SAS Topology Change List
> [   71.864732] mpt3sas_cm0: SAS Topology Change List
> [   71.864734] mpt3sas_cm0: SAS Enclosure Device Status Change
> [   71.864735] mpt3sas_cm0: SAS Topology Change List
> [   71.870479] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0001), enclosure logical
> id(0x500605b00cf4d920) number slots(0)
> [   71.876158] mpt3sas_cm0: SAS Topology Change List
> [   71.910000] mpt3sas_cm0: sas topology change: (responding)
> [   71.910001]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(08), count(1)
> [   71.910002]     phy(08), attached_handle(0x0009): target add: link
> rate: new(0x08), old(0x00)
> [   71.910003] mpt3sas_cm0: sas topology change: (responding)
> [   71.910004]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(00), count(7)
> [   71.910006]     phy(00), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.945304]     phy(02), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.945304]     phy(04), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.945304]     phy(06), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.945313] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0002), enclosure logical
> id(0x500151b0000020bf) number slots(0)
> [   71.975885] mpt3sas_cm0: sas topology change: (add)
> [   71.975887]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(00), count(22)
> [   71.975888]     phy(06), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.975888]     phy(07), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.975889]     phy(08), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.975890]     phy(09), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [   71.975891]     phy(19), attached_handle(0x000b): target add: link
> rate: new(0x0a), old(0x00)
> [   71.975892] mpt3sas_cm0: sas topology change: (responding)
> [   71.975892]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(22), count(4)
> [   71.975893]     phy(24), attached_handle(0x000c): target add: link
> rate: new(0x0a), old(0x00)
> [   72.103541] mpt3sas_cm0: Discovery: (start)
> [   72.110979] mpt3sas_cm0: SAS Topology Change List
> [   72.110982] mpt3sas_cm0: discovery event: (start)
> [   72.118591] mpt3sas_cm0: SAS Topology Change List
> [   72.118592] mpt3sas_cm0: SAS Enclosure Device Status Change
> [   72.118593] mpt3sas_cm0: SAS Topology Change List
> [   72.118598] mpt3sas_cm0: SAS Topology Change List
> [   72.156314] mpt3sas_cm0: sas topology change: (responding)
> [   72.156315]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(01), count(7)
> [   72.156315]     phy(01), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156316]     phy(02), attached_handle(0x000a): target responding:
> link rate: new(0x0a), old(0x00)
> [   72.156316]     phy(03), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156316]     phy(04), attached_handle(0x000a): target responding:
> link rate: new(0x0a), old(0x00)
> [   72.156317]     phy(05), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156317]     phy(06), attached_handle(0x000a): target responding:
> link rate: new(0x0a), old(0x00)
> [   72.156318]     phy(07), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156318] mpt3sas_cm0: sas topology change: (responding)
> [   72.156318]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(19), count(1)
> [   72.156319]     phy(19), attached_handle(0x000b): link rate change:
> link rate: new(0x0a), old(0x0a)
> [   72.156320] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0003), enclosure logical
> id(0x500151b0000000bf) number slots(0)
> [   72.156320] mpt3sas_cm0: sas topology change: (add)
> [   72.156321]     handle(0x000d), enclosure_handle(0x0003)
> start_phy(00), count(22)
> [   72.156321]     phy(06), attached_handle(0x0005): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156321]     phy(07), attached_handle(0x0005): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156322]     phy(08), attached_handle(0x0005): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156323]     phy(09), attached_handle(0x0005): link rate change:
> link rate: new(0x0a), old(0x00)
> [   72.156325] mpt3sas_cm0: sas topology change: (responding)
> [   72.156326]     handle(0x000d), enclosure_handle(0x0003)
> start_phy(22), count(4)
> [   72.156328]     phy(24), attached_handle(0x000e): target add: link
> rate: new(0x0a), old(0x00)
> [   72.353925] mpt3sas_cm0: Discovery: (stop)
> [   72.371312] mpt3sas_cm0: Discovery: (stop)
> [   72.371315] mpt3sas_cm0: discovery event: (stop)
> [   72.371315] mpt3sas_cm0: discovery event: (stop)
> [   77.353498] mpt3sas_cm0: port enable: SUCCESS
> [   77.363833] mpt3sas_cm0: mpt3sas_scsih_reset_done_handler:
> MPT3_IOC_DONE_RESET
> [   77.374684] mpt3sas_cm0: search for end-devices: start
> [   77.385546] scsi target6:0:1: handle(0x0009),
> sas_addr(0x510600b00cf4d920)
> [   77.396152] scsi target6:0:1: enclosure logical
> id(0x500605b00cf4d920), slot(8)
> [   77.406843] scsi target6:0:0: handle(0x000b),
> sas_addr(0x500151b0000020b3)
> [   77.417268] scsi target6:0:0: enclosure logical
> id(0x500151b0000020bf), slot(6)
> [   77.427710] scsi target6:0:2: handle(0x000c),
> sas_addr(0x500151b0000020bd)
> [   77.427712] scsi target6:0:2: enclosure logical
> id(0x500151b0000020bf), slot(0)
> [   77.448783] scsi target6:0:3: handle(0x000e),
> sas_addr(0x500151b0000000bd)
> [   77.459308] scsi target6:0:3: enclosure logical
> id(0x500151b0000000bf), slot(0)
> [   77.470000] mpt3sas_cm0: search for end-devices: complete
> [   77.480641] mpt3sas_cm0: search for end-devices: start
> [   77.491272] mpt3sas_cm0: search for PCIe end-devices: complete
> [   77.502007] mpt3sas_cm0: search for expanders: start
> [   77.502113]     expander present: handle(0x000a),
> sas_addr(0x500151b0000020bf)
> [   77.523613]     expander present: handle(0x000d),
> sas_addr(0x500151b0000000bf)
> [   77.534367] mpt3sas_cm0: search for expanders: complete
> [   77.545023] mpt3sas_cm0: mpt3sas_ctl_reset_done_handler:
> MPT3_IOC_DONE_RESET
> [   77.555713] mpt3sas_cm0: _base_reset_done_handler: MPT3_IOC_DONE_RESET
> [   77.555713] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: SUCCESS
> [   77.555714] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: exit
> [   78.575634] mpt3sas_cm0: removing unresponding devices: start
> [   78.585937] mpt3sas_cm0: removing unresponding devices: end-devices
> [   78.596230] mpt3sas_cm0: Removing unresponding devices: pcie end-devices
> [   78.606367] mpt3sas_cm0: removing unresponding devices: expanders
> [   78.606368] mpt3sas_cm0: removing unresponding devices: complete
> [   78.606369] mpt3sas_cm0: scan devices: start
> [   78.606370] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [   78.607152] mpt3sas_cm0:     scan devices: expanders start
> [   78.659435] mpt3sas_cm0:     break from expander scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [   78.669551] mpt3sas_cm0:     scan devices: expanders complete
> [   78.669552] mpt3sas_cm0:     scan devices: end devices start
> [   78.670587] mpt3sas_cm0:     break from end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [   78.699907] mpt3sas_cm0:     scan devices: end devices complete
> [   78.699907] mpt3sas_cm0:     scan devices: pcie end devices start
> [   78.700119] mpt3sas_cm0:     break from pcie end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [   78.731217] mpt3sas_cm0:     pcie devices: pcie end devices complete
> [   78.731218] mpt3sas_cm0: scan devices: complete
> [  677.567291] mpt3sas_cm0: _ctl_getiocinfo: enter
> [  677.577460] mpt3sas_cm0: ctl_request: ioc_facts, smid(8581)
> [  677.587613] mpt3sas_cm0: ctl_done: ioc_facts, smid(8581)
> [  677.597890] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.608186] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.618657] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.629266] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.629272] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.650852] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.650858] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.672893] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.683876] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.684047] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.706014] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.706122] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.728363] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.739624] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.739647] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.762200] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.762205] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.784756] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.795984] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.807221] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.807234] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.829694] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.829699] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.852316] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.863907] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.864137] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.887400] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.887548] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.910906] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.922642] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.922651] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.946589] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.946594] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.971078] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.983319] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  677.983553] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.007850] mpt3sas_cm0: _ctl_btdh_mapping
> [  678.007906] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.032405] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.044818] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.045057] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.069814] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.069952] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.094872] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  678.094873] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [  678.094874] mpt3sas_cm0:
> enclosure_logical_id(0x500605b00cf4d920), slot(8)
> [  678.095062] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.145198] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.157844] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  678.157845] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [  678.157845] mpt3sas_cm0:
> enclosure_logical_id(0x500605b00cf4d920), slot(8)
> [  678.158021] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.208846] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.209066] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.234755] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.234987] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.261144] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.274521] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.274696] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.301744] mpt3sas_cm0: _ctl_btdh_mapping
> [  678.301753] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.329204] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.329439] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.356952] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.357046] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.594081] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.607903] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  678.621760] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [  678.635683] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [  678.649580] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.663749] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.677515] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  678.691429] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [  678.705367] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [  678.719399] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
> cdb_len(10), smid(8581)
> [  678.733468] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
> smid(8581)
> [  678.733469] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [  678.733470] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [  678.733471] mpt3sas_cm0:     scsi_state(0x01), scsi_status(0x02)
> [  678.733482] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
> cdb_len(10), smid(8581)
> [  678.802563] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
> smid(8581)
> [  678.816233] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.816637] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.843527] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  678.843528] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [  678.843528] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [  678.843704] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.897753] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  678.910995] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  678.924279] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [  678.937495] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [  678.950696] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.963950] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.963956] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.990425] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  678.990429] mpt3sas_cm0: _ctl_btdh_mapping
> [  679.016727] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.016942] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.043201] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.043330] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.069674] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.082995] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.096031] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  679.109094] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [  679.122090] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(0)
> [  679.135067] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.148087] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.160889] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  679.173705] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [  679.186455] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(0)
> [  679.199192] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.211977] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.211993] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.237519] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.237531] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.263052] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.263200] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.288658] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.301510] mpt3sas_cm0: _ctl_btdh_mapping
> [  679.301518] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.327333] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.327568] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.353457] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.366563] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.379860] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.392932] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  679.406032] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [  679.419061] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000000bf), slot(0)
> [  679.432073] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.445117] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [  679.457961] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [  679.470818] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [  679.483605] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000000bf), slot(0)
> [  679.496384] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.509207] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.509227] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.534847] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [  679.534847] mpt3sas_cm0:     iocstatus(0x0022), loginfo(0x310f0400)
> [  679.534854] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [  679.573022] mpt3sas_cm0: ctl_done: fw_upload, smid(8581)
> [  679.585629] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [  679.585720] mpt3sas_cm0: ctl_done: fw_upload, smid(8581)
> [  679.610582] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [  740.619512] mpt3sas_cm0: Command Timeout
> [  740.631765] mf:
>
> [  740.631765] 12000002
> [  740.656037] 00000000
> [  740.668023] 00000000
> [  740.668024] 00000000
> [  740.668024] 00000000
> [  740.668024] 000c0000
> [  740.668025] 00000000
> [  740.668025] 00010000
> [  740.668025]
>
> [  740.668026] 00010000
>
> [  740.668027] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: enter
> [  740.668041] mpt3sas_cm0: mpt3sas_scsih_pre_reset_handler:
> MPT3_IOC_PRE_RESET
> [  740.812296] mpt3sas_cm0: mpt3sas_ctl_pre_reset_handler:
> MPT3_IOC_PRE_RESET
> [  740.812297] mpt3sas_cm0: _base_pre_reset_handler: MPT3_IOC_PRE_RESET
> [  740.812300] mpt3sas_cm0: _base_make_ioc_ready
> [  740.812302] mpt3sas_cm0: sending diag reset !!
> [  741.609001] mpt3sas_cm0: diag reset: SUCCESS
> [  741.619266] mpt3sas_cm0: mpt3sas_scsih_after_reset_handler:
> MPT3_IOC_AFTER_RESET
> [  741.629752] mpt3sas_cm0: completing 0 cmds
> [  741.629753] mpt3sas_cm0: mpt3sas_ctl_after_reset_handler:
> MPT3_IOC_AFTER_RESET
> [  741.629754] mpt3sas_cm0: _base_after_reset_handler: MPT3_IOC_AFTER_RESET
> [  741.629755] mpt3sas_cm0: _base_get_ioc_facts
> [  741.629755] mpt3sas_cm0: _base_wait_for_iocstate
> [  741.682512]     offset:data
> [  741.692264]     [0x00]:03110206
> [  741.701987]     [0x04]:00002e00
> [  741.711559]     [0x08]:00000000
> [  741.711559]     [0x0c]:00000000
> [  741.711560]     [0x10]:00000000
> [  741.711560]     [0x14]:80010080
> [  741.711561]     [0x18]:22312200
> [  741.711561]     [0x1c]:000fa84c
> [  741.711562]     [0x20]:02000500
> [  741.711564]     [0x24]:00080020
> [  741.711567]     [0x28]:0280001d
> [  741.711569]     [0x2c]:00d100d0
> [  741.800018]     [0x30]:0074000b
> [  741.800019]     [0x34]:0020ffe0
> [  741.800019]     [0x38]:00800375
> [  741.800019]     [0x3c]:00000009
> [  741.800020]     [0x40]:00000000
> [  741.800021] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default
> host page size to 4k
> [  741.800022] mpt3sas_cm0: CurrentHostPageSize(0)
> [  741.800023] mpt3sas_cm0: hba queue depth(8704), max chains per io(128)
> [  741.861639] mpt3sas_cm0: request frame size(128), reply frame size(128)
> [  741.861640] mpt3sas_cm0: _base_make_ioc_operational
> [  741.863502] mpt3sas_cm0: _base_send_ioc_init
> [  741.883383]     offset:data
> [  741.883383]     [0x00]:02000004
> [  741.883384]     [0x04]:01000000
> [  741.883384]     [0x08]:00000000
> [  741.883384]     [0x0c]:36000206
> [  741.883385]     [0x10]:00000000
> [  741.883385]     [0x14]:200c0000
> [  741.883386]     [0x18]:00200000
> [  741.883386]     [0x1c]:22b44530
> [  741.883386]     [0x20]:0000000f
> [  741.883387]     [0x24]:0000000f
> [  741.883388]     [0x28]:dbe00000
> [  741.957933]     [0x2c]:0000000f
> [  741.957933]     [0x30]:e4a34000
> [  741.957934]     [0x34]:0000000f
> [  741.957934]     [0x38]:dc110000
> [  741.957935]     [0x3c]:0000000f
> [  741.957935]     [0x40]:a25b084d
> [  741.957936]     [0x44]:00000174
> [  741.984651]     offset:data
> [  741.996808]     [0x00]:02050004
> [  741.996808]     [0x04]:01000000
> [  741.996809]     [0x08]:00000000
> [  741.996809]     [0x0c]:00000000
> [  741.996809]     [0x10]:00000000
> [  741.996813] mpt3sas_cm0: _base_display_fwpkg_version
> [  742.069218] mpt3sas_cm0: _base_display_fwpkg_version: complete
> [  742.073541] mpt3sas_cm0: FW Package Version (02.00.05.02)
> [  742.078297] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00),
> ChipRevision(0x01), BiosVersion(09.03.00.00)
> [  742.083024] NVMe
> [  742.083024] mpt3sas_cm0: Protocol=(Initiator,Target),
> Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
> [  742.088068] mpt3sas_cm0: _base_event_notification
> [  742.098677] mpt3sas_cm0: _base_event_notification: complete
> [  742.104153] mpt3sas_cm0: sending port enable !!
> [  743.841837] mpt3sas_cm0: Discovery: (start)
> [  743.847343] mpt3sas_cm0: SAS Enclosure Device Status Change
> [  743.847347] mpt3sas_cm0: discovery event: (start)
> [  743.853060] mpt3sas_cm0: SAS Topology Change List
> [  743.853062] mpt3sas_cm0: SAS Topology Change List
> [  743.853063] mpt3sas_cm0: Discovery: (start)
> [  743.853065] mpt3sas_cm0: SAS Topology Change List
> [  743.860051] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0001), enclosure logical
> id(0x500605b00cf4d920) number slots(0)
> [  743.864520] mpt3sas_cm0: SAS Enclosure Device Status Change
> [  743.864521] mpt3sas_cm0: SAS Topology Change List
> [  743.864523] mpt3sas_cm0: SAS Topology Change List
> [  743.864525] mpt3sas_cm0: SAS Enclosure Device Status Change
> [  743.864526] mpt3sas_cm0: SAS Topology Change List
> [  743.864527] mpt3sas_cm0: SAS Topology Change List
> [  743.870153] mpt3sas_cm0: sas topology change: (responding)
> [  743.930828]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(08), count(1)
> [  743.930829]     phy(08), attached_handle(0x0009): target add: link
> rate: new(0x08), old(0x00)
> [  743.930837] mpt3sas_cm0: sas topology change: (responding)
> [  743.930839]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(00), count(7)
> [  743.930840]     phy(00), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [  743.930841]     phy(02), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [  743.930842]     phy(04), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [  743.930845]     phy(06), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [  743.930848] mpt3sas_cm0: discovery event: (start)
> [  743.984521] mpt3sas_cm0: sas topology change: (responding)
> [  743.984521]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(01), count(7)
> [  743.984522]     phy(01), attached_handle(0x000b): link rate change:
> link rate: new(0x0a), old(0x00)
> [  743.984522]     phy(03), attached_handle(0x000b): link rate change:
> link rate: new(0x0a), old(0x00)
> [  743.984524]     phy(05), attached_handle(0x000b): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017637]     phy(07), attached_handle(0x000b): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017642] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0003), enclosure logical
> id(0x500151b0000000bf) number slots(0)
> [  744.017643] mpt3sas_cm0: sas topology change: (add)
> [  744.017643]     handle(0x000b), enclosure_handle(0x0003)
> start_phy(00), count(22)
> [  744.017644]     phy(06), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017644]     phy(07), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017645]     phy(08), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017645]     phy(09), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017646] mpt3sas_cm0: sas topology change: (responding)
> [  744.017646]     handle(0x000b), enclosure_handle(0x0003)
> start_phy(22), count(4)
> [  744.017647]     phy(24), attached_handle(0x000e): target add: link
> rate: new(0x0a), old(0x00)
> [  744.017647] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0002), enclosure logical
> id(0x500151b0000020bf) number slots(0)
> [  744.017648] mpt3sas_cm0: sas topology change: (add)
> [  744.017648]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(00), count(22)
> [  744.017649]     phy(06), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017649]     phy(07), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.017651]     phy(08), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.091854] mpt3sas_cm0: Discovery: (start)
> [  744.095823]     phy(09), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [  744.103240] mpt3sas_cm0: Discovery: (stop)
> [  744.103242] mpt3sas_cm0: SAS Topology Change List
> [  744.118548]     phy(19), attached_handle(0x000c): target add: link
> rate: new(0x0a), old(0x00)
> [  744.203304] mpt3sas_cm0: sas topology change: (responding)
> [  744.203305]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(22), count(4)
> [  744.203306]     phy(24), attached_handle(0x000d): target add: link
> rate: new(0x0a), old(0x00)
> [  744.203307] mpt3sas_cm0: discovery event: (start)
> [  744.203308] mpt3sas_cm0: discovery event: (stop)
> [  744.251107] mpt3sas_cm0: sas topology change: (responding)
> [  744.251108]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(19), count(1)
> [  744.251109]     phy(19), attached_handle(0x000c): link rate change:
> link rate: new(0x0a), old(0x0a)
> [  744.341838] mpt3sas_cm0: Discovery: (stop)
> [  744.352020] mpt3sas_cm0: Discovery: (stop)
> [  744.352029] mpt3sas_cm0: discovery event: (stop)
> [  744.372673] mpt3sas_cm0: discovery event: (stop)
> [  749.341800] mpt3sas_cm0: port enable: SUCCESS
> [  749.351973] mpt3sas_cm0: mpt3sas_scsih_reset_done_handler:
> MPT3_IOC_DONE_RESET
> [  749.362528] mpt3sas_cm0: search for end-devices: start
> [  749.373009] scsi target6:0:1: handle(0x0009),
> sas_addr(0x510600b00cf4d920)
> [  749.383183] scsi target6:0:1: enclosure logical
> id(0x500605b00cf4d920), slot(8)
> [  749.393456] scsi target6:0:0: handle(0x000c),
> sas_addr(0x500151b0000020b3)
> [  749.403422] scsi target6:0:0: enclosure logical
> id(0x500151b0000020bf), slot(6)
> [  749.413603]     handle changed from(0x000b)!!!
> [  749.423807] scsi target6:0:2: handle(0x000d),
> sas_addr(0x500151b0000020bd)
> [  749.423808] scsi target6:0:2: enclosure logical
> id(0x500151b0000020bf), slot(0)
> [  749.423809]     handle changed from(0x000c)!!!
> [  749.423943] scsi target6:0:3: handle(0x000e),
> sas_addr(0x500151b0000000bd)
> [  749.465449] scsi target6:0:3: enclosure logical
> id(0x500151b0000000bf), slot(0)
> [  749.465725] mpt3sas_cm0: search for end-devices: complete
> [  749.486921] mpt3sas_cm0: search for end-devices: start
> [  749.486922] mpt3sas_cm0: search for PCIe end-devices: complete
> [  749.486922] mpt3sas_cm0: search for expanders: start
> [  749.487096]     expander present: handle(0x000a),
> sas_addr(0x500151b0000020bf)
> [  749.529574]     expander present: handle(0x000b),
> sas_addr(0x500151b0000000bf)
> [  749.529576]     expander(0x500151b0000000bf): handle changed
> from(0x000d) to (0x000b)!!!
> [  749.550862] mpt3sas_cm0: search for expanders: complete
> [  749.550865] mpt3sas_cm0: mpt3sas_ctl_reset_done_handler:
> MPT3_IOC_DONE_RESET
> [  749.572504] mpt3sas_cm0: _base_reset_done_handler: MPT3_IOC_DONE_RESET
> [  749.572504] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: SUCCESS
> [  749.572504] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: exit
> [  750.571450] mpt3sas_cm0: removing unresponding devices: start
> [  750.582163] mpt3sas_cm0: removing unresponding devices: end-devices
> [  750.592829] mpt3sas_cm0: Removing unresponding devices: pcie end-devices
> [  750.603398] mpt3sas_cm0: removing unresponding devices: expanders
> [  750.603399] mpt3sas_cm0: removing unresponding devices: complete
> [  750.603400] mpt3sas_cm0: scan devices: start
> [  750.603402] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [  750.604281] mpt3sas_cm0:     scan devices: expanders start
> [  750.657941] mpt3sas_cm0:     break from expander scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [  750.668562] mpt3sas_cm0:     scan devices: expanders complete
> [  750.668563] mpt3sas_cm0:     scan devices: end devices start
> [  750.669734] mpt3sas_cm0:     break from end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [  750.700438] mpt3sas_cm0:     scan devices: end devices complete
> [  750.700438] mpt3sas_cm0:     scan devices: pcie end devices start
> [  750.700622] mpt3sas_cm0:     break from pcie end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [  750.733165] mpt3sas_cm0:     pcie devices: pcie end devices complete
> [  750.733165] mpt3sas_cm0: scan devices: complete
> [ 1349.589087] mpt3sas_cm0: _ctl_getiocinfo: enter
> [ 1349.599693] mpt3sas_cm0: ctl_request: ioc_facts, smid(8581)
> [ 1349.610279] mpt3sas_cm0: ctl_done: ioc_facts, smid(8581)
> [ 1349.621158] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.632030] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.643149] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.654267] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.654273] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.676509] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.687607] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.698717] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.698745] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.720931] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.732030] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.732113] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.754756] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.754769] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.777577] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.788944] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.788956] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.811865] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.811870] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.834746] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.834752] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.857593] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.857830] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.880882] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.892582] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.892762] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.915881] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.916006] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.939646] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.939747] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.964020] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.976313] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1349.976319] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.000948] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.013324] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.013498] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.038226] mpt3sas_cm0: _ctl_btdh_mapping
> [ 1350.038230] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.038327] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.075594] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.075700] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.100718] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.113312] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.113312] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1350.113313] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [ 1350.113313] mpt3sas_cm0:
> enclosure_logical_id(0x500605b00cf4d920), slot(8)
> [ 1350.113319] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.176544] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.176545] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1350.176545] mpt3sas_cm0:     sas_address(0x510600b00cf4d920), phy(8)
> [ 1350.176546] mpt3sas_cm0:
> enclosure_logical_id(0x500605b00cf4d920), slot(8)
> [ 1350.176736] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.240290] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.253141] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.253175] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.279239] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.279255] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.305838] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.305871] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.332987] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.333006] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.360514] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.360537] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.388184] mpt3sas_cm0: _ctl_btdh_mapping
> [ 1350.388191] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.415867] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.429843] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.429876] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.457925] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.582377] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.596261] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1350.610261] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [ 1350.624299] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [ 1350.638408] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.652917] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.666946] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1350.681004] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [ 1350.694993] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [ 1350.708973] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
> cdb_len(10), smid(8581)
> [ 1350.722927] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
> smid(8581)
> [ 1350.722928] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [ 1350.722929] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [ 1350.722931] mpt3sas_cm0:     scsi_state(0x01), scsi_status(0x02)
> [ 1350.778048] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
> cdb_len(10), smid(8581)
> [ 1350.791785] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
> smid(8581)
> [ 1350.791797] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.819361] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.832819] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1350.846317] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [ 1350.859744] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [ 1350.873150] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.886902] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1350.900123] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1350.913386] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
> [ 1350.926581] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(6)
> [ 1350.939755] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.952985] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.952991] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.979419] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1350.979423] mpt3sas_cm0: _ctl_btdh_mapping
> [ 1351.005697] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.018932] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.032153] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.032390] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.058593] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.058795] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.084874] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1351.084875] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [ 1351.084875] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(0)
> [ 1351.085051] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.136808] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.136810] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1351.162366] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
> [ 1351.162366] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000020bf), slot(0)
> [ 1351.162462] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.200510] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.200521] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.226028] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.226032] mpt3sas_cm0: _ctl_btdh_mapping
> [ 1351.251614] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.251773] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.277592] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.290656] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.290666] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.317025] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.330076] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1351.343164] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [ 1351.356179] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000000bf), slot(0)
> [ 1351.369168] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.382207] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
> smid(8581)
> [ 1351.395033] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
> [ 1351.407880] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
> [ 1351.420659] mpt3sas_cm0:
> enclosure_logical_id(0x500151b0000000bf), slot(0)
> [ 1351.433421] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.446312] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.446323] mpt3sas_cm0: ctl_request: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.471850] mpt3sas_cm0: ctl_done: config, type(0x0f),
> ext_type(0x12), number(0), smid(8581)
> [ 1351.471851] mpt3sas_cm0:     iocstatus(0x0022), loginfo(0x310f0400)
> [ 1351.471861] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [ 1351.510098] mpt3sas_cm0: ctl_done: fw_upload, smid(8581)
> [ 1351.522571] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [ 1351.534979] mpt3sas_cm0: ctl_done: fw_upload, smid(8581)
> [ 1351.547306] mpt3sas_cm0: ctl_request: fw_upload, smid(8581)
> [ 1412.364540] mpt3sas_cm0: Command Timeout
> [ 1412.376607] mf:
>
> [ 1412.376608] 12000002
> [ 1412.400552] 00000000
> [ 1412.412388] 00000000
> [ 1412.412389] 00000000
> [ 1412.412389] 00000000
> [ 1412.412389] 000c0000
> [ 1412.412390] 00000000
> [ 1412.412390] 00010000
> [ 1412.412391]
>
> [ 1412.412391] 00010000
>
> [ 1412.412392] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: enter
> [ 1412.412404] mpt3sas_cm0: mpt3sas_scsih_pre_reset_handler:
> MPT3_IOC_PRE_RESET
> [ 1412.554643] mpt3sas_cm0: mpt3sas_ctl_pre_reset_handler:
> MPT3_IOC_PRE_RESET
> [ 1412.554643] mpt3sas_cm0: _base_pre_reset_handler: MPT3_IOC_PRE_RESET
> [ 1412.554648] mpt3sas_cm0: _base_make_ioc_ready
> [ 1412.585784] mpt3sas_cm0: sending diag reset !!
> [ 1413.342052] mpt3sas_cm0: diag reset: SUCCESS
> [ 1413.352117] mpt3sas_cm0: mpt3sas_scsih_after_reset_handler:
> MPT3_IOC_AFTER_RESET
> [ 1413.362427] mpt3sas_cm0: completing 0 cmds
> [ 1413.372560] mpt3sas_cm0: mpt3sas_ctl_after_reset_handler:
> MPT3_IOC_AFTER_RESET
> [ 1413.372560] mpt3sas_cm0: _base_after_reset_handler: MPT3_IOC_AFTER_RESET
> [ 1413.372561] mpt3sas_cm0: _base_get_ioc_facts
> [ 1413.372561] mpt3sas_cm0: _base_wait_for_iocstate
> [ 1413.421070]     offset:data
> [ 1413.430822]     [0x00]:03110206
> [ 1413.440547]     [0x04]:00002e00
> [ 1413.450126]     [0x08]:00000000
> [ 1413.450126]     [0x0c]:00000000
> [ 1413.450126]     [0x10]:00000000
> [ 1413.450126]     [0x14]:80010080
> [ 1413.450127]     [0x18]:22312200
> [ 1413.450127]     [0x1c]:000fa84c
> [ 1413.450127]     [0x20]:02000500
> [ 1413.450127]     [0x24]:00080020
> [ 1413.450127]     [0x28]:0280001d
> [ 1413.450128]     [0x2c]:00d100d0
> [ 1413.450128]     [0x30]:0074000b
> [ 1413.450128]     [0x34]:0020ffe0
> [ 1413.450128]     [0x38]:00800375
> [ 1413.450129]     [0x3c]:00000009
> [ 1413.450129]     [0x40]:00000000
> [ 1413.450129] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default
> host page size to 4k
> [ 1413.450130] mpt3sas_cm0: CurrentHostPageSize(0)
> [ 1413.450130] mpt3sas_cm0: hba queue depth(8704), max chains per io(128)
> [ 1413.450132] mpt3sas_cm0: request frame size(128), reply frame size(128)
> [ 1413.450134] mpt3sas_cm0: _base_make_ioc_operational
> [ 1413.451515] mpt3sas_cm0: _base_send_ioc_init
> [ 1413.619995]     offset:data
> [ 1413.619995]     [0x00]:02000004
> [ 1413.619995]     [0x04]:01000000
> [ 1413.619995]     [0x08]:00000000
> [ 1413.619995]     [0x0c]:36000206
> [ 1413.619996]     [0x10]:00000000
> [ 1413.619996]     [0x14]:200c0000
> [ 1413.619996]     [0x18]:00200000
> [ 1413.619996]     [0x1c]:22b44530
> [ 1413.619997]     [0x20]:0000000f
> [ 1413.619997]     [0x24]:0000000f
> [ 1413.619997]     [0x28]:dbe00000
> [ 1413.619997]     [0x2c]:0000000f
> [ 1413.619997]     [0x30]:e4a34000
> [ 1413.619998]     [0x34]:0000000f
> [ 1413.619998]     [0x38]:dc110000
> [ 1413.619998]     [0x3c]:0000000f
> [ 1413.619999]     [0x40]:a2654845
> [ 1413.723893]     [0x44]:00000174
> [ 1413.767567]     offset:data
> [ 1413.771938]     [0x00]:02050004
> [ 1413.776386]     [0x04]:01000000
> [ 1413.780761]     [0x08]:00000000
> [ 1413.780761]     [0x0c]:00000000
> [ 1413.780762]     [0x10]:00000000
> [ 1413.780766] mpt3sas_cm0: _base_display_fwpkg_version
> [ 1413.853103] mpt3sas_cm0: _base_display_fwpkg_version: complete
> [ 1413.857397] mpt3sas_cm0: FW Package Version (02.00.05.02)
> [ 1413.862145] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00),
> ChipRevision(0x01), BiosVersion(09.03.00.00)
> [ 1413.866838] NVMe
> [ 1413.866839] mpt3sas_cm0: Protocol=(Initiator,Target),
> Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
> [ 1413.871804] mpt3sas_cm0: _base_event_notification
> [ 1413.882409] mpt3sas_cm0: _base_event_notification: complete
> [ 1413.887845] mpt3sas_cm0: sending port enable !!
> [ 1415.575003] mpt3sas_cm0: Discovery: (start)
> [ 1415.580465] mpt3sas_cm0: SAS Enclosure Device Status Change
> [ 1415.580472] mpt3sas_cm0: discovery event: (start)
> [ 1415.586146] mpt3sas_cm0: SAS Topology Change List
> [ 1415.586147] mpt3sas_cm0: SAS Topology Change List
> [ 1415.591875] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0001), enclosure logical
> id(0x500605b00cf4d920) number slots(0)
> [ 1415.597535] mpt3sas_cm0: SAS Enclosure Device Status Change
> [ 1415.597536] mpt3sas_cm0: SAS Topology Change List
> [ 1415.597537] mpt3sas_cm0: SAS Topology Change List
> [ 1415.631564] mpt3sas_cm0: sas topology change: (responding)
> [ 1415.631564]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(08), count(1)
> [ 1415.631565]     phy(08), attached_handle(0x0009): target add: link
> rate: new(0x08), old(0x00)
> [ 1415.631566] mpt3sas_cm0: sas topology change: (responding)
> [ 1415.631566]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(00), count(7)
> [ 1415.631567]     phy(00), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.631567]     phy(02), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.631567]     phy(04), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.631568]     phy(06), attached_handle(0x000a): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.631569] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0002), enclosure logical
> id(0x500151b0000020bf) number slots(0)
> [ 1415.631570] mpt3sas_cm0: sas topology change: (add)
> [ 1415.702281]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(00), count(22)
> [ 1415.702281]     phy(06), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.702282]     phy(07), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.702282]     phy(08), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.702282]     phy(09), attached_handle(0x0001): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.702283]     phy(19), attached_handle(0x000b): target add: link
> rate: new(0x0a), old(0x00)
> [ 1415.702459] mpt3sas_cm0: sas topology change: (responding)
> [ 1415.749775]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(22), count(4)
> [ 1415.749776]     phy(24), attached_handle(0x000c): target add: link
> rate: new(0x0a), old(0x00)
> [ 1415.825009] mpt3sas_cm0: Discovery: (start)
> [ 1415.832368] mpt3sas_cm0: SAS Topology Change List
> [ 1415.832377] mpt3sas_cm0: discovery event: (start)
> [ 1415.839903] mpt3sas_cm0: SAS Topology Change List
> [ 1415.839905] mpt3sas_cm0: SAS Enclosure Device Status Change
> [ 1415.839906] mpt3sas_cm0: SAS Topology Change List
> [ 1415.847505] mpt3sas_cm0: sas topology change: (responding)
> [ 1415.854990] mpt3sas_cm0: SAS Topology Change List
> [ 1415.884646]     handle(0x0000), enclosure_handle(0x0001)
> start_phy(01), count(7)
> [ 1415.884647]     phy(01), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.884647]     phy(02), attached_handle(0x000a): target responding:
> link rate: new(0x0a), old(0x00)
> [ 1415.884648]     phy(03), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.884648]     phy(04), attached_handle(0x000a): target responding:
> link rate: new(0x0a), old(0x00)
> [ 1415.884648]     phy(05), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.884649]     phy(06), attached_handle(0x000a): target responding:
> link rate: new(0x0a), old(0x00)
> [ 1415.884649]     phy(07), attached_handle(0x000d): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.884659] mpt3sas_cm0: sas topology change: (responding)
> [ 1415.957137]     handle(0x000a), enclosure_handle(0x0002)
> start_phy(19), count(1)
> [ 1415.957138]     phy(19), attached_handle(0x000b): link rate change:
> link rate: new(0x0a), old(0x0a)
> [ 1415.957146] mpt3sas_cm0: enclosure status change: (enclosure add)
>                    handle(0x0003), enclosure logical
> id(0x500151b0000000bf) number slots(0)
> [ 1415.993356] mpt3sas_cm0: sas topology change: (add)
> [ 1415.993356]     handle(0x000d), enclosure_handle(0x0003)
> start_phy(00), count(22)
> [ 1415.993356]     phy(06), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.993357]     phy(07), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.993357]     phy(08), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.993357]     phy(09), attached_handle(0x0002): link rate change:
> link rate: new(0x0a), old(0x00)
> [ 1415.993358] mpt3sas_cm0: sas topology change: (responding)
> [ 1415.993358]     handle(0x000d), enclosure_handle(0x0003)
> start_phy(22), count(4)
> [ 1415.993359]     phy(24), attached_handle(0x000e): target add: link
> rate: new(0x0a), old(0x00)
> [ 1416.075391] mpt3sas_cm0: Discovery: (stop)
> [ 1416.092674] mpt3sas_cm0: Discovery: (stop)
> [ 1416.092680] mpt3sas_cm0: discovery event: (stop)
> [ 1416.113414] mpt3sas_cm0: discovery event: (stop)
> [ 1421.074967] mpt3sas_cm0: port enable: SUCCESS
> [ 1421.085240] mpt3sas_cm0: mpt3sas_scsih_reset_done_handler:
> MPT3_IOC_DONE_RESET
> [ 1421.095962] mpt3sas_cm0: search for end-devices: start
> [ 1421.106693] scsi target6:0:1: handle(0x0009),
> sas_addr(0x510600b00cf4d920)
> [ 1421.117178] scsi target6:0:1: enclosure logical
> id(0x500605b00cf4d920), slot(8)
> [ 1421.127743] scsi target6:0:0: handle(0x000b),
> sas_addr(0x500151b0000020b3)
> [ 1421.138036] scsi target6:0:0: enclosure logical
> id(0x500151b0000020bf), slot(6)
> [ 1421.148310]     handle changed from(0x000c)!!!
> [ 1421.158705] scsi target6:0:2: handle(0x000c),
> sas_addr(0x500151b0000020bd)
> [ 1421.158707] scsi target6:0:2: enclosure logical
> id(0x500151b0000020bf), slot(0)
> [ 1421.179684]     handle changed from(0x000d)!!!
> [ 1421.179899] scsi target6:0:3: handle(0x000e),
> sas_addr(0x500151b0000000bd)
> [ 1421.200938] scsi target6:0:3: enclosure logical
> id(0x500151b0000000bf), slot(0)
> [ 1421.201162] mpt3sas_cm0: search for end-devices: complete
> [ 1421.222637] mpt3sas_cm0: search for end-devices: start
> [ 1421.222637] mpt3sas_cm0: search for PCIe end-devices: complete
> [ 1421.222638] mpt3sas_cm0: search for expanders: start
> [ 1421.222824]     expander present: handle(0x000a),
> sas_addr(0x500151b0000020bf)
> [ 1421.265555]     expander present: handle(0x000d),
> sas_addr(0x500151b0000000bf)
> [ 1421.265555]     expander(0x500151b0000000bf): handle changed
> from(0x000b) to (0x000d)!!!
> [ 1421.265716] mpt3sas_cm0: search for expanders: complete
> [ 1421.298001] mpt3sas_cm0: mpt3sas_ctl_reset_done_handler:
> MPT3_IOC_DONE_RESET
> [ 1421.298002] mpt3sas_cm0: _base_reset_done_handler: MPT3_IOC_DONE_RESET
> [ 1421.298002] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: SUCCESS
> [ 1421.298002] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: exit
> [ 1421.298006] mpt3sas_cm0: removing unresponding devices: start
> [ 1421.351365] mpt3sas_cm0: removing unresponding devices: end-devices
> [ 1421.351365] mpt3sas_cm0: Removing unresponding devices: pcie end-devices
> [ 1421.351366] mpt3sas_cm0: removing unresponding devices: expanders
> [ 1421.351367] mpt3sas_cm0: removing unresponding devices: complete
> [ 1421.351369] mpt3sas_cm0: scan devices: start
> [ 1421.351370] mpt3sas_cm0: updating handles for
> sas_host(0x500605b00cf4d920)
> [ 1421.352148] mpt3sas_cm0:     scan devices: expanders start
> [ 1421.426208] mpt3sas_cm0:     break from expander scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [ 1421.436492] mpt3sas_cm0:     scan devices: expanders complete
> [ 1421.446969] mpt3sas_cm0:     scan devices: end devices start
> [ 1421.458002] mpt3sas_cm0:     break from end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [ 1421.468578] mpt3sas_cm0:     scan devices: end devices complete
> [ 1421.479147] mpt3sas_cm0:     scan devices: pcie end devices start
> [ 1421.479205] mpt3sas_cm0:     break from pcie end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [ 1421.500178] mpt3sas_cm0:     pcie devices: pcie end devices complete
> [ 1421.500179] mpt3sas_cm0: scan devices: complete
>

--000000000000c2f3ee05afce6832
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQZgYJKoZIhvcNAQcCoIIQVzCCEFMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg27MIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFaDCCBFCgAwIBAgIMTzhhr1uxQygxnqoqMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE0MTEz
MDI3WhcNMjIwOTE1MTEzMDI3WjCBpjELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMSEwHwYDVQQDExhTdWdh
bmF0aCBQcmFidSBTdWJyYW1hbmkxNDAyBgkqhkiG9w0BCQEWJXN1Z2FuYXRoLXByYWJ1LnN1YnJh
bWFuaUBicm9hZGNvbS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDE4PJGpohK
fSdLuvXKDx+KlntIQ9oWcJKJtjhLgQYbRV08pm5dA516HlITt80GGu1PrW1dinnVWjlNIOZoV4cH
Th6z1AFz11Gtjs3hK6bXmtkuFrDpOw+heR1QCcWBth4QQi21n5TS0oRFOQ9QJEjuAXomx6LrLy7V
4SZlX0E3wOpoLZOcoVAqoW9DOEe/eGhhkRwGmkQFenT5bQya3FsVWzowRsRjHJRlCJQv3gfJCiUg
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg503FIe66sXNHTTJXIX6no7KFBZ529LXvH5v9ozBJ
keEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwOTIxMDgxMjE5
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAEj3OXWpHhALfGnuUNiG1b0MMFwyVehvMBURRew57p382JGbw9r9OJX40In6
mDd280JOv/KhA7FkmF2aopPzsOEs6nAMWlEKDp5dD+2tDSt6iqdUBHRMnd9gpoPQg+fZO82mQ+LU
eIK5GfPp6rP1LD9uvXbruGNfiyUypKDgHv3vdvXzGe50LbJ3D6TrH/jmv57r5iDDHUkpv0TMrsuj
/M39/myNxwqKnrEF7RxioNPlOmbJEu3TingGOEflL9pW3WGjqZhYwFb7oTrbtKT52SeTLSCxBVU6
Nx0c2UZXm2Zl4af5dufauWB4b59ns4b7Ykl9dkuudQYcxhgL7yqpqNE=
--000000000000c2f3ee05afce6832--
