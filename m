Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C21C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 04:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9274A23A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 04:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgIVEg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 00:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgIVEg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 00:36:29 -0400
Received: from durga.tabris.net (durga.tabris.net [IPv6:2604:180:1:5a8::6487])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B8DC061755
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 21:36:29 -0700 (PDT)
Received: from bragi.tabris.net (localhost [127.0.0.1])
        (Authenticated sender: mailrelay)
        by durga.tabris.net (Postfix) with ESMTPA id 5D211C3202F;
        Mon, 21 Sep 2020 21:36:27 -0700 (PDT)
Received: from sif.tabris.net (bragi.tabris.net [192.168.88.8])
        (Authenticated sender: tabris)
        by bragi.tabris.net (Postfix) with ESMTPA id DC96CC2C8522;
        Tue, 22 Sep 2020 00:36:26 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 bragi.tabris.net DC96CC2C8522
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by sif.tabris.net (Postfix) with ESMTP id 4C28020144;
        Tue, 22 Sep 2020 00:36:26 -0400 (EDT)
Subject: Re: bug in mpt3sas vs Lenovo 530-8i
To:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <a29522ab-6246-00b6-57b9-cd8d7c8766dc@domedata.com>
 <CA+RiK66O-0giupGduKOvTEoSmn1H21u_1ROjqZRGFy4+JX2gmA@mail.gmail.com>
 <caf5a889-4235-1610-6476-305898d01a75@domedata.com>
 <CA+RiK67Jt8QP-TMNi_QzcO=12Q51Nqm7UmwGgHP6jOdnu92=-Q@mail.gmail.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>
From:   Adam Schrotenboer <adam@domedata.com>
Message-ID: <5f228767-c31e-4718-e1b7-23e94d5ead02@domedata.com>
Date:   Tue, 22 Sep 2020 00:36:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CA+RiK67Jt8QP-TMNi_QzcO=12Q51Nqm7UmwGgHP6jOdnu92=-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/21/2020 04:16 AM, Suganath Prabu Subramani wrote:

> HI Adam,
>
> >From driver logs, I could see "fw_upload" ioctl command got timeout
> and triggered controller reset.
> This issue is not due to memset in mpt3sas_ctl.c but with the patch
> applied proper command will be
> sent to FW.
> Please contact Broadcom support team as this needs to be debugged from
> the HBA FW side and
> support team may also provide the latest FW / access to download
> related components.
>
> FW used is very old "02.00.05.00" It is recommended to have the same
> phase FW and Driver.
> Driver:      [    4.670962] mpt3sas version 31.100.00.00 loaded.
> Firmware: [    6.126215] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00).
>
> Thanks,
> Suganath
>
In my original mail, I mentioned having two of these cards, they should
be reasonably similar.
One of them originally had the RAID mode firmware installed, and I
loaded the IT mode firmware onto it instead. The previous logs were with
the card that came with the old [but IT-mode] firmware.
This log is with the phase16 firmware, built in 2020July. At least from
a non-SME's POV, the same error occurs.
Further of note, you had said that this bug is not caused by the memset,
and with the patch applied...
Should I read that as "with the memset applied, the correct command is
being sent, but the card's firmware is timing out" or "with the memset
*not* applied, the correct command is being sent"?
Also, if this is an ioctl, is the kernel doing this or is there
something in userspace I should be telling to bugger off?

[    0.000000] Linux version 5.4.0-0.bpo.4-amd64
(debian-kernel@lists.debian.org) (gcc version 8.3.0 (Debian 8.3.0-6)) #1
SMP Debian 5.4.19-1~bpo10+1 (2020-03-09)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-5.4.0-0.bpo.4-amd64
root=UUID=3def0939-f671-431e-9aa4-d6e51dc9afa2 ro
mpt3sas.logging_level=0x83f8
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832
bytes, using 'compacted' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009bfefff] usable
[    0.000000] BIOS-e820: [mem 0x0000000009bff000-0x0000000009ffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000a200000-0x000000000a212fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000a213000-0x00000000ca43dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca43e000-0x00000000ca792fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ca793000-0x00000000ca8e6fff]
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ca8e7000-0x00000000cafa3fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cafa4000-0x00000000cbb63fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000cbb64000-0x00000000cbbfefff]
type 20
[    0.000000] BIOS-e820: [mem 0x00000000cbbff000-0x00000000ccffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd000000-0x00000000cfffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd100000-0x00000000fd1fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd300000-0x00000000fd4fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000fea0ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb80000-0x00000000fec01fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fedc2000-0x00000000fedcffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fedd4000-0x00000000fedd5fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000102f37ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000102f380000-0x000000102fffffff]
reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.70 by American Megatrends
[    0.000000] efi:  ACPI=0xca8e6000  ACPI 2.0=0xca8e6014 
SMBIOS=0xcba0d000  SMBIOS 3.0=0xcba0c000  MEMATTR=0xc648f018 
ESRT=0xc6c68618
[    0.000000] secureboot: Secure boot could not be determined (mode 0)
[    0.000000] SMBIOS 3.2.0 present.
[    0.000000] DMI: System manufacturer System Product Name/PRIME
X570-PRO, BIOS 2606 08/13/2020
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3892.606 MHz processor
[    0.000968] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000969] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000973] last_pfn = 0x102f380 max_arch_pfn = 0x400000000
[    0.000976] MTRR default type: uncachable
[    0.000976] MTRR fixed ranges enabled:
[    0.000977]   00000-9FFFF write-back
[    0.000977]   A0000-BFFFF write-through
[    0.000978]   C0000-FFFFF write-protect
[    0.000978] MTRR variable ranges enabled:
[    0.000979]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000979]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000980]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000980]   3 base 0000CB320000 mask FFFFFFFF0000 uncachable
[    0.000981]   4 disabled
[    0.000981]   5 disabled
[    0.000981]   6 disabled
[    0.000981]   7 disabled
[    0.000982] TOM2: 0000001030000000 aka 66304M
[    0.001737] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC-
WT 
[    0.001893] e820: update [mem 0xcb320000-0xcb32ffff] usable ==> reserved
[    0.001895] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.001898] last_pfn = 0xcd000 max_arch_pfn = 0x400000000
[    0.004737] esrt: Reserving ESRT space from 0x00000000c6c68618 to
0x00000000c6c68650.
[    0.004742] e820: update [mem 0xc6c68000-0xc6c68fff] usable ==> reserved
[    0.004755] Using GB pages for direct mapping
[    0.004757] BRK [0x2efc01000, 0x2efc01fff] PGTABLE
[    0.004758] BRK [0x2efc02000, 0x2efc02fff] PGTABLE
[    0.004758] BRK [0x2efc03000, 0x2efc03fff] PGTABLE
[    0.004782] BRK [0x2efc04000, 0x2efc04fff] PGTABLE
[    0.004783] BRK [0x2efc05000, 0x2efc05fff] PGTABLE
[    0.004891] BRK [0x2efc06000, 0x2efc06fff] PGTABLE
[    0.004934] BRK [0x2efc07000, 0x2efc07fff] PGTABLE
[    0.004988] BRK [0x2efc08000, 0x2efc08fff] PGTABLE
[    0.005024] BRK [0x2efc09000, 0x2efc09fff] PGTABLE
[    0.005083] BRK [0x2efc0a000, 0x2efc0afff] PGTABLE
[    0.005167] BRK [0x2efc0b000, 0x2efc0bfff] PGTABLE
[    0.005197] RAMDISK: [mem 0x370a9000-0x3784bfff]
[    0.005203] ACPI: Early table checksum verification disabled
[    0.005206] ACPI: RSDP 0x00000000CA8E6014 000024 (v02 ALASKA)
[    0.005208] ACPI: XSDT 0x00000000CA8E5728 0000BC (v01 ALASKA A M I   
01072009 AMI  01000013)
[    0.005211] ACPI: FACP 0x00000000CA8D6000 000114 (v06 ALASKA A M I   
01072009 AMI  00010013)
[    0.005214] ACPI: DSDT 0x00000000CA8C7000 00E2F5 (v02 ALASKA A M I   
01072009 INTL 20120913)
[    0.005216] ACPI: FACS 0x00000000CAF87000 000040
[    0.005217] ACPI: SSDT 0x00000000CA8DC000 008C98 (v02 AMD    AmdTable
00000002 MSFT 04000000)
[    0.005219] ACPI: SSDT 0x00000000CA8D8000 003ACB (v01 AMD    AMD AOD 
00000001 INTL 20120913)
[    0.005220] ACPI: SSDT 0x00000000CA8D7000 0000FC (v02 ALASKA CPUSSDT 
01072009 AMI  01072009)
[    0.005222] ACPI: FIDT 0x00000000CA8C6000 00009C (v01 ALASKA A M I   
01072009 AMI  00010013)
[    0.005223] ACPI: FPDT 0x00000000CA7D8000 000044 (v01 ALASKA A M I   
01072009 AMI  01000013)
[    0.005225] ACPI: MCFG 0x00000000CA8C4000 00003C (v01 ALASKA A M I   
01072009 MSFT 00010013)
[    0.005226] ACPI: HPET 0x00000000CA8C3000 000038 (v01 ALASKA A M I   
01072009 AMI  00000005)
[    0.005228] ACPI: SSDT 0x00000000CA8C2000 000024 (v01 AMD    BIXBY   
00001000 INTL 20120913)
[    0.005229] ACPI: BGRT 0x00000000CA8C0000 000038 (v01 ALASKA A M I   
01072009 AMI  00010013)
[    0.005231] ACPI: WPBT 0x00000000CA7E7000 00003C (v01 ALASKA A M I   
00000001 ASUS 00000001)
[    0.005232] ACPI: PCCT 0x00000000CA7E6000 00006E (v02 AMD    AmdTable
00000001 AMD  00000000)
[    0.005234] ACPI: SSDT 0x00000000CA7E2000 003EC9 (v02 AMD    AmdTable
00000001 AMD  00000001)
[    0.005235] ACPI: CRAT 0x00000000CA7E1000 000ED8 (v01 AMD    AmdTable
00000001 AMD  00000001)
[    0.005236] ACPI: CDIT 0x00000000CA7E0000 000029 (v01 AMD    AmdTable
00000001 AMD  00000001)
[    0.005238] ACPI: SSDT 0x00000000CA7DF000 00052C (v01 AMD    QOGIRNOI
00000001 INTL 20120913)
[    0.005239] ACPI: SSDT 0x00000000CA7DB000 003445 (v01 AMD    QOGIRN  
00000001 INTL 20120913)
[    0.005241] ACPI: WSMT 0x00000000CA7DA000 000028 (v01 ALASKA A M I   
01072009 AMI  00010013)
[    0.005242] ACPI: APIC 0x00000000CA7D9000 00015E (v03 ALASKA A M I   
01072009 AMI  00010013)
[    0.005247] ACPI: Local APIC address 0xfee00000
[    0.005323] No NUMA configuration found
[    0.005324] Faking a node at [mem 0x0000000000000000-0x000000102f37ffff]
[    0.005327] NODE_DATA(0) allocated [mem 0x102f37b000-0x102f37ffff]
[    0.005368] Zone ranges:
[    0.005369]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.005370]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.005370]   Normal   [mem 0x0000000100000000-0x000000102f37ffff]
[    0.005371]   Device   empty
[    0.005372] Movable zone start for each node
[    0.005372] Early memory node ranges
[    0.005373]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.005373]   node   0: [mem 0x0000000000100000-0x0000000009bfefff]
[    0.005374]   node   0: [mem 0x000000000a000000-0x000000000a1fffff]
[    0.005374]   node   0: [mem 0x000000000a213000-0x00000000ca43dfff]
[    0.005375]   node   0: [mem 0x00000000cbbff000-0x00000000ccffffff]
[    0.005376]   node   0: [mem 0x0000000100000000-0x000000102f37ffff]
[    0.005480] Zeroed struct page in unavailable ranges: 22710 pages
[    0.005480] Initmem setup node 0 [mem
0x0000000000001000-0x000000102f37ffff]
[    0.005481] On node 0 totalpages: 16754506
[    0.005482]   DMA zone: 64 pages used for memmap
[    0.005482]   DMA zone: 52 pages reserved
[    0.005483]   DMA zone: 3999 pages, LIFO batch:0
[    0.005514]   DMA32 zone: 12945 pages used for memmap
[    0.005515]   DMA32 zone: 828459 pages, LIFO batch:63
[    0.012819]   Normal zone: 248782 pages used for memmap
[    0.012820]   Normal zone: 15922048 pages, LIFO batch:63
[    0.135190] ACPI: PM-Timer IO Port: 0x808
[    0.135193] ACPI: Local APIC address 0xfee00000
[    0.135198] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.135209] IOAPIC[0]: apic_id 17, version 33, address 0xfec00000,
GSI 0-23
[    0.135214] IOAPIC[1]: apic_id 18, version 33, address 0xfec01000,
GSI 24-55
[    0.135215] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.135216] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.135217] ACPI: IRQ0 used by override.
[    0.135218] ACPI: IRQ9 used by override.
[    0.135219] Using ACPI (MADT) for SMP configuration information
[    0.135220] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.135227] e820: update [mem 0xc5a1e000-0xc5a63fff] usable ==> reserved
[    0.135233] smpboot: Allowing 32 CPUs, 16 hotplug CPUs
[    0.135252] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.135254] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.135255] PM: Registered nosave memory: [mem 0x09bff000-0x09ffffff]
[    0.135256] PM: Registered nosave memory: [mem 0x0a200000-0x0a212fff]
[    0.135257] PM: Registered nosave memory: [mem 0xc5a1e000-0xc5a63fff]
[    0.135258] PM: Registered nosave memory: [mem 0xc6c68000-0xc6c68fff]
[    0.135259] PM: Registered nosave memory: [mem 0xca43e000-0xca792fff]
[    0.135260] PM: Registered nosave memory: [mem 0xca793000-0xca8e6fff]
[    0.135260] PM: Registered nosave memory: [mem 0xca8e7000-0xcafa3fff]
[    0.135260] PM: Registered nosave memory: [mem 0xcafa4000-0xcbb63fff]
[    0.135261] PM: Registered nosave memory: [mem 0xcbb64000-0xcbbfefff]
[    0.135262] PM: Registered nosave memory: [mem 0xcd000000-0xcfffffff]
[    0.135262] PM: Registered nosave memory: [mem 0xd0000000-0xefffffff]
[    0.135263] PM: Registered nosave memory: [mem 0xf0000000-0xf7ffffff]
[    0.135263] PM: Registered nosave memory: [mem 0xf8000000-0xfd0fffff]
[    0.135264] PM: Registered nosave memory: [mem 0xfd100000-0xfd1fffff]
[    0.135264] PM: Registered nosave memory: [mem 0xfd200000-0xfd2fffff]
[    0.135265] PM: Registered nosave memory: [mem 0xfd300000-0xfd4fffff]
[    0.135265] PM: Registered nosave memory: [mem 0xfd500000-0xfe9fffff]
[    0.135265] PM: Registered nosave memory: [mem 0xfea00000-0xfea0ffff]
[    0.135266] PM: Registered nosave memory: [mem 0xfea10000-0xfeb7ffff]
[    0.135266] PM: Registered nosave memory: [mem 0xfeb80000-0xfec01fff]
[    0.135267] PM: Registered nosave memory: [mem 0xfec02000-0xfec0ffff]
[    0.135267] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.135268] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.135268] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.135268] PM: Registered nosave memory: [mem 0xfed01000-0xfed3ffff]
[    0.135269] PM: Registered nosave memory: [mem 0xfed40000-0xfed44fff]
[    0.135269] PM: Registered nosave memory: [mem 0xfed45000-0xfed7ffff]
[    0.135270] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.135270] PM: Registered nosave memory: [mem 0xfed90000-0xfedc1fff]
[    0.135270] PM: Registered nosave memory: [mem 0xfedc2000-0xfedcffff]
[    0.135271] PM: Registered nosave memory: [mem 0xfedd0000-0xfedd3fff]
[    0.135271] PM: Registered nosave memory: [mem 0xfedd4000-0xfedd5fff]
[    0.135272] PM: Registered nosave memory: [mem 0xfedd6000-0xfeffffff]
[    0.135272] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.135273] [mem 0xd0000000-0xefffffff] available for PCI devices
[    0.135274] Booting paravirtualized kernel on bare hardware
[    0.135277] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.191862] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
nr_cpu_ids:32 nr_node_ids:1
[    0.192850] percpu: Embedded 53 pages/cpu s178584 r8192 d30312 u262144
[    0.192855] pcpu-alloc: s178584 r8192 d30312 u262144 alloc=1*2097152
[    0.192856] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11
12 13 14 15
[    0.192858] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 [0] 24 25 26 27
28 29 30 31
[    0.192879] Built 1 zonelists, mobility grouping on.  Total pages:
16492663
[    0.192880] Policy zone: Normal
[    0.192881] Kernel command line:
BOOT_IMAGE=/vmlinuz-5.4.0-0.bpo.4-amd64
root=UUID=3def0939-f671-431e-9aa4-d6e51dc9afa2 ro
mpt3sas.logging_level=0x83f8
[    0.192907] printk: log_buf_len individual max cpu contribution: 4096
bytes
[    0.192908] printk: log_buf_len total cpu_extra contributions: 126976
bytes
[    0.192908] printk: log_buf_len min size: 131072 bytes
[    0.192933] printk: log_buf_len: 262144 bytes
[    0.192934] printk: early log buf free: 116764(89%)
[    0.197853] Dentry cache hash table entries: 8388608 (order: 14,
67108864 bytes, linear)
[    0.200335] Inode-cache hash table entries: 4194304 (order: 13,
33554432 bytes, linear)
[    0.200394] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.205239] Calgary: detecting Calgary via BIOS EBDA area
[    0.205240] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.298560] Memory: 65645224K/67018024K available (10243K kernel
code, 1188K rwdata, 3752K rodata, 1664K init, 2064K bss, 1372800K
reserved, 0K cma-reserved)
[    0.298723] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
[    0.298736] ftrace: allocating 33964 entries in 133 pages
[    0.306293] rcu: Hierarchical RCU implementation.
[    0.306293] rcu:     RCU restricting CPUs from NR_CPUS=512 to
nr_cpu_ids=32.
[    0.306294] rcu: RCU calculated value of scheduler-enlistment delay
is 25 jiffies.
[    0.306295] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=32
[    0.307875] NR_IRQS: 33024, nr_irqs: 1224, preallocated irqs: 16
[    0.308158] random: crng done (trusting CPU's manufacturer)
[    0.308180] Console: colour dummy device 80x25
[    0.308409] printk: console [tty0] enabled
[    0.308423] ACPI: Core revision 20190816
[    0.308554] clocksource: hpet: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 133484873504 ns
[    0.308569] APIC: Switch to symmetric I/O mode setup
[    0.308571] Switched APIC routing to physical flat.
[    0.309166] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.328571] clocksource: tsc-early: mask: 0xffffffffffffffff
max_cycles: 0x703822342bf, max_idle_ns: 881590578174 ns
[    0.328574] Calibrating delay loop (skipped), value calculated using
timer frequency.. 7785.21 BogoMIPS (lpj=15570424)
[    0.328576] pid_max: default: 32768 minimum: 301
[    0.330710] LSM: Security Framework initializing
[    0.330714] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.330739] AppArmor: AppArmor initialized
[    0.330740] TOMOYO Linux initialized
[    0.330836] Mount-cache hash table entries: 131072 (order: 8, 1048576
bytes, linear)
[    0.330915] Mountpoint-cache hash table entries: 131072 (order: 8,
1048576 bytes, linear)
[    0.331091] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.331134] LVT offset 1 assigned for vector 0xf9
[    0.331264] LVT offset 2 assigned for vector 0xf4
[    0.331298] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.331299] Last level dTLB entries: 4KB 2048, 2MB 2048, 4MB 1024, 1GB 0
[    0.331301] Spectre V1 : Mitigation: usercopy/swapgs barriers and
__user pointer sanitization
[    0.331303] Spectre V2 : Mitigation: Full AMD retpoline
[    0.331304] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling
RSB on context switch
[    0.331306] Spectre V2 : mitigation: Enabling conditional Indirect
Branch Prediction Barrier
[    0.331307] Spectre V2 : User space: Mitigation: STIBP via seccomp
and prctl
[    0.331309] Speculative Store Bypass: Mitigation: Speculative Store
Bypass disabled via prctl and seccomp
[    0.331445] Freeing SMP alternatives memory: 24K
[    0.440877] smpboot: CPU0: AMD Ryzen 7 3800XT 8-Core Processor
(family: 0x17, model: 0x71, stepping: 0x0)
[    0.440949] Performance Events: Fam17h core perfctr, AMD PMU driver.
[    0.440952] ... version:                0
[    0.440953] ... bit width:              48
[    0.440954] ... generic registers:      6
[    0.440955] ... value mask:             0000ffffffffffff
[    0.440956] ... max period:             00007fffffffffff
[    0.440956] ... fixed-purpose events:   0
[    0.440957] ... event mask:             000000000000003f
[    0.440976] rcu: Hierarchical SRCU implementation.
[    0.441174] NMI watchdog: Enabled. Permanently consumes one hw-PMU
counter.
[    0.441321] smp: Bringing up secondary CPUs ...
[    0.441365] x86: Booting SMP configuration:
[    0.441367] .... node  #0, CPUs:        #1
[    0.004522] do_IRQ: 1.55 No irq handler for vector
[    0.444001]   #2
[    0.004522] do_IRQ: 2.55 No irq handler for vector
[    0.444615]   #3
[    0.004522] do_IRQ: 3.55 No irq handler for vector
[    0.446725]   #4
[    0.004522] do_IRQ: 4.55 No irq handler for vector
[    0.448618]   #5
[    0.004522] do_IRQ: 5.55 No irq handler for vector
[    0.452617]   #6
[    0.004522] do_IRQ: 6.55 No irq handler for vector
[    0.454764]   #7
[    0.004522] do_IRQ: 7.55 No irq handler for vector
[    0.456614]   #8
[    0.004522] do_IRQ: 8.55 No irq handler for vector
[    0.458766]   #9
[    0.004522] do_IRQ: 9.55 No irq handler for vector
[    0.460619]  #10
[    0.004522] do_IRQ: 10.55 No irq handler for vector
[    0.462726]  #11 #12 #13 #14 #15
[    0.474753] smp: Brought up 1 node, 16 CPUs
[    0.474753] smpboot: Max logical packages: 2
[    0.474753] smpboot: Total of 16 processors activated (124563.39
BogoMIPS)
[    0.476742] devtmpfs: initialized
[    0.476742] x86/mm: Memory block size: 128MB
[    0.481306] PM: Registering ACPI NVS region [mem
0x0a200000-0x0a212fff] (77824 bytes)
[    0.481306] PM: Registering ACPI NVS region [mem
0xca8e7000-0xcafa3fff] (7065600 bytes)
[    0.481306] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.481306] futex hash table entries: 8192 (order: 7, 524288 bytes,
linear)
[    0.481306] pinctrl core: initialized pinctrl subsystem
[    0.481306] NET: Registered protocol family 16
[    0.481306] audit: initializing netlink subsys (disabled)
[    0.481306] audit: type=2000 audit(1600747723.172:1):
state=initialized audit_enabled=0 res=1
[    0.481306] cpuidle: using governor ladder
[    0.481306] cpuidle: using governor menu
[    0.481306] Detected 1 PCC Subspaces
[    0.481306] Registering PCC driver as Mailbox controller
[    0.481306] ACPI: bus type PCI registered
[    0.481306] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.481306] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem
0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.481306] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.481306] PCI: Using configuration type 1 for base access
[    0.484725] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.484725] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.552881] ACPI: Added _OSI(Module Device)
[    0.552881] ACPI: Added _OSI(Processor Device)
[    0.552881] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.556574] ACPI: Added _OSI(Processor Aggregator Device)
[    0.556575] ACPI: Added _OSI(Linux-Dell-Video)
[    0.556576] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.556578] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.562544] ACPI: 8 ACPI AML tables successfully acquired and loaded
[    0.563289] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.564538] ACPI: EC: EC started
[    0.564540] ACPI: EC: interrupt blocked
[    0.564578] ACPI: \_SB_.PCI0.SBRG.EC0_: Used as first EC
[    0.564579] ACPI: \_SB_.PCI0.SBRG.EC0_: GPE=0x2, EC_CMD/EC_SC=0x66,
EC_DATA=0x62
[    0.564581] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC used to handle
transactions
[    0.564582] ACPI: Interpreter enabled
[    0.564591] ACPI: (supports S0 S3 S4 S5)
[    0.564593] ACPI: Using IOAPIC for interrupt routing
[    0.564785] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.564942] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.568891] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.568896] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI HPX-Type3]
[    0.568990] acpi PNP0A08:00: _OSC: platform does not support
[PCIeHotplug SHPCHotplug PME LTR]
[    0.569078] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.569085] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain
0000 [bus 00-7f] only partially covers this bridge
[    0.569246] PCI host bridge to bus 0000:00
[    0.569248] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    0.569249] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    0.569250] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    0.569252] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.569253] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff window]
[    0.569255] pci_bus 0000:00: root bus resource [mem
0x000c0000-0x000dffff window]
[    0.569256] pci_bus 0000:00: root bus resource [mem
0xd0000000-0xfec02fff window]
[    0.569258] pci_bus 0000:00: root bus resource [mem
0xfee00000-0xffffffff window]
[    0.569259] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.569266] pci 0000:00:00.0: [1022:1480] type 00 class 0x060000
[    0.569345] pci 0000:00:01.0: [1022:1482] type 00 class 0x060000
[    0.569403] pci 0000:00:01.2: [1022:1483] type 01 class 0x060400
[    0.569436] pci 0000:00:01.2: enabling Extended Tags
[    0.569481] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
[    0.569555] pci 0000:00:02.0: [1022:1482] type 00 class 0x060000
[    0.569616] pci 0000:00:03.0: [1022:1482] type 00 class 0x060000
[    0.569672] pci 0000:00:03.2: [1022:1483] type 01 class 0x060400
[    0.569748] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    0.569817] pci 0000:00:04.0: [1022:1482] type 00 class 0x060000
[    0.569875] pci 0000:00:05.0: [1022:1482] type 00 class 0x060000
[    0.569937] pci 0000:00:07.0: [1022:1482] type 00 class 0x060000
[    0.569991] pci 0000:00:07.1: [1022:1484] type 01 class 0x060400
[    0.570020] pci 0000:00:07.1: enabling Extended Tags
[    0.570056] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
[    0.570124] pci 0000:00:08.0: [1022:1482] type 00 class 0x060000
[    0.570178] pci 0000:00:08.1: [1022:1484] type 01 class 0x060400
[    0.570209] pci 0000:00:08.1: enabling Extended Tags
[    0.570249] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
[    0.570331] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
[    0.570434] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
[    0.570542] pci 0000:00:18.0: [1022:1440] type 00 class 0x060000
[    0.570575] pci 0000:00:18.1: [1022:1441] type 00 class 0x060000
[    0.570609] pci 0000:00:18.2: [1022:1442] type 00 class 0x060000
[    0.570642] pci 0000:00:18.3: [1022:1443] type 00 class 0x060000
[    0.570676] pci 0000:00:18.4: [1022:1444] type 00 class 0x060000
[    0.570710] pci 0000:00:18.5: [1022:1445] type 00 class 0x060000
[    0.570746] pci 0000:00:18.6: [1022:1446] type 00 class 0x060000
[    0.570781] pci 0000:00:18.7: [1022:1447] type 00 class 0x060000
[    0.570860] pci 0000:01:00.0: [1022:57ad] type 01 class 0x060400
[    0.570929] pci 0000:01:00.0: enabling Extended Tags
[    0.571010] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.571081] pci 0000:01:00.0: 63.012 Gb/s available PCIe bandwidth,
limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 126.024 Gb/s with
16 GT/s x8 link)
[    0.571147] pci 0000:00:01.2: PCI bridge to [bus 01-08]
[    0.571151] pci 0000:00:01.2:   bridge window [io  0xd000-0xefff]
[    0.571154] pci 0000:00:01.2:   bridge window [mem 0xfbf00000-0xfcafffff]
[    0.571158] pci 0000:00:01.2:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.571388] pci 0000:02:02.0: [1022:57a3] type 01 class 0x060400
[    0.571495] pci 0000:02:02.0: enabling Extended Tags
[    0.571717] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    0.571935] pci 0000:02:05.0: [1022:57a3] type 01 class 0x060400
[    0.572041] pci 0000:02:05.0: enabling Extended Tags
[    0.572263] pci 0000:02:05.0: PME# supported from D0 D3hot D3cold
[    0.572622] pci 0000:02:06.0: [1022:57a3] type 01 class 0x060400
[    0.572728] pci 0000:02:06.0: enabling Extended Tags
[    0.572950] pci 0000:02:06.0: PME# supported from D0 D3hot D3cold
[    0.573160] pci 0000:02:08.0: [1022:57a4] type 01 class 0x060400
[    0.573252] pci 0000:02:08.0: enabling Extended Tags
[    0.573406] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    0.573555] pci 0000:02:09.0: [1022:57a4] type 01 class 0x060400
[    0.573647] pci 0000:02:09.0: enabling Extended Tags
[    0.573801] pci 0000:02:09.0: PME# supported from D0 D3hot D3cold
[    0.573946] pci 0000:02:0a.0: [1022:57a4] type 01 class 0x060400
[    0.574038] pci 0000:02:0a.0: enabling Extended Tags
[    0.574192] pci 0000:02:0a.0: PME# supported from D0 D3hot D3cold
[    0.574360] pci 0000:01:00.0: PCI bridge to [bus 02-08]
[    0.574367] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
[    0.574371] pci 0000:01:00.0:   bridge window [mem 0xfbf00000-0xfcafffff]
[    0.574377] pci 0000:01:00.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.574468] pci 0000:03:00.0: [1657:0014] type 00 class 0x0c0400
[    0.574505] pci 0000:03:00.0: reg 0x10: [mem 0xfc3c0000-0xfc3fffff 64bit]
[    0.574523] pci 0000:03:00.0: reg 0x18: [mem 0xfc40c000-0xfc40ffff 64bit]
[    0.574557] pci 0000:03:00.0: reg 0x30: [mem 0xfc200000-0xfc2fffff pref]
[    0.574647] pci 0000:03:00.0: PME# supported from D0 D3hot
[    0.574708] pci 0000:03:00.0: 16.000 Gb/s available PCIe bandwidth,
limited by 5 GT/s x4 link at 0000:02:02.0 (capable of 32.000 Gb/s with 5
GT/s x8 link)
[    0.574754] pci 0000:03:00.1: [1657:0014] type 00 class 0x0c0400
[    0.574790] pci 0000:03:00.1: reg 0x10: [mem 0xfc380000-0xfc3bffff 64bit]
[    0.574808] pci 0000:03:00.1: reg 0x18: [mem 0xfc408000-0xfc40bfff 64bit]
[    0.574841] pci 0000:03:00.1: reg 0x30: [mem 0xfc100000-0xfc1fffff pref]
[    0.574924] pci 0000:03:00.1: PME# supported from D0 D3hot
[    0.574997] pci 0000:03:00.2: [1657:0014] type 00 class 0x020000
[    0.575033] pci 0000:03:00.2: reg 0x10: [mem 0xfc340000-0xfc37ffff 64bit]
[    0.575051] pci 0000:03:00.2: reg 0x18: [mem 0xfc404000-0xfc407fff 64bit]
[    0.575084] pci 0000:03:00.2: reg 0x30: [mem 0xfc000000-0xfc0fffff pref]
[    0.575165] pci 0000:03:00.2: PME# supported from D0 D3hot
[    0.575240] pci 0000:03:00.3: [1657:0014] type 00 class 0x020000
[    0.575275] pci 0000:03:00.3: reg 0x10: [mem 0xfc300000-0xfc33ffff 64bit]
[    0.575294] pci 0000:03:00.3: reg 0x18: [mem 0xfc400000-0xfc403fff 64bit]
[    0.575328] pci 0000:03:00.3: reg 0x30: [mem 0xfbf00000-0xfbffffff pref]
[    0.575409] pci 0000:03:00.3: PME# supported from D0 D3hot
[    0.575586] pci 0000:02:02.0: PCI bridge to [bus 03]
[    0.575595] pci 0000:02:02.0:   bridge window [mem 0xfbf00000-0xfc4fffff]
[    0.575703] pci 0000:04:00.0: [8086:1539] type 00 class 0x020000
[    0.575748] pci 0000:04:00.0: reg 0x10: [mem 0xfca00000-0xfca1ffff]
[    0.575781] pci 0000:04:00.0: reg 0x18: [io  0xe000-0xe01f]
[    0.575799] pci 0000:04:00.0: reg 0x1c: [mem 0xfca20000-0xfca23fff]
[    0.575974] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.576155] pci 0000:02:05.0: PCI bridge to [bus 04]
[    0.576161] pci 0000:02:05.0:   bridge window [io  0xe000-0xefff]
[    0.576165] pci 0000:02:05.0:   bridge window [mem 0xfca00000-0xfcafffff]
[    0.576265] pci 0000:05:00.0: [1002:7143] type 00 class 0x030000
[    0.576308] pci 0000:05:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.576331] pci 0000:05:00.0: reg 0x18: [mem 0xfc930000-0xfc93ffff 64bit]
[    0.576346] pci 0000:05:00.0: reg 0x20: [io  0xd000-0xd0ff]
[    0.576375] pci 0000:05:00.0: reg 0x30: [mem 0xfc900000-0xfc91ffff pref]
[    0.576387] pci 0000:05:00.0: enabling Extended Tags
[    0.576399] pci 0000:05:00.0: BAR 0: assigned to efifb
[    0.576466] pci 0000:05:00.0: supports D1 D2
[    0.576508] pci 0000:05:00.0: 2.000 Gb/s available PCIe bandwidth,
limited by 2.5 GT/s x1 link at 0000:02:06.0 (capable of 32.000 Gb/s with
2.5 GT/s x16 link)
[    0.576556] pci 0000:05:00.1: [1002:7163] type 00 class 0x038000
[    0.576594] pci 0000:05:00.1: reg 0x10: [mem 0xfc920000-0xfc92ffff 64bit]
[    0.576712] pci 0000:05:00.1: supports D1 D2
[    0.576766] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device. 
You can enable it with 'pcie_aspm=force'
[    0.576781] pci 0000:02:06.0: PCI bridge to [bus 05]
[    0.576787] pci 0000:02:06.0:   bridge window [io  0xd000-0xdfff]
[    0.576791] pci 0000:02:06.0:   bridge window [mem 0xfc900000-0xfc9fffff]
[    0.576798] pci 0000:02:06.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.576902] pci 0000:06:00.0: [1022:1485] type 00 class 0x130000
[    0.576984] pci 0000:06:00.0: enabling Extended Tags
[    0.577118] pci 0000:06:00.0: 63.012 Gb/s available PCIe bandwidth,
limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 252.048 Gb/s with
16 GT/s x16 link)
[    0.577250] pci 0000:06:00.1: [1022:149c] type 00 class 0x0c0330
[    0.577645] pci 0000:06:00.1: reg 0x10: [mem 0xfc600000-0xfc6fffff 64bit]
[    0.578382] pci 0000:06:00.1: enabling Extended Tags
[    0.578923] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    0.579201] pci 0000:06:00.3: [1022:149c] type 00 class 0x0c0330
[    0.579235] pci 0000:06:00.3: reg 0x10: [mem 0xfc500000-0xfc5fffff 64bit]
[    0.579295] pci 0000:06:00.3: enabling Extended Tags
[    0.579370] pci 0000:06:00.3: PME# supported from D0 D3hot D3cold
[    0.579530] pci 0000:02:08.0: PCI bridge to [bus 06]
[    0.579539] pci 0000:02:08.0:   bridge window [mem 0xfc500000-0xfc6fffff]
[    0.579632] pci 0000:07:00.0: [1022:7901] type 00 class 0x010601
[    0.579716] pci 0000:07:00.0: reg 0x24: [mem 0xfc800000-0xfc8007ff]
[    0.579736] pci 0000:07:00.0: enabling Extended Tags
[    0.579828] pci 0000:07:00.0: PME# supported from D3hot D3cold
[    0.579890] pci 0000:07:00.0: 63.012 Gb/s available PCIe bandwidth,
limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 252.048 Gb/s with
16 GT/s x16 link)
[    0.579963] pci 0000:02:09.0: PCI bridge to [bus 07]
[    0.579972] pci 0000:02:09.0:   bridge window [mem 0xfc800000-0xfc8fffff]
[    0.580064] pci 0000:08:00.0: [1022:7901] type 00 class 0x010601
[    0.580148] pci 0000:08:00.0: reg 0x24: [mem 0xfc700000-0xfc7007ff]
[    0.580168] pci 0000:08:00.0: enabling Extended Tags
[    0.580260] pci 0000:08:00.0: PME# supported from D3hot D3cold
[    0.580321] pci 0000:08:00.0: 63.012 Gb/s available PCIe bandwidth,
limited by 16 GT/s x4 link at 0000:00:01.2 (capable of 252.048 Gb/s with
16 GT/s x16 link)
[    0.580392] pci 0000:02:0a.0: PCI bridge to [bus 08]
[    0.580401] pci 0000:02:0a.0:   bridge window [mem 0xfc700000-0xfc7fffff]
[    0.580481] pci 0000:09:00.0: [1000:00af] type 00 class 0x010700
[    0.580509] pci 0000:09:00.0: reg 0x10: [mem 0xe0100000-0xe01fffff
64bit pref]
[    0.580521] pci 0000:09:00.0: reg 0x18: [mem 0xe0000000-0xe00fffff
64bit pref]
[    0.580529] pci 0000:09:00.0: reg 0x20: [mem 0xfce00000-0xfcefffff]
[    0.580537] pci 0000:09:00.0: reg 0x24: [io  0xf000-0xf0ff]
[    0.580547] pci 0000:09:00.0: reg 0x30: [mem 0xfcf00000-0xfcf3ffff pref]
[    0.580607] pci 0000:09:00.0: supports D1 D2
[    0.580686] pci 0000:00:03.2: PCI bridge to [bus 09]
[    0.580690] pci 0000:00:03.2:   bridge window [io  0xf000-0xffff]
[    0.580692] pci 0000:00:03.2:   bridge window [mem 0xfce00000-0xfcffffff]
[    0.580696] pci 0000:00:03.2:   bridge window [mem
0xe0000000-0xe01fffff 64bit pref]
[    0.580726] pci 0000:0a:00.0: [1022:148a] type 00 class 0x130000
[    0.580760] pci 0000:0a:00.0: enabling Extended Tags
[    0.580854] pci 0000:00:07.1: PCI bridge to [bus 0a]
[    0.580899] pci 0000:0b:00.0: [1022:1485] type 00 class 0x130000
[    0.580940] pci 0000:0b:00.0: enabling Extended Tags
[    0.581026] pci 0000:0b:00.1: [1022:1486] type 00 class 0x108000
[    0.581048] pci 0000:0b:00.1: reg 0x18: [mem 0xfcc00000-0xfccfffff]
[    0.581060] pci 0000:0b:00.1: reg 0x24: [mem 0xfcd00000-0xfcd01fff]
[    0.581068] pci 0000:0b:00.1: enabling Extended Tags
[    0.581149] pci 0000:0b:00.3: [1022:149c] type 00 class 0x0c0330
[    0.581167] pci 0000:0b:00.3: reg 0x10: [mem 0xfcb00000-0xfcbfffff 64bit]
[    0.581197] pci 0000:0b:00.3: enabling Extended Tags
[    0.581241] pci 0000:0b:00.3: PME# supported from D0 D3hot D3cold
[    0.581310] pci 0000:00:08.1: PCI bridge to [bus 0b]
[    0.581314] pci 0000:00:08.1:   bridge window [mem 0xfcb00000-0xfcdfffff]
[    0.581547] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.581574] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.581597] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.581626] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.581652] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.581673] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.581695] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.581716] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.582011] ACPI: EC: interrupt unblocked
[    0.582020] ACPI: EC: event unblocked
[    0.582025] ACPI: \_SB_.PCI0.SBRG.EC0_: GPE=0x2, EC_CMD/EC_SC=0x66,
EC_DATA=0x62
[    0.582027] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC used to handle
transactions and events
[    0.582049] iommu: Default domain type: Translated
[    0.582055] pci 0000:05:00.0: vgaarb: setting as boot VGA device
[    0.582055] pci 0000:05:00.0: vgaarb: VGA device added:
decodes=io+mem,owns=io+mem,locks=none
[    0.582055] pci 0000:05:00.0: vgaarb: bridge control possible
[    0.582055] vgaarb: loaded
[    0.582055] EDAC MC: Ver: 3.0.0
[    0.582055] Registered efivars operations
[    0.582055] PCI: Using ACPI for IRQ routing
[    0.586149] PCI: pci_cache_line_size set to 64 bytes
[    0.586260] e820: reserve RAM buffer [mem 0x09bff000-0x0bffffff]
[    0.586260] e820: reserve RAM buffer [mem 0x0a200000-0x0bffffff]
[    0.586261] e820: reserve RAM buffer [mem 0xc5a1e000-0xc7ffffff]
[    0.586261] e820: reserve RAM buffer [mem 0xc6c68000-0xc7ffffff]
[    0.586261] e820: reserve RAM buffer [mem 0xca43e000-0xcbffffff]
[    0.586262] e820: reserve RAM buffer [mem 0xcd000000-0xcfffffff]
[    0.586262] e820: reserve RAM buffer [mem 0x102f380000-0x102fffffff]
[    0.586336] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.586338] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.588600] clocksource: Switched to clocksource tsc-early
[    0.594554] VFS: Disk quotas dquot_6.6.0
[    0.594567] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
bytes)
[    0.594637] AppArmor: AppArmor Filesystem Enabled
[    0.594644] pnp: PnP ACPI init
[    0.594691] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.594694] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.594711] system 00:01: [mem 0xfeb80000-0xfebfffff] has been reserved
[    0.594713] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.594750] system 00:02: [mem 0xfd100000-0xfd1fffff] has been reserved
[    0.594752] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.594772] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.594839] system 00:04: [io  0x0290-0x029f] has been reserved
[    0.594841] system 00:04: [io  0x0200-0x021f] has been reserved
[    0.594843] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.594973] pnp 00:05: [dma 0 disabled]
[    0.594990] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.595121] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.595122] system 00:06: [io  0x040b] has been reserved
[    0.595123] system 00:06: [io  0x04d6] has been reserved
[    0.595125] system 00:06: [io  0x0c00-0x0c01] has been reserved
[    0.595126] system 00:06: [io  0x0c14] has been reserved
[    0.595128] system 00:06: [io  0x0c50-0x0c51] has been reserved
[    0.595129] system 00:06: [io  0x0c52] has been reserved
[    0.595131] system 00:06: [io  0x0c6c] has been reserved
[    0.595132] system 00:06: [io  0x0c6f] has been reserved
[    0.595134] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
[    0.595135] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
[    0.595137] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
[    0.595138] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
[    0.595140] system 00:06: [io  0x0cd8-0x0cdf] has been reserved
[    0.595141] system 00:06: [io  0x0800-0x089f] has been reserved
[    0.595142] system 00:06: [io  0x0b00-0x0b0f] has been reserved
[    0.595144] system 00:06: [io  0x0b20-0x0b3f] has been reserved
[    0.595145] system 00:06: [io  0x0900-0x090f] has been reserved
[    0.595146] system 00:06: [io  0x0910-0x091f] has been reserved
[    0.595148] system 00:06: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.595150] system 00:06: [mem 0xfec01000-0xfec01fff] could not be
reserved
[    0.595151] system 00:06: [mem 0xfedc0000-0xfedc0fff] has been reserved
[    0.595153] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.595155] system 00:06: [mem 0xfed80000-0xfed8ffff] could not be
reserved
[    0.595157] system 00:06: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.595158] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    0.595161] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.595393] pnp: PnP ACPI: found 7 devices
[    0.596028] thermal_sys: Registered thermal governor 'fair_share'
[    0.596028] thermal_sys: Registered thermal governor 'bang_bang'
[    0.596030] thermal_sys: Registered thermal governor 'step_wise'
[    0.596031] thermal_sys: Registered thermal governor 'user_space'
[    0.600535] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[    0.600559] pci 0000:02:02.0: PCI bridge to [bus 03]
[    0.600565] pci 0000:02:02.0:   bridge window [mem 0xfbf00000-0xfc4fffff]
[    0.600574] pci 0000:02:05.0: PCI bridge to [bus 04]
[    0.600577] pci 0000:02:05.0:   bridge window [io  0xe000-0xefff]
[    0.600582] pci 0000:02:05.0:   bridge window [mem 0xfca00000-0xfcafffff]
[    0.600592] pci 0000:02:06.0: PCI bridge to [bus 05]
[    0.600594] pci 0000:02:06.0:   bridge window [io  0xd000-0xdfff]
[    0.600599] pci 0000:02:06.0:   bridge window [mem 0xfc900000-0xfc9fffff]
[    0.600603] pci 0000:02:06.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.600610] pci 0000:02:08.0: PCI bridge to [bus 06]
[    0.600615] pci 0000:02:08.0:   bridge window [mem 0xfc500000-0xfc6fffff]
[    0.600625] pci 0000:02:09.0: PCI bridge to [bus 07]
[    0.600630] pci 0000:02:09.0:   bridge window [mem 0xfc800000-0xfc8fffff]
[    0.600639] pci 0000:02:0a.0: PCI bridge to [bus 08]
[    0.600644] pci 0000:02:0a.0:   bridge window [mem 0xfc700000-0xfc7fffff]
[    0.600654] pci 0000:01:00.0: PCI bridge to [bus 02-08]
[    0.600656] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
[    0.600661] pci 0000:01:00.0:   bridge window [mem 0xfbf00000-0xfcafffff]
[    0.600665] pci 0000:01:00.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.600672] pci 0000:00:01.2: PCI bridge to [bus 01-08]
[    0.600674] pci 0000:00:01.2:   bridge window [io  0xd000-0xefff]
[    0.600677] pci 0000:00:01.2:   bridge window [mem 0xfbf00000-0xfcafffff]
[    0.600679] pci 0000:00:01.2:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.600683] pci 0000:00:03.2: PCI bridge to [bus 09]
[    0.600684] pci 0000:00:03.2:   bridge window [io  0xf000-0xffff]
[    0.600687] pci 0000:00:03.2:   bridge window [mem 0xfce00000-0xfcffffff]
[    0.600690] pci 0000:00:03.2:   bridge window [mem
0xe0000000-0xe01fffff 64bit pref]
[    0.600693] pci 0000:00:07.1: PCI bridge to [bus 0a]
[    0.600700] pci 0000:00:08.1: PCI bridge to [bus 0b]
[    0.600703] pci 0000:00:08.1:   bridge window [mem 0xfcb00000-0xfcdfffff]
[    0.600708] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.600709] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.600710] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.600711] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.600713] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff
window]
[    0.600714] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff
window]
[    0.600715] pci_bus 0000:00: resource 10 [mem 0xd0000000-0xfec02fff
window]
[    0.600717] pci_bus 0000:00: resource 11 [mem 0xfee00000-0xffffffff
window]
[    0.600718] pci_bus 0000:01: resource 0 [io  0xd000-0xefff]
[    0.600719] pci_bus 0000:01: resource 1 [mem 0xfbf00000-0xfcafffff]
[    0.600720] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.600722] pci_bus 0000:02: resource 0 [io  0xd000-0xefff]
[    0.600723] pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfcafffff]
[    0.600724] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.600726] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfc4fffff]
[    0.600727] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.600728] pci_bus 0000:04: resource 1 [mem 0xfca00000-0xfcafffff]
[    0.600729] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.600731] pci_bus 0000:05: resource 1 [mem 0xfc900000-0xfc9fffff]
[    0.600732] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.600733] pci_bus 0000:06: resource 1 [mem 0xfc500000-0xfc6fffff]
[    0.600734] pci_bus 0000:07: resource 1 [mem 0xfc800000-0xfc8fffff]
[    0.600736] pci_bus 0000:08: resource 1 [mem 0xfc700000-0xfc7fffff]
[    0.600737] pci_bus 0000:09: resource 0 [io  0xf000-0xffff]
[    0.600738] pci_bus 0000:09: resource 1 [mem 0xfce00000-0xfcffffff]
[    0.600740] pci_bus 0000:09: resource 2 [mem 0xe0000000-0xe01fffff
64bit pref]
[    0.600741] pci_bus 0000:0b: resource 1 [mem 0xfcb00000-0xfcdfffff]
[    0.600794] NET: Registered protocol family 2
[    0.600880] tcp_listen_portaddr_hash hash table entries: 32768
(order: 7, 524288 bytes, linear)
[    0.600925] TCP established hash table entries: 524288 (order: 10,
4194304 bytes, linear)
[    0.601309] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes, linear)
[    0.601391] TCP: Hash tables configured (established 524288 bind 65536)
[    0.601429] UDP hash table entries: 32768 (order: 8, 1048576 bytes,
linear)
[    0.601513] UDP-Lite hash table entries: 32768 (order: 8, 1048576
bytes, linear)
[    0.601636] NET: Registered protocol family 1
[    0.601640] NET: Registered protocol family 44
[    0.601696] pci 0000:05:00.0: Video device with shadowed ROM at [mem
0x000c0000-0x000dffff]
[    0.806344] pci 0000:0b:00.3: quirk_usb_early_handoff+0x0/0x644 took
199603 usecs
[    0.806347] PCI: CLS 64 bytes, default 64
[    0.806369] Trying to unpack rootfs image as initramfs...
[    0.874014] Freeing initrd memory: 7820K
[    0.874019] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.874020] software IO TLB: mapped [mem 0xbd943000-0xc1943000] (64MB)
[    0.874048] amd_uncore: AMD NB counters detected
[    0.874069] amd_uncore: AMD LLC counters detected
[    0.874220] LVT offset 0 assigned for vector 0x400
[    0.874292] perf: AMD IBS detected (0x000003ff)
[    0.874653] Initialise system trusted keyrings
[    0.874662] Key type blacklist registered
[    0.874696] workingset: timestamp_bits=40 max_order=24 bucket_order=0
[    0.875353] zbud: loaded
[    0.875496] Platform Keyring initialized
[    0.875498] Key type asymmetric registered
[    0.875499] Asymmetric key parser 'x509' registered
[    0.875503] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 250)
[    0.875534] io scheduler mq-deadline registered
[    0.876137] pcieport 0000:00:01.2: AER: enabled with IRQ 26
[    0.876240] pcieport 0000:00:03.2: AER: enabled with IRQ 27
[    0.876376] pcieport 0000:00:07.1: AER: enabled with IRQ 29
[    0.876464] pcieport 0000:00:08.1: AER: enabled with IRQ 30
[    0.877767] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.877774] efifb: probing for efifb
[    0.877783] efifb: framebuffer at 0xd0000000, using 3072k, total 3072k
[    0.877785] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    0.877786] efifb: scrolling: redraw
[    0.877787] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.894388] Console: switching to colour frame buffer device 128x48
[    0.911254] fb0: EFI VGA frame buffer device
[    0.911439] Monitor-Mwait will be used to enter C-1 state
[    0.912540] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.933170] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
is a 16550A
[    0.933488] Linux agpgart interface v0.103
[    0.933842] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    0.933949] AMD-Vi: AMD IOMMUv2 functionality not available on this
system
[    0.934691] i8042: PNP: No PS/2 controller found.
[    0.934760] mousedev: PS/2 mouse device common for all mice
[    0.934927] rtc_cmos 00:03: RTC can wake from S4
[    0.935170] rtc_cmos 00:03: registered as rtc0
[    0.935212] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
[    0.935542] ledtrig-cpu: registered to indicate activity on CPUs
[    0.935790] drop_monitor: Initializing network drop monitor service
[    0.935976] NET: Registered protocol family 10
[    0.940234] Segment Routing with IPv6
[    0.940253] mip6: Mobile IPv6
[    0.940341] NET: Registered protocol family 17
[    0.940512] mpls_gso: MPLS GSO support
[    0.941181] microcode: CPU0: patch_level=0x08701021
[    0.941231] microcode: CPU1: patch_level=0x08701021
[    0.941383] microcode: CPU2: patch_level=0x08701021
[    0.941537] microcode: CPU3: patch_level=0x08701021
[    0.941691] microcode: CPU4: patch_level=0x08701021
[    0.947508] microcode: CPU5: patch_level=0x08701021
[    0.953275] microcode: CPU6: patch_level=0x08701021
[    0.958946] microcode: CPU7: patch_level=0x08701021
[    0.964521] microcode: CPU8: patch_level=0x08701021
[    0.970012] microcode: CPU9: patch_level=0x08701021
[    0.975425] microcode: CPU10: patch_level=0x08701021
[    0.980774] microcode: CPU11: patch_level=0x08701021
[    0.985978] microcode: CPU12: patch_level=0x08701021
[    0.991114] microcode: CPU13: patch_level=0x08701021
[    0.996188] microcode: CPU14: patch_level=0x08701021
[    1.001173] microcode: CPU15: patch_level=0x08701021
[    1.006001] microcode: Microcode Update Driver: v2.2.
[    1.006003] IPI shorthand broadcast: enabled
[    1.015444] sched_clock: Marking stable (1014916985,
522308)->(1128543604, -113104311)
[    1.020426] registered taskstats version 1
[    1.025296] Loading compiled-in X.509 certificates
[    1.047115] Loaded X.509 cert 'Debian Secure Boot CA:
6ccece7e4c6c0d1f6149f3dd27dfcc5cbb419ea1'
[    1.052423] Loaded X.509 cert 'Debian Secure Boot Signer: 00a7468def'
[    1.057728] zswap: loaded using pool lzo/zbud
[    1.063064] Key type ._fscrypt registered
[    1.068158] Key type .fscrypt registered
[    1.073293] AppArmor: AppArmor sha1 policy hashing enabled
[    1.078537] integrity: Loading X.509 certificate: UEFI:db
[    1.083781] integrity: Loaded X.509 cert 'ASUSTeK MotherBoard SW Key
Certificate: da83b990422ebc8c441f8d8b039a65a2'
[    1.089131] integrity: Loading X.509 certificate: UEFI:db
[    1.094600] integrity: Loaded X.509 cert 'ASUSTeK Notebook SW Key
Certificate: b8e581e4df77a5bb4282d5ccfc00c071'
[    1.100110] integrity: Loading X.509 certificate: UEFI:db
[    1.105637] integrity: Loaded X.509 cert 'Microsoft Corporation UEFI
CA 2011: 13adbf4309bd82709c8cd54f316ed522988a1bd4'
[    1.111378] integrity: Loading X.509 certificate: UEFI:db
[    1.117061] integrity: Loaded X.509 cert 'Microsoft Windows
Production PCA 2011: a92902398e16c49778cd90f99e4f9ae17c55af53'
[    1.123028] integrity: Loading X.509 certificate: UEFI:db
[    1.129020] integrity: Loaded X.509 cert 'Canonical Ltd. Master
Certificate Authority: ad91990bc22ab1f517048c23b6655a268e345a63'
[    1.141740] rtc_cmos 00:03: setting system clock to
2020-09-22T04:08:44 UTC (1600747724)
[    1.148707] Freeing unused kernel image memory: 1664K
[    1.159777] Write protecting the kernel read-only data: 16384k
[    1.166440] Freeing unused kernel image memory: 2036K
[    1.172796] Freeing unused kernel image memory: 344K
[    1.183717] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.189964] Run /init as init process
[    1.256876] SCSI subsystem initialized
[    1.263232] ACPI: bus type USB registered
[    1.269533] usbcore: registered new interface driver usbfs
[    1.276082] usbcore: registered new interface driver hub
[    1.282688] usbcore: registered new device driver usb
[    1.283384] libata version 3.00 loaded.
[    1.291127] ahci 0000:07:00.0: version 3.0
[    1.291271] ahci 0000:07:00.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps
0x1 impl SATA mode
[    1.298067] ahci 0000:07:00.0: flags: 64bit ncq sntf ilck pm led clo
only pmp fbs pio slum part
[    1.305387] scsi host0: ahci
[    1.312449] ata1: SATA max UDMA/133 abar m2048@0xfc800000 port
0xfc800100 irq 39
[    1.320033] ahci 0000:08:00.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps
0x10 impl SATA mode
[    1.320434] xhci_hcd 0000:06:00.1: xHCI Host Controller
[    1.327535] ahci 0000:08:00.0: flags: 64bit ncq sntf ilck pm led clo
only pmp fbs pio slum part
[    1.335158] xhci_hcd 0000:06:00.1: new USB bus registered, assigned
bus number 1
[    1.345327] scsi host1: ahci
[    1.358380] xhci_hcd 0000:06:00.1: hcc params 0x0278ffe5 hci version
0x110 quirks 0x0000000000000410
[    1.360018] scsi host2: ahci
[    1.374992] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002, bcdDevice= 5.04
[    1.376621] scsi host3: ahci
[    1.385140] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.394624] scsi host4: ahci
[    1.402763] usb usb1: Product: xHCI Host Controller
[    1.402764] usb usb1: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
[    1.411841] scsi host5: ahci
[    1.420259] usb usb1: SerialNumber: 0000:06:00.1
[    1.421336] hub 1-0:1.0: USB hub found
[    1.429157] ata2: DUMMY
[    1.438411] hub 1-0:1.0: 6 ports detected
[    1.446331] ata3: DUMMY
[    1.460155] xhci_hcd 0000:06:00.1: xHCI Host Controller
[    1.463585] ata4: DUMMY
[    1.472199] xhci_hcd 0000:06:00.1: new USB bus registered, assigned
bus number 2
[    1.480710] ata5: DUMMY
[    1.480797] ata6: SATA max UDMA/133 abar m2048@0xfc700000 port
0xfc700300 irq 40
[    1.489195] xhci_hcd 0000:06:00.1: Host supports USB 3.1 Enhanced
SuperSpeed
[    1.530583] usb usb2: We don't know the algorithms for LPM for this
host, disabling LPM.
[    1.538681] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0003, bcdDevice= 5.04
[    1.546795] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.554775] usb usb2: Product: xHCI Host Controller
[    1.562519] usb usb2: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
[    1.570229] usb usb2: SerialNumber: 0000:06:00.1
[    1.577919] hub 2-0:1.0: USB hub found
[    1.585414] hub 2-0:1.0: 4 ports detected
[    1.592979] xhci_hcd 0000:06:00.3: xHCI Host Controller
[    1.600717] xhci_hcd 0000:06:00.3: new USB bus registered, assigned
bus number 3
[    1.603291] ata1: SATA link down (SStatus 0 SControl 300)
[    1.614881] xhci_hcd 0000:06:00.3: hcc params 0x0278ffe5 hci version
0x110 quirks 0x0000000000000410
[    1.623891] usb usb3: New USB device found, idVendor=1d6b,
idProduct=0002, bcdDevice= 5.04
[    1.631770] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.639766] usb usb3: Product: xHCI Host Controller
[    1.647763] usb usb3: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
[    1.655820] usb usb3: SerialNumber: 0000:06:00.3
[    1.663970] hub 3-0:1.0: USB hub found
[    1.672133] hub 3-0:1.0: 6 ports detected
[    1.680289] xhci_hcd 0000:06:00.3: xHCI Host Controller
[    1.680618] tsc: Refined TSC clocksource calibration: 3892.596 MHz
[    1.688150] xhci_hcd 0000:06:00.3: new USB bus registered, assigned
bus number 4
[    1.696106] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x703812d4d0d, max_idle_ns: 881591033682 ns
[    1.704069] xhci_hcd 0000:06:00.3: Host supports USB 3.1 Enhanced
SuperSpeed
[    1.720410] usb usb4: We don't know the algorithms for LPM for this
host, disabling LPM.
[    1.720417] clocksource: Switched to clocksource tsc
[    1.728467] usb usb4: New USB device found, idVendor=1d6b,
idProduct=0003, bcdDevice= 5.04
[    1.744641] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.752688] usb usb4: Product: xHCI Host Controller
[    1.760590] usb usb4: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
[    1.768471] usb usb4: SerialNumber: 0000:06:00.3
[    1.776257] hub 4-0:1.0: USB hub found
[    1.783963] hub 4-0:1.0: 4 ports detected
[    1.791491] usb: port power management may be unreliable
[    1.799139] xhci_hcd 0000:0b:00.3: xHCI Host Controller
[    1.806601] xhci_hcd 0000:0b:00.3: new USB bus registered, assigned
bus number 5
[    1.814290] xhci_hcd 0000:0b:00.3: hcc params 0x0278ffe5 hci version
0x110 quirks 0x0000000000000410
[    1.822056] usb usb5: New USB device found, idVendor=1d6b,
idProduct=0002, bcdDevice= 5.04
[    1.829790] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.837670] usb usb5: Product: xHCI Host Controller
[    1.845551] usb usb5: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
[    1.853541] usb usb5: SerialNumber: 0000:0b:00.3
[    1.861535] hub 5-0:1.0: USB hub found
[    1.869370] hub 5-0:1.0: 4 ports detected
[    1.869551] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.877697] xhci_hcd 0000:0b:00.3: xHCI Host Controller
[    1.891110] ata6.00: ATA-11: SAMSUNG MZ7LH960HAJR-00005, HXT7404Q,
max UDMA/133
[    1.892925] xhci_hcd 0000:0b:00.3: new USB bus registered, assigned
bus number 6
[    1.900618] ata6.00: 1875385008 sectors, multi 16: LBA48 NCQ (depth
32), AA
[    1.906846] ata6.00: configured for UDMA/133
[    1.908736] xhci_hcd 0000:0b:00.3: Host supports USB 3.1 Enhanced
SuperSpeed
[    1.921112] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG MZ7LH960
404Q PQ: 0 ANSI: 5
[    1.924110] usb usb6: We don't know the algorithms for LPM for this
host, disabling LPM.
[    1.947495] usb usb6: New USB device found, idVendor=1d6b,
idProduct=0003, bcdDevice= 5.04
[    1.955555] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.963688] usb usb6: Product: xHCI Host Controller
[    1.971784] usb usb6: Manufacturer: Linux 5.4.0-0.bpo.4-amd64 xhci-hcd
[    1.979946] usb usb6: SerialNumber: 0000:0b:00.3
[    1.984832] sd 5:0:0:0: [sda] 1875385008 512-byte logical blocks:
(960 GB/894 GiB)
[    1.992125] hub 6-0:1.0: USB hub found
[    1.996071] sd 5:0:0:0: [sda] 4096-byte physical blocks
[    2.004148] hub 6-0:1.0: 4 ports detected
[    2.011980] sd 5:0:0:0: [sda] Write Protect is off
[    2.027652] sd 5:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.027692] sd 5:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.036587] usb 3-4: new full-speed USB device number 2 using xhci_hcd
[    2.049528]  sda: sda1 sda2 sda3 sda4 sda5
[    2.057831] sd 5:0:0:0: [sda] Attached SCSI disk
[    2.206433] usb 3-4: config 1 has an invalid interface number: 2 but
max is 1
[    2.214550] usb 3-4: config 1 has no interface number 1
[    2.222636] usb 5-2: new high-speed USB device number 2 using xhci_hcd
[    2.241432] usb 3-4: New USB device found, idVendor=0b05,
idProduct=18f3, bcdDevice= 1.00
[    2.249267] usb 3-4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    2.257111] usb 3-4: Product: AURA LED Controller
[    2.264851] usb 3-4: Manufacturer: AsusTek Computer Inc.
[    2.272505] usb 3-4: SerialNumber: 9876543210
[    2.283488] usb 5-2: New USB device found, idVendor=05e3,
idProduct=0608, bcdDevice= 7.02
[    2.291104] usb 5-2: New USB device strings: Mfr=0, Product=1,
SerialNumber=0
[    2.298805] usb 5-2: Product: USB2.0 Hub
[    2.312769] hidraw: raw HID events driver (C) Jiri Kosina
[    2.328477] usbcore: registered new interface driver usbhid
[    2.336157] usbhid: USB HID core driver
[    2.343033] hub 5-2:1.0: USB hub found
[    2.351989] hub 5-2:1.0: 4 ports detected
[    2.359663] hid-generic 0003:0B05:18F3.0001: hiddev0,hidraw0: USB HID
v1.11 Device [AsusTek Computer Inc. AURA LED Controller] on
usb-0000:06:00.3-4/input2
[    2.486036] SGI XFS with ACLs, security attributes, realtime, no
debug enabled
[    2.494812] XFS (sda3): Mounting V5 Filesystem
[    2.521688] XFS (sda3): Starting recovery (logdev: internal)
[    2.534766] XFS (sda3): Ending recovery (logdev: internal)
[    2.589845] Not activating Mandatory Access Control as
/sbin/tomoyo-init does not exist.
[    2.645379] systemd[1]: Inserted module 'autofs4'
[    2.660580] usb 5-2.1: new low-speed USB device number 3 using xhci_hcd
[    2.677021] systemd[1]: systemd 241 running in system mode. (+PAM
+AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN
-PCRE2 default-hierarchy=hybrid)
[    2.712608] systemd[1]: Detected architecture x86-64.
[    2.769689] systemd[1]: Set hostname to <mercury>.
[    2.787930] usb 5-2.1: New USB device found, idVendor=0b39,
idProduct=0d04, bcdDevice= 1.60
[    2.796017] usb 5-2.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    2.804190] usb 5-2.1: Product: USB KVM Switch 4 PORT V2.7
[    2.812360] usb 5-2.1: Manufacturer: USB KVM Switch 4 PORT V2.7
[    2.927060] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
V2.7 as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.0/0003:0B39:0D04.0002/input/input0
[    3.000626] hid-generic 0003:0B39:0D04.0002: input,hidraw1: USB HID
v1.10 Keyboard [USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT V2.7]
on usb-0000:0b:00.3-2.1/input0
[    3.025098] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
V2.7 Mouse as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input1
[    3.043213] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
V2.7 System Control as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input2
[    3.120598] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
V2.7 Consumer Control as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input3
[    3.140164] input: USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT
V2.7 as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.1/5-2.1:1.1/0003:0B39:0D04.0003/input/input4
[    3.160652] hid-generic 0003:0B39:0D04.0003: input,hidraw2: USB HID
v1.10 Mouse [USB KVM Switch 4 PORT V2.7 USB KVM Switch 4 PORT V2.7] on
usb-0000:0b:00.3-2.1/input1
[    3.260579] usb 5-2.2: new low-speed USB device number 4 using xhci_hcd
[    3.389957] usb 5-2.2: New USB device found, idVendor=046d,
idProduct=c31c, bcdDevice=64.00
[    3.400566] usb 5-2.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    3.411278] usb 5-2.2: Product: USB Keyboard
[    3.421973] usb 5-2.2: Manufacturer: Logitech
[    3.537059] input: Logitech USB Keyboard as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.2/5-2.2:1.0/0003:046D:C31C.0004/input/input5
[    3.616648] hid-generic 0003:046D:C31C.0004: input,hidraw3: USB HID
v1.10 Keyboard [Logitech USB Keyboard] on usb-0000:0b:00.3-2.2/input0
[    3.649069] input: Logitech USB Keyboard Consumer Control as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.2/5-2.2:1.1/0003:046D:C31C.0005/input/input6
[    3.728590] input: Logitech USB Keyboard System Control as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.2/5-2.2:1.1/0003:046D:C31C.0005/input/input7
[    3.752222] hid-generic 0003:046D:C31C.0005: input,hidraw4: USB HID
v1.10 Device [Logitech USB Keyboard] on usb-0000:0b:00.3-2.2/input1
[    3.856580] usb 5-2.3: new low-speed USB device number 5 using xhci_hcd
[    3.874510] systemd[1]: Started Dispatch Password Requests to Console
Directory Watch.
[    3.899614] systemd[1]: Listening on fsck to fsckd communication Socket.
[    3.925058] systemd[1]: Listening on Syslog Socket.
[    3.950305] systemd[1]: Created slice system-getty.slice.
[    3.974747] systemd[1]: Listening on udev Kernel Socket.
[    3.991992] usb 5-2.3: New USB device found, idVendor=0430,
idProduct=0100, bcdDevice= 1.07
[    3.991993] usb 5-2.3: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[    4.023358] systemd[1]: Listening on udev Control Socket.
[    4.043112] input: HID 0430:0100 as
/devices/pci0000:00/0000:00:08.1/0000:0b:00.3/usb5/5-2/5-2.3/5-2.3:1.0/0003:0430:0100.0006/input/input8
[    4.043910] hid-generic 0003:0430:0100.0006: input,hidraw5: USB HID
v1.10 Mouse [HID 0430:0100] on usb-0000:0b:00.3-2.3/input0
[    4.098551] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[    4.281354] xfs filesystem being remounted at / supports timestamps
until 2038 (0x7fffffff)
[    4.423363] nct6775: Found NCT6798D or compatible chip at 0x2e:0x290
[    4.431387] ACPI Warning: SystemIO range
0x0000000000000295-0x0000000000000296 conflicts with OpRegion
0x0000000000000290-0x0000000000000299 (\AMW0.SHWM) (20190816/utaddress-213)
[    4.448092] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    4.556337] systemd-journald[319]: Received request to flush runtime
journal from PID 1
[    4.619738] acpi_cpufreq: overriding BIOS provided _PSD data
[    4.626986] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input9
[    4.634249] ACPI: Power Button [PWRB]
[    4.641555] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input10
[    4.649229] ACPI: Power Button [PWRF]
[    4.661337] acpi PNP0C14:02: duplicate WMI GUID
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.669267] acpi PNP0C14:03: duplicate WMI GUID
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.676954] acpi PNP0C14:04: duplicate WMI GUID
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.684503] acpi PNP0C14:05: duplicate WMI GUID
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.696944] dca service started, version 1.12.1
[    4.704675] ccp 0000:0b:00.1: enabling device (0000 -> 0002)
[    4.712497] ccp 0000:0b:00.1: ccp enabled
[    4.745963] sd 5:0:0:0: Attached scsi generic sg0 type 0
[    4.753326] EFI Variables Facility v0.08 2004-May-17
[    4.773840] input: PC Speaker as /devices/platform/pcspkr/input/input11
[    4.774977] pps_core: LinuxPPS API ver. 1 registered
[    4.774977] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    4.792364] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00,
revision 0
[    4.807591] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus
port selection
[    4.818718] PTP clock support registered
[    4.821430] pstore: Using crash dump compression: deflate
[    4.821748] setting logging_level(0x000083f8)
[    4.838368] pstore: Registered efi as persistent store backend
[    4.887507] cryptd: max_cpu_qlen set to 1000
[    4.888443] mpt3sas version 31.100.00.00 loaded
[    4.889733] mpt3sas_cm0: mpt3sas_base_attach
[    4.889734] mpt3sas_cm0: mpt3sas_base_map_resources
[    4.889913] mpt3sas_cm0: 63 BIT PCI BUS DMA ADDRESSING SUPPORTED,
total mem (65777052 kB)
[    4.889966] mpt3sas_cm0: _base_get_ioc_facts
[    4.889967] mpt3sas_cm0: _base_wait_for_iocstate
[    4.899897]     offset:data
[    4.955745]     [0x00]:03110206
[    4.955745]     [0x04]:00003900
[    4.955745]     [0x08]:00000000
[    4.955745]     [0x0c]:00000000
[    4.955746]     [0x10]:00000000
[    4.955746]     [0x14]:80010280
[    4.955746]     [0x18]:22311c00
[    4.955746]     [0x1c]:002fa84c
[    4.955747]     [0x20]:10000000
[    4.955747]     [0x24]:00080020
[    4.955747]     [0x28]:0400001a
[    4.955747]     [0x2c]:00a500a0
[    4.955748]     [0x30]:0068000b
[    4.955748]     [0x34]:0020ffe0
[    4.955748]     [0x38]:008004c2
[    4.955748]     [0x3c]:000c0009
[    4.955748]     [0x40]:00000000
[    4.955749] mpt3sas_cm0: CurrentHostPageSize(12)
[    4.955750] mpt3sas_cm0: hba queue depth(7168), max chains per io(128)
[    4.955750] mpt3sas_cm0: request frame size(128), reply frame size(128)
[    4.955761] mpt3sas_cm0: msix is supported, vector_count(128)
[    4.989197] bna: QLogic BR-series 10G Ethernet driver - version: 3.2.25.1
[    4.989430] igb: Intel(R) Gigabit Ethernet Network Driver - version
5.6.0-k
[    4.989431] igb: Copyright (c) 2007-2014 Intel Corporation.
[    4.995514] mpt3sas_cm0: MSI-X vectors supported: 128
[    5.008763] bna 0000:03:00.2: firmware: direct-loading firmware
ctfw-3.2.5.1.bin
[    5.014188]      no of cores: 16, max_msix_vectors: -1
[    5.014189] mpt3sas_cm0:  0 128
[    5.016758] mpt3sas_cm0: High IOPs queues : disabled
[    5.021079] bna 0000:03:00.2: bar0 mapped to 000000000e3c6624, len 262144
[    5.025811] mpt3sas0-msix0: PCI-MSI-X enabled: IRQ 68
[    5.125551] pps pps0: new PPS source ptp0
[    5.128811] mpt3sas0-msix1: PCI-MSI-X enabled: IRQ 69
[    5.128811] mpt3sas0-msix2: PCI-MSI-X enabled: IRQ 70
[    5.128812] mpt3sas0-msix3: PCI-MSI-X enabled: IRQ 71
[    5.128812] mpt3sas0-msix4: PCI-MSI-X enabled: IRQ 72
[    5.128812] mpt3sas0-msix5: PCI-MSI-X enabled: IRQ 73
[    5.128813] mpt3sas0-msix6: PCI-MSI-X enabled: IRQ 74
[    5.128813] mpt3sas0-msix7: PCI-MSI-X enabled: IRQ 75
[    5.128813] mpt3sas0-msix8: PCI-MSI-X enabled: IRQ 76
[    5.128814] mpt3sas0-msix9: PCI-MSI-X enabled: IRQ 77
[    5.128814] mpt3sas0-msix10: PCI-MSI-X enabled: IRQ 78
[    5.128814] mpt3sas0-msix11: PCI-MSI-X enabled: IRQ 79
[    5.128814] mpt3sas0-msix12: PCI-MSI-X enabled: IRQ 80
[    5.128815] mpt3sas0-msix13: PCI-MSI-X enabled: IRQ 81
[    5.128815] mpt3sas0-msix14: PCI-MSI-X enabled: IRQ 82
[    5.128815] mpt3sas0-msix15: PCI-MSI-X enabled: IRQ 83
[    5.128816] mpt3sas0-msix16: PCI-MSI-X enabled: IRQ 84
[    5.128819] mpt3sas0-msix17: PCI-MSI-X enabled: IRQ 85
[    5.134356] igb 0000:04:00.0: added PHC on eth0
[    5.138800] mpt3sas0-msix18: PCI-MSI-X enabled: IRQ 86
[    5.138801] mpt3sas0-msix19: PCI-MSI-X enabled: IRQ 87
[    5.138801] mpt3sas0-msix20: PCI-MSI-X enabled: IRQ 88
[    5.138801] mpt3sas0-msix21: PCI-MSI-X enabled: IRQ 89
[    5.138802] mpt3sas0-msix22: PCI-MSI-X enabled: IRQ 90
[    5.138802] mpt3sas0-msix23: PCI-MSI-X enabled: IRQ 91
[    5.138802] mpt3sas0-msix24: PCI-MSI-X enabled: IRQ 92
[    5.138803] mpt3sas0-msix25: PCI-MSI-X enabled: IRQ 93
[    5.138803] mpt3sas0-msix26: PCI-MSI-X enabled: IRQ 94
[    5.138803] mpt3sas0-msix27: PCI-MSI-X enabled: IRQ 95
[    5.138803] mpt3sas0-msix28: PCI-MSI-X enabled: IRQ 96
[    5.138804] mpt3sas0-msix29: PCI-MSI-X enabled: IRQ 97
[    5.138804] mpt3sas0-msix30: PCI-MSI-X enabled: IRQ 98
[    5.138804] mpt3sas0-msix31: PCI-MSI-X enabled: IRQ 99
[    5.138806] mpt3sas_cm0: iomem(0x00000000e0100000),
mapped(0x0000000057a3b7f4), size(1048576)
[    5.138806] mpt3sas_cm0: ioport(0x000000000000f000), size(256)
[    5.138998] mpt3sas_cm0: _base_get_ioc_facts
[    5.143533] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network
Connection
[    5.148138] mpt3sas_cm0: _base_wait_for_iocstate
[    5.152445]     offset:data
[    5.152540] igb 0000:04:00.0: eth0: (PCIe:2.5Gb/s:Width x1)
24:4b:fe:5e:68:bf
[    5.156859]     [0x00]:03110206
[    5.156860]     [0x04]:00003900
[    5.156860]     [0x08]:00000000
[    5.156860]     [0x0c]:00000000
[    5.156860]     [0x10]:00000000
[    5.156861]     [0x14]:80010280
[    5.156861]     [0x18]:22311c00
[    5.156861]     [0x1c]:002fa84c
[    5.156862]     [0x20]:10000000
[    5.156862]     [0x24]:00080020
[    5.156862]     [0x28]:0400001a
[    5.156862]     [0x2c]:00a500a0
[    5.156862]     [0x30]:0068000b
[    5.156863]     [0x34]:0020ffe0
[    5.156863]     [0x38]:008004c2
[    5.156863]     [0x3c]:000c0009
[    5.156864]     [0x40]:00000000
[    5.161033] igb 0000:04:00.0: eth0: PBA No: FFFFFF-0FF
[    5.161034] igb 0000:04:00.0: Using MSI-X interrupts. 2 rx queue(s),
2 tx queue(s)
[    5.327103] mpt3sas_cm0: CurrentHostPageSize(12)
[    5.327104] mpt3sas_cm0: hba queue depth(7168), max chains per io(128)
[    5.327104] mpt3sas_cm0: request frame size(128), reply frame size(128)
[    5.327105] mpt3sas_cm0: _base_make_ioc_ready
[    5.327106] mpt3sas_cm0: sending message unit reset !!
[    5.328620] mpt3sas_cm0: message unit reset: SUCCESS
[    5.346061] mpt3sas_cm0: _base_get_port_facts
[    5.347140]     offset:data
[    5.352599]     [0x00]:05070000
[    5.352599]     [0x04]:00000000
[    5.352599]     [0x08]:00000000
[    5.352599]     [0x0c]:00000000
[    5.352600]     [0x10]:00000000
[    5.352600]     [0x14]:00004000
[    5.352600]     [0x18]:000000d0
[    5.352601] mpt3sas_cm0: _base_allocate_memory_pools
[    5.352602] mpt3sas_cm0: scatter gather: sge_in_main_msg(1),
sge_per_chain(7), sge_per_io(128), chains_per_io(19)
[    5.352618] mpt3sas_cm0: reply post free pool (0x00000000cdcb398e):
depth(14624), element_size(8), pool_size(114 kB)
[    5.352618] mpt3sas_cm0: reply_post_free_dma = (0x37000000)
[    5.352628] mpt3sas_cm0: reply post free pool (0x000000004b6bfed4):
depth(14624), element_size(8), pool_size(114 kB)
[    5.352628] mpt3sas_cm0: reply_post_free_dma = (0x37020000)
[    5.352637] mpt3sas_cm0: reply post free pool (0x000000001107786e):
depth(14624), element_size(8), pool_size(114 kB)
[    5.352637] mpt3sas_cm0: reply_post_free_dma = (0x37040000)
[    5.352646] mpt3sas_cm0: reply post free pool (0x0000000012d2b9f4):
depth(14624), element_size(8), pool_size(114 kB)
[    5.402205] AVX2 version of gcm_enc/dec engaged.
[    5.404692] mpt3sas_cm0: reply_post_free_dma = (0x37060000)
[    5.404710] mpt3sas_cm0: reply post free pool (0x0000000017737356):
depth(14624), element_size(8), pool_size(114 kB)
[    5.409255] AES CTR mode by8 optimization enabled
[    5.414050] mpt3sas_cm0: reply_post_free_dma = (0x37080000)
[    5.414082] mpt3sas_cm0: reply post free pool (0x00000000dd3f2865):
depth(14624), element_size(8), pool_size(114 kB)
[    5.443513] mpt3sas_cm0: reply_post_free_dma = (0x370a0000)
[    5.443588] mpt3sas_cm0: reply post free pool (0x000000002bfd5b60):
depth(14624), element_size(8), pool_size(114 kB)
[    5.454665] mpt3sas_cm0: reply_post_free_dma = (0x370c0000)
[    5.454675] mpt3sas_cm0: reply post free pool (0x000000002e8da577):
depth(14624), element_size(8), pool_size(114 kB)
[    5.454675] mpt3sas_cm0: reply_post_free_dma = (0x370e0000)
[    5.454687] mpt3sas_cm0: reply post free pool (0x00000000e7607cbd):
depth(14624), element_size(8), pool_size(114 kB)
[    5.454687] mpt3sas_cm0: reply_post_free_dma = (0x37100000)
[    5.454697] mpt3sas_cm0: reply post free pool (0x0000000011329972):
depth(14624), element_size(8), pool_size(114 kB)
[    5.454698] mpt3sas_cm0: reply_post_free_dma = (0x37120000)
[    5.454706] mpt3sas_cm0: reply post free pool (0x0000000024d74442):
depth(14624), element_size(8), pool_size(114 kB)
[    5.454706] mpt3sas_cm0: reply_post_free_dma = (0x37140000)
[    5.454717] mpt3sas_cm0: reply post free pool (0x00000000698d12b2):
depth(14624), element_size(8), pool_size(114 kB)
[    5.521857] mpt3sas_cm0: reply_post_free_dma = (0x37160000)
[    5.522658] mpt3sas_cm0: reply post free pool (0x00000000f7953afc):
depth(14624), element_size(8), pool_size(114 kB)
[    5.537497] mpt3sas_cm0: reply_post_free_dma = (0x37180000)
[    5.537639] mpt3sas_cm0: reply post free pool (0x000000007029963f):
depth(14624), element_size(8), pool_size(114 kB)
[    5.553817] mpt3sas_cm0: reply_post_free_dma = (0x371a0000)
[    5.553829] mpt3sas_cm0: reply post free pool (0x00000000f91181a4):
depth(14624), element_size(8), pool_size(114 kB)
[    5.553829] mpt3sas_cm0: reply_post_free_dma = (0x371c0000)
[    5.553839] mpt3sas_cm0: reply post free pool (0x000000005564c259):
depth(14624), element_size(8), pool_size(114 kB)
[    5.553839] mpt3sas_cm0: reply_post_free_dma = (0x371e0000)
[    5.553849] mpt3sas_cm0: reply post free pool (0x0000000077580762):
depth(14624), element_size(8), pool_size(114 kB)
[    5.604422] mpt3sas_cm0: reply_post_free_dma = (0x37200000)
[    5.604440] mpt3sas_cm0: reply post free pool (0x00000000aec00108):
depth(14624), element_size(8), pool_size(114 kB)
[    5.622117] mpt3sas_cm0: reply_post_free_dma = (0x37220000)
[    5.622140] mpt3sas_cm0: reply post free pool (0x00000000631604ed):
depth(14624), element_size(8), pool_size(114 kB)
[    5.623698] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver
[    5.626792] sp5100-tco sp5100-tco: Using 0xfed80b00 for watchdog MMIO
address
[    5.626815] sp5100-tco sp5100-tco: Watchdog hardware is disabled
[    5.655184] bna 0000:03:00.3: bar0 mapped to 00000000b9471c1e, len 262144
[    5.659226] mpt3sas_cm0: reply_post_free_dma = (0x37240000)
[    5.659250] mpt3sas_cm0: reply post free pool (0x0000000040ebc661):
depth(14624), element_size(8), pool_size(114 kB)
[    5.698892] mpt3sas_cm0: reply_post_free_dma = (0x37260000)
[    5.698915] mpt3sas_cm0: reply post free pool (0x000000009e9e875e):
depth(14624), element_size(8), pool_size(114 kB)
[    5.719483] mpt3sas_cm0: reply_post_free_dma = (0x37280000)
[    5.719507] mpt3sas_cm0: reply post free pool (0x00000000f45748fa):
depth(14624), element_size(8), pool_size(114 kB)
[    5.740293] mpt3sas_cm0: reply_post_free_dma = (0x372a0000)
[    5.740304] mpt3sas_cm0: reply post free pool (0x0000000032cc2783):
depth(14624), element_size(8), pool_size(114 kB)
[    5.740304] mpt3sas_cm0: reply_post_free_dma = (0x372c0000)
[    5.740312] mpt3sas_cm0: reply post free pool (0x000000006cae9e7e):
depth(14624), element_size(8), pool_size(114 kB)
[    5.740312] mpt3sas_cm0: reply_post_free_dma = (0x372e0000)
[    5.740319] mpt3sas_cm0: reply post free pool (0x000000009b2ccf64):
depth(14624), element_size(8), pool_size(114 kB)
[    5.740320] mpt3sas_cm0: reply_post_free_dma = (0x37300000)
[    5.740329] mpt3sas_cm0: reply post free pool (0x000000002e7c9b13):
depth(14624), element_size(8), pool_size(114 kB)
[    5.740330] mpt3sas_cm0: reply_post_free_dma = (0x37320000)
[    5.740339] mpt3sas_cm0: reply post free pool (0x0000000035105e5d):
depth(14624), element_size(8), pool_size(114 kB)
[    5.740339] mpt3sas_cm0: reply_post_free_dma = (0x37340000)
[    5.740349] mpt3sas_cm0: reply post free pool (0x0000000054422f99):
depth(14624), element_size(8), pool_size(114 kB)
[    5.865609] mpt3sas_cm0: reply_post_free_dma = (0x37360000)
[    5.865622] mpt3sas_cm0: reply post free pool (0x00000000342e4838):
depth(14624), element_size(8), pool_size(114 kB)
[    5.886143] mpt3sas_cm0: reply_post_free_dma = (0x37380000)
[    5.886152] mpt3sas_cm0: reply post free pool (0x00000000f563f5eb):
depth(14624), element_size(8), pool_size(114 kB)
[    5.906710] mpt3sas_cm0: reply_post_free_dma = (0x373a0000)
[    5.906819] mpt3sas_cm0: reply post free pool (0x00000000c57b1467):
depth(14624), element_size(8), pool_size(114 kB)
[    5.916618] asus_wmi: ASUS WMI generic driver loaded
[    5.937610] mpt3sas_cm0: reply_post_free_dma = (0x373c0000)
[    5.937634] mpt3sas_cm0: reply post free pool (0x0000000017e60398):
depth(14624), element_size(8), pool_size(114 kB)
[    5.937636] mpt3sas_cm0: reply_post_free_dma = (0x373e0000)
[    5.953647] bna 0000:03:00.3 ethLAN: renamed from eth2
[    5.958258] mpt3sas_cm0: scsi host: can_queue depth (7056)
[    5.988885] mpt3sas_cm0: request pool(0x00000000cce824fb):
depth(7272), frame_size(128), pool_size(909 kB)
[    5.988887] mpt3sas_cm0: request pool: dma(0xfdb700000)
[    5.988889] mpt3sas_cm0: scsiio(0x00000000cce824fb): depth(7059)
[    6.039408] asus_wmi: Initialization: 0x0
[    6.039816] asus_wmi: BIOS WMI version: 0.9
[    6.039938] asus_wmi: SFUN value: 0x0
[    6.051568] bna 0000:03:00.2 ethEXT: renamed from eth1
[    6.054374] mpt3sas_cm0: hi_priority(0x00000000a62fd6ad): depth(104),
start smid(7060)
[    6.054434] mpt3sas_cm0: internal(0x00000000302cd915): depth(109),
start smid(7164)
[    6.059685] eeepc-wmi eeepc-wmi: Detected ASUSWMI, use DCTS
[    6.108311] [drm] radeon kernel modesetting enabled.
[    6.110790] input: Eee PC WMI hotkeys as
/devices/platform/eeepc-wmi/input/input12
[    6.119525] radeon 0000:05:00.0: remove_conflicting_pci_framebuffers:
bar 0: 0xd0000000 -> 0xdfffffff
[    6.136952] radeon 0000:05:00.0: remove_conflicting_pci_framebuffers:
bar 2: 0xfc930000 -> 0xfc93ffff
[    6.137226] checking generic (d0000000 300000) vs hw (d0000000 10000000)
[    6.146543] fb0: switching to radeondrmfb from EFI VGA
[    6.156167] Console: switching to colour dummy device 80x25
[    6.156205] radeon 0000:05:00.0: vgaarb: deactivate vga console
[    6.156362] [drm] initializing kernel modesetting (RV515
0x1002:0x7143 0x17AF:0x204E 0x00).
[    6.156410] ATOM BIOS: 113
[    6.156430] [drm] Generation 2 PCI interface, using max accessible memory
[    6.156435] radeon 0000:05:00.0: VRAM: 256M 0x0000000000000000 -
0x000000000FFFFFFF (256M used)
[    6.156437] radeon 0000:05:00.0: GTT: 512M 0x0000000010000000 -
0x000000002FFFFFFF
[    6.156443] [drm] Detected VRAM RAM=256M, BAR=256M
[    6.156444] [drm] RAM width 64bits DDR
[    6.156477] [TTM] Zone  kernel: Available graphics memory: 32888526 KiB
[    6.156478] [TTM] Zone   dma32: Available graphics memory: 2097152 KiB
[    6.156479] [TTM] Initializing pool allocator
[    6.156482] [TTM] Initializing DMA pool allocator
[    6.156493] [drm] radeon: 256M of VRAM memory ready
[    6.156494] [drm] radeon: 512M of GTT memory ready.
[    6.156498] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.156872] [drm] Possible lm63 thermal controller at 0x4c
[    6.156875] [drm] radeon: power management initialized
[    6.161827] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    6.164664] [drm] PCIE GART of 512M enabled (table at
0x0000000000040000).
[    6.164683] radeon 0000:05:00.0: WB enabled
[    6.164685] radeon 0000:05:00.0: fence driver on ring 0 use gpu addr
0x0000000010000000 and cpu addr 0x00000000f5b3c0a7
[    6.164687] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.164688] [drm] Driver supports precise vblank timestamp query.
[    6.164690] radeon 0000:05:00.0: radeon: MSI limited to 32-bit
[    6.164709] [drm] radeon: irq initialized.
[    6.164720] [drm] Loading R500 Microcode
[    6.165355] radeon 0000:05:00.0: firmware: direct-loading firmware
radeon/R520_cp.bin
[    6.165430] [drm] radeon: ring at 0x0000000010001000
[    6.165463] [drm] ring test succeeded in 3 usecs
[    6.165549] [drm] ib test succeeded in 0 usecs
[    6.165705] [drm] Radeon Display Connectors
[    6.165706] [drm] Connector 0:
[    6.165707] [drm]   DVI-I-1
[    6.165708] [drm]   HPD1
[    6.165709] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
0x7e4c 0x7e4c
[    6.165710] [drm]   Encoders:
[    6.165711] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    6.165712] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[    6.165713] [drm] Connector 1:
[    6.165714] [drm]   SVIDEO-1
[    6.165714] [drm]   Encoders:
[    6.165715] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    6.165716] [drm] Connector 2:
[    6.165717] [drm]   DVI-I-2
[    6.165717] [drm]   HPD2
[    6.165718] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58
0x7e5c 0x7e5c
[    6.165719] [drm]   Encoders:
[    6.165720] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    6.165721] [drm]     DFP3: INTERNAL_LVTM1
[    6.187719] XFS (sda4): Mounting V5 Filesystem
[    6.195323] mpt3sas_cm0: PCIe sgl pool depth(7059),
element_size(4096), pool_size(28236 kB)
[    6.195326] mpt3sas_cm0: Number of chains can fit in a PRP page(19)
[    6.195341] mpt3sas_cm0: chain pool depth(100000), frame_size(128),
pool_size(12500 kB)
[    6.195386] mpt3sas_cm0: sense pool(0x00000000c4abfc75): depth(7059),
element_size(96), pool_size(661 kB)
[    6.195388] mpt3sas_cm0: sense_dma(0xfd9300000)
[    6.195458] mpt3sas_cm0: reply pool(0x000000000028c386): depth(7336),
frame_size(128), pool_size(917 kB)
[    6.195460] mpt3sas_cm0: reply_dma(0xfd8800000)
[    6.195465] mpt3sas_cm0: reply_free pool(0x000000008685a731):
depth(7336), element_size(4), pool_size(28 kB)
[    6.195467] mpt3sas_cm0: reply_free_dma (0xfd9268000)
[    6.195470] mpt3sas_cm0: config page(0x00000000493eac7e): size(512)
[    6.195471] mpt3sas_cm0: config_page_dma(0xfdc8b5000)
[    6.195473] mpt3sas_cm0: Allocated physical memory: size(35291 kB)
[    6.195474] mpt3sas_cm0: Current Controller Queue Depth(7056),Max
Controller Queue Depth(7168)
[    6.195476] mpt3sas_cm0: Scatter Gather Elements per IO(128)
[    6.195485] mpt3sas_cm0: _base_make_ioc_operational
[    6.196384] mpt3sas_cm0: _base_send_ioc_init
[    6.196387]     offset:data
[    6.196388]     [0x00]:02000004
[    6.196389]     [0x04]:01000000
[    6.196390]     [0x08]:00000000
[    6.196391]     [0x0c]:36000206
[    6.196392]     [0x10]:00000000
[    6.196393]     [0x14]:200c0000
[    6.196394]     [0x18]:00200000
[    6.196395]     [0x1c]:1ca83920
[    6.196395]     [0x20]:0000000f
[    6.196396]     [0x24]:0000000f
[    6.196397]     [0x28]:db700000
[    6.196398]     [0x2c]:0000000f
[    6.196399]     [0x30]:dc04d000
[    6.196400]     [0x34]:0000000f
[    6.196401]     [0x38]:d9268000
[    6.196402]     [0x3c]:0000000f
[    6.196403]     [0x40]:b3fff292
[    6.196404]     [0x44]:00000174
[    6.201500] XFS (sda4): Ending clean mount
[    6.203188] xfs filesystem being mounted at /home supports timestamps
until 2038 (0x7fffffff)
[    6.264129]     offset:data
[    6.264134]     [0x00]:02050004
[    6.264136]     [0x04]:01000000
[    6.264137]     [0x08]:00000000
[    6.264139]     [0x0c]:00000000
[    6.264140]     [0x10]:00000000
[    6.264146] mpt3sas_cm0: _base_display_fwpkg_version
[    6.295156] kvm: disabled by bios
[    6.298104] EXT4-fs (sda1): mounting ext2 file system using the ext4
subsystem
[    6.302692] EXT4-fs (sda1): mounted filesystem without journal. Opts:
(null)
[    6.302697] ext2 filesystem being mounted at /boot supports
timestamps until 2038 (0x7fffffff)
[    6.343318] [drm] fb mappable at 0xD00C0000
[    6.343322] [drm] vram apper at 0xD0000000
[    6.343324] [drm] size 9216000
[    6.343326] [drm] fb depth is 24
[    6.343327] [drm]    pitch is 7680
[    6.343405] fbcon: radeondrmfb (fb0) is primary device
[    6.349395] mpt3sas_cm0: _base_display_fwpkg_version: complete
[    6.349397] mpt3sas_cm0: FW Package Version (16.00.00.00)
[    6.349648] mpt3sas_cm0: SAS3408: FWVersion(16.00.00.00),
ChipRevision(0x01), BiosVersion(09.31.00.00)
[    6.349648] NVMe
[    6.349649] mpt3sas_cm0: Protocol=(Initiator,Target),
Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
[    6.349680] mpt3sas_cm0: _base_event_notification
[    6.349693] mpt3sas_cm0: _base_event_notification: complete
[    6.349696] scsi host6: Fusion MPT SAS Host
[    6.350719] mpt3sas_cm0: sending port enable !!
[    6.350867] mpt3sas_cm0: Discovery: (start)
[    6.350872] mpt3sas_cm0: SAS Enclosure Device Status Change
[    6.350873] mpt3sas_cm0: SAS Topology Change List
[    6.350874] mpt3sas_cm0: SAS Enclosure Device Status Change
[    6.350878] mpt3sas_cm0: discovery event: (start)
[    6.350888] mpt3sas_cm0: SAS Topology Change List
[    6.350891] mpt3sas_cm0: SAS Topology Change List
[    6.350899] mpt3sas_cm0: Discovery: (stop)
[    6.350902] mpt3sas_cm0: Discovery: (start)
[    6.350905] mpt3sas_cm0: SAS Enclosure Device Status Change
[    6.350914] mpt3sas_cm0: SAS Topology Change List
[    6.350916] mpt3sas_cm0: SAS Topology Change List
[    6.350924] mpt3sas_cm0: Discovery: (stop)
[    6.352386] mpt3sas_cm0: host_add: handle(0x0001),
sas_addr(0x500605b00d4fecd0), phys(11)
[    6.352421] mpt3sas_cm0: enclosure status change: (enclosure add)
                   handle(0x0001), enclosure logical
id(0x300605b00d09ecd0) number slots(0)
[    6.352455] mpt3sas_cm0: sas topology change: (responding)
[    6.352456]     handle(0x0000), enclosure_handle(0x0001)
start_phy(00), count(8)
[    6.352457]     phy(00), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352458]     phy(01), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352459]     phy(02), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352460]     phy(03), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352461]     phy(04), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352461]     phy(05), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352462]     phy(06), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352463]     phy(07), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[    6.352464] mpt3sas_cm0: updating handles for
sas_host(0x500605b00d4fecd0)
[    6.353284] mpt3sas_cm0: enclosure status change: (enclosure add)
                   handle(0x0002), enclosure logical
id(0x500151b0000020bf) number slots(0)
[    6.353317] mpt3sas_cm0: sas topology change: (add)
[    6.353318]     handle(0x000d), enclosure_handle(0x0002)
start_phy(00), count(22)
[    6.353319]     phy(06), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[    6.353320]     phy(07), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[    6.353321]     phy(08), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[    6.353321]     phy(09), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[    6.353322]     phy(19), attached_handle(0x000e): target add: link
rate: new(0x0a), old(0x00)
[    6.353323] mpt3sas_cm0: updating handles for
sas_host(0x500605b00d4fecd0)
[    6.353684] mpt3sas_cm0: expander_add: handle(0x000d),
parent(0x0001), sas_addr(0x500151b0000020bf), phys(26)
[    6.356965] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x000e),
sas_addr(0x500151b0000020b3)
[    6.356967] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[    6.356968] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[    6.356969] mpt3sas_cm0: _scsih_determine_boot_device:
current_boot_device(0x500151b0000020b3)
[    6.356971] mpt3sas_cm0: sas topology change: (responding)
[    6.356972]     handle(0x000d), enclosure_handle(0x0002)
start_phy(22), count(4)
[    6.356973]     phy(24), attached_handle(0x000f): target add: link
rate: new(0x0a), old(0x00)
[    6.356974] mpt3sas_cm0: updating handles for
sas_host(0x500605b00d4fecd0)
[    6.357364] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x000f),
sas_addr(0x500151b0000020bd)
[    6.357365] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(0)
[    6.357366] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[    6.357367] mpt3sas_cm0: discovery event: (stop)
[    6.357368] mpt3sas_cm0: discovery event: (start)
[    6.357370] mpt3sas_cm0: enclosure status change: (enclosure add)
                   handle(0x0003), enclosure logical
id(0x500151b0000000bf) number slots(0)
[    6.357403] mpt3sas_cm0: sas topology change: (add)
[    6.357404]     handle(0x0010), enclosure_handle(0x0003)
start_phy(00), count(22)
[    6.357405]     phy(06), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[    6.357406]     phy(07), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[    6.357406]     phy(08), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[    6.357407]     phy(09), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[    6.357408]     phy(17), attached_handle(0x0011): target add: link
rate: new(0x0a), old(0x00)
[    6.357409]     phy(19), attached_handle(0x0012): target add: link
rate: new(0x0a), old(0x00)
[    6.357410] mpt3sas_cm0: updating handles for
sas_host(0x500605b00d4fecd0)
[    6.357777] mpt3sas_cm0: expander_add: handle(0x0010),
parent(0x0002), sas_addr(0x500151b0000000bf), phys(26)
[    6.360812] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x0011),
sas_addr(0x500151b0000000b1)
[    6.360813] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[    6.360813] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.360908] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x0012),
sas_addr(0x500151b0000000b3)
[    6.360908] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[    6.360908] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.360909] mpt3sas_cm0: sas topology change: (responding)
[    6.360910]     handle(0x0010), enclosure_handle(0x0003)
start_phy(22), count(4)
[    6.360911]     phy(23), attached_handle(0x0013): target add: link
rate: new(0x0a), old(0x00)
[    6.360911]     phy(24), attached_handle(0x0014): target add: link
rate: new(0x0a), old(0x00)
[    6.360912] mpt3sas_cm0: updating handles for
sas_host(0x500605b00d4fecd0)
[    6.361286] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x0013),
sas_addr(0x5000cca23bd2d159)
[    6.361286] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(17)
[    6.361287] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.361383] mpt3sas_cm0: _scsih_sas_device_init_add: handle(0x0014),
sas_addr(0x500151b0000000bd)
[    6.361383] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(0)
[    6.361383] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.361384] mpt3sas_cm0: discovery event: (stop)
[    6.361385] mpt3sas_cm0: port enable: complete from worker thread
[    6.368592] mpt3sas_cm0: port enable: SUCCESS
[    6.369778] scsi 6:0:0:0: Direct-Access     ATA      WDC WD5003AZEX-0
1A01 PQ: 0 ANSI: 6
[    6.369781] scsi 6:0:0:0: SATA: handle(0x000e),
sas_addr(0x500151b0000020b3), phy(19), device_name(0x50014ee20e11ea3d)
[    6.369782] scsi 6:0:0:0: enclosure logical id (0x500151b0000020bf),
slot(6)
[    6.369783] scsi 6:0:0:0: enclosure level(0x0000), connector name( C1  )
[    6.369824] scsi 6:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[    6.371558] scsi 6:0:1:0: Enclosure         Isilon   SEFC SAS2X24 E1 
0910 PQ: 0 ANSI: 5
[    6.371559] scsi 6:0:1:0: set ignore_delay_remove for handle(0x000f)
[    6.371561] scsi 6:0:1:0: SES: handle(0x000f),
sas_addr(0x500151b0000020bd), phy(24), device_name(0x500151b0000020bd)
[    6.371561] scsi 6:0:1:0: enclosure logical id (0x500151b0000020bf),
slot(0)
[    6.371562] scsi 6:0:1:0: enclosure level(0x0000), connector name( C1  )
[    6.371628] scsi 6:0:1:0: tag#967 CDB: Mode Sense(6) 1a 00 19 00 40 00
[    6.371628] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
[    6.371629] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(0)
[    6.371630] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[    6.371630] mpt3sas_cm0:     handle(0x000f), ioc_status(scsi data
underrun)(0x0045), smid(968)
[    6.371631] mpt3sas_cm0:     request_len(64), underflow(0), resid(64)
[    6.371632] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[    6.371632] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.371633] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x24,0x00],
count(96)
[    6.373779] scsi 6:0:2:0: Direct-Access     ATA      HGST HUH728080AL
T514 PQ: 0 ANSI: 6
[    6.373781] scsi 6:0:2:0: SATA: handle(0x0011),
sas_addr(0x500151b0000000b1), phy(17), device_name(0x5000cca23bc28407)
[    6.373782] scsi 6:0:2:0: enclosure logical id (0x500151b0000000bf),
slot(9)
[    6.373783] scsi 6:0:2:0: enclosure level(0x0000), connector name( C0  )
[    6.373820] scsi 6:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[    6.374965] scsi 6:0:3:0: Direct-Access     ATA      HGST HUH728080AL
T514 PQ: 0 ANSI: 6
[    6.374968] scsi 6:0:3:0: SATA: handle(0x0012),
sas_addr(0x500151b0000000b3), phy(19), device_name(0x5000cca23bc3bf5f)
[    6.374969] scsi 6:0:3:0: enclosure logical id (0x500151b0000000bf),
slot(5)
[    6.374970] scsi 6:0:3:0: enclosure level(0x0000), connector name( C0  )
[    6.375006] scsi 6:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[    6.375913] scsi 6:0:4:0: Direct-Access     HITACHI  HUH72808CLAR8000
M7K0 PQ: 0 ANSI: 6
[    6.375916] scsi 6:0:4:0: SSP: handle(0x0013),
sas_addr(0x5000cca23bd2d159), phy(23), device_name(0x5000cca23bd2d159)
[    6.375917] scsi 6:0:4:0: enclosure logical id (0x500151b0000000bf),
slot(17)
[    6.375918] scsi 6:0:4:0: enclosure level(0x0000), connector name( C0  )
[    6.378097] scsi 6:0:5:0: Enclosure         Isilon   SEFC SAS2X24 E0 
0910 PQ: 0 ANSI: 5
[    6.378099] scsi 6:0:5:0: set ignore_delay_remove for handle(0x0014)
[    6.378101] scsi 6:0:5:0: SES: handle(0x0014),
sas_addr(0x500151b0000000bd), phy(24), device_name(0x500151b0000000bd)
[    6.378102] scsi 6:0:5:0: enclosure logical id (0x500151b0000000bf),
slot(0)
[    6.378103] scsi 6:0:5:0: enclosure level(0x0000), connector name( C0  )
[    6.378167] scsi 6:0:5:0: tag#991 CDB: Mode Sense(6) 1a 00 19 00 40 00
[    6.378168] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
[    6.378169] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(0)
[    6.378169] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.378170] mpt3sas_cm0:     handle(0x0014), ioc_status(scsi data
underrun)(0x0045), smid(992)
[    6.378171] mpt3sas_cm0:     request_len(64), underflow(0), resid(64)
[    6.378172] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[    6.378172] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.378173] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x24,0x00],
count(96)
[    6.379844] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    6.379938] scsi 6:0:1:0: Attached scsi generic sg2 type 13
[    6.380038] sd 6:0:2:0: Attached scsi generic sg3 type 0
[    6.380142] sd 6:0:3:0: Attached scsi generic sg4 type 0
[    6.380235] sd 6:0:4:0: Attached scsi generic sg5 type 0
[    6.380322] scsi 6:0:5:0: Attached scsi generic sg6 type 13
[    6.381027] sd 6:0:4:0: [sde] 1953506646 4096-byte logical blocks:
(8.00 TB/7.28 TiB)
[    6.381164] sd 6:0:2:0: [sdc] 15628053168 512-byte logical blocks:
(8.00 TB/7.28 TiB)
[    6.381166] sd 6:0:2:0: [sdc] 4096-byte physical blocks
[    6.381194] sd 6:0:3:0: [sdd] 15628053168 512-byte logical blocks:
(8.00 TB/7.28 TiB)
[    6.381196] sd 6:0:3:0: [sdd] 4096-byte physical blocks
[    6.381685] sd 6:0:4:0: [sde] Write Protect is off
[    6.381687] sd 6:0:4:0: [sde] Mode Sense: cf 00 10 08
[    6.382137] sd 6:0:0:0: [sdb] 976773168 512-byte logical blocks: (500
GB/466 GiB)
[    6.382139] sd 6:0:0:0: [sdb] 4096-byte physical blocks
[    6.382900] sd 6:0:4:0: [sde] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[    6.384885] sd 6:0:3:0: [sdd] Write Protect is off
[    6.384887] sd 6:0:3:0: [sdd] Mode Sense: 9b 00 10 08
[    6.385051] sd 6:0:2:0: [sdc] Write Protect is off
[    6.385052] sd 6:0:2:0: [sdc] Mode Sense: 9b 00 10 08
[    6.385284] sd 6:0:3:0: [sdd] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    6.385338] sd 6:0:3:0: tag#3457 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[    6.385339] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[    6.385340] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[    6.385340] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.385341] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(3458)
[    6.385342] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[    6.385342] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[    6.385343] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.385344] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x20,0x00],
count(18)
[    6.385435] sd 6:0:2:0: [sdc] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    6.385483] sd 6:0:2:0: tag#4041 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[    6.385485] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[    6.385485] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[    6.385486] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.385487] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(4042)
[    6.385488] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[    6.385489] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[    6.385490] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.385491] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x20,0x00],
count(18)
[    6.385623] Console: switching to colour frame buffer device 240x75
[    6.386191] sd 6:0:0:0: [sdb] Write Protect is off
[    6.386193] sd 6:0:0:0: [sdb] Mode Sense: 9b 00 10 08
[    6.387481] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    6.387539] sd 6:0:0:0: tag#5961 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[    6.387540] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[    6.387541] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[    6.387542] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[    6.387543] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(5962)
[    6.387544] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[    6.387545] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[    6.387546] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.387546] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x05,0x20,0x00],
count(18)
[    6.457376] sd 6:0:2:0: [sdc] Attached SCSI disk
[    6.457720] sd 6:0:4:0: [sde] Attached SCSI disk
[    6.457803]  sdb: sdb1 sdb2 sdb3 sdb4 sdb5
[    6.462633] radeon 0000:05:00.0: fb0: radeondrmfb frame buffer device
[    6.466625] sd 6:0:0:0: [sdb] Attached SCSI disk
[    6.475603] sd 6:0:3:0: [sdd] Attached SCSI disk
[    6.606770] MCE: In-kernel MCE decoding enabled.
[    6.620678] [drm] Initialized radeon 2.50.0 20080528 for 0000:05:00.0
on minor 0
[    6.725704] kvm: disabled by bios
[    6.760580] sd 6:0:0:0: [sdb] tag#1537 CDB: ATA command pass
through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[    6.760949] sd 6:0:2:0: [sdc] tag#5965 CDB: ATA command pass
through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[    6.760951] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[    6.760952] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[    6.760952] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.760953] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(5966)
[    6.760954] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
[    6.760954] mpt3sas_cm0:     tag(0), transfer_count(512),
sc->result(0x00000002)
[    6.760955] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.760955] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    6.765713] sd 6:0:3:0: [sdd] tag#4738 CDB: ATA command pass
through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[    6.775192] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[    6.785384] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[    6.795612] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[    6.805855] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[    6.816282] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[    6.816284] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(1538)
[    6.826750] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    6.837240] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
[    6.837242] mpt3sas_cm0:     tag(0), transfer_count(512),
sc->result(0x00000002)
[    6.847773] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(4739)
[    6.858388] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.858389] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    6.869008] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
[    6.869010] mpt3sas_cm0:     tag(0), transfer_count(512),
sc->result(0x00000002)
[    6.948149] sd 6:0:2:0: [sdc] tag#996 CDB: ATA command pass
through(16) 85 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
[    6.958483] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    6.969822] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[    6.981029] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    6.992351] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[    7.122598] sd 6:0:3:0: [sdd] tag#5158 CDB: ATA command pass
through(16) 85 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
[    7.124083] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    7.136229] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[    7.148598] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(997)
[    7.161141] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[    7.174011] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[    7.174012] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[    7.186867] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    7.186869] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(5159)
[    7.199613] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    7.199615] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    7.212364] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[    7.212366] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[    8.704123] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    8.704124] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    8.704693] EDAC amd64: Node 0: DRAM ECC enabled.
[    8.742614] EDAC amd64: F17h_M70h detected (node 0).
[    8.742715] EDAC MC: UMC0 chip selects:
[    8.742716] EDAC amd64: MC: 0:  8192MB 1:  8192MB
[    8.742716] EDAC amd64: MC: 2:  8192MB 3:  8192MB
[    8.742720] EDAC MC: UMC1 chip selects:
[    8.742721] EDAC amd64: MC: 0:  8192MB 1:  8192MB
[    8.742725] EDAC amd64: MC: 2:  8192MB 3:  8192MB
[    8.742726] EDAC amd64: using x16 syndromes.
[    8.742736] EDAC amd64: MCT channel count: 2
[    8.742879] EDAC MC0: Giving out device to module amd64_edac
controller F17h_M70h: DEV 0000:00:18.3 (INTERRUPT)
[    8.742886] EDAC PCI0: Giving out device to module amd64_edac
controller EDAC PCI controller: DEV 0000:00:18.0 (POLLED)
[    8.742886] AMD64 EDAC driver v3.5.0
[    8.985993] FAT-fs (sda2): Volume was not properly unmounted. Some
data may be corrupt. Please run fsck.
[    9.032751] kvm: disabled by bios
[    9.053361] ses 6:0:1:0: Attached Enclosure device
[    9.053369] ses 6:0:5:0: Attached Enclosure device
[    9.053654] sd 6:0:0:0: [sdb] tag#1539 CDB: ATA command pass
through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[    9.053656] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[    9.053657] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[    9.053658] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[    9.053659] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(1540)
[    9.053660] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
[    9.053660] mpt3sas_cm0:     tag(0), transfer_count(512),
sc->result(0x00000002)
[    9.053661] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    9.053662] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    9.058928] sd 6:0:3:0: [sdd] tag#6314 CDB: ATA command pass
through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[    9.060775] sd 6:0:2:0: [sdc] tag#1432 CDB: ATA command pass
through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[    9.060778] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[    9.060779] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[    9.060779] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    9.060781] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(1433)
[    9.060781] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
[    9.060782] mpt3sas_cm0:     tag(0), transfer_count(512),
sc->result(0x00000002)
[    9.060783] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    9.060784] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    9.318037] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[    9.318038] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[    9.318038] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[    9.318039] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(6315)
[    9.318040] mpt3sas_cm0:     request_len(512), underflow(0), resid(0)
[    9.318041] mpt3sas_cm0:     tag(0), transfer_count(512),
sc->result(0x00000002)
[    9.318042] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[    9.318043] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[    9.467026] kvm: disabled by bios
[    9.554544] kvm: disabled by bios
[    9.562190] audit: type=1400 audit(1600747732.918:2):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="nvidia_modprobe" pid=735 comm="apparmor_parser"
[    9.580892] audit: type=1400 audit(1600747732.918:3):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="nvidia_modprobe//kmod" pid=735 comm="apparmor_parser"
[    9.593763] audit: type=1400 audit(1600747732.922:4):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="/usr/bin/man" pid=736 comm="apparmor_parser"
[    9.593766] audit: type=1400 audit(1600747732.922:5):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="man_filter" pid=736 comm="apparmor_parser"
[    9.619330] audit: type=1400 audit(1600747732.922:6):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="man_groff" pid=736 comm="apparmor_parser"
[    9.619331] audit: type=1400 audit(1600747732.926:7):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="/usr/sbin/ntpd" pid=737 comm="apparmor_parser"
[    9.666231] kvm: disabled by bios
[    9.738369] kvm: disabled by bios
[    9.831673] kvm: disabled by bios
[    9.898274] kvm: disabled by bios
[    9.990058] kvm: disabled by bios
[   10.058212] kvm: disabled by bios
[   10.099903] sd 6:0:0:0: [sdb] tag#5131 CDB: ATA command pass
through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
[   10.099911] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   10.099912] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[   10.099913] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[   10.099914] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(5132)
[   10.099915] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.099916] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.099917] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.099917] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.108222] sd 6:0:0:0: [sdb] tag#5137 CDB: ATA command pass
through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
[   10.224490] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   10.224491] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[   10.224491] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[   10.224492] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(5138)
[   10.224493] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.224494] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.224495] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.224495] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.234180] sd 6:0:2:0: [sdc] tag#4548 CDB: ATA command pass
through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
[   10.332406] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   10.332407] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[   10.332407] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   10.332408] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(4549)
[   10.332408] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.332409] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.332409] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.332410] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.339045] sd 6:0:2:0: [sdc] tag#5975 CDB: ATA command pass
through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
[   10.442269] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   10.442269] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[   10.442270] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   10.442270] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(5976)
[   10.442270] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.442271] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.442271] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.442272] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.449918] sd 6:0:3:0: [sdd] tag#5979 CDB: ATA command pass
through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
[   10.553598] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   10.553599] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[   10.553599] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   10.553600] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(5980)
[   10.553600] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.553600] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.553601] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.553601] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.553665] kvm: disabled by bios
[   10.560455] sd 6:0:3:0: [sdd] tag#4554 CDB: ATA command pass
through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
[   10.560457] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   10.560458] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[   10.560459] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   10.560460] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(4555)
[   10.560460] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.560461] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.560462] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.560463] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.573857] sd 6:0:0:0: [sdb] tag#5997 CDB: ATA command pass
through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
[   10.795108] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   10.795109] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[   10.795110] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[   10.795111] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(5998)
[   10.795112] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.795112] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.795113] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.795114] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.841518] sd 6:0:0:0: [sdb] tag#2626 CDB: ATA command pass
through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
[   10.915837] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   10.915838] mpt3sas_cm0: enclosure logical id(0x500151b0000020bf),
slot(6)
[   10.915839] mpt3sas_cm0: enclosure level(0x0000), connector name( C1  )
[   10.915840] mpt3sas_cm0:     handle(0x000e),
ioc_status(success)(0x0000), smid(2627)
[   10.915841] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   10.983565] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   10.983566] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   10.983567] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   10.988180] sd 6:0:2:0: [sdc] tag#6001 CDB: ATA command pass
through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
[   11.038642] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   11.038643] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[   11.038644] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   11.038645] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(6002)
[   11.038646] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   11.107415] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   11.107416] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   11.107417] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   11.108070] sd 6:0:2:0: [sdc] tag#2627 CDB: ATA command pass
through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
[   11.162864] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   11.162865] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(9)
[   11.162865] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   11.162866] mpt3sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(2628)
[   11.162866] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   11.162866] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   11.162867] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   11.162867] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   11.168338] sd 6:0:3:0: [sdd] tag#2631 CDB: ATA command pass
through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
[   11.287080] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   11.287080] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[   11.287080] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   11.287081] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(2632)
[   11.287081] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   11.287081] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   11.287082] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   11.287082] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   11.287843] sd 6:0:3:0: [sdd] tag#6002 CDB: ATA command pass
through(16) 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
[   11.411238] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   11.411239] mpt3sas_cm0: enclosure logical id(0x500151b0000000bf),
slot(5)
[   11.411240] mpt3sas_cm0: enclosure level(0x0000), connector name( C0  )
[   11.411241] mpt3sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(6003)
[   11.411242] mpt3sas_cm0:     request_len(0), underflow(0), resid(0)
[   11.411242] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[   11.411243] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[   11.411244] mpt3sas_cm0:     [sense_key,asc,ascq]: [0x01,0x00,0x1d],
count(22)
[   11.411392] kvm: disabled by bios
[   11.574730] kvm: disabled by bios
[   11.631134] kvm: disabled by bios
[   11.633338] bna 0000:03:00.3 ethLAN: link up
[   11.633695] IPv6: ADDRCONF(NETDEV_CHANGE): ethLAN: link becomes ready
[   11.723175] kvm: disabled by bios
[   14.109181] mpt3sas_cm0: _ctl_getiocinfo: enter
[   14.109208] mpt3sas_cm0: ctl_request: ioc_facts, smid(7057)
[   14.109251] mpt3sas_cm0: ctl_done: ioc_facts, smid(7057)
[   14.109402] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109443] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109465] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109498] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109530] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109546] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109554] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109573] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109581] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109596] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109604] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109622] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109630] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109643] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109651] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109668] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109676] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109689] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109722] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109749] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109789] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109813] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109821] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109838] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109846] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109859] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109867] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109884] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109892] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109905] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109913] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109930] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109937] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109950] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109983] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.109999] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110018] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110031] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110039] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110055] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110077] mpt3sas_cm0: _ctl_btdh_mapping
[   14.110096] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110122] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110143] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110160] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.110203] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.110667] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.110668] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.110669] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   14.110670] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000020bf), slot(6)
[   14.110711] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.111142] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.111142] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.111143] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   14.111144] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000020bf), slot(6)
[   14.111153] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
cdb_len(10), smid(7057)
[   14.111208] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
smid(7057)
[   14.111217] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.111631] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.111632] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.111633] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   14.111633] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000020bf), slot(6)
[   14.111658] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.112076] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.112077] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.112077] mpt3sas_cm0:     sas_address(0x500151b0000020b3), phy(19)
[   14.112078] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000020bf), slot(6)
[   14.112124] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112141] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112158] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112179] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112185] mpt3sas_cm0: _ctl_btdh_mapping
[   14.112194] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112208] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112251] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112279] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112289] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.112434] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.112435] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.112436] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
[   14.112436] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000020bf), slot(0)
[   14.112445] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.112529] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.112530] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.112530] mpt3sas_cm0:     sas_address(0x500151b0000020bd), phy(24)
[   14.112531] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000020bf), slot(0)
[   14.112685] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112700] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112785] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112803] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112815] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112829] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112870] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112897] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112927] mpt3sas_cm0: _ctl_btdh_mapping
[   14.112943] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112965] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112973] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.112990] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.113001] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.113199] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.113200] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.113200] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   14.113201] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(9)
[   14.113216] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.113383] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.113384] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.113385] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   14.113385] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(9)
[   14.113397] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
cdb_len(10), smid(7057)
[   14.113453] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
smid(7057)
[   14.113470] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x9e), cdb_len(0),
smid(7057)
[   14.113637] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x9e), cdb_len(0),
smid(7057)
[   14.113669] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.113845] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.113846] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.113847] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   14.113847] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(9)
[   14.113856] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.114009] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.114010] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.114010] mpt3sas_cm0:     sas_address(0x500151b0000000b1), phy(17)
[   14.114011] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(9)
[   14.114032] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114046] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114065] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114083] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114112] mpt3sas_cm0: _ctl_btdh_mapping
[   14.114129] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114154] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114170] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114187] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.114229] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.114429] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.114431] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.114432] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   14.114432] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(5)
[   14.114473] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.114658] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.114659] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.114660] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   14.114660] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(5)
[   14.114678] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
cdb_len(10), smid(7057)
[   14.114743] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
smid(7057)
[   14.114753] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x9e), cdb_len(0),
smid(7057)
[   14.114909] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x9e), cdb_len(0),
smid(7057)
[   14.114924] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115091] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115092] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.115093] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   14.115093] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(5)
[   14.115116] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115271] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115272] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.115272] mpt3sas_cm0:     sas_address(0x500151b0000000b3), phy(19)
[   14.115273] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(5)
[   14.115318] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115340] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115347] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115374] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115383] mpt3sas_cm0: _ctl_btdh_mapping
[   14.115388] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115407] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115449] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115478] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.115490] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115610] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115611] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.115612] mpt3sas_cm0:     sas_address(0x5000cca23bd2d159), phy(23)
[   14.115612] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(17)
[   14.115621] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115725] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.115725] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.115726] mpt3sas_cm0:     sas_address(0x5000cca23bd2d159), phy(23)
[   14.115727] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(17)
[   14.115747] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x25),
cdb_len(10), smid(7057)
[   14.116354] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x25), cdb_len(10),
smid(7057)
[   14.116363] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.116472] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.116473] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.116473] mpt3sas_cm0:     sas_address(0x5000cca23bd2d159), phy(23)
[   14.116474] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(17)
[   14.116483] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.116587] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.116589] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.116590] mpt3sas_cm0:     sas_address(0x5000cca23bd2d159), phy(23)
[   14.116592] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(17)
[   14.116610] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116624] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116635] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116653] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116662] mpt3sas_cm0: _ctl_btdh_mapping
[   14.116682] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116707] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116754] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116774] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.116783] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.116927] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.116927] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.116928] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
[   14.116928] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(0)
[   14.116935] mpt3sas_cm0: ctl_request: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.117018] mpt3sas_cm0: ctl_done: scsi_io, cmd(0x12), cdb_len(6),
smid(7057)
[   14.117018] mpt3sas_cm0:     iocstatus(0x0045), loginfo(0x00000000)
[   14.117019] mpt3sas_cm0:     sas_address(0x500151b0000000bd), phy(24)
[   14.117019] mpt3sas_cm0:    
enclosure_logical_id(0x500151b0000000bf), slot(0)
[   14.117025] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.117039] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.117044] mpt3sas_cm0: ctl_request: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.117070] mpt3sas_cm0: ctl_done: config, type(0x0f),
ext_type(0x12), number(0), smid(7057)
[   14.117071] mpt3sas_cm0:     iocstatus(0x0022), loginfo(0x310f0400)
[   14.117112] mpt3sas_cm0: ctl_request: fw_upload, smid(7057)
[   14.117135] mpt3sas_cm0: ctl_done: fw_upload, smid(7057)
[   14.117203] mpt3sas_cm0: ctl_request: fw_upload, smid(7057)
[   14.117225] mpt3sas_cm0: ctl_done: fw_upload, smid(7057)
[   14.117249] mpt3sas_cm0: ctl_request: fw_upload, smid(7057)
[   75.001325] mpt3sas_cm0: Command Timeout
[   75.012610] mf:
                  
[   75.012610] 12000002
[   75.034857] 00000000
[   75.045753] 00000000
[   75.045754] 00000000
[   75.045754] 00000000
[   75.045755] 000c0000
[   75.045755] 00000000
[   75.045756] 00010000
[   75.045756]
                  
[   75.045757] 00010000

[   75.045759] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: enter
[   75.045941] mpt3sas_cm0: mpt3sas_scsih_pre_reset_handler:
MPT3_IOC_PRE_RESET
[   75.045942] mpt3sas_cm0: mpt3sas_ctl_pre_reset_handler:
MPT3_IOC_PRE_RESET
[   75.045944] mpt3sas_cm0: _base_pre_reset_handler: MPT3_IOC_PRE_RESET
[   75.045948] mpt3sas_cm0: _base_make_ioc_ready
[   75.045949] mpt3sas_cm0: sending diag reset !!
[   75.733705] mpt3sas_cm0: diag reset: SUCCESS
[   75.741271] mpt3sas_cm0: mpt3sas_scsih_after_reset_handler:
MPT3_IOC_AFTER_RESET
[   75.749234] mpt3sas_cm0: completing 0 cmds
[   75.749235] mpt3sas_cm0: mpt3sas_ctl_after_reset_handler:
MPT3_IOC_AFTER_RESET
[   75.749236] mpt3sas_cm0: _base_after_reset_handler: MPT3_IOC_AFTER_RESET
[   75.773049] mpt3sas_cm0: _base_get_ioc_facts
[   75.773050] mpt3sas_cm0: _base_wait_for_iocstate
[   76.012061]     offset:data
[   76.019791]     [0x00]:03110206
[   76.027535]     [0x04]:00003900
[   76.035150]     [0x08]:00000000
[   76.035150]     [0x0c]:00000000
[   76.035151]     [0x10]:00000000
[   76.035151]     [0x14]:80010080
[   76.035152]     [0x18]:22311c00
[   76.035152]     [0x1c]:002fa84c
[   76.035152]     [0x20]:10000000
[   76.035153]     [0x24]:00080020
[   76.035153]     [0x28]:0400001a
[   76.035154]     [0x2c]:00a500a0
[   76.035154]     [0x30]:0068000b
[   76.035155]     [0x34]:0020ffe0
[   76.035155]     [0x38]:008004c2
[   76.035155]     [0x3c]:00000009
[   76.035156]     [0x40]:00000000
[   76.035157] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default
host page size to 4k
[   76.035157] mpt3sas_cm0: CurrentHostPageSize(0)
[   76.035158] mpt3sas_cm0: hba queue depth(7168), max chains per io(128)
[   76.035159] mpt3sas_cm0: request frame size(128), reply frame size(128)
[   76.035160] mpt3sas_cm0: _base_make_ioc_operational
[   76.036251] mpt3sas_cm0: _base_send_ioc_init
[   76.186167]     offset:data
[   76.186168]     [0x00]:02000004
[   76.186168]     [0x04]:01000000
[   76.186169]     [0x08]:00000000
[   76.186169]     [0x0c]:36000206
[   76.186170]     [0x10]:00000000
[   76.186170]     [0x14]:200c0000
[   76.186170]     [0x18]:00200000
[   76.186171]     [0x1c]:1ca83920
[   76.246290]     [0x20]:0000000f
[   76.246290]     [0x24]:0000000f
[   76.246291]     [0x28]:db700000
[   76.246291]     [0x2c]:0000000f
[   76.246292]     [0x30]:dc04d000
[   76.246292]     [0x34]:0000000f
[   76.246292]     [0x38]:d9268000
[   76.246293]     [0x3c]:0000000f
[   76.246293]     [0x40]:b4010411
[   76.246293]     [0x44]:00000174
[   76.275429]     offset:data
[   76.316228]     [0x00]:02050004
[   76.316228]     [0x04]:01000000
[   76.316228]     [0x08]:00000000
[   76.316229]     [0x0c]:00000000
[   76.316229]     [0x10]:00000000
[   76.316233] mpt3sas_cm0: _base_display_fwpkg_version
[   76.401952] mpt3sas_cm0: _base_display_fwpkg_version: complete
[   76.401954] mpt3sas_cm0: FW Package Version (16.00.00.00)
[   76.416039] mpt3sas_cm0: SAS3408: FWVersion(16.00.00.00),
ChipRevision(0x01), BiosVersion(09.31.00.00)
[   76.416039] NVMe
[   76.416039] mpt3sas_cm0: Protocol=(Initiator,Target),
Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
[   76.416069] mpt3sas_cm0: _base_event_notification
[   76.416183] mpt3sas_cm0: _base_event_notification: complete
[   76.416183] mpt3sas_cm0: sending port enable !!
[   78.055378] mpt3sas_cm0: Discovery: (start)
[   78.061604] mpt3sas_cm0: SAS Enclosure Device Status Change
[   78.061608] mpt3sas_cm0: discovery event: (start)
[   78.068018] mpt3sas_cm0: SAS Topology Change List
[   78.068020] mpt3sas_cm0: SAS Enclosure Device Status Change
[   78.068022] mpt3sas_cm0: SAS Topology Change List
[   78.074484] mpt3sas_cm0: enclosure status change: (enclosure add)
                   handle(0x0001), enclosure logical
id(0x300605b00d09ecd0) number slots(0)
[   78.080718] mpt3sas_cm0: SAS Topology Change List
[   78.113802] mpt3sas_cm0: sas topology change: (responding)
[   78.113803]     handle(0x0000), enclosure_handle(0x0001)
start_phy(00), count(7)
[   78.113804]     phy(00), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113805]     phy(02), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113805]     phy(04), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113806]     phy(06), attached_handle(0x000d): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113808] mpt3sas_cm0: enclosure status change: (enclosure add)
                   handle(0x0002), enclosure logical
id(0x500151b0000020bf) number slots(0)
[   78.113808] mpt3sas_cm0: sas topology change: (add)
[   78.113809]     handle(0x000d), enclosure_handle(0x0002)
start_phy(00), count(22)
[   78.113810]     phy(06), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113811]     phy(07), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113812]     phy(08), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113813]     phy(09), attached_handle(0x0001): link rate change:
link rate: new(0x0a), old(0x00)
[   78.113814]     phy(19), attached_handle(0x000e): target add: link
rate: new(0x0a), old(0x00)
[   78.113815] mpt3sas_cm0: sas topology change: (responding)
[   78.113815]     handle(0x000d), enclosure_handle(0x0002)
start_phy(22), count(4)
[   78.113816]     phy(24), attached_handle(0x000f): target add: link
rate: new(0x0a), old(0x00)
[   78.305406] mpt3sas_cm0: Discovery: (start)
[   78.305427] mpt3sas_cm0: discovery event: (start)
[   78.305464] mpt3sas_cm0: SAS Topology Change List
[   78.305507] mpt3sas_cm0: sas topology change: (responding)
[   78.305508]     handle(0x0000), enclosure_handle(0x0001)
start_phy(01), count(7)
[   78.305509]     phy(01), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[   78.305511]     phy(02), attached_handle(0x000d): target responding:
link rate: new(0x0a), old(0x00)
[   78.305511]     phy(03), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[   78.305512]     phy(04), attached_handle(0x000d): target responding:
link rate: new(0x0a), old(0x00)
[   78.305514]     phy(05), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[   78.305515]     phy(06), attached_handle(0x000d): target responding:
link rate: new(0x0a), old(0x00)
[   78.305515]     phy(07), attached_handle(0x0010): link rate change:
link rate: new(0x0a), old(0x00)
[   78.306734] mpt3sas_cm0: SAS Topology Change List
[   78.306739] mpt3sas_cm0: sas topology change: (responding)
[   78.306740]     handle(0x000d), enclosure_handle(0x0002)
start_phy(19), count(1)
[   78.306741]     phy(19), attached_handle(0x000e): link rate change:
link rate: new(0x0a), old(0x0a)
[   78.307010] mpt3sas_cm0: SAS Enclosure Device Status Change
[   78.307011] mpt3sas_cm0: SAS Topology Change List
[   78.307015] mpt3sas_cm0: enclosure status change: (enclosure add)
                   handle(0x0003), enclosure logical
id(0x500151b0000000bf) number slots(0)
[   78.307015] mpt3sas_cm0: sas topology change: (add)
[   78.307016]     handle(0x0010), enclosure_handle(0x0003)
start_phy(00), count(22)
[   78.307017]     phy(06), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[   78.307018]     phy(07), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[   78.307018]     phy(08), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[   78.307019]     phy(09), attached_handle(0x0002): link rate change:
link rate: new(0x0a), old(0x00)
[   78.307020]     phy(17), attached_handle(0x0011): target add: link
rate: new(0x0a), old(0x00)
[   78.307021]     phy(19), attached_handle(0x0012): target add: link
rate: new(0x0a), old(0x00)
[   78.307051] mpt3sas_cm0: SAS Topology Change List
[   78.307081] mpt3sas_cm0: sas topology change: (responding)
[   78.307094]     handle(0x0010), enclosure_handle(0x0003)
start_phy(22), count(4)
[   78.307095]     phy(23), attached_handle(0x0013): target add: link
rate: new(0x0a), old(0x00)
[   78.307096]     phy(24), attached_handle(0x0014): target add: link
rate: new(0x0a), old(0x00)
[   78.555785] mpt3sas_cm0: Discovery: (stop)
[   78.649450] mpt3sas_cm0: SAS Topology Change List
[   78.649453] mpt3sas_cm0: discovery event: (stop)
[   78.649455] mpt3sas_cm0: sas topology change: (responding)
[   78.649456]     handle(0x0010), enclosure_handle(0x0003)
start_phy(17), count(3)
[   78.649457]     phy(17), attached_handle(0x0011): link rate change:
link rate: new(0x0a), old(0x0a)
[   78.649458]     phy(19), attached_handle(0x0012): link rate change:
link rate: new(0x0a), old(0x0a)
[   78.805767] mpt3sas_cm0: Discovery: (stop)
[   78.805774] mpt3sas_cm0: discovery event: (stop)
[   83.805414] mpt3sas_cm0: port enable: SUCCESS
[   83.815936] mpt3sas_cm0: mpt3sas_scsih_reset_done_handler:
MPT3_IOC_DONE_RESET
[   83.826979] mpt3sas_cm0: search for end-devices: start
[   83.827681] scsi target6:0:0: handle(0x000e),
sas_addr(0x500151b0000020b3)
[   83.827682] scsi target6:0:0: enclosure logical
id(0x500151b0000020bf), slot(6)
[   83.827725] scsi target6:0:1: handle(0x000f),
sas_addr(0x500151b0000020bd)
[   83.827725] scsi target6:0:1: enclosure logical
id(0x500151b0000020bf), slot(0)
[   83.827897] scsi target6:0:2: handle(0x0011),
sas_addr(0x500151b0000000b1)
[   83.827897] scsi target6:0:2: enclosure logical
id(0x500151b0000000bf), slot(9)
[   83.827957] scsi target6:0:3: handle(0x0012),
sas_addr(0x500151b0000000b3)
[   83.827958] scsi target6:0:3: enclosure logical
id(0x500151b0000000bf), slot(5)
[   83.828002] scsi target6:0:4: handle(0x0013),
sas_addr(0x5000cca23bd2d159)
[   83.828002] scsi target6:0:4: enclosure logical
id(0x500151b0000000bf), slot(17)
[   83.828053] scsi target6:0:5: handle(0x0014),
sas_addr(0x500151b0000000bd)
[   83.828053] scsi target6:0:5: enclosure logical
id(0x500151b0000000bf), slot(0)
[   83.828099] mpt3sas_cm0: search for end-devices: complete
[   83.828099] mpt3sas_cm0: search for end-devices: start
[   83.828100] mpt3sas_cm0: search for PCIe end-devices: complete
[   83.828100] mpt3sas_cm0: search for expanders: start
[   83.828131]     expander present: handle(0x000d),
sas_addr(0x500151b0000020bf)
[   83.828214]     expander present: handle(0x0010),
sas_addr(0x500151b0000000bf)
[   83.828309] mpt3sas_cm0: search for expanders: complete
[   83.828416] mpt3sas_cm0: mpt3sas_ctl_reset_done_handler:
MPT3_IOC_DONE_RESET
[   83.828416] mpt3sas_cm0: _base_reset_done_handler: MPT3_IOC_DONE_RESET
[   83.828416] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: SUCCESS
[   83.828417] mpt3sas_cm0: mpt3sas_base_hard_reset_handler: exit
[   83.828422] mpt3sas_cm0: removing unresponding devices: start
[   83.828422] mpt3sas_cm0: removing unresponding devices: end-devices
[   83.828423] mpt3sas_cm0: Removing unresponding devices: pcie end-devices
[   83.828423] mpt3sas_cm0: removing unresponding devices: expanders
[   83.828424] mpt3sas_cm0: removing unresponding devices: complete
[   83.828426] mpt3sas_cm0: scan devices: start
[   83.828427] mpt3sas_cm0: updating handles for
sas_host(0x500605b00d4fecd0)
[   83.828991] mpt3sas_cm0:     scan devices: expanders start
[   83.832699] mpt3sas_cm0:     break from expander scan:
ioc_status(0x0022), loginfo(0x310f0400)
[   83.832700] mpt3sas_cm0:     scan devices: expanders complete
[   83.832700] mpt3sas_cm0:     scan devices: end devices start
[   83.833728] mpt3sas_cm0:     break from end device scan:
ioc_status(0x0022), loginfo(0x310f0400)
[   83.833728] mpt3sas_cm0:     scan devices: end devices complete
[   83.833728] mpt3sas_cm0:     scan devices: pcie end devices start
[   83.833780] mpt3sas_cm0:     break from pcie end device scan:
ioc_status(0x0022), loginfo(0x310f0400)
[   83.833781] mpt3sas_cm0:     pcie devices: pcie end devices complete
[   83.833782] mpt3sas_cm0: scan devices: complete

