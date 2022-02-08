Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D25C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 18:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384212AbiBHSEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 13:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbiBHSEi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 13:04:38 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25206C061579
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 10:04:36 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtW576yf1z67PrR;
        Wed,  9 Feb 2022 02:00:27 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 8 Feb 2022 19:04:32 +0100
Received: from [10.47.82.28] (10.47.82.28) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 8 Feb
 2022 18:04:28 +0000
Message-ID: <deb3fd22-2352-097f-7fa0-20d2e338aac8@huawei.com>
Date:   Tue, 8 Feb 2022 18:04:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 01/44] ips: Use true and false instead of TRUE and
 FALSE
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-2-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220208172514.3481-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.82.28]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/02/2022 17:24, Bart Van Assche wrote:
> This patch prepares for removal of the drivers/scsi/scsi.h header file.
> That header file defines the 'TRUE' and 'FALSE' constants.
> 
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Regardless of comment, below, feel free to add:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/ips.c | 42 ++++++++++++++++++++----------------------
>   1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 498bf04499ce..b3532d290848 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -655,13 +655,13 @@ ips_release(struct Scsi_Host *sh)

This function and other places return an int, and not a bool, so that 
could be changed as well. Prob not worth the churn, though.

>   		printk(KERN_WARNING
>   		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
>   		BUG();
> -		return (FALSE);
> +		return false;
>   	}
>   
>   	ha = IPS_HA(sh);
>   
>   	if (!ha)
> -		return (FALSE);
> +		return false;
>   
>   	/* flush the cache on the controller */
>   	scb = &ha->scbs[ha->max_cmds - 1];
> @@ -700,7 +700,7 @@ ips_release(struct Scsi_Host *sh)
>   
>   	ips_released_controllers++;
>   
> -	return (FALSE);
> +	return false;

