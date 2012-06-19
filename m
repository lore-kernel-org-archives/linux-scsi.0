From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] Unaligned data access in mvsas causes panic
Date: Tue, 19 Jun 2012 09:07:34 +0800
Message-ID: <3ADAB9761F3E4CF2A23696CB113ED1B4@usish.com.cn>
References: <4FDF31E2.2090305@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53194 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2FSBIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 21:08:40 -0400
In-Reply-To: <4FDF31E2.2090305@tilera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Paul Guo' <ggang@tilera.com>, linux-scsi@vger.kernel.org
Cc: 'Xiangliang Yu' <yuxiangl@marvell.com>

Paul=A3=AC

Could you also share the panic info?

Thanks.

Jack=20
> We encountered panic during stress tesing on our platform,
> due to unaligned data access in the mvsas driver.
>=20
>=20
> Signed-off-by: Paul Guo <ggang@tilera.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c |    5 +++--
>  drivers/scsi/mvsas/mv_sas.h |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.=
c
> index fd3b283..be4989e 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1852,10 +1852,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u=
32
> rx_desc, u32 flags)
>  	}
>=20
>  	/* error info record present */
> -	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
> +	if (unlikely((rx_desc & RXQ_ERR) &&
> +		     get_unaligned_le64((u64 *) slot->response))) {
>  		mv_dprintk("port %d slot %d rx_desc %X has error info"
>  			"%016llX.\n", slot->port->sas_port.id, slot_idx,
> -			 rx_desc, (u64)(*(u64 *)slot->response));
> +			 rx_desc, get_unaligned_le64((u64
*)slot->response));
>  		tstat->stat =3D mvs_slot_err(mvi, task, slot_idx);
>  		tstat->resp =3D SAS_TASK_COMPLETE;
>  		goto out;
> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.=
h
> index c04a4f5..1bc093a 100644
> --- a/drivers/scsi/mvsas/mv_sas.h
> +++ b/drivers/scsi/mvsas/mv_sas.h
> @@ -39,6 +39,7 @@
>  #include <linux/irq.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <asm/unaligned.h>
>  #include <scsi/libsas.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_tcq.h>
> --
> 1.7.10.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
