From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Thu, 26 Feb 2004 16:56:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227005601.GA6127@one-eyed-alien.net>
References: <1077842444.2662.123.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:36017 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261677AbUB0A4H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 19:56:07 -0500
Content-Disposition: inline
In-Reply-To: <1077842444.2662.123.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Ben Collins <bcollins@debian.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

My only concern with something like this is the userspace race problem.
i.e the following sequence of events:

(1) User uses cdrecord -scanbus to locate their device (host:bus:dev:lun)
(2) HBA is disconnected=20
(3) New HBA is added
(4) User issues command to host:bus:dev:lun, and addresses the wrong device

While the current system doesn't prevent this, it makes it a much more
difficult situation to happen.

Matt

On Thu, Feb 26, 2004 at 06:40:43PM -0600, James Bottomley wrote:
> I'm forwarding this to linux-scsi, which is the appropriate list to
> scrutinise it.
>=20
> James
>=20

> Date: Thu, 26 Feb 2004 18:54:12 -0500
> From: Ben Collins <bcollins@debian.org>
> Subject: [BK PATCH] SCSI host num allocation improvement
> To: James Bottomley <James.Bottomley@steeleye.com>
> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
> X-Spam-Status: No, hits=3D-5.9 required=3D5.0
> 	tests=3DBAYES_20,PATCH_UNIFIED_DIFF,USER_AGENT_MUTT autolearn=3Dham vers=
ion=3D2.55
>=20
> After doing a large round of debugging and fixups for ieee1394, I
> started getting really aggrivated with the way that the scsi layer
> allocates host numbers by forever incrementing from the last one.
>=20
> Before too long, I was getting scsi137, etc. Not only did it look bad,
> it was bad. Cdrecord only scans bus 0-15, which means after a few
> hotplugs with your USB or Firewire CD/DVD recorder, you wont be able to
> burn to it. Yes, I know cdrecord needs to be fixed aswell, but I've had
> my fill of trying to convince the author of anything, so I wont be
> sending him a patch.
>=20
> Anyway, this patch enables a race free (I hope) allocation of host
> numbers. And it will pick the lowest available number first. I've only
> tested it with ieee1394 sbp2, so real scsi users should give it a go.
>=20
>=20
> You can import this changeset into BK by piping this whole message to:
> '| bk receive [path to repository]' or apply the patch as usual.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> ChangeSet@1.1589, 2004-02-26 18:40:58-05:00, bcollins@debian.org
>   [SCSI]: Add a scsi_alloc_host_num function for race free, and non-incre=
mental host ids
>=20
>=20
>  hosts.c |   44 ++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 40 insertions(+), 4 deletions(-)
>=20
>=20
> diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> --- a/drivers/scsi/hosts.c	Thu Feb 26 18:52:00 2004
> +++ b/drivers/scsi/hosts.c	Thu Feb 26 18:52:00 2004
> @@ -38,9 +38,6 @@
>  #include "scsi_logging.h"
> =20
> =20
> -static int scsi_host_next_hn;		/* host_no for next new host */
> -
> -
>  static void scsi_host_cls_release(struct class_device *class_dev)
>  {
>  	put_device(&class_to_shost(class_dev)->shost_gendev);
> @@ -166,6 +163,38 @@
>  	kfree(shost);
>  }
> =20
> +static DECLARE_MUTEX(host_num_lock);
> +/**
> + * scsi_host_num_alloc - allocate a unique host number for a scsi host.
> + *
> + * Note:
> + *      Must hold host_num_lock when calling this, and continue holding =
it
> + *      till after the host is added to the shost_class.
> + *
> + * Return value:
> + *      A unique host number.
> + **/
> +static int scsi_host_num_alloc(void)
> +{
> +	int host_num =3D 0;
> +	struct class *class =3D &shost_class;
> +	struct class_device *cdev;
> +	struct Scsi_Host *shost;
> +
> +	down_read(&class->subsys.rwsem);
> +next_host_num_try:
> +	list_for_each_entry(cdev, &class->children, node) {
> +		shost =3D class_to_shost(cdev);
> +		if (shost->host_no =3D=3D host_num) {
> +			host_num++;
> +			goto next_host_num_try;
> +		}
> +	}
> +	up_read(&class->subsys.rwsem);
> +
> +	return host_num;
> +}
> +
>  /**
>   * scsi_host_alloc - register a scsi host adapter instance.
>   * @sht:	pointer to scsi host template
> @@ -214,7 +243,6 @@
> =20
>  	init_MUTEX(&shost->scan_mutex);
> =20
> -	shost->host_no =3D scsi_host_next_hn++; /* XXX(hch): still racy */
>  	shost->dma_channel =3D 0xff;
> =20
>  	/* These three are default values which can be overridden */
> @@ -263,6 +291,12 @@
>  	if (rval)
>  		goto fail_kfree;
> =20
> +	/* Hold this lock until after we've added this to the scsi_host
> +	 * class, to avoid race condititons with the host number
> +	 * allocation scheme. */
> +	down(&host_num_lock);
> +	shost->host_no =3D scsi_host_num_alloc();
> +
>  	device_initialize(&shost->shost_gendev);
>  	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
>  		shost->host_no);
> @@ -273,6 +307,8 @@
>  	shost->shost_classdev.class =3D &shost_class;
>  	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
>  		  shost->host_no);
> +
> +	up(&host_num_lock);
> =20
>  	shost->eh_notify =3D &complete;
>  	rval =3D kernel_thread(scsi_error_handler, shost, 0);
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> This BitKeeper patch contains the following changesets:
> 1.1589
> ## Wrapped with gzip_uu ##
>=20
>=20
> M'XL( *"&/D   [56:V_;-A3]+/Z*"Q3('">6J*<=3D!0[2)<$6;-V"9 $&=3D(5!
> MDTQ$1*8RDK(;S/WO(ZG*>=3D1ML:*3!4BZO(]S[SF4_ JN-5=3DE,*=3D-70NIT2OX
> MN=3D&F#!B?"R+#1MU:TV736%/4:A5I1:,[KB2O(^O?OA\E88&LRP4QM((E5[H,
> MXC#=3D6,S#/2^#R[.?KG]]?8G0=3D HG%9&W_(H;F$Z1:=3D22U$P?$U/5C0R-(E(O
> MN"$A;1;KC>LZP3BQOSP>IS@OUG&!L_&:QBR.219SAI-L4F2(D25?''?PPOG=3D
> M7!@=3D2AO]+$^&DR3&*4[B\3K/\GB"3B$.XWQR #B+<!(E!<23,L-E/AGAO,08
> M^ND</TX%]F(88?0C?-\.3A"%MU<G5^?O2GC-&!#05(L9J>N&SBK+S$RV"[AI
> M)36BD7#3*%"$<KA1G.\#D0QD(T=3D"4L477!I2@PL"P33Z!?(,CS&Z>&0 C?[C
> M@1 F&!U]I6FFA!-"Y*!'KKX.Z9/^,XSMY).DR-9S/)GS<4YRRT:6L*V3_FPZ
> M1V21I.E!DJ]3'"=3DC+Z]MWE]7VK=3D#1N3N?G'<:%8[L&_[,N\^FS*-DQ3C/,^L
> M_I(TCC.OOX/Q,_6E!V62?TE]&891]K_([[O+KN/F=3DQBIE3^MC"ZVTO0-<CS-
> M8DC1>5Q,($V0-L0("J=3DG)_9E<S9[<_W'V9^#'O[,]G*W>XBBX1#!L&MPL^8[
> MA1'X*S'<3J"5XN^6=3DXU8ESE7ON]N--X<VCPNU6^-X:6[\<>;U@943<W@6658
> M55P")8[*6S"5T-W@:".-?9%R'^*6A-FD,J*N@=3DP86]I4'Z$(#80QSBSSWJA]
> M%5H3K7L\E]RT2H+51?L$U^LM';F(8=3D3/34BS;2R#92/8+OH'!<YAHX8IX$,4
> M:*-::L#7AV%WF<+.$U0OG&:,+X65SI#:F\>U*U?7?7I@Z&,/T5\H8,U*SA0G
> M;+#C8T=3D'NIWK!QVJE>8+RZ7D[\TC6J,>2A34PCY:IF:<T&IFU:@>!J[6/O1)
> M:"5JIKC<MZIE?!=3DL9X$O:I%W&$TS\P8?:.L$@;B!@3>-CKIZC7VI;(;1Y0CZ
> MQ[T]%Q+<-I:C3R"ZI0_(G>W]%YNS U =3DDWWX(?I@K:?VRP4Q.D^*' H41$/[
> MR;9J<Y("K[36*JK7S8K_L.2]8IQ'+YN>9Q18@7@ ^VZ-.+*[S6V5R801II$:
> M5L)4CQKLQ.,C/VX8]U;0M+*[/P0K*,_<8.?EU@M>3G"KW'SKY\DXA\3-H+W_
> <--'F[X4M2>]TNYBFN#@@\W&!_@4R$Z&RT@@    =20
> =20
>=20
> --=20
> Debian     - http://www.debian.org/
> Linux 1394 - http://www.linux1394.org/
> Subversion - http://subversion.tigris.org/
> WatchGuard - http://www.watchguard.com/


--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I don't have a left mouse button.  I only have one mouse and it's on my rig=
ht.
					-- Customer
User Friendly, 2/13/1999

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAPpWhIjReC7bSPZARAv4gAJ9Zk7ZcHEiUxsYu+U/HW7vrspTOugCgpkDn
H5pJCfYUPZVE/fgRWvDeroc=
=+KgJ
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
