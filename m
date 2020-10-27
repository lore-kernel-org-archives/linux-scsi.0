Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BB9C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 08:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8670207DE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 08:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509568AbgJ0Izy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 04:55:54 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2999 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2509562AbgJ0Izx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 04:55:53 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id A49D3B804DE410A6FD26;
        Tue, 27 Oct 2020 08:55:50 +0000 (GMT)
Received: from [10.47.8.138] (10.47.8.138) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 27 Oct
 2020 08:55:50 +0000
Subject: Re: [PATCH -next] [SCSI] aic7xxx: change the error value of
 ahx_pci_test_register_access from postive to negative
To:     Zhang Qilong <zhangqilong3@huawei.com>, <hare@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20201026091236.68561-1-zhangqilong3@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <249c3b42-44e0-22a6-eff5-6d9e8e89a9ba@huawei.com>
Date:   Tue, 27 Oct 2020 08:52:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201026091236.68561-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.138]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/10/2020 09:12, Zhang Qilong wrote:
> A negative error code should be returned
> instead of a positive one when going to
> error path.

There's many other places in this driver which still use positive error 
codes, so now inconsistent. I didn't see a good reason to change.

> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>   drivers/scsi/aic7xxx/aic79xx_pci.c | 2 +-
>   drivers/scsi/aic7xxx/aic7xxx_pci.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
> index 8397ae93f7dd..0edce0ebd944 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
> @@ -419,7 +419,7 @@ ahd_pci_test_register_access(struct ahd_softc *ahd)
>   	int	 error;
>   	uint8_t	 hcntrl;
>   
> -	error = EIO;
> +	error = -EIO;
>   
>   	/*
>   	 * Enable PCI error interrupt status, but suppress NMIs
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> index 656f680c7802..cbeca694e883 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> @@ -1168,7 +1168,7 @@ ahc_pci_test_register_access(struct ahc_softc *ahc)
>   	uint32_t cmd;
>   	uint8_t	 hcntrl;
>   
> -	error = EIO;
> +	error = -EIO;
>   
>   	/*
>   	 * Enable PCI error interrupt status, but suppress NMIs
> 

