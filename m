Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A907C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 12:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F30422312E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 12:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgLVMbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 07:31:49 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10059 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgLVMbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 07:31:48 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D0bJg1hR0zM7T8;
        Tue, 22 Dec 2020 20:30:11 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 22 Dec 2020 20:30:56 +0800
Subject: Re: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
To:     John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Hannes Reinecke <hare@suse.com>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
 <9674052e-3deb-2a45-6082-4a40a472a219@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <7456f628-5e97-42ce-8738-9e661ad2f12a@huawei.com>
Date:   Tue, 22 Dec 2020 20:30:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <9674052e-3deb-2a45-6082-4a40a472a219@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2020/12/21 18:13, John Garry 写道:
> On 18/12/2020 20:43, Ahmed S. Darwish wrote:
>> Folks,
>>
>> In the discussion about preempt count consistency across kernel
>> configurations:
>>
>>    https://lkml.kernel.org/r/20200914204209.256266093@linutronix.de
>>
>> it was concluded that the usage of in_interrupt() and related context
>> checks should be removed from non-core code.
>>
>> This includes memory allocation mode decisions (GFP_*). In the long run,
>> usage of in_interrupt() and its siblings should be banned from driver
>> code completely.
>>
>> This series addresses SCSI libsas. Basically, the function:
>>
>>    => drivers/scsi/libsas/sas_init.c:
>>    struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
>>    {
>>          ...
>>          gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
>>          event = kmem_cache_zalloc(sas_event_cache, flags);
> 
> Hi Ahmed,
> 
> Firstly I would say that it would be nice to just remove all the atomic 
> context calls. But that may require significant LLDD rework and 
> participation from driver stakeholders.
> 
> However, considering function sas_alloc_event() again:
> 
>      gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
> 
>      ...
> 
>      event = kmem_cache_zalloc(sas_event_cache, flags);
>      if (!event)
>          return NULL;
> 
>      atomic_inc(&phy->event_nr);
> 
>      if (atomic_read(&phy->event_nr) > phy->ha->event_thres) {
>          /* Code to shutdown the phy */
>      }
> 
>      return event;
> 
> 
> So default for phy->ha->event_thres is 32, and I can't imagine that 

The default value is 1024.

> anyone has ever reconfigured this via sysfs or even required a value 
> that large. Maybe Jason (cc'ed) knows better. It's an arbitrary value to 
> say that the PHY is malfunctioning. I do note that there is the circular 
> path sas_alloc_event() -> sas_notify_phy_event() -> sas_alloc_event() 
> there also.
> 
> Anyway, if the 32x event memories were per-allocated, maybe there is a 
> clean method to manage this memory, which even works in atomic context, 
> so we could avoid this rework (ignoring the context bugs you reported 
> for a moment). I do also note that the sas_event_cache size is not huge.
> 

Pre-allocated memory is an option.(Which we have tried at the very 
beginnig by Wang Yijing.)

Or directly use GFP_ATOMIC is maybe better than passing flags from lldds.

Thanks,
Jason

> Anyway, I'll look at the rest of the series.
> 
> Thanks,
> John
> 
>>          ...
>>    }
>>
>> is transformed so that callers explicitly pass the gfp_t memory
>> allocation flags. Affected libsas clients are modified accordingly.
>>
>> The first six patches have "Fixes: " tags and address bugs the were
>> noticed during the context analysis.
>>
>> Thanks!
>>
>> 8<--------------
>>
>> Ahmed S. Darwish (11):
>>    Documentation: scsi: libsas: Remove notify_ha_event()
>>    scsi: libsas: Introduce a _gfp() variant of event notifiers
>>    scsi: mvsas: Pass gfp_t flags to libsas event notifiers
>>    scsi: isci: port: link down: Pass gfp_t flags
>>    scsi: isci: port: link up: Pass gfp_t flags
>>    scsi: isci: port: broadcast change: Pass gfp_t flags
>>    scsi: libsas: Pass gfp_t flags to event notifiers
>>    scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
>>    scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
>>    scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
>>    scsi: libsas: event notifiers: Remove non _gfp() variants
>>
>>   Documentation/scsi/libsas.rst          |  5 ++--
>>   drivers/scsi/aic94xx/aic94xx_scb.c     | 18 ++++++------
>>   drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
>>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 ++++++++++--------
>>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  5 ++--
>>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  5 ++--
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 ++--
>>   drivers/scsi/isci/port.c               | 14 ++++++----
>>   drivers/scsi/libsas/sas_event.c        | 21 ++++++++------
>>   drivers/scsi/libsas/sas_init.c         | 11 ++++----
>>   drivers/scsi/libsas/sas_internal.h     |  4 +--
>>   drivers/scsi/mvsas/mv_sas.c            | 22 +++++++--------
>>   drivers/scsi/pm8001/pm8001_hwi.c       | 38 +++++++++++++-------------
>>   drivers/scsi/pm8001/pm8001_sas.c       |  8 +++---
>>   drivers/scsi/pm8001/pm80xx_hwi.c       | 30 ++++++++++----------
>>   include/scsi/libsas.h                  |  4 +--
>>   16 files changed, 116 insertions(+), 103 deletions(-)
>>
>> base-commit: 2c85ebc57b3e1817b6ce1a6b703928e113a90442
>> -- 
>> 2.29.2
>> .
>>
> 
> .
