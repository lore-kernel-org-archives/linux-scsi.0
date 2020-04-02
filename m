Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855B9C18E5B
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 09:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52AF220719
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 09:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387858AbgDBJJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 05:09:38 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2630 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387723AbgDBJJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Apr 2020 05:09:38 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id D73D17AD3C2D0714641B;
        Thu,  2 Apr 2020 10:09:36 +0100 (IST)
Received: from [127.0.0.1] (10.47.6.242) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 2 Apr 2020
 10:09:35 +0100
Subject: Re: [PATCH v2] scsi: hisi_sas: Fix build error without SATA_HOST
To:     YueHaibing <yuehaibing@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <chenxiang66@hisilicon.com>,
        <b.zolnierkie@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200402063021.34672-1-yuehaibing@huawei.com>
 <20200402085812.32948-1-yuehaibing@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8470370b-5359-4b82-ed55-8018f8b60697@huawei.com>
Date:   Thu, 2 Apr 2020 10:09:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200402085812.32948-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.6.242]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/04/2020 09:58, YueHaibing wrote:
> If SATA_HOST is n, build fails:
> 
> drivers/scsi/hisi_sas/hisi_sas_main.o: In function `hisi_sas_fill_ata_reset_cmd':
> hisi_sas_main.c:(.text+0x2500): undefined reference to `ata_tf_to_fis'
> 
> Select SATA_HOST to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: bd322af15ce9 ("ata: make SATA_PMP option selectable only if any SATA host driver is enabled")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: John Garry <john.garry@huawei.com>

> ---
> v2: use correct Fixes tag
> ---
>   drivers/scsi/hisi_sas/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
> index 90a17452a50d..13ed9073fc72 100644
> --- a/drivers/scsi/hisi_sas/Kconfig
> +++ b/drivers/scsi/hisi_sas/Kconfig
> @@ -6,6 +6,7 @@ config SCSI_HISI_SAS
>   	select SCSI_SAS_LIBSAS
>   	select BLK_DEV_INTEGRITY
>   	depends on ATA
> +	select SATA_HOST
>   	help
>   		This driver supports HiSilicon's SAS HBA, including support based
>   		on platform device
> 

