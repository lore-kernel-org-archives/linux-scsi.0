From: Kurt Garloff <garloff@suse.de>
Subject: Re: Scsi error handler strategy question
Date: Mon, 5 Jan 2004 10:44:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105094426.GJ6671@tpkurt.garloff.de>
References: <20040104232425.GM4339@linnie.riede.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3CAnR4CLEnEWqRMR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:22713 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263130AbUAEJo2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 04:44:28 -0500
Content-Disposition: inline
In-Reply-To: <20040104232425.GM4339@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org


--3CAnR4CLEnEWqRMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Willem,

On Sun, Jan 04, 2004 at 06:24:25PM -0500, Willem Riede wrote:
> But here is my first question: is there typically any need to wait=20
> some time between doing the host/bus/device reset and the first TUR?
> Is there a standard that governs how fast devices have to be done
> resetting to the point that they can respond to commands (if only to
> say they're not ready?

Ths SCSI-2 standard does not say anything about this.=20
However, it seems to be assumed that a device has recovered enough=20
to respond to commands like INQUIRY and TUR after the normal=20
parallel SCSI selection timeout of 250ms.

In practice, we many devices need more time to recover.
If you look at the SCSI scanning code, there are timeouts of a few
(6) seconds. They are only needed because of devices needing time to=20
recover after a reset.

> When the first TUR completes, the CC/UA expected flag takes care of
> the reported sense 06:29:00 (power on reset or device reset occurred).
> So far so good. Second TUR issued. That one typically gets 02:04:01
> (not ready - in the process of becoming ready) reported. The error
> handler is programmed to retry TUR once if it sees this.

Good.

> Second question: if the device firmware takes some time to re-initiate
> the device, this code can be returned multiple times. So am I allowed
> to submit a patch to increase that retry count? What would be a good
> number? Hard to say in general, as this depends on what devices you
> have and how fast commands get executed :-(

TUR tends to be answered immediately. So you should wait a second=20
before retrying. Allowing for 32 retries does not seem exxagerated then,
as we know that the device is expected to come back.

> Finally, at least my device, the OnStream DI-30, will eventually want=20
> to report 06:28:00 (not ready to ready transition, medium may have
> changed). The error handler considers that an error, and is guaranteed
> to take the device offline, just as it came back to life :-(
>=20
> Am I allowed to submit a patch that will also retry on that condition?

I'd support it.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--3CAnR4CLEnEWqRMR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+TH6xmLh6hyYd04RAmwPAJ9V3Z2ZTC4fLyTHgDYWkzEx1bALpwCgtC2e
I8/mwT+QdfyelV2vc1lWm0E=
=Retm
-----END PGP SIGNATURE-----

--3CAnR4CLEnEWqRMR--
