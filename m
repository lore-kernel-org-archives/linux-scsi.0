From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] lpfc: Fix possible NULL pointer dereference
Date: Tue, 28 Jun 2016 13:28:19 -0700
Message-ID: <5772DDE3.30600@gmail.com>
References: <1465995608-53252-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465995608-53252-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/15/2016 06:00 AM, Johannes Thumshirn wrote:
> Check for the existance of pciob->vport before accessing it.

piocb mispelled.

> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 70edf21..134078f 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -1329,15 +1329,10 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>  	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
>  	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
>  	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
> -	 (!(piocb->vport->load_flag & FC_UNLOADING))) {
> -		if (!piocb->vport)
> -			BUG();

Granted the previous code would crash and burn in the if statement prior
to the BUG() assertion if piocb->vport was NULL, but is the condition
!piocb->vport still a bug here? Should that case still be asserted?

-Tyrel

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
>  	return 0;
>  }
> 
