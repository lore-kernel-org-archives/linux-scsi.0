From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1] ufs: introduce setup_task_mgmt
Date: Tue, 08 Nov 2016 11:02:34 -0800
Message-ID: <55ad85fe5a296cfd8d7bf2c7bc8df660@codeaurora.org>
References: <001e01d23994$4eca9cd0$ec5fd670$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37208 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932125AbcKHTCf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 14:02:35 -0500
In-Reply-To: <001e01d23994$4eca9cd0$ec5fd670$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-07 23:47, Kiwoong Kim wrote:
> Some UFS host controller may need to configure some things
> before any task management request is issued
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |  1 +
>  drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bf78321..fdb0502 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4358,6 +4358,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
> *hba, int lun_id, int task_id,
>  	task_req_upiup->input_param2 = cpu_to_be32(task_id);
> 
>  	/* send command to the controller */

May be you need to move this comment just above __set_bit() call. Rest 
all looks good in this patch.

> +	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
>  	__set_bit(free_slot, &hba->outstanding_tasks);
> 
>  	/* Make sure descriptors are ready before ringing the task doorbell 
> */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index f2a69c0..b084d89 100644
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
>  		return hba->vops->setup_xfer_req(hba, tag, is_cmd_not_null);
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

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
