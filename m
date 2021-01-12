Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E201C4332D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6861922E00
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390438AbhALJRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:17:15 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2311 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389835AbhALJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:17:15 -0500
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFPy82Wyrz67bPC;
        Tue, 12 Jan 2021 17:13:36 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 10:16:33 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 09:16:31 +0000
Subject: Re: About scsi device queue depth
To:     Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
CC:     chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <2b9a90c4-17e6-4935-bf3f-4bef54de27cc@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2deb6f66-a00e-270c-84c2-f2269d2094e4@huawei.com>
Date:   Tue, 12 Jan 2021 09:15:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <2b9a90c4-17e6-4935-bf3f-4bef54de27cc@suse.de>
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

On 12/01/2021 07:23, Hannes Reinecke wrote:
>>
>> So it seems to me that the block layer is merging more bios per 
>> request, as averge sg count per request goes up from 1 - > upto 6 or 
>> more. As I see, when queue depth lowers the only thing that is really 
>> changing is that we fail more often in getting the budget in 
>> scsi_mq_get_budget()->scsi_dev_queue_ready().
>>
>> So initial sdev queue depth comes from cmd_per_lun by default or 
>> manually setting in the driver via scsi_change_queue_depth(). It seems 
>> to me that some drivers are not setting this optimally, as above.
>>
>> Thoughts on guidance for setting sdev queue depth? Could blk-mq 
>> changed this behavior?
>>
> First of all: are these 'real' SAS SSDs?
> The peak at 32 seems very ATA-ish, and I wouldn't put it past the LSI 
> folks to optimize for that case :-)
> Can you get a more detailed picture by changing the queue depth more 
> finegrained?
> (Will get you nicer graphs to boot :-)

They're HUSMM1640ASS204 - not the fastest you can get today, but still 
decent.

I'll see about fine-grained IOPs vs depth results ...

Cheers,
John
