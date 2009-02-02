From: Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: [PATCH] libata: change drive ready wait after hard reset to 5s
Date: Mon, 02 Feb 2009 11:17:45 -0600
Message-ID: <49872AB9.1010807@dell.com>
References: <1233456951-992-1-git-send-email-tj@kernel.org> <1233456951-992-4-git-send-email-tj@kernel.org> <DFEF91B22ED07447AB6AA4B237F913F9021859A8@ausx3mpc125.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4287E325EF1638B221A646D9"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9021859A8@ausx3mpc125.aus.amer.dell.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Hayes, Stuart" <Stuart_Hayes@dell.com>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4287E325EF1638B221A646D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I believe this is the reference that Stuart refers to in the ATA-6 spec:

http://www.t10.org/t13/project/d1410r3a-ATA-ATAPI-6.pdf

Here's the snippet, (p327):

"
Transition D0HR1:D0HR1: When the sample indicates that DASP- is negated
and            less than 450 ms have
elapsed since the negation of RESET-, then the device shall make a
transition to the   D0HR1: Sample_DASP-
state. When the sample indicates that DASP- is negated and greater than
450 ms          but less than 5 s have
elapsed since the negation of RESET-, then the device may make a
transition to the     D0HR1: Sample_DASP-
state.
Transition D0HR1:D0HR3: When the sample indicates that DASP- is negated
and 5 s have elapsed since the
negation of RESET-, then the device shall clear bit 7 in the Error
register and make a transition to the D0HR3:
Set_status state. When the sample indicates that DASP- is negated and
greater than 450 ms but less than 5 s
have elapsed since the negation of RESET-, then the device may clear bit
7 in the Error register and make a
transition to the D0HR3: Set_status state.
"

Hayes, Stuart wrote:
> This fixes problems during resume with drives that take longer than 1s
> to be ready.  The ATA-6 spec appears to allow 5 seconds for a drive to
> be ready.
>
> On one affected system, this patch changes "PM: resume devices took..."=

> message from 17 seconds to 4 seconds, and gets rid of a lot of ugly
> timeout/error messages.
>
> Without this patch, the libata code moves on after 1s, tries to send a
> soft reset (which the drive doesn't see because it isn't ready) which
> also times out, then an IDENTIFY command is sent to the drive which
> times out, and finally the error handler will try to send another hard
> reset which will finally get things working.
>
> Sorry to send as an attachment, but my mail server will wrap text.
>
>
> Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
>
>  =20

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig4287E325EF1638B221A646D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkmHKrkACgkQ2CrZjkA73Ys11ACeM9ibnvpj5ZZVyYhE7oHNqikJ
4h4An0zmAdshbCGkcyEjZi9wvGNNkleR
=8xrR
-----END PGP SIGNATURE-----

--------------enig4287E325EF1638B221A646D9--
