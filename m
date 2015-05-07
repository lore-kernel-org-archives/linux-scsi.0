From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Thu, 07 May 2015 09:44:19 -0400
Message-ID: <1431006259.2407.361.camel@redhat.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
	 <1430835029.2407.187.camel@redhat.com> <5548D2FF.7030501@sandisk.com>
	 <1430838637.2407.209.camel@redhat.com> <5548E155.70007@sandisk.com>
	 <1430842201.2407.226.camel@redhat.com> <5549DEEC.9050501@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Is0Gcq3KcWyCengiug39"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5549DEEC.9050501-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--=-Is0Gcq3KcWyCengiug39
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-06 at 11:29 +0200, Bart Van Assche wrote:
> Hello Doug,
>=20
> On 05/05/15 18:10, Doug Ledford wrote:
> > Be that as it may, that doesn't change what I said about posting a
> > command to a known disconnected QP.  You could just fail immediately.
> > Something like:
> >
> > if (!ch->connected) {
> > 	scmnd->result =3D DID_NO_CONNECT;
> > 	goto err;
> > }
> >
> > right after getting the channel in queuecommand would work.  That would
> > save a couple spinlocks, several DMA mappings, a call into the low leve=
l
> > driver, and a few other things.  (And I only left requeue on the table
> > because I wasn't sure how the blk_mq dealt with just a single channel
> > being down versus all of them being down)
>=20
> What you wrote above looks correct to me. However, it is intentional=20
> that such a check is not present in srp_queuecommand(). The intention=20
> was to optimize the hot path of that driver as much as possible. Hence=
=20
> the choice to post a work request on the QP even after it has been=20
> disconnected and to let the HCA generate an error completion.

Given the amount of time it takes to do all of the dma mapping in that
function on the normal hot path, I suspect the above test, especially if
you added an unlikely annotation, would not even make a blip on your
performance numbers.  In any case, it's not something I would require in
the patch.

> > But my point in all of this is that if you have a single qp between
> > yourself and the target, then any error including a qp resource error =
=3D=3D
> > path error since you only have one path.  When you have a multi queue
> > device, that's no longer true.  A transient resource problem on one qp
> > does not mean a path event (at least not necessarily, although your
> > statement below converts a QP event into a path event by virtue
> > disconnecting and reconnecting all of the QPs).  My curiosity is now
> > moot given what you wrote about tearing everything down and reconnectin=
g
> > (unless the error handling is modified to be more subtle in its
> > workings), but the original question in my mind was what happens at the
> > blk_mq level if you did have a single queue drop but not all of them an=
d
> > you weren't using multipath.
>=20
> If we want to support this without adding similar code to handle this in=
=20
> every SCSI LLD I think we need to change first how blk-mq and=20
> dm-multipath interact. Today dm-multipath is a layer on top of blk-mq.=
=20
> Supporting the above scenario properly is possible e.g. by integrating=
=20
> multipath support in the blk-mq layer. I think Hannes and Christoph have=
=20
> already started to work on this.

Ok.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-Is0Gcq3KcWyCengiug39
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVS2wzAAoJELgmozMOVy/d2HsQAKnT0AGRzHODCI2ETPk/+m6z
y7+ogcwN+vVo5JCwLSMFRjRMXYcRBgbHveiyusawvEDDZ8vWOvqS4SOWt79CVasY
Qf/s7Hf078OT1L0JzfD7xQXMAVyh4Zu4xbfzgP1cATv4kOg61eI2YHW0OgEO6Azb
IzqQMVMfZpN1pH+L3vw5SUC3t+TyVZAEbnodvEn+WG1cPBbvFz8YO1L9/NBVNtmh
YULfUa4x6/OPR2ZjG/pelBdNQLcOPm9BloOT2C1ukcidycabPN0VK74/Eiikg3Y7
6psUnHrTdz9XuQi+U402Y1YVjJGVnvN9UoR/gnMH4NbynFH4MA4GR4ysEB9ItELt
3qnUWvlue1B3HnIxrQMxorbawvgRFNUxB79tt0fGpQreCAxZ23uAGJQjfUR7OKLu
npIcCv90ELR/rveV3yaoypX/VSUMPKSDwi+jETipamnOd9pIQVNVX38nQ/yD224J
VGxBzBX6QmQ3nPAj+QmJrrDs22HX/9pt9jpw0e/fHU33dHO189TUIFOA4G2gcR1Y
JGARQlTVFs3ybctq8afAkti4eQ3M+cUjySQai4wtLeRl7brArEDp8MEJ/2D41bhl
wuGg/G3UB5l/2etiniWCVtMyabIebr+q8fYFKYZiG/G491tqQY7px7enhejbv9Vx
Y/cksfSBiWp3EBunKxZi
=psfA
-----END PGP SIGNATURE-----

--=-Is0Gcq3KcWyCengiug39--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
