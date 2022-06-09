Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06105C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 12:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245340AbiFIMTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 08:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244432AbiFIMTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 08:19:07 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F641B586F
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 05:19:06 -0700 (PDT)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJjlt2S1Rz67x3s;
        Thu,  9 Jun 2022 20:17:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 14:19:04 +0200
Received: from [10.47.88.201] (10.47.88.201) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 9 Jun
 2022 13:19:03 +0100
Message-ID: <bacd4a39-7098-ccc6-b6c3-560b3f63e8f8@huawei.com>
Date:   Thu, 9 Jun 2022 13:19:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 3/3] scsi: libsas: introduce struct smp_rps_resp
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
 <20220609022456.409087-4-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220609022456.409087-4-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.201]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/06/2022 03:24, Damien Le Moal wrote:
> Similarly to sas report general and discovery responses, define the
> structure struct smp_rps_resp to handle SATA PHY report responses

nit: name smp_rps_resp is a bit cryptic to me. Is 
smp_report_phy_sata_resp just too long? I always come up with verbatim 
names ....

> using a structure with a size that is exactly equal to the sas defined
> response size.
> 
> With this change, struct smp_resp becomes unused and is removed.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/aic94xx/aic94xx_dev.c | 2 +-
>   drivers/scsi/libsas/sas_expander.c | 4 ++--
>   drivers/scsi/libsas/sas_internal.h | 2 +-
>   include/scsi/libsas.h              | 2 +-
>   include/scsi/sas.h                 | 8 ++------
>   5 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
> index 73506a459bf8..91d196f26b76 100644
> --- a/drivers/scsi/aic94xx/aic94xx_dev.c
> +++ b/drivers/scsi/aic94xx/aic94xx_dev.c
> @@ -159,7 +159,7 @@ static int asd_init_target_ddb(struct domain_device *dev)
>   		flags |= OPEN_REQUIRED;
>   		if ((dev->dev_type == SAS_SATA_DEV) ||
>   		    (dev->tproto & SAS_PROTOCOL_STP)) {
> -			struct smp_resp *rps_resp = &dev->sata_dev.rps_resp;
> +			struct smp_rps_resp *rps_resp = &dev->sata_dev.rps_resp;
>   			if (rps_resp->frame_type == SMP_RESPONSE &&
>   			    rps_resp->function == SMP_REPORT_PHY_SATA &&
>   			    rps_resp->result == SMP_RESP_FUNC_ACC) {
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 78a38980636e..fa2209080cc2 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -676,10 +676,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
>   #ifdef CONFIG_SCSI_SAS_ATA
>   
>   #define RPS_REQ_SIZE  16
> -#define RPS_RESP_SIZE 60
> +#define RPS_RESP_SIZE sizeof(struct smp_rps_resp)
>   
>   int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
> -			    struct smp_resp *rps_resp)
> +			    struct smp_rps_resp *rps_resp)
>   {
>   	int res;
>   	u8 *rps_req = alloc_smp_req(RPS_REQ_SIZE);
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 13d0ffaada93..8d0ad3abc7b5 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -83,7 +83,7 @@ struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
>   struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
>   int sas_ex_phy_discover(struct domain_device *dev, int single);
>   int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
> -			    struct smp_resp *rps_resp);
> +			    struct smp_rps_resp *rps_resp);
>   int sas_try_ata_reset(struct asd_sas_phy *phy);
>   void sas_hae_reset(struct work_struct *work);
>   
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ff04eb6d250b..2dbead74a2af 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -145,7 +145,7 @@ struct sata_device {
>   
>   	struct ata_port *ap;
>   	struct ata_host *ata_host;
> -	struct smp_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
> +	struct smp_rps_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
>   	u8     fis[ATA_RESP_FIS_SIZE];
>   };
>   
> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
> index a8f9743ed6fc..71b749bed3b0 100644
> --- a/include/scsi/sas.h
> +++ b/include/scsi/sas.h
> @@ -712,16 +712,12 @@ struct smp_disc_resp {
>   	struct discover_resp disc;
>   } __attribute__ ((packed));
>   
> -struct smp_resp {
> +struct smp_rps_resp {
>   	u8    frame_type;
>   	u8    function;
>   	u8    result;
>   	u8    reserved;
> -	union {
> -		struct report_general_resp  rg;
> -		struct discover_resp        disc;
> -		struct report_phy_sata_resp rps;
> -	};
> +	struct report_phy_sata_resp rps;
>   } __attribute__ ((packed));
>   
>   #endif /* _SAS_H_ */

