From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: remove unnecessary UFSHCD_STATE_ERROR set
Date: Tue, 15 Nov 2016 11:00:12 -0800
Message-ID: <fb242d9166cda04eaebf53d776915f60@codeaurora.org>
References: <20161115122533.75266-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbcKOTAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 14:00:13 -0500
In-Reply-To: <20161115122533.75266-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-11-15 04:25, Zang Leigang wrote:
> We set ufshcd_state to UFSHCD_STATE_ERROR when an err handler
> fails. So I think UFSHCD_STATE_ERROR means host not works any more.
> Set it before schedule eh_work is not correct.
> 
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 05c7456..a7724ad 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4158,7 +4158,6 @@ static void ufshcd_check_errors(struct ufs_hba 
> *hba)
>  			/* block commands from scsi mid-layer */
>  			scsi_block_requests(hba->host);
> 
> -			hba->ufshcd_state = UFSHCD_STATE_ERROR;

But we may still want to stop the new requests from being issued (via 
ufshcd_queuecommand) until error handler (ufshcd_err_handler()) gets 
chance to run. May be a new intermediate state like 
UFSHCD_STATE_EH_SCHEDULED should be added and set here, we have to check 
the same in ufshcd_queuecommand() to return busy if ufshcd_state is 
UFSHCD_STATE_EH_SCHEDULED.

>  			schedule_work(&hba->eh_work);
>  		}
>  	}

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
