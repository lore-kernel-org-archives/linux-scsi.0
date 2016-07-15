From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/21] lpfc: Disable FDMI probing if not connected to a
 fabric
Date: Fri, 15 Jul 2016 15:23:27 +0200
Message-ID: <9609896f-9ed2-7093-ddfa-df3850a74fe2@suse.de>
References: <577d5dac.IWJT5/2li7EwQBnO%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbcGONX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:23:28 -0400
In-Reply-To: <577d5dac.IWJT5/2li7EwQBnO%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Disable FDMI probing if not connected to a fabric
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.=
c
> index a38816e..63e48d4 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1510,6 +1510,10 @@ lpfc_fdmi_num_disc_check(struct lpfc_vport *vp=
ort)
>  	if (!lpfc_is_link_up(phba))
>  		return;
> =20
> +	/* Must be connected to a Fabric */
> +	if (!(vport->fc_flag & FC_FABRIC))
> +		return;
> +
>  	if (!(vport->fdmi_port_mask & LPFC_FDMI_PORT_ATTR_num_disc))
>  		return;
> =20
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
