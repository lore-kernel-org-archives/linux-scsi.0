From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Wed, 7 Sep 2005 16:01:26 +0200
Message-ID: <200509071601.38164@bilbo.math.uni-mannheim.de>
References: <20050907135105.GA16340@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3600529.Lut4X7ZoTv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:50397 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751216AbVIGOBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 10:01:55 -0400
In-Reply-To: <20050907135105.GA16340@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

--nextPart3600529.Lut4X7ZoTv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Christoph Hellwig wrote:
>As Rolf Eike Beer noted we might not actually get to the
>kthread_should_stop() because we are waiting in the semaphore forever.
>I didn't get a rmmod hang because of this, but my instrumentation showed
>the thread defitiyly didn't exit.
>
>So make sure to wake the EH thread before the kthread_stop, and to plug
>the reaming race check kthead_should_stop() a second time just before
>calling down_interruptible().
>
>
>Index: scsi-misc-2.6/drivers/scsi/hosts.c
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2005-09-07 14:21:44.000000000
> +0200 +++ scsi-misc-2.6/drivers/scsi/hosts.c	2005-09-07 14:22:33.000000000
> +0200 @@ -226,8 +226,10 @@
> 	struct Scsi_Host *shost =3D dev_to_shost(dev);
> 	struct device *parent =3D dev->parent;
>
>-	if (shost->ehandler)
>+	if (shost->ehandler) {
>+		up(shost->eh_wait);
> 		kthread_stop(shost->ehandler);
>+	}
> 	if (shost->work_q)
> 		destroy_workqueue(shost->work_q);

Wouldn't this hang the same way if rescheduling happens between the up() an=
d=20
the kthread_stop()?

Eike

--nextPart3600529.Lut4X7ZoTv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDHvLCXKSJPmm5/E4RAlrGAJsGWy52JJitY/OKZiI9in5nAaaoJgCdECPY
l1geF+TJ5Rj83EDurzLySIQ=
=8ABy
-----END PGP SIGNATURE-----

--nextPart3600529.Lut4X7ZoTv--
