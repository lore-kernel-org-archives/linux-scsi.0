From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Thu, 8 Sep 2005 17:26:36 +0200
Message-ID: <200509081726.43760@bilbo.math.uni-mannheim.de>
References: <20050907135105.GA16340@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2556486.LKtZpeR4oZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:8097 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932690AbVIHP0p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 11:26:45 -0400
In-Reply-To: <20050907135105.GA16340@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

--nextPart2556486.LKtZpeR4oZ
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

Ok, we looked a bit closer on all this. http://lwn.net/Articles/65178/ tell=
s=20
that ktread_stop() will not send a signal, so the down_interruptible() will=
=20
never return on kthread_stop(). But calling up() directly before=20
kthread_stop() adds a race condition: if reschedule happens right after the=
=20
up() we've won nothing and it will hang again.

Using this kind of semaphore for thread wakeup looks more dangerous everyti=
me=20
I think on it. down_interruptible() may be interrupted by someone with a=20
signal and return without the semaphore locked. Better would be something=20
like

i =3D down_interruptible();

if (kthread_should_stop())
	break;

if (i)
	continue;

Or we have to block all signals, then we can just ignore the _interruptible=
 at=20
all. What about something like this instead?

while(!kthread_should_stop()) {
	if (!down_trylock(&sem)) {
		if (kthread_should_stop())
			break;
		yield();
		continue;
	}

	/* something */
}

Eike

--nextPart2556486.LKtZpeR4oZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDIFgzXKSJPmm5/E4RAm58AJsGaUpHGrs5gJk4QPAW/R2+ahXoeQCgmYjD
/toIxaFMQhcH3n9EYUet0eg=
=VPsW
-----END PGP SIGNATURE-----

--nextPart2556486.LKtZpeR4oZ--
