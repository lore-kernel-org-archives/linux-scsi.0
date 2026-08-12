Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE693264C3
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 06:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514794; cv=none; b=mSnJw5HvgUc4CYFofl34KedhrmoVBPV9/1atz70iq3q2R0W+ZVAsh3U5dw3Dogj7hj263WwJkZOBgx29cL7IWHSVV816Nd1FFh2906WF2TIKH+jl0y74jo1yHw/9fxuYIEg4/z1nM721uPgydByz72bIdriOYs+28Jk7U4sh0UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514794; c=relaxed/simple;
	bh=ZAJzop4AjvsiA4GTl3m1C8MJVDuXUxmiqm9F/Nw8O1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3dzKS0vrGvJBpv86+ZKA+SOXmjF2nh7c2Yy8iovl4zuNxgW3ZWxjB80iUpLhPKXqAgbUT9gUDWyF6jMPE3II3TI0EgHnIzts5bR/2LrbclWAPE8NOTk9TF3CWsG4/mEEGqwlEL2aclXDJrweZOVy9TJCi67PeG7rvPjheidFyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=OkGeLtmu; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="OkGeLtmu"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495437bb891so4778555e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 23:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1786514790; x=1787119590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HorQEIgr4JhNec9eanHk78I2SPpuUlT0tC++CtCiMaE=;
        b=OkGeLtmuIR9V/25H1nrc0yoWiyVaF/+TIJGtvmBrxZGoGXwevN83Zwe3cN5mkPWQEl
         EZkE3Z+fq7fgPFzYcdkDwjTzLUQRxtpF9pA9bn6rmYSSdG7pmnjIk2CxtID8xTv6wfT5
         m2pXvERRFt4RRA2EP1Dhs3/Sgw7BOJFNbC6sLGoSDjgNAwY3FaiXfD8Q5BiMla1LuVaF
         CGq41vBUZIrF5ojvKBnbATXwjSCTCJrz9UbQDr2yrpKxRkpqTKESI9eax9qR6TL9p80D
         9K/mKgYqaiRWCgVxmrWl1Cg2rSpfFqBGGYXyegxSzKUHLKhEwWfSOg3noK5IhwC+v5wl
         s+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786514790; x=1787119590;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HorQEIgr4JhNec9eanHk78I2SPpuUlT0tC++CtCiMaE=;
        b=WRv1KOFAzA/WwtKAJYKU8vJM12yKg6VjJgKdvf1jmp+C+q6YEqlvONJV4fqybYUtzL
         lTlkXS0QEHwBurb47GA2AoMzq15eKBDdefieJfCgEGBExrXog4GAmt860kttyJnNwrxO
         r+B0maSLw2sHDzI20hJx/cKsPObgaF4+GEbFwpKKPi+FADrDBQXOESJoq3RH+VPCJmBD
         4zhmtLJDeDNB1DfVb+CHSv31jt6PRCdxY0B07J5Nk+ubf0P6FdyJsGL2ElUNANTHaU7O
         cycA+nEuDrjnX4AvQzSsgTtUkgJ9kXg7HVuhnW5YG/GefXr/TUhOUppkT1tp/GS6e6JN
         SuPw==
X-Forwarded-Encrypted: i=1; AHgh+RrTKSlnAPIFOHl89LeFEJ8sHxKjMpdFejseWFA/oEcLknST+XjWB38hxmzOFkvg8IyrXM/gnHB2ZUYf@vger.kernel.org
X-Gm-Message-State: AOJu0YxbkBaiArXthI3j6n8L+KGhxbyzkHJ94ZsjNT3Y+XDmWmMHdaeZ
	vwGiMm7ItFsYx4+oTNV3iQLOFyNZdBKvQMwVNhpO7tVwHgH5QbUSoqDH+WBEAEkphfo=
X-Gm-Gg: AR+sD12k4EKZZZrFgkzWvfzJ+6w2iwZmV4KdFodizQ9aY7Wcas+qM+pfOH6DP3SEDw9
	2H8WM7BYFub7Qf6EZB3/F+s8KK8VQwUNRe/+XJiGKhr+C3hWp1Jmv/5/9MGtP1AfoBb6hz8JIPr
	Ft9TSMqNo3wGDkpxCTtZL3/oxvHXjDnAKwJtOKXkQ0k4z6OZS+8njxdf7oAmhcy2Wb4W5ZH6ile
	abL0RjdASywBjudedLjWwyTYLiavCbBDsKKMZfPx7ctEgemGEFIXavKGSy+kV1xBQ5DdMGWlgwQ
	2nwMk+n3jF41AvzrWlqHQGnZ4kyXUpmKOaCpcuRntlxgUNvEB9MXAgagVq6pEac7uCbhJWoosYF
	knsU9zeNKErhaWaukPfTT0jzjbE6l1Jfp0x7RI1dlEW3zegqdm1MSg1ijSOOuARB65QkHgcFtwg
	pcGz1X8EDGNiZ5CCifHmRKJuuPKgG8DHIjiLx/pj0+/R1G2I4F8rq53n5jWmASmNewRA==
X-Received: by 2002:a05:600c:c87:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-4997c4fb76dmr22206145e9.6.1786514790233;
        Tue, 11 Aug 2026 23:06:30 -0700 (PDT)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4997c948512sm19224575e9.6.2026.08.11.23.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:06:29 -0700 (PDT)
Date: Wed, 12 Aug 2026 08:06:28 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, 
	Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	GR-FC-Storage-Upstream@marvell.com, agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com, 
	hare@suse.com, regressions@lists.linux.dev
Subject: [REGRESSION] Re: [PATCH v6 05/56] scsi: qla2xxx: Add FC operational
 firmware load for 29xx
Message-ID: <anwLLKJRVgL6a-aQ@monoceros>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-6-njavali@marvell.com>
 <c324172a-a754-4194-a841-ec1d813dfde5@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wlq7zktslbm7aakd"
Content-Disposition: inline
In-Reply-To: <c324172a-a754-4194-a841-ec1d813dfde5@oracle.com>


--wlq7zktslbm7aakd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: [REGRESSION] Re: [PATCH v6 05/56] scsi: qla2xxx: Add FC operational
 firmware load for 29xx
MIME-Version: 1.0

On Mon, Aug 10, 2026 at 03:27:01PM +0100, John Garry wrote:
> On 23/07/2026 06:03, Nilesh Javali wrote:
> > +
> > +	if (section =3D=3D TIM) {
> > +		if (section_size > req->length * qla_req_entry_size(ha)) {
> > +			ql_log(ql_log_fatal, vha, 0x0098,
> > +			    "TIM section too large (0x%x bytes, ring 0x%lx bytes).\n",
> > +			    section_size,
> > +			    req->length * qla_req_entry_size(ha));
> > +			return QLA_FUNCTION_FAILED;
> > +		}
>=20
> Not that this is generating a warning for i386 builds on the mkp-scsi 7.3
> staging branch:
>=20
> drivers/scsi/qla2xxx/qla_init.c: In function =E2=80=98qla29xx_process_rd_=
image=E2=80=99:
> drivers/scsi/qla2xxx/qla_init.c:9272:53: error: format =E2=80=98%lx=E2=80=
=99 expects
> argument of type =E2=80=98long unsigned int=E2=80=99, but argument 6 has =
type =E2=80=98size_t=E2=80=99 {aka
> =E2=80=98unsigned int=E2=80=99} [-Werror=3Dformat=3D]
>  9272 |        "TIM section too large (0x%x bytes, ring 0x%lx bytes).\n",
>       |                                                   ~~^
>       |                                                     |
>       |                                                     long unsigned
> int
>       |                                                   %x
>  9273 |        section_size,
>  9274 |        req->length * qla_req_entry_size(ha));
>       |        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                    |
>       |                    size_t {aka unsigned int}
> cc1: all warnings being treated as errors

This patch became commit c3930ec119cb ("scsi: qla2xxx: Add FC
operational firmware load for 29xx") now and is included in
next-20260810 and later.

#regzbot introduced: c3930ec119cb916be879c017ea1e389e05dbe1aa ^

Best regards
Uwe

--wlq7zktslbm7aakd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmp8DWAACgkQj4D7WH0S
/k6BvggAsG7SGFLcknG+/aqI/u1jGCPHEq5z8Jk49ehBP0rOAmmU27VdhIxUL7HJ
rK6HFRcjx4KfzjAO/NHRP+aOB9Rxluaf/enIVaGJBVQxx5RXmyAFxEM6XZKc9Emf
UykEio89rzrgOvDUWRxq8PRdAfDCL7frOZEyC2BPanyo6oe/lPrF44qC0CyBE6nl
+lQ6uKMqMnmvqsyXBQ9SKSRsaX8fKfNT1RYmRk9DyMvSVG6BZNpP2OXlwkmOrEPL
SIpi4P36GRqOwkrCHq9N1OJ4kZkuAE0r5KxKWbQSteKL00mehRgui0bN+pxvZqeg
HcpQfUtsre4sbXVojxGWaKtgnvhXxQ==
=0nEt
-----END PGP SIGNATURE-----

--wlq7zktslbm7aakd--
