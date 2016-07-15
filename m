From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/21] lpfc: Reject RDP ELS if port has no login
Date: Fri, 15 Jul 2016 15:09:11 +0200
Message-ID: <9fb2c855-d5fc-22fc-54ae-59fdb1f35012@suse.de>
References: <577d5d9e.DGbam2YjJ7SVt9GU%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbcGONJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:09:12 -0400
In-Reply-To: <577d5d9e.DGbam2YjJ7SVt9GU%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 07/06/2016 09:35 PM, James Smart wrote:
>=20
> Reject RDP ELS if port has no login
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index 02e3a1f..861270e 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5243,6 +5243,12 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, str=
uct lpfc_iocbq *cmdiocb,
>  			 be32_to_cpu(rdp_req->nport_id_desc.nport_id),
>  			 be32_to_cpu(rdp_req->nport_id_desc.length));
> =20
> +	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED) &&
> +	    !phba->cfg_enable_SmartSAN) {
> +		rjt_err =3D LSRJT_UNABLE_TPC;
> +		rjt_expl =3D LSEXP_PORT_LOGIN_REQ;
> +		goto error;
> +	}
>  	if (sizeof(struct fc_rdp_nport_desc) !=3D
>  			be32_to_cpu(rdp_req->rdp_des_length))
>  		goto rjt_logerr;
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
