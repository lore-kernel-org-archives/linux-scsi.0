From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 01/10] scsi: ufs: Allowing power mode change
Date: Wed, 16 May 2018 14:09:51 -0700
Message-ID: <33a5e196be45bfeb0bea49a446e8af98@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <75e5ea5901004ef95b37aed719686214910f6541.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <75e5ea5901004ef95b37aed719686214910f6541.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
> From: Yaniv Gardi <ygardi@codeaurora.org>
> 
> Due to M-PHY issues, moving from HS to any other mode or gear or
> even Hibern8 may cause some un-predicted behavior
> of the device.
> This patch adds provides a quirk to address that.
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 +++++++-
>  drivers/scsi/ufs/ufshcd.h | 7 +++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5bc9dc1..f3083fe 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4162,9 +4162,15 @@ static int ufshcd_link_startup(struct ufs_hba 
> *hba)
>  			goto out;
>  	} while (ret && retries--);
> 
> -	if (ret)
> +	if (ret) {
>  		/* failed to get the link up... retire */
>  		goto out;
> +	}
> +
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE) {
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(TX_LCC_ENABLE), 0);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(TX_LCC_ENABLE), 1);
> +	}
> 
>  	if (link_startup_again) {
>  		link_startup_again = false;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index cbe46f6..bb4ecfb 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -591,6 +591,13 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			UFS_BIT(7)
> 
> +	/*
> +	 * Needs to be enabled if moving from HS to any other gear/mode or 
> even
> +	 * hibern8 causes unpredicted behavior of device.
> +	 * If this quirk is enabled, standard UFS driver will disable/enable
> +	 * TX_LCC.
> +	 */
> +	#define UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE		UFS_BIT(8)
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

This was probably needed in early generation of UFS devices (non 
commercial) and may not be really needed now. I believe we can skip this 
patch.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
