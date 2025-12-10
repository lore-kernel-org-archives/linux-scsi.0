Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6223E23EA9D
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 06:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765349779; cv=none; b=dC799+hdbSVVsHSGc6w3ROeFBhzf13GtGznXBIMVN/mFCLekNfBUqWJwQ5q0w+eQ9MqaYsLTshv2/tVFF3qh5E/+hEZ8lgldBL6uGXchC9zIUhzBmHfjQRzwwffX3Q3dzWS/ZaMe+bZ3sueIh73bep2IcaHGAc0yLv4+cCkG/Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765349779; c=relaxed/simple;
	bh=WE5kx43S3Nrjmx5KnHcPsEe3cW34eeby87CXEjkdGOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWIcSEVDSTPlGlPE9DzGCAYBCDm9pZjg2FD5MjyqwkvPk9lIxalcihXP5Kcb6OGsdikL4KQmlFkT2ipZywVITWM1hFCUUt9RMKqdkm6axRxLReCs9mhBAmsdyO3FRcs7i50K95MUyEvxkjmqgY/Ny0hmHrpnNcPM1zwK8E3LqjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=O2B84s+f; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="O2B84s+f"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so10310813a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 22:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765349773; x=1765954573; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qnOVsTgOgQ5QmfRoRVc9rB7NClnxZYnjHuAkqtJcwqU=;
        b=O2B84s+fXQYKWEJWYoloWf07hddTCK0C9u0TqH5Hb2FW42MSz4vr+wjfd3VUE049ej
         2IFyJsI1aeJO70obp7bap+2jesMzOz4cgso+E+E+LzJkCuWEz1g/XnvyNtPFPZFLJV13
         188K2m2ygttm0G/rya2IDxnozP3wEeqjVxuixnz0p1jhIeZp7LkUgvmt+xmn4KetBHEB
         bF7d++w8wPH3ljbC7wULRPgtTANvHi6e6XWxZ3K5fT/2GWpXgCHEu2+Z1bVvEBnOjSsw
         1bXMa/Wmn2pMTkbqZeFrDpFlEA5OlYfmdWODCxHj4yzlIerThby+hlskmu4MOD7RIAj6
         FXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765349773; x=1765954573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qnOVsTgOgQ5QmfRoRVc9rB7NClnxZYnjHuAkqtJcwqU=;
        b=qDbDQpQjTC/YT2f4TTgtcahDbk0oR1yiN+RfLhp4i4N4Bod65FiZmNCvqLEpvRHCHO
         Q0on14XDFF2CzSDfZSpYLYhzPrC/I+8TbYJJaf6WbYJ5koskok1soDxoERhb6L2S6Pmy
         4Xfo4di3ZTA99qO12ZVGIaiORc/MYi+jg1G7Tb1nb4IgukZeQ/vbVmldlENwVAFds4a7
         PRaeM8dNk75XXfPGq8CFb8/Ug+TKHs7UJ9TEQJv5Rad9lcPEVFEfXj7IyjUMigeVmIcB
         331FqYwQUE4AsMk0gfHMv7jOqQCSF//DdUUfcqwIy4eok7dVEzzKkxt/RyuiwXL8eb+0
         DPHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtcBYgr7UMLpbwMUsV8ESX2/f8xYLwIX+4Dkk4o5Ona3X5tAbCI6OXvf042sLkLnzQMuMBDYf8J44B@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Lbwn9Q/z0e29wR6+4NWLrNvOn6kLQHGPA3nYvuP2gSJ5inKV
	4HEJvj9XODozzTWzfi/0rjYsFFIsHYVGHekPmWU5BQXZnERfa4NFXQ2xgEqIyI0MKiw=
X-Gm-Gg: ASbGncvenejPlE80leTt2Hcl8SNuGsmLgxpdYV39VefzfyQ3CGdh+ZojGECCIJ1JGL9
	3BmtDLAshUOebbs2niXTQK9U3Y6KNu9PqDrfdSu27TgoECY5zI3Qc2A4srTLi638pVRHhs/JaRR
	444EbRk9lqVP2GoQOHfIDvNEnmUo4iBUs59UNChnL8YtwNztdFAwFz57VW3cAPpdIxNjfiGFqdv
	ixNyy6Yu6doMvdpYSlw88X+SgK1QyX9Rxq7dMEiYG0Y8t48qnzbo6MHRxu0rkfpEljlpL4xvp8/
	CekMdcteW2MGXxy04jd/7ww5OkscnoLbH8TM9BYfKmSzm5a9b6mhE8aHnnzbeWk2tuGeB4kKTeE
	KPd/9xIDd68TVCowTbH94ydGql+A7BUZzRSBo4nKiAnJYPnsuPoFTcdo04g2/rSySs7pwCdltnW
	o/kMJlIqMkGReKl8PZ
X-Google-Smtp-Source: AGHT+IHE2VckPFxujmI8wD5fLvQPSt3JS7yZ3jCsqp9dpeRVmrIz3BsCGeCCCxScWY71Qwk/ZgY6KQ==
X-Received: by 2002:a17:907:6ea1:b0:b72:5d9c:b47b with SMTP id a640c23a62f3a-b7ce846ec20mr109558466b.36.1765349772508;
        Tue, 09 Dec 2025 22:56:12 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f49a89afsm1635042866b.47.2025.12.09.22.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 22:56:11 -0800 (PST)
Date: Wed, 10 Dec 2025 07:56:10 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
Message-ID: <77keukzmb57v2jyf26ulsystu77f2k5ta5k2vjxk5hygypzb7c@4kvu4hdty3o6>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
 <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>
 <akknplwphiv2qllb6s3k5cpyqz76coyvbutmwln4bjtsi5rxqo@twezemfbfiow>
 <aTkEkPEhrcbvGzYo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h6fwyjuifbwsskpg"
Content-Disposition: inline
In-Reply-To: <aTkEkPEhrcbvGzYo@infradead.org>


--h6fwyjuifbwsskpg
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
MIME-Version: 1.0

On Tue, Dec 09, 2025 at 09:26:40PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 09, 2025 at 10:22:54PM +0100, Uwe Kleine-K=F6nig wrote:
> > I decided not to do that as part of this patch set. In case I missed a
> > driver and for oot drivers I think it's nice and fair to not break them
> > immediately and give its users/developers a chance to see the warning
> > and act on it.
>=20
> No one should care about out of tree drivers.  On the other hand
> unfinished transitions are really annoying and have a tendency to
> go stale.  So please go the final steps and finish it.

Given that the whole quest to remove the device_driver callbacks will go
on for a few kernel releases and completing the transition for scsi
yields to broken drivers without compile time issues if something is
missed, I think it's sensible to keep them in the "working with warning"
state for a release cycle (or even until the driver callbacks go away).

Best regards
Uwe

--h6fwyjuifbwsskpg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmk5GYgACgkQj4D7WH0S
/k7/gAf9Gs2dOFe4FyF+r0xPDY0pZ9jNl+nkMIkz8s/wnRCCkw4aArpanLfIxunR
4oQLVwq+C5LITJdKVQVjgTFDE1bnDcJL8GQ6NfATAN0DVdOUGy8qqo/NkFTOK/WX
y4u4Ytn5MMXBbk9sQiy1/ZYfn7Tkf4r18mBAAAYBMcujEdhfb4YRKVRAORsUchpV
Na6WDp8yNKhl1sn740mj+QfbFYcbehp8EhtHrLj53Pg6MVRMCIMxOUvhhBn7yUkv
uNuqWQ0x+1ZI+YSMKVszTtk5X3g8dNpmek5uI1VvNwV+S6yY+kfB6LnJf+k4LE9w
UEhl9+MMdcPumIsjnEQT6NvJ8+4Lmg==
=+5L8
-----END PGP SIGNATURE-----

--h6fwyjuifbwsskpg--
