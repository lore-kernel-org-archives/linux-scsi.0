From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Fix a precedence bug in
 lpfc_nvme_io_cmd_wqe_cmpl()
Date: Fri, 3 Nov 2017 08:48:02 -0700
Message-ID: <37592f5c-18a6-a486-fb58-d9db486d7144@broadcom.com>
References: <20171012203057.ixo2ds5i5ecbyv4y@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:45052 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753059AbdKCPsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 11:48:05 -0400
Received: by mail-qk0-f178.google.com with SMTP id r64so3745267qkc.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 08:48:05 -0700 (PDT)
In-Reply-To: <20171012203057.ixo2ds5i5ecbyv4y@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 10/12/2017 1:30 PM, Dan Carpenter wrote:
> The ! has higher precedence than the & operation.  I've added
> parenthesis so this works as intended.
>
> Fixes: 952c303b329c ("scsi: lpfc: Ensure io aborts interlocked with the target.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 60f0dbd0f192..517ae570e507 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -948,7 +948,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
>   	/* NVME targets need completion held off until the abort exchange
>   	 * completes.
>   	 */
> -	if (!lpfc_ncmd->flags & LPFC_SBUF_XBUSY)
> +	if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY))
>   		nCmd->done(nCmd);
>   
>   	spin_lock_irqsave(&phba->hbalock, flags);
yep

Signed-off-by:  James Smart <james.smart@broadcom.com>
