Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5A3C4BA24
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 12:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98AF12468E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 12:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgB0McJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 07:32:09 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2472 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728999AbgB0McJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 07:32:09 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8388F5E079568FD6D2C8;
        Thu, 27 Feb 2020 12:32:06 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 27 Feb 2020 12:32:03 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Thu, 27 Feb
 2020 12:32:03 +0000
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>
CC:     Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        "Kashyap Desai" <kashyap.desai@broadcom.com>,
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com>
Date:   Thu, 27 Feb 2020 12:32:02 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAAO+jF-P3MkB2mo6pmYH1ihjRGpfjkkgXZg9dAZ29nYmU6T2=A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
>     Is blk_mq_hw_ctx.nr_active really the same as scsi_device.device_busy?
> 
> *Both of them are not the same but it serves our purpose to get the 
> number of outstanding io requests. Please refer below link for more 
> details:*
> 
> https://lore.kernel.org/linux-scsi/20191105002334.GA11436@ming.t460p/

Thanks for the pointer, but there did not seem to be a conclusion there: 
https://lore.kernel.org/linux-scsi/20191105002334.GA11436@ming.t460p/

Anyway, if we move to exposing multiple HW queues in the megaraid SAS 
driver:

  host->nr_hw_queues = instance->msix_vectors -
                       instance->low_latency_index_start;

Then hctx->nr_active will no longer be the total active requests per 
host, but rather per hctx.

In addition, hctx->nr_active will no longer be properly maintained, as 
it would be based on the hctx HW queue actually being used by the LLDD 
for that request, which is not always true now. That is because in 
megasas_get_msix_index() a judgement may be made to use a low-latency HW 
queue instead:

static inline void
megasas_get_msix_index(struct megasas_instance *instance,
		       struct scsi_cmnd *scmd,
		       struct megasas_cmd_fusion *cmd,
		       u8 data_arms)
{
...

sdev_busy = atomic_read(&hctx->nr_active);

if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
     sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
	cmd->request_desc->SCSIIO.MSIxIndex =
			mega_mod64(...),
	else if (instance->msix_load_balance)
		cmd->request_desc->SCSIIO.MSIxIndex =
			(mega_mod64(...),
				instance->msix_vectors));

Will this make a difference? I am not sure. Maybe, on this basis, 
magaraid sas is not a good candidate to change to expose multiple queues.

Ignoring that for a moment, since we no longer keep a host busy count, 
and I figure that we don't want to back to using 
scsi_device.device_busy, is the judgement of hctx->nr_active ok to use 
to decide whether to use these performance queues?

Thanks,
John
