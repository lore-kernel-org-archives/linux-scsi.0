From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 2/5] pm80xx: IButton feature support and Indirect SMP
 fix.
Date: Mon, 16 Sep 2013 18:04:32 +0200
Message-ID: <52372C10.3000304@gmail.com>
References: <5237298E.5050701@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56763 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3IPQDc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2013 12:03:32 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so1602028bkb.38
        for <linux-scsi@vger.kernel.org>; Mon, 16 Sep 2013 09:03:30 -0700 (PDT)
In-Reply-To: <5237298E.5050701@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Viswas.G@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

On 09/16/2013 05:53 PM, Anand wrote:
> From db345f70bef0b07655d887f2d0398faf666f4a48 Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Tue, 3 Sep 2013 15:21:29 +0530
> Subject: [PATCH 2/5] pm80xx: IButton feature support and Indirect SMP fix.
> 
> IButton security feature support for motherboard controllers.
> Fix for indirect data transfer mode in case of SMP request.
> 
You'd better split this into two patches for bisect-able.

Jack

> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> 
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index be0b394..158e91d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -967,6 +967,7 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>  {
>  	u32 regval;
>  	u32 bootloader_state;
> +	u32 ibutton0, ibutton1;
>  
>  	/* Check if MPI is in ready state to reset */
>  	if (mpi_uninit_check(pm8001_ha) != 0) {
> @@ -1025,7 +1026,26 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>  	if (-1 == check_fw_ready(pm8001_ha)) {
>  		PM8001_FAIL_DBG(pm8001_ha,
>  			pm8001_printk("Firmware is not ready!\n"));
> -		return -EBUSY;
> +		/* check iButton feature support for motherboard controller */
> +		if (pm8001_ha->pdev->subsystem_vendor !=
> +			PCI_VENDOR_ID_ADAPTEC2) {
> +			ibutton0 = pm8001_cr32(pm8001_ha, 0,
> +					MSGU_HOST_SCRATCH_PAD_6);
> +			ibutton1 = pm8001_cr32(pm8001_ha, 0,
> +					MSGU_HOST_SCRATCH_PAD_7);
> +			if (!ibutton0 && !ibutton1) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("iButton Feature is"
> +					" not Available!!!\n"));
> +				return -EBUSY;
> +			}
> +			if (ibutton0 == 0xdeadbeef && ibutton1 == 0xdeadbeef) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("CRC Check for iButton"
> +					" Feature Failed!!!\n"));
> +				return -EBUSY;
> +			}
> +		}
>  	}
>  	PM8001_INIT_DBG(pm8001_ha,
>  		pm8001_printk("SPCv soft reset Complete\n"));
> @@ -3492,8 +3512,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
>  	else
>  		pm8001_ha->smp_exp_mode = SMP_INDIRECT;
>  
> -	/* DIRECT MODE support only in spcv/ve */
> -	pm8001_ha->smp_exp_mode = SMP_DIRECT;
>  
>  	tmp_addr = cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));
>  	preq_dma_addr = (char *)phys_to_virt(tmp_addr);
> @@ -3509,7 +3527,7 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
>  		/* exclude top 4 bytes for SMP req header */
>  		smp_cmd.long_smp_req.long_req_addr =
>  			cpu_to_le64((u64)sg_dma_address
> -				(&task->smp_task.smp_req) - 4);
> +				(&task->smp_task.smp_req) + 4);
>  		/* exclude 4 bytes for SMP req header and CRC */
>  		smp_cmd.long_smp_req.long_req_size =
>  			cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_req)-8);
> 

