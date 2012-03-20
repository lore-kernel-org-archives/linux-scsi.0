From: "Jack Wang" <jack_wang@usish.com>
Subject: Re [PATCH v3] [SCSI] pm8001: fix endian issue with code optimization.
Date: Tue, 20 Mar 2012 14:41:29 +0800
Message-ID: <857EB40E526B4CC2A2D9140110216FE2@usish.com.cn>
References: <1332172587-11805-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:41283 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2CTGls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 02:41:48 -0400
In-Reply-To: <1332172587-11805-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'santosh nayak' <santoshprasadnayak@gmail.com>, mark_salyzyn@xyratex.com
Cc: lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, dan.carpenter@oracle.com

Acked-by: Jack Wang <jack_wang@usish.com>

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Data type of the 'tag' field of 'fw_flash_Update_resp' should be
> __le32.
> 
> Data type of  'pHeader' should be __le32.
> Remove 2nd cast to 'piomb'.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |    6 +++---
>  drivers/scsi/pm8001/pm8001_hwi.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index 3619f6e..6d83236 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3355,7 +3355,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info
> *pm8001_ha, void *piomb)
>  	struct fw_control_ex	fw_control_context;
>  	struct fw_flash_Update_resp *ppayload =
>  		(struct fw_flash_Update_resp *)(piomb + 4);
> -	u32 tag = ppayload->tag;
> +	u32 tag = le32_to_cpu(ppayload->tag);
>  	struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
>  	status = le32_to_cpu(ppayload->status);
>  	memcpy(&fw_control_context,
> @@ -3701,8 +3701,8 @@ static int mpi_hw_event(struct pm8001_hba_info
> *pm8001_ha, void* piomb)
>   */
>  static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void
*piomb)
>  {
> -	u32 pHeader = (u32)*(u32 *)piomb;
> -	u8 opc = (u8)(pHeader & 0xFFF);
> +	__le32 pHeader = *(__le32 *)piomb;
> +	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
> 
>  	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h
> b/drivers/scsi/pm8001/pm8001_hwi.h
> index 1a4611e..d437309 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -599,7 +599,7 @@ struct fw_flash_Update_req {
>   *
>   */
>  struct fw_flash_Update_resp {
> -	dma_addr_t	tag;
> +	__le32	tag;
>  	__le32	status;
>  	u32	reserved[13];
>  } __attribute__((packed, aligned(4)));
> --
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

