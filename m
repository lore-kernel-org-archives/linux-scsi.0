From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] mvsas: always iounmap resources
Date: Fri, 12 Jun 2015 08:31:38 +0200
Message-ID: <557A7CCA.3080406@suse.de>
References: <1432286102-18184-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbbFLGbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 02:31:41 -0400
In-Reply-To: <1432286102-18184-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Ben Hutchings <ben@decadent.org.uk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 05/22/2015 11:15 AM, Johannes Thumshirn wrote:
> In case pci_resource_start() or pci_resource_len() reutrn 0, mvsas_io=
remap
> returns without doing an iounmap() of mvi->regs_ex.
>=20
> Found by the cocinelle tool.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/mvsas/mv_init.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_ini=
t.c
> index 53030b0..04a3205 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -339,8 +339,11 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, i=
nt bar_ex)
> =20
>  	res_start =3D pci_resource_start(pdev, bar);
>  	res_len =3D pci_resource_len(pdev, bar);
> -	if (!res_start || !res_len)
> +	if (!res_start || !res_len) {
> +		iounmap(mvi->regs_ex);
> +		mvi->regs_ex =3D NULL;
>  		goto err_out;
> +	}
> =20
>  	res_flag =3D pci_resource_flags(pdev, bar);
>  	if (res_flag & IORESOURCE_CACHEABLE)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
