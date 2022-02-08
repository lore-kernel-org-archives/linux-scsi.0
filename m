Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC7DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbiBHRuT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiBHRuS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:50:18 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3B8C061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:50:16 -0800 (PST)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtVsK2L8cz67bjj;
        Wed,  9 Feb 2022 01:50:13 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 18:50:13 +0100
Received: from [10.47.82.28] (10.47.82.28) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 8 Feb
 2022 17:50:09 +0000
Message-ID: <0e3cf0a7-1574-edb5-3bf1-dafe5eaa069b@huawei.com>
Date:   Tue, 8 Feb 2022 17:50:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 30/44] mvsas: Fix a set-but-not-used warning
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-31-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220208172514.3481-31-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.82.28]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/02/2022 17:25, Bart Van Assche wrote:
> This patch fixes the following compiler warning:
> 
> drivers/scsi/mvsas/mv_init.c: In function ‘mvs_pci_init’:
> drivers/scsi/mvsas/mv_init.c:497:30: warning: variable ‘mpi’ set but not used [-Wunused-but-set-variable]
>    497 |         struct mvs_prv_info *mpi;
>        |                              ^~~
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Regardless of a somewhat useful comment, below (2nd), feel free to add:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/mvsas/mv_init.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index dcae2d4464f9..d82b3129119a 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -494,7 +494,6 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   {
>   	unsigned int rc, nhost = 0;
>   	struct mvs_info *mvi;
> -	struct mvs_prv_info *mpi;
>   	irq_handler_t irq_handler = mvs_interrupt;
>   	struct Scsi_Host *shost = NULL;
>   	const struct mvs_chip_info *chip;
> @@ -559,10 +558,14 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		}
>   		nhost++;
>   	} while (nhost < chip->n_host);
> -	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
>   #ifdef CONFIG_SCSI_MVSAS_TASKLET

I really doubt the value such config options

> +	{
> +	struct mvs_prv_info *mpi;
> +
> +	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);

nit: I don't think that we require the cast to struct mvs_prv_info *

>   	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
>   		     (unsigned long)SHOST_TO_SAS_HA(shost));
> +	}
>   #endif
>   
>   	mvs_post_sas_ha_init(shost, chip);
> .

