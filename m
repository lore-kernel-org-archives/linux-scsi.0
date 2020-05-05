Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CE9C47254
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 08:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514262068E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 08:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgEEIix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 04:38:53 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbgEEIiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 May 2020 04:38:52 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2B6F5618EAFAC83BB0B5;
        Tue,  5 May 2020 09:38:51 +0100 (IST)
Received: from [127.0.0.1] (10.210.167.68) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Tue, 5 May 2020
 09:38:50 +0100
Subject: Re: [PATCH RFC v3 37/41] libsas: add tag to struct sas_task
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-38-hare@suse.de>
 <61c1be62-c2f1-8d0d-9533-ba3cf671d666@huawei.com>
 <4361894d-c9b7-c601-56b4-35846f27c8e7@suse.de>
 <57c8f0c8-1314-d3ea-af89-2a730ddd2d6e@huawei.com>
 <0ee56dd8-3116-56c5-0cdb-a1e5a168c287@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <fc657373-4df0-6b45-4c56-8e6792e34504@huawei.com>
Date:   Tue, 5 May 2020 09:38:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0ee56dd8-3116-56c5-0cdb-a1e5a168c287@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.167.68]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/05/2020 09:00, Hannes Reinecke wrote:
> On 5/4/20 9:49 AM, John Garry wrote:
>>>>> -
>>>>> +    task->tag = cmd->request->tag;
>>>>>        task->scatter = scsi_sglist(cmd);
>>>>>        task->num_scatter = scsi_sg_count(cmd);
>>>>>        task->total_xfer_len = scsi_bufflen(cmd);
>>>>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>>>>> index c927228019c9..af864f68b5cc 100644
>>>>> --- a/include/scsi/libsas.h
>>>>> +++ b/include/scsi/libsas.h
>>>>> @@ -594,6 +594,8 @@ struct sas_task {
>>>>>        u32    total_xfer_len;
>>>>>        u8     data_dir:2;      /* Use PCI_DMA_... */
>>>>> +    u32    tag;
>>>>
>>>> unsigned, yet we assign it -1?
>>>>
>>> Yeah, that's how the block layer does internally, too.
>>> Maybe we should export SCSI_NO_TAG and use it here.
>>>
>>
>> I think it's better that the LLDD would not have to deal with "no tag" 
>> scenario (pm8001 driver has to handle it in this series). Rather 
>> libsas can handle that, and fail an allocation of a slow_task to the 
>> LLDD instead.
>>
> I fully agree. The 'no tag' scenario should never happen with libsas 
> with this patchset.
> But for that to happen we need to:
> - Ensure that even ATA devices on libsas always have a domain device (I 
> think it's true nowadays, but we'll need to check).

They should do. See references to sas_ata_init(), which is at the 2x 
points of ATA dev discovery - root port and expander remote port.

> - Add a host port to libsas, such that sas_alloc_target() will have a 
> valid target/port upon lookup (and your patch won't be needed anymore)

I think that they should already have for ATA devices.

> - Move ATA non-SCSI commands over to using sas slow tasks. This 
> shouldn't be much of a problem as really the only non-SCSI ATA command 
> which will need to be sent from within an I/O stream is the 'read log'
> command, and that is handled internally by the drivers anyway.

ok

> All other commands are sent during device discovery or from out-of-band 
> things like ioctl, so they should be fine using slow tasks.
> 

ok

Cheers,
John
