Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1072DCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 10:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E3920578
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 10:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409111AbfJYKNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 06:13:15 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407875AbfJYKNP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 06:13:15 -0400
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 9DA69D10119049096D05;
        Fri, 25 Oct 2019 11:13:13 +0100 (IST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 25 Oct 2019 11:13:13 +0100
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 25 Oct
 2019 11:13:13 +0100
Subject: Re: [PATCH V4 1/2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
To:     Ming Lei <ming.lei@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Hannes Reinecke" <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        "Bart Van Assche" <bart.vanassche@wdc.com>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-2-ming.lei@redhat.com>
 <7d95de12-6114-c0d7-8b21-d36b2ea020fc@huawei.com>
 <20191024005828.GB15426@ming.t460p>
 <19e73b4d-77c7-e776-fee4-8b9f078c2be5@huawei.com>
 <20191024212427.GA26168@ming.t460p>
 <fb0d3475-b9b9-bac2-ec44-5c4cff67a104@huawei.com>
 <20191025094315.GA6128@ming.t460p>
From:   John Garry <john.garry@huawei.com>
Message-ID: <36eb068c-37ed-756f-17ef-113aa55a17d0@huawei.com>
Date:   Fri, 25 Oct 2019 11:13:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191025094315.GA6128@ming.t460p>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/10/2019 10:43, Ming Lei wrote:
> On Fri, Oct 25, 2019 at 09:58:16AM +0100, John Garry wrote:
>>
>>>> In scsi_host.h, we have for scsi_host_template.can_queue: "It is set to the
>>>> maximum number of simultaneous commands a given host adapter will accept.",
>>>> so that should be honoured.
>>>
>>
>> Hi Ming,
>>
>>> That words should have been changed to:
>>>
>>> "It is set to the maximum number of simultaneous commands a given host adapter's
>>> hw queue will accept."
>>

Hi Ming,

>> I find this definition misleading. As you know, some MQ SAS HBAs can accept
>> .can_queue commands on a given hw queue, but can still only accept
>> .can_queue commands over all hw queues.
> 
> I don't know there are such MQ HBA driver in tree, 

HiSilicon SAS HBA can accept 4096 commands on any given hw queue but can 
also only accept 4096 commands over all queues simultaneously.  In fact, 
the hw queue depth is configurable.

That's why I think that the definition is misleading.

I think I sound like a broken record now :)

at least that is the
> current blk-mq/scsi-mq model: each hw queue has its own independent
> tags, so there can't be the limit for MQ HBA, which should allow to
> accept (.can_queue * nr_hw_queues) commands. And I did hear people
> complains bad performance caused by the atomic .host_busy counter.
> 

ok, seems reasonable for now.

> If you are talking about the current SQ(from blk-mq or scsi-mq viewpoint) HBA
> which has multiple reply queue(HPSA, hisilicon SAS, mpt3sas, and megaraid_sas),
> they are just the special type. According to scsi-mq's model, they should
> belong to SQ HBA.
> 
>>
>>>
>>>>
>>>> And Scsi_host.nr_hw_queues: "it is assumed that each hardware queue has a
>>>> queue depth of can_queue. In other words, the total queue depth per host is
>>>> nr_hw_queues * can_queue."
>>>
>>> The above is correct.
>>>
>>>>
>>>> I don't read "total queue depth per host" same as "maximum number of
>>>> simultaneous commands a given host adapter will accept". If anything, the
>>>> nr_hw_queues comment is ambiguous.
>>>>
>>>>>
>>>>> The point is simple, because each hw queue has its own independent tags,
>>>>> that is why I mentioned your Hisilicon SAS can't be converted to MQ
>>>>> easily cause this hardware has only single shared tags.
>>>>
>>>> Please be aware that HiSilicon SAS HW would not be unique for SCSI HBAs in
>>>> this regard, in that the unique hostwide tag is not just for HBA HW IO
>>>> management, but also is used as the tag for SCSI TMFs.
>>>
>>> Right.
>>>
>>>>
>>>> Just checking mpt3sas seems similar:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/mpt3sas/mpt3sas_scsih.c#n2918
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/mpt3sas/mpt3sas_base.c#n3546
>>>
>>> Not only mpt3sas, there are also HPSA and more. And these drivers have to
>>> support single hw queue of blk-mq, instead of real MQ. And the reason is that
>>> these HBA has single tags.
>>
>> We should be able to do better than that.
>>
>> For a start, at least doesn't the check you remove in scsi_host_is_busy()
>> limit commands the HBA accepts to .can_queue?
> 
> As I mentioned above, that is current blk-mq/scsi-mq's model, each hw
> queue has its own independent tags, so the check really doesn't make
> sense. >
>>
>> And if you make the change in this patch, then the changes to improve blk-mq
>> for CPU hotplug are pointless, as we can't change the SAS HBAs to expose
>> multiple queues.
> 
> No, just the small number of special type SCSI HBAs with multiple reply queue
> and single tags can't benefit from the patchset of 'improve blk-mq for CPU hotplug',
> and all other normal MQ device/drivers do get improved wrt. CPU hotplug.
> 

TBH, I'm not sure on the group of SCSI drivers which could benefit then.

As I see, only qla2xxx driver sets Scsi_host.nr_hw_queues and also uses 
pci_alloc_irq_vectors_affinity().

> We have tried hosttags approach for the several drivers, but looks it is
> too messy. Given there are only 3 or 4 such device, we still can improve
> them via driver private approach in future if no generic way is doable.

ok, I'd rather not go on this path - you may say I'm digging my head in 
the sand. Anyway, I'll continue to support the 'improve blk-mq for CPU 
hotplug' effort.

Thanks,
John


> 
> 
> Thanks,
> Ming
> 
> .
> 

