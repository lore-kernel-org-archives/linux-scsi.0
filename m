Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C4CC433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 08:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FA621582
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 08:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgIGI5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:57:30 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727953AbgIGI5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Sep 2020 04:57:30 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2C5D77505446F7B84C87;
        Mon,  7 Sep 2020 09:57:28 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.208) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 7 Sep 2020
 09:57:27 +0100
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: Fix error path in
 sas_notify_lldd_dev_found()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jason Yan <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20200905125836.GF183976@mwanda>
Message-ID: <4ef45b15-34fd-80e9-1adb-53044ca9fa84@huawei.com>
Date:   Mon, 7 Sep 2020 09:54:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200905125836.GF183976@mwanda>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.208]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/09/2020 13:58, Dan Carpenter wrote:
> In sas_notify_lldd_dev_found(), if we can't find a device, 

nit: the callback is for the LLDD is to allocate resources, device 
context etc., for that domain_device, and not find the device. The 
device has been found at this point.

 > then it seems
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

This looks ok.

>   }

Thanks,
John

>   
>   
> 

