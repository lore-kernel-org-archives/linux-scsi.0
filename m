Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA76BC10DAA
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 01:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCDB020708
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 01:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgIGBhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Sep 2020 21:37:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbgIGBhS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Sep 2020 21:37:18 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DB7DE54EDDC5E93ECC73;
        Mon,  7 Sep 2020 09:37:15 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.92) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 09:37:06 +0800
Subject: Re: [PATCH] scsi: libsas: Fix error path in
 sas_notify_lldd_dev_found()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200905125836.GF183976@mwanda>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <c2e1730d-fe83-7c6a-6011-4bc6c4848f57@huawei.com>
Date:   Mon, 7 Sep 2020 09:37:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200905125836.GF183976@mwanda>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


ÔÚ 2020/9/5 20:58, Dan Carpenter Ð´µÀ:
> In sas_notify_lldd_dev_found(), if we can't find a device, then it seems
> like the wrong thing to mark the device as found and to increment the
> reference count.  None of the callers ever drop the reference in that
> situation.
> 
> Fixes: 735f7d2fedf5 ("[SCSI] libsas: fix domain_device leak")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/libsas/sas_discover.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index cd7c7d269f6f..d0f9e90e3279 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -182,10 +182,11 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
>   		pr_warn("driver on host %s cannot handle device %016llx, error:%d\n",
>   			dev_name(sas_ha->dev),
>   			SAS_ADDR(dev->sas_addr), res);
> +		return res;
>   	}
>   	set_bit(SAS_DEV_FOUND, &dev->state);
>   	kref_get(&dev->kref);
> -	return res;
> +	return 0;
>   }
>   
>   
> 

Hi Dan, thanks for finding this,

Reviewed-by: Jason Yan <yanaijie@huawei.com>

