From: James Smart <james.smart@emulex.com>
Subject: Re: [patch] [SCSI] lpfc: nested calls to spin_lock_irq()
Date: Wed, 21 Dec 2011 10:42:59 -0500
Message-ID: <4EF1FE83.1000201@emulex.com>
References: <20111216202819.GF18570@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:41984 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491Ab1LUPnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 10:43:21 -0500
In-Reply-To: <20111216202819.GF18570@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

Thanks Dan...

-- james


Acked-by: James Smart <james.smart@emulex.com>


On 12/16/2011 3:28 PM, Dan Carpenter wrote:
> We already have disabled IRQs so there is no need to disable them again.
> Also the functions are not nestable, the first spin_unlock_irq() will
> enable IRQs and we don't want to do that until the second unlock.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 678a4b1..d7e916b 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -2977,9 +2977,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
>   				"topology\n");
>   				/* Get Loop Map information */
>   		if (bf_get(lpfc_mbx_read_top_il, la)) {
> -			spin_lock_irq(shost->host_lock);
> +			spin_lock(shost->host_lock);
>   			vport->fc_flag |= FC_LBIT;
> -			spin_unlock_irq(shost->host_lock);
> +			spin_unlock(shost->host_lock);
>   		}
>
>   		vport->fc_myDID = bf_get(lpfc_mbx_read_top_alpa_granted, la);
> @@ -3029,9 +3029,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
>   				phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
>   		}
>   		vport->fc_myDID = phba->fc_pref_DID;
> -		spin_lock_irq(shost->host_lock);
> +		spin_lock(shost->host_lock);
>   		vport->fc_flag |= FC_LBIT;
> -		spin_unlock_irq(shost->host_lock);
> +		spin_unlock(shost->host_lock);
>   	}
>   	spin_unlock_irq(&phba->hbalock);
>
>
