From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Linux scsi / usb-mass-storage and HP printer
	cardreader bug + fix
Date: Wed, 9 Jan 2008 14:10:46 -0800
Message-ID: <20080109221046.GD14375@one-eyed-alien.net>
References: <47854051.1060307@hhs.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0934803818=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47854051.1060307@hhs.nl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, fedora-kernel-list@redhat.com
List-Id: linux-scsi@vger.kernel.org


--===============0934803818==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2008 at 10:44:49PM +0100, Hans de Goede wrote:
> First of all sorry for the somewhat massive cross-posting, I've spend a=
=20
> significant amount of time hunting down this bug, and so far the response=
=20
> has been less the overwhelming.
=20
> The cardreader of the multi function printers will "crash" and from that=
=20
> moment on no longer communicate in any sane way, if you try to read the=
=20
> last sector of an sdcard* in a read that is more then 1 sector, so trying=
=20
> to read 8 sectors starting at sector capicity-8 will crash it, as will=20
> reading 2 sectors starting at sector capicity-2, however reading the last=
=20
> sector in a one 1 sector read will succeed! (* xdcards seem to be fine).

To continue the history on this.... we over in usb-storage land looked at
this and think it belongs in the SCSI layer.  We don't like changing
commands in-flight; it has, historically, caused us all sorts of issues in
the past.

Furthermore, this seems like the likely sort of off-by-one bug that can
affect many types of devices, not just USB.

I'd really like to see this in sd_mod -- I have no objection to requiring
an HCD to set a flag to indicate that it should be used, if really desired.
But, it seems to me to be a much easier change to make where the command
originated rather than in mid-flight.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  Nine more messages in admin.policy.
M: I know, I'm typing as fast as I can!
					-- Pitr and Mike
User Friendly, 11/27/97

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHhUZmHL9iwnUZqnkRAgQ1AKCBL9ym3B9QqC+MlmD/oNoa9FfAOwCgpSJ4
C96Up3F/YocW3GytmDMheAQ=
=5sc/
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--


--===============0934803818==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
--===============0934803818==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============0934803818==--
