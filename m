Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94B2C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 12:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbiBQMtj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 07:49:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbiBQMth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 07:49:37 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980B02A82D7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 04:49:22 -0800 (PST)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JzvlR6xD4z67PcV;
        Thu, 17 Feb 2022 20:48:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 17 Feb 2022 13:49:19 +0100
Received: from [10.47.81.42] (10.47.81.42) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 12:49:19 +0000
Message-ID: <28cfcd43-e006-ab26-2d58-47384ae49146@huawei.com>
Date:   Thu, 17 Feb 2022 12:49:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
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
 <ba58ea9e-430a-ec22-e67a-ceb632e99f33@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <ba58ea9e-430a-ec22-e67a-ceb632e99f33@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.42]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>
>>
>> I figured out what is happening here and it does not help solve the
>> mystery of my hang.
>>
>> Here's the steps:
>> a. scsi_cmnd times out
>> b. scsi error handling kicks in
>> c. libsas attempts to abort the task, which fails
>> d. libsas then tries IT nexus reset, which passes
>>    - libsas assumes the scsi_cmnd has completed with failure
>> e. error handling concludes
>> f. scsi midlayer then retries the same scsi_cmnd
>> g. since we did not "free" associated ccb earlier or dma unmap at d.,
>> the dma unmap on the same scsi_cmnd causes the warn
>>
>> So the LLD should really free resources and dma unmap at point IT nexus
>> reset completes, but it doesn't. I think in certain conditions dma map
>> should not be done twice.
>>
>> Anyway, that can be fixed, but I still have the hang :(
> 
> I guess (a) (cmd timeout) is only the symptom of the hang ? That is, the
> hang is causing the timeout ?

Right

> It may be good to turn on scsi trace to see if the command was only
> partially done, or not at all, or if it is a non-data command.
> 

I could do that. But I think that the command just does not complete. Or 
maybe it is missed.

> And speaking of errors, I am currently testing v4 of my series and
> noticed some weird things in the error handling. E.g., with one of the
> test executing a report zones command with an LBA out of range, I see this:
> 
> [23962.027105] pm80xx0:: mpi_sata_event  2788:SATA EVENT 0x23
> [23962.036099] pm80xx0:: pm80xx_send_read_log  1863:Executing read log end
> 

I don't know why the driver even does this, but the implementation of 
pm80xx_send_read_log() is questionable. It would be nice to not see ATA 
code in the driver like this.

> All good: this is IO_XFER_ERROR_ABORTED_NCQ_MODE. And the read log is to
> get the drive queue out of error state.
> 
> [23962.046101] pm80xx0:: mpi_sata_event  2788:SATA EVENT 0x26
> 
> This is IO_XFER_ERROR_UNEXPECTED_PHASE. No clue what this is doing.
> 
> [23962.054947] pm80xx0:: mpi_sata_event  2805:task or dev null
> 
> Why ?
> 
> [23962.063865] pm80xx0:: pm80xx_send_abort_all  1796:Executing abort
> task end
> 
> All queued commands are aborted when the read log completes. Again, per
> ATA NCQ specs, all good. After that, normal (some useless) messages.
> 
> [23962.063964] pm80xx0:: mpi_sata_completion  2395:IO failed device_id
> 16388 status 0x1 tag 1
> [23962.084587] pm80xx0:: mpi_sata_completion  2430:SAS Address of IO
> Failure Drive:50010860002f5657
> [23962.095526] sas: sas_ata_task_done: SAS error 0x8d
> [23962.139470] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [23962.147897] ata24.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 0x0
> [23962.156253] ata24.00: failed command: RECEIVE FPDMA QUEUED
> [23962.163307] ata24.00: cmd 65/01:00:00:00:0c/00:02:23:01:00/40 tag 11
> ncq dma 512 in
> [23962.163307]          res 43/10:00:00:00:00/00:00:00:00:00/00 Emask
> 0x480 (invalid argument) <F>
> 
> Good here, correct error...
> 
> [23962.182879] ata24.00: status: { DRDY SENSE ERR }
> [23962.189100] ata24.00: error: { IDNF }
> 
> ... but I need to look at this in libata. Getting the same with AHCI.

ok, in a way that is a relief.

> 
> [23962.215456] ata24.00: configured for UDMA/133
> [23962.221469] ata24: EH complete
> [23962.226056] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1
> tries: 1
> 
> That event 0x26 and the "task or dev null" are obscure. No clue, but
> they look wrong.

As above, I doubt the implemenation of that code. It alloc's a domain 
device itself, which is not how things should be done.

> 
> Overall, this driver is by default way too verbose I think. I would
> prefer to reduce the above to something like:
> 
> [23962.095526] sas: sas_ata_task_done: SAS error 0x8d
> [23962.139470] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [23962.147897] ata24.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 0x0
> [23962.156253] ata24.00: failed command: RECEIVE FPDMA QUEUED
> [23962.163307] ata24.00: cmd 65/01:00:00:00:0c/00:02:23:01:00/40 tag 11
> ncq dma 512 in
> [23962.163307]          res 43/10:00:00:00:00/00:00:00:00:00/00 Emask
> 0x480 (invalid argument) <F>
> [23962.182879] ata24.00: status: { DRDY SENSE ERR }
> [23962.189100] ata24.00: error: { IDNF }
> [23962.215456] ata24.00: configured for UDMA/133
> [23962.221469] ata24: EH complete
> [23962.226056] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1
> tries: 1
> 
> That is, by default, remove most FAIL messages, changing them to DEV
> level. The same test with a SAS drive is totally silent, as it should
> be, since the command error is not a fatal one.
> 
> But not touching this for now. I first want the series to be queued.
> 

In response to later message:

On 17/02/2022 11:47, Damien Le Moal wrote:
 >> Anyway, that can be fixed, but I still have the hang:(
 > One thought: could it be bug with the DMA engine of your platform ?
 > What if you simply run an fio workload on the disk directly (no FS),
 > hang happens too ?

I did try fio a while ago and it worked ok. Strange.

 > For the bugs I fixed with my series, it was the reverse: fio worked
 > great but everything broke down when I ran libzbc tests...
 >

I got a few more things to try but need to make progress on my libsas 
series now ...

Thanks,
John




