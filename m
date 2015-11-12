From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch] hpsa: logical vs bitwise AND typo
Date: Thu, 12 Nov 2015 10:59:21 +0100
Message-ID: <1447322361.2616.10.camel@suse.de>
References: <20151112094338.GB28432@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbbKLJ7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2015 04:59:24 -0500
In-Reply-To: <20151112094338.GB28432@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Don Brace <don.brace@pmcs.com>, Scott Teel <scott.teel@pmcs.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 2015-11-12 at 12:43 +0300, Dan Carpenter wrote:
> HPSA_DIAG_OPTS_DISABLE_RLD_CACHING is a mask and bitwise AND was
> intended here instead of logical &&.=C2=A0=C2=A0This bug is essential=
ly
> harmless,
> it means that sometimes we don't print a warning message which we
> wanted
> to print.
>=20
> Fixes: c2adae44e916 ('hpsa: disable report lun data caching')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 6a8f958..a386036 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8671,7 +8671,7 @@ static void hpsa_disable_rld_caching(struct
> ctlr_info *h)
> =C2=A0	if ((rc !=3D 0)=C2=A0=C2=A0|| (c->err_info->CommandStatus !=3D=
 0))
> =C2=A0		goto errout;
> =C2=A0
> -	if (*options && HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
> +	if (*options & HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
> =C2=A0		goto out;
> =C2=A0
> =C2=A0errout:

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
