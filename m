Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA03C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 00:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbiBQAMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 19:12:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiBQAMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 19:12:19 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9DC8594C
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 16:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645056725; x=1676592725;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=8Mu7PsbDT2D4WLF4zxReP0JSARlgAOCB36MBEr2p7z0=;
  b=UOSM5lpVQ7LkZTNn130WzIv7R2nFjrwW/ngiUVx+Ulvy/6ktULZFC02s
   D6dZ+zELbxafGYIyG0OrYkaavccGRGdGeNKhTFoiamKx9fYExx01fviup
   9iNi5lPbK6GNKYdcTjRHrgakAE8vdfGxH79uPmCiUO8gwD+ka613Z3KIp
   Kilf3cF00m910OWWh0x3/4cPXYfzaG4ZdyxrRrEO8U2kYNZU/jb8WQ+6L
   d1u7/qqH7tQtiJ8dL28LIktRCA1qhu7qa1ul7m0vX+8JhBBouT2DBVMRd
   Cd3rGDf6zfsyabmqnCvAwYHRw41p76nuX3Lw+jM5btLN8BcrApTssRSvY
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,374,1635177600"; 
   d="scan'208";a="193137738"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 08:12:05 +0800
IronPort-SDR: bRsctxqH858iBeD6zKu2Yqbza+ku6V17bhH3AHAT7DiNhSXQtORAOOV5Muduz3l8NCVor6xUcS
 U+K9wXSm14FwF2zvEOmgU+W59Sv2lDQ8jiogFfbGzb9TpILyO8xH5XsqdRIaTwnNMToE8+ZMuy
 m1xjnbQYWmi6kZtsI3gkLFcED2zsIQjISV1seQlTauEy0tzREgzQVhUtJjqzC6Km9kmgF8wC7b
 6dJjG1Me8yQw09qfk4fCFsTDd2r1qkkk7JTM/p+l3yDFYXg8gHsdQlFY7GQrXF66AkzsiBiqrO
 0XGNDN0SOdpYZN28cgz54j99
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 15:44:52 -0800
IronPort-SDR: QBluuVDsA1pQEraI/2O5KSobyC8f2HXGvAYhKxJoicFZiNvdfTQlWR7+IsMDBEUGsTk44HcOrF
 XKubCOSHEfcCjfelmZG4uJU65FQI3XV1qfPGj8qlIJhAPZIfqrLiVxN50eLFRx7Fwh1Qcn+bfv
 KeNlEzdGDE9p+m7BMyBI/PwCFXHnspcLQ2EMxvZ2B3ZGcPbG7+9Fu3eQmZCx2kX5UaEK6c+1t1
 r5YgKzZmcB/On62BVTke+gTrNoHgmxhy7RVQTfh2ahgAFrXDWMV8UTXjOH8D1FbUXvQgza4vsB
 nj0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 16:12:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzZyD6vW4z1SVp1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 16:12:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645056724; x=1647648725; bh=8Mu7PsbDT2D4WLF4zxReP0JSARlgAOCB36M
        BEr2p7z0=; b=Xwo/vDNCKKGhOC9w1uGsTsZMS+VzGUxYGmScijewllF0Hfq7BR5
        THybqZEuEmzwBmAUQKzir7n4tFPe0xnX7eL5g6pf8p1XHc1cfZO92HBT5yT1wlnr
        TkAgyVY6bnADABPh1ilSfFnW7FqSGRkU4L2NuMPJy9WiN9LlM4T8iCF8tSAe3fP1
        6CTdZVJjBmUFrE63wCwuVxUXTmv5+pGg8nynRLoeqwWYy9u/+ftawgBAyB+9NUml
        GtHjnpvSFWIAsIPO5DlsvNmIkAyRepM6tWe4alafJ8KUSQAy6BJc+MAE3evaFz1g
        hi12wr/9xtOoOTqzP3rdNtbAI8NY7DwJX7g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id opqBm5i3KVC6 for <linux-scsi@vger.kernel.org>;
        Wed, 16 Feb 2022 16:12:04 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzZyC2ZW0z1Rwrw;
        Wed, 16 Feb 2022 16:12:03 -0800 (PST)
Message-ID: <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
Date:   Thu, 17 Feb 2022 09:12:02 +0900
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
 <9c22abeb-1b22-4613-66bc-276aaa4a639c@opensource.wdc.com>
 <e7b5c48b-4217-7247-8bc9-e5f8ae9411ce@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <e7b5c48b-4217-7247-8bc9-e5f8ae9411ce@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/22 21:21, John Garry wrote:
> 
>>> JFYI, turning on DMA debug sometimes gives this even after fdisk -l:
>>>
>>> [   45.080945] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
>>> [   45.087582] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
>>
>> What is status 0x3b ? Is this a driver thing or sas thing ? Have not
>> checked.
> 
> This is a driver thing. I'd need the manual to check.
> 
>>
>>> [   45.093681] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO
>>> Failure Drive:5000c50085ff5559
>>> [   45.102641] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
>>> [   45.108739] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO
>>> Failure Drive:5000c50085ff5559
>>> [   45.117694] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
>>> [   45.123792] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO
>>> Failure Drive:5000c50085ff5559
>>> [   45.132652] pm80xx: rc= -5
>>
>> This comes from pm8001_query_task(), pm8001_abort_task() or
>> pm8001_chip_abort_task()...
>>
>>> [   45.135370] sas: sas_scsi_find_task: task 0x(____ptrval____) result
>>> code -5 not handled
>>
>> Missing error handling ?
> 
> This is something I added. So the driver does not return a valid TMF 
> code - it returns -5, which I think comes from pm8001_query_task() -> 
> pm8001_exec_internal_tmf_task(). And sas_scsi_find_task() does not 
> recognise -5 and just assumes that the TMF failed, so ...
> 
>>
>>> [   45.143466] sas: task 0x(____ptrval____) is not at LU: I_T recover
>>> [   45.149741] sas: I_T nexus reset for dev 5000c50085ff5559
>>> [   47.183916] sas: I_T 5000c50085ff5559 recovered
>>
>> Weird... Losing your drive ? Bad cable ?
> 
> .. we escalate the error handling and call sas_eh_handle_sas_errors() -> 
> sas_recover_I_T(), which resets the PHY - see pm8001_I_T_nexus_reset().
> 
>>
>>> [   47.189034] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1
>>> tries: 1
>>> [   47.204168] ------------[ cut here ]------------
>>> [   47.208829] DMA-API: pm80xx 0000:04:00.0: cacheline tracking EEXIST,
>>> overlapping mappings aren't supported
>>> [   47.218502] WARNING: CPU: 3 PID: 641 at kernel/dma/debug.c:570
>>> add_dma_entry+0x308/0x3f0
>>> [   47.226607] Modules linked in:
>>> [   47.229678] CPU: 3 PID: 641 Comm: kworker/3:1H Not tainted
>>> 5.17.0-rc1-11918-gd9d909a8c666 #407
>>> [   47.238298] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI
>>> RC0 - V1.16.01 03/15/2019
>>> [   47.246829] Workqueue: kblockd blk_mq_run_work_fn
>>> [   47.251552] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS
>>> BTYPE=--)
>>> [   47.258522] pc : add_dma_entry+0x308/0x3f0
>>> [   47.262626] lr : add_dma_entry+0x308/0x3f0
>>> [   47.266730] sp : ffff80002e5c75f0
>>> [   47.270049] x29: ffff80002e5c75f0 x28: 0000002880a908c0 x27:
>>> ffff80000cc95440
>>> [   47.277216] x26: ffff80000cc94000 x25: ffff80000cc94e20 x24:
>>> ffff00208e4660c8
>>> [   47.284382] x23: ffff800009d16b40 x22: ffff80000a5b8700 x21:
>>> 1ffff00005cb8eca
>>> [   47.291548] x20: ffff80000caf4c90 x19: ffff0a2009726100 x18:
>>> 0000000000000000
>>> [   47.298713] x17: 70616c7265766f20 x16: 2c54534958454520 x15:
>>> 676e696b63617274
>>> [   47.305879] x14: 1ffff00005cb8df4 x13: 0000000041b58ab3 x12:
>>> ffff700005cb8e27
>>> [   47.313044] x11: 1ffff00005cb8e26 x10: ffff700005cb8e26 x9 :
>>> dfff800000000000
>>> [   47.320210] x8 : ffff80002e5c7137 x7 : 0000000000000001 x6 :
>>> 00008ffffa3471da
>>> [   47.327375] x5 : ffff80002e5c7130 x4 : dfff800000000000 x3 :
>>> ffff8000083a1f48
>>> [   47.334540] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
>>> ffff00208f7ab200
>>> [   47.341706] Call trace:
>>> [   47.344157]  add_dma_entry+0x308/0x3f0
>>> [   47.347914]  debug_dma_map_sg+0x3ac/0x500
>>> [   47.351931]  __dma_map_sg_attrs+0xac/0x130
>>> [   47.356037]  dma_map_sg_attrs+0x14/0x2c
>>> [   47.359883]  pm8001_task_exec.constprop.0+0x5e0/0x800
>>> [   47.364945]  pm8001_queue_command+0x1c/0x2c
>>> [   47.369136]  sas_queuecommand+0x2c4/0x360
>>> [   47.373153]  scsi_queue_rq+0x810/0x1334
>>> [   47.377000]  blk_mq_dispatch_rq_list+0x340/0xda0
>>> [   47.381625]  __blk_mq_sched_dispatch_requests+0x14c/0x22c
>>> [   47.387034]  blk_mq_sched_dispatch_requests+0x60/0x9c
>>> [   47.392095]  __blk_mq_run_hw_queue+0xc8/0x274
>>> [   47.396460]  blk_mq_run_work_fn+0x30/0x40
>>> [   47.400476]  process_one_work+0x494/0xbac
>>> [   47.404494]  worker_thread+0xac/0x6d0
>>> [   47.408164]  kthread+0x174/0x184
>>> [   47.411401]  ret_from_fork+0x10/0x2[   45.080945] sas:
>>> sas_scsi_find_task: querying task 0x(____ptrval____)
>>> [   45.087582] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
>>> [   45.093681] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO
>>> Failure Drive:5000c50085ff5559
>>> [   45.102641] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
>>> [   45.108739] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO
>>> Failure Drive:5000c50085ff5559
>>> [   45.117694] pm80xx0:: mpi_ssp_completion  1936:sas IO status 0x3b
>>> [   45.123792] pm80xx0:: mpi_ssp_completion  1947:SAS Address of IO
>>> Failure Drive:5000c50085ff5559
>>> [   45.132652] pm80xx: rc= -5
>>> [   45.135370] sas: sas_scsi_find_task: task 0x(____ptrval____) result
>>> code -5 not handled
>>> [   45.143466] sas: task 0x(____ptrval____) is not at LU: I_T recover
>>> [   45.149741] sas: I_T nexus reset for dev 5000c50085ff5559
>>> [   47.183916] sas: I_T 5000c50085ff5559 recovered
>>> [   47.189034] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1
>>> tries: 1
>>> [   47.204168] ------------[ cut here ]------------
>>> [   47.208829] DMA-API: pm80xx 0000:04:00.0: cacheline tracking EEXIST,
>>> overlapping mappings aren't supported
>>> [   47.218502] WARNING: CPU: 3 PID: 641 at kernel/dma/debug.c:570
>>> add_dma_entry+0x308/0x3f0
>>> [   47.226607] Modules linked in:
>>> [   47.229678] CPU: 3 PID: 641 Comm: kworker/3:1H Not tainted
>>> 5.17.0-rc1-11918-gd9d909a8c666 #407
>>> [   47.238298] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI
>>> RC0 - V1.16.01 03/15/2019
>>> [   47.246829] Workqueue: kblockd blk_mq_run_work_fn
>>> [   47.251552] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS
>>> BTYPE=--)
>>> [   47.258522] pc : add_dma_entry+0x308/0x3f0
>>> [   47.262626] lr : add_dma_entry+0x308/0x3f0
>>> [   47.266730] sp : ffff80002e5c75f0
>>> [   47.270049] x29: ffff80002e5c75f0 x28: 0000002880a908c0 x27:
>>> ffff80000cc95440
>>> [   47.277216] x26: ffff80000cc94000 x25: ffff80000cc94e20 x24:
>>> ffff00208e4660c8
>>> [   47.284382] x23: ffff800009d16b40 x22: ffff80000a5b8700 x21:
>>> 1ffff00005cb8eca
>>> [   47.291548] x20: ffff80000caf4c90 x19: ffff0a2009726100 x18:
>>> 0000000000000000
>>> [   47.298713] x17: 70616c7265766f20 x16: 2c54534958454520 x15:
>>> 676e696b63617274
>>> [   47.305879] x14: 1ffff00005cb8df4 x13: 0000000041b58ab3 x12:
>>> ffff700005cb8e27
>>> [   47.313044] x11: 1ffff00005cb8e26 x10: ffff700005cb8e26 x9 :
>>> dfff800000000000
>>> [   47.320210] x8 : ffff80002e5c7137 x7 : 0000000000000001 x6 :
>>> 00008ffffa3471da
>>> [   47.327375] x5 : ffff80002e5c7130 x4 : dfff800000000000 x3 :
>>> ffff8000083a1f48
>>> [   47.334540] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
>>> ffff00208f7ab200
>>> [   47.341706] Call trace:
>>> [   47.344157]  add_dma_entry+0x308/0x3f0
>>> [   47.347914]  debug_dma_map_sg+0x3ac/0x500
>>> [   47.351931]  __dma_map_sg_attrs+0xac/0x130
>>> [   47.356037]  dma_map_sg_attrs+0x14/0x2c
>>> [   47.359883]  pm8001_task_exec.constprop.0+0x5e0/0x800
>>> [   47.364945]  pm8001_queue_command+0x1c/0x2c
>>> [   47.369136]  sas_queuecommand+0x2c4/0x360
>>> [   47.373153]  scsi_queue_rq+0x810/0x1334
>>> [   47.377000]  blk_mq_dispatch_rq_list+0x340/0xda0
>>> [   47.381625]  __blk_mq_sched_dispatch_requests+0x14c/0x22c
>>> [   47.387034]  blk_mq_sched_dispatch_requests+0x60/0x9c
>>> [   47.392095]  __blk_mq_run_hw_queue+0xc8/0x274
>>> [   47.396460]  blk_mq_run_work_fn+0x30/0x40
>>> [   47.400476]  process_one_work+0x494/0xbac
>>> [   47.404494]  worker_thread+0xac/0x6d0
>>> [   47.408164]  kthread+0x174/0x184
>>> [   47.411401]  ret_from_fork+0x10/0x2
>>>
>>> I'll have a look at it. And that is on mainline or mkp-scsi staging, and
>>> not your patchset.
>>
>> Are you saying that my patches suppresses the above ? This is submission
>> path and the dma code seems to complain about alignment... So bad buffer
>> addresses ?
> 
> Your series does not suppress it. It doesn't occur often, so I need to 
> check more.
> 
> I think the issue is that we call dma_map_sg() twice, i.e. ccb never 
> unmapped.

That would be a big issue indeed. We could add a flag to CCBs to track
the buf_prd DMA mapping state and BUG_ON() when ccb free function is
called with the buffer still mapped. That should allow catching this
infrequent problem ?

> 
> Thanks,
> John
> 


-- 
Damien Le Moal
Western Digital Research
