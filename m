Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E81C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 09:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3E86246A1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 09:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCBJRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 04:17:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:54620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgCBJRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 04:17:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5764CACCA;
        Mon,  2 Mar 2020 09:17:20 +0000 (UTC)
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     John Garry <john.garry@huawei.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Cc:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
 <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de>
 <b5ab348d98b790578325140226f741c8@mail.gmail.com>
 <d7119a15-8be8-9fb2-3c50-8b0a6605982d@huawei.com>
 <CAAO+jF-P3MkB2mo6pmYH1ihjRGpfjkkgXZg9dAZ29nYmU6T2=A@mail.gmail.com>
 <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <79fe7843-9d71-bdde-957c-32dde22437d9@suse.de>
Date:   Mon, 2 Mar 2020 10:17:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 1:32 PM, John Garry wrote:
>>
>>     Is blk_mq_hw_ctx.nr_active really the same as 
>> scsi_device.device_busy?
>>
>> *Both of them are not the same but it serves our purpose to get the 
>> number of outstanding io requests. Please refer below link for more 
>> details:*
>>
>> https://lore.kernel.org/linux-scsi/20191105002334.GA11436@ming.t460p/
> 
> Thanks for the pointer, but there did not seem to be a conclusion there: 
> https://lore.kernel.org/linux-scsi/20191105002334.GA11436@ming.t460p/
> 
> Anyway, if we move to exposing multiple HW queues in the megaraid SAS 
> driver:
> 
>   host->nr_hw_queues = instance->msix_vectors -
>                        instance->low_latency_index_start;
> 
> Then hctx->nr_active will no longer be the total active requests per 
> host, but rather per hctx.
> 
> In addition, hctx->nr_active will no longer be properly maintained, as 
> it would be based on the hctx HW queue actually being used by the LLDD 
> for that request, which is not always true now. That is because in 
> megasas_get_msix_index() a judgement may be made to use a low-latency HW 
> queue instead:
> 
> static inline void
> megasas_get_msix_index(struct megasas_instance *instance,
>                 struct scsi_cmnd *scmd,
>                 struct megasas_cmd_fusion *cmd,
>                 u8 data_arms)
> {
> ...
> 
> sdev_busy = atomic_read(&hctx->nr_active);
> 
> if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
>      sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
>      cmd->request_desc->SCSIIO.MSIxIndex =
>              mega_mod64(...),
>      else if (instance->msix_load_balance)
>          cmd->request_desc->SCSIIO.MSIxIndex =
>              (mega_mod64(...),
>                  instance->msix_vectors));
> 
> Will this make a difference? I am not sure. Maybe, on this basis, 
> magaraid sas is not a good candidate to change to expose multiple queues.
> 
> Ignoring that for a moment, since we no longer keep a host busy count, 
> and I figure that we don't want to back to using 
> scsi_device.device_busy, is the judgement of hctx->nr_active ok to use 
> to decide whether to use these performance queues?
> 
Personally, I wonder if the current implementation of high-IOPs queues 
makes sense with multiqueue.
Thing is, the current high-IOPs queue mechanism of shifting I/O to 
another internal queue doesn't align nicely with the blk-mq architecture.
What we _do_ have, though, is a 'poll' queue mechanism, allowing to 
separate out one (or several) queues for polling, to allow for .. 
indeed, high-IOPs.
So it would be interesting to figure out if we don't get similar 
performance by using the 'poll' queue implementation from blk-mq instead 
of the current one.

Which would also have the benefit that we could support the io_uring 
interface natively with megaraid_sas, which I think would be a benefit 
on its own.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
