From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aic94xx: Fixup compilation warning
Date: Mon, 24 Nov 2014 16:55:30 +0100
Message-ID: <547354F2.40106@suse.de>
References: <1415085059-127936-1-git-send-email-hare@suse.de>	 <20141124134014.GA22128@infradead.org> <1416843568.2194.3.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbaKXPzc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 10:55:32 -0500
In-Reply-To: <1416843568.2194.3.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/24/2014 04:39 PM, James Bottomley wrote:
> On Mon, 2014-11-24 at 05:40 -0800, Christoph Hellwig wrote:
>> Can someone review this trivial patch for me?  Thanks!
>=20
> I don't really think we need reviewers for trivial patches, do we?
>=20
> However, the patch is clearly bogus. What's supposed to happen is tha=
t
> the unset variables (size and offs) get initialised to default values=
 on
> error return, which is what's missing for offset, so this is the corr=
ect
> patch, isn't it?
>=20
> James
>=20
> ---
> diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94x=
x/aic94xx_sds.c
> index edb43fd..d11b4d7 100644
> --- a/drivers/scsi/aic94xx/aic94xx_sds.c
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c
> @@ -1003,6 +1003,7 @@ static int asd_process_ctrl_a_user(struct asd_h=
a_struct *asd_ha,
>  		}
> =20
>  		size =3D sizeof(struct asd_ctrla_phy_settings);
> +		offs =3D 0;
>  		ps =3D &dflt_ps;
>  	}
> =20
>=20
Yep, that would work, as well.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
