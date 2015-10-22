From: subhashj@codeaurora.org
Subject: Re: [PATCH v3 03/15] scsi: ufs: verify command tag validity
Date: Thu, 22 Oct 2015 07:17:13 -0000
Message-ID: <6e280d863d13c3f28fa806d8a9a294df.squirrel@codeaurora.org>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
    <1441188795-4600-4-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1441188795-4600-4-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


> A race condition appear to exist between request completion when
> scsi_done() is called to end the request and set the tag back to
> -1 (at blk_queue_end_tag() scsi_end_request), and scsi layer error
> handling which aborts the command and reuses it to request sense
> data. Sending the request sense is done with tag which was set to -1
> and so it is invalid.
> Assert command tag passed from scsi layer is valid.
>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2d3ebca..8860a57 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -190,6 +190,10 @@ static int ufshcd_config_pwr_mode(struct ufs_hba
> *hba,
>  		struct ufs_pa_layer_attr *desired_pwr_mode);
>  static int ufshcd_change_power_mode(struct ufs_hba *hba,
>  			     struct ufs_pa_layer_attr *pwr_mode);
> +static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
> +{
> +	return tag >= 0 && tag < hba->nutrs;
> +}
>
>  static inline int ufshcd_enable_irq(struct ufs_hba *hba)
>  {
> @@ -1310,6 +1314,12 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  	hba = shost_priv(host);
>
>  	tag = cmd->request->tag;
> +	if (!ufshcd_valid_tag(hba, tag)) {
> +		dev_err(hba->dev,
> +			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
> +			__func__, tag, cmd, cmd->request);
> +		BUG();
> +	}
>
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	switch (hba->ufshcd_state) {
> @@ -3862,13 +3872,23 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	host = cmd->device->host;
>  	hba = shost_priv(host);
>  	tag = cmd->request->tag;
> +	if (!ufshcd_valid_tag(hba, tag)) {
> +		dev_err(hba->dev,
> +			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
> +			__func__, tag, cmd, cmd->request);
> +		BUG();
> +	}
>
>  	ufshcd_hold(hba, false);
> +	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  	/* If command is already aborted/completed, return SUCCESS */
> -	if (!(test_bit(tag, &hba->outstanding_reqs)))
> +	if (!(test_bit(tag, &hba->outstanding_reqs))) {
> +		dev_err(hba->dev,
> +			"%s: cmd at tag %d already completed, outstanding=0x%lx,
> doorbell=0x%x\n",
> +			__func__, tag, hba->outstanding_reqs, reg);
>  		goto out;
> +	}
>
> -	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  	if (!(reg & (1 << tag))) {
>  		dev_err(hba->dev,
>  		"%s: cmd was completed, but without a notifying intr, tag = %d",
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
