Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C00C3B189
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 10:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A0A3217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 10:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgBMKHf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 05:07:35 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2419 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729428AbgBMKHf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 05:07:35 -0500
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 084F856825ACC3C28FFE;
        Thu, 13 Feb 2020 10:07:33 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 13 Feb 2020 10:07:32 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 13 Feb
 2020 10:07:32 +0000
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Ming Lei" <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
 <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
 <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com>
 <CAL2rwxpLY1xfbiW4CZ6nWF7W8_zLWS+a+W6XC6emcVm96XetNw@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ab0397bf-19a0-41b1-3bd6-a08dbdd94cdb@huawei.com>
Date:   Thu, 13 Feb 2020 10:07:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAL2rwxpLY1xfbiW4CZ6nWF7W8_zLWS+a+W6XC6emcVm96XetNw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/01/2020 11:18, Sumit Saxena wrote:
>>>> or doing a performance test here.
>>> Hi Hannes,
>>>

Hi Sumit,

>>> Sorry for the delay in replying, I observed a few issues with this patchset:
>>>
>>> 1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
>>> which IO submitter CPU is affined with. Due to this IO submission and
>>> completion CPUs are different which causes performance drop for low
>>> latency workloads.
>> Hi Sumit,
>>
>> So the new code has:
>>
>> megasas_build_ldio_fusion()
>> {
>>
>> cmd->request_desc->SCSIIO.MSIxIndex =
>> blk_mq_unique_tag_to_hwq(tag);
>>
>> }
>>
>> So the value here is hw queue index from blk-mq point of view, and not
>> megaraid_sas msix index, as you alluded to.
> Yes John, value filled in "cmd->request_desc->SCSIIO.MSIxIndex" is HW
> queue index.
> 
>> So we get 80 msix, 8 are reserved for low_latency_index_start (that's
>> how it seems to me), and we report other 72 as #hw queues = 72 to SCSI
>> midlayer.
>>
>> So I think that this should be:
>>
>> cmd->request_desc->SCSIIO.MSIxIndex =
>> blk_mq_unique_tag_to_hwq(tag) + low_latency_index_start;

Can you possibly test performance again with this local change, or would 
you rather an updated patchset be sent?

> Agreed, this should return correct HW queue index.
>>


Thanks,
John
