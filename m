From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 11:22:59 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030106112259.B13916@one-eyed-alien.net>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Mon, Jan 06, 2003 at 08:18:45PM +0100
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl
Cc: luben@splentec.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 08:18:45PM +0100, Andries.Brouwer@cwi.nl wrote:
> > In the case reported, the problem was
>=20
> Ha, Alan - it is possible that the two of you are referring
> to different things.

That confusion is definatly happening.

> I mentioned two devices, both return 36 bytes when asked for
> 36 bytes, but the first has 0 in the additional length field
> (thus reports length 5), the second has 32 in the additional
> length field (thus reports length 37).
> This second device, when asked for 37 bytes, still only returns 36.

The first case:  If the additional length indicates < 36 bytes, we should
never issue the second request (which is where this device choked).  This
should be a sanity check in scsi_scan.c, and it works for reasons I've
previously outlined.

The second case:  This is a bad device.  A classic off-by-one error.  But
what can usb-storage do?  We don't know that the device is bad.  But,
focusing on this case, what happens?  Short data is returned... if the
resid field is set to indicate this, then scsi_scan.c should be able to do
something sane here.

Perhaps the "best" fix here is to simply make scsi_scan.c only send 36 byte
inquiry requests if the bus is 'emulated'.  That would solve a world of
problems....

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

God, root, what is difference?
					-- Pitr
User Friendly, 11/11/1999

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GdeTIjReC7bSPZARAifyAJ9OY896FdZDeLJmj05wZyvk+8G+DQCfc3ou
d5NQg4YjdeBjEmCVFB396OA=
=GWTj
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
