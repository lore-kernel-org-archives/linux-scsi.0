From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] drivers/scsi/qla2xxx: fix double free bug after firmware
 timeout
Date: Mon, 15 Jan 2018 19:58:47 +0000
Message-ID: <13B82B86-8810-4722-97F9-EC5B862ECC76@cavium.com>
References: <151603716189.28707.13105191089826357709.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151603716189.28707.13105191089826357709.stgit@rabbit.intern.cm-ag>
Content-Language: en-US
Content-ID: <0D10ED0DEBA34247A4F3CF7DEC64569C@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Max Kellermann <mk@cm4all.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "max.kellermann@gmail.com" <max.kellermann@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Max,=20

> On Jan 15, 2018, at 9:26 AM, Max Kellermann <mk@cm4all.com> wrote:
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

We have patch to prevent this double free in 4.16/scsi-queue already.=20

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3D4.=
16/scsi-queue&id=3D045d6ea200af794ba15515984cff63787a7fc3c0

Thanks,
- Himanshu
