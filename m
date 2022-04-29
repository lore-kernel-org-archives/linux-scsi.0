Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18350C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Apr 2022 09:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356306AbiD2JKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Apr 2022 05:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356307AbiD2JKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2022 05:10:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC735C42C6
        for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2022 02:06:51 -0700 (PDT)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KqRNz6DWHz686Vq;
        Fri, 29 Apr 2022 17:03:47 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 11:06:23 +0200
Received: from [10.47.91.78] (10.47.91.78) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Fri, 29 Apr
 2022 10:06:22 +0100
Message-ID: <0cb8d2e1-b2b3-04ac-9151-9b211d893cfd@huawei.com>
Date:   Fri, 29 Apr 2022 10:06:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] scsi: pm80xx: Remove pm8001_tag_init()
To:     Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        <linux-scsi@vger.kernel.org>, Viswas G <Viswas.G@microchip.com>,
        "Ruksar Devadi" <Ruksar.devadi@microchip.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20220428000326.3622230-1-ipylypiv@google.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220428000326.3622230-1-ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.78]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/04/2022 01:03, Igor Pylypiv wrote:
> In commit 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
> I/O supported to 1024") the pm8001_ha->tags allocation was moved into
> pm8001_init_ccb_tag(). This changed the execution order of allocation.
> pm8001_tag_init() used to be called after the pm8001_ha->tags allocation
> and now it is called before the allocation.
> 
> Before:
> 
> pm8001_pci_probe()
> `--> pm8001_pci_alloc()
>       `--> pm8001_alloc()
>            `--> pm8001_ha->tags = kzalloc(...)
>            `--> pm8001_tag_init(pm8001_ha); // OK: tags are allocated
> 
> After:
> 
> pm8001_pci_probe()
> `--> pm8001_pci_alloc()
> |    `--> pm8001_alloc()
> |         `--> pm8001_tag_init(pm8001_ha); // NOK: tags are not allocated
> |
> `--> pm8001_init_ccb_tag()
>       `-->  pm8001_ha->tags = kzalloc(...) // today it is bitmap_zalloc()
> 
> Since pm8001_ha->tags_num is zero when pm8001_tag_init() is called it does
> nothing. Tags memory is allocated with bitmap_zalloc() so there is no need
> to manually clear each bit with pm8001_tag_free().

Your change looks ok. But please note the following discussed in the 
following link, there was/is a bug in the lateness in which the tags are 
allocated:

https://lore.kernel.org/linux-scsi/PH0PR11MB5112D8C17D9EA268C197893FEC579@PH0PR11MB5112.namprd11.prod.outlook.com/

I don't think that it has been fixed yet...

Thanks,
John

> 
> Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
> I/O supported to 1024")
> Reviewed-by: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>   drivers/scsi/pm8001/pm8001_init.c | 2 --
>   drivers/scsi/pm8001/pm8001_sas.c  | 7 -------
>   drivers/scsi/pm8001/pm8001_sas.h  | 1 -
>   3 files changed, 10 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9b04f1a6a67d..7040cecd861b 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -420,8 +420,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>   		atomic_set(&pm8001_ha->devices[i].running_req, 0);
>   	}
>   	pm8001_ha->flags = PM8001F_INIT_TIME;
> -	/* Initialize tags */
> -	pm8001_tag_init(pm8001_ha);
>   	return 0;
>   
>   err_out_nodev:
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 3a863d776724..dc689055341b 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -92,13 +92,6 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
>   	return 0;
>   }
>   
> -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)
> -{
> -	int i;
> -	for (i = 0; i < pm8001_ha->tags_num; ++i)
> -		pm8001_tag_free(pm8001_ha, i);
> -}
> -
>   /**
>    * pm8001_mem_alloc - allocate memory for pm8001.
>    * @pdev: pci device.
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 060ab680a7ed..ba959f986c1e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -633,7 +633,6 @@ extern struct workqueue_struct *pm8001_wq;
>   
>   /******************** function prototype *********************/
>   int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
> -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
>   u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
>   void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>   			  struct pm8001_ccb_info *ccb);

