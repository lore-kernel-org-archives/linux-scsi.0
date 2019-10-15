Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D30ECE58F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 14:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7292168B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 14:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbfJOOSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:18:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731553AbfJOOSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 10:18:00 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1729FE19F47D7609545C;
        Tue, 15 Oct 2019 22:17:58 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 22:17:52 +0800
Subject: Re: ahci KASAN warning in experimental arm64 allmodconfig boot
To:     <linux-ide@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
References: <758acedf-4007-9937-e777-bd1371c84e21@huawei.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <67ee2965-7907-a9aa-b7e8-c5c9bf3ea1fc@huawei.com>
Date:   Tue, 15 Oct 2019 15:17:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <758acedf-4007-9937-e777-bd1371c84e21@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/10/2019 19:02, John Garry wrote:
> Hi guys,
>
> I'm experimenting by trying to boot an allmodconfig arm64 kernel, as
> mentioned here:
> https://lore.kernel.org/linux-arm-kernel/507325a3-030e-2843-0f46-7e18c60257de@huawei.com/
>
>
> I am getting a KASAN slab-out-of-bounds warning around the ahci code, as
> below. I am also getting a crash some time after, but the stackframe is
> mixed up in the dmesg, so hard to extract that.
>
> The kernel is v5.4-rc3.
>
> I'll continue to look at this as time allows.
>
> I have cc'ed the scsi list as this may be related to the SAS host (using
> libsas), but I'm doubtful, considering the log mentions ahci_init_one().
>

It may very well be related - just CONFIG_DEBUG_TEST_DRIVER_REMOVE 
triggers this WARN:

[   23.452574] ------------[ cut here ]------------
[   23.457190] WARNING: CPU: 59 PID: 1 at drivers/ata/libata-core.c:6676 
ata_host_detach+0x15c/0x168
[   23.466047] Modules linked in:
[   23.469092] CPU: 59 PID: 1 Comm: swapper/0 Not tainted 
5.4.0-rc1-00010-g5b83fd27752b-dirty #296
[   23.477776] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI 
RC0 - V1.16.01 03/15/2019
[   23.486286] pstate: a0c00009 (NzCv daif +PAN +UAO)
[   23.491065] pc : ata_host_detach+0x15c/0x168
[   23.495322] lr : ata_host_detach+0x88/0x168
[   23.499491] sp : ffff800011cabb50
[   23.502792] x29: ffff800011cabb50 x28: 0000000000000007
[   23.508091] x27: ffff80001137f068 x26: ffff8000112c0c28
[   23.513390] x25: 0000000000003848 x24: ffff0023ea185300
[   23.518689] x23: 0000000000000001 x22: 00000000000014c0
[   23.523987] x21: 0000000000013740 x20: ffff0023bdc20000
[   23.529286] x19: 0000000000000000 x18: 0000000000000004
[   23.534584] x17: 0000000000000001 x16: 00000000000000f0
[   23.539883] x15: ffff0023eac13790 x14: ffff0023eb76c408
[   23.545181] x13: 0000000000000000 x12: ffff0023eac13790
[   23.550480] x11: ffff0023eb76c228 x10: 0000000000000000
[   23.555779] x9 : ffff0023eac13798 x8 : 0000000040000000
[   23.561077] x7 : 0000000000000002 x6 : 0000000000000001
[   23.566376] x5 : 0000000000000002 x4 : 0000000000000000
[   23.571674] x3 : ffff0023bf08a0bc x2 : 0000000000000000
[   23.576972] x1 : 3099674201f72700 x0 : 0000000000400284
[   23.582272] Call trace:
[   23.584706]  ata_host_detach+0x15c/0x168
[   23.588616]  ata_pci_remove_one+0x10/0x18
[   23.592615]  ahci_remove_one+0x20/0x40
[   23.596356]  pci_device_remove+0x3c/0xe0
[   23.600267]  really_probe+0xdc/0x3e0
[   23.603830]  driver_probe_device+0x58/0x100
[   23.608000]  device_driver_attach+0x6c/0x90
[   23.612169]  __driver_attach+0x84/0xc8
[   23.615908]  bus_for_each_dev+0x74/0xc8
[   23.619730]  driver_attach+0x20/0x28
[   23.623292]  bus_add_driver+0x148/0x1f0
[   23.627115]  driver_register+0x60/0x110
[   23.630938]  __pci_register_driver+0x40/0x48
[   23.635199]  ahci_pci_driver_init+0x20/0x28
[   23.639372]  do_one_initcall+0x5c/0x1b0
[   23.643199]  kernel_init_freeable+0x1a4/0x24c
[   23.647546]  kernel_init+0x10/0x108
[   23.651023]  ret_from_fork+0x10/0x18
[   23.654590] ---[ end trace 634a14b675b71c13 ]---

I'll dig deeper if I get a chance.

John

> Thanks,
> John
>
> Log snippet:
>
> [  137.529384][  T187]
> ==================================================================
> [  137.529403][  T187] BUG: KASAN: slab-out-of-bounds in
> ata_link_next+0x5c/0x1b0
> [  137.529411][  T187] Read of size 4 at addr ffff002320073cc8 by task
> kworker/u194:0/187
> [  137.529414][  T187]
> [  137.529426][  T187] CPU: 38 PID: 187 Comm: kworker/u194:0 Tainted: G
>       W         5.4.0-rc3+ #1149
> [  137.529433][  T187] Hardware name: Huawei D06 /D06, BIOS Hisilicon
> D06 UEFI RC0 - V1.16.01 03/15/2019
> [  137.529447][  T187] Workqueue: events_unbound async_run_entry_fn
> [  137.529454][  T187] Call trace:
> [  137.529462][  T187]  dump_backtrace+0x0/0x298
> [  137.529469][  T187]  show_stack+0x20/0x30
> [  137.529477][  T187]  dump_stack+0x190/0x21c
> [  137.529488][  T187]  print_address_description.isra.6+0x80/0x3d0
> [  137.529496][  T187]  __kasan_report+0x174/0x23c
> [  137.529503][  T187]  kasan_report+0xc/0x18
> [  137.529511][  T187]  __asan_load4+0xa4/0xb0
> [  137.529517][  T187]  ata_link_next+0x5c/0x1b0
> [  137.529526][  T187]  ata_scsi_scan_host+0x50/0x2d0
> [  137.529533][  T187]  async_port_probe+0x7c/0xa8
> [  137.529541][  T187]  async_run_entry_fn+0x118/0x340
> [  137.529549][  T187]  process_one_work+0x7b8/0xdb8
> [  137.529556][  T187]  worker_thread+0x414/0x6b8
> [  137.529562][  T187]  kthread+0x1d4/0x1f0
> [  137.529570][  T187]  ret_from_fork+0x10/0x18
> [  137.529574][  T187]
> [  137.529580][  T187] Allocated by task 16:
> [  137.529589][  T187]  save_stack+0x28/0xb0
> [  137.529597][  T187]  __kasan_kmalloc.isra.9+0xa0/0xc8
> [  137.529604][  T187]  kasan_slab_alloc+0x14/0x20
> [  137.529612][  T187]  kmem_cache_alloc+0x25c/0x420
> [  137.529620][  T187]  __proc_create+0x430/0x458
> [  137.529627][  T187]  proc_mkdir_data+0x50/0xf0
> [  137.529634][  T187]  proc_mkdir+0x2c/0x38
> [  137.529642][  T187]  register_irq_proc+0x104/0x278
> [  137.529650][  T187]  __setup_irq+0xafc/0xe80
> [  137.529657][  T187]  request_threaded_irq+0x198/0x218
> [  137.529666][  T187]  devm_request_threaded_irq+0xb0/0x120
> [  137.529674][  T187]  ahci_host_activate+0x1cc/0x290
> [  137.529682][  T187]  ahci_init_one+0x1358/0x1570
> [  137.529691][  T187]  local_pci_probe+0x78/0xf0
> [  137.529698][  T187]  work_for_cpu_fn+0x30/0x50
> [  137.529705][  T187]  process_one_work+0x7b8/0xdb8
> [  137.529713][  T187]  worker_thread+0x4a8/0x6b8
> [  137.529719][  T187]  kthread+0x1d4/0x1f0
> [  137.529726][  T187]  ret_from_fork+0x10/0x18
> [  137.529729][  T187]
> [  137.529734][  T187] Freed by task 0:
> [  137.529737][  T187] (stack is not available)
> [  137.529741][  T187]
> [  137.529747][  T187] The buggy address belongs to the object at
> ffff002320073b68
> [  137.529747][  T187]  which belongs to the cache proc_dir_entry of
> size 256
> [  137.529755][  T187] The buggy address is located 96 bytes to the
> right of
> [  137.529755][  T187]  256-byte region [ffff002320073b68,
> ffff002320073c68)
> [  137.529759][  T187] The buggy address belongs to the page:
> [  137.529768][  T187] page:fffffe008c601c00 refcount:1 mapcount:0
> mapping:ffff0020bf1b8480 index:0xffff002320070988 compound_mapcount: 0
> [  137.529779][  T187] flags: 0x1ffff00000010200(slab|head)
> [  137.529791][  T187] raw: 1ffff00000010200 ffff0020bf1a3cd0
> fffffe008c612208 ffff0020bf1b8480
> [  137.529801][  T187] raw: ffff002320070988 000000000035000b
> 00000001ffffffff 0000000000000000
> [  137.529805][  T187] page dumped because: kasan: bad access detected
> [  137.529809][  T187]
> [  137.529812][  T187] Memory state around the buggy address:
> [  137.529820][  T187]  ffff002320073b80: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  137.529827][  T187]  ffff002320073c00: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 fc fc fc
> [  137.529835][  T187] >ffff002320073c80: fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc fc fc
> [  137.529839][  T187]                                               ^
> [  137.529846][  T187]  ffff002320073d00: fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc fc fc
> [  137.529853][  T187]  ffff002320073d80: fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc fc fc
> [  137.529857][  T187]
> ==================================================================
> [  137.529874][  T187] Unable to handle kernel paging request at virtual
> address 000004a02a0040ba
> [  137.529883][  T187] Mem abort info:
> [  137.529893][  T187]   ESR = 0x96000004
> [  137.529905][  T187]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  137.529915][  T187]   SET = 0, FnV = 0
> [  137.529925][  T187]   EA = 0, S1PTW = 0
> [  137.529934][  T187] Data abort info:
> [  137.529940][   T16] kobject: '177' ((____ptrval____)):
> kobject_add_internal: parent: 'irq', set: '<NULL>'
> [  137.529945][  T187]   ISV = 0, ISS = 0x00000004
> [  137.529955][  T187]   CM = 0, WnR = 0
> [  137.529966][  T187] [000004a02a0040ba] user address but active_mm is
> swapper
> [  137.529979][  T187] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [  137.529985][  T187] Modules linked in:
> [  137.529996][  T187] CPU: 38 PID: 187 Comm: kworker/u194:0 Tainted: G
>   B   W         5.4.0-rc3+ #1149
> [  137.530002][  T187] Hardware name: Huawei D06 /D06, BIOS Hisilicon
> D06 UEFI RC0 - V1.16.01 03/15/2019
> [  137.530011][  T187] Workqueue: events_unbound async_run_entry_fn
> [  137.530020][  T187] pstate: 40800009 (nZcv daif -PAN +UAO)
> [  137.530026][  T187] pc : ata_dev_next+0xf8/0x1f8
> [  137.530033][  T187] lr : ata_dev_next+0xf8/0x1f8
> [  137.530037][  T187] sp : ffff0020bddafb80
> [  137.530042][  T187] x29: ffff0020bddafb80 x28: 0000000000000000
> [  137.530050][  T187] x27: 0000000000003cc0 x26: ffffa00015016000
> [  137.530059][  T187] x25: 00000000000020c0 x24: ffffa000113102a8
> [  137.530068][  T187] x23: 350004a02a0003fa x22: ffffa00011335db0
> [  137.530077][  T187] x21: ffffa000113356f0 x20: 0000000000000000
> [  137.530085][  T187] x19: ffffa00011336830 x18: 00000000000025a8
> [  137.530094][  T187] x17: 00000000000025a0 x16: 00000000000026b0
> [  137.530102][  T187] x15: 0000000000001470 x14: 3d3d3d3d3d3d3d3d
> [  137.530111][  T187] x13: 3d3d3d3d3d3d3d3d x12: 1fffe00417bb5f3e
> [  137.530120][  T187] x11: ffff800417bb5f3e x10: dfffa00000000000
> [  137.530129][  T187] x9 : ffff800417bb5f3f x8 : 0000000000000001
> [  137.530138][  T187] x7 : 0000000000003cd0 x6 : 0000000000000000
> [  137.530146][  T187] x5 : ffffa00015015cc8 x4 : 0000000000000000
> [  137.530155][  T187] x3 : ffffa00011301608 x2 : 0000000000000000
> [  137.530163][  T187] x1 : 21f045c4027f9500 x0 : 0000000000000000
> [  137.530171][  T187] Call trace:
> [  137.530178][  T187]  ata_dev_next+0xf8/0x1f8
> [  137.530187][  T187]  ata_scsi_scan_host+0x6c/0x2d0
> [  137.530194][  T187]  async_port_probe+0x7c/0xa8
> [  137.530202][  T187]  async_run_entry_fn+0x118/0x340
> [  137.530209][  T187]  process_one_work+0x7b8/0xdb8
> [  137.530216][  T187]  worker_thread+0x414/0x6b8
> [  137.530223][  T187]  kthread+0x1d4/0x1f0
> [  137.530230][  T187]  ret_from_fork+0x10/0x18
> [  137.530242][  T187] Code: 97c544f6 d2879801 8b0102e0 97cd4fb5 (f95e62e0)
> [  137.530472][  T187] ---[ end trace 1702441cf7c2cd89 ]---
> [  137.530479][  T187] Kernel panic - not syncing: Fatal exception
> [  137.530592][   T16] kobject: '178' ((____ptrval____)):
> kobject_add_internal: parent: 'irq', set: '<NULL>'
> [  137.530653][  T187] SMP: stopping secondary CPUs
> [  137.531078][  T187] Kernel Offset: disabled
> [  137.531085][  T187] CPU features: 0x0002,23208a38
> [  137.531089][  T187] Memory Limit: none
> [  143.699079][  T187] ---[ end Kernel panic - not syncing: Fatal
> exception ]---
>
>
>
>
>


