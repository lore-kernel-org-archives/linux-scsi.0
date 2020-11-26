Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE35AC63798
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 14:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AAB120B80
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 14:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbgKZOLJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 09:11:09 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2164 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390160AbgKZOLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 09:11:09 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Chfl467S7z67JM9;
        Thu, 26 Nov 2020 22:09:20 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 26 Nov 2020 15:11:07 +0100
Received: from [10.210.172.213] (10.210.172.213) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 26 Nov 2020 14:11:05 +0000
Subject: Re: [PATCH 02/14] scsi: hisi_sas: Remove preemptible().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-scsi@vger.kernel.org>
CC:     Finn Thain <fthain@telegraphics.com.au>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        <linux-m68k@lists.linux-m68k.org>,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        <MPT-FusionLinux.pdl@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-3-bigeasy@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <f405bce8-5929-b91a-2e42-12cdb7f08867@huawei.com>
Date:   Thu, 26 Nov 2020 14:10:43 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201126132952.2287996-3-bigeasy@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.172.213]
X-ClientProxiedBy: lhreml707-chm.china.huawei.com (10.201.108.56) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/11/2020 13:29, Sebastian Andrzej Siewior wrote:
> From: "Ahmed S. Darwish"<a.darwish@linutronix.de>
> 
> hisi_sas_task_exec() uses preemptible() to see if it's safe to block.
> This does not work for CONFIG_PREEMPT_COUNT=n kernels in which
> preemptible() always returns 0.
> 
> The problem is masked when enabling some of the common Kconfig.debug
> options (like CONFIG_DEBUG_ATOMIC_SLEEP), as they implicitly enable the
> preemption counter.
> 
> In general, driver leaf functions should not make logic decisions based
> on the context they're called from. The caller should be the entity
> responsible for explicitly indicating context.
> 
> Since hisi_sas_task_exec() already has a gfp_t flags parameter, use it
> as the explicit context marker.
> 
> Fixes: 214e702d4b70 ("scsi: hisi_sas: Adjust task reject period during host reset")
> Fixes: 550c0d89d52d ("scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()")
> Signed-off-by: Ahmed S. Darwish<a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior<bigeasy@linutronix.de>
> Cc: Xiaofei Tan<tanxiaofei@huawei.com>
> Cc: Xiang Chen<chenxiang66@hisilicon.com>
> Cc: John Garry<john.garry@huawei.com>

Acked-by: John Garry <john.garry@huawei.com>
