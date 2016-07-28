From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix possible NULL pointer dereference
Date: Thu, 28 Jul 2016 07:58:38 -0700
Message-ID: <f76e1ffb-1642-1e7f-ccc8-a45c8fc13aa9@broadcom.com>
References: <1465995608-53252-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34201 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbcG1O6m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2016 10:58:42 -0400
Received: by mail-qk0-f177.google.com with SMTP id o67so64889664qke.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2016 07:58:42 -0700 (PDT)
In-Reply-To: <1465995608-53252-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

This patch is good. Thanks

-- james

Signed-off-by: James Smart  <james.smart@broadcom.com>


On 6/15/2016 6:00 AM, Johannes Thumshirn wrote:
> Check for the existance of pciob->vport before accessing it.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 70edf21..134078f 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -1329,15 +1329,10 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>   	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
>   	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
>   	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
> -	 (!(piocb->vport->load_flag & FC_UNLOADING))) {
> -		if (!piocb->vport)
> -			BUG();
> -		else
> -			mod_timer(&piocb->vport->els_tmofunc,
> -				jiffies +
> -				msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
> -	}
> -
> +	    piocb->vport && !(piocb->vport->load_flag & FC_UNLOADING))
> +		mod_timer(&piocb->vport->els_tmofunc,
> +			  jiffies +
> +			  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
>   
>   	return 0;
>   }

