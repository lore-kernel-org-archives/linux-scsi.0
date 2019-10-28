Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A32CA9EA0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 09:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E246E20B7C
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 09:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbfJ1Jml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 05:42:41 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2057 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732063AbfJ1Jml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Oct 2019 05:42:41 -0400
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2EE2BDEAC21FFA498016;
        Mon, 28 Oct 2019 09:42:40 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 28 Oct 2019 09:42:39 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 28 Oct
 2019 09:42:39 +0000
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
 <36eb068c-37ed-756f-17ef-113aa55a17d0@huawei.com>
 <20191025215311.GA7076@ming.t460p>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8a442c8b-f424-3923-c276-6f77c6eb8b57@huawei.com>
Date:   Mon, 28 Oct 2019 09:42:39 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191025215311.GA7076@ming.t460p>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>>
>>> I don't know there are such MQ HBA driver in tree,
>>
>> HiSilicon SAS HBA can accept 4096 commands on any given hw queue but can
>> also only accept 4096 commands over all queues simultaneously.  In fact, the
>> hw queue depth is configurable.
>>
>> That's why I think that the definition is misleading.
> 
> That is why we call HiSilicon SAS is SQ device, still from
> blk-mq/scsi-mq viewpoint, :-)

Sure, but this is the Scsi host interface, not the blk-mq interface.

So I think that the Scsi host interface is somewhat deficient as things 
stand (for same reason I gave). It can be revisited.

> 
>>
>> I think I sound like a broken record now :)
>>
>> at least that is the
>>> current blk-mq/scsi-mq model: each hw queue has its own independent
>>> tags, so there can't be the limit for MQ HBA, which should allow to
>>> accept (.can_queue * nr_hw_queues) commands. And I did hear people
>>> complains bad performance caused by the atomic .host_busy counter.
>>>
>>

[...]

>>
>> TBH, I'm not sure on the group of SCSI drivers which could benefit then.
>>
>> As I see, only qla2xxx driver sets Scsi_host.nr_hw_queues and also uses
>> pci_alloc_irq_vectors_affinity().
> 
> Other non-SCSI drivers can benefit from that patchset too, such as NVMe.
> 
> Except for qla2xxx, there are also lpfc, virtio-scsi and smartpqi, and
> there will be more since I heard that new version of one other popular
> SCSI HBA will support real MQ.

OK, fine. So please check my latest reply on that thread when you have a 
chance - I may have found an issue.

> 
>>
>>> We have tried hosttags approach for the several drivers, but looks it is
>>> too messy. Given there are only 3 or 4 such device, we still can improve
>>> them via driver private approach in future if no generic way is doable.
>>
>> ok, I'd rather not go on this path - you may say I'm digging my head in the
>> sand. Anyway, I'll continue to support the 'improve blk-mq for CPU hotplug'
>> effort.
> 
> I meant that way is the last straw, :-)

ok

Thanks,
John

> 
> 
> Thanks,
> Ming
> 
> .
> 

