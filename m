From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: flush eh_work when eh_work scheduled.
Date: Wed, 28 Jun 2017 16:45:01 -0700
Message-ID: <039432f8963a0b8a46655b246ede6098@codeaurora.org>
References: <20170624111432.11852-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdF1XpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 19:45:02 -0400
In-Reply-To: <20170624111432.11852-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-06-24 04:14, Zang Leigang wrote:
> Forget a condition: eh_work scheduled but do not start to work.
> 
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e050dcea1bea..a2dff12713fc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5807,7 +5807,8 @@ static int ufshcd_eh_host_reset_handler(struct
> scsi_cmnd *cmd)
>  	do {
>  		spin_lock_irqsave(hba->host->host_lock, flags);
>  		if (!(work_pending(&hba->eh_work) ||
> -				hba->ufshcd_state == UFSHCD_STATE_RESET))
> +			    hba->ufshcd_state == UFSHCD_STATE_RESET ||
> +			    hba->ufshcd_state == UFSHCD_STATE_EH_SCHEDULED))
>  			break;
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
