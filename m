From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/14] lpfc: The linux driver does not reinitiate
 discovery after a failed FLOGI
Date: Mon, 14 Sep 2015 09:40:02 +0200
Message-ID: <55F679D2.3000804@suse.de>
References: <55e4bd93.oKGQ536ViqN6PeJn%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbbINHkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:40:03 -0400
In-Reply-To: <55e4bd93.oKGQ536ViqN6PeJn%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> The linux driver does not reinitiate discovery after a failed FLOGI
>=20
> Forgot to clear FCF Discovery in-progress flag upon FLOGI failures.
> Thus we didn't restart FLOGI.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index 759fa9b..3feeb44 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1026,9 +1026,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, str=
uct lpfc_iocbq *cmdiocb,
>  stop_rr_fcf_flogi:
>  		/* FLOGI failure */
>  		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> -				"2858 FLOGI failure Status:x%x/x%x TMO:x%x\n",
> +				"2858 FLOGI failure Status:x%x/x%x TMO:x%x "
> +				"Data x%x x%x\n",
>  				irsp->ulpStatus, irsp->un.ulpWord[4],
> -				irsp->ulpTimeout);
> +				irsp->ulpTimeout, phba->hba_flag,
> +				phba->fcf.fcf_flag);
> =20
>  		/* Check for retry */
>  		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
> @@ -1152,6 +1154,9 @@ stop_rr_fcf_flogi:
>  	}
> =20
>  flogifail:
> +	spin_lock_irq(&phba->hbalock);
> +	phba->fcf.fcf_flag &=3D ~FCF_DISCOVERY;
> +	spin_unlock_irq(&phba->hbalock);
>  	lpfc_nlp_put(ndlp);
> =20
>  	if (!lpfc_error_lost_link(irsp)) {
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
