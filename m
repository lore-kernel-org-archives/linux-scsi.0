From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 05/10] scsi: ufshcd: fix possible unclocked register
 access
Date: Wed, 16 May 2018 14:12:33 -0700
Message-ID: <45d251138fac73f4776eae34d9e36def@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <7f237069f86547afedcbbdf673cf85dfb20d05fa.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7f237069f86547afedcbbdf673cf85dfb20d05fa.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> vendor specific setup_clocks ops may depend on clocks managed by ufshcd
> driver so if the vendor specific setup_clocks callback is called when
> the required clocks are turned off, it results into unclocked register
> access.
> 
> This change make sure that required clocks are enabled before vendor
> specific setup_clocks callback is called.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 838ba8f0..dfeb194 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6780,9 +6780,16 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  	if (list_empty(head))
>  		goto out;
> 
> -	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
> -	if (ret)
> -		return ret;
> +	/*
> +	 * vendor specific setup_clocks ops may depend on clocks managed by
> +	 * this standard driver hence call the vendor specific setup_clocks
> +	 * before disabling the clocks managed here.
> +	 */
> +	if (!on) {
> +		ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
> +		if (ret)
> +			return ret;
> +	}
> 
>  	list_for_each_entry(clki, head, list) {
>  		if (!IS_ERR_OR_NULL(clki->clk)) {
> @@ -6806,9 +6813,16 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  		}
>  	}
> 
> -	ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
> -	if (ret)
> -		return ret;
> +	/*
> +	 * vendor specific setup_clocks ops may depend on clocks managed by
> +	 * this standard driver hence call the vendor specific setup_clocks
> +	 * after enabling the clocks managed here.
> +	 */
> +	if (on) {
> +		ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
> +		if (ret)
> +			return ret;
> +	}
> 
>  out:
>  	if (ret) {

Looks good to me.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
