From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2] ufs: introduce setup_task_mgmt
Date: Thu, 10 Nov 2016 10:15:05 -0800
Message-ID: <a368b99cc68ae4a6e8c935e9713bf5f6@codeaurora.org>
References: <002301d23b4c$3ba55550$b2effff0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbcKJSPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 13:15:06 -0500
In-Reply-To: <002301d23b4c$3ba55550$b2effff0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-10 04:16, Kiwoong Kim wrote:
> Some UFS host controller may need to configure some things
> before any task management request is issued
> 
> v2: move a comment to another place
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |  2 ++
>  drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bf78321..301b592 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4357,6 +4357,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
> *hba, int lun_id, int task_id,
>  	task_req_upiup->input_param1 = cpu_to_be32(lun_id);
>  	task_req_upiup->input_param2 = cpu_to_be32(task_id);
> 
> +	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
> +
>  	/* send command to the controller */
>  	__set_bit(free_slot, &hba->outstanding_tasks);
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e935fd1..05d8384 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -263,6 +263,8 @@ struct ufs_pwr_mode_info {
>   *			to be set.
>   * @setup_xfer_req: called before any transfer request is issued
>   *                  to set some things
> + * @setup_task_mgmt: called before any task management request is 
> issued
> + *                  to set some things
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
> @@ -287,6 +289,7 @@ struct ufs_hba_variant_ops {
>  					struct ufs_pa_layer_attr *,
>  					struct ufs_pa_layer_attr *);
>  	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
> +	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -811,6 +814,13 @@ static inline void
> ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
>  		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
>  }
> 
> +static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
> +					int tag, u8 tm_function)
> +{
> +	if (hba->vops && hba->vops->setup_task_mgmt)
> +		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
> +}
> +
>  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum 
> ufs_pm_op op)
>  {
>  	if (hba->vops && hba->vops->suspend)


LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
