From: subhashj@codeaurora.org
Subject: Re: [PATCH][SCSI] scsi: ufs: get a TM service response from the
 correct offset
Date: Tue, 27 Sep 2016 15:38:58 -0700
Message-ID: <7b2832c0aac3a25131ba0e0c8bc13a93@codeaurora.org>
References: <000401d20a27$da459040$8ed0b0c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48739 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753049AbcI0WjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 18:39:00 -0400
In-Reply-To: <000401d20a27$da459040$8ed0b0c0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: vinholikatti@gmail.com, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

Hi Kiwoong Kim,

This is a good catch, Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

Thanks,
Subhash

On 2016-09-08 16:22, Kiwoong Kim wrote:
> From: Kiwoong Kim <kwmad.kim@samsung.com>
> 
> When any UFS host controller receives a TM(Task Management)
> response from a UFS device,
> UFS driver has been recognize like receiving a message of
> "Task Management Function Complete"(00h) in all cases, so far.
> That means there is no pending task for a tag of the TM request
> sent before in the UFS device.
> That's because the byte offset 6 in TM response which has been used
> to get a TM service response so far
> represents just whether or not a TM transmission passes.
> 
> Regarding UFS spec, the correct byte offset to
> get TM service response is 15, not 6.
> 
> I tested that UFS driver responds properly for the TM response
> From a UFS device with an reference board with exynos8890, as follow:
> No pending task -> Task Management Function Complete (00h)
> Pending task -> Task Management Function Succeeded (08h)
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> Signed-off-by: HeonGwang Chu <hg.chu@samsung.com>
> Tested-by: : Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufs.h    |    1 +
>  drivers/scsi/ufs/ufshcd.c |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 42c459a..89c121e 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -295,6 +295,7 @@ enum {
>         MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
>         MASK_RSP_UPIU_DATA_SEG_LEN      = 0xFFFF,
>         MASK_RSP_EXCEPTION_EVENT        = 0x10000,
> +       MASK_TM_SERVICE_RESP            = 0xFF,
>  };
> 
>  /* Task management service response */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e8a706b..c641cd3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3013,8 +3013,8 @@ static int ufshcd_task_req_compl(struct ufs_hba
> *hba, u32 index, u8 *resp)
>         if (ocs_value == OCS_SUCCESS) {
>                 task_rsp_upiup = (struct utp_upiu_task_rsp *)
>                                 task_req_descp[index].task_rsp_upiu;
> -               task_result = 
> be32_to_cpu(task_rsp_upiup->header.dword_1);
> -               task_result = ((task_result & MASK_TASK_RESPONSE) >> 
> 8);
> +               task_result = 
> be32_to_cpu(task_rsp_upiup->output_param1);
> +               task_result = task_result & MASK_TM_SERVICE_RESP;
>                 if (resp)
>                         *resp = (u8)task_result;
>         } else {
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
