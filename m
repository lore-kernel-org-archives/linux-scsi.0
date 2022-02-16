Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C47C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 12:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbiBPMFv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 07:05:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbiBPMFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 07:05:44 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCB01DE59A
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 04:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645013131; x=1676549131;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=h9Ola9RwaK43sppcrIr1fdqV3VCvJ+fOGyJCKR3cqUU=;
  b=ll1kJcd9i876KMVgs0LnfzXZgLHm+JU2SPhXounCYMoHKt+kcc8JGSrZ
   lcLn32ez0ngZJD4IiJMLqMpXo+Br6QWIjNQgHcpJMzliweSIaV5jwTJgp
   rfRCCFAl4LqvYvw7sJXofQsJJXXHNV/WLWZnqUFOk8yLw+Ogk/s71s61P
   SKPqJGrlwlznoopJ9nGdbDP5z6tZTOtmIcznXHPEGh5NBZSKy9oFI4L2/
   Uq88qH9M9NIzDeIaPYwGyd7gtSVz1DQeIu5uePCtQtwUSFRiJfFbEJRIh
   bOyD5jPNqtqLAInjcBrIDUlb2lOENvvuafMgrcRdHcc7xuQH6oRw9VY1j
   w==;
X-IronPort-AV: E=Sophos;i="5.88,373,1635177600"; 
   d="scan'208";a="197912778"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2022 20:05:31 +0800
IronPort-SDR: Z2B6x4V//61Mg0neBxoEqhm1fZjevNWM/q3nBZawGP17nXvzl6WLzhiAbF1bK1yXf1CmOM7RRg
 evE4mSiUwKtQg95P7Hwlr83Wgn5Ry7nWHxJj/9/VMjiXaegs0kKOWwo1EyXfeUcuX3yMeNumY7
 5CY7akWlzcs63hbpVeNkNTbMOBBN8Mz6iUDc0d470nHjUCDYxQCC1zogDZjwX5jN5BTM9vpLxi
 tbX4cvm3FT7qTanoub+ziEwgW1oI+oL9t8bkr94ZnsgQFjrTQOqWoaK0PYTGWYaAGmTeWjFUzX
 yhFXYK+03rfeNWyEikBwBGA9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:37:11 -0800
IronPort-SDR: C0kYCUNDvFdV6gxG6x45X9EPxddutvMssXnossWRZ5LAvOgIfeMIwkGmLIWUFEespYniTwKm8v
 VdLy/ut0RRPFsQO7ZKgTzRN1EyWlk2P47KRa0ecQXDoxi20Q/gEUVO1p/YjSw8YbOHkz0FREfd
 2iqZox2GIKoW0sxjipKkwyqtTJZExF/Lu2XF7JmkKGzCXdTtGuXtrnzBQG58J8ch6XlKlXANNh
 hK+3aOcKqPRAVw0zhyPoCx8sYnjy6PoHNTZTSD44tP8Ca+Z2RY44Bf41E/KaekEKkVCwJCjVgd
 OlQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 04:05:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzGqv36Kdz1SVp2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 04:05:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645013130; x=1647605131; bh=h9Ola9RwaK43sppcrIr1fdqV3VCvJ+fOGyJ
        CKR3cqUU=; b=dWEvnPSLIyiy6Y2guGcrIJrulvhDnj+7cu6NxgG9guDBPAVF0g+
        2qJJ5VGZWJhfrHUZwFga1JO2nCmeTV2vtA4wERzqGjVz6yyALKrcQgl/LqMddF/O
        /+zXLDJ7gi+5tAlkrHHp2dgOIJb+mRL92Diq2INsi5FcMVxy6/ADiysbBuzk43y/
        UqpxJM/ss5kwq67Xn5bJ4D/SMeHHC35vL6vVKFBMwBW6xLbgRTrVT4u5yyukLYB0
        gmSQ065dfZXS3Hax5oAT6G4R1+UATrNOtOPvnVrOVL/KQH85QDL0OBvM9FigAqS7
        FX4q07VL/cXDcELOb+csvez4yOx+42EUa8g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FtydXtBCp7uv for <linux-scsi@vger.kernel.org>;
        Wed, 16 Feb 2022 04:05:30 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzGqs5Rbsz1Rwrw;
        Wed, 16 Feb 2022 04:05:29 -0800 (PST)
Message-ID: <9c22abeb-1b22-4613-66bc-276aaa4a639c@opensource.wdc.com>
Date:   Wed, 16 Feb 2022 21:05:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
 <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
 <37df3c92-c28e-72d4-76d8-33356829af5a@opensource.wdc.com>
 <5a5481af-e975-c6fb-2d48-961769eae551@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <5a5481af-e975-c6fb-2d48-961769eae551@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/22 20:50, John Garry wrote:
> On 16/02/2022 11:42, Damien Le Moal wrote:
>>> Hi Damien,
>>>
>>>> patch 30 cleans up pm8001_task_exec(). This patch is for
>>>> pm8001_queue_command(). I preferred to separate to facilitate review.
>>>> But if you insist, I can merge these into a much bigger "code cleanup"
>>>> patch...
>>>>
>>> I don't mind really.
>>>
>>> BTW, on a separate topic, IIRC you said that rmmod hangs for this driver
>>> - if so, did you investigate why?
>> The problem is gone with the fixes. I suspect it was due to the buggy
>> non-data command handling (likely, the flush issued when stopping the
>> device on rmmod).
>>
>> I have not tackled/tried again the QD change failure though.
>>
>> Preparing v4 now. Will check the QD change.
>>
> 
> ok, great.
> 
> JFYI, turning on DMA debug sometimes gives this even after fdisk -l:
> 
> [   45.080945] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
> [   45.087582] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b

What is status 0x3b ? Is this a driver thing or sas thing ? Have not
checked.

> [   45.093681] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO 
> Failure Drive:5000c50085ff5559
> [   45.102641] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
> [   45.108739] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO 
> Failure Drive:5000c50085ff5559
> [   45.117694] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
> [   45.123792] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO 
> Failure Drive:5000c50085ff5559
> [   45.132652] pm80xx: rc= -5

This comes from pm8001_query_task(), pm8001_abort_task() or
pm8001_chip_abort_task()...

> [   45.135370] sas: sas_scsi_find_task: task 0x(____ptrval____) result 
> code -5 not handled

Missing error handling ?

> [   45.143466] sas: task 0x(____ptrval____) is not at LU: I_T recover
> [   45.149741] sas: I_T nexus reset for dev 5000c50085ff5559
> [   47.183916] sas: I_T 5000c50085ff5559 recovered

Weird... Losing your drive ? Bad cable ?

> [   47.189034] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 
> tries: 1
> [   47.204168] ------------[ cut here ]------------
> [   47.208829] DMA-API: pm80xx 0000:04:00.0: cacheline tracking EEXIST, 
> overlapping mappings aren't supported
> [   47.218502] WARNING: CPU: 3 PID: 641 at kernel/dma/debug.c:570 
> add_dma_entry+0x308/0x3f0
> [   47.226607] Modules linked in:
> [   47.229678] CPU: 3 PID: 641 Comm: kworker/3:1H Not tainted 
> 5.17.0-rc1-11918-gd9d909a8c666 #407
> [   47.238298] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI 
> RC0 - V1.16.01 03/15/2019
> [   47.246829] Workqueue: kblockd blk_mq_run_work_fn
> [   47.251552] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS 
> BTYPE=--)
> [   47.258522] pc : add_dma_entry+0x308/0x3f0
> [   47.262626] lr : add_dma_entry+0x308/0x3f0
> [   47.266730] sp : ffff80002e5c75f0
> [   47.270049] x29: ffff80002e5c75f0 x28: 0000002880a908c0 x27: 
> ffff80000cc95440
> [   47.277216] x26: ffff80000cc94000 x25: ffff80000cc94e20 x24: 
> ffff00208e4660c8
> [   47.284382] x23: ffff800009d16b40 x22: ffff80000a5b8700 x21: 
> 1ffff00005cb8eca
> [   47.291548] x20: ffff80000caf4c90 x19: ffff0a2009726100 x18: 
> 0000000000000000
> [   47.298713] x17: 70616c7265766f20 x16: 2c54534958454520 x15: 
> 676e696b63617274
> [   47.305879] x14: 1ffff00005cb8df4 x13: 0000000041b58ab3 x12: 
> ffff700005cb8e27
> [   47.313044] x11: 1ffff00005cb8e26 x10: ffff700005cb8e26 x9 : 
> dfff800000000000
> [   47.320210] x8 : ffff80002e5c7137 x7 : 0000000000000001 x6 : 
> 00008ffffa3471da
> [   47.327375] x5 : ffff80002e5c7130 x4 : dfff800000000000 x3 : 
> ffff8000083a1f48
> [   47.334540] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 
> ffff00208f7ab200
> [   47.341706] Call trace:
> [   47.344157]  add_dma_entry+0x308/0x3f0
> [   47.347914]  debug_dma_map_sg+0x3ac/0x500
> [   47.351931]  __dma_map_sg_attrs+0xac/0x130
> [   47.356037]  dma_map_sg_attrs+0x14/0x2c
> [   47.359883]  pm8001_task_exec.constprop.0+0x5e0/0x800
> [   47.364945]  pm8001_queue_command+0x1c/0x2c
> [   47.369136]  sas_queuecommand+0x2c4/0x360
> [   47.373153]  scsi_queue_rq+0x810/0x1334
> [   47.377000]  blk_mq_dispatch_rq_list+0x340/0xda0
> [   47.381625]  __blk_mq_sched_dispatch_requests+0x14c/0x22c
> [   47.387034]  blk_mq_sched_dispatch_requests+0x60/0x9c
> [   47.392095]  __blk_mq_run_hw_queue+0xc8/0x274
> [   47.396460]  blk_mq_run_work_fn+0x30/0x40
> [   47.400476]  process_one_work+0x494/0xbac
> [   47.404494]  worker_thread+0xac/0x6d0
> [   47.408164]  kthread+0x174/0x184
> [   47.411401]  ret_from_fork+0x10/0x2[   45.080945] sas: 
> sas_scsi_find_task: querying task 0x(____ptrval____)
> [   45.087582] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
> [   45.093681] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO 
> Failure Drive:5000c50085ff5559
> [   45.102641] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
> [   45.108739] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO 
> Failure Drive:5000c50085ff5559
> [   45.117694] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
> [   45.123792] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO 
> Failure Drive:5000c50085ff5559
> [   45.132652] pm80xx: rc= -5
> [   45.135370] sas: sas_scsi_find_task: task 0x(____ptrval____) result 
> code -5 not handled
> [   45.143466] sas: task 0x(____ptrval____) is not at LU: I_T recover
> [   45.149741] sas: I_T nexus reset for dev 5000c50085ff5559
> [   47.183916] sas: I_T 5000c50085ff5559 recovered
> [   47.189034] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 
> tries: 1
> [   47.204168] ------------[ cut here ]------------
> [   47.208829] DMA-API: pm80xx 0000:04:00.0: cacheline tracking EEXIST, 
> overlapping mappings aren't supported
> [   47.218502] WARNING: CPU: 3 PID: 641 at kernel/dma/debug.c:570 
> add_dma_entry+0x308/0x3f0
> [   47.226607] Modules linked in:
> [   47.229678] CPU: 3 PID: 641 Comm: kworker/3:1H Not tainted 
> 5.17.0-rc1-11918-gd9d909a8c666 #407
> [   47.238298] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI 
> RC0 - V1.16.01 03/15/2019
> [   47.246829] Workqueue: kblockd blk_mq_run_work_fn
> [   47.251552] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS 
> BTYPE=--)
> [   47.258522] pc : add_dma_entry+0x308/0x3f0
> [   47.262626] lr : add_dma_entry+0x308/0x3f0
> [   47.266730] sp : ffff80002e5c75f0
> [   47.270049] x29: ffff80002e5c75f0 x28: 0000002880a908c0 x27: 
> ffff80000cc95440
> [   47.277216] x26: ffff80000cc94000 x25: ffff80000cc94e20 x24: 
> ffff00208e4660c8
> [   47.284382] x23: ffff800009d16b40 x22: ffff80000a5b8700 x21: 
> 1ffff00005cb8eca
> [   47.291548] x20: ffff80000caf4c90 x19: ffff0a2009726100 x18: 
> 0000000000000000
> [   47.298713] x17: 70616c7265766f20 x16: 2c54534958454520 x15: 
> 676e696b63617274
> [   47.305879] x14: 1ffff00005cb8df4 x13: 0000000041b58ab3 x12: 
> ffff700005cb8e27
> [   47.313044] x11: 1ffff00005cb8e26 x10: ffff700005cb8e26 x9 : 
> dfff800000000000
> [   47.320210] x8 : ffff80002e5c7137 x7 : 0000000000000001 x6 : 
> 00008ffffa3471da
> [   47.327375] x5 : ffff80002e5c7130 x4 : dfff800000000000 x3 : 
> ffff8000083a1f48
> [   47.334540] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 
> ffff00208f7ab200
> [   47.341706] Call trace:
> [   47.344157]  add_dma_entry+0x308/0x3f0
> [   47.347914]  debug_dma_map_sg+0x3ac/0x500
> [   47.351931]  __dma_map_sg_attrs+0xac/0x130
> [   47.356037]  dma_map_sg_attrs+0x14/0x2c
> [   47.359883]  pm8001_task_exec.constprop.0+0x5e0/0x800
> [   47.364945]  pm8001_queue_command+0x1c/0x2c
> [   47.369136]  sas_queuecommand+0x2c4/0x360
> [   47.373153]  scsi_queue_rq+0x810/0x1334
> [   47.377000]  blk_mq_dispatch_rq_list+0x340/0xda0
> [   47.381625]  __blk_mq_sched_dispatch_requests+0x14c/0x22c
> [   47.387034]  blk_mq_sched_dispatch_requests+0x60/0x9c
> [   47.392095]  __blk_mq_run_hw_queue+0xc8/0x274
> [   47.396460]  blk_mq_run_work_fn+0x30/0x40
> [   47.400476]  process_one_work+0x494/0xbac
> [   47.404494]  worker_thread+0xac/0x6d0
> [   47.408164]  kthread+0x174/0x184
> [   47.411401]  ret_from_fork+0x10/0x2
> 
> I'll have a look at it. And that is on mainline or mkp-scsi staging, and 
> not your patchset.

Are you saying that my patches suppresses the above ? This is submission
path and the dma code seems to complain about alignment... So bad buffer
addresses ?

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
