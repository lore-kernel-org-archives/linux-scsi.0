Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2982FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 12:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA58A23120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 12:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbhAMMTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 07:19:40 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2333 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbhAMMTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 07:19:39 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DG5x36q9mz67bTR;
        Wed, 13 Jan 2021 20:15:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 13 Jan 2021 13:18:57 +0100
Received: from [10.47.0.70] (10.47.0.70) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 13 Jan
 2021 12:18:56 +0000
Subject: Re: About scsi device queue depth
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <20210112014203.GA60605@T590>
 <4b50f067-a368-2197-c331-a8c981f5cd02@huawei.com>
 <20210112090634.GA97446@T590>
 <e5832d8b-383c-9734-85a1-6f36bdb5a773@huawei.com>
 <7a342a60943cd7ed28d319b189c105ba@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <16a66e96-a08f-78d1-155a-41bb5d31f2d1@huawei.com>
Date:   Wed, 13 Jan 2021 12:17:47 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7a342a60943cd7ed28d319b189c105ba@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.70]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/01/2021 11:44, Kashyap Desai wrote:
>>>> loops = 10000
>>> Is there any effect on random read IOPS when you decrease sdev queue
>>> depth? For sequential IO, IO merge can be enhanced by that way.
>>>
>> Let me check...
> John - Can you check your test with rq_affinity = 2  and nomerges=2 ?
> 
> I have noticed similar drops (whatever you have reported) -  "once we reach
> near pick of sdev or host queue depth, sometimes performance drop due to
> contention."
> But this behavior keep changing since kernel changes in this area is very
> actively happened in past. So I don't know the exact details about kernel
> version etc.
> I have similar setup (16 SSDs) and I will try similar test on latest kernel.
> 
> BTW - I remember that rq_affinity=2 play major role in such issue.  I
> usually do testing with rq_affinity = 2.
> 

Hi Kashyap,

As requested:

rq_affinity=1, nomerges=0 (default)

sdev queue depth	num jobs=1
8			1650
16			1638
32			1612
64			1573
254			1435 (default for LLDD)

rq_affinity=2, nomerges=2

sdev queue depth	num jobs=1
8			1236
16			1423
32			1438
64			1438
254			1438 (default for LLDD)

Setup as original: fio read, 12x SAS SSDs

So, again, we see that performance changes from changing sdev queue 
depth depends on workload and then also other queue config.

Thanks,
John
