From: Kurt Garloff <garloff@suse.de>
Subject: Re: New SCSI exc handlers: Returning cmnds?
Date: Fri, 21 Jun 2002 16:56:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020621145652.GC29154@gum01m.etpnet.phys.tue.nl>
References: <OF912C2ED8.D5D9043D-ONC1256BDF.004D76C5@de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF912C2ED8.D5D9043D-ONC1256BDF.004D76C5@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Fri, Jun 21, 2002 at 04:16:50PM +0200, Martin Peschke3 wrote:
> And after that the things happen you are asking for advice ;-)

digging through the SCSI code is a time-consuming thing ...

> Your eh_abort_handler is called for each timed out command (the concerned
> scsi_cmnd struct pointer is passed to your routine). Your driver should t=
ry
> to abort the particular command and return either SUCCESS or FAILED. This
> is a synchrounous step, i.e. your eh_abort_handler returns when the job is
> done. If you need to wait, then you are allowed to call schedule since
> everything happens in thread context.

Sure.

> You do not need to call scsi_done() for commands being aborted, but you a=
re
> allowed to do so during abort (makes it easier for you to, you don't have
> to cope with race conditions). You must not call scsi_done() for commands
> after your eh_abort_handler called for this particular command has
> returned.

To make sure I understand you: The midlayer just discards the timed out=20
SCSI commands, whether I give them back with scsi_done() [and result
DID_ABORT] or not?
But I don't understand your comment about race conditions. I just free
up the structures that are allocated in the driver for the command and
skip the scsi_done() callback that I used to call in the old exc handler.
No races ...

> Your eh_*_reset_handler should be implemented similarly.
> They might be called if there is still recovery to do after aborting.

Yes, that's why we occasionally see bus resets in Linux. Perfect for a
messed up SCSI bus with disks, and quite harmful for tape backups or=20
CD burning sessions.
I'll try to implement device_reset next in my driver ...

Thanks for your (and for Aron's) advice!

DC395 driver 1.41 to be released within the next minutes ...

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9Ez60xmLh6hyYd04RAuoaAJ9ColAt6gk33D2CCh10Iy59TwlEoQCgiAVz
c2dJzlweojcddLAYpWs7c8c=
=zcE+
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
