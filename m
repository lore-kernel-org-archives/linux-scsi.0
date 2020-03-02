Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F4FC3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 12:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E0A22173E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 12:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgCBMNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 07:13:19 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2492 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726654AbgCBMNT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 07:13:19 -0500
Received: from lhreml707-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id CB4197B6BA0567E7A420;
        Mon,  2 Mar 2020 12:13:17 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml707-cah.china.huawei.com (10.201.108.48) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 12:13:17 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 2 Mar 2020
 12:13:17 +0000
Subject: Re: megaraid_sas problem for scsi_add_host() fail
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <8f9838bb-d59a-90d9-fd22-87945320e976@huawei.com>
 <CAL2rwxpGQxjzCSY7qTGqRD+bE+jKJFkedZ3f-vOr3Khfo_cy9A@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <fd0361aa-781e-9e18-53a9-b46b9c0cbbcf@huawei.com>
Date:   Mon, 2 Mar 2020 12:13:16 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAL2rwxpGQxjzCSY7qTGqRD+bE+jKJFkedZ3f-vOr3Khfo_cy9A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Hi Sumit,

> It is megaraid_sas driver bug. Driver does not freeup resources properly, when
> scsi_add_host() fails. Please try attached patch.

Yeah, that looks to work. The driver gracefully failed to bind.

However we might have lots of memory leaks:


root@(none)$ echo scan > /sys/kernel/debug/kmemleak
root@(none)$ [  140.585484] kmemleak: 259 new suspected memory leaks 
(see /sys/kernel/debug/kmemleak)
[  140.585484] kmemleak: 259 new suspected memory leaks (see 
/sys/kernel/debug/kmemleak)

root@(none)$
root@(none)$ more /sys/kernel/debug/kmemleak
unreferenced object 0xffff0026b9184c00 (size 512):
   comm "kworker/0:0", pid 5, jiffies 4294903201 (age 95.768s)
   hex dump (first 32 bytes):
     60 00 00 00 61 00 00 00 62 00 00 00 63 00 00 00  `...a...b...c...
     64 00 00 00 65 00 00 00 66 00 00 00 67 00 00 00  d...e...f...g...
   backtrace:
     [<(____ptrval____)>] slab_post_alloc_hook+0x6c/0xa0
     [<(____ptrval____)>] __kmalloc+0x174/0x280
     [<(____ptrval____)>] megasas_probe_one+0x798/0x2878
     [<(____ptrval____)>] local_pci_probe+0x74/0xf0
     [<(____ptrval____)>] work_for_cpu_fn+0x2c/0x48
     [<(____ptrval____)>] process_one_work+0x488/0xc08
     [<(____ptrval____)>] worker_thread+0x330/0x5d0
     [<(____ptrval____)>] kthread+0x1c8/0x1d0
     [<(____ptrval____)>] ret_from_fork+0x10/0x18
unreferenced object 0xffff0026b922c000 (size 4096):
   comm "kworker/0:0", pid 5, jiffies 4294903201 (age 95.768s)
   hex dump (first 32 bytes):
     00 00 21 b7 26 00 ff ff 00 00 9f ff 00 00 00 00  ..!.&...........
     00 10 22 10 00 a0 ff ff 00 00 00 00 00 00 00 00  ..".............
   backtrace:
     [<(____ptrval____)>] slab_post_alloc_hook+0x6c/0xa0
     [<(____ptrval____)>] kmem_cache_alloc_trace+0x140/0x228
     [<(____ptrval____)>] megasas_alloc_fusion_context+0x30/0x1b0
     [<(____ptrval____)>] megasas_probe_one+0x7d8/0x2878
     [<(____ptrval____)>] local_pci_probe+0x74/0xf0
     [<(____ptrval____)>] work_for_cpu_fn+0x2c/0x48
     [<(____ptrval____)>] process_one_work+0x488/0xc08
     [<(____ptrval____)>] worker_thread+0x330/0x5d0
     [<(____ptrval____)>] kthread+0x1c8/0x1d0
     [<(____ptrval____)>] ret_from_fork+0x10/0x18
unreferenced object 0xffff0026b7013000 (size 2048):
   comm "kworker/0:0", pid 5, jiffies 4294903512 (age 94.540s)
   hex dump (first 32 bytes):
     00 58 18 b9 26 00 ff ff 00 5c 18 b9 26 00 ff ff  .X..&....\..&...
     00 60 18 b9 26 00 ff ff 00 64 18 b9 26 00 ff ff  .`..&....d..&...
   backtrace:
     [<(____ptrval____)>] slab_post_alloc_hook+0x6c/0xa0
     [<(____ptrval____)>] kmem_cache_alloc_trace+0x140/0x228
root@(none)$


Thanks,
John

> 
> Thanks,
> Sumit
>>
>> [   62.516871] megasas: 07.713.01.00-rc1
>> [   62.526189] megaraid_sas 0000:08:00.0: Adding to iommu group 1
>> [   62.571790] megaraid_sas 0000:08:00.0: BAR:0x0  BAR's
>> base_addr(phys):0x0000080010000000  mapped virt_addr:0x(____ptrval____)
>> [   62.571802] megaraid_sas 0000:08:00.0: FW now in Ready state
>> [   62.583811] megaraid_sas 0000:08:00.0: 63 bit DMA mask and 63 bit
>> consistent mask
>> [   62.602143] megaraid_sas 0000:08:00.0: firmware supports msix : (128)
>> [   62.780250] megaraid_sas 0000:08:00.0: requested/available msix 128/128
>> [   62.794292] megaraid_sas 0000:08:00.0: current msix/online cpus :
>> (128/128)
>> [   62.809011] megaraid_sas 0000:08:00.0: RDPQ mode : (enabled)
>> [   62.820968] megaraid_sas 0000:08:00.0: Current firmware supports
>> maximum commands: 4077 LDIO threshold: 0
>> [   62.937043] megaraid_sas 0000:08:00.0: Configured max firmware
>> commands: 4076
>> [   63.509185] megaraid_sas 0000:08:00.0: Performance mode :Latency
>> [   63.521906] megaraid_sas 0000:08:00.0: FW supports sync cache : Yes
>> [   63.535148] megaraid_sas 0000:08:00.0: megasas_disable_intr_fusion is
>> called outbound_intr_mask:0x40000009
>> [   63.610607] megaraid_sas 0000:08:00.0: FW provided supportMaxExtLDs:
>> 1 max_lds: 64
>> [   63.626618] megaraid_sas 0000:08:00.0: controller type : MR(2048MB)
>> [   63.639870] megaraid_sas 0000:08:00.0: Online Controller Reset(OCR) :
>> Enabled
>> [   63.654945] megaraid_sas 0000:08:00.0: Secure JBOD support : Yes
>> [   63.667661] megaraid_sas 0000:08:00.0: NVMe passthru support : Yes
>> [   63.667672] megaraid_sas 0000:08:00.0: FW provided TM TaskAbort/Reset
>> timeout : 6 secs/60 secs
>> [   63.698922] megaraid_sas 0000:08:00.0: JBOD sequence map support : Yes
>> [   63.712715] megaraid_sas 0000:08:00.0: PCI Lane Margining support : No
>> [   63.754764] megaraid_sas 0000:08:00.0: NVME page size : (4096)
>> [   63.787258] megaraid_sas 0000:08:00.0: megasas_enable_intr_fusion is
>> called outbound_intr_mask:0x40000000
>> [   63.807485] megaraid_sas 0000:08:00.0: INIT adapter done
>> [   63.822235] megaraid_sas 0000:08:00.0: pci id :
>> (0x1000)/(0x0016)/(0x19e5)/(0xd215)
>> [   63.838652] megaraid_sas 0000:08:00.0: unevenspan support : no
>> [   63.850980] megaraid_sas 0000:08:00.0: firmware crash dump : no
>> [   63.863499] megaraid_sas 0000:08:00.0: JBOD sequence map : enabled
>> [   63.877352] scsi host0: Avago SAS based MegaRAID driver
>> [   63.890398] megaraid_sas 0000:08:00.0: Failed to add host from
>> megasas_io_attach 6802
>> [   63.906999] megaraid_sas 0000:08:00.0: megasas_disable_intr_fusion is
>> called outbound_intr_mask:0x40000009
>> [   64.591755] nvme 0000:81:00.0: Adding to iommu group 2
>> [   64.636476] nvme nvme0: pci function 0000:81:00.0
>> [   64.669635] libphy: Fixed MDIO Bus: probed
>> [   64.680255] tun: Universal TUN/TAP device driver, 1.6
>> [   64.694422] thunder_xcv, ver 1.0
>> [   64.702042] thunder_bgx, ver 1.0
>> [   64.709277] nicpf, ver 1.0
>> [   64.718144] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
>> [   64.730402] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
>> [   64.743337] igb: Intel(R) Gigabit Ethernet Network Driver - version
>> 5.6.0-k
>> [   64.754981] nvme nvme0: Removing after probe failure status: -12
>> [   64.757953] igb: Copyright (c) 2007-2014 Intel Corporation.
>> [   64.782805] igbvf: Intel(R) Gigabit Virtual Function Network Driver -
>> version 2.4.0-k
>> [   64.799423] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
>> [   64.813848] sky2: driver version 1.30
>> [   64.825564] VFIO - User Level meta-driver version: 0.3
>> [   64.848089] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [   64.862029] ehci-pci: EHCI PCI platform driver
>> [   64.873445] ehci-pci 0000:7a:01.0: Adding to iommu group 3
>> [   64.886700]
>> ==================================================================
>> [   64.901999] BUG: KASAN: slab-out-of-bounds in
>> run_timer_softirq+0x6f4/0xae0
>> [   64.916663] Write of size 8 at addr ffff0026b931aae0 by task swapper/0/0
>>
>> [   64.933914] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
>> 5.6.0-rc3-00005-g17ceebe3a05c-dirty #1775
>> [   64.952240] Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD,
>> BIOS 2280-V2 CS V3.B160.01 02/24/2020
>> [   64.972575] Call trace:
>> [   64.977729]  dump_backtrace+0x0/0x298
>> [   64.985439]  show_stack+0x14/0x20
>> [   64.992418]  dump_stack+0x118/0x190
>> [   64.999762]  print_address_description.isra.9+0x6c/0x3b8
>> [   65.010953]  __kasan_report+0x134/0x23c
>> [   65.019029]  kasan_report+0xc/0x18
>> [   65.026188]  __asan_store8+0x94/0xb8
>> [   65.033720]  run_timer_softirq+0x6f4/0xae0
>> [   65.042343]  efi_header_end+0x16c/0x840
>> [   65.050420]  irq_exit+0x19c/0x1a8
>> [   65.057396]  __handle_domain_irq+0x7c/0xe0
>> [   65.066022]  gic_handle_irq+0x64/0x168
>> [   65.073917]  el1_irq+0xbc/0x180
>> [   65.080528]  arch_cpu_idle+0x3c/0x320
>> [   65.088239]  default_idle_call+0x28/0x4c
>> [   65.096502]  do_idle+0x278/0x348
>> [   65.103295]  cpu_startup_entry+0x24/0x40
>> [   65.111554]  rest_init+0x1c4/0x298
>> [   65.118718]  arch_call_rest_init+0xc/0x14
>> [   65.127159]  start_kernel+0x848/0x888
>>
>> [   65.138006] Allocated by task 0:
>> [   65.144802] (stack is not available)
>>
>> [   65.155465] Freed by task 0:
>> [   65.161530] (stack is not available)
>>
>> [   65.172193] The buggy address belongs to the object at ffff0026b931aa00
>>    which belongs to the cache pool_workqueue of size 256
>> [   65.199113] The buggy address is located 224 bytes inside of
>>    256-byte region [ffff0026b931aa00, ffff0026b931ab00)
>> [   65.223840] The buggy address belongs to the page:
>> [   65.233931] page:fffffe009ac4c600 refcount:1 mapcount:0
>> mapping:ffff0026dd81c880 index:0xffff0026b931fe00 compound_mapcount: 0
>> [   65.257923] flags: 0x6ffff00000010200(slab|head)
>> [   65.267649] raw: 6ffff00000010200 fffffe009b20b208 fffffe009ac07608
>> ffff0026dd81c880
>> [   65.283959] raw: ffff0026b931fe00 0000000000400002 00000001ffffffff
>> 0000000000000000
>> [   65.300270] page dumped because: kasan: bad access detected
>>
>> [   65.315139] Memory state around the buggy address:
>> [   65.325231]  ffff0026b931a980: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [   65.340445]  ffff0026b931aa00: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [   65.355660] >ffff0026b931aa80: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [   65.370870]                                                        ^
>> [   65.384256]  ffff0026b931ab00: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [   65.399467]  ffff0026b931ab80: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [   65.414675]
>> ==================================================================
>> [   65.429885] Disabling lock debugging due to kernel taint
>> [   65.441431] Unable to handle kernel paging request at virtual address
>> ffffa0001013c0b0
>> [   65.441695] ehci-pci 0000:7a:01.0: EHCI Host Controller
>> [   65.458088] Mem abort info:
>> [   65.469183] ehci-pci 0000:7a:01.0: new USB bus registered, assigned
>> bus number 1
>> [   65.474927]   ESR = 0x96000007
>> [   65.491201] ehci-pci 0000:7a:01.0: irq 65, io mem 0x20c101000
>> [   65.496913]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [   65.496918]   SET = 0, FnV = 0
>> [   65.496922]   EA = 0, S1PTW = 0
>> [   65.522586] ehci-pci 0000:7a:01.0: USB 0.0 started, EHCI 1.00
>> [   65.526575] Data abort info:
>> [   65.526580]   ISV = 0, ISS = 0x00000007
>> [   65.535948] hub 1-0:1.0: USB hub found
>> [   65.545245]   CM = 0, WnR = 0
>> [   65.545251] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000052530000
>> [   65.545256] [ffffa0001013c0b0] pgd=00002027fffff003,
>> pud=00002027ffffe003, pmd=00000026dda5b003, pte=0000000000000000
>> [   65.551519] hub 1-0:1.0: 2 ports detected
>> [   65.559375] Internal error: Oops: 96000007 [#1] PREEMPT SMP
>> [   65.559379] Modules linked in:
>> [   65.569534] ehci-platform: EHCI generic platform driver
>> [   65.573475] CPU: 34 PID: 8 Comm: kworker/u256:0 Tainted: G    B
>>         5.6.0-rc3-00005-g17ceebe3a05c-dirty #1775
>> [   65.573477] Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD,
>> BIOS 2280-V2 CS V3.B160.01 02/24/2020
>> [   65.573487] Workqueue: poll_megasas0_status megasas_fault_detect_work
>> [   65.573492] pstate: 80c00009 (Nzcv daif +PAN +UAO)
>> [   65.588048] ehci-orion: EHCI orion driver
>> [   65.609756] pc : megasas_readl+0x60/0x80
>> [   65.609759] lr : megasas_readl+0x1c/0x80
>> [   65.609761] sp : ffff0026d97bfc00
>> [   65.609763] x29: ffff0026d97bfc00 x28: ffff0026d97a9890
>> [   65.609767] x27: ffff0026d97a0618 x26: ffff0026d97a9880
>> [   65.609771] x25: ffff0026d9758808 x24: ffff0026b931aa28
>> [   65.609775] x23: ffff0026b931aa98 x22: ffffa0002931e000
>> [   65.609779] x21: ffff0026dd898800 x20: ffff0026b931dcd8
>> [   65.618543] ehci-exynos: EHCI Exynos driver
>> [   65.629840] x19: ffffa0001013c0b0 x18: 0000000000000000
>> [   65.629843] x17: 0000000000001d50 x16: ffffffffffffe240
>> [   65.629847] x15: 00000000000013a8 x14: 0000000000000000
>> [   65.629850] x13: 00000000000013a0 x12: 1fffe004db2f7f7c
>> [   65.629854] x11: ffff8004db2f7f78 x10: dfffa00000000000
>> [   65.629857] x9 : ffffa00028f679e8 x8 : ffffa0002a483a48
>> [   65.629861] x7 : ffffa00026d5ed94 x6 : 0000000000000000
>> [   65.629864] x5 : ffffa0002a483a48 x4 : 0000000000000000
>> [   65.629868] x3 : ffffa000279df03c x2 : 0000000000000000
>> [   65.636662] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> [   65.647207] x1 : ef244e124d671400 x0 : 0000000000000004
>> [   65.647210] Call trace:
>> [   65.647214]  megasas_readl+0x60/0x80
>> [   65.647218]  megasas_read_fw_status_reg_fusion+0x2c/0x38
>> [   65.647221]  megasas_fault_detect_work+0x44/0x520
>> [   65.647226]  process_one_work+0x488/0xc08
>> [   65.647228]  worker_thread+0x68/0x5d0
>> [   65.647233]  kthread+0x1c8/0x1d0
>> [   65.669535] ohci-pci: OHCI PCI platform driver
>> [   65.689683]  ret_from_fork+0x10/0x18
>> [   65.689689] Code: 54ffff09 a94153f3 a8c27bfd d65f03c0 (b9400260)
>> [   65.689695] ---[ end trace 3632c7efc4f2d69c ]---
>>
>>
>> That's 5.6-rc3 .
>>
>> Please have a look,
>>
>> John
>>
>>
>>

