From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Tidy clocks list head usage
Date: Mon, 05 Jun 2017 13:37:34 -0700
Message-ID: <26fd2cf420a554553f1289a4b53d3346@codeaurora.org>
References: <1496651815-13416-1-git-send-email-adrian.hunter@intel.com>
 <1496651815-13416-2-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496651815-13416-2-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-06-05 01:36, Adrian Hunter wrote:
> From: Szymon Mielczarek <szymonx.mielczarek@intel.com>
> 
> Move the initialization of clocks list head to ufshcd_alloc_host() so 
> that
> every driver doesn't have to do it. Remove checks for the list head 
> being
> NULL because that is not possible.
> 
> Signed-off-by: Szymon Mielczarek <szymonx.mielczarek@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/scsi/ufs/tc-dwc-g210-pci.c |  2 --
>  drivers/scsi/ufs/ufshcd-pci.c      |  2 --
>  drivers/scsi/ufs/ufshcd-pltfrm.c   |  2 --
>  drivers/scsi/ufs/ufshcd.c          | 12 +++++++-----
>  4 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c
> b/drivers/scsi/ufs/tc-dwc-g210-pci.c
> index c09a0fef0fe6..325d5e14fc0d 100644
> --- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
> +++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
> @@ -130,8 +130,6 @@ static void tc_dwc_g210_pci_remove(struct pci_dev 
> *pdev)
>  		return err;
>  	}
> 
> -	INIT_LIST_HEAD(&hba->clk_list_head);
> -
>  	hba->vops = &tc_dwc_g210_pci_hba_vops;
> 
>  	err = ufshcd_init(hba, mmio_base, pdev->irq);
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c 
> b/drivers/scsi/ufs/ufshcd-pci.c
> index 52b546fb509b..5dd4122cbd85 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -143,8 +143,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
>  		return err;
>  	}
> 
> -	INIT_LIST_HEAD(&hba->clk_list_head);
> -
>  	err = ufshcd_init(hba, mmio_base, pdev->irq);
>  	if (err) {
>  		dev_err(&pdev->dev, "Initialization failed\n");
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c 
> b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 8e5e6c04c035..e82bde077296 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -58,8 +58,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba 
> *hba)
>  	if (!np)
>  		goto out;
> 
> -	INIT_LIST_HEAD(&hba->clk_list_head);
> -
>  	cnt = of_property_count_strings(np, "clock-names");
>  	if (!cnt || (cnt == -EINVAL)) {
>  		dev_info(dev, "%s: Unable to find clocks, assuming enabled\n",
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ffe8d8608818..88ccd63f83c1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -314,7 +314,7 @@ static void ufshcd_print_clk_freqs(struct ufs_hba 
> *hba)
>  	struct ufs_clk_info *clki;
>  	struct list_head *head = &hba->clk_list_head;
> 
> -	if (!head || list_empty(head))
> +	if (list_empty(head))
>  		return;
> 
>  	list_for_each_entry(clki, head, list) {
> @@ -869,7 +869,7 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up)
>  	ktime_t start = ktime_get();
>  	bool clk_state_changed = false;
> 
> -	if (!head || list_empty(head))
> +	if (list_empty(head))
>  		goto out;
> 
>  	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
> @@ -943,7 +943,7 @@ static bool
> ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>  	struct ufs_clk_info *clki;
>  	struct list_head *head = &hba->clk_list_head;
> 
> -	if (!head || list_empty(head))
> +	if (list_empty(head))
>  		return false;
> 
>  	list_for_each_entry(clki, head, list) {
> @@ -6752,7 +6752,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  	ktime_t start = ktime_get();
>  	bool clk_state_changed = false;
> 
> -	if (!head || list_empty(head))
> +	if (list_empty(head))
>  		goto out;
> 
>  	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
> @@ -6818,7 +6818,7 @@ static int ufshcd_init_clocks(struct ufs_hba 
> *hba)
>  	struct device *dev = hba->dev;
>  	struct list_head *head = &hba->clk_list_head;
> 
> -	if (!head || list_empty(head))
> +	if (list_empty(head))
>  		goto out;
> 
>  	list_for_each_entry(clki, head, list) {
> @@ -7811,6 +7811,8 @@ int ufshcd_alloc_host(struct device *dev, struct
> ufs_hba **hba_handle)
>  	hba->dev = dev;
>  	*hba_handle = hba;
> 
> +	INIT_LIST_HEAD(&hba->clk_list_head);
> +
>  out_error:
>  	return err;
>  }

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
