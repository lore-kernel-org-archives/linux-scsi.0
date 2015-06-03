From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build failure after merge of the target-updates tree
Date: Wed, 03 Jun 2015 13:00:39 -0700
Message-ID: <1433361639.2251.111.camel@HansenPartnership.com>
References: <20150603181607.70cef830@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5iJM2+aM+xyFlD2j6c1Z"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150603181607.70cef830@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-5iJM2+aM+xyFlD2j6c1Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-03 at 18:16 +1000, Stephen Rothwell wrote:
> Hi Nicholas,
>=20
> After merging the target-updates tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/target/target_core_fabric_lib.c: In function 'target_get_pr_trans=
port_id_len':
> drivers/target/target_core_fabric_lib.c:364:7: error: 'SCSI_PROTOCOL_FCP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_FCP:
>        ^
> drivers/target/target_core_fabric_lib.c:364:7: note: each undeclared iden=
tifier is reported only once for each function it appears in
> drivers/target/target_core_fabric_lib.c:365:7: error: 'SCSI_PROTOCOL_SBP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SBP:
>        ^
> drivers/target/target_core_fabric_lib.c:366:7: error: 'SCSI_PROTOCOL_SRP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SRP:
>        ^
> drivers/target/target_core_fabric_lib.c:367:7: error: 'SCSI_PROTOCOL_SAS'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SAS:
>        ^
> drivers/target/target_core_fabric_lib.c:369:7: error: 'SCSI_PROTOCOL_ISCS=
I' undeclared (first use in this function)
>   case SCSI_PROTOCOL_ISCSI:
>        ^
> drivers/target/target_core_fabric_lib.c: In function 'target_get_pr_trans=
port_id':
> drivers/target/target_core_fabric_lib.c:388:7: error: 'SCSI_PROTOCOL_SAS'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SAS:
>        ^
> drivers/target/target_core_fabric_lib.c:390:7: error: 'SCSI_PROTOCOL_SBP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SBP:
>        ^
> drivers/target/target_core_fabric_lib.c:392:7: error: 'SCSI_PROTOCOL_SRP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SRP:
>        ^
> drivers/target/target_core_fabric_lib.c:394:7: error: 'SCSI_PROTOCOL_FCP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_FCP:
>        ^
> drivers/target/target_core_fabric_lib.c:396:7: error: 'SCSI_PROTOCOL_ISCS=
I' undeclared (first use in this function)
>   case SCSI_PROTOCOL_ISCSI:
>        ^
> drivers/target/target_core_fabric_lib.c: In function 'target_parse_pr_out=
_transport_id':
> drivers/target/target_core_fabric_lib.c:411:7: error: 'SCSI_PROTOCOL_SAS'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SAS:
>        ^
> drivers/target/target_core_fabric_lib.c:418:7: error: 'SCSI_PROTOCOL_SBP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SBP:
>        ^
> drivers/target/target_core_fabric_lib.c:419:7: error: 'SCSI_PROTOCOL_SRP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_SRP:
>        ^
> drivers/target/target_core_fabric_lib.c:420:7: error: 'SCSI_PROTOCOL_FCP'=
 undeclared (first use in this function)
>   case SCSI_PROTOCOL_FCP:
>        ^
> drivers/target/target_core_fabric_lib.c:423:7: error: 'SCSI_PROTOCOL_ISCS=
I' undeclared (first use in this function)
>   case SCSI_PROTOCOL_ISCSI:
>        ^
>=20
> Caused by commit 2650d71e244f ("target: move transport ID handling to
> the core") interacting with commit ba929992522b ("target: Minimize SCSI
> header #include directives") from the scsi tree.
>=20
> I have added this merge fix patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 3 Jun 2015 18:10:46 +1000
> Subject: [PATCH] target: explicitly include scsi_proto.h in target_core_f=
abric_lib.c
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/target/target_core_fabric_lib.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/tar=
get_core_fabric_lib.c
> index b05578b5b4a0..cb6497ce4b61 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -35,6 +35,8 @@
>  #include <linux/spinlock.h>
>  #include <linux/export.h>
> =20
> +#include <scsi/scsi_proto.h>
> +
>  #include <target/target_core_base.h>
>  #include <target/target_core_fabric.h>

OK, this gives us a cross tree dependency on the SCSI header split
patches.  Nic, if you base your tree off this commit in mine, I'll make
sure to push early in the merge window.

commit ba929992522b6d1f866b7021bc50da66f8fdd743
Author: Bart Van Assche <bart.vanassche@sandisk.com>
Date:   Fri May 8 10:11:12 2015 +0200

    target: Minimize SCSI header #include directives

James


--=-5iJM2+aM+xyFlD2j6c1Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJVb1znAAoJEDeqqVYsXL0M41wIALWvkRz/dLWChQNirxhvmYYd
UXXk5Uwn+Vl2OAV//WRTYX1AYLC9XtaXSF5yMxqty3oFMQQV6DjpOp+4D/5SKUMK
T8y+QOAJc3oM9ZW20HYZgVAdbLWsjE70yBindjRJmPzIa2u0ZhiEfn4uavEHHIa7
4BB1riujEBC/mN/BjGhhX3/sPoKTmVgCdozGk3eRnYnUqZ8AEQIgztFdcWJjqxZE
xgFAFviHj1BsDxIDOmGxIJ1iTn0DWgGLzRdobiftRJfnTfIpp3g0WgobqA6q0HaL
J0yqko2HEbE5tu9BpTm7Do/n64hkxgLLC0i7BlLishlZ3/Zshjd5YS2nHc18lZM=
=dAsi
-----END PGP SIGNATURE-----

--=-5iJM2+aM+xyFlD2j6c1Z--
