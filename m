From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with the
 hbalock held
Date: Mon, 18 Jul 2016 16:28:57 -0400 (EDT)
Message-ID: <1095600204.5575668.1468873737267.JavaMail.zimbra@redhat.com>
References: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:34937 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbcGRU3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2016 16:29:06 -0400
In-Reply-To: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>



----- Original Message -----
> From: "Johannes Thumshirn" <jthumshirn@suse.de>
> To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James Bottomley" <jejb@linux.vnet.ibm.com>, "James Smart"
> <james.smart@avagotech.com>, "Dick Kennedy" <dick.kennedy@avagotech.com>
> Cc: "Linux SCSI Mailinglist" <linux-scsi@vger.kernel.org>, "Johannes Thumshirn" <jthumshirn@suse.de>
> Sent: Monday, July 18, 2016 10:06:03 AM
> Subject: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with the hbalock held
> 
> Call lpfc_sli_validate_fcp_iocb() with the hbalock held, as the pointer to
> iocbq is not guaranteed to still be valid after looking it up.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 1a248a2..d58ec4c 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -9978,6 +9978,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t
> tgt_id, uint64_t lun_id,
>  	struct lpfc_iocbq *iocbq;
>  	int sum, i;
>  
> +	spin_lock_irq(&phba->hbalock);
>  	for (i = 1, sum = 0; i <= phba->sli.last_iotag; i++) {
>  		iocbq = phba->sli.iocbq_lookup[i];
>  
> @@ -9985,6 +9986,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t
> tgt_id, uint64_t lun_id,
>  						ctx_cmd) == 0)
>  			sum++;
>  	}
> +	spin_unlock_irq(&phba->hbalock);
>  
>  	return sum;
>  }
> --
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hi Johannes

The code looks correct, but I would get a review from James Smart or Dick Kennedy at Emulex (now Broadcom :))
Have you experienced an issue already due to this, can you share the stack trace of the issue if you have it.

Reviewed-by Laurence Oberman <loberman@redhat.com>
