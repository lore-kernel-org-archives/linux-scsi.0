From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 03/10] scsi: ufs: Add LCC quirk for host and device
Date: Wed, 16 May 2018 14:11:17 -0700
Message-ID: <b96ac094fc3c99d4f0f47f266f38f778@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <0aa7ff1ff67e0c01d6347b932cfe7ce801ef09fc.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aa7ff1ff67e0c01d6347b932cfe7ce801ef09fc.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
> LCC (Line Control Command) is being used for communication between
> UFS host and UFS device. But some hosts might have the issue with
> issuing the LCC commands to UFS device and in this case LCC could be
> explicitly disabled.
> 
> But there could be a need where we don't want to disable the LCC
> on both host & device; hence this change splits the quirk in 2 parts
> one for host and one for device.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h | 12 ++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f3083fe..6dabce8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4116,6 +4116,11 @@ static int ufshcd_disable_tx_lcc(struct ufs_hba
> *hba, bool peer)
>  	return err;
>  }
> 
> +static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
> +{
> +	return ufshcd_disable_tx_lcc(hba, false);
> +}
> +
>  static inline int ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
>  {
>  	return ufshcd_disable_tx_lcc(hba, true);
> @@ -4172,6 +4177,17 @@ static int ufshcd_link_startup(struct ufs_hba 
> *hba)
>  		ufshcd_dme_set(hba, UIC_ARG_MIB(TX_LCC_ENABLE), 1);
>  	}
> 
> +	if (hba->quirks & UFSHCD_BROKEN_LCC_PROCESSING_ON_HOST) {
> +		ret = ufshcd_disable_device_tx_lcc(hba);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	if (hba->quirks & UFSHCD_BROKEN_LCC_PROCESSING_ON_DEVICE) {
> +		ret = ufshcd_disable_host_tx_lcc(hba);
> +		if (ret)
> +			goto out;
> +	}
>  	if (link_startup_again) {
>  		link_startup_again = false;
>  		retries = DME_LINKSTARTUP_RETRIES;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index bb4ecfb..0417c42 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -598,6 +598,18 @@ struct ufs_hba {
>  	 * TX_LCC.
>  	 */
>  	#define UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE		UFS_BIT(8)
> +
> +	/*
> +	 * If UFS device is having issue in processing LCC (Line Control
> +	 * Command) coming from UFS host controller then enable this quirk.
> +	 * When this quirk is enabled, host controller driver should disable
> +	 * the LCC transmission on UFS host controller (by clearing
> +	 * TX_LCC_ENABLE attribute of host to 0).
> +	 */
> +	#define UFSHCD_BROKEN_LCC_PROCESSING_ON_DEVICE		0x100
> +
> +	#define UFSHCD_BROKEN_LCC_PROCESSING_ON_HOST		0x200
> +
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

Please check if these quirks are really needed for commercial version of 
UFS host controllers.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
