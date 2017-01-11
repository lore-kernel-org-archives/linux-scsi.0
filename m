From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] lpfc: avoid double free of resource identifiers
Date: Wed, 11 Jan 2017 11:47:49 -0800
Message-ID: <43af5f62-2e79-62c6-c045-5da0cff18e10@broadcom.com>
References: <20170111100642.18573-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f176.google.com ([209.85.210.176]:36213 "EHLO
        mail-wj0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757098AbdAKTy1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 14:54:27 -0500
Received: by mail-wj0-f176.google.com with SMTP id ew7so96466367wjc.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 11:54:26 -0800 (PST)
In-Reply-To: <20170111100642.18573-1-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>, Roberto Sassu <rsassu@suse.de>

looks good. Thanks

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james


On 1/11/2017 2:06 AM, Johannes Thumshirn wrote:
> From: Roberto Sassu <rsassu@suse.de>
>
> Set variables initialized in lpfc_sli4_alloc_resource_identifiers() to NULL
> if an error occurred. Otherwise, lpfc_sli4_driver_resource_unset() attempts
> to free the memory again.
>
> Signed-off-by: Roberto Sassu <rsassu@suse.de>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 4faa767..a78a3df 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -5954,18 +5954,25 @@ lpfc_sli4_alloc_resource_identifiers(struct lpfc_hba *phba)
>   
>    free_vfi_bmask:
>   	kfree(phba->sli4_hba.vfi_bmask);
> +	phba->sli4_hba.vfi_bmask = NULL;
>    free_xri_ids:
>   	kfree(phba->sli4_hba.xri_ids);
> +	phba->sli4_hba.xri_ids = NULL;
>    free_xri_bmask:
>   	kfree(phba->sli4_hba.xri_bmask);
> +	phba->sli4_hba.xri_bmask = NULL;
>    free_vpi_ids:
>   	kfree(phba->vpi_ids);
> +	phba->vpi_ids = NULL;
>    free_vpi_bmask:
>   	kfree(phba->vpi_bmask);
> +	phba->vpi_bmask = NULL;
>    free_rpi_ids:
>   	kfree(phba->sli4_hba.rpi_ids);
> +	phba->sli4_hba.rpi_ids = NULL;
>    free_rpi_bmask:
>   	kfree(phba->sli4_hba.rpi_bmask);
> +	phba->sli4_hba.rpi_bmask = NULL;
>    err_exit:
>   	return rc;
>   }

