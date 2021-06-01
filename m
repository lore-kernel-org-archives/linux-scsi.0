Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235F9C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 08:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 031796136E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 08:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhFAITX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 04:19:23 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3108 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbhFAITW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 04:19:22 -0400
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FvPpl20QKz6J8Qd;
        Tue,  1 Jun 2021 16:05:19 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 10:17:40 +0200
Received: from [10.47.91.52] (10.47.91.52) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 1 Jun 2021
 09:17:39 +0100
Subject: Re: [PATCH] scsi: libsas: Use fallthrough pseudo-keyword
To:     Wei Ming Chen <jj251510319013@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddeodr.com>
References: <20210531153724.3149-1-jj251510319013@gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <287b6910-17e8-9ef7-0042-9b525259967e@huawei.com>
Date:   Tue, 1 Jun 2021 09:16:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210531153724.3149-1-jj251510319013@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.52]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ Gustavo

On 31/05/2021 16:37, Wei Ming Chen wrote:
> Replace /* Fall through */ comment with pseudo-keyword macro fallthrough[1]
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Wei Ming Chen <jj251510319013@gmail.com>
> ---
>   drivers/scsi/libsas/sas_discover.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 9f5068f3bcfb..dd205414e505 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -461,7 +461,7 @@ static void sas_discover_domain(struct work_struct *work)
>   		break;
>   #else
>   		pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
> -		/* Fall through */
> +		fallthrough;

I don't know why we need the 2nd fall through (and the compiler can't 
see the first one) - added by Gustavo in da1fb2909 - but I think that 
this one can now simply be removed.

>   #endif
>   		/* Fall through - only for the #else condition above. */
Thanks,
John

>   	default:
> 

