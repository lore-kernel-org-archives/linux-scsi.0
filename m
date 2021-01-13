Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE83AC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 15:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F4A6208BA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 15:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbhAMPla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:41:30 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2334 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbhAMPla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 10:41:30 -0500
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DGBN93GvVz67Xft;
        Wed, 13 Jan 2021 23:35:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 13 Jan 2021 16:40:29 +0100
Received: from [10.47.0.70] (10.47.0.70) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 13 Jan
 2021 15:40:26 +0000
Subject: Re: About scsi device queue depth
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <20210112014203.GA60605@T590>
 <4b50f067-a368-2197-c331-a8c981f5cd02@huawei.com>
 <20210112090634.GA97446@T590>
 <e5832d8b-383c-9734-85a1-6f36bdb5a773@huawei.com>
 <7a342a60943cd7ed28d319b189c105ba@mail.gmail.com>
 <16a66e96-a08f-78d1-155a-41bb5d31f2d1@huawei.com>
 <0cd4b8de66fc7d7140a9c73d8e26327d@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <dd8e6fdc-397d-b6ad-3371-0b65d1932ad1@huawei.com>
Date:   Wed, 13 Jan 2021 15:39:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0cd4b8de66fc7d7140a9c73d8e26327d@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.70]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/2021 13:34, Kashyap Desai wrote:
>> Hi Kashyap,
>>
>> As requested:
>>
>> rq_affinity=1, nomerges=0 (default)
>>
>> sdev queue depth	num jobs=1
>> 8			1650
>> 16			1638
>> 32			1612
>> 64			1573
>> 254			1435 (default for LLDD)
>>
>> rq_affinity=2, nomerges=2
>>
>> sdev queue depth	num jobs=1
>> 8			1236
>> 16			1423
>> 32			1438
>> 64			1438
>> 254			1438 (default for LLDD)
>>
>> Setup as original: fio read, 12x SAS SSDs
> What is an issue with rq_affinity=2 and nomerges=2 ?
> It looks like - "Dropping IOPs from peak (1.6M) is not an issue here but we
> are not able to reach peak IOPs. IOPS increase gradually and it saturate."
> 
>> So, again, we see that performance changes from changing sdev queue depth
>> depends on workload and then also other queue config.
> Can you send me "dmesg" logs of your setup. What is host_busy counter while
> you run your test ? I am not able to duplicate the issue on my setup.
> 
> To avoid any io merge issue, can we use rand_read data ?
> 

For randread:

rq_affinity=1, nomerges=0 (default)
fio queue depth 128
sdev qdepth   		num jobs=1
8			1300K
16			1435K
32			1438K
64			1438K
254 (default)		1439K

rq_affinity=2, nomerges=2
sdev queue depth	num jobs=1
8			1313
16			1438
32			1438
64			1438
254 (default)		1438


dmesg (I realize that the list may block this mail due to size):

estuary:/$ dmesg
[    0.000000] Booting Linux on physical CPU 0x0000080000 [0x481fd010]
[    0.000000] Linux version 5.11.0-rc3-g23cafd1b97c8 
(john@Turing-Arch-b) (aarch64-linux-gnu-gcc (GNU Toolchain for the 
A-profile Architecture 8.3-2019.03 (arm-rel-8.36)) 8.3.0, GNU ld (GNU 
Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36)) 
2.32.0.20190321) #382 SMP PREEMPT Wed Jan 13 22:31:37 CST 2021
[    0.000000] earlycon: pl11 at MMIO32 0x00000000602b0000 (options '')
[    0.000000] printk: bootconsole [pl11] enabled
[    0.000000] efi: EFI v2.70 by EDK II
[    0.000000] efi: ACPI 2.0=0x39dd0000 SMBIOS 3.0=0x3f0d0000 
MEMATTR=0x3c5e8018 ESRT=0x3e372f18 RNG=0x3f0fbd18 MEMRESERVE=0x3a0e3e98
[    0.000000] efi: seeding entropy pool
[    0.000000] esrt: Reserving ESRT space from 0x000000003e372f18 to 
0x000000003e372f50.
[    0.000000] cma: Reserved 32 MiB at 0x000000007e000000
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x0000000039DD0000 000024 (v02 HISI  )
[    0.000000] ACPI: XSDT 0x0000000039DC0000 0000B4 (v01 HISI   HIP08 
00000000      01000013)
[    0.000000] ACPI: FACP 0x0000000039910000 000114 (v06 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: DSDT 0x0000000039620000 012F04 (v02 HISI   HIP08 
00000000 INTL 20181213)
[    0.000000] ACPI: PCCT 0x0000000039DB0000 00008A (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: SSDT 0x0000000039DA0000 00F1E8 (v02 HISI   HIP07 
00000000 INTL 20181213)
[    0.000000] ACPI: BERT 0x0000000039D70000 000030 (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: HEST 0x0000000039D50000 00058C (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: ERST 0x0000000039D10000 000230 (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: EINJ 0x0000000039D00000 000170 (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: GTDT 0x0000000039690000 000084 (v03 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: MCFG 0x0000000039680000 00003C (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: SLIT 0x0000000039670000 00003C (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: SPCR 0x0000000039660000 000050 (v02 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: SRAT 0x0000000039650000 0009C0 (v03 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: APIC 0x0000000039640000 00286C (v04 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: IORT 0x0000000039610000 0016F0 (v00 HISI   HIP08 
00000000 INTL 20181213)
[    0.000000] ACPI: PPTT 0x0000000030B20000 0037E4 (v02 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: MPAM 0x0000000030B10000 00077C (v01 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: SPMI 0x0000000030B00000 000041 (v05 HISI   HIP08 
00000000 HISI 20151124)
[    0.000000] ACPI: iBFT 0x00000000312D0000 000800 (v01 HISI   HIP08 
00000000      00000000)
[    0.000000] ACPI: SPCR: console: uart,mmio,0x3f00002f8,115200
[    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x2080000000-0x27ffffffff]
[    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x00000000-0x7fffffff]
[    0.000000] ACPI: SRAT: Node 3 PXM 3 [mem 0x202000000000-0x2027ffffffff]
[    0.000000] NUMA: Initmem setup node 0 [<memory-less node>]
[    0.000000] NUMA: NODE_DATA [mem 0x2027f80c3c00-0x2027f80c5fff]
[    0.000000] NUMA: NODE_DATA(0) on node 3
[    0.000000] NUMA: NODE_DATA [mem 0x27ffffdc00-0x27ffffffff]
[    0.000000] NUMA: Initmem setup node 2 [<memory-less node>]
[    0.000000] NUMA: NODE_DATA [mem 0x2027f80c1800-0x2027f80c3bff]
[    0.000000] NUMA: NODE_DATA(2) on node 3
[    0.000000] NUMA: NODE_DATA [mem 0x2027f80bf400-0x2027f80c17ff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x00002027ffffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   1: [mem 0x0000000000000000-0x000000000000ffff]
[    0.000000]   node   1: [mem 0x0000000000010000-0x00000000302bbfff]
[    0.000000]   node   1: [mem 0x00000000302bc000-0x0000000030afffff]
[    0.000000]   node   1: [mem 0x0000000030b00000-0x00000000396bffff]
[    0.000000]   node   1: [mem 0x00000000396c0000-0x000000003975ffff]
[    0.000000]   node   1: [mem 0x0000000039760000-0x00000000397bffff]
[    0.000000]   node   1: [mem 0x00000000397c0000-0x000000003990ffff]
[    0.000000]   node   1: [mem 0x0000000039910000-0x000000003991ffff]
[    0.000000]   node   1: [mem 0x0000000039920000-0x00000000399fffff]
[    0.000000]   node   1: [mem 0x0000000039a00000-0x0000000039a3ffff]
[    0.000000]   node   1: [mem 0x0000000039a40000-0x0000000039adffff]
[    0.000000]   node   1: [mem 0x0000000039ae0000-0x0000000039b0ffff]
[    0.000000]   node   1: [mem 0x0000000039b10000-0x0000000039c4ffff]
[    0.000000]   node   1: [mem 0x0000000039c50000-0x0000000039d1ffff]
[    0.000000]   node   1: [mem 0x0000000039d20000-0x0000000039d21fff]
[    0.000000]   node   1: [mem 0x0000000039d22000-0x0000000039d2ffff]
[    0.000000]   node   1: [mem 0x0000000039d30000-0x0000000039d30fff]
[    0.000000]   node   1: [mem 0x0000000039d31000-0x0000000039d3ffff]
[    0.000000]   node   1: [mem 0x0000000039d40000-0x0000000039d41fff]
[    0.000000]   node   1: [mem 0x0000000039d42000-0x0000000039d5ffff]
[    0.000000]   node   1: [mem 0x0000000039d60000-0x0000000039d61fff]
[    0.000000]   node   1: [mem 0x0000000039d62000-0x0000000039d7ffff]
[    0.000000]   node   1: [mem 0x0000000039d80000-0x0000000039d80fff]
[    0.000000]   node   1: [mem 0x0000000039d81000-0x0000000039d8ffff]
[    0.000000]   node   1: [mem 0x0000000039d90000-0x0000000039d9ffff]
[    0.000000]   node   1: [mem 0x0000000039da0000-0x0000000039ddffff]
[    0.000000]   node   1: [mem 0x0000000039de0000-0x000000003a0dffff]
[    0.000000]   node   1: [mem 0x000000003a0e0000-0x000000003a0eafff]
[    0.000000]   node   1: [mem 0x000000003a0eb000-0x000000003a0ebfff]
[    0.000000]   node   1: [mem 0x000000003a0ec000-0x000000003f0cffff]
[    0.000000]   node   1: [mem 0x000000003f0d0000-0x000000003f0fffff]
[    0.000000]   node   1: [mem 0x000000003f100000-0x000000003fbfffff]
[    0.000000]   node   1: [mem 0x0000000040000000-0x0000000043ffffff]
[    0.000000]   node   1: [mem 0x0000000044020000-0x000000005fffffff]
[    0.000000]   node   1: [mem 0x0000000060000000-0x000000007fffffff]
[    0.000000]   node   1: [mem 0x0000002080000000-0x00000027ffffffff]
[    0.000000]   node   3: [mem 0x0000202000000000-0x00002027ffffffff]
[    0.000000] Zeroed struct page in unavailable ranges: 996 pages
[    0.000000] Initmem setup node 0 [mem 
0x0000000000000000-0x0000000000000000]
[    0.000000] On node 0 totalpages: 0
[    0.000000] Initmem setup node 1 [mem 
0x0000000000000000-0x00000027ffffffff]
[    0.000000] On node 1 totalpages: 8387552
[    0.000000]   DMA zone: 8176 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 523232 pages, LIFO batch:63
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:63
[    0.000000] Initmem setup node 2 [mem 
0x0000000000000000-0x0000000000000000]
[    0.000000] On node 2 totalpages: 0
[    0.000000] Initmem setup node 3 [mem 
0x0000202000000000-0x00002027ffffffff]
[    0.000000] On node 3 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:63
[    0.000000] psci: probing for conduit method from ACPI.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.1
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x80000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x80100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x80200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x80300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x90000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x90100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x90200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0x90300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xa0000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xa0100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xa0200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xa0300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xb0000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xb0100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xb0200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xb0300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xc0000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xc0100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xc0200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xc0300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xd0000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xd0100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xd0200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xd0300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xe0000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xe0100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xe0200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xe0300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xf0000 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xf0100 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xf0200 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 0 -> MPIDR 0xf0300 -> Node 0
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x180000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x180100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x180200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x180300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x190000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x190100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x190200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x190300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1a0000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1a0100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1a0200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1a0300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1b0000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1b0100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1b0200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1b0300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1c0000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1c0100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1c0200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1c0300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1d0000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1d0100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1d0200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1d0300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1e0000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1e0100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1e0200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1e0300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1f0000 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1f0100 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1f0200 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 1 -> MPIDR 0x1f0300 -> Node 1
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x280000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x280100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x280200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x280300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x290000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x290100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x290200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x290300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2a0000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2a0100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2a0200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2a0300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2b0000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2b0100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2b0200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2b0300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2c0000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2c0100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2c0200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2c0300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2d0000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2d0100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2d0200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2d0300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2e0000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2e0100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2e0200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2e0300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2f0000 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2f0100 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2f0200 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 2 -> MPIDR 0x2f0300 -> Node 2
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x380000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x380100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x380200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x380300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x390000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x390100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x390200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x390300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3a0000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3a0100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3a0200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3a0300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3b0000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3b0100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3b0200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3b0300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3c0000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3c0100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3c0200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3c0300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3d0000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3d0100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3d0200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3d0300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3e0000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3e0100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3e0200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3e0300 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3f0000 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3f0100 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3f0200 -> Node 3
[    0.000000] ACPI: NUMA: SRAT: PXM 3 -> MPIDR 0x3f0300 -> Node 3
[    0.000000] percpu: Embedded 23 pages/cpu s56536 r8192 d29480 u94208
[    0.000000] pcpu-alloc: s56536 r8192 d29480 u94208 alloc=23*4096
[    0.000000] pcpu-alloc: [0] 000 [0] 001 [0] 002 [0] 003
[    0.000000] pcpu-alloc: [0] 004 [0] 005 [0] 006 [0] 007
[    0.000000] pcpu-alloc: [0] 008 [0] 009 [0] 010 [0] 011
[    0.000000] pcpu-alloc: [0] 012 [0] 013 [0] 014 [0] 015
[    0.000000] pcpu-alloc: [0] 016 [0] 017 [0] 018 [0] 019
[    0.000000] pcpu-alloc: [0] 020 [0] 021 [0] 022 [0] 023
[    0.000000] pcpu-alloc: [0] 024 [0] 025 [0] 026 [0] 027
[    0.000000] pcpu-alloc: [0] 028 [0] 029 [0] 030 [0] 031
[    0.000000] pcpu-alloc: [1] 032 [1] 033 [1] 034 [1] 035
[    0.000000] pcpu-alloc: [1] 036 [1] 037 [1] 038 [1] 039
[    0.000000] pcpu-alloc: [1] 040 [1] 041 [1] 042 [1] 043
[    0.000000] pcpu-alloc: [1] 044 [1] 045 [1] 046 [1] 047
[    0.000000] pcpu-alloc: [1] 048 [1] 049 [1] 050 [1] 051
[    0.000000] pcpu-alloc: [1] 052 [1] 053 [1] 054 [1] 055
[    0.000000] pcpu-alloc: [1] 056 [1] 057 [1] 058 [1] 059
[    0.000000] pcpu-alloc: [1] 060 [1] 061 [1] 062 [1] 063
[    0.000000] pcpu-alloc: [2] 064 [2] 065 [2] 066 [2] 067
[    0.000000] pcpu-alloc: [2] 068 [2] 069 [2] 070 [2] 071
[    0.000000] pcpu-alloc: [2] 072 [2] 073 [2] 074 [2] 075
[    0.000000] pcpu-alloc: [2] 076 [2] 077 [2] 078 [2] 079
[    0.000000] pcpu-alloc: [2] 080 [2] 081 [2] 082 [2] 083
[    0.000000] pcpu-alloc: [2] 084 [2] 085 [2] 086 [2] 087
[    0.000000] pcpu-alloc: [2] 088 [2] 089 [2] 090 [2] 091
[    0.000000] pcpu-alloc: [2] 092 [2] 093 [2] 094 [2] 095
[    0.000000] pcpu-alloc: [3] 096 [3] 097 [3] 098 [3] 099
[    0.000000] pcpu-alloc: [3] 100 [3] 101 [3] 102 [3] 103
[    0.000000] pcpu-alloc: [3] 104 [3] 105 [3] 106 [3] 107
[    0.000000] pcpu-alloc: [3] 108 [3] 109 [3] 110 [3] 111
[    0.000000] pcpu-alloc: [3] 112 [3] 113 [3] 114 [3] 115
[    0.000000] pcpu-alloc: [3] 116 [3] 117 [3] 118 [3] 119
[    0.000000] pcpu-alloc: [3] 120 [3] 121 [3] 122 [3] 123
[    0.000000] pcpu-alloc: [3] 124 [3] 125 [3] 126 [3] 127
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: detected: GIC system register CPU interface
[    0.000000] CPU features: detected: Virtualization Host Extensions
[    0.000000] CPU features: kernel page table isolation forced ON by KASLR
[    0.000000] CPU features: detected: Kernel page table isolation (KPTI)
[    0.000000] CPU features: detected: Hardware dirty bit management
[    0.000000] CPU features: detected: Spectre-v4
[    0.000000] alternatives: patching kernel code
[    0.000000] Built 4 zonelists, mobility grouping on.  Total pages: 
16514032
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/john/Image rdinit=/init 
console=ttyS0,115200 nvme.use_threaded_interrupts=0 iommu.strict=0 
hisi_sas_v3_hw.auto_affidne_msi_experimental=1 
irqchip.gicv3_pseudo_nmsi=1 acpi=force earlycon=pl011,mmio32,0x602b0000
[    0.000000] printk: log_buf_len individual max cpu contribution: 4096 
bytes
[    0.000000] printk: log_buf_len total cpu_extra contributions: 520192 
bytes
[    0.000000] printk: log_buf_len min size: 131072 bytes
[    0.000000] printk: log_buf_len: 1048576 bytes
[    0.000000] printk: early log buf free: 112608(85%)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] software IO TLB: mapped [mem 
0x000000007a000000-0x000000007e000000] (64MB)
[    0.000000] Memory: 65159192K/67104640K available (14400K kernel 
code, 2830K rwdata, 7712K rodata, 5760K init, 494K bss, 1912680K 
reserved, 32768K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=128, Nodes=4
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to 
nr_cpu_ids=128.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay 
is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, 
nr_cpu_ids=128
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
[    0.000000] GICv3: 640 SPIs implemented
[    0.000000] GICv3: 0 Extended SPIs implemented
[    0.000000] GICv3: Distributor has no Range Selector support
[    0.000000] GICv3: 16 PPIs implemented
[    0.000000] GICv3: GICv4 features: DirectLPI
[    0.000000] GICv3: CPU0: found redistributor 80000 region 
0:0x00000000ae100000
[    0.000000] SRAT: PXM 0 -> ITS 0 -> Node 0
[    0.000000] SRAT: PXM 2 -> ITS 1 -> Node 2
[    0.000000] ITS [mem 0x202100000-0x20211ffff]
[    0.000000] ITS@0x0000000202100000: Using ITS number 0
[    0.000000] ITS@0x0000000202100000: allocated 65536 Devices 
@2080280000 (flat, esz 8, psz 16K, shr 1)
[    0.000000] ITS@0x0000000202100000: allocated 65536 Virtual CPUs 
@2080300000 (flat, esz 16, psz 4K, shr 1)
[    0.000000] ITS@0x0000000202100000: allocated 256 Interrupt 
Collections @208025a000 (flat, esz 16, psz 4K, shr 1)
[    0.000000] ITS [mem 0x200202100000-0x20020211ffff]
[    0.000000] ITS@0x0000200202100000: Using ITS number 1
[    0.000000] ITS@0x0000200202100000: allocated 65536 Devices 
@202000080000 (flat, esz 8, psz 16K, shr 1)
[    0.000000] ITS@0x0000200202100000: allocated 65536 Virtual CPUs 
@202000100000 (flat, esz 16, psz 4K, shr 1)
[    0.000000] ITS@0x0000200202100000: allocated 256 Interrupt 
Collections @202000001000 (flat, esz 16, psz 4K, shr 1)
[    0.000000] GICv3: using LPI property table @0x0000002080270000
[    0.000000] ITS: Using DirectLPI for VPE invalidation
[    0.000000] ITS: Enabling GICv4 support
[    0.000000] GICv3: CPU0: using allocated LPI pending table 
@0x0000002080800000
[    0.000000] random: get_random_bytes called from 
start_kernel+0x350/0x50c with crng_init=0
[    0.000000] arch_timer: cp15 timer(s) running at 100.00MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff 
max_cycles: 0x171024e7e0, max_idle_ns: 440795205315 ns
[    0.000000] sched_clock: 56 bits at 100MHz, resolution 10ns, wraps 
every 4398046511100ns
[    0.000149] Console: colour dummy device 80x25
[    0.000219] mempolicy: Enabling automatic NUMA balancing. Configure 
with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000255] ACPI: Core revision 20201113
[    0.000491] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 200.00 BogoMIPS (lpj=400000)
[    0.000516] pid_max: default: 131072 minimum: 1024
[    0.000579] LSM: Security Framework initializing
[    0.012561] Dentry cache hash table entries: 8388608 (order: 14, 
67108864 bytes, vmalloc)
[    0.019082] Inode-cache hash table entries: 4194304 (order: 13, 
33554432 bytes, vmalloc)
[    0.019328] Mount-cache hash table entries: 131072 (order: 8, 1048576 
bytes, vmalloc)
[    0.019531] Mountpoint-cache hash table entries: 131072 (order: 8, 
1048576 bytes, vmalloc)
[    0.021224] rcu: Hierarchical SRCU implementation.
[    0.021289] Platform MSI: ITS@0x202100000 domain created
[    0.021303] Platform MSI: ITS@0x200202100000 domain created
[    0.021319] PCI/MSI: ITS@0x202100000 domain created
[    0.021332] PCI/MSI: ITS@0x200202100000 domain created
[    0.021349] fsl-mc MSI: ITS@0x202100000 domain created
[    0.021362] fsl-mc MSI: ITS@0x200202100000 domain created
[    0.021382] Remapping and enabling EFI services.
[    0.021593] efi: memattr: Entry attributes invalid: RO and XP bits 
both cleared
[    0.021612] efi: memattr: ! 0x000000000000-0x00000000ffff [Runtime 
Code|RUN|  |  |  |  |  |  |  |  |   |  |  |  |  ]
[    0.022931] smp: Bringing up secondary CPUs ...
[    0.027609] Detected VIPT I-cache on CPU1
[    0.027617] GICv3: CPU1: found redistributor 80100 region 
1:0x00000000ae140000
[    0.027631] GICv3: CPU1: using allocated LPI pending table 
@0x0000002080810000
[    0.027673] CPU1: Booted secondary processor 0x0000080100 [0x481fd010]
[    0.065922] Detected VIPT I-cache on CPU2
[    0.065927] GICv3: CPU2: found redistributor 80200 region 
2:0x00000000ae180000
[    0.065939] GICv3: CPU2: using allocated LPI pending table 
@0x0000002080820000
[    0.065976] CPU2: Booted secondary processor 0x0000080200 [0x481fd010]
[    0.104226] Detected VIPT I-cache on CPU3
[    0.104231] GICv3: CPU3: found redistributor 80300 region 
3:0x00000000ae1c0000
[    0.104242] GICv3: CPU3: using allocated LPI pending table 
@0x0000002080830000
[    0.104279] CPU3: Booted secondary processor 0x0000080300 [0x481fd010]
[    0.142525] Detected VIPT I-cache on CPU4
[    0.142537] GICv3: CPU4: found redistributor 90000 region 
4:0x00000000ae200000
[    0.142557] GICv3: CPU4: using allocated LPI pending table 
@0x0000002080840000
[    0.142601] CPU4: Booted secondary processor 0x0000090000 [0x481fd010]
[    0.181008] Detected VIPT I-cache on CPU5
[    0.181014] GICv3: CPU5: found redistributor 90100 region 
5:0x00000000ae240000
[    0.181026] GICv3: CPU5: using allocated LPI pending table 
@0x0000002080850000
[    0.181065] CPU5: Booted secondary processor 0x0000090100 [0x481fd010]
[    0.219316] Detected VIPT I-cache on CPU6
[    0.219322] GICv3: CPU6: found redistributor 90200 region 
6:0x00000000ae280000
[    0.219334] GICv3: CPU6: using allocated LPI pending table 
@0x0000002080860000
[    0.219371] CPU6: Booted secondary processor 0x0000090200 [0x481fd010]
[    0.257617] Detected VIPT I-cache on CPU7
[    0.257623] GICv3: CPU7: found redistributor 90300 region 
7:0x00000000ae2c0000
[    0.257635] GICv3: CPU7: using allocated LPI pending table 
@0x0000002080870000
[    0.257674] CPU7: Booted secondary processor 0x0000090300 [0x481fd010]
[    0.295936] Detected VIPT I-cache on CPU8
[    0.295946] GICv3: CPU8: found redistributor a0000 region 
8:0x00000000ae300000
[    0.295965] GICv3: CPU8: using allocated LPI pending table 
@0x0000002080880000
[    0.296008] CPU8: Booted secondary processor 0x00000a0000 [0x481fd010]
[    0.334246] Detected VIPT I-cache on CPU9
[    0.334253] GICv3: CPU9: found redistributor a0100 region 
9:0x00000000ae340000
[    0.334265] GICv3: CPU9: using allocated LPI pending table 
@0x0000002080890000
[    0.334303] CPU9: Booted secondary processor 0x00000a0100 [0x481fd010]
[    0.372551] Detected VIPT I-cache on CPU10
[    0.372558] GICv3: CPU10: found redistributor a0200 region 
10:0x00000000ae380000
[    0.372571] GICv3: CPU10: using allocated LPI pending table 
@0x00000020808a0000
[    0.372608] CPU10: Booted secondary processor 0x00000a0200 [0x481fd010]
[    0.410857] Detected VIPT I-cache on CPU11
[    0.410864] GICv3: CPU11: found redistributor a0300 region 
11:0x00000000ae3c0000
[    0.410877] GICv3: CPU11: using allocated LPI pending table 
@0x00000020808b0000
[    0.410915] CPU11: Booted secondary processor 0x00000a0300 [0x481fd010]
[    0.449161] Detected VIPT I-cache on CPU12
[    0.449172] GICv3: CPU12: found redistributor b0000 region 
12:0x00000000ae400000
[    0.449192] GICv3: CPU12: using allocated LPI pending table 
@0x00000020808c0000
[    0.449236] CPU12: Booted secondary processor 0x00000b0000 [0x481fd010]
[    0.487472] Detected VIPT I-cache on CPU13
[    0.487479] GICv3: CPU13: found redistributor b0100 region 
13:0x00000000ae440000
[    0.487492] GICv3: CPU13: using allocated LPI pending table 
@0x00000020808d0000
[    0.487530] CPU13: Booted secondary processor 0x00000b0100 [0x481fd010]
[    0.525781] Detected VIPT I-cache on CPU14
[    0.525788] GICv3: CPU14: found redistributor b0200 region 
14:0x00000000ae480000
[    0.525801] GICv3: CPU14: using allocated LPI pending table 
@0x00000020808e0000
[    0.525839] CPU14: Booted secondary processor 0x00000b0200 [0x481fd010]
[    0.564084] Detected VIPT I-cache on CPU15
[    0.564091] GICv3: CPU15: found redistributor b0300 region 
15:0x00000000ae4c0000
[    0.564104] GICv3: CPU15: using allocated LPI pending table 
@0x00000020808f0000
[    0.564142] CPU15: Booted secondary processor 0x00000b0300 [0x481fd010]
[    0.602408] Detected VIPT I-cache on CPU16
[    0.602420] GICv3: CPU16: found redistributor c0000 region 
16:0x00000000ae500000
[    0.602440] GICv3: CPU16: using allocated LPI pending table 
@0x0000002080900000
[    0.602483] CPU16: Booted secondary processor 0x00000c0000 [0x481fd010]
[    0.640725] Detected VIPT I-cache on CPU17
[    0.640732] GICv3: CPU17: found redistributor c0100 region 
17:0x00000000ae540000
[    0.640745] GICv3: CPU17: using allocated LPI pending table 
@0x0000002080910000
[    0.640783] CPU17: Booted secondary processor 0x00000c0100 [0x481fd010]
[    0.679029] Detected VIPT I-cache on CPU18
[    0.679037] GICv3: CPU18: found redistributor c0200 region 
18:0x00000000ae580000
[    0.679050] GICv3: CPU18: using allocated LPI pending table 
@0x0000002080920000
[    0.679089] CPU18: Booted secondary processor 0x00000c0200 [0x481fd010]
[    0.717330] Detected VIPT I-cache on CPU19
[    0.717338] GICv3: CPU19: found redistributor c0300 region 
19:0x00000000ae5c0000
[    0.717352] GICv3: CPU19: using allocated LPI pending table 
@0x0000002080930000
[    0.717390] CPU19: Booted secondary processor 0x00000c0300 [0x481fd010]
[    0.755634] Detected VIPT I-cache on CPU20
[    0.755647] GICv3: CPU20: found redistributor d0000 region 
20:0x00000000ae600000
[    0.755668] GICv3: CPU20: using allocated LPI pending table 
@0x0000002080940000
[    0.755712] CPU20: Booted secondary processor 0x00000d0000 [0x481fd010]
[    0.793944] Detected VIPT I-cache on CPU21
[    0.793952] GICv3: CPU21: found redistributor d0100 region 
21:0x00000000ae640000
[    0.793967] GICv3: CPU21: using allocated LPI pending table 
@0x0000002080950000
[    0.794005] CPU21: Booted secondary processor 0x00000d0100 [0x481fd010]
[    0.832251] Detected VIPT I-cache on CPU22
[    0.832259] GICv3: CPU22: found redistributor d0200 region 
22:0x00000000ae680000
[    0.832273] GICv3: CPU22: using allocated LPI pending table 
@0x0000002080960000
[    0.832312] CPU22: Booted secondary processor 0x00000d0200 [0x481fd010]
[    0.870561] Detected VIPT I-cache on CPU23
[    0.870569] GICv3: CPU23: found redistributor d0300 region 
23:0x00000000ae6c0000
[    0.870585] GICv3: CPU23: using allocated LPI pending table 
@0x0000002080970000
[    0.870624] CPU23: Booted secondary processor 0x00000d0300 [0x481fd010]
[    0.908891] Detected VIPT I-cache on CPU24
[    0.908905] GICv3: CPU24: found redistributor e0000 region 
24:0x00000000ae700000
[    0.908926] GICv3: CPU24: using allocated LPI pending table 
@0x0000002080980000
[    0.908970] CPU24: Booted secondary processor 0x00000e0000 [0x481fd010]
[    0.947202] Detected VIPT I-cache on CPU25
[    0.947211] GICv3: CPU25: found redistributor e0100 region 
25:0x00000000ae740000
[    0.947225] GICv3: CPU25: using allocated LPI pending table 
@0x0000002080990000
[    0.947264] CPU25: Booted secondary processor 0x00000e0100 [0x481fd010]
[    0.985516] Detected VIPT I-cache on CPU26
[    0.985524] GICv3: CPU26: found redistributor e0200 region 
26:0x00000000ae780000
[    0.985539] GICv3: CPU26: using allocated LPI pending table 
@0x00000020809a0000
[    0.985577] CPU26: Booted secondary processor 0x00000e0200 [0x481fd010]
[    1.023821] Detected VIPT I-cache on CPU27
[    1.023829] GICv3: CPU27: found redistributor e0300 region 
27:0x00000000ae7c0000
[    1.023844] GICv3: CPU27: using allocated LPI pending table 
@0x00000020809b0000
[    1.023883] CPU27: Booted secondary processor 0x00000e0300 [0x481fd010]
[    1.062129] Detected VIPT I-cache on CPU28
[    1.062143] GICv3: CPU28: found redistributor f0000 region 
28:0x00000000ae800000
[    1.062166] GICv3: CPU28: using allocated LPI pending table 
@0x00000020809c0000
[    1.062210] CPU28: Booted secondary processor 0x00000f0000 [0x481fd010]
[    1.100441] Detected VIPT I-cache on CPU29
[    1.100451] GICv3: CPU29: found redistributor f0100 region 
29:0x00000000ae840000
[    1.100466] GICv3: CPU29: using allocated LPI pending table 
@0x00000020809d0000
[    1.100505] CPU29: Booted secondary processor 0x00000f0100 [0x481fd010]
[    1.138753] Detected VIPT I-cache on CPU30
[    1.138762] GICv3: CPU30: found redistributor f0200 region 
30:0x00000000ae880000
[    1.138777] GICv3: CPU30: using allocated LPI pending table 
@0x00000020809e0000
[    1.138817] CPU30: Booted secondary processor 0x00000f0200 [0x481fd010]
[    1.177058] Detected VIPT I-cache on CPU31
[    1.177068] GICv3: CPU31: found redistributor f0300 region 
31:0x00000000ae8c0000
[    1.177083] GICv3: CPU31: using allocated LPI pending table 
@0x00000020809f0000
[    1.177121] CPU31: Booted secondary processor 0x00000f0300 [0x481fd010]
[    1.215320] Detected VIPT I-cache on CPU32
[    1.215342] GICv3: CPU32: found redistributor 180000 region 
32:0x00000000aa100000
[    1.215394] GICv3: CPU32: using allocated LPI pending table 
@0x0000002080a00000
[    1.215438] CPU32: Booted secondary processor 0x0000180000 [0x481fd010]
[    1.253764] Detected VIPT I-cache on CPU33
[    1.253776] GICv3: CPU33: found redistributor 180100 region 
33:0x00000000aa140000
[    1.253796] GICv3: CPU33: using allocated LPI pending table 
@0x0000002080a10000
[    1.253830] CPU33: Booted secondary processor 0x0000180100 [0x481fd010]
[    1.292084] Detected VIPT I-cache on CPU34
[    1.292095] GICv3: CPU34: found redistributor 180200 region 
34:0x00000000aa180000
[    1.292115] GICv3: CPU34: using allocated LPI pending table 
@0x0000002080a20000
[    1.292149] CPU34: Booted secondary processor 0x0000180200 [0x481fd010]
[    1.330405] Detected VIPT I-cache on CPU35
[    1.330417] GICv3: CPU35: found redistributor 180300 region 
35:0x00000000aa1c0000
[    1.330436] GICv3: CPU35: using allocated LPI pending table 
@0x0000002080a30000
[    1.330470] CPU35: Booted secondary processor 0x0000180300 [0x481fd010]
[    1.368713] Detected VIPT I-cache on CPU36
[    1.368729] GICv3: CPU36: found redistributor 190000 region 
36:0x00000000aa200000
[    1.368760] GICv3: CPU36: using allocated LPI pending table 
@0x0000002080a40000
[    1.368801] CPU36: Booted secondary processor 0x0000190000 [0x481fd010]
[    1.407038] Detected VIPT I-cache on CPU37
[    1.407050] GICv3: CPU37: found redistributor 190100 region 
37:0x00000000aa240000
[    1.407071] GICv3: CPU37: using allocated LPI pending table 
@0x0000002080a50000
[    1.407106] CPU37: Booted secondary processor 0x0000190100 [0x481fd010]
[    1.445360] Detected VIPT I-cache on CPU38
[    1.445373] GICv3: CPU38: found redistributor 190200 region 
38:0x00000000aa280000
[    1.445394] GICv3: CPU38: using allocated LPI pending table 
@0x0000002080a60000
[    1.445428] CPU38: Booted secondary processor 0x0000190200 [0x481fd010]
[    1.483681] Detected VIPT I-cache on CPU39
[    1.483694] GICv3: CPU39: found redistributor 190300 region 
39:0x00000000aa2c0000
[    1.483715] GICv3: CPU39: using allocated LPI pending table 
@0x0000002080a70000
[    1.483749] CPU39: Booted secondary processor 0x0000190300 [0x481fd010]
[    1.522010] Detected VIPT I-cache on CPU40
[    1.522026] GICv3: CPU40: found redistributor 1a0000 region 
40:0x00000000aa300000
[    1.522052] GICv3: CPU40: using allocated LPI pending table 
@0x0000002080a80000
[    1.522092] CPU40: Booted secondary processor 0x00001a0000 [0x481fd010]
[    1.560334] Detected VIPT I-cache on CPU41
[    1.560347] GICv3: CPU41: found redistributor 1a0100 region 
41:0x00000000aa340000
[    1.560368] GICv3: CPU41: using allocated LPI pending table 
@0x0000002080a90000
[    1.560403] CPU41: Booted secondary processor 0x00001a0100 [0x481fd010]
[    1.598655] Detected VIPT I-cache on CPU42
[    1.598669] GICv3: CPU42: found redistributor 1a0200 region 
42:0x00000000aa380000
[    1.598690] GICv3: CPU42: using allocated LPI pending table 
@0x0000002080aa0000
[    1.598724] CPU42: Booted secondary processor 0x00001a0200 [0x481fd010]
[    1.636971] Detected VIPT I-cache on CPU43
[    1.636985] GICv3: CPU43: found redistributor 1a0300 region 
43:0x00000000aa3c0000
[    1.637006] GICv3: CPU43: using allocated LPI pending table 
@0x0000002080ab0000
[    1.637039] CPU43: Booted secondary processor 0x00001a0300 [0x481fd010]
[    1.675294] Detected VIPT I-cache on CPU44
[    1.675311] GICv3: CPU44: found redistributor 1b0000 region 
44:0x00000000aa400000
[    1.675338] GICv3: CPU44: using allocated LPI pending table 
@0x0000002080ac0000
[    1.675377] CPU44: Booted secondary processor 0x00001b0000 [0x481fd010]
[    1.713616] Detected VIPT I-cache on CPU45
[    1.713630] GICv3: CPU45: found redistributor 1b0100 region 
45:0x00000000aa440000
[    1.713651] GICv3: CPU45: using allocated LPI pending table 
@0x0000002080ad0000
[    1.713686] CPU45: Booted secondary processor 0x00001b0100 [0x481fd010]
[    1.751936] Detected VIPT I-cache on CPU46
[    1.751950] GICv3: CPU46: found redistributor 1b0200 region 
46:0x00000000aa480000
[    1.751972] GICv3: CPU46: using allocated LPI pending table 
@0x0000002080ae0000
[    1.752007] CPU46: Booted secondary processor 0x00001b0200 [0x481fd010]
[    1.790256] Detected VIPT I-cache on CPU47
[    1.790270] GICv3: CPU47: found redistributor 1b0300 region 
47:0x00000000aa4c0000
[    1.790292] GICv3: CPU47: using allocated LPI pending table 
@0x0000002080af0000
[    1.790326] CPU47: Booted secondary processor 0x00001b0300 [0x481fd010]
[    1.828587] Detected VIPT I-cache on CPU48
[    1.828604] GICv3: CPU48: found redistributor 1c0000 region 
48:0x00000000aa500000
[    1.828632] GICv3: CPU48: using allocated LPI pending table 
@0x0000002080b00000
[    1.828671] CPU48: Booted secondary processor 0x00001c0000 [0x481fd010]
[    1.866910] Detected VIPT I-cache on CPU49
[    1.866924] GICv3: CPU49: found redistributor 1c0100 region 
49:0x00000000aa540000
[    1.866946] GICv3: CPU49: using allocated LPI pending table 
@0x0000002080b10000
[    1.866981] CPU49: Booted secondary processor 0x00001c0100 [0x481fd010]
[    1.905237] Detected VIPT I-cache on CPU50
[    1.905251] GICv3: CPU50: found redistributor 1c0200 region 
50:0x00000000aa580000
[    1.905272] GICv3: CPU50: using allocated LPI pending table 
@0x0000002080b20000
[    1.905307] CPU50: Booted secondary processor 0x00001c0200 [0x481fd010]
[    1.943552] Detected VIPT I-cache on CPU51
[    1.943567] GICv3: CPU51: found redistributor 1c0300 region 
51:0x00000000aa5c0000
[    1.943589] GICv3: CPU51: using allocated LPI pending table 
@0x0000002080b30000
[    1.943623] CPU51: Booted secondary processor 0x00001c0300 [0x481fd010]
[    1.981858] Detected VIPT I-cache on CPU52
[    1.981875] GICv3: CPU52: found redistributor 1d0000 region 
52:0x00000000aa600000
[    1.981904] GICv3: CPU52: using allocated LPI pending table 
@0x0000002080b40000
[    1.981945] CPU52: Booted secondary processor 0x00001d0000 [0x481fd010]
[    2.020187] Detected VIPT I-cache on CPU53
[    2.020201] GICv3: CPU53: found redistributor 1d0100 region 
53:0x00000000aa640000
[    2.020224] GICv3: CPU53: using allocated LPI pending table 
@0x0000002080b50000
[    2.020258] CPU53: Booted secondary processor 0x00001d0100 [0x481fd010]
[    2.058506] Detected VIPT I-cache on CPU54
[    2.058521] GICv3: CPU54: found redistributor 1d0200 region 
54:0x00000000aa680000
[    2.058543] GICv3: CPU54: using allocated LPI pending table 
@0x0000002080b60000
[    2.058579] CPU54: Booted secondary processor 0x00001d0200 [0x481fd010]
[    2.096819] Detected VIPT I-cache on CPU55
[    2.096834] GICv3: CPU55: found redistributor 1d0300 region 
55:0x00000000aa6c0000
[    2.096856] GICv3: CPU55: using allocated LPI pending table 
@0x0000002080b70000
[    2.096892] CPU55: Booted secondary processor 0x00001d0300 [0x481fd010]
[    2.135157] Detected VIPT I-cache on CPU56
[    2.135175] GICv3: CPU56: found redistributor 1e0000 region 
56:0x00000000aa700000
[    2.135204] GICv3: CPU56: using allocated LPI pending table 
@0x0000002080b80000
[    2.135244] CPU56: Booted secondary processor 0x00001e0000 [0x481fd010]
[    2.173479] Detected VIPT I-cache on CPU57
[    2.173493] GICv3: CPU57: found redistributor 1e0100 region 
57:0x00000000aa740000
[    2.173516] GICv3: CPU57: using allocated LPI pending table 
@0x0000002080b90000
[    2.173551] CPU57: Booted secondary processor 0x00001e0100 [0x481fd010]
[    2.211798] Detected VIPT I-cache on CPU58
[    2.211813] GICv3: CPU58: found redistributor 1e0200 region 
58:0x00000000aa780000
[    2.211836] GICv3: CPU58: using allocated LPI pending table 
@0x0000002080ba0000
[    2.211872] CPU58: Booted secondary processor 0x00001e0200 [0x481fd010]
[    2.250116] Detected VIPT I-cache on CPU59
[    2.250131] GICv3: CPU59: found redistributor 1e0300 region 
59:0x00000000aa7c0000
[    2.250154] GICv3: CPU59: using allocated LPI pending table 
@0x0000002080bb0000
[    2.250189] CPU59: Booted secondary processor 0x00001e0300 [0x481fd010]
[    2.288442] Detected VIPT I-cache on CPU60
[    2.288462] GICv3: CPU60: found redistributor 1f0000 region 
60:0x00000000aa800000
[    2.288492] GICv3: CPU60: using allocated LPI pending table 
@0x0000002080bc0000
[    2.288533] CPU60: Booted secondary processor 0x00001f0000 [0x481fd010]
[    2.326763] Detected VIPT I-cache on CPU61
[    2.326779] GICv3: CPU61: found redistributor 1f0100 region 
61:0x00000000aa840000
[    2.326802] GICv3: CPU61: using allocated LPI pending table 
@0x0000002080bd0000
[    2.326838] CPU61: Booted secondary processor 0x00001f0100 [0x481fd010]
[    2.365095] Detected VIPT I-cache on CPU62
[    2.365111] GICv3: CPU62: found redistributor 1f0200 region 
62:0x00000000aa880000
[    2.365134] GICv3: CPU62: using allocated LPI pending table 
@0x0000002080be0000
[    2.365169] CPU62: Booted secondary processor 0x00001f0200 [0x481fd010]
[    2.403408] Detected VIPT I-cache on CPU63
[    2.403424] GICv3: CPU63: found redistributor 1f0300 region 
63:0x00000000aa8c0000
[    2.403447] GICv3: CPU63: using allocated LPI pending table 
@0x0000002080bf0000
[    2.403484] CPU63: Booted secondary processor 0x00001f0300 [0x481fd010]
[    2.442168] Detected VIPT I-cache on CPU64
[    2.442221] GICv3: CPU64: found redistributor 280000 region 
64:0x00002000ae100000
[    2.442291] GICv3: CPU64: using allocated LPI pending table 
@0x0000002080c00000
[    2.442368] CPU64: Booted secondary processor 0x0000280000 [0x481fd010]
[    2.480622] Detected VIPT I-cache on CPU65
[    2.480657] GICv3: CPU65: found redistributor 280100 region 
65:0x00002000ae140000
[    2.480686] GICv3: CPU65: using allocated LPI pending table 
@0x0000002080c10000
[    2.480744] CPU65: Booted secondary processor 0x0000280100 [0x481fd010]
[    2.518977] Detected VIPT I-cache on CPU66
[    2.519012] GICv3: CPU66: found redistributor 280200 region 
66:0x00002000ae180000
[    2.519038] GICv3: CPU66: using allocated LPI pending table 
@0x0000002080c20000
[    2.519098] CPU66: Booted secondary processor 0x0000280200 [0x481fd010]
[    2.557323] Detected VIPT I-cache on CPU67
[    2.557358] GICv3: CPU67: found redistributor 280300 region 
67:0x00002000ae1c0000
[    2.557386] GICv3: CPU67: using allocated LPI pending table 
@0x0000002080c30000
[    2.557444] CPU67: Booted secondary processor 0x0000280300 [0x481fd010]
[    2.595681] Detected VIPT I-cache on CPU68
[    2.595721] GICv3: CPU68: found redistributor 290000 region 
68:0x00002000ae200000
[    2.595761] GICv3: CPU68: using allocated LPI pending table 
@0x0000002080c40000
[    2.595821] CPU68: Booted secondary processor 0x0000290000 [0x481fd010]
[    2.634048] Detected VIPT I-cache on CPU69
[    2.634084] GICv3: CPU69: found redistributor 290100 region 
69:0x00002000ae240000
[    2.634113] GICv3: CPU69: using allocated LPI pending table 
@0x0000002080c50000
[    2.634172] CPU69: Booted secondary processor 0x0000290100 [0x481fd010]
[    2.672401] Detected VIPT I-cache on CPU70
[    2.672437] GICv3: CPU70: found redistributor 290200 region 
70:0x00002000ae280000
[    2.672464] GICv3: CPU70: using allocated LPI pending table 
@0x0000002080c60000
[    2.672524] CPU70: Booted secondary processor 0x0000290200 [0x481fd010]
[    2.710749] Detected VIPT I-cache on CPU71
[    2.710785] GICv3: CPU71: found redistributor 290300 region 
71:0x00002000ae2c0000
[    2.710813] GICv3: CPU71: using allocated LPI pending table 
@0x0000002080c70000
[    2.710873] CPU71: Booted secondary processor 0x0000290300 [0x481fd010]
[    2.749102] Detected VIPT I-cache on CPU72
[    2.749141] GICv3: CPU72: found redistributor 2a0000 region 
72:0x00002000ae300000
[    2.749182] GICv3: CPU72: using allocated LPI pending table 
@0x0000002080c80000
[    2.749242] CPU72: Booted secondary processor 0x00002a0000 [0x481fd010]
[    2.787466] Detected VIPT I-cache on CPU73
[    2.787503] GICv3: CPU73: found redistributor 2a0100 region 
73:0x00002000ae340000
[    2.787531] GICv3: CPU73: using allocated LPI pending table 
@0x0000002080c90000
[    2.787590] CPU73: Booted secondary processor 0x00002a0100 [0x481fd010]
[    2.825828] Detected VIPT I-cache on CPU74
[    2.825865] GICv3: CPU74: found redistributor 2a0200 region 
74:0x00002000ae380000
[    2.825893] GICv3: CPU74: using allocated LPI pending table 
@0x0000002080ca0000
[    2.825952] CPU74: Booted secondary processor 0x00002a0200 [0x481fd010]
[    2.864176] Detected VIPT I-cache on CPU75
[    2.864213] GICv3: CPU75: found redistributor 2a0300 region 
75:0x00002000ae3c0000
[    2.864241] GICv3: CPU75: using allocated LPI pending table 
@0x0000002080cb0000
[    2.864300] CPU75: Booted secondary processor 0x00002a0300 [0x481fd010]
[    2.902539] Detected VIPT I-cache on CPU76
[    2.902579] GICv3: CPU76: found redistributor 2b0000 region 
76:0x00002000ae400000
[    2.902623] GICv3: CPU76: using allocated LPI pending table 
@0x0000002080cc0000
[    2.902684] CPU76: Booted secondary processor 0x00002b0000 [0x481fd010]
[    2.940908] Detected VIPT I-cache on CPU77
[    2.940945] GICv3: CPU77: found redistributor 2b0100 region 
77:0x00002000ae440000
[    2.940973] GICv3: CPU77: using allocated LPI pending table 
@0x0000002080cd0000
[    2.941032] CPU77: Booted secondary processor 0x00002b0100 [0x481fd010]
[    2.979265] Detected VIPT I-cache on CPU78
[    2.979303] GICv3: CPU78: found redistributor 2b0200 region 
78:0x00002000ae480000
[    2.979333] GICv3: CPU78: using allocated LPI pending table 
@0x0000002080ce0000
[    2.979392] CPU78: Booted secondary processor 0x00002b0200 [0x481fd010]
[    3.017610] Detected VIPT I-cache on CPU79
[    3.017648] GICv3: CPU79: found redistributor 2b0300 region 
79:0x00002000ae4c0000
[    3.017675] GICv3: CPU79: using allocated LPI pending table 
@0x0000002080cf0000
[    3.017734] CPU79: Booted secondary processor 0x00002b0300 [0x481fd010]
[    3.055954] Detected VIPT I-cache on CPU80
[    3.055994] GICv3: CPU80: found redistributor 2c0000 region 
80:0x00002000ae500000
[    3.056038] GICv3: CPU80: using allocated LPI pending table 
@0x0000002080d00000
[    3.056099] CPU80: Booted secondary processor 0x00002c0000 [0x481fd010]
[    3.094321] Detected VIPT I-cache on CPU81
[    3.094358] GICv3: CPU81: found redistributor 2c0100 region 
81:0x00002000ae540000
[    3.094386] GICv3: CPU81: using allocated LPI pending table 
@0x0000002080d10000
[    3.094445] CPU81: Booted secondary processor 0x00002c0100 [0x481fd010]
[    3.132675] Detected VIPT I-cache on CPU82
[    3.132712] GICv3: CPU82: found redistributor 2c0200 region 
82:0x00002000ae580000
[    3.132742] GICv3: CPU82: using allocated LPI pending table 
@0x0000002080d20000
[    3.132802] CPU82: Booted secondary processor 0x00002c0200 [0x481fd010]
[    3.171024] Detected VIPT I-cache on CPU83
[    3.171061] GICv3: CPU83: found redistributor 2c0300 region 
83:0x00002000ae5c0000
[    3.171092] GICv3: CPU83: using allocated LPI pending table 
@0x0000002080d30000
[    3.171150] CPU83: Booted secondary processor 0x00002c0300 [0x481fd010]
[    3.209380] Detected VIPT I-cache on CPU84
[    3.209420] GICv3: CPU84: found redistributor 2d0000 region 
84:0x00002000ae600000
[    3.209465] GICv3: CPU84: using allocated LPI pending table 
@0x0000002080d40000
[    3.209526] CPU84: Booted secondary processor 0x00002d0000 [0x481fd010]
[    3.247746] Detected VIPT I-cache on CPU85
[    3.247784] GICv3: CPU85: found redistributor 2d0100 region 
85:0x00002000ae640000
[    3.247815] GICv3: CPU85: using allocated LPI pending table 
@0x0000002080d50000
[    3.247874] CPU85: Booted secondary processor 0x00002d0100 [0x481fd010]
[    3.286108] Detected VIPT I-cache on CPU86
[    3.286145] GICv3: CPU86: found redistributor 2d0200 region 
86:0x00002000ae680000
[    3.286175] GICv3: CPU86: using allocated LPI pending table 
@0x0000002080d60000
[    3.286235] CPU86: Booted secondary processor 0x00002d0200 [0x481fd010]
[    3.324466] Detected VIPT I-cache on CPU87
[    3.324504] GICv3: CPU87: found redistributor 2d0300 region 
87:0x00002000ae6c0000
[    3.324535] GICv3: CPU87: using allocated LPI pending table 
@0x0000002080d70000
[    3.324594] CPU87: Booted secondary processor 0x00002d0300 [0x481fd010]
[    3.362818] Detected VIPT I-cache on CPU88
[    3.362858] GICv3: CPU88: found redistributor 2e0000 region 
88:0x00002000ae700000
[    3.362903] GICv3: CPU88: using allocated LPI pending table 
@0x0000002080d80000
[    3.362965] CPU88: Booted secondary processor 0x00002e0000 [0x481fd010]
[    3.401196] Detected VIPT I-cache on CPU89
[    3.401233] GICv3: CPU89: found redistributor 2e0100 region 
89:0x00002000ae740000
[    3.401265] GICv3: CPU89: using allocated LPI pending table 
@0x0000002080d90000
[    3.401324] CPU89: Booted secondary processor 0x00002e0100 [0x481fd010]
[    3.439556] Detected VIPT I-cache on CPU90
[    3.439594] GICv3: CPU90: found redistributor 2e0200 region 
90:0x00002000ae780000
[    3.439623] GICv3: CPU90: using allocated LPI pending table 
@0x0000002080da0000
[    3.439683] CPU90: Booted secondary processor 0x00002e0200 [0x481fd010]
[    3.477903] Detected VIPT I-cache on CPU91
[    3.477940] GICv3: CPU91: found redistributor 2e0300 region 
91:0x00002000ae7c0000
[    3.477971] GICv3: CPU91: using allocated LPI pending table 
@0x0000002080db0000
[    3.478030] CPU91: Booted secondary processor 0x00002e0300 [0x481fd010]
[    3.516267] Detected VIPT I-cache on CPU92
[    3.516309] GICv3: CPU92: found redistributor 2f0000 region 
92:0x00002000ae800000
[    3.516358] GICv3: CPU92: using allocated LPI pending table 
@0x0000002080dc0000
[    3.516419] CPU92: Booted secondary processor 0x00002f0000 [0x481fd010]
[    3.554640] Detected VIPT I-cache on CPU93
[    3.554679] GICv3: CPU93: found redistributor 2f0100 region 
93:0x00002000ae840000
[    3.554709] GICv3: CPU93: using allocated LPI pending table 
@0x0000002080dd0000
[    3.554770] CPU93: Booted secondary processor 0x00002f0100 [0x481fd010]
[    3.593004] Detected VIPT I-cache on CPU94
[    3.593043] GICv3: CPU94: found redistributor 2f0200 region 
94:0x00002000ae880000
[    3.593074] GICv3: CPU94: using allocated LPI pending table 
@0x0000002080de0000
[    3.593133] CPU94: Booted secondary processor 0x00002f0200 [0x481fd010]
[    3.631352] Detected VIPT I-cache on CPU95
[    3.631391] GICv3: CPU95: found redistributor 2f0300 region 
95:0x00002000ae8c0000
[    3.631420] GICv3: CPU95: using allocated LPI pending table 
@0x0000002080df0000
[    3.631479] CPU95: Booted secondary processor 0x00002f0300 [0x481fd010]
[    3.669807] Detected VIPT I-cache on CPU96
[    3.669878] GICv3: CPU96: found redistributor 380000 region 
96:0x00002000aa100000
[    3.669957] GICv3: CPU96: using allocated LPI pending table 
@0x0000002080e00000
[    3.670058] CPU96: Booted secondary processor 0x0000380000 [0x481fd010]
[    3.708268] Detected VIPT I-cache on CPU97
[    3.708313] GICv3: CPU97: found redistributor 380100 region 
97:0x00002000aa140000
[    3.708346] GICv3: CPU97: using allocated LPI pending table 
@0x0000002080e10000
[    3.708410] CPU97: Booted secondary processor 0x0000380100 [0x481fd010]
[    3.746631] Detected VIPT I-cache on CPU98
[    3.746676] GICv3: CPU98: found redistributor 380200 region 
98:0x00002000aa180000
[    3.746707] GICv3: CPU98: using allocated LPI pending table 
@0x0000002080e20000
[    3.746772] CPU98: Booted secondary processor 0x0000380200 [0x481fd010]
[    3.784984] Detected VIPT I-cache on CPU99
[    3.785029] GICv3: CPU99: found redistributor 380300 region 
99:0x00002000aa1c0000
[    3.785059] GICv3: CPU99: using allocated LPI pending table 
@0x0000002080e30000
[    3.785124] CPU99: Booted secondary processor 0x0000380300 [0x481fd010]
[    3.823345] Detected VIPT I-cache on CPU100
[    3.823394] GICv3: CPU100: found redistributor 390000 region 
100:0x00002000aa200000
[    3.823444] GICv3: CPU100: using allocated LPI pending table 
@0x0000002080e40000
[    3.823511] CPU100: Booted secondary processor 0x0000390000 [0x481fd010]
[    3.861713] Detected VIPT I-cache on CPU101
[    3.861759] GICv3: CPU101: found redistributor 390100 region 
101:0x00002000aa240000
[    3.861791] GICv3: CPU101: using allocated LPI pending table 
@0x0000002080e50000
[    3.861855] CPU101: Booted secondary processor 0x0000390100 [0x481fd010]
[    3.900079] Detected VIPT I-cache on CPU102
[    3.900125] GICv3: CPU102: found redistributor 390200 region 
102:0x00002000aa280000
[    3.900155] GICv3: CPU102: using allocated LPI pending table 
@0x0000002080e60000
[    3.900220] CPU102: Booted secondary processor 0x0000390200 [0x481fd010]
[    3.938429] Detected VIPT I-cache on CPU103
[    3.938475] GICv3: CPU103: found redistributor 390300 region 
103:0x00002000aa2c0000
[    3.938506] GICv3: CPU103: using allocated LPI pending table 
@0x0000002080e70000
[    3.938571] CPU103: Booted secondary processor 0x0000390300 [0x481fd010]
[    3.976791] Detected VIPT I-cache on CPU104
[    3.976840] GICv3: CPU104: found redistributor 3a0000 region 
104:0x00002000aa300000
[    3.976887] GICv3: CPU104: using allocated LPI pending table 
@0x0000002080e80000
[    3.976955] CPU104: Booted secondary processor 0x00003a0000 [0x481fd010]
[    4.015150] Detected VIPT I-cache on CPU105
[    4.015197] GICv3: CPU105: found redistributor 3a0100 region 
105:0x00002000aa340000
[    4.015227] GICv3: CPU105: using allocated LPI pending table 
@0x0000002080e90000
[    4.015291] CPU105: Booted secondary processor 0x00003a0100 [0x481fd010]
[    4.053514] Detected VIPT I-cache on CPU106
[    4.053562] GICv3: CPU106: found redistributor 3a0200 region 
106:0x00002000aa380000
[    4.053594] GICv3: CPU106: using allocated LPI pending table 
@0x0000002080ea0000
[    4.053658] CPU106: Booted secondary processor 0x00003a0200 [0x481fd010]
[    4.091862] Detected VIPT I-cache on CPU107
[    4.091909] GICv3: CPU107: found redistributor 3a0300 region 
107:0x00002000aa3c0000
[    4.091941] GICv3: CPU107: using allocated LPI pending table 
@0x0000002080eb0000
[    4.092005] CPU107: Booted secondary processor 0x00003a0300 [0x481fd010]
[    4.130225] Detected VIPT I-cache on CPU108
[    4.130275] GICv3: CPU108: found redistributor 3b0000 region 
108:0x00002000aa400000
[    4.130322] GICv3: CPU108: using allocated LPI pending table 
@0x0000002080ec0000
[    4.130391] CPU108: Booted secondary processor 0x00003b0000 [0x481fd010]
[    4.168587] Detected VIPT I-cache on CPU109
[    4.168634] GICv3: CPU109: found redistributor 3b0100 region 
109:0x00002000aa440000
[    4.168667] GICv3: CPU109: using allocated LPI pending table 
@0x0000002080ed0000
[    4.168732] CPU109: Booted secondary processor 0x00003b0100 [0x481fd010]
[    4.206939] Detected VIPT I-cache on CPU110
[    4.206986] GICv3: CPU110: found redistributor 3b0200 region 
110:0x00002000aa480000
[    4.207018] GICv3: CPU110: using allocated LPI pending table 
@0x0000002080ee0000
[    4.207083] CPU110: Booted secondary processor 0x00003b0200 [0x481fd010]
[    4.245284] Detected VIPT I-cache on CPU111
[    4.245332] GICv3: CPU111: found redistributor 3b0300 region 
111:0x00002000aa4c0000
[    4.245363] GICv3: CPU111: using allocated LPI pending table 
@0x0000002080ef0000
[    4.245427] CPU111: Booted secondary processor 0x00003b0300 [0x481fd010]
[    4.283639] Detected VIPT I-cache on CPU112
[    4.283688] GICv3: CPU112: found redistributor 3c0000 region 
112:0x00002000aa500000
[    4.283737] GICv3: CPU112: using allocated LPI pending table 
@0x0000002080f00000
[    4.283806] CPU112: Booted secondary processor 0x00003c0000 [0x481fd010]
[    4.322003] Detected VIPT I-cache on CPU113
[    4.322049] GICv3: CPU113: found redistributor 3c0100 region 
113:0x00002000aa540000
[    4.322077] GICv3: CPU113: using allocated LPI pending table 
@0x0000002080f10000
[    4.322142] CPU113: Booted secondary processor 0x00003c0100 [0x481fd010]
[    4.360356] Detected VIPT I-cache on CPU114
[    4.360402] GICv3: CPU114: found redistributor 3c0200 region 
114:0x00002000aa580000
[    4.360435] GICv3: CPU114: using allocated LPI pending table 
@0x0000002080f20000
[    4.360500] CPU114: Booted secondary processor 0x00003c0200 [0x481fd010]
[    4.398704] Detected VIPT I-cache on CPU115
[    4.398750] GICv3: CPU115: found redistributor 3c0300 region 
115:0x00002000aa5c0000
[    4.398778] GICv3: CPU115: using allocated LPI pending table 
@0x0000002080f30000
[    4.398843] CPU115: Booted secondary processor 0x00003c0300 [0x481fd010]
[    4.437074] Detected VIPT I-cache on CPU116
[    4.437123] GICv3: CPU116: found redistributor 3d0000 region 
116:0x00002000aa600000
[    4.437173] GICv3: CPU116: using allocated LPI pending table 
@0x0000002080f40000
[    4.437241] CPU116: Booted secondary processor 0x00003d0000 [0x481fd010]
[    4.475442] Detected VIPT I-cache on CPU117
[    4.475489] GICv3: CPU117: found redistributor 3d0100 region 
117:0x00002000aa640000
[    4.475523] GICv3: CPU117: using allocated LPI pending table 
@0x0000002080f50000
[    4.475589] CPU117: Booted secondary processor 0x00003d0100 [0x481fd010]
[    4.513790] Detected VIPT I-cache on CPU118
[    4.513837] GICv3: CPU118: found redistributor 3d0200 region 
118:0x00002000aa680000
[    4.513869] GICv3: CPU118: using allocated LPI pending table 
@0x0000002080f60000
[    4.513934] CPU118: Booted secondary processor 0x00003d0200 [0x481fd010]
[    4.552141] Detected VIPT I-cache on CPU119
[    4.552188] GICv3: CPU119: found redistributor 3d0300 region 
119:0x00002000aa6c0000
[    4.552223] GICv3: CPU119: using allocated LPI pending table 
@0x0000002080f70000
[    4.552288] CPU119: Booted secondary processor 0x00003d0300 [0x481fd010]
[    4.590513] Detected VIPT I-cache on CPU120
[    4.590564] GICv3: CPU120: found redistributor 3e0000 region 
120:0x00002000aa700000
[    4.590614] GICv3: CPU120: using allocated LPI pending table 
@0x0000002080f80000
[    4.590683] CPU120: Booted secondary processor 0x00003e0000 [0x481fd010]
[    4.628878] Detected VIPT I-cache on CPU121
[    4.628925] GICv3: CPU121: found redistributor 3e0100 region 
121:0x00002000aa740000
[    4.628959] GICv3: CPU121: using allocated LPI pending table 
@0x0000002080f90000
[    4.629024] CPU121: Booted secondary processor 0x00003e0100 [0x481fd010]
[    4.667235] Detected VIPT I-cache on CPU122
[    4.667283] GICv3: CPU122: found redistributor 3e0200 region 
122:0x00002000aa780000
[    4.667312] GICv3: CPU122: using allocated LPI pending table 
@0x0000002080fa0000
[    4.667377] CPU122: Booted secondary processor 0x00003e0200 [0x481fd010]
[    4.705588] Detected VIPT I-cache on CPU123
[    4.705636] GICv3: CPU123: found redistributor 3e0300 region 
123:0x00002000aa7c0000
[    4.705670] GICv3: CPU123: using allocated LPI pending table 
@0x0000002080fb0000
[    4.705735] CPU123: Booted secondary processor 0x00003e0300 [0x481fd010]
[    4.743963] Detected VIPT I-cache on CPU124
[    4.744014] GICv3: CPU124: found redistributor 3f0000 region 
124:0x00002000aa800000
[    4.744060] GICv3: CPU124: using allocated LPI pending table 
@0x0000002080fc0000
[    4.744129] CPU124: Booted secondary processor 0x00003f0000 [0x481fd010]
[    4.782327] Detected VIPT I-cache on CPU125
[    4.782376] GICv3: CPU125: found redistributor 3f0100 region 
125:0x00002000aa840000
[    4.782412] GICv3: CPU125: using allocated LPI pending table 
@0x0000002080fd0000
[    4.782479] CPU125: Booted secondary processor 0x00003f0100 [0x481fd010]
[    4.820685] Detected VIPT I-cache on CPU126
[    4.820734] GICv3: CPU126: found redistributor 3f0200 region 
126:0x00002000aa880000
[    4.820769] GICv3: CPU126: using allocated LPI pending table 
@0x0000002080fe0000
[    4.820834] CPU126: Booted secondary processor 0x00003f0200 [0x481fd010]
[    4.859030] Detected VIPT I-cache on CPU127
[    4.859079] GICv3: CPU127: found redistributor 3f0300 region 
127:0x00002000aa8c0000
[    4.859112] GICv3: CPU127: using allocated LPI pending table 
@0x0000002080ff0000
[    4.859179] CPU127: Booted secondary processor 0x00003f0300 [0x481fd010]
[    4.892345] smp: Brought up 4 nodes, 128 CPUs
[    4.899056] SMP: Total of 128 processors activated.
[    4.899068] CPU features: detected: Privileged Access Never
[    4.899081] CPU features: detected: LSE atomic instructions
[    4.899094] CPU features: detected: Common not Private translations
[    4.899109] CPU features: detected: RAS Extension Support
[    4.899121] CPU features: detected: CRC32 instructions
[    4.931603] CPU: All CPU(s) started at EL2
[    4.936731] ------------[ cut here ]------------
[    4.936744] Shortest NUMA path spans too many nodes
[    4.936759] WARNING: CPU: 0 PID: 1 at kernel/sched/topology.c:753 
cpu_attach_domain+0x308/0x368
[    4.936784] Modules linked in:
[    4.936794] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
5.11.0-rc3-g23cafd1b97c8 #382
[    4.936813] pstate: 60400009 (nZCv daif +PAN -UAO -TCO BTYPE=--)
[    4.936828] pc : cpu_attach_domain+0x308/0x368
[    4.936839] lr : cpu_attach_domain+0x308/0x368
[    4.936850] sp : ffff80001041bc90
[    4.936858] x29: ffff80001041bc90 x28: ffff202003f8fa00
[    4.936873] x27: 0000000000000000 x26: 0000000000000000
[    4.936886] x25: ffff202003f57a00 x24: ffff2027d7d2ca80
[    4.936900] x23: 0000000000001917 x22: ffff202003f57a00
[    4.936914] x21: 0000000000000000 x20: ffffa63355bc99c8
[    4.936927] x19: ffffa6335575da80 x18: 0000000000000010
[    4.936941] x17: 0000000000000000 x16: 000000009935660d
[    4.936954] x15: 000000000000035e x14: ffff80001041b950
[    4.936968] x13: 00000000ffffffea x12: ffff2027d765ffe8
[    4.936981] x11: 0000000000000003 x10: ffff2027d759ffa8
[    4.936995] x9 : ffff2027d75a0000 x8 : 00000000000bffe8
[    4.937008] x7 : c0000000ffff7fff x6 : 0000000000000001
[    4.937022] x5 : 00000000002bffa8 x4 : 0000000000000000
[    4.937035] x3 : 00000000ffffffff x2 : ffffa63355be2750
[    4.937049] x1 : f2a4ef248cff2500 x0 : 0000000000000000
[    4.937063] Call trace:
[    4.937069]  cpu_attach_domain+0x308/0x368
[    4.937080]  build_sched_domains+0x11b4/0x1208
[    4.937091]  sched_init_domains+0x88/0xb0
[    4.937102]  sched_init_smp+0x30/0x84
[    4.937113]  kernel_init_freeable+0xf8/0x23c
[    4.937125]  kernel_init+0x14/0x118
[    4.937136]  ret_from_fork+0x10/0x30
[    4.937147] ---[ end trace 15340c3c75e3254f ]---
[    4.941820] devtmpfs: initialized
[    4.942230] KASLR enabled
[    4.942409] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 7645041785100000 ns
[    4.942514] futex hash table entries: 32768 (order: 9, 2097152 bytes, 
vmalloc)
[    4.943315] pinctrl core: initialized pinctrl subsystem
[    4.943580] SMBIOS 3.1.1 present.
[    4.943592] DMI: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS 
V5.B103.01 12/25/2020
[    4.943974] NET: Registered protocol family 16
[    4.946041] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic 
allocations
[    4.946657] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for 
atomic allocations
[    4.947271] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for 
atomic allocations
[    4.947299] audit: initializing netlink subsys (disabled)
[    4.947376] audit: type=2000 audit(0.580:1): state=initialized 
audit_enabled=0 res=1
[    4.947545] thermal_sys: Registered thermal governor 'step_wise'
[    4.947547] thermal_sys: Registered thermal governor 'power_allocator'
[    4.947697] cpuidle: using governor menu
[    4.947730] Detected 1 PCC Subspaces
[    4.947771] Registering PCC driver as Mailbox controller
[    4.947910] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    4.949109] ASID allocator initialised with 32768 entries
[    4.949270] ACPI: bus type PCI registered
[    4.949281] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.949423] Serial: AMBA PL011 UART driver
[    4.953267] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    4.953285] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    4.953301] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    4.953316] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    4.953882] cryptd: max_cpu_qlen set to 1000
[    4.954917] ACPI: Added _OSI(Module Device)
[    4.954929] ACPI: Added _OSI(Processor Device)
[    4.954939] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.954951] ACPI: Added _OSI(Processor Aggregator Device)
[    4.954964] ACPI: Added _OSI(Linux-Dell-Video)
[    4.954974] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    4.954987] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    4.964680] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    4.968328] ACPI: Interpreter enabled
[    4.968339] ACPI: Using GIC for interrupt routing
[    4.968360] ACPI: MCFG table detected, 1 entries
[    4.968374] ACPI: IORT: SMMU-v3[148000000] Mapped to Proximity domain 0
[    4.968434] ACPI: IORT: SMMU-v3[201000000] Mapped to Proximity domain 0
[    4.968472] ACPI: IORT: SMMU-v3[100000000] Mapped to Proximity domain 0
[    4.968508] ACPI: IORT: SMMU-v3[140000000] Mapped to Proximity domain 0
[    4.968544] ACPI: IORT: SMMU-v3[200148000000] Mapped to Proximity 
domain 2
[    4.968579] ACPI: IORT: SMMU-v3[200201000000] Mapped to Proximity 
domain 2
[    4.968614] ACPI: IORT: SMMU-v3[200100000000] Mapped to Proximity 
domain 2
[    4.968650] ACPI: IORT: SMMU-v3[200140000000] Mapped to Proximity 
domain 2
[    4.969140] HEST: Table parsing has been initialized.
[    4.995328] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    4.995350] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    4.995464] acpi PNP0A08:00: _OSC: platform does not support [LTR]
[    4.995556] acpi PNP0A08:00: _OSC: OS now controls [PME PCIeCapability]
[    4.997336] acpi PNP0A08:00: [Firmware Bug]: ECAM area [mem 
0xd0000000-0xd3ffffff] not reserved in ACPI namespace
[    4.997369] acpi PNP0A08:00: ECAM at [mem 0xd0000000-0xd3ffffff] for 
[bus 00-3f]
[    4.997406] Remapped I/O 0x00000000efff0000 to [io  0x0000-0xffff window]
[    4.997475] PCI host bridge to bus 0000:00
[    4.997486] pci_bus 0000:00: root bus resource [mem 
0x80000000000-0x83fffffffff pref window]
[    4.997506] pci_bus 0000:00: root bus resource [mem 
0xe0000000-0xeffeffff window]
[    4.997523] pci_bus 0000:00: root bus resource [io  0x0000-0xffff window]
[    4.997539] pci_bus 0000:00: root bus resource [bus 00-3f]
[    4.997582] pci 0000:00:00.0: [19e5:a120] type 01 class 0x060400
[    4.997654] pci 0000:00:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.997728] pci 0000:00:04.0: [19e5:a120] type 01 class 0x060400
[    4.997793] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.997857] pci 0000:00:08.0: [19e5:a120] type 01 class 0x060400
[    4.997916] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.997978] pci 0000:00:0c.0: [19e5:a120] type 01 class 0x060400
[    4.998038] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.998105] pci 0000:00:10.0: [19e5:a120] type 01 class 0x060400
[    4.998172] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.998234] pci 0000:00:11.0: [19e5:a120] type 01 class 0x060400
[    4.998295] pci 0000:00:11.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.998356] pci 0000:00:12.0: [19e5:a120] type 01 class 0x060400
[    4.998417] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.998540] pci 0000:03:00.0: [1000:0097] type 00 class 0x010700
[    4.998560] pci 0000:03:00.0: reg 0x10: [io  0x0000-0x00ff]
[    4.998578] pci 0000:03:00.0: reg 0x14: [mem 0xe6440000-0xe644ffff 64bit]
[    4.998598] pci 0000:03:00.0: reg 0x1c: [mem 0xe6400000-0xe643ffff 64bit]
[    4.998619] pci 0000:03:00.0: reg 0x30: [mem 0xe6300000-0xe63fffff pref]
[    4.998636] pci 0000:03:00.0: enabling Extended Tags
[    4.998721] pci 0000:03:00.0: supports D1 D2
[    4.998829] pci 0000:05:00.0: [19e5:1710] type 00 class 0x118000
[    4.998860] pci 0000:05:00.0: reg 0x10: [mem 0xe0000000-0xe3ffffff pref]
[    4.998884] pci 0000:05:00.0: reg 0x14: [mem 0xe6200000-0xe62fffff]
[    4.999046] pci 0000:05:00.0: supports D1
[    4.999057] pci 0000:05:00.0: PME# supported from D0 D1 D3hot
[    4.999184] pci 0000:06:00.0: [19e5:1711] type 00 class 0x030000
[    4.999219] pci 0000:06:00.0: reg 0x10: [mem 0xe4000000-0xe5ffffff pref]
[    4.999246] pci 0000:06:00.0: reg 0x14: [mem 0xe6000000-0xe61fffff]
[    4.999440] pci 0000:06:00.0: supports D1
[    4.999450] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    4.999570] pci_bus 0000:00: on NUMA node 0
[    4.999579] pci 0000:00:10.0: BAR 14: assigned [mem 
0xe0000000-0xe5ffffff]
[    4.999596] pci 0000:00:11.0: BAR 14: assigned [mem 
0xe6000000-0xe8ffffff]
[    4.999612] pci 0000:00:08.0: BAR 14: assigned [mem 
0xe9000000-0xe91fffff]
[    4.999628] pci 0000:00:08.0: BAR 13: assigned [io  0x1000-0x1fff]
[    4.999643] pci 0000:00:00.0: PCI bridge to [bus 01]
[    4.999657] pci 0000:00:04.0: PCI bridge to [bus 02]
[    4.999671] pci 0000:03:00.0: BAR 6: assigned [mem 
0xe9000000-0xe90fffff pref]
[    4.999689] pci 0000:03:00.0: BAR 3: assigned [mem 
0xe9100000-0xe913ffff 64bit]
[    4.999709] pci 0000:03:00.0: BAR 1: assigned [mem 
0xe9140000-0xe914ffff 64bit]
[    4.999729] pci 0000:03:00.0: BAR 0: assigned [io  0x1000-0x10ff]
[    4.999744] pci 0000:00:08.0: PCI bridge to [bus 03]
[    4.999756] pci 0000:00:08.0:   bridge window [io  0x1000-0x1fff]
[    4.999771] pci 0000:00:08.0:   bridge window [mem 0xe9000000-0xe91fffff]
[    4.999788] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    4.999802] pci 0000:05:00.0: BAR 0: assigned [mem 
0xe0000000-0xe3ffffff pref]
[    4.999821] pci 0000:05:00.0: BAR 1: assigned [mem 0xe4000000-0xe40fffff]
[    4.999840] pci 0000:00:10.0: PCI bridge to [bus 05]
[    4.999852] pci 0000:00:10.0:   bridge window [mem 0xe0000000-0xe5ffffff]
[    4.999870] pci 0000:06:00.0: BAR 0: assigned [mem 
0xe6000000-0xe7ffffff pref]
[    4.999889] pci 0000:06:00.0: BAR 1: assigned [mem 0xe8000000-0xe81fffff]
[    4.999908] pci 0000:00:11.0: PCI bridge to [bus 06]
[    4.999920] pci 0000:00:11.0:   bridge window [mem 0xe6000000-0xe8ffffff]
[    4.999937] pci 0000:00:12.0: PCI bridge to [bus 07]
[    4.999951] pci_bus 0000:00: resource 4 [mem 
0x80000000000-0x83fffffffff pref window]
[    4.999969] pci_bus 0000:00: resource 5 [mem 0xe0000000-0xeffeffff 
window]
[    4.999985] pci_bus 0000:00: resource 6 [io  0x0000-0xffff window]
[    4.999999] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    5.000013] pci_bus 0000:03: resource 1 [mem 0xe9000000-0xe91fffff]
[    5.000027] pci_bus 0000:05: resource 1 [mem 0xe0000000-0xe5ffffff]
[    5.000042] pci_bus 0000:06: resource 1 [mem 0xe6000000-0xe8ffffff]
[    5.000097] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 7b])
[    5.000114] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.000222] acpi PNP0A08:01: _OSC: platform does not support [PME LTR]
[    5.000313] acpi PNP0A08:01: _OSC: OS now controls [PCIeCapability]
[    5.001966] acpi PNP0A08:01: [Firmware Bug]: ECAM area [mem 
0xd7b00000-0xd7bfffff] not reserved in ACPI namespace
[    5.002005] acpi PNP0A08:01: ECAM at [mem 0xd7b00000-0xd7bfffff] for 
[bus 7b]
[    5.002070] PCI host bridge to bus 0000:7b
[    5.002080] pci_bus 0000:7b: root bus resource [mem 
0x148800000-0x148ffffff pref window]
[    5.002099] pci_bus 0000:7b: root bus resource [bus 7b]
[    5.002118] pci 0000:7b:00.0: [19e5:a122] type 00 class 0x088000
[    5.002141] pci 0000:7b:00.0: reg 0x18: [mem 0x00000000-0x00003fff 
64bit pref]
[    5.002210] pci_bus 0000:7b: on NUMA node 0
[    5.002214] pci 0000:7b:00.0: BAR 2: assigned [mem 
0x148800000-0x148803fff 64bit pref]
[    5.002234] pci_bus 0000:7b: resource 4 [mem 0x148800000-0x148ffffff 
pref window]
[    5.002290] ACPI: PCI Root Bridge [PCI2] (domain 0000 [bus 7a])
[    5.002306] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.002410] acpi PNP0A08:02: _OSC: platform does not support [PME LTR]
[    5.002501] acpi PNP0A08:02: _OSC: OS now controls [PCIeCapability]
[    5.004139] acpi PNP0A08:02: [Firmware Bug]: ECAM area [mem 
0xd7a00000-0xd7afffff] not reserved in ACPI namespace
[    5.004176] acpi PNP0A08:02: ECAM at [mem 0xd7a00000-0xd7afffff] for 
[bus 7a]
[    5.004237] PCI host bridge to bus 0000:7a
[    5.004248] pci_bus 0000:7a: root bus resource [mem 
0x20c000000-0x20c1fffff pref window]
[    5.004266] pci_bus 0000:7a: root bus resource [bus 7a]
[    5.004284] pci 0000:7a:00.0: [19e5:a23b] type 00 class 0x0c0310
[    5.004301] pci 0000:7a:00.0: reg 0x10: [mem 0x20c100000-0x20c100fff 
64bit pref]
[    5.004358] pci 0000:7a:01.0: [19e5:a239] type 00 class 0x0c0320
[    5.004375] pci 0000:7a:01.0: reg 0x10: [mem 0x20c101000-0x20c101fff 
64bit pref]
[    5.004430] pci 0000:7a:02.0: [19e5:a238] type 00 class 0x0c0330
[    5.004447] pci 0000:7a:02.0: reg 0x10: [mem 0x20c000000-0x20c0fffff 
64bit pref]
[    5.004504] pci_bus 0000:7a: on NUMA node 0
[    5.004507] pci 0000:7a:02.0: BAR 0: assigned [mem 
0x20c000000-0x20c0fffff 64bit pref]
[    5.004526] pci 0000:7a:00.0: BAR 0: assigned [mem 
0x20c100000-0x20c100fff 64bit pref]
[    5.004546] pci 0000:7a:01.0: BAR 0: assigned [mem 
0x20c101000-0x20c101fff 64bit pref]
[    5.004565] pci_bus 0000:7a: resource 4 [mem 0x20c000000-0x20c1fffff 
pref window]
[    5.004616] ACPI: PCI Root Bridge [PCI3] (domain 0000 [bus 78-79])
[    5.004633] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.004738] acpi PNP0A08:03: _OSC: platform does not support [PME LTR]
[    5.004829] acpi PNP0A08:03: _OSC: OS now controls [PCIeCapability]
[    5.006480] acpi PNP0A08:03: [Firmware Bug]: ECAM area [mem 
0xd7800000-0xd79fffff] not reserved in ACPI namespace
[    5.006509] acpi PNP0A08:03: ECAM at [mem 0xd7800000-0xd79fffff] for 
[bus 78-79]
[    5.006579] PCI host bridge to bus 0000:78
[    5.006589] pci_bus 0000:78: root bus resource [mem 
0x208000000-0x208bfffff pref window]
[    5.006608] pci_bus 0000:78: root bus resource [bus 78-79]
[    5.006628] pci 0000:78:00.0: [19e5:a121] type 01 class 0x060400
[    5.006648] pci 0000:78:00.0: enabling Extended Tags
[    5.006722] pci 0000:78:01.0: [19e5:a25a] type 00 class 0x010400
[    5.006741] pci 0000:78:01.0: reg 0x18: [mem 0x208800000-0x208bfffff 
64bit pref]
[    5.006862] pci 0000:79:00.0: [19e5:a258] type 00 class 0x100000
[    5.006880] pci 0000:79:00.0: reg 0x18: [mem 0x208000000-0x2083fffff 
64bit pref]
[    5.006918] pci 0000:79:00.0: reg 0x22c: [mem 0x208400000-0x20840ffff 
64bit pref]
[    5.006936] pci 0000:79:00.0: VF(n) BAR2 space: [mem 
0x208400000-0x2087effff 64bit pref] (contains BAR2 for 63 VFs)
[    5.007066] pci_bus 0000:78: on NUMA node 0
[    5.007069] pci 0000:78:00.0: bridge window [mem 
0x00400000-0x007fffff 64bit pref] to [bus 79] add_size 400000 add_align 
400000
[    5.007098] pci 0000:78:00.0: BAR 15: assigned [mem 
0x208000000-0x2087fffff 64bit pref]
[    5.007117] pci 0000:78:01.0: BAR 2: assigned [mem 
0x208800000-0x208bfffff 64bit pref]
[    5.007137] pci 0000:79:00.0: BAR 2: assigned [mem 
0x208000000-0x2083fffff 64bit pref]
[    5.007156] pci 0000:79:00.0: BAR 9: assigned [mem 
0x208400000-0x2087effff 64bit pref]
[    5.007175] pci 0000:78:00.0: PCI bridge to [bus 79]
[    5.007189] pci 0000:78:00.0:   bridge window [mem 
0x208000000-0x2087fffff 64bit pref]
[    5.007208] pci_bus 0000:78: resource 4 [mem 0x208000000-0x208bfffff 
pref window]
[    5.007225] pci_bus 0000:79: resource 2 [mem 0x208000000-0x2087fffff 
64bit pref]
[    5.007282] ACPI: PCI Root Bridge [PCI4] (domain 0000 [bus 7c-7d])
[    5.007299] acpi PNP0A08:04: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.007404] acpi PNP0A08:04: _OSC: platform does not support [PME LTR]
[    5.007495] acpi PNP0A08:04: _OSC: OS now controls [PCIeCapability]
[    5.009133] acpi PNP0A08:04: [Firmware Bug]: ECAM area [mem 
0xd7c00000-0xd7dfffff] not reserved in ACPI namespace
[    5.009162] acpi PNP0A08:04: ECAM at [mem 0xd7c00000-0xd7dfffff] for 
[bus 7c-7d]
[    5.009227] PCI host bridge to bus 0000:7c
[    5.009238] pci_bus 0000:7c: root bus resource [mem 
0x120000000-0x13fffffff pref window]
[    5.009257] pci_bus 0000:7c: root bus resource [bus 7c-7d]
[    5.009275] pci 0000:7c:00.0: [19e5:a121] type 01 class 0x060400
[    5.009296] pci 0000:7c:00.0: enabling Extended Tags
[    5.009319] ACPI: IORT: [Firmware Bug]: [map (____ptrval____)] 
conflicting mapping for input ID 0x7c00
[    5.009340] ACPI: IORT: [Firmware Bug]: applying workaround.
[    5.009397] pci_bus 0000:7c: on NUMA node 0
[    5.009400] pci 0000:7c:00.0: PCI bridge to [bus 7d]
[    5.009414] pci_bus 0000:7c: resource 4 [mem 0x120000000-0x13fffffff 
pref window]
[    5.009466] ACPI: PCI Root Bridge [PCI5] (domain 0000 [bus 74-76])
[    5.009482] acpi PNP0A08:05: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.009590] acpi PNP0A08:05: _OSC: platform does not support [PME LTR]
[    5.009681] acpi PNP0A08:05: _OSC: OS now controls [PCIeCapability]
[    5.011325] acpi PNP0A08:05: [Firmware Bug]: ECAM area [mem 
0xd7400000-0xd76fffff] not reserved in ACPI namespace
[    5.011363] acpi PNP0A08:05: ECAM at [mem 0xd7400000-0xd76fffff] for 
[bus 74-76]
[    5.011443] PCI host bridge to bus 0000:74
[    5.011454] pci_bus 0000:74: root bus resource [mem 
0x141000000-0x141ffffff pref window]
[    5.011473] pci_bus 0000:74: root bus resource [mem 
0x144000000-0x145ffffff pref window]
[    5.011491] pci_bus 0000:74: root bus resource [mem 
0xa2000000-0xa2ffffff window]
[    5.011508] pci_bus 0000:74: root bus resource [bus 74-76]
[    5.011527] pci 0000:74:00.0: [19e5:a121] type 01 class 0x060400
[    5.011547] pci 0000:74:00.0: enabling Extended Tags
[    5.011614] pci 0000:74:01.0: [19e5:a121] type 01 class 0x060400
[    5.011635] pci 0000:74:01.0: enabling Extended Tags
[    5.011697] pci 0000:74:02.0: [19e5:a230] type 00 class 0x010700
[    5.011717] pci 0000:74:02.0: reg 0x24: [mem 0xa2008000-0xa200ffff]
[    5.011793] pci 0000:74:03.0: [19e5:a235] type 00 class 0x010601
[    5.011816] pci 0000:74:03.0: reg 0x24: [mem 0xa2010000-0xa2010fff]
[    5.011868] pci 0000:74:04.0: [19e5:a230] type 00 class 0x010700
[    5.011888] pci 0000:74:04.0: reg 0x24: [mem 0xa2000000-0xa2007fff]
[    5.011987] pci 0000:75:00.0: [19e5:a250] type 00 class 0x120000
[    5.012005] pci 0000:75:00.0: reg 0x18: [mem 0x144000000-0x1443fffff 
64bit pref]
[    5.012043] pci 0000:75:00.0: reg 0x22c: [mem 0x144400000-0x14440ffff 
64bit pref]
[    5.012061] pci 0000:75:00.0: VF(n) BAR2 space: [mem 
0x144400000-0x1447effff 64bit pref] (contains BAR2 for 63 VFs)
[    5.012179] pci 0000:76:00.0: [19e5:a255] type 00 class 0x100000
[    5.012198] pci 0000:76:00.0: reg 0x18: [mem 0x144800000-0x144bfffff 
64bit pref]
[    5.012236] pci 0000:76:00.0: reg 0x22c: [mem 0x144c00000-0x144c0ffff 
64bit pref]
[    5.012253] pci 0000:76:00.0: VF(n) BAR2 space: [mem 
0x144c00000-0x144feffff 64bit pref] (contains BAR2 for 63 VFs)
[    5.012353] pci_bus 0000:74: on NUMA node 0
[    5.012356] pci 0000:74:00.0: bridge window [mem 
0x00400000-0x007fffff 64bit pref] to [bus 75] add_size 400000 add_align 
400000
[    5.012383] pci 0000:74:01.0: bridge window [mem 
0x00400000-0x007fffff 64bit pref] to [bus 76] add_size 400000 add_align 
400000
[    5.012411] pci 0000:74:00.0: BAR 15: assigned [mem 
0x141000000-0x1417fffff 64bit pref]
[    5.012430] pci 0000:74:01.0: BAR 15: assigned [mem 
0x141800000-0x141ffffff 64bit pref]
[    5.012448] pci 0000:74:02.0: BAR 5: assigned [mem 0xa2000000-0xa2007fff]
[    5.012464] pci 0000:74:04.0: BAR 5: assigned [mem 0xa2008000-0xa200ffff]
[    5.012480] pci 0000:74:03.0: BAR 5: assigned [mem 0xa2010000-0xa2010fff]
[    5.012497] pci 0000:75:00.0: BAR 2: assigned [mem 
0x141000000-0x1413fffff 64bit pref]
[    5.012517] pci 0000:75:00.0: BAR 9: assigned [mem 
0x141400000-0x1417effff 64bit pref]
[    5.012535] pci 0000:74:00.0: PCI bridge to [bus 75]
[    5.012548] pci 0000:74:00.0:   bridge window [mem 
0x141000000-0x1417fffff 64bit pref]
[    5.012567] pci 0000:76:00.0: BAR 2: assigned [mem 
0x141800000-0x141bfffff 64bit pref]
[    5.012587] pci 0000:76:00.0: BAR 9: assigned [mem 
0x141c00000-0x141feffff 64bit pref]
[    5.012606] pci 0000:74:01.0: PCI bridge to [bus 76]
[    5.012618] pci 0000:74:01.0:   bridge window [mem 
0x141800000-0x141ffffff 64bit pref]
[    5.012637] pci_bus 0000:74: resource 4 [mem 0x141000000-0x141ffffff 
pref window]
[    5.012655] pci_bus 0000:74: resource 5 [mem 0x144000000-0x145ffffff 
pref window]
[    5.012672] pci_bus 0000:74: resource 6 [mem 0xa2000000-0xa2ffffff 
window]
[    5.012688] pci_bus 0000:75: resource 2 [mem 0x141000000-0x1417fffff 
64bit pref]
[    5.012705] pci_bus 0000:76: resource 2 [mem 0x141800000-0x141ffffff 
64bit pref]
[    5.012780] ACPI: PCI Root Bridge [PCI6] (domain 0000 [bus 80-9f])
[    5.012797] acpi PNP0A08:06: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.012903] acpi PNP0A08:06: _OSC: platform does not support [LTR]
[    5.012994] acpi PNP0A08:06: _OSC: OS now controls [PME PCIeCapability]
[    5.014641] acpi PNP0A08:06: [Firmware Bug]: ECAM area [mem 
0xd8000000-0xd9ffffff] not reserved in ACPI namespace
[    5.014672] acpi PNP0A08:06: ECAM at [mem 0xd8000000-0xd9ffffff] for 
[bus 80-9f]
[    5.014705] Remapped I/O 0x00000000ffff0000 to [io  0x10000-0x1ffff 
window]
[    5.014776] PCI host bridge to bus 0000:80
[    5.014787] pci_bus 0000:80: root bus resource [mem 
0x280000000000-0x283fffffffff pref window]
[    5.014806] pci_bus 0000:80: root bus resource [mem 
0xf0000000-0xfffeffff window]
[    5.014824] pci_bus 0000:80: root bus resource [io  0x10000-0x1ffff 
window] (bus address [0x0000-0xffff])
[    5.014846] pci_bus 0000:80: root bus resource [bus 80-9f]
[    5.014887] pci 0000:80:00.0: [19e5:a120] type 01 class 0x060400
[    5.014962] pci 0000:80:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.015032] pci 0000:80:04.0: [19e5:a120] type 01 class 0x060400
[    5.015105] pci 0000:80:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.015172] pci 0000:80:08.0: [19e5:a120] type 01 class 0x060400
[    5.015241] pci 0000:80:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.015307] pci 0000:80:0c.0: [19e5:a120] type 01 class 0x060400
[    5.015375] pci 0000:80:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.015440] pci 0000:80:10.0: [19e5:a120] type 01 class 0x060400
[    5.015508] pci 0000:80:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.015677] pci 0000:85:00.0: [19e5:3714] type 00 class 0x010802
[    5.015702] pci 0000:85:00.0: reg 0x10: [mem 0xf0040000-0xf004ffff 64bit]
[    5.015740] pci 0000:85:00.0: reg 0x24: [mem 0xf0020000-0xf003ffff]
[    5.015759] pci 0000:85:00.0: reg 0x30: [mem 0xf0000000-0xf001ffff pref]
[    5.015896] pci_bus 0000:80: on NUMA node 2
[    5.015901] pci 0000:80:10.0: BAR 14: assigned [mem 
0xf0000000-0xf00fffff]
[    5.015918] pci 0000:80:00.0: PCI bridge to [bus 81]
[    5.015932] pci 0000:80:04.0: PCI bridge to [bus 82]
[    5.015946] pci 0000:80:08.0: PCI bridge to [bus 83]
[    5.015960] pci 0000:80:0c.0: PCI bridge to [bus 84]
[    5.015974] pci 0000:85:00.0: BAR 5: assigned [mem 0xf0000000-0xf001ffff]
[    5.015991] pci 0000:85:00.0: BAR 6: assigned [mem 
0xf0020000-0xf003ffff pref]
[    5.016008] pci 0000:85:00.0: BAR 0: assigned [mem 
0xf0040000-0xf004ffff 64bit]
[    5.016029] pci 0000:80:10.0: PCI bridge to [bus 85]
[    5.016042] pci 0000:80:10.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    5.016059] pci_bus 0000:80: resource 4 [mem 
0x280000000000-0x283fffffffff pref window]
[    5.016077] pci_bus 0000:80: resource 5 [mem 0xf0000000-0xfffeffff 
window]
[    5.016093] pci_bus 0000:80: resource 6 [io  0x10000-0x1ffff window]
[    5.016108] pci_bus 0000:85: resource 1 [mem 0xf0000000-0xf00fffff]
[    5.016167] ACPI: PCI Root Bridge [PCI7] (domain 0000 [bus bb])
[    5.016183] acpi PNP0A08:07: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.016288] acpi PNP0A08:07: _OSC: platform does not support [PME LTR]
[    5.016379] acpi PNP0A08:07: _OSC: OS now controls [PCIeCapability]
[    5.018020] acpi PNP0A08:07: [Firmware Bug]: ECAM area [mem 
0xdbb00000-0xdbbfffff] not reserved in ACPI namespace
[    5.018057] acpi PNP0A08:07: ECAM at [mem 0xdbb00000-0xdbbfffff] for 
[bus bb]
[    5.018124] PCI host bridge to bus 0000:bb
[    5.018134] pci_bus 0000:bb: root bus resource [mem 
0x200148800000-0x200148ffffff pref window]
[    5.018158] pci_bus 0000:bb: root bus resource [bus bb]
[    5.018177] pci 0000:bb:00.0: [19e5:a122] type 00 class 0x088000
[    5.018197] pci 0000:bb:00.0: reg 0x18: [mem 0x00000000-0x00003fff 
64bit pref]
[    5.018273] pci_bus 0000:bb: on NUMA node 2
[    5.018276] pci 0000:bb:00.0: BAR 2: assigned [mem 
0x200148800000-0x200148803fff 64bit pref]
[    5.018298] pci_bus 0000:bb: resource 4 [mem 
0x200148800000-0x200148ffffff pref window]
[    5.018358] ACPI: PCI Root Bridge [PCI8] (domain 0000 [bus ba])
[    5.018374] acpi PNP0A08:08: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.018478] acpi PNP0A08:08: _OSC: platform does not support [PME LTR]
[    5.018569] acpi PNP0A08:08: _OSC: OS now controls [PCIeCapability]
[    5.020205] acpi PNP0A08:08: [Firmware Bug]: ECAM area [mem 
0xdba00000-0xdbafffff] not reserved in ACPI namespace
[    5.020242] acpi PNP0A08:08: ECAM at [mem 0xdba00000-0xdbafffff] for 
[bus ba]
[    5.020309] PCI host bridge to bus 0000:ba
[    5.020320] pci_bus 0000:ba: root bus resource [mem 
0x20020c000000-0x20020c1fffff pref window]
[    5.020340] pci_bus 0000:ba: root bus resource [bus ba]
[    5.020366] pci_bus 0000:ba: on NUMA node 2
[    5.020368] pci_bus 0000:ba: resource 4 [mem 
0x20020c000000-0x20020c1fffff pref window]
[    5.020426] ACPI: PCI Root Bridge [PCI9] (domain 0000 [bus b8-b9])
[    5.020442] acpi PNP0A08:09: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.020544] acpi PNP0A08:09: _OSC: platform does not support [PME LTR]
[    5.020635] acpi PNP0A08:09: _OSC: OS now controls [PCIeCapability]
[    5.022280] acpi PNP0A08:09: [Firmware Bug]: ECAM area [mem 
0xdb800000-0xdb9fffff] not reserved in ACPI namespace
[    5.022308] acpi PNP0A08:09: ECAM at [mem 0xdb800000-0xdb9fffff] for 
[bus b8-b9]
[    5.022388] PCI host bridge to bus 0000:b8
[    5.022398] pci_bus 0000:b8: root bus resource [mem 
0x200208000000-0x200208bfffff pref window]
[    5.022418] pci_bus 0000:b8: root bus resource [bus b8-b9]
[    5.022437] pci 0000:b8:00.0: [19e5:a121] type 01 class 0x060400
[    5.022460] pci 0000:b8:00.0: enabling Extended Tags
[    5.022545] pci 0000:b8:01.0: [19e5:a25a] type 00 class 0x010400
[    5.022565] pci 0000:b8:01.0: reg 0x18: [mem 
0x200208800000-0x200208bfffff 64bit pref]
[    5.022694] pci 0000:b9:00.0: [19e5:a258] type 00 class 0x100000
[    5.022714] pci 0000:b9:00.0: reg 0x18: [mem 
0x200208000000-0x2002083fffff 64bit pref]
[    5.022760] pci 0000:b9:00.0: reg 0x22c: [mem 
0x200208400000-0x20020840ffff 64bit pref]
[    5.022779] pci 0000:b9:00.0: VF(n) BAR2 space: [mem 
0x200208400000-0x2002087effff 64bit pref] (contains BAR2 for 63 VFs)
[    5.022904] pci_bus 0000:b8: on NUMA node 2
[    5.022907] pci 0000:b8:00.0: bridge window [mem 
0x00400000-0x007fffff 64bit pref] to [bus b9] add_size 400000 add_align 
400000
[    5.022935] pci 0000:b8:00.0: BAR 15: assigned [mem 
0x200208000000-0x2002087fffff 64bit pref]
[    5.022955] pci 0000:b8:01.0: BAR 2: assigned [mem 
0x200208800000-0x200208bfffff 64bit pref]
[    5.022977] pci 0000:b9:00.0: BAR 2: assigned [mem 
0x200208000000-0x2002083fffff 64bit pref]
[    5.022998] pci 0000:b9:00.0: BAR 9: assigned [mem 
0x200208400000-0x2002087effff 64bit pref]
[    5.023018] pci 0000:b8:00.0: PCI bridge to [bus b9]
[    5.023031] pci 0000:b8:00.0:   bridge window [mem 
0x200208000000-0x2002087fffff 64bit pref]
[    5.023051] pci_bus 0000:b8: resource 4 [mem 
0x200208000000-0x200208bfffff pref window]
[    5.023070] pci_bus 0000:b9: resource 2 [mem 
0x200208000000-0x2002087fffff 64bit pref]
[    5.023131] ACPI: PCI Root Bridge [PCIA] (domain 0000 [bus bc-bd])
[    5.023148] acpi PNP0A08:0a: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.023252] acpi PNP0A08:0a: _OSC: platform does not support [PME LTR]
[    5.023343] acpi PNP0A08:0a: _OSC: OS now controls [PCIeCapability]
[    5.024983] acpi PNP0A08:0a: [Firmware Bug]: ECAM area [mem 
0xdbc00000-0xdbdfffff] not reserved in ACPI namespace
[    5.025013] acpi PNP0A08:0a: ECAM at [mem 0xdbc00000-0xdbdfffff] for 
[bus bc-bd]
[    5.025081] PCI host bridge to bus 0000:bc
[    5.025091] pci_bus 0000:bc: root bus resource [mem 
0x200120000000-0x20013fffffff pref window]
[    5.025111] pci_bus 0000:bc: root bus resource [bus bc-bd]
[    5.025131] pci 0000:bc:00.0: [19e5:a121] type 01 class 0x060400
[    5.025153] pci 0000:bc:00.0: enabling Extended Tags
[    5.025179] ACPI: IORT: [Firmware Bug]: [map (____ptrval____)] 
conflicting mapping for input ID 0xbc00
[    5.025200] ACPI: IORT: [Firmware Bug]: applying workaround.
[    5.025275] pci 0000:bd:00.0: [19e5:a222] type 00 class 0x020000
[    5.025293] pci 0000:bd:00.0: reg 0x10: [mem 
0x2001210f0000-0x2001210fffff 64bit pref]
[    5.025314] pci 0000:bd:00.0: reg 0x18: [mem 
0x200120f00000-0x200120ffffff 64bit pref]
[    5.025358] pci 0000:bd:00.0: reg 0x224: [mem 
0x2001210c0000-0x2001210cffff 64bit pref]
[    5.025377] pci 0000:bd:00.0: VF(n) BAR0 space: [mem 
0x2001210c0000-0x2001210effff 64bit pref] (contains BAR0 for 3 VFs)
[    5.025404] pci 0000:bd:00.0: reg 0x22c: [mem 
0x200120c00000-0x200120cfffff 64bit pref]
[    5.025422] pci 0000:bd:00.0: VF(n) BAR2 space: [mem 
0x200120c00000-0x200120efffff 64bit pref] (contains BAR2 for 3 VFs)
[    5.025483] pci 0000:bd:00.1: [19e5:a221] type 00 class 0x020000
[    5.025501] pci 0000:bd:00.1: reg 0x10: [mem 
0x2001210b0000-0x2001210bffff 64bit pref]
[    5.025522] pci 0000:bd:00.1: reg 0x18: [mem 
0x200120b00000-0x200120bfffff 64bit pref]
[    5.025564] pci 0000:bd:00.1: reg 0x224: [mem 
0x200121080000-0x20012108ffff 64bit pref]
[    5.025582] pci 0000:bd:00.1: VF(n) BAR0 space: [mem 
0x200121080000-0x2001210affff 64bit pref] (contains BAR0 for 3 VFs)
[    5.025609] pci 0000:bd:00.1: reg 0x22c: [mem 
0x200120800000-0x2001208fffff 64bit pref]
[    5.025627] pci 0000:bd:00.1: VF(n) BAR2 space: [mem 
0x200120800000-0x200120afffff 64bit pref] (contains BAR2 for 3 VFs)
[    5.025685] pci 0000:bd:00.2: [19e5:a222] type 00 class 0x020000
[    5.025703] pci 0000:bd:00.2: reg 0x10: [mem 
0x200121070000-0x20012107ffff 64bit pref]
[    5.025723] pci 0000:bd:00.2: reg 0x18: [mem 
0x200120700000-0x2001207fffff 64bit pref]
[    5.025765] pci 0000:bd:00.2: reg 0x224: [mem 
0x200121040000-0x20012104ffff 64bit pref]
[    5.025783] pci 0000:bd:00.2: VF(n) BAR0 space: [mem 
0x200121040000-0x20012106ffff 64bit pref] (contains BAR0 for 3 VFs)
[    5.025810] pci 0000:bd:00.2: reg 0x22c: [mem 
0x200120400000-0x2001204fffff 64bit pref]
[    5.025828] pci 0000:bd:00.2: VF(n) BAR2 space: [mem 
0x200120400000-0x2001206fffff 64bit pref] (contains BAR2 for 3 VFs)
[    5.025885] pci 0000:bd:00.3: [19e5:a221] type 00 class 0x020000
[    5.025903] pci 0000:bd:00.3: reg 0x10: [mem 
0x200121030000-0x20012103ffff 64bit pref]
[    5.025924] pci 0000:bd:00.3: reg 0x18: [mem 
0x200120300000-0x2001203fffff 64bit pref]
[    5.025965] pci 0000:bd:00.3: reg 0x224: [mem 
0x200121000000-0x20012100ffff 64bit pref]
[    5.025983] pci 0000:bd:00.3: VF(n) BAR0 space: [mem 
0x200121000000-0x20012102ffff 64bit pref] (contains BAR0 for 3 VFs)
[    5.026010] pci 0000:bd:00.3: reg 0x22c: [mem 
0x200120000000-0x2001200fffff 64bit pref]
[    5.026028] pci 0000:bd:00.3: VF(n) BAR2 space: [mem 
0x200120000000-0x2001202fffff 64bit pref] (contains BAR2 for 3 VFs)
[    5.026091] pci_bus 0000:bc: on NUMA node 2
[    5.026094] pci 0000:bc:00.0: bridge window [mem 
0x00100000-0x005fffff 64bit pref] to [bus bd] add_size c00000 add_align 
100000
[    5.026122] pci 0000:bc:00.0: BAR 15: assigned [mem 
0x200120000000-0x2001210fffff 64bit pref]
[    5.026145] pci 0000:bd:00.0: BAR 2: assigned [mem 
0x200120000000-0x2001200fffff 64bit pref]
[    5.026170] pci 0000:bd:00.0: BAR 9: assigned [mem 
0x200120100000-0x2001203fffff 64bit pref]
[    5.026190] pci 0000:bd:00.1: BAR 2: assigned [mem 
0x200120400000-0x2001204fffff 64bit pref]
[    5.026211] pci 0000:bd:00.1: BAR 9: assigned [mem 
0x200120500000-0x2001207fffff 64bit pref]
[    5.026231] pci 0000:bd:00.2: BAR 2: assigned [mem 
0x200120800000-0x2001208fffff 64bit pref]
[    5.026251] pci 0000:bd:00.2: BAR 9: assigned [mem 
0x200120900000-0x200120bfffff 64bit pref]
[    5.026271] pci 0000:bd:00.3: BAR 2: assigned [mem 
0x200120c00000-0x200120cfffff 64bit pref]
[    5.026292] pci 0000:bd:00.3: BAR 9: assigned [mem 
0x200120d00000-0x200120ffffff 64bit pref]
[    5.026311] pci 0000:bd:00.0: BAR 0: assigned [mem 
0x200121000000-0x20012100ffff 64bit pref]
[    5.026332] pci 0000:bd:00.0: BAR 7: assigned [mem 
0x200121010000-0x20012103ffff 64bit pref]
[    5.026352] pci 0000:bd:00.1: BAR 0: assigned [mem 
0x200121040000-0x20012104ffff 64bit pref]
[    5.026372] pci 0000:bd:00.1: BAR 7: assigned [mem 
0x200121050000-0x20012107ffff 64bit pref]
[    5.026392] pci 0000:bd:00.2: BAR 0: assigned [mem 
0x200121080000-0x20012108ffff 64bit pref]
[    5.026413] pci 0000:bd:00.2: BAR 7: assigned [mem 
0x200121090000-0x2001210bffff 64bit pref]
[    5.026433] pci 0000:bd:00.3: BAR 0: assigned [mem 
0x2001210c0000-0x2001210cffff 64bit pref]
[    5.026453] pci 0000:bd:00.3: BAR 7: assigned [mem 
0x2001210d0000-0x2001210fffff 64bit pref]
[    5.026475] pci 0000:bc:00.0: PCI bridge to [bus bd]
[    5.026488] pci 0000:bc:00.0:   bridge window [mem 
0x200120000000-0x2001210fffff 64bit pref]
[    5.026508] pci_bus 0000:bc: resource 4 [mem 
0x200120000000-0x20013fffffff pref window]
[    5.026526] pci_bus 0000:bd: resource 2 [mem 
0x200120000000-0x2001210fffff 64bit pref]
[    5.026589] ACPI: PCI Root Bridge [PCIB] (domain 0000 [bus b4-b6])
[    5.026606] acpi PNP0A08:0b: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    5.026711] acpi PNP0A08:0b: _OSC: platform does not support [PME LTR]
[    5.026803] acpi PNP0A08:0b: _OSC: OS now controls [PCIeCapability]
[    5.028441] acpi PNP0A08:0b: [Firmware Bug]: ECAM area [mem 
0xdb400000-0xdb6fffff] not reserved in ACPI namespace
[    5.028478] acpi PNP0A08:0b: ECAM at [mem 0xdb400000-0xdb6fffff] for 
[bus b4-b6]
[    5.028565] PCI host bridge to bus 0000:b4
[    5.028575] pci_bus 0000:b4: root bus resource [mem 
0x200141000000-0x200141ffffff pref window]
[    5.028595] pci_bus 0000:b4: root bus resource [mem 
0x200144000000-0x200145ffffff pref window]
[    5.028614] pci_bus 0000:b4: root bus resource [mem 
0xa3000000-0xa3ffffff window]
[    5.028632] pci_bus 0000:b4: root bus resource [bus b4-b6]
[    5.028651] pci 0000:b4:00.0: [19e5:a121] type 01 class 0x060400
[    5.028673] pci 0000:b4:00.0: enabling Extended Tags
[    5.028745] pci 0000:b4:01.0: [19e5:a121] type 01 class 0x060400
[    5.028768] pci 0000:b4:01.0: enabling Extended Tags
[    5.028841] pci 0000:b4:02.0: [19e5:a230] type 00 class 0x010700
[    5.028863] pci 0000:b4:02.0: reg 0x24: [mem 0xa3008000-0xa300ffff]
[    5.028943] pci 0000:b4:03.0: [19e5:a235] type 00 class 0x010601
[    5.028968] pci 0000:b4:03.0: reg 0x24: [mem 0xa3010000-0xa3010fff]
[    5.029024] pci 0000:b4:04.0: [19e5:a230] type 00 class 0x010700
[    5.029046] pci 0000:b4:04.0: reg 0x24: [mem 0xa3000000-0xa3007fff]
[    5.029154] pci 0000:b5:00.0: [19e5:a250] type 00 class 0x120000
[    5.029174] pci 0000:b5:00.0: reg 0x18: [mem 
0x200144000000-0x2001443fffff 64bit pref]
[    5.029220] pci 0000:b5:00.0: reg 0x22c: [mem 
0x200144400000-0x20014440ffff 64bit pref]
[    5.029238] pci 0000:b5:00.0: VF(n) BAR2 space: [mem 
0x200144400000-0x2001447effff 64bit pref] (contains BAR2 for 63 VFs)
[    5.029373] pci 0000:b6:00.0: [19e5:a255] type 00 class 0x100000
[    5.029393] pci 0000:b6:00.0: reg 0x18: [mem 
0x200144800000-0x200144bfffff 64bit pref]
[    5.029439] pci 0000:b6:00.0: reg 0x22c: [mem 
0x200144c00000-0x200144c0ffff 64bit pref]
[    5.029457] pci 0000:b6:00.0: VF(n) BAR2 space: [mem 
0x200144c00000-0x200144feffff 64bit pref] (contains BAR2 for 63 VFs)
[    5.029569] pci_bus 0000:b4: on NUMA node 2
[    5.029572] pci 0000:b4:00.0: bridge window [mem 
0x00400000-0x007fffff 64bit pref] to [bus b5] add_size 400000 add_align 
400000
[    5.029599] pci 0000:b4:01.0: bridge window [mem 
0x00400000-0x007fffff 64bit pref] to [bus b6] add_size 400000 add_align 
400000
[    5.029627] pci 0000:b4:00.0: BAR 15: assigned [mem 
0x200141000000-0x2001417fffff 64bit pref]
[    5.029646] pci 0000:b4:01.0: BAR 15: assigned [mem 
0x200141800000-0x200141ffffff 64bit pref]
[    5.029666] pci 0000:b4:02.0: BAR 5: assigned [mem 0xa3000000-0xa3007fff]
[    5.029682] pci 0000:b4:04.0: BAR 5: assigned [mem 0xa3008000-0xa300ffff]
[    5.029699] pci 0000:b4:03.0: BAR 5: assigned [mem 0xa3010000-0xa3010fff]
[    5.029716] pci 0000:b5:00.0: BAR 2: assigned [mem 
0x200141000000-0x2001413fffff 64bit pref]
[    5.029737] pci 0000:b5:00.0: BAR 9: assigned [mem 
0x200141400000-0x2001417effff 64bit pref]
[    5.029757] pci 0000:b4:00.0: PCI bridge to [bus b5]
[    5.029770] pci 0000:b4:00.0:   bridge window [mem 
0x200141000000-0x2001417fffff 64bit pref]
[    5.029790] pci 0000:b6:00.0: BAR 2: assigned [mem 
0x200141800000-0x200141bfffff 64bit pref]
[    5.029811] pci 0000:b6:00.0: BAR 9: assigned [mem 
0x200141c00000-0x200141feffff 64bit pref]
[    5.029831] pci 0000:b4:01.0: PCI bridge to [bus b6]
[    5.029844] pci 0000:b4:01.0:   bridge window [mem 
0x200141800000-0x200141ffffff 64bit pref]
[    5.029864] pci_bus 0000:b4: resource 4 [mem 
0x200141000000-0x200141ffffff pref window]
[    5.029882] pci_bus 0000:b4: resource 5 [mem 
0x200144000000-0x200145ffffff pref window]
[    5.029900] pci_bus 0000:b4: resource 6 [mem 0xa3000000-0xa3ffffff 
window]
[    5.029916] pci_bus 0000:b5: resource 2 [mem 
0x200141000000-0x2001417fffff 64bit pref]
[    5.029934] pci_bus 0000:b6: resource 2 [mem 
0x200141800000-0x200141ffffff 64bit pref]
[    5.037294] iommu: Default domain type: Translated
[    5.037385] pci 0000:06:00.0: vgaarb: VGA device added: 
decodes=io+mem,owns=none,locks=none
[    5.037415] pci 0000:06:00.0: vgaarb: bridge control possible
[    5.037431] pci 0000:06:00.0: vgaarb: setting as boot device (VGA 
legacy resources not available)
[    5.037451] vgaarb: loaded
[    5.037641] SCSI subsystem initialized
[    5.037748] libata version 3.00 loaded.
[    5.037798] ACPI: bus type USB registered
[    5.037823] usbcore: registered new interface driver usbfs
[    5.037845] usbcore: registered new interface driver hub
[    5.037921] usbcore: registered new device driver usb
[    5.038200] pps_core: LinuxPPS API ver. 1 registered
[    5.038213] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    5.038235] PTP clock support registered
[    5.038282] EDAC MC: Ver: 3.0.0
[    5.038534] Registered efivars operations
[    5.040440] FPGA manager framework
[    5.040467] Advanced Linux Sound Architecture Driver Initialized.
[    5.041212] clocksource: Switched to clocksource arch_sys_counter
[    5.041395] VFS: Disk quotas dquot_6.6.0
[    5.041431] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    5.041521] pnp: PnP ACPI init
[    5.042157] pnp 00:00: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.042537] pnp: PnP ACPI: found 1 devices
[    5.043693] NET: Registered protocol family 2
[    5.043869] tcp_listen_portaddr_hash hash table entries: 32768 
(order: 7, 524288 bytes, vmalloc)
[    5.044184] TCP established hash table entries: 524288 (order: 10, 
4194304 bytes, vmalloc)
[    5.045332] TCP bind hash table entries: 65536 (order: 8, 1048576 
bytes, vmalloc)
[    5.045557] TCP: Hash tables configured (established 524288 bind 65536)
[    5.045757] UDP hash table entries: 32768 (order: 8, 1048576 bytes, 
vmalloc)
[    5.046118] UDP-Lite hash table entries: 32768 (order: 8, 1048576 
bytes, vmalloc)
[    5.046803] NET: Registered protocol family 1
[    5.047168] RPC: Registered named UNIX socket transport module.
[    5.047182] RPC: Registered udp transport module.
[    5.047193] RPC: Registered tcp transport module.
[    5.047204] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.047238] pci 0000:7a:00.0: enabling device (0000 -> 0002)
[    5.047269] pci 0000:7a:02.0: enabling device (0000 -> 0002)
[    5.047334] PCI: CLS 32 bytes, default 64
[    5.047381] Unpacking initramfs...
[    5.996590] Freeing initrd memory: 77856K
[    6.001214] hw perfevents: enabled with armv8_pmuv3_0 PMU driver, 13 
counters available
[    6.001548] kvm [1]: IPA Size Limit: 48 bits
[    6.001609] kvm [1]: GICv4 support disabled
[    6.001620] kvm [1]: vgic-v2@9b020000
[    6.001647] kvm [1]: GIC system register CPU interface enabled
[    6.002889] kvm [1]: vgic interrupt IRQ9
[    6.004172] kvm [1]: VHE mode initialized successfully
[    6.007111] Initialise system trusted keyrings
[    6.007204] workingset: timestamp_bits=42 max_order=24 bucket_order=0
[    6.008514] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    6.008706] NFS: Registering the id_resolver key type
[    6.008723] Key type id_resolver registered
[    6.008734] Key type id_legacy registered
[    6.008763] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    6.008804] 9p: Installing v9fs 9p2000 file system support
[    6.021196] Key type asymmetric registered
[    6.021207] Asymmetric key parser 'x509' registered
[    6.021226] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 245)
[    6.021243] io scheduler mq-deadline registered
[    6.021254] io scheduler kyber registered
[    6.028352] ACPI: IORT: [Firmware Bug]: [map (____ptrval____)] 
conflicting mapping for input ID 0x7c00
[    6.028375] ACPI: IORT: [Firmware Bug]: applying workaround.
[    6.028434] ACPI: IORT: [Firmware Bug]: [map (____ptrval____)] 
conflicting mapping for input ID 0xbc00
[    6.028455] ACPI: IORT: [Firmware Bug]: applying workaround.
[    6.029782] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    6.029824] ACPI: Power Button [PWRB]
[    6.045255] thermal LNXTHERM:00: registered as thermal_zone0
[    6.045270] ACPI: Thermal Zone [TZ00] (50 C)
[    6.052860] thermal LNXTHERM:01: registered as thermal_zone1
[    6.052874] ACPI: Thermal Zone [TZ01] (50 C)
[    6.053174] ERST: Error Record Serialization Table (ERST) support is 
initialized.
[    6.053193] pstore: Registered erst as persistent store backend
[    6.053349] EDAC MC0: Giving out device to module ghes_edac.c 
controller ghes_edac: DEV ghes (INTERRUPT)
[    6.053568] GHES: APEI firmware first mode is enabled by APEI bit and 
WHEA _OSC.
[    6.053620] EINJ: Error INJection is initialized.
[    6.053727] ACPI GTDT: found 1 SBSA generic Watchdog(s).
[    6.058271] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.078738] 00:00: ttyS0 at MMIO 0x3f00002f8 (irq = 17, base_baud = 
115200) is a 16550A
[    6.078777] printk: console [ttyS0] enabled
[    6.082953] printk: bootconsole [pl11] disabled
[    6.088465] SuperH (H)SCI(F) driver initialized
[    6.093134] msm_serial: driver initialized
[    6.097556] arm-smmu-v3 arm-smmu-v3.0.auto: option mask 0x0
[    6.103124] arm-smmu-v3 arm-smmu-v3.0.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.111489] arm-smmu-v3 arm-smmu-v3.0.auto: allocated 65536 entries 
for cmdq
[    6.118585] arm-smmu-v3 arm-smmu-v3.0.auto: allocated 32768 entries 
for evtq
[    6.125875] arm-smmu-v3 arm-smmu-v3.1.auto: option mask 0x0
[    6.131441] arm-smmu-v3 arm-smmu-v3.1.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.139630] arm-smmu-v3 arm-smmu-v3.1.auto: allocated 65536 entries 
for cmdq
[    6.146740] arm-smmu-v3 arm-smmu-v3.1.auto: allocated 32768 entries 
for evtq
[    6.153891] arm-smmu-v3 arm-smmu-v3.2.auto: option mask 0x0
[    6.159452] arm-smmu-v3 arm-smmu-v3.2.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.167734] arm-smmu-v3 arm-smmu-v3.2.auto: allocated 65536 entries 
for cmdq
[    6.174831] arm-smmu-v3 arm-smmu-v3.2.auto: allocated 32768 entries 
for evtq
[    6.181962] arm-smmu-v3 arm-smmu-v3.3.auto: option mask 0x0
[    6.187536] arm-smmu-v3 arm-smmu-v3.3.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.195725] arm-smmu-v3 arm-smmu-v3.3.auto: allocated 65536 entries 
for cmdq
[    6.202835] arm-smmu-v3 arm-smmu-v3.3.auto: allocated 32768 entries 
for evtq
[    6.209975] arm-smmu-v3 arm-smmu-v3.4.auto: option mask 0x0
[    6.215549] arm-smmu-v3 arm-smmu-v3.4.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.223835] arm-smmu-v3 arm-smmu-v3.4.auto: allocated 65536 entries 
for cmdq
[    6.230929] arm-smmu-v3 arm-smmu-v3.4.auto: allocated 32768 entries 
for evtq
[    6.238069] arm-smmu-v3 arm-smmu-v3.5.auto: option mask 0x0
[    6.243639] arm-smmu-v3 arm-smmu-v3.5.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.251826] arm-smmu-v3 arm-smmu-v3.5.auto: allocated 65536 entries 
for cmdq
[    6.258938] arm-smmu-v3 arm-smmu-v3.5.auto: allocated 32768 entries 
for evtq
[    6.266085] arm-smmu-v3 arm-smmu-v3.6.auto: option mask 0x0
[    6.271654] arm-smmu-v3 arm-smmu-v3.6.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.279936] arm-smmu-v3 arm-smmu-v3.6.auto: allocated 65536 entries 
for cmdq
[    6.287031] arm-smmu-v3 arm-smmu-v3.6.auto: allocated 32768 entries 
for evtq
[    6.294174] arm-smmu-v3 arm-smmu-v3.7.auto: option mask 0x0
[    6.299745] arm-smmu-v3 arm-smmu-v3.7.auto: ias 48-bit, oas 48-bit 
(features 0x00001fef)
[    6.307933] arm-smmu-v3 arm-smmu-v3.7.auto: allocated 65536 entries 
for cmdq
[    6.315044] arm-smmu-v3 arm-smmu-v3.7.auto: allocated 32768 entries 
for evtq
[    6.345619] loop: module loaded
[    6.349224] megasas: 07.714.04.00-rc1
[    6.352912] mpt3sas version 36.100.00.00 loaded
[    6.357832] mpt3sas 0000:03:00.0: Adding to iommu group 0
[    6.364607] mpt3sas_cm0: 63 BIT PCI BUS DMA ADDRESSING SUPPORTED, 
total mem (65269816 kB)
[    6.430379] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default 
host page size to 4k
[    6.438363] mpt3sas_cm0: MSI-X vectors supported: 96
[    6.443307]   no of cores: 128, max_msix_vectors: -1
[    6.448250] mpt3sas_cm0:  0 96
[    6.453078] mpt3sas_cm0: High IOPs queues : disabled
[    6.458026] mpt3sas0-msix0: PCI-MSI-X enabled: IRQ 42
[    6.463056] mpt3sas0-msix1: PCI-MSI-X enabled: IRQ 43
[    6.468084] mpt3sas0-msix2: PCI-MSI-X enabled: IRQ 44
[    6.473111] mpt3sas0-msix3: PCI-MSI-X enabled: IRQ 45
[    6.478140] mpt3sas0-msix4: PCI-MSI-X enabled: IRQ 46
[    6.483168] mpt3sas0-msix5: PCI-MSI-X enabled: IRQ 47
[    6.488198] mpt3sas0-msix6: PCI-MSI-X enabled: IRQ 48
[    6.493226] mpt3sas0-msix7: PCI-MSI-X enabled: IRQ 49
[    6.498255] mpt3sas0-msix8: PCI-MSI-X enabled: IRQ 50
[    6.503282] mpt3sas0-msix9: PCI-MSI-X enabled: IRQ 51
[    6.508310] mpt3sas0-msix10: PCI-MSI-X enabled: IRQ 52
[    6.513427] mpt3sas0-msix11: PCI-MSI-X enabled: IRQ 53
[    6.518542] mpt3sas0-msix12: PCI-MSI-X enabled: IRQ 54
[    6.523657] mpt3sas0-msix13: PCI-MSI-X enabled: IRQ 55
[    6.528772] mpt3sas0-msix14: PCI-MSI-X enabled: IRQ 56
[    6.533886] mpt3sas0-msix15: PCI-MSI-X enabled: IRQ 57
[    6.539001] mpt3sas0-msix16: PCI-MSI-X enabled: IRQ 58
[    6.544115] mpt3sas0-msix17: PCI-MSI-X enabled: IRQ 59
[    6.549229] mpt3sas0-msix18: PCI-MSI-X enabled: IRQ 60
[    6.554345] mpt3sas0-msix19: PCI-MSI-X enabled: IRQ 61
[    6.559461] mpt3sas0-msix20: PCI-MSI-X enabled: IRQ 62
[    6.564576] mpt3sas0-msix21: PCI-MSI-X enabled: IRQ 63
[    6.569692] mpt3sas0-msix22: PCI-MSI-X enabled: IRQ 64
[    6.574807] mpt3sas0-msix23: PCI-MSI-X enabled: IRQ 65
[    6.579923] mpt3sas0-msix24: PCI-MSI-X enabled: IRQ 66
[    6.585039] mpt3sas0-msix25: PCI-MSI-X enabled: IRQ 67
[    6.590155] mpt3sas0-msix26: PCI-MSI-X enabled: IRQ 68
[    6.595270] mpt3sas0-msix27: PCI-MSI-X enabled: IRQ 69
[    6.600386] mpt3sas0-msix28: PCI-MSI-X enabled: IRQ 70
[    6.605501] mpt3sas0-msix29: PCI-MSI-X enabled: IRQ 71
[    6.610615] mpt3sas0-msix30: PCI-MSI-X enabled: IRQ 72
[    6.615731] mpt3sas0-msix31: PCI-MSI-X enabled: IRQ 73
[    6.620847] mpt3sas0-msix32: PCI-MSI-X enabled: IRQ 74
[    6.625961] mpt3sas0-msix33: PCI-MSI-X enabled: IRQ 75
[    6.631077] mpt3sas0-msix34: PCI-MSI-X enabled: IRQ 76
[    6.636191] mpt3sas0-msix35: PCI-MSI-X enabled: IRQ 77
[    6.641307] mpt3sas0-msix36: PCI-MSI-X enabled: IRQ 78
[    6.646422] mpt3sas0-msix37: PCI-MSI-X enabled: IRQ 79
[    6.651536] mpt3sas0-msix38: PCI-MSI-X enabled: IRQ 80
[    6.656651] mpt3sas0-msix39: PCI-MSI-X enabled: IRQ 81
[    6.661766] mpt3sas0-msix40: PCI-MSI-X enabled: IRQ 82
[    6.666882] mpt3sas0-msix41: PCI-MSI-X enabled: IRQ 83
[    6.671997] mpt3sas0-msix42: PCI-MSI-X enabled: IRQ 84
[    6.677113] mpt3sas0-msix43: PCI-MSI-X enabled: IRQ 85
[    6.682228] mpt3sas0-msix44: PCI-MSI-X enabled: IRQ 86
[    6.687344] mpt3sas0-msix45: PCI-MSI-X enabled: IRQ 87
[    6.692459] mpt3sas0-msix46: PCI-MSI-X enabled: IRQ 88
[    6.697575] mpt3sas0-msix47: PCI-MSI-X enabled: IRQ 89
[    6.702691] mpt3sas0-msix48: PCI-MSI-X enabled: IRQ 90
[    6.707804] mpt3sas0-msix49: PCI-MSI-X enabled: IRQ 91
[    6.712920] mpt3sas0-msix50: PCI-MSI-X enabled: IRQ 92
[    6.718035] mpt3sas0-msix51: PCI-MSI-X enabled: IRQ 93
[    6.723151] mpt3sas0-msix52: PCI-MSI-X enabled: IRQ 94
[    6.728267] mpt3sas0-msix53: PCI-MSI-X enabled: IRQ 95
[    6.733382] mpt3sas0-msix54: PCI-MSI-X enabled: IRQ 96
[    6.738499] mpt3sas0-msix55: PCI-MSI-X enabled: IRQ 97
[    6.743614] mpt3sas0-msix56: PCI-MSI-X enabled: IRQ 98
[    6.748730] mpt3sas0-msix57: PCI-MSI-X enabled: IRQ 99
[    6.753845] mpt3sas0-msix58: PCI-MSI-X enabled: IRQ 100
[    6.759047] mpt3sas0-msix59: PCI-MSI-X enabled: IRQ 101
[    6.764249] mpt3sas0-msix60: PCI-MSI-X enabled: IRQ 102
[    6.769450] mpt3sas0-msix61: PCI-MSI-X enabled: IRQ 103
[    6.774651] mpt3sas0-msix62: PCI-MSI-X enabled: IRQ 104
[    6.779853] mpt3sas0-msix63: PCI-MSI-X enabled: IRQ 105
[    6.785054] mpt3sas0-msix64: PCI-MSI-X enabled: IRQ 106
[    6.790255] mpt3sas0-msix65: PCI-MSI-X enabled: IRQ 107
[    6.795456] mpt3sas0-msix66: PCI-MSI-X enabled: IRQ 108
[    6.800657] mpt3sas0-msix67: PCI-MSI-X enabled: IRQ 109
[    6.805859] mpt3sas0-msix68: PCI-MSI-X enabled: IRQ 110
[    6.811060] mpt3sas0-msix69: PCI-MSI-X enabled: IRQ 111
[    6.816262] mpt3sas0-msix70: PCI-MSI-X enabled: IRQ 112
[    6.821463] mpt3sas0-msix71: PCI-MSI-X enabled: IRQ 113
[    6.826664] mpt3sas0-msix72: PCI-MSI-X enabled: IRQ 114
[    6.831865] mpt3sas0-msix73: PCI-MSI-X enabled: IRQ 115
[    6.837066] mpt3sas0-msix74: PCI-MSI-X enabled: IRQ 116
[    6.842267] mpt3sas0-msix75: PCI-MSI-X enabled: IRQ 117
[    6.847469] mpt3sas0-msix76: PCI-MSI-X enabled: IRQ 118
[    6.852670] mpt3sas0-msix77: PCI-MSI-X enabled: IRQ 119
[    6.857877] mpt3sas0-msix78: PCI-MSI-X enabled: IRQ 120
[    6.863078] mpt3sas0-msix79: PCI-MSI-X enabled: IRQ 121
[    6.868279] mpt3sas0-msix80: PCI-MSI-X enabled: IRQ 122
[    6.873479] mpt3sas0-msix81: PCI-MSI-X enabled: IRQ 123
[    6.878681] mpt3sas0-msix82: PCI-MSI-X enabled: IRQ 124
[    6.883882] mpt3sas0-msix83: PCI-MSI-X enabled: IRQ 125
[    6.889083] mpt3sas0-msix84: PCI-MSI-X enabled: IRQ 126
[    6.894284] mpt3sas0-msix85: PCI-MSI-X enabled: IRQ 127
[    6.899485] mpt3sas0-msix86: PCI-MSI-X enabled: IRQ 128
[    6.904686] mpt3sas0-msix87: PCI-MSI-X enabled: IRQ 129
[    6.909888] mpt3sas0-msix88: PCI-MSI-X enabled: IRQ 130
[    6.915089] mpt3sas0-msix89: PCI-MSI-X enabled: IRQ 131
[    6.920290] mpt3sas0-msix90: PCI-MSI-X enabled: IRQ 132
[    6.925491] mpt3sas0-msix91: PCI-MSI-X enabled: IRQ 133
[    6.930693] mpt3sas0-msix92: PCI-MSI-X enabled: IRQ 134
[    6.935894] mpt3sas0-msix93: PCI-MSI-X enabled: IRQ 135
[    6.941095] mpt3sas0-msix94: PCI-MSI-X enabled: IRQ 136
[    6.946296] mpt3sas0-msix95: PCI-MSI-X enabled: IRQ 137
[    6.951497] mpt3sas_cm0: iomem(0x00000000e9140000), 
mapped(0x(____ptrval____)), size(65536)
[    6.959811] mpt3sas_cm0: ioport(0x0000000000001000), size(256)
[    7.023261] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default 
host page size to 4k
[    7.031231] mpt3sas_cm0: sending diag reset !!
[    8.163945] mpt3sas_cm0: diag reset: SUCCESS
[    8.198753] mpt3sas_cm0: scatter gather: sge_in_main_msg(1), 
sge_per_chain(7), sge_per_io(128), chains_per_io(19)
[    8.210423] mpt3sas_cm0: request pool(0x(____ptrval____)) - 
dma(0xff300000): depth(4224), frame_size(128), pool_size(528 kB)
[    8.245300] mpt3sas_cm0: sense pool(0x(____ptrval____))- 
dma(0xfe900000): depth(3963),element_size(96), pool_size(371 kB)
[    8.256323] mpt3sas_cm0: config page(0x(____ptrval____)) - 
dma(0xfe7f6000): size(512)
[    8.264120] mpt3sas_cm0: Allocated physical memory: size(8344 kB)
[    8.270186] mpt3sas_cm0: Current Controller Queue Depth(3960),Max 
Controller Queue Depth(4096)
[    8.278756] mpt3sas_cm0: Scatter Gather Elements per IO(128)
[    8.482803] mpt3sas_cm0: _base_display_fwpkg_version: complete
[    8.488897] mpt3sas_cm0: LSISAS3008: FWVersion(12.00.02.00), 
ChipRevision(0x02), BiosVersion(14.00.00.00)
[    8.498423] mpt3sas_cm0: Protocol=(Initiator), 
Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set 
Full,NCQ)
[    8.509932] scsi host0: Fusion MPT SAS Host
[    8.515036] mpt3sas_cm0: sending port enable !!
[   10.335524] mpt3sas_cm0: hba_port entry: (____ptrval____), port: 255 
is added to hba_port list
[   10.345090] mpt3sas_cm0: host_add: handle(0x0001), 
sas_addr(0x538bc015c17bd000), phys(8)
[   10.354400] mpt3sas_cm0: expander_add: handle(0x0009), 
parent(0x0001), sas_addr(0x500e004aaaaaaa1f), phys(25)
[   10.364633]  expander-0:0: add: handle(0x0009), 
sas_addr(0x500e004aaaaaaa1f)
[   10.373859] random: fast init done
[   22.601115] mpt3sas_cm0: port enable: SUCCESS
[   22.605978] scsi 0:0:0:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.614039] scsi 0:0:0:0: SSP: handle(0x000a), 
sas_addr(0x5000cca04ec29801), phy(0), device_name(0x5000cca04ec29803)
[   22.624510] scsi 0:0:0:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(0)
[   22.631610] scsi 0:0:0:0: enclosure level(0x0000), connector name(     )
[   22.638299] scsi 0:0:0:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.645663]  end_device-0:0:0: add: handle(0x000a), 
sas_addr(0x5000cca04ec29801)
[   22.653472] scsi 0:0:1:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.661547] scsi 0:0:1:0: SSP: handle(0x000b), 
sas_addr(0x5000cca04ec29805), phy(1), device_name(0x5000cca04ec29807)
[   22.672018] scsi 0:0:1:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(1)
[   22.679120] scsi 0:0:1:0: enclosure level(0x0000), connector name(     )
[   22.685793] scsi 0:0:1:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.693164]  end_device-0:0:1: add: handle(0x000b), 
sas_addr(0x5000cca04ec29805)
[   22.700967] scsi 0:0:2:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.709042] scsi 0:0:2:0: SSP: handle(0x000c), 
sas_addr(0x5000cca04ec2ee7d), phy(2), device_name(0x5000cca04ec2ee7f)
[   22.719513] scsi 0:0:2:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(2)
[   22.726615] scsi 0:0:2:0: enclosure level(0x0000), connector name(     )
[   22.733287] scsi 0:0:2:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.740654]  end_device-0:0:2: add: handle(0x000c), 
sas_addr(0x5000cca04ec2ee7d)
[   22.748429] scsi 0:0:3:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.756504] scsi 0:0:3:0: SSP: handle(0x000d), 
sas_addr(0x5000cca04ec2be65), phy(3), device_name(0x5000cca04ec2be67)
[   22.766975] scsi 0:0:3:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(3)
[   22.774077] scsi 0:0:3:0: enclosure level(0x0000), connector name(     )
[   22.780748] scsi 0:0:3:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.788106]  end_device-0:0:3: add: handle(0x000d), 
sas_addr(0x5000cca04ec2be65)
[   22.795882] scsi 0:0:4:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.803958] scsi 0:0:4:0: SSP: handle(0x000e), 
sas_addr(0x5000cca04ec2b855), phy(4), device_name(0x5000cca04ec2b857)
[   22.814429] scsi 0:0:4:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(4)
[   22.821531] scsi 0:0:4:0: enclosure level(0x0000), connector name(     )
[   22.828203] scsi 0:0:4:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.835552]  end_device-0:0:4: add: handle(0x000e), 
sas_addr(0x5000cca04ec2b855)
[   22.843417] scsi 0:0:5:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.851492] scsi 0:0:5:0: SSP: handle(0x000f), 
sas_addr(0x5000cca04ec2a70d), phy(5), device_name(0x5000cca04ec2a70f)
[   22.861963] scsi 0:0:5:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(5)
[   22.869064] scsi 0:0:5:0: enclosure level(0x0000), connector name(     )
[   22.875734] scsi 0:0:5:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.883102]  end_device-0:0:5: add: handle(0x000f), 
sas_addr(0x5000cca04ec2a70d)
[   22.890899] scsi 0:0:6:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.898976] scsi 0:0:6:0: SSP: handle(0x0010), 
sas_addr(0x5000cca04ec2c9ad), phy(6), device_name(0x5000cca04ec2c9af)
[   22.909447] scsi 0:0:6:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(6)
[   22.916549] scsi 0:0:6:0: enclosure level(0x0000), connector name(     )
[   22.923221] scsi 0:0:6:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.930587]  end_device-0:0:6: add: handle(0x0010), 
sas_addr(0x5000cca04ec2c9ad)
[   22.938388] scsi 0:0:7:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.946464] scsi 0:0:7:0: SSP: handle(0x0011), 
sas_addr(0x5000cca04ec2f17d), phy(7), device_name(0x5000cca04ec2f17f)
[   22.956935] scsi 0:0:7:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(7)
[   22.964036] scsi 0:0:7:0: enclosure level(0x0000), connector name(     )
[   22.970708] scsi 0:0:7:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   22.978077]  end_device-0:0:7: add: handle(0x0011), 
sas_addr(0x5000cca04ec2f17d)
[   22.985882] scsi 0:0:8:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   22.993957] scsi 0:0:8:0: SSP: handle(0x0012), 
sas_addr(0x5000cca04ec2d825), phy(8), device_name(0x5000cca04ec2d827)
[   23.004429] scsi 0:0:8:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(8)
[   23.011531] scsi 0:0:8:0: enclosure level(0x0000), connector name(     )
[   23.018202] scsi 0:0:8:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   23.025567]  end_device-0:0:8: add: handle(0x0012), 
sas_addr(0x5000cca04ec2d825)
[   23.033376] scsi 0:0:9:0: Direct-Access     HGST     HUSMM1640ASS204 
C2D0 PQ: 0 ANSI: 6
[   23.041450] scsi 0:0:9:0: SSP: handle(0x0013), 
sas_addr(0x5000cca04ec04479), phy(9), device_name(0x5000cca04ec0447b)
[   23.051921] scsi 0:0:9:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(9)
[   23.059024] scsi 0:0:9:0: enclosure level(0x0000), connector name(     )
[   23.065696] scsi 0:0:9:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   23.073060]  end_device-0:0:9: add: handle(0x0013), 
sas_addr(0x5000cca04ec04479)
[   23.080955] scsi 0:0:10:0: Direct-Access     HGST     HUSMM1640ASS204 
  C2D0 PQ: 0 ANSI: 6
[   23.089124] scsi 0:0:10:0: SSP: handle(0x0014), 
sas_addr(0x5000cca04ec2cbdd), phy(10), device_name(0x5000cca04ec2cbdf)
[   23.099768] scsi 0:0:10:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(10)
[   23.107042] scsi 0:0:10:0: enclosure level(0x0000), connector name(     )
[   23.113801] scsi 0:0:10:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   23.121258]  end_device-0:0:10: add: handle(0x0014), 
sas_addr(0x5000cca04ec2cbdd)
[   23.129147] scsi 0:0:11:0: Direct-Access     HGST     HUSMM1640ASS204 
  C2D0 PQ: 0 ANSI: 6
[   23.137310] scsi 0:0:11:0: SSP: handle(0x0015), 
sas_addr(0x5000cca04ec2f36d), phy(11), device_name(0x5000cca04ec2f36f)
[   23.147954] scsi 0:0:11:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(11)
[   23.155228] scsi 0:0:11:0: enclosure level(0x0000), connector name(     )
[   23.161987] scsi 0:0:11:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   23.169440]  end_device-0:0:11: add: handle(0x0015), 
sas_addr(0x5000cca04ec2f36d)
[   23.177551] scsi 0:0:12:0: Enclosure         HUAWEI   Expander 12Gx16 
  131  PQ: 0 ANSI: 6
[   23.185714] scsi 0:0:12:0: set ignore_delay_remove for handle(0x0016)
[   23.192124] scsi 0:0:12:0: SES: handle(0x0016), 
sas_addr(0x500e004aaaaaaa1e), phy(24), device_name(0x0000000000000000)
[   23.202767] scsi 0:0:12:0: enclosure logical id (0x500e004aaaaaaa1e), 
slot(24)
[   23.210040] scsi 0:0:12:0: enclosure level(0x0000), connector name(     )
[   23.216800] scsi 0:0:12:0: qdepth(254), tagged(1), scsi_level(7), 
cmd_que(1)
[   23.224684]  end_device-0:0:12: add: handle(0x0016), 
sas_addr(0x500e004aaaaaaa1e)
[   23.232763] hisi_sas_v3_hw 0000:74:02.0: Adding to iommu group 1
[   23.232923] sd 0:0:0:0: [sda] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233082] sd 0:0:1:0: [sdb] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233087] sd 0:0:1:0: [sdb] 4096-byte physical blocks
[   23.233093] sd 0:0:2:0: [sdc] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233097] sd 0:0:2:0: [sdc] 4096-byte physical blocks
[   23.233097] sd 0:0:3:0: [sdd] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233100] sd 0:0:3:0: [sdd] 4096-byte physical blocks
[   23.233178] sd 0:0:4:0: [sde] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233181] sd 0:0:4:0: [sde] 4096-byte physical blocks
[   23.233191] sd 0:0:1:0: [sdb] Write Protect is off
[   23.233194] sd 0:0:1:0: [sdb] Mode Sense: f7 00 10 08
[   23.233204] sd 0:0:2:0: [sdc] Write Protect is off
[   23.233204] sd 0:0:3:0: [sdd] Write Protect is off
[   23.233206] sd 0:0:2:0: [sdc] Mode Sense: f7 00 10 08
[   23.233206] sd 0:0:3:0: [sdd] Mode Sense: f7 00 10 08
[   23.233210] sd 0:0:5:0: [sdf] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233212] sd 0:0:5:0: [sdf] 4096-byte physical blocks
[   23.233259] sd 0:0:6:0: [sdg] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233262] sd 0:0:6:0: [sdg] 4096-byte physical blocks
[   23.233288] sd 0:0:4:0: [sde] Write Protect is off
[   23.233290] sd 0:0:4:0: [sde] Mode Sense: f7 00 10 08
[   23.233315] sd 0:0:5:0: [sdf] Write Protect is off
[   23.233318] sd 0:0:5:0: [sdf] Mode Sense: f7 00 10 08
[   23.233323] sd 0:0:7:0: [sdh] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233326] sd 0:0:7:0: [sdh] 4096-byte physical blocks
[   23.233329] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233339] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233342] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233357] sd 0:0:8:0: [sdi] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233360] sd 0:0:8:0: [sdi] 4096-byte physical blocks
[   23.233367] sd 0:0:6:0: [sdg] Write Protect is off
[   23.233369] sd 0:0:6:0: [sdg] Mode Sense: f7 00 10 08
[   23.233424] sd 0:0:4:0: [sde] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233429] sd 0:0:7:0: [sdh] Write Protect is off
[   23.233432] sd 0:0:7:0: [sdh] Mode Sense: f7 00 10 08
[   23.233450] sd 0:0:5:0: [sdf] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233451] sd 0:0:10:0: [sdk] 781422768 512-byte logical blocks: 
(400 GB/373 GiB)
[   23.233455] sd 0:0:10:0: [sdk] 4096-byte physical blocks
[   23.233458] sd 0:0:9:0: [sdj] 781422768 512-byte logical blocks: (400 
GB/373 GiB)
[   23.233461] sd 0:0:9:0: [sdj] 4096-byte physical blocks
[   23.233463] sd 0:0:8:0: [sdi] Write Protect is off
[   23.233466] sd 0:0:8:0: [sdi] Mode Sense: f7 00 10 08
[   23.233498] sd 0:0:11:0: [sdl] 781422768 512-byte logical blocks: 
(400 GB/373 GiB)
[   23.233501] sd 0:0:11:0: [sdl] 4096-byte physical blocks
[   23.233503] sd 0:0:6:0: [sdg] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233562] sd 0:0:10:0: [sdk] Write Protect is off
[   23.233564] sd 0:0:10:0: [sdk] Mode Sense: f7 00 10 08
[   23.233565] sd 0:0:9:0: [sdj] Write Protect is off
[   23.233565] sd 0:0:7:0: [sdh] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233568] sd 0:0:9:0: [sdj] Mode Sense: f7 00 10 08
[   23.233600] sd 0:0:8:0: [sdi] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233605] sd 0:0:11:0: [sdl] Write Protect is off
[   23.233607] sd 0:0:11:0: [sdl] Mode Sense: f7 00 10 08
[   23.233698] sd 0:0:9:0: [sdj] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233699] sd 0:0:10:0: [sdk] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.233737] sd 0:0:11:0: [sdl] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.531824] hisi_sas_v3_hw 0000:74:02.0: enabling device (0000 -> 0002)
[   23.531825] sd 0:0:0:0: [sda] 4096-byte physical blocks
[   23.535540] sd 0:0:1:0: [sdb] Attached SCSI disk
[   23.548196] hisi_sas_v3_hw 0000:74:02.0: 16 hw queues
[   23.548464] sd 0:0:0:0: [sda] Write Protect is off
[   23.548996]  sdc:
[   23.553253] scsi host1: hisi_sas_v3_hw
[   23.555136] sd 0:0:11:0: [sdl] Attached SCSI disk
[   23.555272] sd 0:0:4:0: [sde] Attached SCSI disk
[   23.555284] sd 0:0:10:0: [sdk] Attached SCSI disk
[   23.555365] sd 0:0:2:0: [sdc] Attached SCSI disk
[   23.555479] sd 0:0:9:0: [sdj] Attached SCSI disk
[   23.555540] sd 0:0:3:0: [sdd] Attached SCSI disk
[   23.555551] sd 0:0:5:0: [sdf] Attached SCSI disk
[   23.555558] sd 0:0:8:0: [sdi] Attached SCSI disk
[   23.555568] sd 0:0:7:0: [sdh] Attached SCSI disk
[   23.555582] sd 0:0:6:0: [sdg] Attached SCSI disk
[   23.558021] sd 0:0:0:0: [sda] Mode Sense: f7 00 10 08
[   23.609971] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   23.673015] sd 0:0:0:0: [sda] Attached SCSI disk
[   25.773201] hisi_sas_v3_hw 0000:74:04.0: Adding to iommu group 2
[   25.780244] hisi_sas_v3_hw 0000:74:04.0: enabling device (0000 -> 0002)
[   25.796882] hisi_sas_v3_hw 0000:74:04.0: 16 hw queues
[   25.801929] scsi host2: hisi_sas_v3_hw
[   28.017272] hisi_sas_v3_hw 0000:b4:02.0: Adding to iommu group 3
[   28.024470] hisi_sas_v3_hw 0000:b4:02.0: enabling device (0000 -> 0002)
[   28.041431] hisi_sas_v3_hw 0000:b4:02.0: 16 hw queues
[   28.046472] scsi host3: hisi_sas_v3_hw
[   30.261224] hisi_sas_v3_hw 0000:b4:04.0: Adding to iommu group 4
[   30.268285] hisi_sas_v3_hw 0000:b4:04.0: enabling device (0000 -> 0002)
[   30.285082] hisi_sas_v3_hw 0000:b4:04.0: 16 hw queues
[   30.290131] scsi host4: hisi_sas_v3_hw
[   32.505261] ahci 0000:74:03.0: Adding to iommu group 5
[   32.511597] ahci 0000:74:03.0: version 3.0
[   32.511749] ahci 0000:74:03.0: SSS flag set, parallel bus scan disabled
[   32.518351] ahci 0000:74:03.0: AHCI 0001.0300 32 slots 2 ports 6 Gbps 
0x3 impl SATA mode
[   32.526407] ahci 0000:74:03.0: flags: 64bit ncq sntf stag pm led clo 
only pmp fbs slum part ccc ems sxs boh
[   32.536467] scsi host5: ahci
[   32.539547] scsi host6: ahci
[   32.542464] ata1: SATA max UDMA/133 abar m4096@0xa2010000 port 
0xa2010100 irq 266
[   32.549915] ata2: SATA max UDMA/133 abar m4096@0xa2010000 port 
0xa2010180 irq 267
[   32.557446] ahci 0000:b4:03.0: Adding to iommu group 6
[   32.563948] ahci 0000:b4:03.0: SSS flag set, parallel bus scan disabled
[   32.570563] ahci 0000:b4:03.0: AHCI 0001.0300 32 slots 2 ports 6 Gbps 
0x3 impl SATA mode
[   32.578618] ahci 0000:b4:03.0: flags: 64bit ncq sntf stag pm led clo 
only pmp fbs slum part ccc ems sxs boh
[   32.588747] scsi host7: ahci
[   32.591800] scsi host8: ahci
[   32.594724] ata3: SATA max UDMA/133 abar m4096@0xa3010000 port 
0xa3010100 irq 268
[   32.602176] ata4: SATA max UDMA/133 abar m4096@0xa3010000 port 
0xa3010180 irq 269
[   32.611317] libphy: Fixed MDIO Bus: probed
[   32.615775] tun: Universal TUN/TAP device driver, 1.6
[   32.621077] thunder_xcv, ver 1.0
[   32.624315] thunder_bgx, ver 1.0
[   32.627544] nicpf, ver 1.0
[   32.630773] hclge is initializing
[   32.634182] hns3: Hisilicon Ethernet Network Driver for Hip08 Family 
- version
[   32.641372] hns3: Copyright (c) 2017 Huawei Corporation.
[   32.646768] hns3 0000:bd:00.0: Adding to iommu group 7
[   32.653034] hns3 0000:bd:00.0: The firmware version is 1.10.0.11
[   32.662422] libphy: hisilicon MII bus: probed
[   32.730424] hns3 0000:bd:00.0: hclge driver initialization finished.
[   32.737472] Generic PHY mii-0000:bd:00.0:01: attached PHY driver 
(mii_bus:phy_addr=mii-0000:bd:00.0:01, irq=POLL)
[   32.748094] hns3 0000:bd:00.1: Adding to iommu group 8
[   32.754534] hns3 0000:bd:00.1: The firmware version is 1.10.0.11
[   32.762116] libphy: hisilicon MII bus: probed
[   32.830106] hns3 0000:bd:00.1: hclge driver initialization finished.
[   32.837162] Generic PHY mii-0000:bd:00.1:03: attached PHY driver 
(mii_bus:phy_addr=mii-0000:bd:00.1:03, irq=POLL)
[   32.847707] hns3 0000:bd:00.2: Adding to iommu group 9
[   32.854298] hns3 0000:bd:00.2: The firmware version is 1.10.0.11
[   32.862592] libphy: hisilicon MII bus: probed
[   32.871273] ata1: SATA link down (SStatus 0 SControl 300)
[   32.923269] ata3: SATA link down (SStatus 0 SControl 300)
[   32.974436] hns3 0000:bd:00.2: hclge driver initialization finished.
[   32.981479] Generic PHY mii-0000:bd:00.2:05: attached PHY driver 
(mii_bus:phy_addr=mii-0000:bd:00.2:05, irq=POLL)
[   32.992019] hns3 0000:bd:00.3: Adding to iommu group 10
[   32.998581] hns3 0000:bd:00.3: The firmware version is 1.10.0.11
[   33.006151] libphy: hisilicon MII bus: probed
[   33.094141] hns3 0000:bd:00.3: hclge driver initialization finished.
[   33.101180] Generic PHY mii-0000:bd:00.3:07: attached PHY driver 
(mii_bus:phy_addr=mii-0000:bd:00.3:07, irq=POLL)
[   33.111708] e1000: Intel(R) PRO/1000 Network Driver
[   33.116573] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   33.122320] e1000e: Intel(R) PRO/1000 Network Driver
[   33.127263] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   33.133184] igb: Intel(R) Gigabit Ethernet Network Driver
[   33.138559] igb: Copyright (c) 2007-2014 Intel Corporation.
[   33.144122] igbvf: Intel(R) Gigabit Virtual Function Network Driver
[   33.150361] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   33.156491] sky2: driver version 1.30
[   33.160586] VFIO - User Level meta-driver version: 0.3
[   33.166401] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   33.172908] ehci-pci: EHCI PCI platform driver
[   33.177458] ehci-pci 0000:7a:01.0: Adding to iommu group 11
[   33.184423] ehci-pci 0000:7a:01.0: EHCI Host Controller
[   33.189641] ehci-pci 0000:7a:01.0: new USB bus registered, assigned 
bus number 1
[   33.191249] ata2: SATA link down (SStatus 0 SControl 300)
[   33.197007] ehci-pci 0000:7a:01.0: applying Synopsys HC workaround
[   33.197047] ehci-pci 0000:7a:01.0: irq 660, io mem 0x20c101000
[   33.229121] ehci-pci 0000:7a:01.0: USB 0.0 started, EHCI 1.00
[   33.234994] hub 1-0:1.0: USB hub found
[   33.238734] hub 1-0:1.0: 2 ports detected
[   33.242840] ehci-platform: EHCI generic platform driver
[   33.248133] ehci-orion: EHCI orion driver
[   33.252171] ehci-exynos: EHCI Exynos driver
[   33.256377] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   33.262539] ohci-pci: OHCI PCI platform driver
[   33.267016] ohci-pci 0000:7a:00.0: Adding to iommu group 12
[   33.273755] ohci-pci 0000:7a:00.0: OHCI PCI host controller
[   33.279311] ohci-pci 0000:7a:00.0: new USB bus registered, assigned 
bus number 2
[   33.286705] ohci-pci 0000:7a:00.0: irq 661, io mem 0x20c100000
[   33.353247] hub 2-0:1.0: USB hub found
[   33.356983] hub 2-0:1.0: 2 ports detected
[   33.361093] ohci-platform: OHCI generic platform driver
[   33.366370] ohci-exynos: OHCI Exynos driver
[   33.370641] xhci_hcd 0000:7a:02.0: Adding to iommu group 13
[   33.377537] xhci_hcd 0000:7a:02.0: xHCI Host Controller
[   33.382747] xhci_hcd 0000:7a:02.0: new USB bus registered, assigned 
bus number 3
[   33.390175] xhci_hcd 0000:7a:02.0: hcc params 0x0220f66d hci version 
0x100 quirks 0x0000000000000010
[   33.399472] hub 3-0:1.0: USB hub found
[   33.403211] hub 3-0:1.0: 1 port detected
[   33.407189] xhci_hcd 0000:7a:02.0: xHCI Host Controller
[   33.412394] xhci_hcd 0000:7a:02.0: new USB bus registered, assigned 
bus number 4
[   33.419758] xhci_hcd 0000:7a:02.0: Host supports USB 3.0 SuperSpeed
[   33.426007] usb usb4: We don't know the algorithms for LPM for this 
host, disabling LPM.
[   33.434159] hub 4-0:1.0: USB hub found
[   33.437897] hub 4-0:1.0: 1 port detected
[   33.442061] usbcore: registered new interface driver usb-storage
[   33.465246] rtc-efi rtc-efi.0: registered as rtc0
[   33.478139] rtc-efi rtc-efi.0: setting system clock to 
2021-01-13T14:41:05 UTC (1610548865)
[   33.486725] i2c /dev entries driver
[   33.491642] sbsa-gwdt sbsa-gwdt.0: Initialized with 10s timeout @ 
100000000 Hz, action=0.
[   33.500630] sdhci: Secure Digital Host Controller Interface driver
[   33.506786] sdhci: Copyright(c) Pierre Ossman
[   33.511374] Synopsys Designware Multimedia Card Interface Driver
[   33.515241] ata4: SATA link down (SStatus 0 SControl 300)
[   33.517690] sdhci-pltfm: SDHCI platform and OF driver helper
[   33.530499] ledtrig-cpu: registered to indicate activity on CPUs
[   33.537378] pstore: ignoring unexpected backend 'efi'
[   33.542696] usbcore: registered new interface driver usbhid
[   33.548249] usbhid: USB HID core driver
[   33.577121] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   33.629009] NET: Registered protocol family 17
[   33.633497] 9pnet: Installing 9P2000 support
[   33.637768] Key type dns_resolver registered
[   33.642118] registered taskstats version 1
[   33.646201] Loading compiled-in X.509 certificates
[   33.651063] pstore: Using crash dump compression: deflate
[   33.656944] pcieport 0000:00:00.0: Adding to iommu group 14
[   33.664237] pcieport 0000:00:00.0: PME: Signaling with IRQ 719
[   33.670147] pcieport 0000:00:04.0: Adding to iommu group 15
[   33.677289] pcieport 0000:00:04.0: PME: Signaling with IRQ 720
[   33.683285] pcieport 0000:00:08.0: Adding to iommu group 16
[   33.690431] pcieport 0000:00:08.0: PME: Signaling with IRQ 721
[   33.696432] pcieport 0000:00:0c.0: Adding to iommu group 17
[   33.703463] pcieport 0000:00:0c.0: PME: Signaling with IRQ 722
[   33.709367] pcieport 0000:00:10.0: Adding to iommu group 18
[   33.716436] pcieport 0000:00:10.0: PME: Signaling with IRQ 723
[   33.722338] pcieport 0000:00:11.0: Adding to iommu group 19
[   33.729480] pcieport 0000:00:11.0: PME: Signaling with IRQ 724
[   33.735381] pcieport 0000:00:12.0: Adding to iommu group 20
[   33.742470] pcieport 0000:00:12.0: PME: Signaling with IRQ 725
[   33.745117] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[   33.748425] pcieport 0000:78:00.0: Adding to iommu group 21
[   33.755758] hub 1-1:1.0: USB hub found
[   33.761447] ACPI: IORT: [Firmware Bug]: [map (____ptrval____)] 
conflicting mapping for input ID 0x7c00
[   33.764727] hub 1-1:1.0: 4 ports detected
[   33.773406] ACPI: IORT: [Firmware Bug]: applying workaround.
[   33.783048] pcieport 0000:7c:00.0: Adding to iommu group 22
[   33.789646] pcieport 0000:74:00.0: Adding to iommu group 23
[   33.796440] pcieport 0000:74:01.0: Adding to iommu group 24
[   33.803019] pcieport 0000:80:00.0: Adding to iommu group 25
[   33.810303] pcieport 0000:80:00.0: PME: Signaling with IRQ 726
[   33.816265] pcieport 0000:80:04.0: Adding to iommu group 26
[   33.823395] pcieport 0000:80:04.0: PME: Signaling with IRQ 727
[   33.829340] pcieport 0000:80:08.0: Adding to iommu group 27
[   33.836437] pcieport 0000:80:08.0: PME: Signaling with IRQ 728
[   33.842373] pcieport 0000:80:0c.0: Adding to iommu group 28
[   33.849481] pcieport 0000:80:0c.0: PME: Signaling with IRQ 729
[   33.855420] pcieport 0000:80:10.0: Adding to iommu group 29
[   33.862552] pcieport 0000:80:10.0: PME: Signaling with IRQ 730
[   33.868534] pcieport 0000:b8:00.0: Adding to iommu group 30
[   33.875193] ACPI: IORT: [Firmware Bug]: [map (____ptrval____)] 
conflicting mapping for input ID 0xbc00
[   33.884468] ACPI: IORT: [Firmware Bug]: applying workaround.
[   33.890177] pcieport 0000:bc:00.0: Adding to iommu group 31
[   33.896777] pcieport 0000:b4:00.0: Adding to iommu group 32
[   33.903481] pcieport 0000:b4:01.0: Adding to iommu group 33
[   33.910264] ALSA device list:
[   33.913237]   No soundcards found.
[   33.917873] Freeing unused kernel memory: 5760K
[   33.922492] Run /init as init process
[   33.926142]   with arguments:
[   33.926143]     /init
[   33.926144]   with environment:
[   33.926145]     HOME=/
[   33.926146]     TERM=linux
[   33.926147]     BOOT_IMAGE=/john/Image
[   33.933791] /dev/sda2: Can't open blockdev
[   33.956651] random: sshd: uninitialized urandom read (32 bytes read)
[   33.970173] hub 3-1:1.0: USB hub found
[   33.974811] hub 3-1:1.0: 4 ports detected
[   34.034113] usb 4-1: new SuperSpeed Gen 1 USB device number 2 using 
xhci_hcd
[   34.077116] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[   34.100808] hub 4-1:1.0: USB hub found
[   34.105587] hub 4-1:1.0: 4 ports detected
[   34.272832] input: Keyboard/Mouse KVM 1.1.0 as 
/devices/pci0000:7a/0000:7a:01.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:12D1:0003.0001/input/input1
[   34.345237] hid-generic 0003:12D1:0003.0001: input: USB HID v1.10 
Keyboard [Keyboard/Mouse KVM 1.1.0] on usb-0000:7a:01.0-1.1/input0
[   34.368245] input: Keyboard/Mouse KVM 1.1.0 as 
/devices/pci0000:7a/0000:7a:01.0/usb1/1-1/1-1.1/1-1.1:1.1/0003:12D1:0003.0002/input/input2
[   34.380562] hid-generic 0003:12D1:0003.0002: input: USB HID v1.10 
Mouse [Keyboard/Mouse KVM 1.1.0] on usb-0000:7a:01.0-1.1/input1
estuary:/$
