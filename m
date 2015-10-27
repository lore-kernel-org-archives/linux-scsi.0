From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v5 04/15] scsi: ufs: clear outstanding_request bit in
 case query timeout
Date: Tue, 27 Oct 2015 14:56:27 -0000
Message-ID: <6c67cb64689065532ae0daa0c2cb7b6d.squirrel@www.codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
    <1445942657-6293-5-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-5-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> When sending a query to the device returns with a timeout error,
> we clear the corresponding bit in the DOORBELL register but
> we don't clear the outstanding_request field as we should.
> This patch fixes this bug.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8860a57..e0b8755 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -364,6 +364,16 @@ static inline void ufshcd_utrl_clear(struct ufs_hba
> *hba, u32 pos)
>  }
>
>  /**
> + * ufshcd_outstanding_req_clear - Clear a bit in outstanding request
> field
> + * @hba: per adapter instance
> + * @tag: position of the bit to be cleared
> + */
> +static inline void ufshcd_outstanding_req_clear(struct ufs_hba *hba, int
> tag)
> +{
> +	__clear_bit(tag, &hba->outstanding_reqs);
> +}
> +
> +/**
>   * ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
>   * @reg: Register value of host controller status
>   *
> @@ -1502,9 +1512,17 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>
>  	if (!time_left) {
>  		err = -ETIMEDOUT;
> +		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
> +			__func__, lrbp->task_tag);
>  		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
> -			/* sucessfully cleared the command, retry if needed */
> +			/* successfully cleared the command, retry if needed */
>  			err = -EAGAIN;
> +		/*
> +		 * in case of an error, after clearing the doorbell,
> +		 * we also need to clear the outstanding_request
> +		 * field in hba
> +		 */
> +		ufshcd_outstanding_req_clear(hba, lrbp->task_tag);
>  	}
>
>  	return err;
> @@ -3942,7 +3960,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	scsi_dma_unmap(cmd);
>
>  	spin_lock_irqsave(host->host_lock, flags);
> -	__clear_bit(tag, &hba->outstanding_reqs);
> +	ufshcd_outstanding_req_clear(hba, tag);
>  	hba->lrb[tag].cmd = NULL;
>  	spin_unlock_irqrestore(host->host_lock, flags);
>
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
