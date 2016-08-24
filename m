From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/8] hisi_sas: add internal abort in
 hisi_sas_dev_gone()
Date: Wed, 24 Aug 2016 14:41:54 +0200
Message-ID: <afdb313c-c621-da26-ae3a-7b0666274dd5@suse.de>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
 <1472036754-156813-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/24/2016 01:05 PM, John Garry wrote:
> Execute an internal abort for that device when it is removed,
> so that commands for that device are not processed.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 763c6c5..c4e59cd 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -621,6 +621,9 @@ static void hisi_sas_dev_gone(struct domain_device *device)
>  	dev_info(dev, "found dev[%lld:%x] is gone\n",
>  		 sas_dev->device_id, sas_dev->dev_type);
>  
> +	hisi_sas_internal_task_abort(hisi_hba, device,
> +				     HISI_SAS_INT_ABT_DEV, 0);
> +
>  	hisi_hba->hw->free_device(hisi_hba, sas_dev);
>  	device->lldd_dev = NULL;
>  	memset(sas_dev, 0, sizeof(*sas_dev));
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
