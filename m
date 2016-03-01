From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] qlogicpti: Return correct error code
Date: Tue, 1 Mar 2016 19:59:17 +0800
Message-ID: <56D58415.5090407@suse.de>
References: <20160217133254.GA31334@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160217133254.GA31334@amitoj-Inspiron-3542>
Sender: linux-kernel-owner@vger.kernel.org
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>, JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

On 02/17/2016 09:32 PM, Amitoj Kaur Chawla wrote:
> The return value of of_ioremap on failure should be -ENODEV and not
> -1.
>=20
> Found using Coccinelle. A simplified version of the semantic patch
> used is:
>=20
> //<smpl>
> @@
> expression *e;
> @@
>=20
> e =3D of_ioremap(...);
> if (e =3D=3D NULL) {
> ...
> return
> - -1
> + -ENODEV
> ;
> }
> //</smpl>
>=20
> The single call site only checks that the return value is less than 0=
,
> hence no change is required at the call site.
>=20
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
> ---
>  drivers/scsi/qlogicpti.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index 676385f..69bfc0a 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -710,7 +710,7 @@ static int qpti_map_regs(struct qlogicpti *qpti)
>  				 "PTI Qlogic/ISP");
>  	if (!qpti->qregs) {
>  		printk("PTI: Qlogic/ISP registers are unmappable\n");
> -		return -1;
> +		return -ENODEV;
>  	}
>  	if (qpti->is_pti) {
>  		qpti->sreg =3D of_ioremap(&op->resource[0], (16 * 4096),
> @@ -718,7 +718,7 @@ static int qpti_map_regs(struct qlogicpti *qpti)
>  					"PTI Qlogic/ISP statreg");
>  		if (!qpti->sreg) {
>  			printk("PTI: Qlogic/ISP status register is unmappable\n");
> -			return -1;
> +			return -ENODEV;
>  		}
>  	}
>  	return 0;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
