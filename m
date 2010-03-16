From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 2/3] SCSI: lpfc, fix lock imbalances
Date: Tue, 16 Mar 2010 13:11:42 -0400
Message-ID: <4B9FBBCE.6060401@emulex.com>
References: <1268753039-17214-1-git-send-email-jslaby@suse.cz> <1268753039-17214-2-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1268753039-17214-2-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jirislaby@gmail.com" <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Acked-By:  James Smart <james.smart@emulex.com>

-- james s


Jiri Slaby wrote:
> Stanse found that two error paths in lpfc_bsg_rport_els_cmp and
> lpfc_issue_ct_rsp_cmp omits to unlock phba->ct_ev_lock. It is
> because they wrongly unlock phba->hbalock instead. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: James Smart <james.smart@emulex.com>
> Cc: James Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 692c29f..992efb1 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -432,7 +432,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
>  	dd_data = cmdiocbq->context1;
>  	/* normal completion and timeout crossed paths, already done */
>  	if (!dd_data) {
> -		spin_unlock_irqrestore(&phba->hbalock, flags);
> +		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
>  		return;
>  	}
>  
> @@ -1195,7 +1195,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
>  	dd_data = cmdiocbq->context1;
>  	/* normal completion and timeout crossed paths, already done */
>  	if (!dd_data) {
> -		spin_unlock_irqrestore(&phba->hbalock, flags);
> +		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
>  		return;
>  	}
>  
