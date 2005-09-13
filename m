From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Tue, 13 Sep 2005 19:01:26 +0200
Message-ID: <200509131901.33033@bilbo.math.uni-mannheim.de>
References: <Pine.LNX.4.44L0.0509131247090.4481-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1310945.fQatWsyLyi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:42987 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S964900AbVIMRAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 13:00:55 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509131247090.4481-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>, SCSI development list <linux-scsi@vger.kernel.org>

--nextPart1310945.fQatWsyLyi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Dienstag, 13. September 2005 18:50 schrieb Alan Stern:
>Rolf Eike Beer wrote:
>> Ok, we looked a bit closer on all this. http://lwn.net/Articles/65178/
>> tells that ktread_stop() will not send a signal, so the
>> down_interruptible() will never return on kthread_stop(). But calling up()
>> directly before
>> kthread_stop() adds a race condition: if reschedule happens right after
>> the up() we've won nothing and it will hang again.
>
>This problem shows up in other ways as well.  With hot-unpluggable
>hosts, the call that does the last 'put' on the last device will hang
>waiting for the eh thread to terminate.  See
>
>http://bugzilla.kernel.org/show_bug.cgi?id=5237

Looks like someone has to build a waitqueue to fix this.

Eike

--nextPart1310945.fQatWsyLyi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDJwXsXKSJPmm5/E4RArA3AJ4mbt4LS4GlDBAfavLc8RsyM3p8mgCfb0l2
qRhDx4EYa0ote34FqwW6D0Q=
=yQGa
-----END PGP SIGNATURE-----

--nextPart1310945.fQatWsyLyi--
