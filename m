From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 14:08:25 -0700
Message-ID: <20060626210825.GB31085@one-eyed-alien.net>
References: <20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
	<1151310285.3185.16.camel@laptopd505.fenrus.org>
	<20060626124001.GG1608@parisc-linux.org>
	<20060626144442.GA13319@one-eyed-alien.net>
	<20060626151828.GH1608@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0234628326=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060626151828.GH1608@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--===============0234628326==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 26, 2006 at 09:18:28AM -0600, Matthew Wilcox wrote:
> On Mon, Jun 26, 2006 at 07:44:42AM -0700, Matthew Dharm wrote:
> > As for using one Scsi_Host... there are several usb-storage devices whi=
ch
> > attach to an entire SCSI bus (not just a single target), so can't make =
each
> > device it's own target.
>=20
> Oh.  My fault for reading the comment rather than the code.
>=20
>                 /* reject if target !=3D 0 or if LUN is higher than
>                  * the maximum known LUN
>                  */
>                 else if (us->srb->device->id &&=20
>                                 !(us->flags & US_FL_SCM_MULT_TARG)) {
>=20
> Do these devices stick to occupying only target IDs from 0-7?  If not,
> you may wish to increase ->max_id for those devices.  I think it'd be wor=
th
> exporting scsi_scan_channel() from the midlayer (and rearranging it to ha=
ve
> __scsi_scan_channel() as was done with __scsi_scan_target) for USB's bene=
fit.

These support target IDs to up 15.  But I see the point of limiting
->max_id for devices which do not have the SCM_MULT_TARG flag set.

> It's definitely possible to remove individual targets dynamically now;
> Fibre Channel has sorted that out (and will complain loudly if it breaks).
> The scsi core doesn't really have a channel object; channel is just an in=
teger=20
> that describes a path to a target.  So I think there should be no problem=
 in
> converting USB to have one host and many channels.

Interesting.

What's the limit on the number of channels you can have?

How do I set up multiple channels in code?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEoEzJHL9iwnUZqnkRAn+GAKCoC7s7PAyiPGwMgzTIwh4A9OXLXQCeLX8k
9oi/GvUtNHkNfHtWsdGeltA=
=Ii3e
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--


--===============0234628326==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642

--===============0234628326==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============0234628326==--
