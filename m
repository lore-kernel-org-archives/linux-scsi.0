From: "Juergen E. Fischer" <fischer@linux-buechse.de>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Wed, 29 Oct 2003 18:56:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029175621.GB5903@linux-buechse.de>
References: <20031027155713.GA28140@lst.de> <20031027160101.76d5291b.rddunlap@osdl.org> <20031028090600.GA7370@lst.de> <20031028124536.3ce82c23.rddunlap@osdl.org> <3F9EF2B4.9030708@us.ibm.com> <20031028162610.6dcfd06e.rddunlap@osdl.org> <20031029122008.GA5903@linux-buechse.de> <1067439510.1829.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD9ED18AC.dip.t-dialin.net ([217.237.24.172]:40354 "EHLO
	linux-buechse.de") by vger.kernel.org with ESMTP id S261235AbTJ2R7w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:59:52 -0500
Content-Disposition: inline
In-Reply-To: <1067439510.1829.4.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, fischer@norbit.de


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, Oct 29, 2003 at 08:58:28 -0600, James Bottomley wrote:
> You don't actually need a new command for this.  The struct scsi_cmnd
> layout is designed to allow you to reuse the current command for
> clearing contingent allegiance conditions (the fields you need to alter
> all have copies stored somewhere which you can restore when you have the
> sense data.  See for example how the 53c700 does this, or aic7xxx_old)

Why not?  It's a new command after all and if the initialization is
done correctly (ie. ->device is setup) it works the way it is now.

> > The second it when the controller needs to be resetted.  Both are purely
> > internal to the driver.
=20
> As a rule of thumb: as long as the command is never seen outside the
> driver, then using kmalloc is fine.  If it is ever seen outside the
> driver (like in requeueing conditions) then you should use
> scsi_get_command().

using it now anyway.  Following patch fixes the problem.  Works here.


--- aha152x.c.orig	2003-10-29 18:53:59.000000000 +0100
+++ aha152x.c	2003-10-29 18:38:20.000000000 +0100
@@ -450,7 +450,8 @@
 		/* host lock */
=20
 #if defined(AHA152X_DEBUG)
-	char *locker;	/* which function has the lock */
+	const char *locker;
+		/* which function has the lock */
 	int lockerl;	/* where did it get it */
=20
 	int debug;	/* current debugging setting */
@@ -1991,7 +1992,7 @@
 				SETPORT(PORTA, 0);	/* turn led off */
=20
 			kfree(ptr->host_scribble);
-			kfree(ptr);
+			scsi_put_command(ptr);
 		} else if(DONE_SC->SCp.Status=3D=3D0x02) {
 #if defined(AHA152X_STAT)
 			HOSTDATA(shpnt)->busfree_with_check_condition++;
@@ -2001,7 +2002,7 @@
 #endif
=20
 			if(!(DONE_SC->SCp.Status & not_issued)) {
-				Scsi_Cmnd *cmnd =3D kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
+				Scsi_Cmnd *cmnd =3D scsi_get_command(DONE_SC->device, GFP_ATOMIC);
=20
 				if(cmnd) {
 					Scsi_Cmnd *ptr=3DDONE_SC;
@@ -2018,9 +2019,6 @@
 					cmnd->cmnd[4]         =3D sizeof(ptr->sense_buffer);
 					cmnd->cmnd[5]         =3D 0;
 					cmnd->cmd_len	      =3D 6;
-					cmnd->device->host    =3D ptr->device->host;
-					cmnd->device->id      =3D ptr->device->id;
-					cmnd->device->lun     =3D ptr->device->lun;
 					cmnd->use_sg          =3D 0;=20
 					cmnd->request_buffer  =3D ptr->sense_buffer;
 					cmnd->request_bufflen =3D sizeof(ptr->sense_buffer);


J=FCrgen

--=20
"If Bill Gates had a nickel for every time Windows crashed....
Oh, wait, he does!"=20
  -- Gary Oliver

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/n/9Fc/GhTF5ESHURArPYAJoCgxDZRf1CW3jIAVXKlmexrsNCTwCeNua9
1WM5yofjjO4Ey5FCqY/nfWU=
=9sR3
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
