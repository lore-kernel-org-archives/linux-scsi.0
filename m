From: "Lee Susman" <lsusman@codeaurora.org>
Subject: RE: [PATCH] scsi: ufs: fix Command Type issue according to UFS 2.0 spec
Date: Thu, 14 Aug 2014 16:57:24 +0300
Message-ID: <000301cfb7c7$aed05ee0$0c711ca0$@codeaurora.org>
References: <20140801080058.GA13757@intel.com> <17296D9F8FF2234F831FC3DF505A87A911B2046D@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36347 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaHNN52 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2014 09:57:28 -0400
In-Reply-To: <17296D9F8FF2234F831FC3DF505A87A911B2046D@shsmsx102.ccr.corp.intel.com>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Dong, Chuanxiao'" <chuanxiao.dong@intel.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, santoshsy@gmail.com, vinholikatti@gmail.com

Hi Chuanxiao,

I have pulled and ran multiple dd runs on a build with your patch (to an
external UFS device). 
Did not see any issues with this patch, adding my reviewed-by and tested-by.

Reviewed-off-by: Lee Susman <lsusman@codeaurora.org>
Tested-off-by: Lee Susman <lsusman@codeaurora.org>

Thanks,
Lee

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dong, Chuanxiao
Sent: Wednesday, August 13, 2014 6:12 PM
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com; santoshsy@gmail.com; vinholikatti@gmail.com
Subject: RE: [PATCH] scsi: ufs: fix Command Type issue according to UFS 2.0
spec

Any comment to this patch?

Thanks
Chuanxiao

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Chuanxiao Dong
> Sent: Friday, August 01, 2014 4:01 PM
> To: linux-scsi@vger.kernel.org
> Cc: JBottomley@Parallels.com; santoshsy@gmail.com; 
> vinholikatti@gmail.com
> Subject: [PATCH] scsi: ufs: fix Command Type issue according to UFS 
> 2.0 spec
> 
> UFS 2.0 spec defines that the command type in transfer descriptor is 
> always
> 0x1 instead of different values as shown in UFSHC1.0/1.1.
> 
> This patch will distingwish v1.0/v1.1 UFSHC and later UFSHC when 
> setting CT
> 
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
> index ba27215..8635d5d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -706,16 +706,19 @@ static void ufshcd_disable_intr(struct ufs_hba 
> *hba,
> u32 intrs)
>  /**
>   * ufshcd_prepare_req_desc_hdr() - Fills the requests header
>   * descriptor according to request
> + * @hba: per adapter instance
>   * @lrbp: pointer to local reference block
>   * @upiu_flags: flags required in the header
>   * @cmd_dir: requests data direction
>   */
> -static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
> -		u32 *upiu_flags, enum dma_data_direction cmd_dir)
> +static void ufshcd_prepare_req_desc_hdr(struct ufs_hba *hba,
> +		struct ufshcd_lrb *lrbp, u32 *upiu_flags,
> +		enum dma_data_direction cmd_dir)
>  {
>  	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
>  	u32 data_direction;
>  	u32 dword_0;
> +	u8 cmd_type;
> 
>  	if (cmd_dir == DMA_FROM_DEVICE) {
>  		data_direction = UTP_DEVICE_TO_HOST; @@ -728,8 +731,20 @@
static 
> void ufshcd_prepare_req_desc_hdr(struct
> ufshcd_lrb *lrbp,
>  		*upiu_flags = UPIU_CMD_FLAGS_NONE;
>  	}
> 
> -	dword_0 = data_direction | (lrbp->command_type
> -				<< UPIU_COMMAND_TYPE_OFFSET);
> +	/*
> +	 * Per UFSHCI spec v1.0/v1.1, Command Type in UTP transfer
> +	 * request descriptor is not the same as v2.0 spec.
> +	 * In v2.0 spec, Command Type is always 1, the other values
> +	 * are reserved
> +	 */
> +	if (hba->ufs_version == UFSHCI_VERSION_10 ||
> +			hba->ufs_version == UFSHCI_VERSION_11)
> +		cmd_type = lrbp->command_type;
> +	else
> +		cmd_type = UTP_CMD_TYPE_UFS;
> +
> +	dword_0 = data_direction | (cmd_type <<
> UPIU_COMMAND_TYPE_OFFSET);
> +
>  	if (lrbp->intr_cmd)
>  		dword_0 |= UTP_REQ_DESC_INT_CMD;
> 
> @@ -834,7 +849,7 @@ static int ufshcd_compose_upiu(struct ufs_hba 
> *hba, struct ufshcd_lrb *lrbp)
>  	switch (lrbp->command_type) {
>  	case UTP_CMD_TYPE_SCSI:
>  		if (likely(lrbp->cmd)) {
> -			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> +			ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags,
>  					lrbp->cmd->sc_data_direction);
>  			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
>  		} else {
> @@ -842,7 +857,7 @@ static int ufshcd_compose_upiu(struct ufs_hba 
> *hba, struct ufshcd_lrb *lrbp)
>  		}
>  		break;
>  	case UTP_CMD_TYPE_DEV_MANAGE:
> -		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
> +		ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags,
DMA_NONE);
>  		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
>  			ufshcd_prepare_utp_query_req_upiu(
>  					hba, lrbp, upiu_flags);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

