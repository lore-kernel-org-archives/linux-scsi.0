Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC101C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2ADF2070E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKNKlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:41:46 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2099 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726599AbfKNKlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 05:41:46 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id EC05FAFBC9050F869DF2;
        Thu, 14 Nov 2019 10:41:43 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 14 Nov 2019 10:41:43 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 14 Nov
 2019 10:41:43 +0000
Subject: Re: [PATCH V2 10/13] pm80xx : Do not request 12G sas speeds.
To:     Deepak Ukey <deepak.ukey@microchip.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "Vasanthalakshmi.Tharmarajan@microchip.com" 
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        "Viswas.G@microchip.com" <Viswas.G@microchip.com>,
        "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dpf@google.com" <dpf@google.com>,
        "jsperbeck@google.com" <jsperbeck@google.com>,
        "auradkar@google.com" <auradkar@google.com>,
        "ianyar@google.com" <ianyar@google.com>
References: <20191114100910.6153-1-deepak.ukey@microchip.com>
 <20191114100910.6153-11-deepak.ukey@microchip.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1fbdb6d0-89c7-c2a8-3d75-2628948e8baf@huawei.com>
Date:   Thu, 14 Nov 2019 10:41:42 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191114100910.6153-11-deepak.ukey@microchip.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/11/2019 10:09, Deepak Ukey wrote:
> From: peter chang <dpf@google.com>
> 
> occasionally, 6G capable drives fail to train at 6G on links that look
> good from a signal-integrity perspective. PMC suggests configuring the
> port to not even expect 12G.

We can set the PHY max hw linkrate at 6Gbps via sysfs, but I assume that 
this is not good enough.

So could the driver has the intelligence to know the training failed, 
and reset the max linkrate accordingly and retry?

It just seems that adding a module parameter to set the max linkrate is 
a little heavy handed.

BTW, how is this handled in the phy control rate callback, 
pm8001_phy_control? Would 6Gbps be set as PHY hw linkrate?

Thanks,
John

> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>   drivers/scsi/pm8001/pm8001_init.c | 17 +++++++++++++++++
>   drivers/scsi/pm8001/pm8001_sas.h  |  1 +
>   drivers/scsi/pm8001/pm80xx_hwi.c  | 21 ++++-----------------
>   3 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index b7cc3d05a3e0..86b619d10392 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -41,11 +41,20 @@
>   #include <linux/slab.h>
>   #include "pm8001_sas.h"
>   #include "pm8001_chips.h"
> +#include "pm80xx_hwi.h"
>   
>   static ulong logging_level = PM8001_FAIL_LOGGING | PM8001_IOERR_LOGGING;
>   module_param(logging_level, ulong, 0644);
>   MODULE_PARM_DESC(logging_level, " bits for enabling logging info.");
>   
> +static ulong link_rate = LINKRATE_15 | LINKRATE_30 | LINKRATE_60 | LINKRATE_120;
> +module_param(link_rate, ulong, 0644);
> +MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
> +		" 1: Link rate 1.5G\n"
> +		" 2: Link rate 3.0G\n"
> +		" 4: Link rate 6.0G\n"
> +		" 8: Link rate 12.0G\n");
> +
>   static struct scsi_transport_template *pm8001_stt;
>   
>   /**
> @@ -471,6 +480,14 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>   	pm8001_ha->shost = shost;
>   	pm8001_ha->id = pm8001_id++;
>   	pm8001_ha->logging_level = logging_level;
> +	if (link_rate >= 1 && link_rate <= 15)
> +		pm8001_ha->link_rate = (link_rate << 8);
> +	else {
> +		pm8001_ha->link_rate = LINKRATE_15 | LINKRATE_30 |
> +			LINKRATE_60 | LINKRATE_120;
> +		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +			"Setting link rate to default value\n"));
> +	}
>   	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
>   	/* IOMB size is 128 for 8088/89 controllers */
>   	if (pm8001_ha->chip_id != chip_8001)
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index d64883b80da9..f7be7b85624e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -546,6 +546,7 @@ struct pm8001_hba_info {
>   	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
>   #endif
>   	u32			logging_level;
> +	u32			link_rate;
>   	u32			fw_status;
>   	u32			smp_exp_mode;
>   	bool			controller_fatal_error;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 09008db2efdc..5ca9732f4704 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -37,6 +37,7 @@
>    * POSSIBILITY OF SUCH DAMAGES.
>    *
>    */
> + #include <linux/version.h>
>    #include <linux/slab.h>
>    #include "pm8001_sas.h"
>    #include "pm80xx_hwi.h"
> @@ -4565,23 +4566,9 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>   
>   	PM8001_INIT_DBG(pm8001_ha,
>   		pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
> -	/*
> -	 ** [0:7]	PHY Identifier
> -	 ** [8:11]	link rate 1.5G, 3G, 6G
> -	 ** [12:13] link mode 01b SAS mode; 10b SATA mode; 11b Auto mode
> -	 ** [14]	0b disable spin up hold; 1b enable spin up hold
> -	 ** [15] ob no change in current PHY analig setup 1b enable using SPAST
> -	 */
> -	if (!IS_SPCV_12G(pm8001_ha->pdev))
> -		payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> -				LINKMODE_AUTO | LINKRATE_15 |
> -				LINKRATE_30 | LINKRATE_60 | phy_id);
> -	else
> -		payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> -				LINKMODE_AUTO | LINKRATE_15 |
> -				LINKRATE_30 | LINKRATE_60 | LINKRATE_120 |
> -				phy_id);
>   
> +	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> +			LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
>   	/* SSC Disable and SAS Analog ST configuration */
>   	/**
>   	payload.ase_sh_lm_slr_phyid =
> @@ -4594,7 +4581,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>   	payload.sas_identify.dev_type = SAS_END_DEVICE;
>   	payload.sas_identify.initiator_bits = SAS_PROTOCOL_ALL;
>   	memcpy(payload.sas_identify.sas_addr,
> -	  &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
> +	  &pm8001_ha->sas_addr, SAS_ADDR_SIZE);
>   	payload.sas_identify.phy_id = phy_id;
>   	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
>   			sizeof(payload), 0);
> 

