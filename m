From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1 1/8] ufs: add some vendor specific operations
Date: Thu, 06 Oct 2016 12:24:00 -0700
Message-ID: <374157914ed3ee27db50db2a9b6d7c10@codeaurora.org>
References: <006401d21faa$210df570$6329e050$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38541 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934184AbcJFTYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 15:24:02 -0400
In-Reply-To: <006401d21faa$210df570$6329e050$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

Hi Kim,


On 2016-10-06 01:17, Kiwoong Kim wrote:
> Some UFS host controller may need to require some sequences
> before used clocks are turned on or off.
> e.g) control internal gates in UFS host


I believe we are doing couple of other things as well other than clock 
control in this patch, such as hibern8 notify, *nexus_t* notify. You 
might want to separate each in different patches. Also, please find more 
additional below.

> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   15 +++++++++++++--
>  drivers/scsi/ufs/ufshcd.h |   37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 05c7456..82c9a40 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1474,6 +1474,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	/* issue command to the controller */
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_vops_set_nexus_t_xfer_req(hba, tag, lrbp->cmd);
>  	ufshcd_send_command(hba, tag);
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -1683,6 +1684,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
>  	/* Make sure descriptors are ready before ringing the doorbell */
>  	wmb();
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_vops_set_nexus_t_xfer_req(hba, tag, lrbp->cmd);

what does "next_t_xfer_req" means? why do we need this? and do you think 
it may be useful/needed for non-exynos UFS host controllers as well?



>  	ufshcd_send_command(hba, tag);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> @@ -2651,6 +2653,8 @@ static int __ufshcd_uic_hibern8_enter(struct 
> ufs_hba *hba)
>  	int ret;
>  	struct uic_command uic_cmd = {0};
> 
> +	ufshcd_vops_hibern8_notify(hba, true, PRE_CHANGE);
> +
>  	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> 
> @@ -2664,7 +2668,8 @@ static int __ufshcd_uic_hibern8_enter(struct 
> ufs_hba *hba)
>  		 */
>  		if (ufshcd_link_recovery(hba))
>  			ret = -ENOLINK;
> -	}
> +	} else
> +		ufshcd_vops_hibern8_notify(hba, true, POST_CHANGE);
> 
>  	return ret;
>  }
> @@ -2687,13 +2692,16 @@ static int ufshcd_uic_hibern8_exit(struct 
> ufs_hba *hba)
>  	struct uic_command uic_cmd = {0};
>  	int ret;
> 
> +	ufshcd_vops_hibern8_notify(hba, false, PRE_CHANGE);
> +
>  	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	if (ret) {
>  		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
>  			__func__, ret);
>  		ret = ufshcd_link_recovery(hba);
> -	}
> +	} else
> +		ufshcd_vops_hibern8_notify(hba, false, POST_CHANGE);
> 
>  	return ret;
>  }
> @@ -4312,6 +4320,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
> *hba, int lun_id, int task_id,
>  	task_req_upiup->input_param2 = cpu_to_be32(task_id);
> 
>  	/* send command to the controller */
> +	ufshcd_vops_set_nexus_t_task_mgmt(hba, free_slot, tm_function);


Same question as "next_t_xfer_req". what does "next_t_task_mgmt" means? 
why do we need this? and do you think it may be useful/needed for 
non-exynos UFS host controllers as well?


>  	__set_bit(free_slot, &hba->outstanding_tasks);
> 
>  	/* Make sure descriptors are ready before ringing the task doorbell 
> */
> @@ -5389,6 +5398,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  	if (!head || list_empty(head))
>  		goto out;
> 
> +	ufshcd_vops_pre_setup_clocks(hba, on);
> +

I don't think we need a different op for this, we can simply use the 
existing op and add one more argument to it to indicate 
PRE_CHANGE/POST_CHANGE. If you agree with my response to "[PATCH v2] 
scsi: ufshcd: fix possible unclocked register access" patch, i can 
update send out v3 of my patch and then you can rebase your patch series 
on top of my patch.


>  	list_for_each_entry(clki, head, list) {
>  		if (!IS_ERR_OR_NULL(clki->clk)) {
>  			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 430bef1..b97f7c2 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -252,6 +252,7 @@ struct ufs_pwr_mode_info {
>   * @exit: called to cleanup everything done in init
>   * @get_ufs_hci_version: called to get UFS HCI version
>   * @clk_scale_notify: notifies that clks are scaled up/down
> + * @pre_setup_clocks: called before controlling used clocks
>   * @setup_clocks: called before touching any of the controller 
> registers
>   * @setup_regulators: called before accessing the host controller
>   * @hce_enable_notify: called before and after HCE enable bit is set 
> to allow
> @@ -261,6 +262,9 @@ struct ufs_pwr_mode_info {
>   * @pwr_change_notify: called before and after a power mode change
>   *			is carried out to allow vendor spesific capabilities
>   *			to be set.
> + * @set_nexus_t_xfer_req:
> + * @set_nexus_t_task_mgmt:
> + * @hibern8_notify:
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
> @@ -273,6 +277,7 @@ struct ufs_hba_variant_ops {
>  	u32	(*get_ufs_hci_version)(struct ufs_hba *);
>  	int	(*clk_scale_notify)(struct ufs_hba *, bool,
>  				    enum ufs_notify_change_status);
> +	int	(*pre_setup_clocks)(struct ufs_hba *, bool);
>  	int	(*setup_clocks)(struct ufs_hba *, bool);
>  	int     (*setup_regulators)(struct ufs_hba *, bool);
>  	int	(*hce_enable_notify)(struct ufs_hba *,
> @@ -283,6 +288,10 @@ struct ufs_hba_variant_ops {
>  					enum ufs_notify_change_status status,
>  					struct ufs_pa_layer_attr *,
>  					struct ufs_pa_layer_attr *);
> +	void	(*set_nexus_t_xfer_req)(struct ufs_hba *,
> +					int, struct scsi_cmnd *);
> +	void	(*set_nexus_t_task_mgmt)(struct ufs_hba *, int, u8);
> +	void    (*hibern8_notify)(struct ufs_hba *, u8, bool);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -755,6 +764,13 @@ static inline int
> ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
>  	return 0;
>  }
> 
> +static inline int ufshcd_vops_pre_setup_clocks(struct ufs_hba *hba, 
> bool on)
> +{
> +	if (hba->vops && hba->vops->pre_setup_clocks)
> +		return hba->vops->pre_setup_clocks(hba, on);
> +	return 0;
> +}
> +
>  static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool 
> on)
>  {
>  	if (hba->vops && hba->vops->setup_clocks)
> @@ -799,6 +815,27 @@ static inline int
> ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
>  	return -ENOTSUPP;
>  }
> 
> +static inline void ufshcd_vops_set_nexus_t_xfer_req(struct ufs_hba 
> *hba,
> +					int tag, struct scsi_cmnd *cmd)
> +{
> +	if (hba->vops && hba->vops->set_nexus_t_xfer_req)
> +		return hba->vops->set_nexus_t_xfer_req(hba, tag, cmd);
> +}
> +
> +static inline void ufshcd_vops_set_nexus_t_task_mgmt(struct ufs_hba 
> *hba,
> +					int tag, u8 tm_function)
> +{
> +	if (hba->vops && hba->vops->set_nexus_t_task_mgmt)
> +		return hba->vops->set_nexus_t_task_mgmt(hba, tag, tm_function);
> +}
> +
> +static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
> +					u8 enter, bool notify)
> +{
> +	if (hba->vops && hba->vops->hibern8_notify)
> +		return hba->vops->hibern8_notify(hba, enter, notify);
> +}
> +
>  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum 
> ufs_pm_op op)
>  {
>  	if (hba->vops && hba->vops->suspend)

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
