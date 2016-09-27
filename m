From: subhashj@codeaurora.org
Subject: Re: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
Date: Tue, 27 Sep 2016 15:30:22 -0700
Message-ID: <9e470819d1cfcead5966e37c00f53967@codeaurora.org>
References: <20160825093919.5936-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47795 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752934AbcI0WaY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 18:30:24 -0400
In-Reply-To: <20160825093919.5936-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

On 2016-08-25 02:39, Zang Leigang wrote:
> Some device may cause a compatibility issue while receiving a Query 
> UPIU
> with Data Segment which does not expected.
> 
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f08d41a..9b21d88 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1266,9 +1266,12 @@ static void
> ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
>  	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
>  			0, query->request.query_func, 0, 0);
> 
> -	/* Data segment length */
> -	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
> -			0, 0, len >> 8, (u8)len);
> +	/* Data segment length only need for WRITE_DESC */
> +	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
> +		ucd_req_ptr->header.dword_2 =
> +			UPIU_HEADER_DWORD(0, 0, (len >> 8), (u8)len);
> +	else
> +		ucd_req_ptr->header.dword_2 = 0;
> 
>  	/* Copy the Query Request buffer as is */
>  	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
