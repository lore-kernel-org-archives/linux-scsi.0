From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH V2 08/10] pm80xx: Queue rotation logic for inbound and
 outbound queues
Date: Thu, 26 Sep 2013 09:08:02 +0200
Message-ID: <5243DD52.7010304@gmail.com>
References: <5243C8D8.5090505@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49206 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3IZHHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 03:07:53 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so308603eaj.28
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2013 00:07:52 -0700 (PDT)
In-Reply-To: <5243C8D8.5090505@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com

On 09/26/2013 07:40 AM, Anand wrote:
> From 678d8085ace7c471dc140420c41dc4ad70300d60 Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Wed, 18 Sep 2013 11:12:59 +0530
> Subject: [PATCH V2 08/10] pm80xx: Queue rotation logic for inbound and outbound queues.
> 
> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> 
I'd like to know the number of this improved for performance?

Jack

> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c |   31 +++++++++++++------------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 80a10aa..ce59d0d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3715,8 +3715,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  	int ret;
>  	u64 phys_addr;
>  	struct inbound_queue_table *circularQ;
> -	static u32 inb;
> -	static u32 outb;
> +	u32 q_index;
>  	u32 opc = OPC_INB_SSPINIIOSTART;
>  	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
>  	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
> @@ -3735,7 +3734,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
>  	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
>  		       task->ssp_task.cmd->cmd_len);
> -	circularQ = &pm8001_ha->inbnd_q_tbl[0];
> +	q_index = (u32) (pm8001_dev->id & 0x00ffffff) % PM8001_MAX_INB_NUM;
> +	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>  
>  	/* Check if encryption is set */
>  	if (pm8001_ha->chip->encrypt &&
> @@ -3783,7 +3783,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  	} else {
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
>  			"Sending Normal SAS command 0x%x inb q %x\n",
> -			task->ssp_task.cmd->cmnd[0], inb));
> +			task->ssp_task.cmd->cmnd[0], q_index));
>  		/* fill in PRD (scatter/gather) table, if any */
>  		if (task->num_scatter > 1) {
>  			pm8001_chip_make_sg(task->scatter, ccb->n_elem,
> @@ -3809,11 +3809,9 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  			ssp_cmd.esgl = 0;
>  		}
>  	}
> -	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd, outb++);
> -
> -	/* rotate the outb queue */
> -	outb = outb%PM8001_MAX_SPCV_OUTB_NUM;
> -
> +	q_index = (u32) (pm8001_dev->id & 0x00ffffff) % PM8001_MAX_OUTB_NUM;
> +	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
> +						&ssp_cmd, q_index);
>  	return ret;
>  }
>  
> @@ -3825,8 +3823,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
>  	u32 tag = ccb->ccb_tag;
>  	int ret;
> -	static u32 inb;
> -	static u32 outb;
> +	u32 q_index;
>  	struct sata_start_req sata_cmd;
>  	u32 hdr_tag, ncg_tag = 0;
>  	u64 phys_addr;
> @@ -3836,7 +3833,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	unsigned long flags;
>  	u32 opc = OPC_INB_SATA_HOST_OPSTART;
>  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> -	circularQ = &pm8001_ha->inbnd_q_tbl[0];
> +	q_index = (u32) (pm8001_ha_dev->id & 0x00ffffff) % PM8001_MAX_INB_NUM;
> +	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>  
>  	if (task->data_dir == PCI_DMA_NONE) {
>  		ATAP = 0x04; /* no data*/
> @@ -3917,7 +3915,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	} else {
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
>  			"Sending Normal SATA command 0x%x inb %x\n",
> -			sata_cmd.sata_fis.command, inb));
> +			sata_cmd.sata_fis.command, q_index));
>  		/* dad (bit 0-1) is 0 */
>  		sata_cmd.ncqtag_atap_dir_m_dad =
>  			cpu_to_le32(((ncg_tag & 0xff)<<16) |
> @@ -4014,12 +4012,9 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  			}
>  		}
>  	}
> -
> +	q_index = (u32) (pm8001_ha_dev->id & 0x00ffffff) % PM8001_MAX_OUTB_NUM;
>  	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
> -						&sata_cmd, outb++);
> -
> -	/* rotate the outb queue */
> -	outb = outb%PM8001_MAX_SPCV_OUTB_NUM;
> +						&sata_cmd, q_index);
>  	return ret;
>  }
>  
> 

