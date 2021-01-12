Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B10C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 167B723104
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbhALLzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:55:42 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2318 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbhALLzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:55:41 -0500
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFTRw17Nzz67ZPZ;
        Tue, 12 Jan 2021 19:51:08 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 12:54:59 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 11:54:57 +0000
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, <intel-linux-scu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com>
Date:   Tue, 12 Jan 2021 11:53:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
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

On 12/01/2021 11:06, Ahmed S. Darwish wrote:
> Hi,
> 
> Changelog v2
> ------------
> 
> - Rebase on top of v5.11-rc3
> 
> - Rebase on top of John's patch "scsi: libsas and users: Remove notifier
>    indirection", as it affects every other patch. Include it in this
>    series (patch #2).
> 
> - Introduce patches #13 => #19, which modify call sites back to use the
>    original libsas notifier function names without _gfp() suffix.
> 
> - Collect r-b tags
> 
> v1 Submission
> -------------
> 
>    https://lkml.kernel.org/r/20201218204354.586951-1-a.darwish@linutronix.de
> 
> Cover letter
> ------------
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
>          ...
>    }
> 
> is transformed so that callers explicitly pass the gfp_t memory
> allocation flags. Affected libsas clients are modified accordingly.
> 
> Patches #1, #2 => #7 have "Fixes: " tags and address bugs the were
> noticed during the context analysis.
> 
> Thanks!
> 
> 8<--------------
> 
> Ahmed S. Darwish (18):
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
>    scsi: libsas: event notifiers API: Add gfp_t flags parameter
>    scsi: hisi_sas: Switch back to original libsas event notifiers
>    scsi: aic94xx: Switch back to original libsas event notifiers
>    scsi: pm80xx: Switch back to original libsas event notifiers
>    scsi: libsas: Switch back to original event notifiers API
>    scsi: isci: Switch back to original libsas event notifiers
>    scsi: mvsas: Switch back to original libsas event notifiers
>    scsi: libsas: Remove temporarily-added _gfp() API variants

I'll give this a spin today and help review also then.

There's 18 patches here - it would be very convenient if they were on a 
public branch :)

Cheers,
John

> 
> John Garry (1):
>    scsi: libsas and users: Remove notifier indirection
> 
>   Documentation/scsi/libsas.rst          |  5 ++--
>   drivers/scsi/aic94xx/aic94xx_scb.c     | 20 ++++++-------
>   drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 29 +++++++++----------
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  6 ++--
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 ++--
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  6 ++--
>   drivers/scsi/isci/port.c               | 11 +++----
>   drivers/scsi/libsas/sas_event.c        | 27 ++++++++---------
>   drivers/scsi/libsas/sas_init.c         | 17 ++++-------
>   drivers/scsi/libsas/sas_internal.h     |  5 ++--
>   drivers/scsi/mvsas/mv_sas.c            | 24 +++++++---------
>   drivers/scsi/pm8001/pm8001_hwi.c       | 40 ++++++++++++--------------
>   drivers/scsi/pm8001/pm8001_sas.c       | 12 +++-----
>   drivers/scsi/pm8001/pm80xx_hwi.c       | 37 +++++++++++-------------
>   include/scsi/libsas.h                  |  9 +++---
>   16 files changed, 115 insertions(+), 142 deletions(-)
> 
> base-commit: 7c53f6b671f4aba70ff15e1b05148b10d58c2837
> --
> 2.30.0
> .
> 

