From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] libsas: fix bug for vacant phy
Date: Wed, 29 Sep 2010 09:21:37 +0200
Message-ID: <4CA2E901.9040908@suse.de>
References: <BE430C874DBA6841A75E65151DCC6E1C0699F1BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <D8666BDF2F024F71B478BDCA08C7833D@usish.com.cn> <BE430C874DBA6841A75E65151DCC6E1C0731F42F@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <01B7071A8F0947F38977CA217D833D16@usish.com.cn> <27DA42B50CD244D19895F2FCED2191FD@usish.com.cn> <BE430C874DBA6841A75E65151DCC6E1C077DA147@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0I2HVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2010 03:21:42 -0400
In-Reply-To: <BE430C874DBA6841A75E65151DCC6E1C077DA147@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Tuffli <Chuck_Tuffli@pmc-sierra.com>
Cc: Jack Wang <jack_wang@usish.com>, James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org, lindar_liu <lindar_liu@usish.com>, roy <roy_wang@usish.com>

Chuck Tuffli wrote:
> This fixes the issue I was seeing. Thanks!
>=20
> -----Original Message-----
> From: Jack Wang [mailto:jack_wang@usish.com]=20
> Sent: Sunday, September 19, 2010 10:52 PM
> To: 'Jack Wang'; Chuck Tuffli; 'James Bottomley'; linux-scsi@vger.ker=
nel.org
> Cc: 'lindar_liu'; 'roy'
> Subject: [PATCH v2] libsas: fix bug for vacant phy
>=20
>=20
> Hi, James
>=20
> Please drop the previous patch and apply this new one.
> Attached patch fix following bugs reported by Chuck.
>=20
> Chuck
> Could you test if this solve your problem ?
>=20
> Jack -
> Signed-off-by: Jack Wang <jack_wang@usish.com>
>=20
> Signed-off-by: Lindar <lindar_liu@usish.com>
> ---
>  sas_expander.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/sas_expander.c b/sas_expander.c
> index d1d86a6..f63dbea 100644
> --- a/sas_expander.c
> +++ b/sas_expander.c
> @@ -175,10 +175,10 @@ static void sas_set_ex_phy(struct domain_device=
 *dev,
> int phy_id,
>  	switch (resp->result) {
>  	case SMP_RESP_PHY_VACANT:
>  		phy->phy_state =3D PHY_VACANT;
> -		return;
> +		break;
>  	default:
>  		phy->phy_state =3D PHY_NOT_PRESENT;
> -		return;
> +		break;
>  	case SMP_RESP_FUNC_ACC:
>  		phy->phy_state =3D PHY_EMPTY; /* do not know yet */
>  		break;
> @@ -209,7 +209,8 @@ static void sas_set_ex_phy(struct domain_device *=
dev,
> int phy_id,
>  	phy->phy->negotiated_linkrate =3D phy->linkrate;
> =20
>  	if (!rediscover)
> -		sas_phy_add(phy->phy);
> +		if (sas_phy_add(phy->phy))
> +			sas_phy_free(phy->phy);
> =20
>  	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
>  		    SAS_ADDR(dev->sas_addr), phy->phy_id,
Hmm. Shouldn't you avoid the message here if you entered the error
path? I guess the SAS phy isn't actually attached then.
So maybe the above statement should read:


if (!rediscover)
        if (sas_phy_add(phy->phy)) {
                sas_phy_free(phy->phy);
		return;
	}


Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
