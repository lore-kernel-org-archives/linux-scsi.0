Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805BCC3DA7A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 11:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbjAEL2i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Jan 2023 06:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbjAEL23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2023 06:28:29 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D386BBA6;
        Thu,  5 Jan 2023 03:28:27 -0800 (PST)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NnkhL2r1GznTWh;
        Thu,  5 Jan 2023 19:26:58 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 5 Jan 2023 19:28:25 +0800
Subject: Re: [PATCH] scsi: libsas: fix an error code in sas_ata_add_dev()
To:     Dan Carpenter <error27@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jie Zhan <zhanjie9@hisilicon.com>,
        <linux-scsi@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <Y7asLxzVwQ56G+ya@kili>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <0a15d816-7760-e845-7fe5-05e73d439f95@huawei.com>
Date:   Thu, 5 Jan 2023 19:28:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <Y7asLxzVwQ56G+ya@kili>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/1/5 18:53, Dan Carpenter wrote:
> This code accidentally returns success instead of -ENOMEM.
> 
> Fixes: 7cc7646b4b24 ("scsi: libsas: Factor out sas_ata_add_dev()")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>   drivers/scsi/libsas/sas_ata.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 177cdaef3cad..f5e1c24f54ca 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -716,7 +716,7 @@ int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
>   
>   	rphy = sas_end_device_alloc(phy->port);
>   	if (!rphy)
> -		return ret;
> +		return -ENOMEM;

Hi Dan,

Good catch, thanks for the fix.

Reviewed-by: Jason Yan <yanaijie@huawei.com>
