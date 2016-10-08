From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 01/10] ufs: introduce setup_xfer_req callback
Date: Sat, 08 Oct 2016 09:41:27 -0700
Message-ID: <3621c6238f4d98c3a6ef51db7f2cf212@codeaurora.org>
References: <000201d22113$04f4e820$0edeb860$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37506 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753623AbcJHQl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2016 12:41:29 -0400
In-Reply-To: <000201d22113$04f4e820$0edeb860$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: vinholikatti@gmail.com, "'Martin K. Petersen'" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, =?UTF-8?Q?=27=EC=B6=94?= =?UTF-8?Q?=ED=97=8C=EA=B4=91=27?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-10-07 20:21, Kiwoong Kim wrote:
> Some UFS host controller may need to configure some things
> before any transfer request is issued.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    2 ++
>  drivers/scsi/ufs/ufshcd.h |   10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 05c7456..bb537db 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1474,6 +1474,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	/* issue command to the controller */
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
>  	ufshcd_send_command(hba, tag);
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -1683,6 +1684,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
>  	/* Make sure descriptors are ready before ringing the doorbell */
>  	wmb();
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
>  	ufshcd_send_command(hba, tag);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 430bef1..f37e5a4 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -261,6 +261,8 @@ struct ufs_pwr_mode_info {
>   * @pwr_change_notify: called before and after a power mode change
>   *			is carried out to allow vendor spesific capabilities
>   *			to be set.
> + * @setup_xfer_req: called before any transfer request is issued
> + *                  to set some things
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
> @@ -283,6 +285,7 @@ struct ufs_hba_variant_ops {
>  					enum ufs_notify_change_status status,
>  					struct ufs_pa_layer_attr *,
>  					struct ufs_pa_layer_attr *);
> +	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -799,6 +802,13 @@ static inline int
> ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
>  	return -ENOTSUPP;
>  }
> 
> +static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int 
> tag,
> +					bool is_cmd_not_null)

This might sound better: s/is_cmd_not_null/is_scsi_cmd  ?

> +{
> +	if (hba->vops && hba->vops->setup_xfer_req)
> +		return hba->vops->setup_xfer_req(hba, tag, is_cmd_not_null);
> +}
> +
>  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum 
> ufs_pm_op op)
>  {
>  	if (hba->vops && hba->vops->suspend)

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
