From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 2/2] scsi: lpfc: don't double count abort errors
Date: Fri, 30 Jun 2017 07:56:55 -0700
Message-ID: <69a42b12-8d69-9ecd-cbd3-dd146938bd4e@broadcom.com>
References: <20170630080352.mmfyjjxsznzx75yf@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170630080352.mmfyjjxsznzx75yf@mwanda>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/30/2017 1:03 AM, Dan Carpenter wrote:
> If lpfc_nvmet_unsol_fcp_issue_abort() fails then we accidentally
> increment "tgtp->xmt_abort_rsp_error" and then two lines later we
> increment it a second time.
>
> Fixes: 547077a44b3b ("scsi: lpfc: Adding additional stats counters for nvme.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 7dc061a14f95..fbeec344c6cc 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -2583,7 +2583,6 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
>   	}
>   
>   aerr:
> -	atomic_inc(&tgtp->xmt_abort_rsp_error);
>   	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
>   	atomic_inc(&tgtp->xmt_abort_rsp_error);
>   	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,

looks good.

Signed-off-By: James Smart <james.smart@broadcom.com>
