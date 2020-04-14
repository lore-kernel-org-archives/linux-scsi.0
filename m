Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A30BC2BA19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6114920575
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406700AbgDNHf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:35:57 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2048 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406685AbgDNHfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 03:35:50 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id D5C64DEAE293C60B34A0;
        Tue, 14 Apr 2020 08:35:45 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.216) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 14 Apr
 2020 08:35:44 +0100
Subject: Re: [PATCH 6/9] scsi: libsas: Add missing annotation for
 sas_ata_qc_issue()
To:     Jules Irenge <jbi.octave@gmail.com>, <linux-kernel@vger.kernel.org>
CC:     <boqun.feng@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Allison Randal <allison@lohutok.net>,
        Hannes Reinecke <hare@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        Jason Yan <yanaijie@huawei.com>
References: <0/9> <20200411001933.10072-1-jbi.octave@gmail.com>
 <20200411001933.10072-7-jbi.octave@gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <66630a8b-436e-5210-3654-dc3c4a17a05d@huawei.com>
Date:   Tue, 14 Apr 2020 08:35:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200411001933.10072-7-jbi.octave@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.216]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/04/2020 01:19, Jules Irenge wrote:
> Sparse reports a warning at sas_ata_qc_issue()
> 
> warning: context imbalance in sas_ata_qc_issue() - unexpected unlock
> The root cause is the missing annotation at sas_ata_qc_issue()
> 
> Add the missing __must_hold(ap->lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

that looks ok...

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/libsas/sas_ata.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index c5a828a041e0..5d716d388707 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -160,6 +160,7 @@ static void sas_ata_task_done(struct sas_task *task)
>   }
>   
>   static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
> +	__must_hold(ap->lock)
>   {
>   	struct sas_task *task;
>   	struct scatterlist *sg;
> 

