Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618AFC43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 09:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1A220748
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 09:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgIDJML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:12:11 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2752 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729712AbgIDJMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Sep 2020 05:12:09 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 3FDB791929569A201FCF;
        Fri,  4 Sep 2020 10:12:07 +0100 (IST)
Received: from [127.0.0.1] (10.47.1.112) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 10:12:05 +0100
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
To:     Jens Axboe <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
Date:   Fri, 4 Sep 2020 10:09:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.1.112]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/09/2020 22:23, Jens Axboe wrote:
> On 8/19/20 9:20 AM, John Garry wrote:
>> Hi all,
>>
>> Here is v8 of the patchset.
>>
>> In this version of the series, we keep the shared sbitmap for driver tags,
>> and introduce changes to fix up the tag budgeting across request queues.
>> We also have a change to count requests per-hctx for when an elevator is
>> enabled, as an optimisation. I also dropped the debugfs changes - more on
>> that below.
>>
>> Some performance figures:
>>
>> Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are included,
>> but it is not always an appropriate scheduler to use.
>>
>> Tag depth 		4000 (default)			260**
>>
>> Baseline (v5.9-rc1):
>> none sched:		2094K IOPS			513K
>> mq-deadline sched:	2145K IOPS			1336K
>>
>> Final, host_tagset=0 in LLDD *, ***:
>> none sched:		2120K IOPS			550K
>> mq-deadline sched:	2121K IOPS			1309K
>>
>> Final ***:
>> none sched:		2132K IOPS			1185			
>> mq-deadline sched:	2145K IOPS			2097	
>>
>> * this is relevant as this is the performance in supporting but not
>>    enabling the feature
>> ** depth=260 is relevant as some point where we are regularly waiting for
>>     tags to be available. Figures were are a bit unstable here.
>> *** Included "[PATCH V4] scsi: core: only re-run queue in
>>      scsi_end_request() if device queue is busy"
>>
>> A copy of the patches can be found here:
>> https://github.com/hisilicon/kernel-dev/tree/private-topic-blk-mq-shared-tags-v8
>>
>> The hpsa patch depends on:
>> https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de/
>>
>> And the smartpqi patch is not to be accepted.
>>
>> Comments (and testing) welcome, thanks!
> 
> I applied 1-11, leaving the SCSI core bits and drivers to Martin. I can
> also carry them, just let me know.
> 

Great, thanks!

So the SCSI parts depend on the block parts for building, so I guess it 
makes sense if you could carry them also.

hpsa and smartpqi patches are pending for now, but the rest could be 
picked up. Martin/James may want more review of the SCSI core bits, though.

Thanks again,
John


