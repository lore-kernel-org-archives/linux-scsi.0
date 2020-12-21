Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533FFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 10:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EDBD207FF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 10:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgLUKPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 05:15:11 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2273 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLUKPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 05:15:11 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CzwG00mfWz67S8b;
        Mon, 21 Dec 2020 18:10:32 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 21 Dec 2020 11:14:28 +0100
Received: from [10.210.168.224] (10.210.168.224) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 21 Dec 2020 10:14:27 +0000
Subject: Re: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Hannes Reinecke <hare@suse.com>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9674052e-3deb-2a45-6082-4a40a472a219@huawei.com>
Date:   Mon, 21 Dec 2020 10:13:42 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.224]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/12/2020 20:43, Ahmed S. Darwish wrote:
> Folks,
> 
> In the discussion about preempt count consistency across kernel
> configurations:
> 
>    https://lkml.kernel.org/r/20200914204209.256266093@linutronix.de
> 
> it was concluded that the usage of in_interrupt() and related context
> checks should be removed from non-core code.
> 
> This includes memory allocation mode decisions (GFP_*). In the long run,
> usage of in_interrupt() and its siblings should be banned from driver
> code completely.
> 
> This series addresses SCSI libsas. Basically, the function:
> 
>    => drivers/scsi/libsas/sas_init.c:
>    struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
>    {
>          ...
>          gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
>          event = kmem_cache_zalloc(sas_event_cache, flags);

Hi Ahmed,

Firstly I would say that it would be nice to just remove all the atomic 
context calls. But that may require significant LLDD rework and 
participation from driver stakeholders.

However, considering function sas_alloc_event() again:

	gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;

	...

	event = kmem_cache_zalloc(sas_event_cache, flags);
	if (!event)
		return NULL;

	atomic_inc(&phy->event_nr);

	if (atomic_read(&phy->event_nr) > phy->ha->event_thres) {
		/* Code to shutdown the phy */
	}

	return event;


So default for phy->ha->event_thres is 32, and I can't imagine that 
anyone has ever reconfigured this via sysfs or even required a value 
that large. Maybe Jason (cc'ed) knows better. It's an arbitrary value to 
say that the PHY is malfunctioning. I do note that there is the circular 
path sas_alloc_event() -> sas_notify_phy_event() -> sas_alloc_event() 
there also.

Anyway, if the 32x event memories were per-allocated, maybe there is a 
clean method to manage this memory, which even works in atomic context, 
so we could avoid this rework (ignoring the context bugs you reported 
for a moment). I do also note that the sas_event_cache size is not huge.

Anyway, I'll look at the rest of the series.

Thanks,
John

>          ...
>    }
> 
> is transformed so that callers explicitly pass the gfp_t memory
> allocation flags. Affected libsas clients are modified accordingly.
> 
> The first six patches have "Fixes: " tags and address bugs the were
> noticed during the context analysis.
> 
> Thanks!
> 
> 8<--------------
> 
> Ahmed S. Darwish (11):
>    Documentation: scsi: libsas: Remove notify_ha_event()
>    scsi: libsas: Introduce a _gfp() variant of event notifiers
>    scsi: mvsas: Pass gfp_t flags to libsas event notifiers
>    scsi: isci: port: link down: Pass gfp_t flags
>    scsi: isci: port: link up: Pass gfp_t flags
>    scsi: isci: port: broadcast change: Pass gfp_t flags
>    scsi: libsas: Pass gfp_t flags to event notifiers
>    scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
>    scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
>    scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
>    scsi: libsas: event notifiers: Remove non _gfp() variants
> 
>   Documentation/scsi/libsas.rst          |  5 ++--
>   drivers/scsi/aic94xx/aic94xx_scb.c     | 18 ++++++------
>   drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 ++++++++++--------
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  5 ++--
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  5 ++--
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 ++--
>   drivers/scsi/isci/port.c               | 14 ++++++----
>   drivers/scsi/libsas/sas_event.c        | 21 ++++++++------
>   drivers/scsi/libsas/sas_init.c         | 11 ++++----
>   drivers/scsi/libsas/sas_internal.h     |  4 +--
>   drivers/scsi/mvsas/mv_sas.c            | 22 +++++++--------
>   drivers/scsi/pm8001/pm8001_hwi.c       | 38 +++++++++++++-------------
>   drivers/scsi/pm8001/pm8001_sas.c       |  8 +++---
>   drivers/scsi/pm8001/pm80xx_hwi.c       | 30 ++++++++++----------
>   include/scsi/libsas.h                  |  4 +--
>   16 files changed, 116 insertions(+), 103 deletions(-)
> 
> base-commit: 2c85ebc57b3e1817b6ce1a6b703928e113a90442
> --
> 2.29.2
> .
> 

