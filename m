From: Giel van Schijndel <me@mortis.eu>
Subject: Re: [PATCH] Cleanup: snprintf() always NUL-terminates: depend on it
Date: Sun, 4 Jan 2015 23:38:00 +0100
Message-ID: <20150104223800.GA4806@salidar.dom.custoft.eu>
References: <1420394759-20345-1-git-send-email-me@mortis.eu>
 <CA+55aFw8aMBF5uXekxATymQPTqwZHGJTL-jQx8zDqOwbaft+4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from khitomer.mortis.eu ([185.27.175.75]:30688 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbbADWsB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2015 17:48:01 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFw8aMBF5uXekxATymQPTqwZHGJTL-jQx8zDqOwbaft+4g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 11:34:43 -0800, Linus Torvalds wrote:
> On Sun, Jan 4, 2015 at 10:05 AM, Giel van Schijndel <me@mortis.eu> wrote:
>> Especially since one very strange piece of code seems to be written in
>> such a way that a NUL needs to be placed where a NUL is present already.
>=20
> Actually, it's worse than that. This:
>=20
>>         len =3D snprintf(fname, 99, "%s", buf);
>> -       fname[len-1] =3D '\0';
>=20
> is complete garbage, since the return value of snprintf() is not the
> length of the result, but length of what the result *would* have been.
>=20
> So if the string doesn't fit in 99 bytes, it will actively corrupt
> some random memory after the string. It's not writing zero to what was
> already zero, it's corrupting memory.

Ah yes, I didn't even notice that nasty side effect. I just deleted that
"really, really" NUL-termination line because it was based on a
misunderstanding of snprintf()'s postcondition. Even if
len=3D=3Dsizeof(fname) this still would have given the wrong example for
others to follow.

> Anyway, from a quick glance your patches look fine, but you need to
> sign off on them. See Documentation/SubmittingPatches.

Ah yes, forgot that. Would it be sufficient if I sent a reply to all
those patch mails with next line tacked on, or would it require a
resubmission?
> Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Always code as if the guy who ends up maintaining your code will be a
 violent psychopath who knows where you live."
  -- Rick Osborne

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpwMQACgkQZBYm/87l50KTpQCgrH/WGx/W9Hhislo1AfEkx2XR
p1wAoKIDhwHCBMjvNVQl/rHdYFfdZbGc
=P3iw
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
