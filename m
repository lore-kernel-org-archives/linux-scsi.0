From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Subject: RE: [PATCH] scsi: ufs: fix Command Type issue according to UFS 2.0
 spec
Date: Wed, 13 Aug 2014 15:11:44 +0000
Message-ID: <17296D9F8FF2234F831FC3DF505A87A911B2046D@shsmsx102.ccr.corp.intel.com>
References: <20140801080058.GA13757@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaHMPNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Aug 2014 11:13:00 -0400
In-Reply-To: <20140801080058.GA13757@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "santoshsy@gmail.com" <santoshsy@gmail.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

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
> Subject: [PATCH] scsi: ufs: fix Command Type issue according to UFS 2.0 spec
> 
> UFS 2.0 spec defines that the command type in transfer descriptor is always
> 0x1 instead of different values as shown in UFSHC1.0/1.1.
> 
> This patch will distingwish v1.0/v1.1 UFSHC and later UFSHC when setting CT
> 
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> ba27215..8635d5d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -706,16 +706,19 @@ static void ufshcd_disable_intr(struct ufs_hba *hba,
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
>  		data_direction = UTP_DEVICE_TO_HOST;
> @@ -728,8 +731,20 @@ static void ufshcd_prepare_req_desc_hdr(struct
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
> @@ -834,7 +849,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  	switch (lrbp->command_type) {
>  	case UTP_CMD_TYPE_SCSI:
>  		if (likely(lrbp->cmd)) {
> -			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> +			ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags,
>  					lrbp->cmd->sc_data_direction);
>  			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
>  		} else {
> @@ -842,7 +857,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  		}
>  		break;
>  	case UTP_CMD_TYPE_DEV_MANAGE:
> -		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
> +		ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE);
>  		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
>  			ufshcd_prepare_utp_query_req_upiu(
>  					hba, lrbp, upiu_flags);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
