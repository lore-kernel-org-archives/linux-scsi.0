From: Mohammed Sameer <uniball@gmx.net>
Subject: Re: BUG: CD driver sends command during host removal
Date: Sun, 3 Oct 2004 01:57:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002235714.GA2189@uniball>
References: <20040929210751.GC6179@us.ibm.com> <Pine.LNX.4.44L0.0409291719170.1700-100000@ida.rowland.org>
Reply-To: Mohammed Sameer <uniball@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-81.10.17.94.tedata.net ([81.10.17.94]:59011 "EHLO
	uniball.foolab.org") by vger.kernel.org with ESMTP id S267624AbUJBX73
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 19:59:29 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0409291719170.1700-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: USB users list <linux-usb-users@lists.sourceforge.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2004 at 05:20:21PM -0400, Alan Stern wrote:
> On Wed, 29 Sep 2004, Mike Anderson wrote:
>=20
> > So now that this thread and the other thread related to similar
> > shutdown issues has grown long is the next step to see if we can get the
> > usb queuecommand to return DID_NO_CONNECT in this shutdown case.
>=20
> Here's a patch.  Mohammed, please try it out and tell us how it works.  I=
=20
> just wrote it, so I haven't had a chance to test it myself yet.
>=20
> Alan Stern
>=20
>=20
> =3D=3D=3D=3D=3D drivers/usb/storage/scsiglue.c 1.84 vs edited =3D=3D=3D=
=3D=3D
> --- 1.84/drivers/usb/storage/scsiglue.c	2004-09-13 08:11:34 -04:00
> +++ edited/drivers/usb/storage/scsiglue.c	2004-09-29 16:08:47 -04:00
> @@ -183,6 +183,14 @@
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
> =20
> +	/* fail the command if we are disconnecting */
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->flags)) {
> +		US_DEBUGP("Command failed for disconnect\n");
> +		srb->result =3D DID_NO_CONNECT << 16;
> +		done(srb);
> +		return 0;
> +	}
> +
>  	srb->scsi_done =3D done;
>  	us->srb =3D srb;
> =20
>=20
though patch complained:

patching file drivers/usb/storage/scsiglue.c
Hunk #1 succeeded at 166 (offset -17 lines).

But the patch works fine, Thanks!
May god bless you all!!


--=20
----------------
-- Katoob Main Developer, Arabbix Maintainer.
Linux registered user #224950
Proud Egyptian GNU/Linux User Group <www.eglug.org> Admin.
Life powered by Debian, Homepage: www.foolab.org
--
Don't send me any attachment in Micro$oft (.DOC, .PPT) format please
Read http://www.fsf.org/philosophy/no-word-attachments.html
Preferable attachments: .PDF, .HTML, .TXT
Thanx for adding this text to Your signature

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBX0Bay2aOKaP9DfcRAuo0AKCmTUSQRWzBIY4R538xxg6+/Xmm/QCgtK8o
gKt/+EtIWHt22TZklQv7jnE=
=ghaM
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
