From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [CHECKER] Probable security holes in 2.6.5
Date: Mon, 19 Apr 2004 14:15:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040419191540.GE24871@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:6070 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261735AbUDSTRQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 15:17:16 -0400
Received: from lists.us.dell.com (localhost.localdomain [127.0.0.1])
	by lists.us.dell.com (8.12.10/8.12.10/Dell.IT.3.31.03) with ESMTP id i3JJFe8o000615
	for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2004 14:15:40 -0500
Received: (from mdomsch@localhost)
	by lists.us.dell.com (8.12.10/8.12.10/Submit) id i3JJFeoj000613
	for linux-scsi@vger.kernel.org; Mon, 19 Apr 2004 14:15:40 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Forwarding to linux-scsi.

----- Forwarded message from Chris Wright <chrisw@osdl.org> -----

Date: Mon, 19 Apr 2004 12:09:08 -0700
From: Chris Wright <chrisw@osdl.org>
To: Ken Ashcraft <ken@coverity.com>
Cc: linux-kernel@vger.kernel.org, mc@cs.stanford.edu,
        linux-aacraid-devel@dell.com
Subject: Re: [CHECKER] Probable security holes in 2.6.5
In-Reply-To: <1082134916.19301.7.camel@dns.coverity.int>; from ken@coverity=
.com on Fri, Apr 16, 2004 at 10:01:57AM -0700

> [BUG]
> /home/kash/linux/linux-2.6.5/drivers/scsi/aacraid/commctrl.c:419:aac_send=
_raw_srb: ERROR:TAINT: 413:419:Passing unbounded user value "fibsize" as ar=
g 2 to function "copy_from_user", which uses it unsafely in model [SOURCE_M=
ODEL=3D(lib,copy_from_user,user,taintscalar)] [SINK_MODEL=3D(lib,copy_from_=
user,user,trustingsink)]  [MINOR] [CAPABILTY] [PATH=3D]=20
> 	}
> 	fib_init(srbfib);
>=20
> 	srbcmd =3D (struct aac_srb*) fib_data(srbfib);
>=20
> Start --->
> 	if(copy_from_user((void*)&fibsize,
> (void*)&user_srb->count,sizeof(u32))){
> 		printk(KERN_DEBUG"aacraid: Could not copy data size from user\n");=20
> 		rcode =3D -EFAULT;
> 		goto cleanup;
> 	}
>=20
> Error --->
> 	if(copy_from_user(srbcmd, user_srb,fibsize)){
> 		printk(KERN_DEBUG"aacraid: Could not copy srb from user\n");=20
> 		rcode =3D -EFAULT;
> 		goto cleanup;
> ---------------------------------------------------------

Yup, it's protected by capable(), but...  Simple check eliminate possible
overflow.

thanks,
-chris
--=20
Linux Security Modules     http://lsm.immunix.org     http://lsm.bkbits.net

=3D=3D=3D=3D=3D drivers/scsi/aacraid/commctrl.c 1.4 vs edited =3D=3D=3D=3D=
=3D
--- 1.4/drivers/scsi/aacraid/commctrl.c	Wed Nov 19 10:38:25 2003
+++ edited/drivers/scsi/aacraid/commctrl.c	Mon Apr 19 12:02:12 2004
@@ -416,6 +416,11 @@
 		goto cleanup;
 	}
=20
+	if (fibsize > FIB_DATA_SIZE_IN_BYTES) {
+		rcode =3D -EINVAL;
+		goto cleanup;
+	}
+
 	if(copy_from_user(srbcmd, user_srb,fibsize)){
 		printk(KERN_DEBUG"aacraid: Could not copy srb from user\n");=20
 		rcode =3D -EFAULT;
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAhCVcIavu95Lw/AkRAsLeAJ4zu4FS9X66U5OoJu10iw6b7CvjEgCfUL+c
FybutSgBQXHtoBYgwdMKC8Y=
=VUjD
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
