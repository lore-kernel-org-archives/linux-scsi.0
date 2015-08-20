From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V2 2/8] pm80xx: Corrected device state changes in
 I_T_Nexus_Reset.
Date: Thu, 20 Aug 2015 16:51:53 +0200
Message-ID: <55D5E989.9090401@redhat.com>
References: <1439285792-12030-1-git-send-email-Viswas.G@pmcs.com>
 <1439285792-12030-3-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbbHTOv4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2015 10:51:56 -0400
In-Reply-To: <1439285792-12030-3-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: Jack Wang <jinpu.wang@profitbricks.com>, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com, Hannes Reinecke <hare@suse.com>

On 11.8.2015 11:36, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
> 
> In Nexus reset the device state request are not needed.
> 
> Changes from V1:
> Device state change request has been removed as the firmware
> will handle it during internal cleanup. Also updated the
> proper return value in case of failures.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> 
> Reviewed-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> ---
>  drivers/scsi/pm8001/pm8001_sas.c |   18 +++++++++++++-----
>  drivers/scsi/pm8001/pm8001_sas.h |    8 ++++++++
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index b93f289..48f4627 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -975,19 +975,27 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
>  	phy = sas_get_local_phy(dev);
>  
>  	if (dev_is_sata(dev)) {
> -		DECLARE_COMPLETION_ONSTACK(completion_setstate);
>  		if (scsi_is_sas_phy_local(phy)) {
>  			rc = 0;
>  			goto out;
>  		}
>  		rc = sas_phy_reset(phy, 1);
> +		if (rc) {
> +			PM8001_EH_DBG(pm8001_ha,
> +			pm8001_printk("phy reset failed for device %x\n"
> +			"with rc %d\n", pm8001_dev->device_id, rc));
> +			rc = TMF_RESP_FUNC_FAILED;
> +			goto out;
> +		}
>  		msleep(2000);
>  		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
>  			dev, 1, 0);
> -		pm8001_dev->setds_completion = &completion_setstate;
> -		rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -			pm8001_dev, 0x01);
> -		wait_for_completion(&completion_setstate);
> +		if (rc) {
> +			PM8001_EH_DBG(pm8001_ha,
> +			pm8001_printk("task abort failed %x\n"
> +			"with rc %d\n", pm8001_dev->device_id, rc));
> +			rc = TMF_RESP_FUNC_FAILED;
> +		}
>  	} else {
>  		rc = sas_phy_reset(phy, 1);
>  		msleep(2000);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 8dd8b78..c9736cc 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -569,6 +569,14 @@ struct pm8001_fw_image_header {
>  #define	NCQ_READ_LOG_FLAG			0x80000000
>  #define	NCQ_ABORT_ALL_FLAG			0x40000000
>  #define	NCQ_2ND_RLE_FLAG			0x20000000
> +
> +/* Device states */
> +#define DS_OPERATIONAL				0x01
> +#define DS_PORT_IN_RESET			0x02
> +#define DS_IN_RECOVERY				0x03
> +#define DS_IN_ERROR				0x04
> +#define DS_NON_OPERATIONAL			0x07
> +
>  /**
>   * brief param structure for firmware flash update.
>   */
> 

