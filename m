From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v2] scsi: virtio-scsi: Fix address translation failure
 of HighMem pages used by sg list
Date: Wed, 25 Jul 2012 13:21:36 +0100
Message-ID: <1343218896.5132.135.camel@deadeye.wl.decadent.org.uk>
References: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-E7ZUT59P+n/hOBFqt6d/"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Sen <senwang@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-E7ZUT59P+n/hOBFqt6d/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-25 at 20:13 +0800, Wang Sen wrote:
> When using the commands below to write some data to a virtio-scsi LUN of =
the
> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will c=
rash.
>=20
>         # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>         # sudo mount /dev/sdb /mnt
>         # dd if=3D/dev/zero of=3D/mnt/file bs=3D1M count=3D1024
>=20
> In current implementation, sg_set_buf is called to add buffers to sg list=
 which
> is put into the virtqueue eventually. But if there are some HighMem pages=
 in
> table->sgl you can not get virtual address by sg_virt. So, sg_virt(sg_ele=
m) may
> return NULL value. This will cause QEMU exit when virtqueue_map_sg is cal=
led
> in QEMU because an invalid GPA is passed by virtqueue.
>=20
> I take Paolo's solution mentioned in last thread to avoid failure on hand=
ling=20
> flag bits.
>=20
> I have tested the patch on my workstation. QEMU would not crash any more.
>
> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
[...]

This is not the correct way to submit a change for stable.  See
Documentation/stable_kernel_rules.txt.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-E7ZUT59P+n/hOBFqt6d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUA/k0Oe/yOyVhhEJAQqevQ/7BBoIlTCoezJwmbc9Jcp90m7pJsn8vT0/
LdzINmhy1dyVinAFtY+LPph4+AkOIQe+FfggSBUDO0ecK8mH0abyjb8sXisaJOEv
hUXuAwFzpSELAuhjEfpJikRLQNInzEzNlwPJt01yCyxO5+Vv4bHvEsx8KrfNulyg
k529FacSeYB8ACQrbzeBI9ZIpTO3En1IcBESDBLA8TCnVRXT1F3NSowrjDwc4yQQ
ERxlTb7IWOjVSZPVYnTr/T/CA/CT5sT8kRF4QGcDxLH/76hCOf0Uznff/OPEo5fG
0WS7VmJ0YajlYwoV6kJditq3tZSyP7NlDRuml04k4zYtgki2VMj02Es/ep6yv6O6
tWYB2tjgCwyzXruGp4KkgQCrJm85g1m5M8rY8LFtwv43s1SRkoDm4gK+UmzO3bpJ
xorLxIafiNIOjkY6pV2RBwucw4FHYFdxj93Vu07LjYCpVrdwP/eotFhKjuzWqlBF
wJAnjkfmBN8dmBAbdIEUzHyVabIjaOH+toqeZGM/RFP+9IM3k+srgm9EPqMlmz/l
wD6U8HiITheYbIKSRZ5BJZwULS1/UIgLqr4AmAbhMDtK40YAxBmkFhkHye2a3vPq
Ca85eGLwscZirlkJpO6k5jfHzWMT0MKYl2cpqVB+eruUCg3KtUKt/h3ojZs+hsUM
5LXOXirF2vM=
=z1xk
-----END PGP SIGNATURE-----

--=-E7ZUT59P+n/hOBFqt6d/--
