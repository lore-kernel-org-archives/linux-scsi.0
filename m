From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/21] lpfc: Correct FCOE discovery to avoid loss of
 storage devices after system reboot
Date: Fri, 15 Jul 2016 15:16:00 +0200
Message-ID: <c1418ff4-2552-c734-9cb2-c53d3378b73e@suse.de>
References: <577d5da2.z0GKKgjcgUhFJ0Im%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcGONQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:16:02 -0400
In-Reply-To: <577d5da2.z0GKKgjcgUhFJ0Im%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Correct FCOE discovery to avoid loss of storage devices after system =
reboot
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index bb514d2..8d940ed 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4484,7 +4484,8 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
>  		 * the corresponding FCF bit in the roundrobin bitmap.
>  		 */
>  		spin_lock_irq(&phba->hbalock);
> -		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
> +		if ((phba->fcf.fcf_flag & FCF_DISCOVERY) &&
> +		    (phba->fcf.current_rec.fcf_indx !=3D acqe_fip->index)) {
>  			spin_unlock_irq(&phba->hbalock);
>  			/* Update FLOGI FCF failover eligible FCF bmask */
>  			lpfc_sli4_fcf_rr_index_clear(phba, acqe_fip->index);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
