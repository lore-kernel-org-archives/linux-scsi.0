From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1 3/9] scsi: ufs: Override auto suspend tunables for ufs
Date: Fri, 20 Jul 2018 16:51:41 -0700
Message-ID: <0dc1fca230941323aa6c904cc88713e5@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
 <6981189193244970a912c8b3f390a00bc37ed14a.1530880006.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6981189193244970a912c8b3f390a00bc37ed14a.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-07-06 05:30, Asutosh Das wrote:
> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
> 
> Override auto suspend tunables for UFS device LUNs during
> initialization so as to efficiently manage background operations
> and the power consumption.
> 
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 77e2b3e..b03f3ea 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -89,6 +89,9 @@
>  /* Interrupt aggregation default timeout, unit: 40us */
>  #define INT_AGGR_DEF_TO	0x02
> 
> +/* default value of auto suspend is 3 seconds */
> +#define UFSHCD_AUTO_SUSPEND_DELAY_MS 3000 /* millisecs */
> +
>  #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
>  	({                                                              \
>  		int _ret;                                               \
> @@ -4528,6 +4531,9 @@ static int ufshcd_slave_configure(struct
> scsi_device *sdev)
>  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>  	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
> 
> +	sdev->autosuspend_delay = UFSHCD_AUTO_SUSPEND_DELAY_MS;
> +	sdev->use_rpm_auto = 1;
> +
>  	return 0;
>  }

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
