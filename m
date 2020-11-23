Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BD8C2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 15:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A933208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 15:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388403AbgKWPqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 10:46:19 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2139 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388010AbgKWPqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 10:46:18 -0500
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CfrzQ1tq0z67Gx0;
        Mon, 23 Nov 2020 23:43:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 23 Nov 2020 16:46:16 +0100
Received: from [10.47.7.144] (10.47.7.144) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 23 Nov
 2020 15:46:15 +0000
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
To:     Marc Zyngier <maz@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>, <linuxarm@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
 <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
 <874klmqu2r.fsf@nanos.tec.linutronix.de>
 <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
 <87lfexp6am.fsf@nanos.tec.linutronix.de>
 <3acb7fde-eae2-a223-9cfd-f409cc2abba6@huawei.com>
 <873615oy8a.fsf@nanos.tec.linutronix.de>
 <4aab9d3b-6ca6-01c5-f840-459f945c7577@huawei.com>
 <87sg91ik9e.wl-maz@kernel.org>
 <0edc9a11-0b92-537f-1790-6b4b6de4900d@huawei.com>
 <afd97dd4b1e102ac9ad49800821231a4@kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <5a314713-c1ee-2d34-bee1-60beae274742@huawei.com>
Date:   Mon, 23 Nov 2020 15:45:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <afd97dd4b1e102ac9ad49800821231a4@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.144]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Marc,

>> So is there a reason for which irq dispose mapping is not a
>> requirement for drivers when finished with the irq? because of shared
>> interrupts?
> 
> For a bunch of reasons: IRQ number used to be created 1:1 with their
> physical counterpart, so there wasn't a need to "get rid" of the
> associated data structures. Also, people expected their drivers
> to be there for the lifetime of the system (believe it or not,
> hotplug devices are pretty new!).
> 
> Shared interrupts are just another part of the problem (although we
> should be able to work out whether there is any action attached to
> the descriptor before blowing it away.
> 

OK, understood.

>> But it looks like there is more to it than that, which I'm worried is
>> far from non-trivial. For example, just calling irq_dispose_mapping()
>> for removal and then plaform_get_irq()->acpi_get_irq() second time
>> fails as it looks like more tidy-up is needed for removal...
> 
> Most probably. I could imagine things failing if there is any trace
> of an existing translation in the ITS or in the platform-MSI layer,
> for example, or if the interrupt is still active...

So this looks to be a problem I have. So if I hack the code to skip the 
check in acpi_get_irq() for the irq already being init'ed, I run into a 
use-after-free in the gic-v3-its driver. I may be skipping something 
with this hack, but I'll ask anyway.

So initially in the msi_prepare method we setup the its dev - this is 
from the mbigen probe. Then when all the irqs are unmapped later for end 
device driver removal, we release this its device in 
its_irq_domain_free(). But I don't see anything to set it up again. Is 
it improper to have released the its device in this scenario? Commenting 
out the release makes things "good" again.

Thanks,
john

Complete splat:

[   35.751627] 
==================================================================
[   35.758892] BUG: KASAN: use-after-free in its_irq_domain_alloc+0x44/0x1a8
[   35.765714] Read of size 8 at addr ffff04101bc93210 by task swapper/0/1
[   35.772357]
[   35.773854] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 
5.10.0-rc4-18055-g3247a1b07719 #955
[   35.782072] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 IT21 Nemo 2.0 RC0 04/18/2018
[   35.791250] Call trace:
[   35.793706]  dump_backtrace+0x0/0x2d0
[   35.797384]  show_stack+0x18/0x68
[   35.800713]  dump_stack+0x100/0x16c
[   35.804216]  print_address_description.constprop.12+0x6c/0x4e8
[   35.810078]  kasan_report+0x130/0x200
[   35.813755]  __asan_load8+0x9c/0xd8
[   35.817257]  its_irq_domain_alloc+0x44/0x1a8
[   35.821548]  irq_domain_alloc_irqs_parent+0x68/0x88
[   35.826447]  msi_domain_alloc+0x98/0x180
[   35.830387]  irq_domain_alloc_irqs_hierarchy+0x58/0x78
[   35.835549]  msi_domain_populate_irqs+0x16c/0x1d8
[   35.840275]  platform_msi_domain_alloc+0x9c/0xd0
[   35.844914]  mbigen_irq_domain_alloc+0x100/0x180
[   35.849553]  __irq_domain_alloc_irqs+0x188/0x498
[   35.854191]  irq_create_fwspec_mapping+0x21c/0x4e0
[   35.859005]  acpi_irq_get+0x1f0/0x218
[   35.862683]  platform_get_irq_optional+0x1c4/0x4a0
[   35.867495]  platform_get_irq+0x20/0x68
[   35.871348]  hisi_sas_v2_probe+0x2c/0x88
[   35.875287]  platform_drv_probe+0x70/0xd0
[   35.879313]  really_probe+0x414/0x640
[   35.882990]  driver_probe_device+0x78/0xe8
[   35.887103]  device_driver_attach+0x9c/0xa8
[   35.891304]  __driver_attach+0x74/0x120
[   35.895156]  bus_for_each_dev+0xec/0x160
[   35.899094]  driver_attach+0x34/0x48
[   35.902684]  bus_add_driver+0x1b8/0x2c0
[   35.906535]  driver_register+0xc0/0x1e0
[   35.910386]  __platform_driver_register+0x80/0x90
[   35.915115]  hisi_sas_v2_driver_init+0x1c/0x28
[   35.919578]  do_one_initcall+0xd4/0x268
[   35.923431]  kernel_init_freeable+0x270/0x2d8
[   35.927807]  kernel_init+0x14/0x124
[   35.931309]  ret_from_fork+0x10/0x34
[   35.934895]
[   35.936386] Allocated by task 1:
[   35.939628]  stack_trace_save+0x94/0xc8
[   35.943480]  kasan_save_stack+0x28/0x58
[   35.947331]  __kasan_kmalloc.isra.6+0xcc/0xf0
[   35.951706]  kasan_kmalloc+0x10/0x20
[   35.955295]  its_create_device+0x1b8/0x448
[   35.959408]  its_msi_prepare+0x120/0x1d8
[   35.963347]  its_pmsi_prepare+0x20c/0x280
[   35.967373]  msi_domain_prepare_irqs+0x80/0x98
[   35.971836]  __platform_msi_create_device_domain+0xa8/0x130
[   35.977435]  mbigen_device_probe+0x298/0x340
[   35.981723]  platform_drv_probe+0x70/0xd0
[   35.985748]  really_probe+0x414/0x640
[   35.989424]  driver_probe_device+0x78/0xe8
[   35.993537]  device_driver_attach+0x9c/0xa8
[   35.997737]  __driver_attach+0x74/0x120
[   36.001589]  bus_for_each_dev+0xec/0x160
[   36.005527]  driver_attach+0x34/0x48
[   36.009118]  bus_add_driver+0x1b8/0x2c0
[   36.012968]  driver_register+0xc0/0x1e0
[   36.016819]  __platform_driver_register+0x80/0x90
[   36.021545]  mbigen_platform_driver_init+0x1c/0x28
[   36.026356]  do_one_initcall+0xd4/0x268
[   36.030207]  kernel_init_freeable+0x270/0x2d8
[   36.034583]  kernel_init+0x14/0x124
[   36.038084]  ret_from_fork+0x10/0x34
[   36.041671]
[   36.043162] Freed by task 1:
[   36.046053]  stack_trace_save+0x94/0xc8
[   36.049904]  kasan_save_stack+0x28/0x58
[   36.053754]  kasan_set_track+0x28/0x40
[   36.057518]  kasan_set_free_info+0x24/0x48
[   36.061631]  __kasan_slab_free+0x104/0x188
[   36.065744]  kasan_slab_free+0x14/0x20
[   36.069510]  slab_free_freelist_hook+0x8c/0x190
[   36.074060]  kfree+0x308/0x448
[   36.077125]  its_irq_domain_free+0x31c/0x338
[   36.081414]  irq_domain_free_irqs_common+0xd8/0x128
[   36.086314]  irq_domain_free_irqs_top+0x70/0x88
[   36.090864]  msi_domain_free+0xa8/0xc8
[   36.094629]  irq_domain_free_irqs_common+0xd8/0x128
[   36.099528]  platform_msi_domain_free+0xdc/0x1b0
[   36.104167]  mbigen_irq_domain_free+0x10/0x20
[   36.108543]  irq_domain_free_irqs+0x184/0x208
[   36.112918]  irq_dispose_mapping+0x54/0x98
[   36.117033]  devm_platform_get_irqs_affinity_release+0xbc/0xdc
[   36.122893]  release_nodes+0x350/0x3e8
[   36.126657]  devres_release_all+0x54/0x78
[   36.130683]  really_probe+0x234/0x640
[   36.134359]  driver_probe_device+0x78/0xe8
[   36.138473]  device_driver_attach+0x9c/0xa8
[   36.142673]  __driver_attach+0x74/0x120
[   36.146524]  bus_for_each_dev+0xec/0x160
[   36.150462]  driver_attach+0x34/0x48
[   36.154052]  bus_add_driver+0x1b8/0x2c0
[   36.157903]  driver_register+0xc0/0x1e0
[   36.161754]  __platform_driver_register+0x80/0x90
[   36.166479]  hisi_sas_v2_driver_init+0x1c/0x28
[   36.170942]  do_one_initcall+0xd4/0x268
[   36.174793]  kernel_init_freeable+0x270/0x2d8
[   36.179168]  kernel_init+0x14/0x124
[   36.182670]  ret_from_fork+0x10/0x34
[   36.186256]
[   36.187749] The buggy address belongs to the object at ffff04101bc93200
[   36.187749]  which belongs to the cache kmalloc-128 of size 128
[   36.200335] The buggy address is located 16 bytes inside of
[   36.200335]  128-byte region [ffff04101bc93200, ffff04101bc93280)
[   36.212046] The buggy address belongs to the page:
[   36.216864] page:(____ptrval____) refcount:1 mapcount:0 
mapping:0000000000000000 index:0x0 pfn:0x4101bc92
[   36.226479] head:(____ptrval____) order:1 compound_mapcount:0
[   36.232253] flags: 0x2bfffc0000010200(slab|head)
[   36.236895] raw: 2bfffc0000010200 dead000000000100 dead000000000122 
ffff00104000fc00
[   36.244679] raw: 0000000000000000 0000000000200020 00000001ffffffff 
0000000000000000
[   36.252459] page dumped because: kasan: bad access detected
[   36.258055]
[   36.259545] Memory state around the buggy address:
[   36.264358]  ffff04101bc93100: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   36.271616]  ffff04101bc93180: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[   36.278874] >ffff04101bc93200: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   36.286130]                          ^
[   36.289893]  ffff04101bc93280: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[   36.297151]  ffff04101bc93300: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   36.304406] 
==================================================================
[   36.311663] Disabling lock debugging due to kernel taint
