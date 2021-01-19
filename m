Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE94C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DBDA2253A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbhASOiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:38:18 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2369 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404390AbhASKff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 05:35:35 -0500
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DKlKx4GFXz67bhy;
        Tue, 19 Jan 2021 18:30:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 19 Jan 2021 11:34:52 +0100
Received: from [10.47.10.61] (10.47.10.61) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 19 Jan
 2021 10:34:50 +0000
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
To:     <Don.Brace@microchip.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>,
        <buczek@molgen.mpg.de>, <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@redhat.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
Date:   Tue, 19 Jan 2021 10:33:36 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.61]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>
>> Am 10.12.20 um 21:35 schrieb Don Brace:
>>> From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
>>>
>>> * Correct scsi-mid-layer sending more requests than
>>>     exposed host Q depth causing firmware ASSERT issue.
>>>     * Add host Qdepth counter.
>>
>> This supposedly fixes the regression between Linux 5.4 and 5.9, which
>> we reported in [1].
>>
>>       kernel: smartpqi 0000:89:00.0: controller is offline: status code
>> 0x6100c
>>       kernel: smartpqi 0000:89:00.0: controller offline
>>
>> Thank you for looking into this issue and fixing it. We are going to
>> test this.
>>
>> For easily finding these things in the git history or the WWW, it
>> would be great if these log messages could be included (in the
>> future).
>> DON> Thanks for your suggestion. Well add them in the next time.
>>
>> Also, that means, that the regression is still present in Linux 5.10,
>> released yesterday, and this commit does not apply to these versions.
>>
>> DON> They have started 5.10-RC7 now. So possibly 5.11 or 5.12
>> depending when all of the patches are applied. The patch in question
>> is among 28 other patches.
>>
>> Mahesh, do you have any idea, what commit caused the regression and
>> why the issue started to show up?
>> DON> The smartpqi driver sets two scsi_host_template member fields:
>> .can_queue and .nr_hw_queues. But we have not yet converted to
>> host_tagset. So the queue_depth becomes nr_hw_queues * can_queue,
>> which is more than the hw can support. That can be verified by looking
>> at scsi_host.h.
>>          /*
>>           * In scsi-mq mode, the number of hardware queues supported by
>> the LLD.
>>           *
>>           * Note: it is assumed that each hardware queue has a queue
>> depth of
>>           * can_queue. In other words, the total queue depth per host
>>           * is nr_hw_queues * can_queue. However, for when host_tagset
>> is set,
>>           * the total queue depth is can_queue.
>>           */
>>
>> So, until we make this change, the queue_depth change prevents the
>> above issue from happening.
> 
> can_queue and nr_hw_queues have been set like this as long as the driver existed. Why did Paul observe a regression with 5.9?
> 
> And why can't you simply set can_queue to (ctrl_info->scsi_ml_can_queue / nr_hw_queues)?
> 
> Don: I did this in an internal patch, but this patch seemed to work the best for our driver. HBA performance remained steady when running benchmarks.
> 

I guess that this is a fallout from commit 6eb045e092ef ("scsi:
  core: avoid host-wide host_busy counter for scsi_mq"). But that commit 
is correct.

If .can_queue is set to (ctrl_info->scsi_ml_can_queue / nr_hw_queues), 
then blk-mq can send each hw queue only (ctrl_info->scsi_ml_can_queue / 
nr_hw_queues) commands, while it should be possible to send 
ctrl_info->scsi_ml_can_queue commands.

I think that this can alternatively be solved by setting .host_tagset flag.

Thanks,
John


