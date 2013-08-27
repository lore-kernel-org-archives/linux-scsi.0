From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3 1/6] scsi: ufs: find out sense data over scsi status
 values
Date: Tue, 27 Aug 2013 14:23:09 +0530
Message-ID: <521C68F5.6060607@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com> <003601cea26a$31334600$9399d200$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:47311 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3H0IxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2013 04:53:15 -0400
In-Reply-To: <003601cea26a$31334600$9399d200$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>


Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

On 8/26/2013 8:10 PM, Seungwon Jeon wrote:
> Unlike 'GOOD' and 'CHECK CONDITION', other status values in
> Response UPIU may or may not contain sense data. That is returning
> sense data isn't obvious. So, in this case the Data Segment Length
> field should be checked. If a non-zero value, it means that UPIU
> has Sense Data in the Data Segment area.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
>   drivers/scsi/ufs/ufs.h    |    1 +
>   drivers/scsi/ufs/ufshcd.c |   37 ++++++++++++++++++++++---------------
>   2 files changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index bce09a6..7210500 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -177,6 +177,7 @@ enum {
>   	MASK_TASK_RESPONSE              = 0xFF00,
>   	MASK_RSP_UPIU_RESULT            = 0xFFFF,
>   	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
> +	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
>   	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
>   };
>   
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1b99c0a..6ff16c9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -310,6 +310,20 @@ ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
>   	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
>   }
>   
> +/*
> + * ufshcd_get_rsp_upiu_data_seg_len - Get the data segment length
> + *				from response UPIU
> + * @ucd_rsp_ptr: pointer to response UPIU
> + *
> + * Return the data segment length.
> + */
> +static inline unsigned int
> +ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
> +{
> +	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
> +		MASK_RSP_UPIU_DATA_SEG_LEN;
> +}
> +
>   /**
>    * ufshcd_is_exception_event - Check if the device raised an exception event
>    * @ucd_rsp_ptr: pointer to response UPIU
> @@ -405,7 +419,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>   static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
>   {
>   	int len;
> -	if (lrbp->sense_buffer) {
> +	if (lrbp->sense_buffer &&
> +	    ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
>   		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
>   		memcpy(lrbp->sense_buffer,
>   			lrbp->ucd_rsp_ptr->sr.sense_data,
> @@ -1789,32 +1804,24 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
>   	int result = 0;
>   
>   	switch (scsi_status) {
> -	case SAM_STAT_GOOD:
> -		result |= DID_OK << 16 |
> -			  COMMAND_COMPLETE << 8 |
> -			  SAM_STAT_GOOD;
> -		break;
>   	case SAM_STAT_CHECK_CONDITION:
> +		ufshcd_copy_sense_data(lrbp);
> +	case SAM_STAT_GOOD:
>   		result |= DID_OK << 16 |
>   			  COMMAND_COMPLETE << 8 |
> -			  SAM_STAT_CHECK_CONDITION;
> -		ufshcd_copy_sense_data(lrbp);
> -		break;
> -	case SAM_STAT_BUSY:
> -		result |= SAM_STAT_BUSY;
> +			  scsi_status;
>   		break;
>   	case SAM_STAT_TASK_SET_FULL:
> -
>   		/*
>   		 * If a LUN reports SAM_STAT_TASK_SET_FULL, then the LUN queue
>   		 * depth needs to be adjusted to the exact number of
>   		 * outstanding commands the LUN can handle at any given time.
>   		 */
>   		ufshcd_adjust_lun_qdepth(lrbp->cmd);
> -		result |= SAM_STAT_TASK_SET_FULL;
> -		break;
> +	case SAM_STAT_BUSY:
>   	case SAM_STAT_TASK_ABORTED:
> -		result |= SAM_STAT_TASK_ABORTED;
> +		ufshcd_copy_sense_data(lrbp);
> +		result |= scsi_status;
>   		break;
>   	default:
>   		result |= DID_ERROR << 16;

