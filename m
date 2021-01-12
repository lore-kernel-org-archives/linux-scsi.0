Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874F5C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 10:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DCC222D05
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 10:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390766AbhALK3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 05:29:49 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2313 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389949AbhALK3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 05:29:49 -0500
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFRXk5GFlz67Zbq;
        Tue, 12 Jan 2021 18:25:10 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 11:29:01 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 10:29:00 +0000
Subject: Re: About scsi device queue depth
To:     <jejb@linux.ibm.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
CC:     chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
 <b51fc658-b28a-d627-a2a3-b2835132ab13@huawei.com>
 <62b562eae9830830d87ea9f92dcc0018a1935583.camel@linux.ibm.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <571e3700-2850-3a5d-8fd0-91425a4f810a@huawei.com>
Date:   Tue, 12 Jan 2021 10:27:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <62b562eae9830830d87ea9f92dcc0018a1935583.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.61]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>
>> For this case, it seems the opposite - less is more. And I seem to
>> be hitting closer to the sweet spot there, with more merges.
> 
> I think cheaper SSDs have a write latency problem due to erase block
> issues.  I suspect all SSDs have a channel problem in that there's a
> certain number of parallel channels and once you go over that number
> they can't actually work on any more operations even if they can queue
> them.  For cheaper (as in fewer channels, and less spare erased block
> capacity) SSDs there will be a benefit to reducing the depth to some
> multiplier of the channels (I'd guess 2-4 as the multiplier).  When
> SSDs become write throttled, there may be less benefit to us queueing
> in the block layer (merging produces bigger packets with lower
> overhead, but the erase block consumption will remain the same).
> 
> For the record, the internet thinks that cheap SSDs have 2-4 channels,
> so that would argue a tag depth somewhere from 4-16

I have seen upto 10-channel devices mentioned being "high end" - this 
would mean upto 40 queue depth using on 4x multiplier; so, based on 
that, the current value of 254 for that driver seems way off.

> 
>>> SSDs have a peculiar lifetime problem in that when they get
>>> erase block starved they start behaving more like spinning rust in
>>> that they reach a processing limit but only for writes, so lowering
>>> the write queue depth (which we don't even have a knob for) might
>>> be a good solution.  Trying to track the erase block problem has
>>> been a constant bugbear.
>>
>> I am only doing read performance test here, and the disks are SAS3.0
>> SSDs HUSMM1640ASS204, so not exactly slow.
> 
> Possibly ... the stats on most manufacturer SSDs don't give you
> information about the channels or spare erase blocks.

For my particular disk, this is the datasheet/manual:
https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/data-sheet-ultrastar-ssd1600ms.pdf

https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/product-manual-ultrastar-ssd1600mr-1-92tb.pdf

And I didn't see explicit info regarding channels or spare erase blocks, 
as you expect.

> 
>>> I'm assuming you're using spinning rust in the above, so it sounds
>>> like the firmware in the card might be eating the queue full
>>> returns.  Icould see this happening in RAID mode, but it shouldn't
>>> happen in jbod mode.
>>
>> Not sure on that, but I didn't check too much. I did try to increase
>> fio queue depth and sdev queue depth to be very large to clobber the
>> disks, but still nothing.
> 
> If it's an SSD it's likely not giving the queue full you'd need to get
> the mid-layer to throttle automatically.
> 

So it seems that the queue depth we select should depend on class of 
device, but then the value can also affect write performance.

As for my issue today, I can propose a smaller value for the mpt3sas 
driver based on my limited tests, and see how the driver maintainers 
feel about it.

I just wonder what intelligence we can add for this. And whether LLDDs 
should be selecting this (queue depth) at all, unless they (the HBA) 
have some limits themselves.

You did mention maybe a separate write queue depth - could this be a 
solution?

Thanks,
John
