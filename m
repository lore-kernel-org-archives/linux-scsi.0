Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100DBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 10:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbiBQKri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 05:47:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiBQKrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 05:47:36 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB161DF25B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 02:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645094840; x=1676630840;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=XV79uhJiPhZdpb+nOlyMWLX0rnZ0u4Ex5TEAbrH+6Vc=;
  b=dcVA+UKMwkHU5kyqqnJGfyQHFw/KPNuhWEGgBdp3jSYm+Ra4WazU3y6X
   P5+fGQrRqgSiDkGr53vWYMqFriXo/XbHrl+eRxWOatlI8OfVyHt8/K169
   60Q7dkafQLI6NinHFCPkuhgTjijU7CEr833aUlDHE3bH7Z1/E81RtSNW9
   35m1STpVNTZ/ae+3/jBbNXRb/VLVGmSkPJYpY0G1vL5p835sZEjXiwb9H
   MYVJbyXWpfnKyt+F0PUaekyVil2alnX2KHByGT1ck9mUhH8rAGXm34fvJ
   4N4Mvj/hYM3mtWVBXNvbqcqe6w7oiuihR8wpQsw9TjSnPd3RvBBDLVrC2
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297293166"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 18:47:19 +0800
IronPort-SDR: 28jCyJSRyUmBHifiMikGh1K/cucO+SKAlAenVCizowtjYCkYFOYabcIoEoO+ahWZXVA8jnuZbG
 6Rt4j0HY0r9PqJfYDPj177d8CsuF9OF+gH7+eyJhjMkBCN3dE7M1YkNdVYAg/v08iZHwmx24og
 wjwTzhaGPVV1u5d9GGHhO+1LhPpjbKgTP6aBPD9a2Cd7lvQhJEh8iGIHVe4HvGsp93Wp8iuVQK
 135yPpJrsKjyv8s4wko33JzTpEtVd5NsEC9xPoG1feHx7C9mEd1qePNQb7dx22BijB6AQfhFS/
 vYB6ksTP85K4XoiQNdLlKjQS
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 02:20:05 -0800
IronPort-SDR: /tkJXDj4PlqOtuNgn5apTF8cZLoTHh0d+Cvkj4LWLGO6Rv8HCwJUxIC96JwnpWnnvZoZ6MLzZo
 IqSPxtmQqZ+Tqg6PJeqSUhd0mj7HfXgsTXbzIkpQzK3eQQjiayVK5W7I7jnBfAT+DB7Yu9sBUh
 +JAYc8BjlEEZJt8G3EOmF67CaeWyVDi9Zo1E1ObukvrWe2g6oQMSQLhtsxfhFynFKZzoVkI+ar
 TVhvs1fopRHb5cAskdueu/u0y+b+urWAMYk9nCC4crdj4qajsVZdpw0gZXtTMth35p3B1sIT2I
 CzE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 02:47:20 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzs3C0hlxz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 02:47:19 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645094838; x=1647686839; bh=XV79uhJiPhZdpb+nOlyMWLX0rnZ0u4Ex5TE
        AbrH+6Vc=; b=MF8UvvG/f2zsqJ5RAzlPjToKkCIrfFoPP+XZaIr4RlYvPVXN5rC
        dS69Xd3f5L1T+bdlXaoto5Ac0/9S0xgwB82w6Bcb4WVdUoKY/RSBhzllUXP0gc3J
        Ltd1ucMYUXou9CQwpcoBP+3F7VDtTbWLoxKKzVuL9vA3dx8AYmKwbIapv1zKmGJV
        PCI5MOhSXLGrmDfaY4aa/mg0Kh38qGolaQlT3NhMNVLeepKXjdyozETkyboEMjh0
        /t+JjE6tuzC+AeBuW/LyE4y2FbpIy2iJmYrUGZHSakeG2yS2oiRxg6tbLVqh3z9n
        fvA6bfzjyOLQdNyr/LYOR624hCq+cJ5x1mA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ywxtP5NIF99P for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 02:47:18 -0800 (PST)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzs391zQrz1Rwrw;
        Thu, 17 Feb 2022 02:47:17 -0800 (PST)
Message-ID: <ba58ea9e-430a-ec22-e67a-ceb632e99f33@opensource.wdc.com>
Date:   Thu, 17 Feb 2022 19:47:15 +0900
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
 <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
 <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/22 18:23, John Garry wrote:
> On 17/02/2022 00:12, Damien Le Moal wrote:
>>>>> I'll have a look at it. And that is on mainline or mkp-scsi staging, and
>>>>> not your patchset.
>>>> Are you saying that my patches suppresses the above ? This is submission
>>>> path and the dma code seems to complain about alignment... So bad buffer
>>>> addresses ?
>>> Your series does not suppress it. It doesn't occur often, so I need to
>>> check more.
>>>
>>> I think the issue is that we call dma_map_sg() twice, i.e. ccb never
>>> unmapped.
>> That would be a big issue indeed. We could add a flag to CCBs to track
>> the buf_prd DMA mapping state and BUG_ON() when ccb free function is
>> called with the buffer still mapped. That should allow catching this
>> infrequent problem ?
>>
> 
> I figured out what is happening here and it does not help solve the 
> mystery of my hang.
> 
> Here's the steps:
> a. scsi_cmnd times out
> b. scsi error handling kicks in
> c. libsas attempts to abort the task, which fails
> d. libsas then tries IT nexus reset, which passes
>   - libsas assumes the scsi_cmnd has completed with failure
> e. error handling concludes
> f. scsi midlayer then retries the same scsi_cmnd
> g. since we did not "free" associated ccb earlier or dma unmap at d., 
> the dma unmap on the same scsi_cmnd causes the warn
> 
> So the LLD should really free resources and dma unmap at point IT nexus 
> reset completes, but it doesn't. I think in certain conditions dma map 
> should not be done twice.
> 
> Anyway, that can be fixed, but I still have the hang :(

I guess (a) (cmd timeout) is only the symptom of the hang ? That is, the
hang is causing the timeout ?
It may be good to turn on scsi trace to see if the command was only
partially done, or not at all, or if it is a non-data command.

And speaking of errors, I am currently testing v4 of my series and
noticed some weird things in the error handling. E.g., with one of the
test executing a report zones command with an LBA out of range, I see this:

[23962.027105] pm80xx0:: mpi_sata_event  2788:SATA EVENT 0x23
[23962.036099] pm80xx0:: pm80xx_send_read_log  1863:Executing read log end

All good: this is IO_XFER_ERROR_ABORTED_NCQ_MODE. And the read log is to
get the drive queue out of error state.

[23962.046101] pm80xx0:: mpi_sata_event  2788:SATA EVENT 0x26

This is IO_XFER_ERROR_UNEXPECTED_PHASE. No clue what this is doing.

[23962.054947] pm80xx0:: mpi_sata_event  2805:task or dev null

Why ?

[23962.063865] pm80xx0:: pm80xx_send_abort_all  1796:Executing abort
task end

All queued commands are aborted when the read log completes. Again, per
ATA NCQ specs, all good. After that, normal (some useless) messages.

[23962.063964] pm80xx0:: mpi_sata_completion  2395:IO failed device_id
16388 status 0x1 tag 1
[23962.084587] pm80xx0:: mpi_sata_completion  2430:SAS Address of IO
Failure Drive:50010860002f5657
[23962.095526] sas: sas_ata_task_done: SAS error 0x8d
[23962.139470] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[23962.147897] ata24.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 0x0
[23962.156253] ata24.00: failed command: RECEIVE FPDMA QUEUED
[23962.163307] ata24.00: cmd 65/01:00:00:00:0c/00:02:23:01:00/40 tag 11
ncq dma 512 in
[23962.163307]          res 43/10:00:00:00:00/00:00:00:00:00/00 Emask
0x480 (invalid argument) <F>

Good here, correct error...

[23962.182879] ata24.00: status: { DRDY SENSE ERR }
[23962.189100] ata24.00: error: { IDNF }

... but I need to look at this in libata. Getting the same with AHCI.

[23962.215456] ata24.00: configured for UDMA/133
[23962.221469] ata24: EH complete
[23962.226056] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1
tries: 1

That event 0x26 and the "task or dev null" are obscure. No clue, but
they look wrong.

Overall, this driver is by default way too verbose I think. I would
prefer to reduce the above to something like:

[23962.095526] sas: sas_ata_task_done: SAS error 0x8d
[23962.139470] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[23962.147897] ata24.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 0x0
[23962.156253] ata24.00: failed command: RECEIVE FPDMA QUEUED
[23962.163307] ata24.00: cmd 65/01:00:00:00:0c/00:02:23:01:00/40 tag 11
ncq dma 512 in
[23962.163307]          res 43/10:00:00:00:00/00:00:00:00:00/00 Emask
0x480 (invalid argument) <F>
[23962.182879] ata24.00: status: { DRDY SENSE ERR }
[23962.189100] ata24.00: error: { IDNF }
[23962.215456] ata24.00: configured for UDMA/133
[23962.221469] ata24: EH complete
[23962.226056] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1
tries: 1

That is, by default, remove most FAIL messages, changing them to DEV
level. The same test with a SAS drive is totally silent, as it should
be, since the command error is not a fatal one.

But not touching this for now. I first want the series to be queued.




-- 
Damien Le Moal
Western Digital Research
