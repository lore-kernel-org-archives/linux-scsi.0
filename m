From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] drivers/scsi/qla2xxx: fix double free bug after firmware
 timeout
Date: Thu, 7 Dec 2017 20:38:23 +0000
Message-ID: <F250F948-C720-4D0C-8DCC-329E9FB6B1CA@cavium.com>
References: <151265800413.23884.12590131670697249849.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:58678
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750929AbdLGUi2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Dec 2017 15:38:28 -0500
In-Reply-To: <151265800413.23884.12590131670697249849.stgit@rabbit.intern.cm-ag>
Content-Language: en-US
Content-ID: <CFBF29B51A712144A79F640BA10D33C5@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Max Kellermann <mk@cm4all.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "max.kellermann@gmail.com" <max.kellermann@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Max,

> On Dec 7, 2017, at 6:46 AM, Max Kellermann <mk@cm4all.com> wrote:
>=20
> When the qla2xxx firmware is unavailable, eventually
> qla2x00_sp_timeout() is reached, which calls the timeout function and
> frees the srb_t instance.
>=20
> The timeout function always resolves to qla2x00_async_iocb_timeout(),
> which invokes another callback function called "done".  All of these
> qla2x00_*_sp_done() callbacks also free the srb_t instance; after
> returning to qla2x00_sp_timeout(), it is freed again.
>=20
> The fix is to remove the "sp->free(sp)" call from qla2x00_sp_timeout()
> and add it to those code paths in qla2x00_async_iocb_timeout() which
> do not already free the object.
>=20
> This is how it looks like with KASAN:
>=20
> BUG: KASAN: use-after-free in qla2x00_sp_timeout+0x228/0x250
> Read of size 8 at addr ffff88278147a590 by task swapper/2/0
>=20
> Allocated by task 1502:
>  save_stack+0x33/0xa0
>  kasan_kmalloc+0xa0/0xd0
>  kmem_cache_alloc+0xb8/0x1c0
>  mempool_alloc+0xd6/0x260
>  qla24xx_async_gnl+0x3c5/0x1100
>=20
> Freed by task 0:
>  save_stack+0x33/0xa0
>  kasan_slab_free+0x72/0xc0
>  kmem_cache_free+0x75/0x200
>  qla24xx_async_gnl_sp_done+0x556/0x9e0
>  qla2x00_async_iocb_timeout+0x1c7/0x420
>  qla2x00_sp_timeout+0x16d/0x250
>  call_timer_fn+0x36/0x200
>=20
> The buggy address belongs to the object at ffff88278147a440
>  which belongs to the cache qla2xxx_srbs of size 344
> The buggy address is located 336 bytes inside of
>  344-byte region [ffff88278147a440, ffff88278147a598)
>=20
> Signed-off-by: Max Kellermann <mk@cm4all.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index b5b48ddca962..801890564e00 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -58,7 +58,6 @@ qla2x00_sp_timeout(unsigned long __data)
> 	req->outstanding_cmds[sp->handle] =3D NULL;
> 	iocb =3D &sp->u.iocb_cmd;
> 	iocb->timeout(sp);
> -	sp->free(sp);
> 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
> }
>=20
> @@ -121,9 +120,11 @@ qla2x00_async_iocb_timeout(void *data)
> 		ea.data[1] =3D lio->u.logio.data[1];
> 		ea.sp =3D sp;
> 		qla24xx_handle_plogi_done_event(fcport->vha, &ea);
> +		sp->free(sp);
> 		break;
> 	case SRB_LOGOUT_CMD:
> 		qlt_logo_completion_handler(fcport, QLA_FUNCTION_TIMEOUT);
> +		sp->free(sp);
> 		break;
> 	case SRB_CT_PTHRU_CMD:
> 	case SRB_MB_IOCB:
>=20


NACK

These calls are asynchronous calls and free should be called by completion.

I am going to send updates to driver which we have fixed similar issue for =
4.16

Thanks,
- Himanshu
