Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F826C10F14
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 16:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40CF12064A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 16:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387827AbfJOQSF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:18:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbfJOQSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 12:18:02 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6A11845CFA3A86B36F55;
        Wed, 16 Oct 2019 00:17:55 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 16 Oct 2019
 00:17:53 +0800
Subject: Re: ahci KASAN warning in experimental arm64 allmodconfig boot
To:     <linux-ide@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
References: <758acedf-4007-9937-e777-bd1371c84e21@huawei.com>
 <67ee2965-7907-a9aa-b7e8-c5c9bf3ea1fc@huawei.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <bdf02e03-86a1-3d35-2908-28187f504495@huawei.com>
Date:   Tue, 15 Oct 2019 17:17:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <67ee2965-7907-a9aa-b7e8-c5c9bf3ea1fc@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/10/2019 15:17, John Garry wrote:
>>
>>
>> I'll continue to look at this as time allows.
>>
>> I have cc'ed the scsi list as this may be related to the SAS host (using
>> libsas), but I'm doubtful, considering the log mentions ahci_init_one().
>>
>
> It may very well be related - just CONFIG_DEBUG_TEST_DRIVER_REMOVE
> triggers this WARN:
>
> [   23.452574] ------------[ cut here ]------------
> [   23.457190] WARNING: CPU: 59 PID: 1 at drivers/ata/libata-core.c:6676
> ata_host_detach+0x15c/0x168
> [   23.466047] Modules linked in:
> [   23.469092] CPU: 59 PID: 1 Comm: swapper/0 Not tainted
> 5.4.0-rc1-00010-g5b83fd27752b-dirty #296
> [   23.477776] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI
> RC0 - V1.16.01 03/15/2019
> [   23.486286] pstate: a0c00009 (NzCv daif +PAN +UAO)
> [   23.491065] pc : ata_host_detach+0x15c/0x168
> [   23.495322] lr : ata_host_detach+0x88/0x168
> [   23.499491] sp : ffff800011cabb50
> [   23.502792] x29: ffff800011cabb50 x28: 0000000000000007
> [   23.508091] x27: ffff80001137f068 x26: ffff8000112c0c28
> [   23.513390] x25: 0000000000003848 x24: ffff0023ea185300
> [   23.518689] x23: 0000000000000001 x22: 00000000000014c0
> [   23.523987] x21: 0000000000013740 x20: ffff0023bdc20000
> [   23.529286] x19: 0000000000000000 x18: 0000000000000004
> [   23.534584] x17: 0000000000000001 x16: 00000000000000f0
> [   23.539883] x15: ffff0023eac13790 x14: ffff0023eb76c408
> [   23.545181] x13: 0000000000000000 x12: ffff0023eac13790
> [   23.550480] x11: ffff0023eb76c228 x10: 0000000000000000
> [   23.555779] x9 : ffff0023eac13798 x8 : 0000000040000000
> [   23.561077] x7 : 0000000000000002 x6 : 0000000000000001
> [   23.566376] x5 : 0000000000000002 x4 : 0000000000000000
> [   23.571674] x3 : ffff0023bf08a0bc x2 : 0000000000000000
> [   23.576972] x1 : 3099674201f72700 x0 : 0000000000400284
> [   23.582272] Call trace:
> [   23.584706]  ata_host_detach+0x15c/0x168
> [   23.588616]  ata_pci_remove_one+0x10/0x18
> [   23.592615]  ahci_remove_one+0x20/0x40
> [   23.596356]  pci_device_remove+0x3c/0xe0
> [   23.600267]  really_probe+0xdc/0x3e0
> [   23.603830]  driver_probe_device+0x58/0x100
> [   23.608000]  device_driver_attach+0x6c/0x90
> [   23.612169]  __driver_attach+0x84/0xc8
> [   23.615908]  bus_for_each_dev+0x74/0xc8
> [   23.619730]  driver_attach+0x20/0x28
> [   23.623292]  bus_add_driver+0x148/0x1f0
> [   23.627115]  driver_register+0x60/0x110
> [   23.630938]  __pci_register_driver+0x40/0x48
> [   23.635199]  ahci_pci_driver_init+0x20/0x28
> [   23.639372]  do_one_initcall+0x5c/0x1b0
> [   23.643199]  kernel_init_freeable+0x1a4/0x24c
> [   23.647546]  kernel_init+0x10/0x108
> [   23.651023]  ret_from_fork+0x10/0x18
> [   23.654590] ---[ end trace 634a14b675b71c13 ]---
>
> I'll dig deeper if I get a chance.
>

So it seems that problem comes from the way we async probe the ata_port.

What I find is that at the point when we async probe the ata_port, with 
CONFIG_DEBUG_TEST_DRIVER_REMOVE set we start to detach the driver and 
tear everything down before the probe runs.

There's no synchronisation in detach to ensure that the probe has 
actually completed, and when it does, use-after-free, WARNs, etc...

This change fixes the issue for me:

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 28c492be0a57..ff3d4ab81818 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6708,6 +6708,8 @@ void ata_host_detach(struct ata_host *host)
  {
         int i;

+       async_synchronize_full();
+
         for (i = 0; i < host->n_ports; i++)
                 ata_port_detach(host->ports[i]);



> John
>
>> Thanks,


