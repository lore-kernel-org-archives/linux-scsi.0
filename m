Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CCBC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 12:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbhKXMdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:33:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4158 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244115AbhKXMcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 07:32:00 -0500
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HzgF22r94z6889W;
        Wed, 24 Nov 2021 20:24:54 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 13:28:48 +0100
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 12:28:47 +0000
From:   John Garry <john.garry@huawei.com>
Subject: [issue report] pm8001 driver crashes with IOMMU enabled
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Message-ID: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
Date:   Wed, 24 Nov 2021 12:28:46 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

When I enable the IOMMU on my arm64 system, the pm8001 driver crashes as 
follows:

[    8.649365] pm80xx 0000:04:00.0: Adding to iommu group 0
[    8.655901] pm80xx 0000:04:00.0: pm80xx: driver version 0.1.40
[    8.661755] pm80xx 0000:04:00.0: enabling device (0140 -> 0142)
[    8.667864] :: pm8001_pci_alloc  530:Setting link rate to default value
[    9.716548] scsi host0: pm80xx
[   10.423522] Freeing initrd memory: 413456K
[   11.693443] Unable to handle kernel paging request at virtual address 
ffff0000fcebfb00
[   11.701348] Mem abort info:
[   11.704129]   ESR = 0x96000005
[   11.707170]   EC = 0x25: DABT (current EL), IL = 32 bits
[   11.712468]   SET = 0, FnV = 0
[   11.715510]   EA = 0, S1PTW = 0
[   11.718637]   FSC = 0x05: level 1 translation fault
[   11.723501] Data abort info:
[   11.726368]   ISV = 0, ISS = 0x00000005
[   11.730190]   CM = 0, WnR = 0
[   11.733145] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000013d43000
[   11.739832] [ffff0000fcebfb00] pgd=18000a4fffff8003, 
p4d=18000a4fffff8003, pud=0000000000000000
[   11.748521] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[   11.754080] Modules linked in:
[   11.757122] CPU: 1 PID: 7 Comm: kworker/u192:0 Not tainted 
5.16.0-rc2-dirty #102
[   11.764505] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI 
RC0 - V1.16.01 03/15/2019
[   11.773015] Workqueue: 0000:04:00.0_disco_q sas_discover_domain
[   11.778926] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[   11.785874] pc : pm80xx_chip_smp_req+0x2d0/0x3d0
[   11.790479] lr : pm80xx_chip_smp_req+0xac/0x3d0
[   11.794996] sp : ffff80001258ba60
[   11.798297] x29: ffff80001258ba60 x28: ffff0020a2892b50 x27: 
ffff0020a2898000
[   11.805421] x26: ffff0020a3ee0000 x25: 0000000000000008 x24: 
ffff0000fcebfb00
[   11.812546] x23: ffff8000113ab6b8 x22: 0000000000000000 x21: 
ffff0020a3ed0038
[   11.819670] x20: ffff0020a2890000 x19: ffff80001258badc x18: 
00000000fffffffb
[   11.826794] x17: 0000000000000000 x16: 0000000000000000 x15: 
0000000000000000
[   11.833917] x14: 0000000000000000 x13: 0000000000000000 x12: 
0000000000000002
[   11.841041] x11: 00000a20098b1000 x10: ffff0020b36515f0 x9 : 
0000000000001000
[   11.848165] x8 : 00000a20098b0000 x7 : ffff8000117eb7f0 x6 : 
0000000000000001
[   11.855288] x5 : 0000000000000f44 x4 : 0000000000001000 x3 : 
0000000000000000
[   11.862412] x2 : ffff8000113ab698 x1 : 0000000000000004 x0 : 
ffff8000117eb000
[   11.869535] Call trace:
[   11.871969]  pm80xx_chip_smp_req+0x2d0/0x3d0
[   11.876226]  pm8001_task_exec.constprop.0+0x368/0x520
[   11.881266]  pm8001_queue_command+0x1c/0x30
[   11.885437]  smp_execute_task_sg+0xdc/0x204
[   11.889607]  sas_discover_expander.part.0+0xac/0x6cc
[   11.894559]  sas_discover_root_expander+0x8c/0x150
[   11.899337]  sas_discover_domain+0x3ac/0x6a0
[   11.903594]  process_one_work+0x1d0/0x354
[   11.907592]  worker_thread+0x13c/0x470
[   11.911328]  kthread+0x17c/0x190
[   11.914545]  ret_from_fork+0x10/0x20
[   11.918110] Code: 371806e1 910006d6 6b16033f 54000249 (38766b05)
[   11.924192] ---[ end trace b91d59aaee98ea2d ]---
[   11.928796] note: kworker/u192:0[7] exited with preempt_count 1


I notice that the driver is calling virt_to_phys() on a dma_addr_t, 
which is broken:

static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
struct pm8001_ccb_info *ccb)
{
char *preq_dma_addr = NULL;
__le64 tmp_addr;

tmp_addr = cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));
preq_dma_addr = (char *)phys_to_virt(tmp_addr);

How is this supposed to work? I assume that someone has enabled the 
IOMMU on a system with one of these cards before.

I have encountered some other RAID cards which bypasses the IOMMU to 
access host memory - is that the case here potentially?

Thanks,
John
