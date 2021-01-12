Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8841AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5131D22CBE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbhALLiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:38:15 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2316 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730185AbhALLiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:38:12 -0500
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFT2K44xSz67ZV9;
        Tue, 12 Jan 2021 19:32:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 12:37:30 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 11:37:29 +0000
Subject: Re: [PATCH v2 02/19] scsi: libsas and users: Remove notifier
 indirection
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
 <20210112110647.627783-3-a.darwish@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <21eefa9b-7ff5-b418-6db4-7e0039c24473@huawei.com>
Date:   Tue, 12 Jan 2021 11:36:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210112110647.627783-3-a.darwish@linutronix.de>
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
> From: John Garry<john.garry@huawei.com>
> 
> The LLDDs report events to libsas with .notify_port_event and
> .notify_phy_event callbacks.
> 
> These callbacks are fixed and so there is no reason why we cannot call the
> functions directly, so do that.
> 
> This neatens the code slightly.
> 
> [a.darwish@linutronix.de: Remove the now unused "sas_ha" local variables]
> Signed-off-by: John Garry<john.garry@huawei.com>

Don't forget your signed-off-by :)

> ---
>   Documentation/scsi/libsas.rst          |  4 +--
>   drivers/scsi/aic94xx/aic94xx_scb.c     | 20 ++++++-------
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 12 +++-----
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 +-
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 +-
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 +-
>   drivers/scsi/isci/port.c               |  7 ++---
>   drivers/scsi/libsas/sas_event.c        | 13 +++------
>   drivers/scsi/libsas/sas_init.c         |  6 ----
>   drivers/scsi/libsas/sas_internal.h     |  1 -
>   drivers/scsi/mvsas/mv_sas.c            | 14 ++++-----
>   drivers/scsi/pm8001/pm8001_hwi.c       | 40 ++++++++++++--------------
>   drivers/scsi/pm8001/pm8001_sas.c       |  7 ++---
>   drivers/scsi/pm8001/pm80xx_hwi.c       | 35 ++++++++++------------
>   include/scsi/libsas.h                  |  7 ++---
>   15 files changed, 69 insertions(+), 106 deletions(-)
> 
> diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
> index f9b77c7879db..a183b1d84713 100644
> --- a/Documentation/scsi/libsas.rst
> +++ b/Documentation/scsi/libsas.rst
> @@ -189,8 +189,8 @@ num_phys
>   The event interface::
>   
>   	/* LLDD calls these to notify the class of an event. */
> -	void (*notify_port_event)(struct sas_phy *, enum port_event);
> -	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
> +	void sas_notify_port_event(struct sas_phy *, enum port_event);
> +	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
>   
>   When sas_register_ha() returns, those are set and can be
>   called by the LLDD to notify the SAS layer of such events

Maybe this was missed in the rebase, but I think that this comment can 
go/be changed at some stage.

Thanks,
John
