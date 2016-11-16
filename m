From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: introduce a new ufshcd_statea
 UFSHCD_STATE_EH_SCHEDULED
Date: Wed, 16 Nov 2016 10:48:35 -0800
Message-ID: <a80d0b3c77a2d68c1a1d1aa82dc76139@codeaurora.org>
References: <20161116032937.117395-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbcKPSsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 13:48:36 -0500
In-Reply-To: <20161116032937.117395-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-11-15 19:29, Zang Leigang wrote:
> Add a new ufshcd_state, indicats that an err handler may get to run
> immediately. Use UFSHCD_STATE_ERROR here looks not literaly correct.
> 
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 05c7456..59d4130 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -123,6 +123,7 @@ enum {
>  	UFSHCD_STATE_RESET,
>  	UFSHCD_STATE_ERROR,
>  	UFSHCD_STATE_OPERATIONAL,
> +	UFSHCD_STATE_EH_SCHEDULED,
>  };
> 
>  /* UFSHCD error handling flags */
> @@ -1410,6 +1411,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  	switch (hba->ufshcd_state) {
>  	case UFSHCD_STATE_OPERATIONAL:
>  		break;
> +	case UFSHCD_STATE_EH_SCHEDULED:
>  	case UFSHCD_STATE_RESET:
>  		err = SCSI_MLQUEUE_HOST_BUSY;
>  		goto out_unlock;
> @@ -4158,7 +4160,7 @@ static void ufshcd_check_errors(struct ufs_hba 
> *hba)
>  			/* block commands from scsi mid-layer */
>  			scsi_block_requests(hba->host);
> 
> -			hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
>  			schedule_work(&hba->eh_work);
>  		}
>  	}


LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
