Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548BBC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 14:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A08F223E8
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 14:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbhAKOBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 09:01:16 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2305 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730503AbhAKOBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 09:01:15 -0500
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DDwFv0qCjz67Zn2;
        Mon, 11 Jan 2021 21:55:31 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 15:00:33 +0100
Received: from [10.210.171.188] (10.210.171.188) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 14:00:31 +0000
Subject: Re: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jason Yan <yanaijie@huawei.com>
CC:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <X/xV/uR77a9JLZ4v@lx-t490>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ccddbd5e-ec63-934e-c15a-7263aeaa24ce@huawei.com>
Date:   Mon, 11 Jan 2021 13:59:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <X/xV/uR77a9JLZ4v@lx-t490>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.171.188]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/01/2021 13:43, Ahmed S. Darwish wrote:
> Hi John, Jason,
> 
> On Tue, Dec 22, 2020 at 12:54:58PM +0000, John Garry wrote:
>> On 22/12/2020 12:30, Jason Yan wrote:
>>>>       return event;
>>>>
>>>>
>>>> So default for phy->ha->event_thres is 32, and I can't imagine that
>>> The default value is 1024.
>> Ah, 32 is the minimum allowed set via sysfs.
>>
>>>> anyone has ever reconfigured this via sysfs or even required a value
>>>> that large. Maybe Jason (cc'ed) knows better. It's an arbitrary
>>>> value to say that the PHY is malfunctioning. I do note that there is
>>>> the circular path sas_alloc_event() -> sas_notify_phy_event() ->
>>>> sas_alloc_event() there also.
>>>>
>>>> Anyway, if the 32x event memories were per-allocated, maybe there is
>>>> a clean method to manage this memory, which even works in atomic
>>>> context, so we could avoid this rework (ignoring the context bugs
>>>> you reported for a moment). I do also note that the sas_event_cache
>>>> size is not huge.
>>>>
>>> Pre-allocated memory is an option.(Which we have tried at the very
>>> beginnig by Wang Yijing.)
>> Right, I remember this, but I think the concern was having a proper method
>> to manage this pre-allocated memory then. And same problem now.
>>
>>> Or directly use GFP_ATOMIC is maybe better than passing flags from lldds.
>>>
>> I think that if we don't really need this, then should not use it.
>>
> Kind reminder. Do we have any consensus here?
> 

Hi Ahmed,

To me, what you're doing seems fine.

I was looking for some API to manage small memory pools and which is 
atomic safe to avoid passing the context flag, but I didn't find such a 
thing.

Just one other thing to mention:
I have a patch to remove the indirection in libsas notifiers:
https://github.com/hisilicon/kernel-dev/commit/87fcd7e113dc05b7933260e7fa4588dc3730cc2a

I was going to send it today. Hopefully, if community has no problem 
with it, you can make your changes with that in mind.

Thanks,
John



