From: Laura Abbott <labbott@redhat.com>
Subject: alloc failure in qla1280 probe -- need to decrease can_queue?
Date: Mon, 18 Apr 2016 15:07:15 -0700
Message-ID: <57155A93.7090604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36187 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbcDRWHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2016 18:07:20 -0400
Received: by mail-qg0-f41.google.com with SMTP id f52so127942524qga.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2016 15:07:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

We received a bug report https://bugzilla.redhat.com/show_bug.cgi?id=1321033
of qla1280 scsi host failure on 4.4 based kernels that looks to be caused
by page alloc failure:

[    4.804166] scsi host0: QLogic QLA1040 PCI to SCSI Host Adapter
                       Firmware version:  7.65.06, Driver version 3.27.1
[    4.804174] ------------[ cut here ]------------
[    4.804184] WARNING: CPU: 2 PID: 305 at mm/page_alloc.c:2989 __alloc_pages_nodemask+0xae8/0xbc0()
[    4.804186] Modules linked in: amdkfd amd_iommu_v2 radeon i2c_algo_bit drm_kms_helper ttm drm megaraid_sas serio_raw 8021q garp bnx2 stp llc mrp sunhme qla1280(+) fjes
[    4.804208] CPU: 2 PID: 305 Comm: systemd-udevd Not tainted 4.4.6-201.fc22.x86_64 #1
[    4.804210] Hardware name: Google Enterprise Search Appliance/0DT021, BIOS 1.1.2 08/14/2006
[    4.804212]  0000000000000286 000000002f01064c ffff88042985b710 ffffffff813b542e
[    4.804216]  0000000000000000 ffffffff81a75024 ffff88042985b748 ffffffff810a40f2
[    4.804220]  0000000000000000 0000000000000000 000000000000000b 0000000000000000
[    4.804223] Call Trace:
[    4.804231]  [<ffffffff813b542e>] dump_stack+0x63/0x85
[    4.804236]  [<ffffffff810a40f2>] warn_slowpath_common+0x82/0xc0
[    4.804239]  [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
[    4.804242]  [<ffffffff811b75e8>] __alloc_pages_nodemask+0xae8/0xbc0
[    4.804247]  [<ffffffff817a002e>] ? _raw_spin_unlock_irqrestore+0xe/0x10
[    4.804251]  [<ffffffff811908be>] ? irq_work_queue+0x8e/0xa0
[    4.804256]  [<ffffffff810fa10a>] ? console_unlock+0x20a/0x540
[    4.804262]  [<ffffffff812029cc>] alloc_pages_current+0x8c/0x110
[    4.804265]  [<ffffffff811b5159>] alloc_kmem_pages+0x19/0x90
[    4.804268]  [<ffffffff811d2efe>] kmalloc_order_trace+0x2e/0xe0
[    4.804272]  [<ffffffff8120e6d2>] __kmalloc+0x232/0x260
[    4.804277]  [<ffffffff8138990d>] init_tag_map+0x3d/0xc0
[    4.804290]  [<ffffffff813899d5>] __blk_queue_init_tags+0x45/0x80
[    4.804293]  [<ffffffff81389a24>] blk_init_tags+0x14/0x20
[    4.804298]  [<ffffffff81520e60>] scsi_add_host_with_dma+0x80/0x300
[    4.804305]  [<ffffffffa000fec3>] qla1280_probe_one+0x683/0x9ef [qla1280]
[    4.804309]  [<ffffffff81401115>] local_pci_probe+0x45/0xa0
[    4.804312]  [<ffffffff814024fd>] pci_device_probe+0xfd/0x140
[    4.804316]  [<ffffffff814ef1d2>] driver_probe_device+0x222/0x490
[    4.804319]  [<ffffffff814ef4c4>] __driver_attach+0x84/0x90
[    4.804321]  [<ffffffff814ef440>] ? driver_probe_device+0x490/0x490
[    4.804324]  [<ffffffff814eccac>] bus_for_each_dev+0x6c/0xc0
[    4.804326]  [<ffffffff814ee98e>] driver_attach+0x1e/0x20
[    4.804328]  [<ffffffff814ee4cb>] bus_add_driver+0x1eb/0x280
[    4.804331]  [<ffffffffa0015000>] ? 0xffffffffa0015000
[    4.804333]  [<ffffffff814efd80>] driver_register+0x60/0xe0
[    4.804336]  [<ffffffff81400a5c>] __pci_register_driver+0x4c/0x50
[    4.804339]  [<ffffffffa00151ce>] qla1280_init+0x1ce/0x1000 [qla1280]
[    4.804341]  [<ffffffffa0015000>] ? 0xffffffffa0015000
[    4.804345]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
[    4.804348]  [<ffffffff8120d086>] ? kmem_cache_alloc_trace+0x196/0x210
[    4.804352]  [<ffffffff811aba7e>] ? do_init_module+0x27/0x1cb
[    4.804354]  [<ffffffff811abab6>] do_init_module+0x5f/0x1cb
[    4.804358]  [<ffffffff8112a6e0>] load_module+0x2040/0x2680
[    4.804360]  [<ffffffff81126e40>] ? __symbol_put+0x60/0x60
[    4.804363]  [<ffffffff8112ae69>] SYSC_init_module+0x149/0x190
[    4.804366]  [<ffffffff8112af9e>] SyS_init_module+0xe/0x10
[    4.804369]  [<ffffffff817a05ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[    4.804371] ---[ end trace 0ea3b625f86705f7 ]---
[    4.804581] qla1280: probe of 0000:11:04.0 failed with error -12

This looks very similar to http://www.spinics.net/lists/linux-usb/msg136998.html
which was fixed by 55ff8cfbc4e1 ("USB: uas: Reduce can_queue to MAX_CMNDS").
Does a similar fix need to be applied here?

Thanks,
Laura
