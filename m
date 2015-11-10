From: Wei Fang <fangwei1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 08/32] scsi: hisi_sas: add hisi_sas_remove
Date: Tue, 10 Nov 2015 11:48:30 +0800
Message-ID: <5641690E.10303@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
 <1447086757-147706-9-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086757-147706-9-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi John,

On 2015/11/10 0:32, John Garry wrote:
> This patch also includes relevant memory/pool
> free'ing and sas/scsi host removal
> 
> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 71 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 70 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 97f5368..7f81000 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -126,6 +126,59 @@ err_out:
>  	return -ENOMEM;
>  }
>  
> +static void hisi_sas_free(struct hisi_hba *hisi_hba)
> +{
> +	struct device *dev = &hisi_hba->pdev->dev;
> +	int i, s;
> +
> +	for (i = 0; i < hisi_hba->queue_count; i++) {
> +		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
> +		if (hisi_hba->cmd_hdr[i])
> +			dma_free_coherent(dev, s,
> +					  hisi_hba->cmd_hdr[i],
> +					  hisi_hba->cmd_hdr_dma[i]);
> +
> +		s = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
> +		if (hisi_hba->complete_hdr[i])
> +			dma_free_coherent(dev, s,
> +					  hisi_hba->complete_hdr[i],
> +					  hisi_hba->complete_hdr_dma[i]);
> +	}
> +
> +	dma_pool_destroy(hisi_hba->status_buffer_pool);
> +	dma_pool_destroy(hisi_hba->command_table_pool);
> +	dma_pool_destroy(hisi_hba->sge_page_pool);
> +
> +	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
> +	if (hisi_hba->itct)
> +		dma_free_coherent(dev, s,
> +				  hisi_hba->itct, hisi_hba->itct_dma);
> +
> +	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_iost);
> +	if (hisi_hba->iost)
> +		dma_free_coherent(dev, s,
> +				  hisi_hba->iost, hisi_hba->iost_dma);
> +
> +	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint);
> +	if (hisi_hba->breakpoint)
> +		dma_free_coherent(dev, s,
> +				  hisi_hba->breakpoint,
> +				  hisi_hba->breakpoint_dma);
> +
> +
> +	s = sizeof(struct hisi_sas_initial_fis) * HISI_SAS_MAX_PHYS;
> +	if (hisi_hba->initial_fis)
> +		dma_free_coherent(dev, s,
> +				  hisi_hba->initial_fis,
> +				  hisi_hba->initial_fis_dma);
> +
> +	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint) * 2;
> +	if (hisi_hba->sata_breakpoint)
> +		dma_free_coherent(dev, s,
> +				  hisi_hba->sata_breakpoint,
> +				  hisi_hba->sata_breakpoint_dma);
> +
> +}
>  
>  static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>  					      const struct hisi_sas_hw *hw)
> @@ -188,8 +241,10 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>  	if (IS_ERR(hisi_hba->ctrl))
>  		goto err_out;
>  
> -	if (hisi_sas_alloc(hisi_hba, shost))
> +	if (hisi_sas_alloc(hisi_hba, shost)) {
> +		hisi_sas_free(hisi_hba);
>  		goto err_out;
> +	}
>  
>  	return shost;
>  err_out:
> @@ -270,6 +325,20 @@ err_out_ha:
>  }
>  EXPORT_SYMBOL_GPL(hisi_sas_probe);
>  
> +int hisi_sas_remove(struct platform_device *pdev)
> +{
> +	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
> +	struct hisi_hba *hisi_hba = sha->lldd_ha;
> +
> +	sas_unregister_ha(sha);
> +	sas_remove_host(sha->core.shost);
> +	scsi_remove_host(sha->core.shost);

scsi host should be removed before detaching SAS transport.

See more information:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Thanks,
Wei

> +	hisi_sas_free(hisi_hba);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hisi_sas_remove);
> +
>  static __init int hisi_sas_init(void)
>  {
>  	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
