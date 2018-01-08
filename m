From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v3 1/3] scsi: libsas: fix memory leak in
 sas_smp_get_phy_events()
Date: Mon, 8 Jan 2018 10:01:25 +0100
Message-ID: <4c02b36e-fa4a-d28e-690c-699bdcd5caf0@suse.com>
References: <20180104130433.42813-1-yanaijie@huawei.com>
 <20180104130433.42813-2-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:37026 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755969AbeAHJB3 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 8 Jan 2018 04:01:29 -0500
In-Reply-To: <20180104130433.42813-2-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, John Garry <john.garry@huawei.com>, chenqilin <chenqilin2@huawei.com>, chenxiang <chenxiang66@hisilicon.com>

On 01/04/2018 02:04 PM, Jason Yan wrote:
> We've got a memory leak with the following producer:
> 
> while true;
> do cat /sys/class/sas_phy/phy-1:0:12/invalid_dword_count >/dev/null;
> done
> 
> The buffer req is allocated and not freed after we return. Fix it.
> 
> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: chenqilin <chenqilin2@huawei.com>
> CC: chenxiang <chenxiang66@hisilicon.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libsas/sas_expander.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 3183d63..4b0c67f 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -695,6 +695,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
>  	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
>  
>   out:
> +	kfree(req);
>  	kfree(resp);
>  	return res;
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
