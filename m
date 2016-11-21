From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3] ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Date: Mon, 21 Nov 2016 10:35:35 -0800
Message-ID: <4a2a1aaa670806755475d23be7239b1a@codeaurora.org>
References: <000401d24236$cb8fc5b0$62af5110$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44368 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752810AbcKUSfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 13:35:37 -0500
In-Reply-To: <000401d24236$cb8fc5b0$62af5110$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-18 23:30, Kiwoong Kim wrote:
> Some UFS host controllers may think
> granularities of PRDT length and offset as bytes, not double words.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
> V2: change the name of the quirk
> (UFSHCD_QUIRK_BROKEN_DWORD_UTRD -> UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> V3: (rebased to 4.10/scsi-queue tip)
> ---
>  drivers/scsi/ufs/ufshcd.c | 28 +++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.h |  6 ++++++
>  2 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e75fbb3..d6e3112 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1128,7 +1128,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct
> uic_command *uic_cmd)
>   *
>   * Returns 0 in case of success, non-zero value in case of failure
>   */
> -static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
> +static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  {
>  	struct ufshcd_sg_entry *prd_table;
>  	struct scatterlist *sg;
> @@ -1142,8 +1142,13 @@ static int ufshcd_map_sg(struct ufshcd_lrb 
> *lrbp)
>  		return sg_segments;
> 
>  	if (sg_segments) {
> -		lrbp->utr_descriptor_ptr->prd_table_length =
> -					cpu_to_le16((u16) (sg_segments));
> +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> +			lrbp->utr_descriptor_ptr->prd_table_length =
> +				cpu_to_le16((u16)(sg_segments *
> +					sizeof(struct ufshcd_sg_entry)));
> +		else
> +			lrbp->utr_descriptor_ptr->prd_table_length =
> +				cpu_to_le16((u16) (sg_segments));
> 
>  		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
> 
> @@ -1505,7 +1510,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	ufshcd_comp_scsi_upiu(hba, lrbp);
> 
> -	err = ufshcd_map_sg(lrbp);
> +	err = ufshcd_map_sg(hba, lrbp);
>  	if (err) {
>  		lrbp->cmd = NULL;
>  		clear_bit_unlock(tag, &hba->lrb_in_use);
> @@ -2366,12 +2371,21 @@ static void
> ufshcd_host_memory_configure(struct ufs_hba *hba)
>  				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
> 
>  		/* Response upiu and prdt offset should be in double words */
> -		utrdlp[i].response_upiu_offset =
> +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
> +			utrdlp[i].response_upiu_offset =
> +				cpu_to_le16(response_offset);
> +			utrdlp[i].prd_table_offset =
> +				cpu_to_le16(prdt_offset);
> +			utrdlp[i].response_upiu_length =
> +				cpu_to_le16(ALIGNED_UPIU_SIZE);
> +		} else {
> +			utrdlp[i].response_upiu_offset =
>  				cpu_to_le16((response_offset >> 2));
> -		utrdlp[i].prd_table_offset =
> +			utrdlp[i].prd_table_offset =
>  				cpu_to_le16((prdt_offset >> 2));
> -		utrdlp[i].response_upiu_length =
> +			utrdlp[i].response_upiu_length =
>  				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> +		}
> 
>  		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
>  		hba->lrb[i].ucd_req_ptr =
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 8e76501..7d9ff22 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -485,6 +485,12 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		UFS_BIT(5)
> 
> +	/*
> +	 * This quirk needs to be enabled if the host contoller regards
> +	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
> +	 */
> +	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			UFS_BIT(7)
> +
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
