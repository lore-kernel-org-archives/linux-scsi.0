Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3875C001E0
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 01:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjGTBp4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjGTBpz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 21:45:55 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F78F1FD8;
        Wed, 19 Jul 2023 18:45:53 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R5wRk5QBgztRVB;
        Thu, 20 Jul 2023 09:42:42 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 09:45:49 +0800
Subject: Re: [PATCH v2 2/8] ata,scsi: remove ata_sas_port_{start,stop}
 callbacks
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.com>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-3-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <ebf714b4-f4ef-8c3c-75f7-3e75649b8d77@huawei.com>
Date:   Thu, 20 Jul 2023 09:45:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230720004257.307031-3-nks@flawful.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/7/20 8:42, Niklas Cassel wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Callbacks are empty now, so remove them.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-sata.c     | 34 ----------------------------------
>   drivers/scsi/libsas/sas_ata.c |  2 --
>   include/linux/libata.h        |  2 --
>   3 files changed, 38 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 99d4ab04bcce..d3b595294eee 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1144,40 +1144,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
>   }
>   EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
>   
> -/**
> - *	ata_sas_port_start - Set port up for dma.
> - *	@ap: Port to initialize
> - *
> - *	Called just after data structures for each port are
> - *	initialized.
> - *
> - *	May be used as the port_start() entry in ata_port_operations.
> - *
> - *	LOCKING:
> - *	Inherited from caller.
> - */
> -int ata_sas_port_start(struct ata_port *ap)
> -{
> -	/* the port is marked as frozen at allocation time */
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_port_start);
> -
> -/**
> - *	ata_sas_port_stop - Undo ata_sas_port_start()
> - *	@ap: Port to shut down
> - *
> - *	May be used as the port_stop() entry in ata_port_operations.
> - *
> - *	LOCKING:
> - *	Inherited from caller.
> - */
> -
> -void ata_sas_port_stop(struct ata_port *ap)
> -{
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_port_stop);
> -
>   /**
>    * ata_sas_async_probe - simply schedule probing and return
>    * @ap: Port to probe
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 77714a495cbb..7ead1f1be97f 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -565,8 +565,6 @@ static struct ata_port_operations sas_sata_ops = {
>   	.qc_prep		= ata_noop_qc_prep,
>   	.qc_issue		= sas_ata_qc_issue,
>   	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
> -	.port_start		= ata_sas_port_start,
> -	.port_stop		= ata_sas_port_stop,


Hi Niklas,

->port_start is NULL now but ata_sas_port_init() is still using it 
without checking whether it is NULL. I know the patch #3 will remove it 
finally. But this will bring a great inconvenience because the kernel 
will crash when bisectting to this commit.

Either put patch #3 before this patch or fold patch #3 directly into 
path #2 ?

Thanks,
Jason
