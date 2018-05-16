From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 10/10] scsi: ufs: Add clock ungating to a separate
 workqueue
Date: Wed, 16 May 2018 14:14:43 -0700
Message-ID: <9b3fe3b9f1bd2f7c36dcd840acf7848d@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <0bfae28dbfb4cf86e80435639b92c7f4023041dc.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0bfae28dbfb4cf86e80435639b92c7f4023041dc.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Vijay Viswanath <vviswana@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
> From: Vijay Viswanath <vviswana@codeaurora.org>
> 
> UFS driver can receive a request during memory reclaim by kswapd.
> So when ufs driver puts the ungate work in queue, and if there are no
> idle workers, kthreadd is invoked to create a new kworker. Since
> kswapd task holds a mutex which kthreadd also needs, this can cause
> a deadlock situation. So ungate work must be done in a separate
> work queue with WQ_MEM_RECLAIM flag enabled.
> Such a workqueue will have a rescue thread which will be called
> when the above deadlock condition is possible.
> 
> Signed-off-by: Vijay Viswanath <vviswana@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 11 ++++++++++-
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 557d538..3be61b7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1483,7 +1483,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  		hba->clk_gating.state = REQ_CLKS_ON;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
> -		schedule_work(&hba->clk_gating.ungate_work);
> +		queue_work(hba->clk_gating.clk_gating_workq,
> +			   &hba->clk_gating.ungate_work);
>  		/*
>  		 * fall through to check if we should wait for this
>  		 * work to be done or not.
> @@ -1669,6 +1670,8 @@ static ssize_t
> ufshcd_clkgate_enable_store(struct device *dev,
> 
>  static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>  {
> +	char wq_name[sizeof("ufs_clk_gating_00")];
> +
>  	if (!ufshcd_is_clkgating_allowed(hba))
>  		return;
> 
> @@ -1676,6 +1679,11 @@ static void ufshcd_init_clk_gating(struct 
> ufs_hba *hba)
>  	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
>  	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
> 
> +	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
> +		 hba->host->host_no);
> +	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
> +							   WQ_MEM_RECLAIM);
> +
>  	hba->clk_gating.is_enabled = true;
> 
>  	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
> @@ -1703,6 +1711,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba 
> *hba)
>  	device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
>  	cancel_work_sync(&hba->clk_gating.ungate_work);
>  	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
> +	destroy_workqueue(hba->clk_gating.clk_gating_workq);
>  }
> 
>  /* Must be called with host lock acquired */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 76c31d5..2e6bdc0 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -361,6 +361,7 @@ struct ufs_clk_gating {
>  	struct device_attribute enable_attr;
>  	bool is_enabled;
>  	int active_reqs;
> +	struct workqueue_struct *clk_gating_workq;
>  };
> 
>  struct ufs_saved_pwr_info {

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
