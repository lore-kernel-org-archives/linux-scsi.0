From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] scsi: virtio_scsi: Use struct_size() helper
Date: Mon, 1 Jul 2019 16:21:48 +0100
Message-ID: <20190701152148.GG11900@stefanha-x1.localdomain>
References: <20190619192833.GA825@embeddedor>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619192833.GA825@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2019 at 02:28:33PM -0500, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>=20
> struct virtio_scsi {
> 	...
>         struct virtio_scsi_vq req_vqs[];
> };
>=20
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
>=20
> So, replace the following form:
>=20
> sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues
>=20
> with:
>=20
> struct_size(vscsi, req_vqs, num_queues)
>=20
> This code was detected with the help of Coccinelle.
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/scsi/virtio_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0aJQwACgkQnKSrs4Gr
c8hU0wf/SEM8YCmD62jJAJNbhuuxbgPPdSmJV/Oh3RzqiM/ujaeDjX1Msi+8fFbR
NlE7Cr9xEkGuEacjWbl+MNio761nAUo5Ibln9uws3BTpnHClVohmaat2RfuRyoB5
0O1FC55L1Gj8+/RaRoZAO3gld6TM5+KFuptuYN4kOl9/DJDSbjoGX11dFtyL6Jut
mSdjs07Koh+Uxt+2/gIEoflBy6tr8nbOIpIb0qI9Y+4iYXUFPvRqDhqnZ1TezcWE
T4lWINqg4FuT+MMmCAyk8KLhj9FVKLMG7mCRT/R+emhi2yTwyMwvKLYeMW0uikUQ
2NfsNT8OZBYFNEdUzjeCiw4Mg8f99A==
=FseJ
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
