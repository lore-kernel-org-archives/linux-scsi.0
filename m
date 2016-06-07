From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: fix potential memory leak
Date: Tue, 07 Jun 2016 12:12:08 -0700
Message-ID: <1465326728.2310.39.camel@HansenPartnership.com>
References: <1a5ff649.111.1552c05f371.Coremail.kernelpatch@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37648 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbcFGTMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 15:12:23 -0400
In-Reply-To: <1a5ff649.111.1552c05f371.Coremail.kernelpatch@126.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tiezhu Yang <kernelpatch@126.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2016-06-08 at 02:00 +0800, Tiezhu Yang wrote:
> There exists potential memory leak in ufshcd_parse_clock_info(),
> this patch fixes it.

What makes you think there's a leak here?  These are all devm_
allocations, so they're all freed when the device is.  If an error is
returned, the device is released and the memory freed.

You can argue that on successful initialization, there's no need to
keep the clkfreq array but this patch isn't the way you'd change that.

James

> Signed-off-by: Tiezhu Yang <kernelpatch@126.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c
> b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index db53f38..8b057f4 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -100,19 +100,19 @@ static int ufshcd_parse_clock_info(struct
> ufs_hba *hba)
>  	if (ret && (ret != -EINVAL)) {
>  		dev_err(dev, "%s: error reading array %d\n",
>  				"freq-table-hz", ret);
> -		return ret;
> +		goto out_free;
>  	}
>  
>  	for (i = 0; i < sz; i += 2) {
>  		ret = of_property_read_string_index(np,
>  				"clock-names", i/2, (const char
> **)&name);
>  		if (ret)
> -			goto out;
> +			goto out_free;
>  
>  		clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
>  		if (!clki) {
>  			ret = -ENOMEM;
> -			goto out;
> +			goto out_free;
>  		}
>  
>  		clki->min_freq = clkfreq[i];
> @@ -122,6 +122,10 @@ static int ufshcd_parse_clock_info(struct
> ufs_hba *hba)
>  				clki->min_freq, clki->max_freq, clki
> ->name);
>  		list_add_tail(&clki->list, &hba->clk_list_head);
>  	}
> +
> +out_free:
> +	devm_kfree(dev, clkfreq);
> +	clkfreq = NULL;
>  out:
>  	return ret;
>  }

