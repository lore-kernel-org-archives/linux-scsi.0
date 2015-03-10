From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH] drivers: scsi: ufs: Fix possible null derefrence
Date: Tue, 10 Mar 2015 10:28:44 -0000
Message-ID: <77622d9c87fdc6e7af6fd862da67a81c.squirrel@www.codeaurora.org>
References: <20150304124948.GA3288@kt-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150304124948.GA3288@kt-Inspiron-3542>
Sender: linux-kernel-owner@vger.kernel.org
Cc: vinholikatti@gmail.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, tapaswenipathak@gmail.com, julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

> Check for null before being dereferenced to avoid a invalid null
> dereference.
>
> Found using Coccinelle.
>
> Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/scsi/ufs/ufshcd.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5d60a86..c54e64f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4268,12 +4268,15 @@ static int ufshcd_config_vreg(struct device *dev,
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


Please add to the patch fix for another instance of this  in
ufshcd_config_vreg_load():

static int ufshcd_config_vreg_load(struct device *dev,
    struct ufs_vreg *vreg, int ua)
{
	int ret = 0;
	struct regulator *reg = vreg->reg;
	const char *name = vreg->name;

	BUG_ON(!vreg);


Gilad.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
