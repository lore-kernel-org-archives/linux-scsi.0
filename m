From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 19:11:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087837874.6751.3.camel@laptop.fenrus.com>
References: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LxVGpQ7noi5zklhAoowK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:9106 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266329AbUFURLZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:11:25 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com


--=-LxVGpQ7noi5zklhAoowK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-06-21 at 18:16, Moore, Eric Dean wrote:
> All,
>=20
> We are pleased to announce the MPT Fusion release candidate for lk 2.6
>=20
> This driver incorporates the patches from Christoph Hellwig, Jeremy Higdo=
n,
> and Masao Fukuchi.
>=20
> Changelog of this release:
>  - merged code from lk 2.4 MPT Fusion driver(from versions 2.05.13 to
> 2.05.16)
>=20
> * Patch from Masao Fukuchi
>  - Remove limit on number of support hosts=20
>=20
> * Patch from Christoph Hellwig
>  - kill scsi_to_pci_dma_dir usage, both pci and scsi use the same bits
>  - kill mptscsih_io_direction and always trust the midlayer
>  - kill usage of Scsi_Foo typedefs
>  - use <scsi/*.h> headers
>  - avoid list search in fusion ->proc_info
>=20
> * Patch from Jeremy Higdon
>  - Add readX_relaxed to MPT Fusion driver
>=20
> The patch for lk 2.6.6 and the driver is available at
>=20
> ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01=
.09

+       list_for_each(p, &ioc_list) {
+               i =3D list_entry(p, MPT_ADAPTER, list);

should use list_for_each_entry()

+       /* wait 100 msec */
+       if (sleepFlag =3D=3D CAN_SLEEP) {
+               set_current_state(TASK_INTERRUPTIBLE);
+               schedule_timeout(100 * HZ / 1000);
+       } else {
+               mdelay (100);
+       }
+

that's a bug, has to be UNINTERRUPTIBLE for sure
-static int mptctl_do_mpt_command (struct mpt_ioctl_command karg, void
__user *mfPtr);
-static int mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t
fwlen);
+static int mptctl_do_mpt_command (struct mpt_ioctl_command karg, char
*mfPtr, int local);
+static int mptctl_do_fw_download(int ioc, char *ufwbuf, size_t fwlen);
=20

you're backing out all __user annotations, that's a bad idea. Those are
there for a reason.




--=-LxVGpQ7noi5zklhAoowK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA1xayxULwo51rQBIRAhvYAKCaP8WNVj0Mhpi4efw/uO/KG64NIwCghWaq
e0J4u38YQtBNPQ1csUVfp3g=
=X+lx
-----END PGP SIGNATURE-----

--=-LxVGpQ7noi5zklhAoowK--

