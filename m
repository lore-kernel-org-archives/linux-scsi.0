Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6202EAE5;
	Thu, 11 Apr 2024 04:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712810436; cv=none; b=ZMHA0G4BrP8FQCCOWacGVpoIFAKvJiaRH48JxdBKlqxE2q5/lJtDbrZA1NxSaNg1sDUMU56RVViClT6a/XyN0PKrYGtRCyN8uvamBrnVSAIBo1ABUGEiWtxtX9ZYPinw1hOIfGl0vaUdwIj+KZdNidn2WaRcOWCFL+0azdMMdKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712810436; c=relaxed/simple;
	bh=M9LkEacLmCYCjfAuDabC1/gaX7o4sYY/+6Bxnvg9BJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VF1QLH6Kq0P9+hb5S1jil4ds1tnZn9dQ93vTyrZYgSyUN6LcHelWhJ5Fn8yK4BIpiQgtBpklGEXpHVMVcAIZIFzvNrBzu3t9Fy95AuAVogO9kdhZdfixqDFHQJDj+QF0XFPBWXkIrbFoCGNpjyns2FQChu0JIe9zIB7u1qEN0Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Sl0+COZq; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Sl0+COZq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0NEKVSxEHvmt2+My9K11tpjvFpMqhdWMGkUoH9YhH1A=; b=Sl0+COZqKR1yDCwEpK6T4H7g54
	Tp3RJ1/ETGiUPLG6XaMSm3bNlbbmItgLdgkqAR6o4o0HpZHKZoDMoDlfQl1hDkrm+cIiK6qd0xrNB
	BFZDYBG+5mia5PjkqV9U6J4D8g9I0rmboCHXNlWscmca6Lzkte+lobvCTP3XZJDyKoaDjSrK2m94o
	v0tX88U7SOWTIE+mf/Z78GusUH+h38VXuJbh3TnFf4Z/eDZW6HTF3WqeL/cwen5Cqcs0yjCfBtnkJ
	hXuhG3G2iILWwSbbPjD2n855AcYgRvUfoqZKWdn/pFAh92wpMwTXcnZ5NWlMXa3e1U+sp1gISGhXB
	7X8NMTcg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <kibi@debian.org>)
	id 1rumEZ-001YIg-Bb; Thu, 11 Apr 2024 04:40:24 +0000
Date: Thu, 11 Apr 2024 06:40:21 +0200
From: Cyril Brulebois <kibi@debian.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: John David Anglin <dave.anglin@bell.net>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-parisc <linux-parisc@vger.kernel.org>,
	linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>,
	stable@vger.kernel.org
Subject: Re: Broken Domain Validation in 6.1.84+
Message-ID: <20240411044021.xejk54iznz3cdxem@mraw.org>
Organization: Debian
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
 <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
 <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
 <6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
 <03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
 <yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com>
 <b3df77f6-2928-46cd-a7ee-f806d4c937d1@bell.net>
 <yq1frvvpymp.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7oudawh4gfttuhvx"
Content-Disposition: inline
In-Reply-To: <yq1frvvpymp.fsf@ca-mkp.ca.oracle.com>
X-Debian-User: kibi


--7oudawh4gfttuhvx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Martin K. Petersen <martin.petersen@oracle.com> (2024-04-08):
> Great, thanks for testing!
>=20
> Greg, please revert the following commits from linux-6.1.y:
>=20
> b73dd5f99972 ("scsi: sd: usb_storage: uas: Access media prior to querying=
 device properties")
> cf33e6ca12d8 ("scsi: core: Add struct for args to execution functions")
>=20
> and include the patch below instead.

According to James I've ran into another expression of the same issue,
which in my case led to the loss of some SMART information:
  https://lore.kernel.org/stable/20240410193207.qnb75osxuk4ovvm6@mraw.org/
  https://lore.kernel.org/stable/0655cea93e52928d3e4a12b4fe2d2a4375492ed3.c=
amel@linux.ibm.com/

I've just confirmed that both reverts plus that patch, applied on top of
v6.1.85, fix that regression for me. That's tested in a QEMU VM with a
SATA disk (that exposes only a few SMART attributes anyway) and also on
baremetal with real disks (2 pairs of Seagate IronWolf): smartctl
returns data again, including temperatures.

Closes: https://bugs.debian.org/1068675
Tested-by: Cyril Brulebois <kibi@debian.org>


Cheers,
--=20
Cyril Brulebois (kibi@debian.org)            <https://debamax.com/>
D-I release manager -- Release team member -- Freelance Consultant

--7oudawh4gfttuhvx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEtg6/KYRFPHDXTPR4/5FK8MKzVSAFAmYXabUACgkQ/5FK8MKz
VSASmA//f48sG/Fsmsc0usGNcYmVB6Zfu9y60OfNMJK/XJ2vW99Wcg6RNRqlhOiA
F+zP7b/EXJjPkOn+6DbomjGcAjsN/0feT8UOHLRWMTT/7oym/j0hj+CWEYnJ3TTm
6D6NFhTo+EzK6m4MqguSwCXe3jeEU+b0tugMGRUs7uqUr7wygkWjgwh1kjbZdFqX
acSTp4BHZGCrMkihqREq8HqKYK2rnsJTk+RROVA4Mc8HevwV5Wkuq82ipZtwPwIl
Dx6J0CNwF2udmLimXZh8j+8QxH6P9uP217gjg1P73vXY3q0jUDanXRVgP2a7QlSb
NngZGaXcR0sKrLL9cmoqkW/yQrqNii+kynG1JUw9OE1N5Hs+nr1ncjj+F65rkrMr
0mKymqAH8WYSUl0qa2a+abBO4i6z5MeQ1lntD0n0K2YZgeO9xA/lqeUjlt67n9Rb
RsM7fBM3SauutOU+E/vWNA53SQ1M8SZAFmwuga1c97EzAxetC2bl5ws8vvvP60ht
Zi03Rgq70EpkY364ecQUm+YKTsykh0GvsYdlAUtCgFyLJ2owQa7rhSv04Qbw8wkx
tlu6SNbsJd/lMfzv4kVB8DvUugvAdwpMJcYWvTgsYKrg4jdNcLx7LGnIy+SyCP06
lKJGvlGd6e8A2NRRhn03JgD1kXQS9r91vS3oMkq12lPnJ57xq34=
=c5D5
-----END PGP SIGNATURE-----

--7oudawh4gfttuhvx--
