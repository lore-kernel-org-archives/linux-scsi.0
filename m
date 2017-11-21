From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: ufshcd: fix potential NULL pointer dereference
 in ufshcd_config_vreg
Date: Tue, 21 Nov 2017 11:16:15 -0800
Message-ID: <a37ed71b207fe81511a1e5d0a4d2c3af@codeaurora.org>
References: <20171120141229.GA2130@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171120141229.GA2130@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-11-20 06:12, Gustavo A. R. Silva wrote:
> _vreg_ is being dereferenced before it is null checked, hence there is 
> a
> potential null pointer dereference.
> 
> Fix this by moving the pointer dereference after _vreg_ has been null
> checked.
> 
> This issue was detected with the help of Coccinelle.
> 
> Fixes: aa4976130934 ("ufs: Add regulator enable support")
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 011c336..a355d98 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6559,12 +6559,15 @@ static int ufshcd_config_vreg(struct device 
> *dev,
>  		struct ufs_vreg *vreg, bool on)
>  {
>  	int ret = 0;
> -	struct regulator *reg = vreg->reg;
> -	const char *name = vreg->name;
> +	struct regulator *reg;
> +	const char *name;
>  	int min_uV, uA_load;
> 
>  	BUG_ON(!vreg);
> 
> +	reg = vreg->reg;
> +	name = vreg->name;
> +
>  	if (regulator_count_voltages(reg) > 0) {
>  		min_uV = on ? vreg->min_uV : 0;
>  		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
