From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [scsi 1/4] scsi: ufs: ufshcd_query_descriptor_retry should be
 static
Date: Tue, 10 Jan 2017 16:52:34 -0800
Message-ID: <0daf87838a71d1e996d784fb2b3bdbd6@codeaurora.org>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-01-05 00:45, Tomas Winkler wrote:
> Fix the following compilation warning:
> 
> drivers/scsi/ufs/ufshcd.c:2076:5: warning: no previous prototype for
> ‘ufshcd_query_descriptor_retry’ [-Wmissing-prototypes]
> 
> Also do not export the function, it should not be used out of ufs
> context.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 20e5e5fb048c..be3c2900b6bb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2073,9 +2073,11 @@ static int __ufshcd_query_descriptor(struct 
> ufs_hba *hba,
>   * The buf_len parameter will contain, on return, the length parameter
>   * received on the response.
>   */
> -int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
> -			enum query_opcode opcode, enum desc_idn idn, u8 index,
> -			u8 selector, u8 *desc_buf, int *buf_len)
> +static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
> +					 enum query_opcode opcode,
> +					 enum desc_idn idn, u8 index,
> +					 u8 selector,
> +					 u8 *desc_buf, int *buf_len)
>  {
>  	int err;
>  	int retries;
> @@ -2089,7 +2091,6 @@ int ufshcd_query_descriptor_retry(struct ufs_hba 
> *hba,
> 
>  	return err;
>  }
> -EXPORT_SYMBOL(ufshcd_query_descriptor_retry);
> 
>  /**
>   * ufshcd_read_desc_param - read the specified descriptor parameter

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
