From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: fix missing spin_unlock on sql_list_lock
Date: Sat, 4 Mar 2017 09:42:50 -0800
Message-ID: <4692bdb2-dabb-a9bb-90f3-0678ab0fd26e@broadcom.com>
References: <20170224143015.6441-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36153 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdCDRm4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:42:56 -0500
Received: by mail-wm0-f53.google.com with SMTP id n11so36265282wma.1
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:42:55 -0800 (PST)
In-Reply-To: <20170224143015.6441-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

Looks good. I included it in the lpfc patch set just posted.

-- james


On 2/24/2017 6:30 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> In the case where sglq is null, the current code just returns without
> unlocking the spinlock sql_list_lock. Fix this by breaking out of the
> while loop and the exit path will then unlock and return NULL as was
> the original intention.
>
> Detected by CoverityScan, CID#1411635 ("Missing unlock")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 1fba5dc..40720bb 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -952,7 +952,7 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
>   	start_sglq = sglq;
>   	while (!found) {
>   		if (!sglq)
> -			return NULL;
> +			break;
>   		if (ndlp && ndlp->active_rrqs_xri_bitmap &&
>   		    test_bit(sglq->sli4_lxritag,
>   		    ndlp->active_rrqs_xri_bitmap)) {
