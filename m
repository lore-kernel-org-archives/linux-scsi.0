From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/15] hisi_sas: disable dlvry queues once at reset for v2
 hw
Date: Wed, 14 Sep 2016 14:46:54 +0200
Message-ID: <3a66d740-6764-de25-097f-c910fe5eb5de@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-7-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54653 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761960AbcINMq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 08:46:59 -0400
In-Reply-To: <1473176185-217808-7-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> The Delivery queue enable register should only be written
> to once at reset for v2 hw.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 25e7c58..aca2b80 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -685,9 +685,7 @@ static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
>  	else
>  		reset_val = 0x7ffff;
>  
> -	/* Disable all of the DQ */
> -	for (i = 0; i < HISI_SAS_MAX_QUEUES; i++)
> -		hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
> +	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
>  
>  	/* Disable all of the PHYs */
>  	for (i = 0; i < hisi_hba->n_phy; i++) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
