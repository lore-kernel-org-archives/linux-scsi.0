Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4640C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EBB560ED5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhJUNXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 09:23:14 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4017 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhJUNXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 09:23:09 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HZp0m2HLZz67wr1;
        Thu, 21 Oct 2021 21:16:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 21 Oct 2021 15:20:49 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 21 Oct 2021 14:20:48 +0100
Subject: Re: BUG: KASAN: use-after-free in blk_mq_sched_tags_teardown
To:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
CC:     linux-block <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        <lkft-triage@lists.linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh R <vigneshr@ti.com>,
        linux-mtd <linux-mtd@lists.infradead.org>
References: <CA+G9fYvv6YsRM2Qf7AGMo3nwqkuAt_D1i+6H_ApHk3kmScyDyg@mail.gmail.com>
 <CAK8P3a21U0jzMOUWp1rhrNrD3szxxrwo59SBYG89xpYJGXteRA@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <aae28ac1-aa3f-3602-8732-9b3a87e9cdf0@huawei.com>
Date:   Thu, 21 Oct 2021 14:20:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a21U0jzMOUWp1rhrNrD3szxxrwo59SBYG89xpYJGXteRA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/10/2021 13:20, Arnd Bergmann wrote:
> On Thu, Oct 21, 2021 at 2:01 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>>
>> Following KASAN BUG noticed on linux next 20211021 while booting qemu-arm64
>> with allmodconfig.
> 
>> [   77.730367][    T5] Freed by task 1:
>> [   77.732009][    T5]  kasan_save_stack+0x30/0x80
>> [   77.734083][    T5]  kasan_set_track+0x30/0x80
>> [   77.736085][    T5]  kasan_set_free_info+0x34/0x80
>> [   77.738261][    T5]  ____kasan_slab_free+0xfc/0x1c0
>> [   77.740433][    T5]  __kasan_slab_free+0x3c/0x80
>> [   77.742518][    T5]  slab_free_freelist_hook+0x1d4/0x2c0
>> [   77.744892][    T5]  kfree+0x160/0x300
>> [   77.746618][    T5]  blktrans_dev_release+0x64/0x100
>> [   77.748821][    T5]  del_mtd_blktrans_dev+0x1c0/0x240
>> [   77.751079][    T5]  mtdblock_remove_dev+0x28/0x80
>> [   77.753246][    T5]  blktrans_notify_remove+0xa4/0x140
>> [   77.755507][    T5]  del_mtd_device+0x84/0x1c0
>> [   77.757541][    T5]  mtd_device_unregister+0x90/0xc0
>> [   77.759764][    T5]  physmap_flash_remove+0x58/0x180
>> [   77.762012][    T5]  platform_remove+0x48/0xc0
>> [   77.764032][    T5]  __device_release_driver+0x1dc/0x340
>> [   77.766393][    T5]  driver_detach+0x138/0x200
>> [   77.768396][    T5]  bus_remove_driver+0x100/0x180
>> [   77.770554][    T5]  driver_unregister+0x64/0xc0
>> [   77.772633][    T5]  platform_driver_unregister+0x28/0x80
>> [   77.775042][    T5]  physmap_init+0xc4/0xfc
>> [   77.776994][    T5]  do_one_initcall+0xb0/0x2c0
>> [   77.779028][    T5]  do_initcalls+0x17c/0x244
>> [   77.781023][    T5]  kernel_init_freeable+0x2d4/0x378
>> [   77.783269][    T5]  kernel_init+0x34/0x180
>> [   77.785196][    T5]  ret_from_fork+0x10/0x20
>> [   77.787135][    T5]
>> ...
>> full boot log link,
>> https://pastebin.com/xL5MYSD6
> 
> I think this is related to an earlier bug that Anders reported a while ago,
> see [1]. I had looked at it originally, and found that this probably a
> device that gets probed from CONFIG_MTD_PHYSMAP_COMPAT
> and then freed again immediately after we find the device does not
> exist, starting with commit dcb3e137ce9b ("[MTD] physmap: make
> physmap compat explicit").
> 
> It's not really the fault of CONFIG_MTD_PHYSMAP_COMPAT
> describing a nonexisting device, but instead it's something in the
> cleanup path.
> 

Maybe there is more than one issue, but the fix I mentioned in my 
earlier reply resolves a UAF which can I trigger on my system:

[  674.333618] FAT-fs (sda1): unable to read boot sector to mark fs as dirty
[  674.422877] 
==================================================================
[  674.430097] BUG: KASAN: use-after-free in 
blk_mq_sched_tags_teardown+0xb4/0x12c
[  674.437412] Read of size 4 at addr ffff001053f40100 by task umount/557
[  674.443934]
[  674.445418] CPU: 6 PID: 557 Comm: umount Not tainted 
5.15.0-rc3-00045-g000f88ac8830 #420
[  674.453502] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 IT21 Nemo 2.0 RC0 04/18/2018
[  674.462626] Call trace:
[  674.465063]  dump_backtrace+0x0/0x2b4
[  674.468724]  show_stack+0x1c/0x30
[  674.472036]  dump_stack_lvl+0x68/0x84
[  674.475695]  print_address_description.constprop.0+0x74/0x2b8
[  674.481438]  kasan_report+0x1e4/0x24c
[  674.485096]  __asan_load4+0x98/0xd0
[  674.488579]  blk_mq_sched_tags_teardown+0xb4/0x12c
[  674.493366]  blk_mq_exit_sched+0x110/0x140
[  674.497459]  __elevator_exit+0x38/0x60
[  674.501203]  blk_release_queue+0x10c/0x1cc
[  674.505295]  kobject_put+0xac/0x180
[  674.508780]  blk_put_queue+0x18/0x24
[  674.512350]  disk_release+0x64/0x90
[  674.515836]  device_release+0x98/0x110
[  674.519581]  kobject_put+0xac/0x180
[  674.523065]  put_device+0x18/0x30
[  674.526374]  put_disk+0x30/0x44
[  674.529511]  part_release+0x28/0x4c
[  674.532993]  device_release+0x98/0x110
[  674.536737]  kobject_put+0xac/0x180
[  674.540221]  put_device+0x18/0x30
[  674.543531]  blkdev_put+0xe4/0x340
[  674.546930]  kill_block_super+0x60/0xa0
[  674.550762]  deactivate_locked_super+0x78/0x104
[  674.555289]  deactivate_super+0x90/0xac
[  674.559121]  cleanup_mnt+0x164/0x214
[  674.562691]  __cleanup_mnt+0x18/0x24
[  674.566260]  task_work_run+0xb8/0x1cc
[  674.569918]  do_notify_resume+0x11a8/0x1abc
[  674.574098]  el0_svc+0x6c/0x7c
[  674.577148]  el0t_64_sync_handler+0x1a8/0x1b0
[  674.581500]  el0t_64_sync+0x1a0/0x1a4
[  674.585157]
[  674.586639] The buggy address belongs to the page:
[  674.591420] page:(____ptrval____) refcount:0 mapcount:-128 
mapping:0000000000000000 index:0x0 pfn:0x1053f40
[  674.601154] flags: 0xbfffc0000000000(node=0|zone=2|lastcpupid=0xffff)
[  674.607594] raw: 0bfffc0000000000 fffffc00415ff008 ffff0017fbffebb0 
0000000000000000
[  674.615331] raw: 0000000000000000 0000000000000006 00000000ffffff7f 
0000000000000000
[  674.623065] page dumped because: kasan: bad access detected
[  674.628628]
[  674.630109] Memory state around the buggy address:
[  674.634891]  ffff001053f40000: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[  674.642105]  ffff001053f40080: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[  674.649319] >ffff001053f40100: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[  674.656531]                    ^
[  674.659751]  ffff001053f40180: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[  674.666964]  ffff001053f40200: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[  674.674177] 
==================================================================
[  674.681389] Disabling lock debugging due to kernel taint
root@(none)$
root@(none)$

Note that my baseline includes recent block changes which would be on 
next 20211021

Thanks,
John

>          Arnd
> 
> [1] https://lore.kernel.org/linux-mtd/CADYN=9Kjw_3cDGAvh9=+nNwdYof1kUPKG-SUOP5FsQhZ+gz62Q@mail.gmail.com/
> .
> 

