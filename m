From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 13:05:47 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030106130547.E13916@one-eyed-alien.net>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net> <3E19EBC4.6000601@splentec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <3E19EBC4.6000601@splentec.com>; from luben@splentec.com on Mon, Jan 06, 2003 at 03:49:08PM -0500
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Luben Tuikov <luben@splentec.com>
Cc: Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm told this is a bad idea because there are some HBA which snoop the
INQUIRY data.  Since I don't know how that snooping works, I can't comment
further.

Matt

On Mon, Jan 06, 2003 at 03:49:08PM -0500, Luben Tuikov wrote:
> Matthew Dharm wrote:
> >=20
> > Perhaps the "best" fix here is to simply make scsi_scan.c only send 36 =
byte
> > inquiry requests if the bus is 'emulated'.  That would solve a world of
> > problems....
>=20
> When scsi_scan.c does it's own scanning for SCSI Core, maybe it's best to
> ignore 36 < INQUIRY_DATA_LEN < 57, since this is just vendor specific
> data and SCSI Core is not interested in it.
>=20
> In descriptive-C this looks like this:
>=20
> </issue a 36 byte buffer INQUIRY/>
> </now dissect:/>
>=20
> int bytes_got =3D max(bytes_requested - cmd->resid, 0);
>=20
> if (31 < buffer[4] && buffer[4] < 52) {
> 	/* we don't care, do not issue another INQUIRY */=09
> else if (buffer[4] >=3D 52) {
> 	bytes_requested =3D 5+buffer[4];
> 	/* issue another INQUIRY to get the additional flags, */
> 	/* plus any version descriptors if available */
> 	</insert code here/>
> 	bytes_got =3D max(bytes_requested - cmd->resid, 0);
> }
>=20
> if (bytes_got !=3D buffer[4]+5) {
> 	/* let's rely on the transport to have correctly set */
> 	/* cmd->resid and report a broken device server */
> 	</insert code here/>
> }
>=20
> /* Now we rely on bytes_got */
>=20
> </rest of scanning code/>
>=20
> --=20
> Luben
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Would you mind not using our Web server? We're trying to have a game of=20
Quake here.
					-- Greg
User Friendly, 5/11/1998

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Ge+rIjReC7bSPZARAlAIAJ9LTRHsoVDosXzEpKmji8dmOM+VqwCdFpob
p1dgjE61Pot7JBRtqTdJdnM=
=SdcO
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
