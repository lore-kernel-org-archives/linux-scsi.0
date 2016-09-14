From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/15] hisi_sas: use safe BITS_PER_BYTE for slot tag size
 calculation
Date: Wed, 14 Sep 2016 14:46:26 +0200
Message-ID: <2347d56f-bf51-5be7-431d-ae5162cb00c3@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756090AbcINMqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 08:46:31 -0400
In-Reply-To: <1473176185-217808-6-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> The memory calculation for the tags bitmap should use BITS_PER_BYTE
> macro instead of coincidental same value of sizeof(unsigned long).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 0e48751..dcb17a3 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1309,7 +1309,7 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
>  	memset(hisi_hba->breakpoint, 0, s);
>  
>  	hisi_hba->slot_index_count = max_command_entries;
> -	s = hisi_hba->slot_index_count / sizeof(unsigned long);
> +	s = hisi_hba->slot_index_count / BITS_PER_BYTE;
>  	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
>  	if (!hisi_hba->slot_index_tags)
>  		goto err_out;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
