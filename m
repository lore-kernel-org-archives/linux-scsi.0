From: Kurt Garloff <garloff@suse.de>
Subject: New SCSI exc handlers: Returning cmnds?
Date: Fri, 21 Jun 2002 13:07:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020621110747.GA28197@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

converting the dc395x_trm (Tekram DC3x5 / TRM-S1040) to new exception
handling, I wonder what needs to be done with queued commands when
eh_abort_handler() or eh_bus_reset_handler() are called.

In the old abort handler, I was feeding the command back with DID_ABORT
and call scsi_done() on it, if successful.
In the old reset handler, I was feeding all commands (including the one that
was passed when _reset was called) that were sitting in the host adapter
driver's queue  with DID_RESET back to midlayer by calling scsi_done() on
them.=20

How should this handled in the new EH code?
Is the new EH code implicitly aborting the commands, so I don't have to
do it?=20
Is the ML prepared to have scsi_done() called when doing EH?
Or do I have to use some bottom half/tasklet ... type of mechanism?

Do I have to give the cmnds in queueing order, or does the ML take care
of the correct ordering?

http://www.andante.org/scsi_error.html
is scarily ignorant on that subject.

Thanks for advice!
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9EwkDxmLh6hyYd04RAo+HAKCPLRc+H4tpsuS7+slvQYZf3OhTJwCgycpu
+XnhsjMw3OENi8OlJB5aB60=
=/WNt
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
