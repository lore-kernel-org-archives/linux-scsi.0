From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] switch EH thread startup to the kthread API
Date: Wed, 7 Sep 2005 09:30:55 +0200
Message-ID: <200509070931.02816@bilbo.math.uni-mannheim.de>
References: <20050906120426.GB20177@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7129837.THXu6GkLzO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:50884 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932068AbVIGHbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 03:31:04 -0400
In-Reply-To: <20050906120426.GB20177@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

--nextPart7129837.THXu6GkLzO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Christoph Hellwig wrote:

>@@ -1600,8 +1593,6 @@
> 	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
> 					  " scsi_eh_%d\n",shost->host_no));
>
>-	complete(shost->eh_notify);
>-
> 	while (1) {
> 		/*
> 		 * If we get a signal, it means we are supposed to go
>@@ -1622,7 +1613,7 @@
> 		 * semaphores isn't unreasonable.
> 		 */
> 		down_interruptible(&sem);
>-		if (shost->eh_kill)
>+		if (kthread_should_stop())
> 			break;
>
> 		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"

We used nearly the same code in cpqfcTS yesterday for testing. On module=20
unload down_interruptible() does not get interrupted and the kthread_stop()=
=20
will wait forever and hang rmmod.

Eike

--nextPart7129837.THXu6GkLzO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDHpc2XKSJPmm5/E4RAp5FAJ0e6bBQtGbKNiTLIO4rDo6yq+VMUgCgoj/c
o5UgzHHHJn558G5mbAupfNw=
=Edhh
-----END PGP SIGNATURE-----

--nextPart7129837.THXu6GkLzO--
