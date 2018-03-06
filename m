From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 8/8] scsi: hisi_sas: Code cleanup and minor bug fixes
Date: Tue, 6 Mar 2018 12:34:36 +0100
Message-ID: <301d4ff0-e1ac-fc40-9af2-2b6bf54b41b9@suse.de>
References: <1520261330-204596-1-git-send-email-john.garry@huawei.com>
 <1520261330-204596-9-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520261330-204596-9-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 03/05/2018 03:48 PM, John Garry wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> The patch does some code cleanup and fixes some small bugs:
> - Correct return status of phy_up_v3_hw()
> - Add static for function phy_get_max_linkrate_v3_hw()
> - Change exception return status when no reset method
> - Change magic value to ts->stat in slot_complete_vx_hw()
> - Remove unnecessary check for dev_is_sata()
> - Fix some issues of alignment and indents (Authored by
>   Xiaofei Tan in another patch, but added here to be
>   practical)
> 
> Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 14 +++++++-------
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 +++-
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 10 ++++++----
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++++++-------
>  4 files changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index dff9723..49c1fa6 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -33,7 +33,7 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
>  	case ATA_CMD_FPDMA_RECV:
>  	case ATA_CMD_FPDMA_SEND:
>  	case ATA_CMD_NCQ_NON_DATA:
> -	return HISI_SAS_SATA_PROTOCOL_FPDMA;
> +		return HISI_SAS_SATA_PROTOCOL_FPDMA;
>  
>  	case ATA_CMD_DOWNLOAD_MICRO:
>  	case ATA_CMD_ID_ATA:
> @@ -45,7 +45,7 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
>  	case ATA_CMD_WRITE_LOG_EXT:
>  	case ATA_CMD_PIO_WRITE:
>  	case ATA_CMD_PIO_WRITE_EXT:
> -	return HISI_SAS_SATA_PROTOCOL_PIO;
> +		return HISI_SAS_SATA_PROTOCOL_PIO;
>  
>  	case ATA_CMD_DSM:
>  	case ATA_CMD_DOWNLOAD_MICRO_DMA:
> @@ -64,7 +64,7 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
>  	case ATA_CMD_WRITE_LOG_DMA_EXT:
>  	case ATA_CMD_WRITE_STREAM_DMA_EXT:
>  	case ATA_CMD_ZAC_MGMT_IN:
> -	return HISI_SAS_SATA_PROTOCOL_DMA;
> +		return HISI_SAS_SATA_PROTOCOL_DMA;
>  
>  	case ATA_CMD_CHK_POWER:
>  	case ATA_CMD_DEV_RESET:
> @@ -77,21 +77,21 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
>  	case ATA_CMD_STANDBY:
>  	case ATA_CMD_STANDBYNOW1:
>  	case ATA_CMD_ZAC_MGMT_OUT:
> -	return HISI_SAS_SATA_PROTOCOL_NONDATA;
> +		return HISI_SAS_SATA_PROTOCOL_NONDATA;
>  	default:
>  	{
>  		if (fis->command == ATA_CMD_SET_MAX) {
>  			switch (fis->features) {
>  			case ATA_SET_MAX_PASSWD:
>  			case ATA_SET_MAX_LOCK:
> -			return HISI_SAS_SATA_PROTOCOL_PIO;
> +				return HISI_SAS_SATA_PROTOCOL_PIO;
>  
>  			case ATA_SET_MAX_PASSWD_DMA:
>  			case ATA_SET_MAX_UNLOCK_DMA:
> -			return HISI_SAS_SATA_PROTOCOL_DMA;
> +				return HISI_SAS_SATA_PROTOCOL_DMA;
>  
>  			default:
> -			return HISI_SAS_SATA_PROTOCOL_NONDATA;
> +				return HISI_SAS_SATA_PROTOCOL_NONDATA;
>  			}
>  		}
>  		if (direction == DMA_NONE)
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index 8dd0e6a6..520ba69 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -651,8 +651,10 @@ static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
>  			dev_err(dev, "De-reset failed\n");
>  			return -EIO;
>  		}
> -	} else
> +	} else {
>  		dev_warn(dev, "no reset method\n");
> +		return -EIO;
> +	}
>  
return -EINVAL?

>  	return 0;
>  }
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index bd1a48a..69c4dd1 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -1095,8 +1095,10 @@ static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
>  			dev_err(dev, "SAS de-reset fail.\n");
>  			return -EIO;
>  		}
> -	} else
> -		dev_warn(dev, "no reset method\n");
> +	} else {
> +		dev_err(dev, "no reset method\n");
> +		return -EIO;
> +	}
>  
>  	return 0;
>  }
return -EINVAL?

> @@ -2408,7 +2410,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
>  		spin_lock_irqsave(&hisi_hba->lock, flags);
>  		hisi_sas_slot_task_free(hisi_hba, task, slot);
>  		spin_unlock_irqrestore(&hisi_hba->lock, flags);
> -		return -1;
> +		return ts->stat;
>  	}
>  
>  	if (unlikely(!sas_dev)) {> @@ -2667,7 +2669,7 @@ static int prep_abort_v2_hw(struct hisi_hba
*hisi_hba,
>  	/* dw0 */
>  	hdr->dw0 = cpu_to_le32((5 << CMD_HDR_CMD_OFF) | /*abort*/
>  			       (port->id << CMD_HDR_PORT_OFF) |
> -			       ((dev_is_sata(dev) ? 1:0) <<
> +			       (dev_is_sata(dev) <<
>  				CMD_HDR_ABORT_DEVICE_TYPE_OFF) |
>  			       (abort_flag << CMD_HDR_ABORT_FLAG_OFF));
>  
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 8da9de7..b9b5d9f 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -670,8 +670,10 @@ static int reset_hw_v3_hw(struct hisi_hba *hisi_hba)
>  			dev_err(dev, "Reset failed\n");
>  			return -EIO;
>  		}
> -	} else
> +	} else {
>  		dev_err(dev, "no reset method!\n");
> +		return -EIO;
> +	}
>  
>  	return 0;
>  }
return -EINVAL?

> @@ -731,7 +733,7 @@ static void phy_hard_reset_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
>  	start_phy_v3_hw(hisi_hba, phy_no);
>  }
>  
> -enum sas_linkrate phy_get_max_linkrate_v3_hw(void)
> +static enum sas_linkrate phy_get_max_linkrate_v3_hw(void)
>  {
>  	return SAS_LINK_RATE_12_0_GBPS;
>  }
> @@ -1096,7 +1098,7 @@ static int prep_abort_v3_hw(struct hisi_hba *hisi_hba,
>  	/* dw0 */
>  	hdr->dw0 = cpu_to_le32((5 << CMD_HDR_CMD_OFF) | /*abort*/
>  			       (port->id << CMD_HDR_PORT_OFF) |
> -				   ((dev_is_sata(dev) ? 1:0)
> +				   (dev_is_sata(dev)
>  					<< CMD_HDR_ABORT_DEVICE_TYPE_OFF) |
>  					(abort_flag
>  					 << CMD_HDR_ABORT_FLAG_OFF));
> @@ -1114,7 +1116,7 @@ static int prep_abort_v3_hw(struct hisi_hba *hisi_hba,
>  
>  static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
>  {
> -	int i, res = 0;
> +	int i, res;
>  	u32 context, port_id, link_rate;
>  	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
>  	struct asd_sas_phy *sas_phy = &phy->sas_phy;
> @@ -1186,7 +1188,7 @@ static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
>  	phy->port_id = port_id;
>  	phy->phy_attached = 1;
>  	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
> -
> +	res = IRQ_HANDLED;
>  end:
>  	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
>  			     CHL_INT0_SL_PHY_ENABLE_MSK);
> @@ -1217,7 +1219,7 @@ static int phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
>  	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, CHL_INT0_NOT_RDY_MSK);
>  	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 0);
>  
> -	return 0;
> +	return IRQ_HANDLED;
>  }
>  
>  static void phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)

If we're returning IRQ_HANDLED, shouldn't the function have the return
type irqreturn_t ?
But as this isn't an interrupt handler, shouldn't we rather fixup the
caller to check for the correct return values?

> @@ -1573,7 +1575,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
>  		spin_lock_irqsave(&hisi_hba->lock, flags);
>  		hisi_sas_slot_task_free(hisi_hba, task, slot);
>  		spin_unlock_irqrestore(&hisi_hba->lock, flags);
> -		return -1;
> +		return ts->stat;
>  	}
>  
>  	if (unlikely(!sas_dev)) {
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
