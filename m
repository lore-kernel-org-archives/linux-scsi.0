Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631EDC77B7D
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 07:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbjEOHGK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 03:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjEOHGJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 03:06:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A73E4F
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 00:06:06 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QKVdq5P0ZzTkk1;
        Mon, 15 May 2023 15:01:19 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 15:06:04 +0800
Message-ID: <8c6368eb-c55b-d3b0-a244-10834ca42075@huawei.com>
Date:   Mon, 15 May 2023 15:06:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: SCSI: Consumer of
 scsi_devices->iorequest_cnt/iodone_cnt/ioerr_cnt
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <emilne@redhat.com>, <czhong@redhat.com>,
        Wenchao Hao <haowenchao@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linfeilong@huawei.com>
References: <ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com>
 <e08f3fe4-a14e-c1c7-4344-7fbe0b50d44f@huawei.com>
 <ZGGl58yNUqZigOj/@ovpn-8-26.pek2.redhat.com>
 <8e0f2d31-e6ff-ec4a-3974-450560ad49c5@huawei.com>
 <ZGG8YSrgjjsdyoio@ovpn-8-26.pek2.redhat.com>
From:   "haowenchao (C)" <haowenchao2@huawei.com>
In-Reply-To: <ZGG8YSrgjjsdyoio@ovpn-8-26.pek2.redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/5/15 13:00, Ming Lei wrote:
> On Mon, May 15, 2023 at 11:47:31AM +0800, haowenchao (C) wrote:
>> On 2023/5/15 11:24, Ming Lei wrote:
>>> On Mon, May 15, 2023 at 10:55:01AM +0800, haowenchao (C) wrote:
>>>> On 2023/5/13 23:55, Ming Lei wrote:
>>>>> Hello Guys,
>>>>>
>>>>> scsi_device->iorequest_cnt/iodone_cnt/ioerr_cnt are only inc/dec,
>>>>> and exported to userspace via sysfs in kernel, and not see any kernel
>>>>> consumers, so the exported counters are only for userspace, just be curious
>>>>> which/how applications consume them?
>>>>>
>>>>
>>>> These counters are used to checking the disk health status in a certain scenario
>>>> for us.
>>>
>>> All the three counters are increased only, and you could use some simple bpf code
>>> to retrieve such info easily. It adds such overhead for everyone, who may not use
>>> this counters at all, maybe 99% of people don't use it.
>>>
>>>>
>>>>> These counters not only adds cost in fast path, but also causes kernel panic,
>>>>> especially the "atomic_inc(&cmd->device->iorequest_cnt)" in
>>>>> scsi_queue_rq(), because cmd->device may be freed after returning
>>>>> from scsi_dispatch_cmd(), which is introduced by:
>>>>>
>>>>> cfee29ffb45b ("scsi: core: Do not increase scsi_device's iorequest_cnt if dispatch failed")
>>>>>
>>>>> If there aren't explicit applications which depend on these counters,
>>>>> I'd suggest to kill the three since all are not in stable ABI. Otherwise
>>>>> I think we need to revert cfee29ffb45b.
>>>>>
>>>>>
>>>>
>>>> Sorry for introduce this bug.
>>>>
>>>> We would check these counters after iodone_cnt equal to iorequest_cnt. So
>>>> cfee29ffb45b is aimed to fix the issue of iorequest_cnt is increased for
>>>> multiple times if scsi_dispatch_cmd() failed.
>>>>
>>>> Maybe we should revert cfee29ffb45b and fix the original issue with following
>>>> changes:
>>>
>>> Yeah, it can be fixed in this way, can you cook one such fix?
>>>
>>
>> OK, I would post patches.
> 
> Thanks!
> 
>>
>>> Longterm, maybe we can mark these sysfs interface as obsolete and let
>>> existed users switch to ebpf, and finally remove them.
>>>
>>
>> Where can we mark these sysfs interface as obsolete?
> 
> It could be one comment on the sysfs interface or extra logging, but not
> sure if the latter can work since user expects these sysfs interfaces to
> dump counter only.
> 
> Thanks,
> Ming
> 

I just send the patch but did not comment the sysfs interface, because I am not
sure if others would feedback about these sysfs interface. Would you help to
review the patch?

Thanks.

