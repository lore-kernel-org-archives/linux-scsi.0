From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 06/17] Update the infiniband uverbs driver to use idr
 helper functions.
Date: Wed, 16 Sep 2015 14:39:45 -0400
Message-ID: <55F9B771.2010302@redhat.com>
References: <cover.1442263513.git.lduncan@suse.com>
 <da24a58bf9766c2cf1d2fe4019c9efc586306a9c.1442263513.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xOElKsse9wOBfLotNkVoI2d6fcEktrU9m"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <da24a58bf9766c2cf1d2fe4019c9efc586306a9c.1442263513.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xOElKsse9wOBfLotNkVoI2d6fcEktrU9m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 01:50 PM, Lee Duncan wrote:
> Signed-off-by: Lee Duncan <lduncan@suse.com>

Looks OK to me.  The setting of uobj->id is no longer under the lock,
but we won't succeed at an idr lookup until it is set, which means it
won't be found and can't be used in idr_remove_uobj() until after the
uobj->id is set regardless of the lock.

Acked-by: Doug Ledford <dledford@redhat.com>

> ---
>  drivers/infiniband/core/uverbs_cmd.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
> index bbb02ffe87df..1e5b2a66a501 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -120,24 +120,16 @@ static int idr_add_uobj(struct idr *idr, struct i=
b_uobject *uobj)
>  {
>  	int ret;
> =20
> -	idr_preload(GFP_KERNEL);
> -	spin_lock(&ib_uverbs_idr_lock);
> -
> -	ret =3D idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
> +	ret =3D idr_get_index(idr, &ib_uverbs_idr_lock, uobj);
>  	if (ret >=3D 0)
>  		uobj->id =3D ret;
> =20
> -	spin_unlock(&ib_uverbs_idr_lock);
> -	idr_preload_end();
> -
>  	return ret < 0 ? ret : 0;
>  }
> =20
>  void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
>  {
> -	spin_lock(&ib_uverbs_idr_lock);
> -	idr_remove(idr, uobj->id);
> -	spin_unlock(&ib_uverbs_idr_lock);
> +	idr_put_index(idr, &ib_uverbs_idr_lock, uobj->id);
>  }
> =20
>  static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--xOElKsse9wOBfLotNkVoI2d6fcEktrU9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+bdxAAoJELgmozMOVy/dyVYP+gPNFqcV7CUGlV9YodGYM7wt
Fco3DHGmXf2b35kaVyVo6MBfKo+FDMH7CzyYC/dglOI7uUnaPmsBo+DDFKaCTkEA
RgU6rREL0ZTU+gQaetVN9FHbGP+q2sayIXFDcaZdrb3zCxQQrD41ped1VhD6as+c
7qoFS8RqVNQQNCKEo70lfjEz+8TY3bWVBkNB7YygT00r9DqztvRdRBsnZW36O5l+
R2gWxSFXeM0qLFSweW21vSsDLcqWkKcwxIBzT7hy6MG5XaW0VepyvhpfosDwzECB
Cr2BmveFDb04l84Wc9bHD+fzekkR48Ti90lTKolyWTV95lfrujiVDdeFfHEq53oy
hQDtdf5lEW7vrTM90ty4s0+HtERFUIqXjbwheq1LV/jR+/gVWMXX/By+r1whx+PA
U5DryXZZ3J22X+KqaTrk5athua2U5iyjQ5DMGAytZYUivAul1IAUZdzNDlJzFGdm
WZBbdsvPSp4DZfcuX7VzaO1UJ2a6XzixQpqytTpIOQk5UFScemSuULnodMsVSNB7
HudLkhGUihda7CDy9WSb1TgnmkEYSpAr7tAQBGwYUZq3K4jlegv67zFn+kEew6GQ
nITG8hl48YYHmNHteKbYGJH5TpD9itE02bJkCCgT4zFgSkRgjccXxcwdOaKrNY1D
FU8rC8iVSW/AxOF0+690
=K57E
-----END PGP SIGNATURE-----

--xOElKsse9wOBfLotNkVoI2d6fcEktrU9m--
