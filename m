From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bfa: fix leak of bfad_im_port_index on module unload
Date: Fri, 12 Jun 2015 17:09:57 +0200
Message-ID: <20150612150957.GA18918@c203.arch.suse.de>
References: <1434063045-17480-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbFLPKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 11:10:06 -0400
Content-Disposition: inline
In-Reply-To: <1434063045-17480-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

On Fri, Jun 12, 2015 at 01:50:45AM +0300, Alexey Khoroshilov wrote:
> Resources allocated within bfad_im_port_index idr are not deallocated
> on module unload. The patch adds idr_destroy() in exit function.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/scsi/bfa/bfad_im.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 7223b0006740..8367c11d554b 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -851,6 +851,8 @@ bfad_im_module_exit(void)
> =20
>  	if (bfad_im_scsi_vport_transport_template)
>  		fc_release_transport(bfad_im_scsi_vport_transport_template);
> +
> +	idr_destroy(&bfad_im_port_index);
>  }
> =20
>  void
> --=20
> 1.9.1
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
