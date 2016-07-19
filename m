From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with the
 hbalock held
Date: Tue, 19 Jul 2016 08:31:17 -0700
Message-ID: <fe32617c-68e6-a60a-c5c3-c1926fdf7b1e@broadcom.com>
References: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35475 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbcGSPbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 11:31:19 -0400
Received: by mail-pf0-f181.google.com with SMTP id x72so8395126pfd.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2016 08:31:19 -0700 (PDT)
In-Reply-To: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

The check is better and is fine to accept. However, in reviewing the 
code, there may still be some raciness as some of the fields validated 
aren't set under lock. We'll look deeper. Regardless, holding the lock 
while counting is a very good thing to do.

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james


On 7/18/2016 7:06 AM, Johannes Thumshirn wrote:
> Call lpfc_sli_validate_fcp_iocb() with the hbalock held, as the pointer to
> iocbq is not guaranteed to still be valid after looking it up.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 1a248a2..d58ec4c 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -9978,6 +9978,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
>   	struct lpfc_iocbq *iocbq;
>   	int sum, i;
>   
> +	spin_lock_irq(&phba->hbalock);
>   	for (i = 1, sum = 0; i <= phba->sli.last_iotag; i++) {
>   		iocbq = phba->sli.iocbq_lookup[i];
>   
> @@ -9985,6 +9986,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
>   						ctx_cmd) == 0)
>   			sum++;
>   	}
> +	spin_unlock_irq(&phba->hbalock);
>   
>   	return sum;
>   }

