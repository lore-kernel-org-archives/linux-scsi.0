From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/14] lpfc: The lpfc driver does not issue RFF_ID and
 RFT_ID in the correct sequence
Date: Tue, 21 Apr 2015 11:58:25 +0200
Message-ID: <55361F41.1090103@suse.de>
References: <55350588.xwtuh+7l3U0CWLLy%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbbDUJ62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 05:58:28 -0400
In-Reply-To: <55350588.xwtuh+7l3U0CWLLy%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org

On 04/20/2015 03:56 PM, James Smart wrote:
>=20
> The lpfc driver does not issue RFF_ID and RFT_ID in the correct seque=
nce
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpf=
c_hbadisc.c
> index 2500f15..f2db89f 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -3868,11 +3868,11 @@ out:
> =20
>  	if (vport->port_state < LPFC_VPORT_READY) {
>  		/* Link up discovery requires Fabric registration. */
> -		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0); /* Do this first! */
>  		lpfc_ns_cmd(vport, SLI_CTNS_RNN_ID, 0, 0);
>  		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
>  		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
>  		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
> +		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0);
> =20
>  		/* Issue SCR just before NameServer GID_FT Query */
>  		lpfc_issue_els_scr(vport, SCR_DID, 0);
>=20
Hehe.
Someone screwed up with the comment ;-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
