From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] drivers: scsi: aic7xxx: Fix positive error codes.
Date: Wed, 03 Dec 2014 17:22:05 +0100
Message-ID: <547F38AD.9050103@suse.de>
References: <1417564984-6941-1-git-send-email-letshaveanadventure@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417564984-6941-1-git-send-email-letshaveanadventure@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Wilkes <letshaveanadventure@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/03/2014 01:03 AM, Jason Wilkes wrote:
> Note:
> There are more instances of the problem described below, but I
> thought I'd explain the first one in detail, to make sure it's
> worth fixing the others (and to make sure I didn't do anything
> stupid, which I may have. I'm new to this :-). Alright, here we go!
>=20
> A few drivers seem to return positive error codes internally, in
> order to signal something to a static function in the same driver.
> (see, for example, drivers/staging/lustre/lnet/lnet/lib-move.c)
> That's unusual, but seems okay as long as they're consistent between
> return codes and return code checks. However, a problem might arise
> if +ERRORCODE rather than -ERRORCODE is returned to other layers
> of the kernel (e.g., to the driver core). Let's do some exploring...
>=20
> Here's a function that returns +ENOMEM
> FILE: drivers/scsi/aic7xxx/aic7770_osm.c
> FUNC: aic7770_map_registers
>=20
> int
> aic7770_map_registers(struct ahc_softc *ahc, u_int port)
> {
> ... (clipped for brevity) ..
>=20
> 	if (!request_region(port, AHC_EISA_IOSIZE, "aic7xxx"))
> 		return (ENOMEM);
>=20
> ... (clipped for brevity) ..
> }
>=20
> This may not be a problem, unless we're passing the value
> outside the current module. So who calls this function?
> $ grep -r -C20 aic7770_map_registers
>=20
> Looks like it's only ever called in:
> FILE: drivers/scsi/aic7xxx/aic7770.c
> FUNC: aic7770_config
>=20
> int aic7770_config(struct ahc_softc *ahc, struct aic7770_identity *en=
try, u_int io)
> {
> ... (code and stuff) ...
>=20
> 	error =3D aic7770_map_registers(ahc, io);
> 	if (error !=3D 0)
> 		return (error);
>=20
> ... (code and stuff) ...
> }
>=20
> Hmm... Let's see who calls this guy.
> $ grep -r -C20 aic7770_config
>=20
> This too is only called once, in:
> FILE: drivers/scsi/aic7xxx/aic7770_osm.c
> FUNC: aic7770_probe
>=20
> static int
> aic7770_probe(struct device *dev)
> {
> ... (blah blah blah) ...
>=20
> 	error =3D aic7770_config(ahc, aic7770_ident_table + edev->id.driver_=
data,
> 			       eisaBase);
> 	if (error !=3D 0) {
> 		ahc->bsh.ioport =3D 0;
> 		ahc_free(ahc);
> 		return (error);
> 	}
>=20
> ... (blah blah blah) ...
> }
>=20
> Same deal as before. Okay, so who calls aic7770_probe?
>=20
> Well, as expected, no one calls it, at least not by name.
> It's just the .probe function in the following struct:
>=20
> FILE: drivers/scsi/aic7xxx/aic7770_osm.c
>=20
> static struct eisa_driver aic7770_driver =3D {
> 	.id_table	=3D aic7770_ids,
> 	.driver =3D {
> 		.name   =3D "aic7xxx",
> 		.probe  =3D aic7770_probe,
> 		.remove =3D aic7770_remove,
> 	}
> };
>=20
> So the return code *is* being passed to another layer of the kernel,
> in which case it should probably be negative.
>=20
> There are lots of similar examples in the same driver. I'd be happy
> to fix them up, but I thought I should send this patch first, to make
> sure I'm not doing anything obviously wrong.
>=20
> Ooh! One more thing, just to be safe. Above, I assumed that grepping
> the kernel tree would give us all the places where an identifier show=
s
> up, but maybe this driver does something clever with the preprocessor=
=2E
>=20
> $ grep -r '##' drivers/scsi/aic7xxx/ || cowsay hooray
>  ________
> < hooray >
>  --------
>         \   ^__^
>          \  (oo)\_______
>             (__)\       )\/\
>                 ||----w |
>                 ||     ||
>=20
> Okay good, so there shouldn't be any ## magic messing with our greps.
> Alright, I guess I should send this patch off now. Thanks for reading=
,
> and apologies in advance if I'm a moron :-)
>=20
> Signed-off-by: Jason Wilkes <letshaveanadventure@gmail.com>
> ---
>  drivers/scsi/aic7xxx/aic7770.c     | 2 +-
>  drivers/scsi/aic7xxx/aic7770_osm.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/aic7xxx/aic7770.c b/drivers/scsi/aic7xxx/ai=
c7770.c
> index 5000bd6..cecdea9 100644
> --- a/drivers/scsi/aic7xxx/aic7770.c
> +++ b/drivers/scsi/aic7xxx/aic7770.c
> @@ -171,7 +171,7 @@ aic7770_config(struct ahc_softc *ahc, struct aic7=
770_identity *entry, u_int io)
>  		break;
>  	default:
>  		printk("aic7770_config: invalid irq setting %d\n", intdef);
> -		return (ENXIO);
> +		return -ENXIO;
>  	}
> =20
>  	if ((intdef & EDGE_TRIG) !=3D 0)
> diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xx=
x/aic7770_osm.c
> index 3d401d0..50f030d 100644
> --- a/drivers/scsi/aic7xxx/aic7770_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7770_osm.c
> @@ -51,7 +51,7 @@ aic7770_map_registers(struct ahc_softc *ahc, u_int =
port)
>  	 * Lock out other contenders for our i/o space.
>  	 */
>  	if (!request_region(port, AHC_EISA_IOSIZE, "aic7xxx"))
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	ahc->tag =3D BUS_SPACE_PIO;
>  	ahc->bsh.ioport =3D port;
>  	return (0);
> @@ -87,10 +87,10 @@ aic7770_probe(struct device *dev)
>  	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
>  	name =3D kstrdup(buf, GFP_ATOMIC);
>  	if (name =3D=3D NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	ahc =3D ahc_alloc(&aic7xxx_driver_template, name);
>  	if (ahc =3D=3D NULL)
> -		return (ENOMEM);
> +		return -ENOMEM;
>  	error =3D aic7770_config(ahc, aic7770_ident_table + edev->id.driver=
_data,
>  			       eisaBase);
>  	if (error !=3D 0) {
>=20
Looks okay so far, but have you validated all callers to ensure they
use the new syntax?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
