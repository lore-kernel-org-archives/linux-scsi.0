From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 4/5] pm80xx: Print SAS address of IO failed device, 4G
 boundary fix.
Date: Mon, 16 Sep 2013 18:21:06 +0200
Message-ID: <52372FF2.9020902@gmail.com>
References: <52372A9B.2000900@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40727 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3IPQUF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2013 12:20:05 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so1688662bkb.10
        for <linux-scsi@vger.kernel.org>; Mon, 16 Sep 2013 09:20:03 -0700 (PDT)
In-Reply-To: <52372A9B.2000900@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Viswas.G@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

On 09/16/2013 05:58 PM, Anand wrote:
> From 3574b24db1a5472df9cef88010fabad7742351e5 Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Tue, 3 Sep 2013 16:55:54 +0530
> Subject: [PATCH 4/5] pm80xx: Print SAS address of IO failed device, 4G boundary fix.
> 
> Added queue rotation logic to improve IO performance.
> Print sas address of failed IO device.
> Fix for single SG crossing 4G boundary.
> 
Similar here, please split the patch into at least 4:
1 queue rotation logic
2 print sas address support
3 sg boundary fix
4 set device state rsp logic fix

Jack

> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> 
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c  |   71 +++++++++++++-
>  drivers/scsi/pm8001/pm8001_init.c |    4 +
>  drivers/scsi/pm8001/pm8001_sas.c  |    9 ++-
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  199 +++++++++++++++++++++++++++++++++----
>  4 files changed, 260 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 2fd8c38..502c7d6 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1868,6 +1868,13 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
>  	if (unlikely(!t || !t->lldd_task || !t->dev))
>  		return;
>  	ts = &t->task_status;
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW))
> +		PM8001_FAIL_DBG(pm8001_ha,
> +			pm8001_printk("SAS Address of IO Failure Drive:"
> +			"%016llx", SAS_ADDR(t->dev->sas_addr)-1));
> +
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
> @@ -2276,6 +2283,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  	u32 param;
>  	u32 status;
>  	u32 tag;
> +	int i, j;
> +	u8 sata_addr_low[4];
> +	u32 temp_sata_addr_low;
> +	u8 sata_addr_hi[4];
> +	u32 temp_sata_addr_hi;
>  	struct sata_completion_resp *psataPayload;
>  	struct task_status_struct *ts;
>  	struct ata_task_resp *resp ;
> @@ -2325,7 +2337,60 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  			pm8001_printk("ts null\n"));
>  		return;
>  	}
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW)) {
> +		if (!((t->dev->parent) &&
> +			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
> +			for (i = 0 , j = 4 ; j <= 7 && i <= 3 ; i++ , j++)
> +				sata_addr_low[i] = pm8001_ha->sas_addr[j];
> +			for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
> +				sata_addr_hi[i] = pm8001_ha->sas_addr[j];
> +			memcpy(&temp_sata_addr_low, sata_addr_low,
> +				sizeof(sata_addr_low));
> +			memcpy(&temp_sata_addr_hi, sata_addr_hi,
> +				sizeof(sata_addr_hi));
> +			temp_sata_addr_hi = (((temp_sata_addr_hi >> 24) & 0xff)
> +						|((temp_sata_addr_hi << 8) &
> +						0xff0000) |
> +						((temp_sata_addr_hi >> 8)
> +						& 0xff00) |
> +						((temp_sata_addr_hi << 24) &
> +						0xff000000));
> +			temp_sata_addr_low = ((((temp_sata_addr_low >> 24)
> +						& 0xff) |
> +						((temp_sata_addr_low << 8)
> +						& 0xff0000) |
> +						((temp_sata_addr_low >> 8)
> +						& 0xff00) |
> +						((temp_sata_addr_low << 24)
> +						& 0xff000000)) +
> +						pm8001_dev->attached_phy +
> +						0x10);
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
> +		} else {
> +			for (i = 0 , j = 4 ; j <= 7 && i <= 3; i++ , j++)
> +				sata_addr_low[i] = t->dev->sas_addr[j];
> +			for (i = 0 , j = 0 ; j <= 3 && i <= 3 ; i++ , j++)
> +				sata_addr_hi[i] = t->dev->sas_addr[j];
> +			temp_sata_addr_low = (sata_addr_low[0] << 24) |
> +						(sata_addr_low[1] << 16) |
> +						(sata_addr_low[2] << 8) |
> +						(sata_addr_low[3]);
> +			temp_sata_addr_hi =  (sata_addr_hi[0] << 24)|
> +						(sata_addr_hi[1] << 16)|
> +						(sata_addr_hi[2] << 8)|
> +						(sata_addr_hi[3]);
>  
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
> +		}
> +	}
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
> @@ -3087,8 +3152,8 @@ void pm8001_mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha,
>  	struct pm8001_device *pm8001_dev = ccb->device;
>  	u32 status = le32_to_cpu(pPayload->status);
>  	u32 device_id = le32_to_cpu(pPayload->device_id);
> -	u8 pds = le32_to_cpu(pPayload->pds_nds) | PDS_BITS;
> -	u8 nds = le32_to_cpu(pPayload->pds_nds) | NDS_BITS;
> +	u8 pds = le32_to_cpu(pPayload->pds_nds) & PDS_BITS;
> +	u8 nds = le32_to_cpu(pPayload->pds_nds) & NDS_BITS;
>  	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set device id = 0x%x state "
>  		"from 0x%x to 0x%x status = 0x%x!\n",
>  		device_id, pds, nds, status));
> @@ -4700,6 +4765,8 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
>  	sspTMCmd.tmf = cpu_to_le32(tmf->tmf);
>  	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
>  	sspTMCmd.tag = cpu_to_le32(ccb->ccb_tag);
> +	if (pm8001_ha->chip_id != chip_8001)
> +		sspTMCmd.ds_ads_m = 0x08;
>  	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>  	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd, 0);
>  	return ret;
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index e697cee..5ed33d0 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -865,8 +865,10 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>  
>  	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
>  	if (pm8001_ha->chip_id != chip_8001) {
> +#ifdef PM8001_USE_MSIX
>  		for (i = 1; i < pm8001_ha->number_of_intr; i++)
>  			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
> +#endif
>  		/* setup thermal configuration. */
>  		pm80xx_set_thermal_config(pm8001_ha);
>  	}
> @@ -1035,10 +1037,12 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  			(unsigned long)pm8001_ha);
>  #endif
>  	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
> +#ifdef PM8001_USE_MSIX
>  	if (pm8001_ha->chip_id != chip_8001) {
>  		for (i = 1; i < pm8001_ha->number_of_intr; i++)
>  			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
>  	}
> +#endif
>  	scsi_unblock_requests(pm8001_ha->shost);
>  	return 0;
>  
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index a85d73d..f4eb18e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -447,7 +447,6 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
>  			break;
>  		case SAS_PROTOCOL_SATA:
>  		case SAS_PROTOCOL_STP:
> -		case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
>  			rc = pm8001_task_prep_ata(pm8001_ha, ccb);
>  			break;
>  		default:
> @@ -704,6 +703,8 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>  	int res, retry;
>  	struct sas_task *task = NULL;
>  	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
> +	struct pm8001_device *pm8001_dev = dev->lldd_dev;
> +	DECLARE_COMPLETION_ONSTACK(completion_setstate);
>  
>  	for (retry = 0; retry < 3; retry++) {
>  		task = sas_alloc_slow_task(GFP_KERNEL);
> @@ -729,6 +730,12 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>  			goto ex_err;
>  		}
>  		wait_for_completion(&task->slow_task->completion);
> +		if (pm8001_ha->chip_id != chip_8001) {
> +			pm8001_dev->setds_completion = &completion_setstate;
> +				PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> +					pm8001_dev, 0x01);
> +			wait_for_completion(&completion_setstate);
> +		}
>  		res = -TMF_RESP_FUNC_FAILED;
>  		/* Even TMF timed out, return direct. */
>  		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 70fa7d9..187b9f0 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1296,6 +1296,13 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
>  	if (unlikely(!t || !t->lldd_task || !t->dev))
>  		return;
>  	ts = &t->task_status;
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW))
> +		PM8001_FAIL_DBG(pm8001_ha,
> +			pm8001_printk("SAS Address of IO Failure Drive"
> +			":%016llx", SAS_ADDR(t->dev->sas_addr)-1));
> +
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha,
> @@ -1719,6 +1726,10 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  	u32 param;
>  	u32 status;
>  	u32 tag;
> +	int i, j;
> +	u8 sata_addr_low[4];
> +	u32 temp_sata_addr_low, temp_sata_addr_hi;
> +	u8 sata_addr_hi[4];
>  	struct sata_completion_resp *psataPayload;
>  	struct task_status_struct *ts;
>  	struct ata_task_resp *resp ;
> @@ -1768,7 +1779,61 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  			pm8001_printk("ts null\n"));
>  		return;
>  	}
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW)) {
> +		if (!((t->dev->parent) &&
> +			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
> +			for (i = 0 , j = 4 ; i <= 3 && j <= 7 ; i++ , j++)
> +				sata_addr_low[i] = pm8001_ha->sas_addr[j];
> +			for (i = 0 , j = 0; i <= 3 && j <= 3; i++ , j++)
> +				sata_addr_hi[i] = pm8001_ha->sas_addr[j];
> +			memcpy(&temp_sata_addr_low, sata_addr_low,
> +				sizeof(sata_addr_low));
> +			memcpy(&temp_sata_addr_hi, sata_addr_hi,
> +				sizeof(sata_addr_hi));
> +			temp_sata_addr_hi = (((temp_sata_addr_hi >> 24) & 0xff)
> +						|((temp_sata_addr_hi << 8) &
> +						0xff0000) |
> +						((temp_sata_addr_hi >> 8)
> +						& 0xff00) |
> +						((temp_sata_addr_hi << 24) &
> +						0xff000000));
> +			temp_sata_addr_low = ((((temp_sata_addr_low >> 24)
> +						& 0xff) |
> +						((temp_sata_addr_low << 8)
> +						& 0xff0000) |
> +						((temp_sata_addr_low >> 8)
> +						& 0xff00) |
> +						((temp_sata_addr_low << 24)
> +						& 0xff000000)) +
> +						pm8001_dev->attached_phy +
> +						0x10);
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
>  
> +		} else {
> +			for (i = 0 , j = 4 ; i <= 3 && j <= 7; i++ , j++)
> +				sata_addr_low[i] = t->dev->sas_addr[j];
> +			for (i = 0 , j = 0 ; i <= 3 && j <= 3 ; i++ , j++)
> +				sata_addr_hi[i] = t->dev->sas_addr[j];
> +			temp_sata_addr_low = (sata_addr_low[0] << 24) |
> +						(sata_addr_low[1] << 16) |
> +						(sata_addr_low[2] << 8) |
> +						(sata_addr_low[3]);
> +			temp_sata_addr_hi =  (sata_addr_hi[0] << 24)|
> +						(sata_addr_hi[1] << 16)|
> +						(sata_addr_hi[2] << 8)|
> +						(sata_addr_hi[3]);
> +
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
> +		}
> +	}
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
> @@ -3648,10 +3713,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  	struct ssp_ini_io_start_req ssp_cmd;
>  	u32 tag = ccb->ccb_tag;
>  	int ret;
> -	u64 phys_addr;
> +	u64 phys_addr, start_addr, end_addr;
> +	u32 end_addr_high, end_addr_low;
>  	struct inbound_queue_table *circularQ;
> -	static u32 inb;
> -	static u32 outb;
> +	u32 q_index;
>  	u32 opc = OPC_INB_SSPINIIOSTART;
>  	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
>  	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
> @@ -3670,7 +3735,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
>  	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
>  		       task->ssp_task.cmd->cmd_len);
> -	circularQ = &pm8001_ha->inbnd_q_tbl[0];
> +	q_index = (u32) (pm8001_dev->id & 0x00ffffff) % PM8001_MAX_INB_NUM;
> +	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>  
>  	/* Check if encryption is set */
>  	if (pm8001_ha->chip->encrypt &&
> @@ -3702,6 +3768,30 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  				cpu_to_le32(upper_32_bits(dma_addr));
>  			ssp_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
>  			ssp_cmd.enc_esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + ssp_cmd.enc_len) - 1;
> +			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != ssp_cmd.enc_addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list address "
> +					"start_addr=0x%016llx data_len=0x%x "
> +					"end_addr_high=0x%08x end_addr_low="
> +					"0x%08x has crossed 4G boundary\n",
> +						start_addr, ssp_cmd.enc_len,
> +						end_addr_high, end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +					offsetof(struct pm8001_ccb_info,
> +						buf_prd[0]);
> +				ssp_cmd.enc_addr_low =
> +					cpu_to_le32(lower_32_bits(phys_addr));
> +				ssp_cmd.enc_addr_high =
> +					cpu_to_le32(upper_32_bits(phys_addr));
> +				ssp_cmd.enc_esgl = cpu_to_le32(1<<31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			ssp_cmd.enc_addr_low = 0;
>  			ssp_cmd.enc_addr_high = 0;
> @@ -3718,7 +3808,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  	} else {
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
>  			"Sending Normal SAS command 0x%x inb q %x\n",
> -			task->ssp_task.cmd->cmnd[0], inb));
> +			task->ssp_task.cmd->cmnd[0], q_index));
>  		/* fill in PRD (scatter/gather) table, if any */
>  		if (task->num_scatter > 1) {
>  			pm8001_chip_make_sg(task->scatter, ccb->n_elem,
> @@ -3737,6 +3827,30 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>  				cpu_to_le32(upper_32_bits(dma_addr));
>  			ssp_cmd.len = cpu_to_le32(task->total_xfer_len);
>  			ssp_cmd.esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + ssp_cmd.len) - 1;
> +			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != ssp_cmd.addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list address "
> +					"start_addr=0x%016llx data_len=0x%x "
> +					"end_addr_high=0x%08x end_addr_low="
> +					"0x%08x has crossed 4G boundary\n",
> +						 start_addr, ssp_cmd.len,
> +						 end_addr_high, end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +					offsetof(struct pm8001_ccb_info,
> +						 buf_prd[0]);
> +				ssp_cmd.addr_low =
> +					cpu_to_le32(lower_32_bits(phys_addr));
> +				ssp_cmd.addr_high =
> +					cpu_to_le32(upper_32_bits(phys_addr));
> +				ssp_cmd.esgl = cpu_to_le32(1<<31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			ssp_cmd.addr_low = 0;
>  			ssp_cmd.addr_high = 0;
> @@ -3744,11 +3858,9 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
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
> @@ -3760,18 +3872,19 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
>  	u32 tag = ccb->ccb_tag;
>  	int ret;
> -	static u32 inb;
> -	static u32 outb;
> +	u32 q_index;
>  	struct sata_start_req sata_cmd;
>  	u32 hdr_tag, ncg_tag = 0;
> -	u64 phys_addr;
> +	u64 phys_addr, start_addr, end_addr;
> +	u32 end_addr_high, end_addr_low;
>  	u32 ATAP = 0x0;
>  	u32 dir;
>  	struct inbound_queue_table *circularQ;
>  	unsigned long flags;
>  	u32 opc = OPC_INB_SATA_HOST_OPSTART;
>  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> -	circularQ = &pm8001_ha->inbnd_q_tbl[0];
> +	q_index = (u32) (pm8001_ha_dev->id & 0x00ffffff) % PM8001_MAX_INB_NUM;
> +	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>  
>  	if (task->data_dir == PCI_DMA_NONE) {
>  		ATAP = 0x04; /* no data*/
> @@ -3832,6 +3945,31 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  			sata_cmd.enc_addr_high = upper_32_bits(dma_addr);
>  			sata_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
>  			sata_cmd.enc_esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + sata_cmd.enc_len) - 1;
> +			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != sata_cmd.enc_addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list address "
> +					"start_addr=0x%016llx data_len=0x%x "
> +					"end_addr_high=0x%08x end_addr_low"
> +					"=0x%08x has crossed 4G boundary\n",
> +						start_addr, sata_cmd.enc_len,
> +						end_addr_high, end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +						offsetof(struct pm8001_ccb_info,
> +						buf_prd[0]);
> +				sata_cmd.enc_addr_low =
> +					lower_32_bits(phys_addr);
> +				sata_cmd.enc_addr_high =
> +					upper_32_bits(phys_addr);
> +				sata_cmd.enc_esgl =
> +					cpu_to_le32(1 << 31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			sata_cmd.enc_addr_low = 0;
>  			sata_cmd.enc_addr_high = 0;
> @@ -3852,7 +3990,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	} else {
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
>  			"Sending Normal SATA command 0x%x inb %x\n",
> -			sata_cmd.sata_fis.command, inb));
> +			sata_cmd.sata_fis.command, q_index));
>  		/* dad (bit 0-1) is 0 */
>  		sata_cmd.ncqtag_atap_dir_m_dad =
>  			cpu_to_le32(((ncg_tag & 0xff)<<16) |
> @@ -3873,6 +4011,30 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  			sata_cmd.addr_high = upper_32_bits(dma_addr);
>  			sata_cmd.len = cpu_to_le32(task->total_xfer_len);
>  			sata_cmd.esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + sata_cmd.len) - 1;
> +			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != sata_cmd.addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list address "
> +					"start_addr=0x%016llx data_len=0x%x"
> +					"end_addr_high=0x%08x end_addr_low="
> +					"0x%08x has crossed 4G boundary\n",
> +						start_addr, sata_cmd.len,
> +						end_addr_high, end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +					offsetof(struct pm8001_ccb_info,
> +					buf_prd[0]);
> +				sata_cmd.addr_low =
> +					lower_32_bits(phys_addr);
> +				sata_cmd.addr_high =
> +					upper_32_bits(phys_addr);
> +				sata_cmd.esgl = cpu_to_le32(1 << 31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			sata_cmd.addr_low = 0;
>  			sata_cmd.addr_high = 0;
> @@ -3949,12 +4111,9 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
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

