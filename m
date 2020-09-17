Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B1BC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 08:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CA920872
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 08:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIQI3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:29:24 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2878 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726531AbgIQI3N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 04:29:13 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 9397B6FE4348BEA6E670;
        Thu, 17 Sep 2020 09:29:10 +0100 (IST)
Received: from [127.0.0.1] (10.210.165.75) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 17 Sep
 2020 09:29:09 +0100
Subject: Re: mpt3sas hostwide tagset?
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
CC:     PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
References: <44b35254-faed-bcc9-6fb3-b843fff1ac1f@huawei.com>
 <9440d365161aec3ef4553894e3d33fb5@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <656cf161-a0d9-e6bd-2c8c-fe870c06b201@huawei.com>
Date:   Thu, 17 Sep 2020 09:26:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <9440d365161aec3ef4553894e3d33fb5@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.165.75]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/09/2020 09:26, Kashyap Desai wrote:
> Hi John -
> 
> We have driver code of <mpt3sas> ready for this feature. Due to some other
> priority, we are not able to make any progress on this. Primarily we want to
> cover more unit testing and performance on this feature.
> We will be sending <mpt3sas> driver version soon.

ok, great. Not sure why we missed this one originally.

Thanks!

> 
> Kashyap
> 
>> -----Original Message-----
>> From: John Garry [mailto:john.garry@huawei.com]
>> Sent: Thursday, September 17, 2020 1:48 PM
>> To: Sathya Prakash <sathya.prakash@broadcom.com>;
>> sreekanth.reddy@broadcom.com; Suganath Prabu Subramani <suganath-
>> prabu.subramani@broadcom.com>
>> Cc: MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
>> Kashyap Desai <kashyap.desai@broadcom.com>; Hannes Reinecke
>> <hare@suse.com>; Martin K . Petersen <martin.petersen@oracle.com>;
>> axboe@kernel.dk; Ming Lei <ming.lei@redhat.com>
>> Subject: mpt3sas hostwide tagset?
>>
>> Hi guys,
>>
>> You may have noticed patchset "blk-mq/scsi: Provide hostwide shared tags
>> for SCSI HBAs", where we allow SCSI HBAs which have restriction of
>> hostwide
>> tagset to expose hw queues to blk-mq. Main motivation is to take advantage
>> of blk-mq CPU hotplug handling support [0], and also possibly [1].
>>
>>   From looking at this driver again, I now notice that mpt3sas seems to
>> have all
>> the characteristics of a driver which could make this change:
>> uses managed interrupts for some completion queues, manages internally
>> CPU<->queue mapping, does not set Scsi_Host.nr_hw_queues, and also uses
>> request->tag.
>>
>> Have you considered making this transition? Not sure if there are
>> technical
>> reasons not to.
>>
>> Thanks,
>> John
>>
>> [0] https://lore.kernel.org/linux-block/20200529135315.199230-1-
>> hch@lst.de/
>>
>> [1]
>> https://lore.kernel.org/linux-
>> scsi/CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gm
>> ail.com/
>>

