Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F3AC17441
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 14:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E7F20674
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 14:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKLOfc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 09:35:32 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2089 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbfKLOfc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 09:35:32 -0500
Received: from lhreml702-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 08406169A4B065FA4D94;
        Tue, 12 Nov 2019 14:35:31 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml702-cah.china.huawei.com (10.201.108.43) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 12 Nov 2019 14:35:30 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 12 Nov
 2019 14:35:30 +0000
Subject: Re: [PATCH 6/6] scsi: hisi_sas: Expose multiple hw queues for v3 as
 experimental
From:   John Garry <john.garry@huawei.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
 <1571926881-75524-7-git-send-email-john.garry@huawei.com>
 <20191027081910.GB16704@ming.t460p>
 <bd3b09f7-4a51-7cec-49c4-8e2eab3bdfd0@huawei.com>
 <20191112111053.GA31697@ming.t460p>
 <a8a83145-9498-9ed6-0510-5d51eda22f54@huawei.com>
Message-ID: <fca9ae03-783a-e5cd-b517-d3f87be9fa5e@huawei.com>
Date:   Tue, 12 Nov 2019 14:35:29 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <a8a83145-9498-9ed6-0510-5d51eda22f54@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/11/2019 13:54, John Garry wrote:
>>>
>>> I mentioned in the thread "blk-mq: improvement on handling IO during CPU
>>> hotplug" that I was using this series to test that patchset.
>>>
>>> So just with this patchset (and without yours), I get what looks like 
>>> some
>>> IO errors in the LLDD. The error is an underflow error. I can't 
>>> figure out
>>> what is the cause.
>>
> 
> Hi Ming,
> 
>> Can you post the error log? Or interpret the 'underflow error' from hisi
>> sas or scsi viewpoint?
> 
> The check here fails:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/libsas/sas_scsi_host.c?h=v5.4-rc7#n57 
> 
> 
> Indeed, no data is received.
> 
>>
>>>
>>> I'm wondering if the SCSI command is getting corrupted someway.
>>
>> Why do you think the command is corrupted?
> 
> I considered that the underflow may occur if we were to clobber a SCSI 
> command/request from another hctx and zero some fields, which is 
> detected as an underflow. But that's just guessing.
> 
> However do I find if I set shost->can_queue = HISI_SAS_MAX_COMMANDS / 
> #queues, then no issue  But maybe that's a coincidence. For this, total
> queue depth = HISI_SAS_MAX_COMMANDS. I don't see the impact of that.
> 

Scratch that. I have seen the issue here also.

Thanks,
John

> I need to test that more.
> 
>>
>>>
>>>>> +    if (expose_mq_experimental) {
>>>>> +        shost->can_queue = HISI_SAS_MAX_COMMANDS;
>>>>> +        shost->cmd_per_lun = HISI_SAS_MAX_COMMANDS;
>>>> The above is contradictory with current 'nr_hw_queues''s meaning,
>>>> see commit on Scsi_Host.nr_hw_queues.
>>>>
>>>
>>> Right, so I am generating the hostwide tag in the LLDD. And the Scsi
>>> host-wide host_busy counter should ensure that we don't pump too much 
>>> IO to
>>> the HBA.
>>
>> Even without the host-wide host_busy, your approach should work if you
>> build the hisi sas tag correctly(uniquely), just not efficiently.
> 
> Yes, I do that.
> 
>   I'd
>> suggest you to collect trace and observe if request with expected hisi 
>> sas
>> tag is sent to hardware.
>>
> 
> I can add some debug for that. What trace do you mean?
> 
>> BTW, the patch of 'scsi: core: avoid host-wide host_busy counter for 
>> scsi_mq'
>> will be merged to v5.5 if everything is fine.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.5/scsi-queue&id=6eb045e092efefafc6687409a6fa6d1dabf0fb69 
>>
> 
> Yeah, it seems a good change.
> 
> Thanks,
> John
> .

