From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1
Date: Tue, 26 Sep 2017 14:50:41 -0700
Message-ID: <853cb73a8e7139304bedfc8b59d5b710@codeaurora.org>
References: <1504691919-30832-1-git-send-email-kehuanlin@pinecone.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504691919-30832-1-git-send-email-kehuanlin@pinecone.net>
Sender: linux-kernel-owner@vger.kernel.org
To: kehuanlin <chgokhl@gmail.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kehuanlin@pinecone.net, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-09-06 02:58, kehuanlin wrote:
> Since the command type of UTRD in UFS 2.1 specification is the same 
> with
> UFS 2.0. And it assumes the future UFS specification will follow the 
> same
> definition.
> 
> Signed-off-by: kehuanlin <kehuanlin@pinecone.net>
> ---
>  drivers/scsi/ufs/ufshcd.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5bc9dc1..c33a2f8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2195,10 +2195,11 @@ static int ufshcd_comp_devman_upiu(struct
> ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  	u32 upiu_flags;
>  	int ret = 0;
> 
> -	if (hba->ufs_version == UFSHCI_VERSION_20)
> -		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> -	else
> +	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
> +	    (hba->ufs_version == UFSHCI_VERSION_11))
>  		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
> +	else
> +		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> 
>  	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
>  	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
> @@ -2222,10 +2223,11 @@ static int ufshcd_comp_scsi_upiu(struct
> ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  	u32 upiu_flags;
>  	int ret = 0;
> 
> -	if (hba->ufs_version == UFSHCI_VERSION_20)
> -		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> -	else
> +	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
> +	    (hba->ufs_version == UFSHCI_VERSION_11))
>  		lrbp->command_type = UTP_CMD_TYPE_SCSI;
> +	else
> +		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> 
>  	if (likely(lrbp->cmd)) {
>  		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>



-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
