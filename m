Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CD8C3F2D4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 09:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C30AA246B9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 09:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCBJvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 04:51:51 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2486 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726956AbgCBJvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 04:51:51 -0500
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id E05B943D12E896C00195;
        Mon,  2 Mar 2020 09:51:49 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 09:51:49 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 2 Mar 2020
 09:51:49 +0000
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     Hannes Reinecke <hare@suse.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
CC:     <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
 <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de>
 <b5ab348d98b790578325140226f741c8@mail.gmail.com>
 <d7119a15-8be8-9fb2-3c50-8b0a6605982d@huawei.com>
 <CAAO+jF-P3MkB2mo6pmYH1ihjRGpfjkkgXZg9dAZ29nYmU6T2=A@mail.gmail.com>
 <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com>
 <79fe7843-9d71-bdde-957c-32dde22437d9@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <5ac6fd4f-eef8-700b-89d2-c8b3cd6e12ca@huawei.com>
Date:   Mon, 2 Mar 2020 09:51:48 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <79fe7843-9d71-bdde-957c-32dde22437d9@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> static inline void
>> megasas_get_msix_index(struct megasas_instance *instance,
>>                 struct scsi_cmnd *scmd,
>>                 struct megasas_cmd_fusion *cmd,
>>                 u8 data_arms)
>> {
>> ...
>>
>> sdev_busy = atomic_read(&hctx->nr_active);
>>
>> if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
>>      sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
>>      cmd->request_desc->SCSIIO.MSIxIndex =
>>              mega_mod64(...),
>>      else if (instance->msix_load_balance)
>>          cmd->request_desc->SCSIIO.MSIxIndex =
>>              (mega_mod64(...),
>>                  instance->msix_vectors));
>>
>> Will this make a difference? I am not sure. Maybe, on this basis, 
>> magaraid sas is not a good candidate to change to expose multiple queues.
>>
>> Ignoring that for a moment, since we no longer keep a host busy count, 
>> and I figure that we don't want to back to using 
>> scsi_device.device_busy, is the judgement of hctx->nr_active ok to use 
>> to decide whether to use these performance queues?
>>
> Personally, I wonder if the current implementation of high-IOPs queues 
> makes sense with multiqueue. > Thing is, the current high-IOPs queue mechanism of shifting I/O to
> another internal queue doesn't align nicely with the blk-mq architecture.

Right, we should not be hiding HW queues from blk-mq like this. This 
breaks the symmetry. Maybe we can move this functionality to blk-mq, but 
I doubt that this is a common use case.

> What we _do_ have, though, is a 'poll' queue mechanism, allowing to 
> separate out one (or several) queues for polling, to allow for .. 
> indeed, high-IOPs.

Any examples or references for this?

> So it would be interesting to figure out if we don't get similar 
> performance by using the 'poll' queue implementation from blk-mq instead 
> of the current one.

I thought that this driver/or mpt3sas already used a polling mode.

And for these low-latency queues, I figure that the issue is not just 
polling vs interrupt, but indeed how fast the HW queue can consume SQEs. 
A HW queue may only be able to consume at a limited rate - that's why we 
segregate.

As an aside, that is actually an issue for blk-mq. For 1 to many HW 
queue-to-CPU mapping, limiting many CPUs a single queue can limit IOPs 
since HW queues can only consume at a limited rate.

> 
> Which would also have the benefit that we could support the io_uring 
> interface natively with megaraid_sas, which I think would be a benefit 
> on its own.
> 

thanks,
John

