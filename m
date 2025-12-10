Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B507C314D32
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765362865; cv=none; b=iarpFLaJSD52uo9esUdP0p3s4lwKrOXaUKIrPe90BZSBiktRPoX7xn4CwDh+Xpgl116IFzPEl1U/60lqX8PMM5eZDv5Rp34/XcaJfxJHL629dTm2Zjj+D0A/Jp6jmqSL2LsjbMWzGY8dvlIyUcETrE23rMRTOAf1DOMNJf7fSZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765362865; c=relaxed/simple;
	bh=77JAyJReGQhUJcHn64+k+GtPdLktUzL8BOuP2P9dao0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4CBNqXuZT6cRo+Xp3kQlfOGdiDBRdebbflQCNLM2QEOF04AEazw6CrGS+d5JjjL8CHSnaSqYjHQlR+K3EYFx+WoSN2z1IHxqn5bKUIsjz7jRniCk8FC1ZU+n1XO0S5mEcP3SrOnwxRGPOU6bgHsfcR0u2nPiyAX9ErolE+slg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=XaMF5u6S; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="XaMF5u6S"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7a72874af1so255695666b.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 02:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765362856; x=1765967656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K5hcqn/1zWGHoJRgkEU9rlk+zfTnmupBpe83iqaDIYI=;
        b=XaMF5u6SY6dj8Nr4Fc9Y879ZokvrZQxMIStL1JYs/QGiuW8TWzYWHZXw+ZwN3fWne4
         XLdXaEpeeANkBP9Z0h4AR3M83qrfCqPJeXqMy5gQSLOPd+XacBFllz63WCpVxnR91oZP
         fh2lIXHUcclds8nCKuNM15d40TYrk+vJbnwgtQEY9PXbVyKgGU9D1zuRmK6jgLmQ3ujg
         lzxXy0bNNk6/2bPWKRPeINRwnTi/xQ2NOR1rfYOaOCVa5DYsfdfW8l+MByTzjChbkNc1
         yXc9pwZjjw3bpc7LHlmgzn1Q8ZVHEQXuYOD7RDiiNqYX3Z6LmJ/AXMpbLeisfs/f5Sft
         5XFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765362856; x=1765967656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5hcqn/1zWGHoJRgkEU9rlk+zfTnmupBpe83iqaDIYI=;
        b=sIidG67iiqYcDOcUWBv5LDvui6qD9AyJdaImjZ7LVAlGIEuaCsW/lphzS2JFuKzMFD
         q7uw/2CELjiz/Yc76TTsETJdaDVmWcHIB+hGzs6m+g4bbRIDd048Ri7idfuCiMaTymMM
         N+yPHcMfwhHGdC1rcNp8WhdJQ6h8TzwnkGeYEotgMJEaz5gn+I73VYm2Qy3KOSoA1SzV
         EakJ1/Vq2t34fnzhe3QNv88D7x8y7dBCjex9//8i4Hu25+6b5Oppjamf41u6iZSFrkxZ
         eeVPv9DB078CJ75PXkjRln5p84UCLM8hda1t/eGjHjU92OUBfTafA0K7BSsyuYNN2mgk
         Lxgg==
X-Forwarded-Encrypted: i=1; AJvYcCWBBR+U8C1Bqzyl1i40pqG9srEHuZ/AwGKa/PGw1TDd05PP5qB37kucUCRi6SpNwpeykafaOa7pi53t@vger.kernel.org
X-Gm-Message-State: AOJu0YyRpcOq3yjMC2p/VGlykRG8JFgO5ZYleGmY26sGPK9c8f2u99kp
	lw4FDJ7O4kr3rDiGZOTu2tFcYNFrfKDZuL7hjveTdMGuhmp1AdZUONCkap0D4SWEUyY=
X-Gm-Gg: ASbGncsS3Acv3qvAs2oL9WSt+ziY26qGYDjf8KkvqnzcPxX9Uma6sCdhR5xdEcqOzpO
	aP1f4GCJyth0uW4Itw7t3h21gNGMk2fVUlZJOHlFBqYPZ5uL+sIsUnPPRy9AUb+dR9sEIkUdQyL
	kP+05Zxa0gTAAQpzrOhVsTeelMPDMbNxtYe1ny9wS+o2Hfm9gcgOaimeBpH1I8VnoIf1L2FScNt
	dlCgyVpGi77lzrfBXeVCiwkTIqqzUpziZnDDgNyE8vMRHUU5RxxZ9UEDuiepUPYEV0xnj4nT9YF
	QdxCSrF6euN4UiMpkqtMNUTgo/aHAkhSYO4Tvdtb2ul4KqEu/CT0CIeLzyQDivjl11t39ZgMhFv
	eTLrLUdGZLPjDrpbk41uPPcPYdTSW5uV2kYXe9x/8Cz0ZVaFem7gYpcQc5bELTamiDtrpZNJuKg
	AfUegBGAimt4AVEE2lkzpCf2n6hsoa1xgl/rfH02dErLTuUoQ3PuN8nU3cvlaM8Hr28sA1W1CHW
	MT7zIvlQ43oTQ==
X-Google-Smtp-Source: AGHT+IGLp+qs6xfi9W19mY/6hH1kCjXZmS/jIOyzFZ0+C6PfqHxwID76laljZr3RPN3OIPwimAvT9g==
X-Received: by 2002:a17:906:f583:b0:b73:2a77:3128 with SMTP id a640c23a62f3a-b7ce83d37b1mr191871366b.27.1765362855676;
        Wed, 10 Dec 2025 02:34:15 -0800 (PST)
Received: from localhost (p200300f65f00660876e6d1cee70127e1.dip0.t-ipconnect.de. [2003:f6:5f00:6608:76e6:d1ce:e701:27e1])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b7ce9fe43acsm141167566b.55.2025.12.10.02.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 02:34:15 -0800 (PST)
Date: Wed, 10 Dec 2025 11:34:14 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
Message-ID: <l2z6kvliwus5hq6kuf4q6yjgzx34vw4euku6yca4x7mukvlepk@4ewau5pgjxp3>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
 <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>
 <akknplwphiv2qllb6s3k5cpyqz76coyvbutmwln4bjtsi5rxqo@twezemfbfiow>
 <aTkEkPEhrcbvGzYo@infradead.org>
 <77keukzmb57v2jyf26ulsystu77f2k5ta5k2vjxk5hygypzb7c@4kvu4hdty3o6>
 <aTkbiHE45DDeQhH3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cpcnvxnd7etut5yc"
Content-Disposition: inline
In-Reply-To: <aTkbiHE45DDeQhH3@infradead.org>


--cpcnvxnd7etut5yc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
MIME-Version: 1.0

Hello Christoph,

On Tue, Dec 09, 2025 at 11:04:40PM -0800, Christoph Hellwig wrote:
> You will notice very quickly when they break.  And it's not like there's
> a lot of them to start with.  Please just finish up the conversion
> instead of leaving it lingering.

I somewhat understand your position here. But with my Debian kernel team
member hat on I really appreciate if for conversions like this there is
a major kernel version that emits warnings, so users hitting problems
can find hints by just bisecting over kernel releases (that are packaged
and so don't need kernel compilation skills). The bigger picture is this
conversion affects a good dozen of busses. The todo item to convert the
scsi bus dates back to commit v2.6.16-rc1~164^2~32 =3D 594c8281f905
("[PATCH] Add bus_type probe, remove, shutdown methods.") from 2006.=20

Also my impression is that scsi isn't very healthy anyhow. One thing I
spotted is that there are error paths e.g. in scsi_alloc_sdev() when
scsi_realloc_sdev_budget_map() fails that free devices that had
device_initialize() called (here: scsi_sysfs_device_initialize() called
device_initialize(&sdev->sdev_gendev);) So I think there are bugs and
cleanup opportunities in drivers/scsi for someone who cares about scsi,
that make me wonder about the effort you put into making me cleanup the
comparably small issue of three trivial functions for legacy handling
that scsi used for > 18 years now.

Call me conservative, but I really prefer keeping these three little
functions and thus be sure to not silently break a driver that I might
have missed.

And yes, I intend to complete the conversion, just group the remaining
bits that affect scsi to the final cleanup of struct device_driver to
minimize the time window for silent breakage (even though I'm reasonably
sure that I didn't break an scsi driver). The quest will consist of ~
100 patches in sum, each patch that has a safety net until the quest is
done, is a good idea from where I stand.

Best regards
Uwe

--cpcnvxnd7etut5yc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmk5TKMACgkQj4D7WH0S
/k7xUAf/RAfluhXQfDTsaliknnmifma2vyxj80+bnsZA7TAPJ0vWvr/OGFJ9d6YR
NdahX6GYkBkkHIQ/HKErFE52gRAEKTcMO7TLoibgGdo00OgtXpmwS1EoSLtqA2zW
G72GHks0QBM/6dCJsJM408+Pj0qAZ8r1hY09CnZkjGcWhsmh3zXyCb0luK72X0Q3
c+5517PaBueYF4L+7yy9J/xqins8LsNgm+GLiNGd3mXFTSuO6d8RR7sncjy9MgJ1
PKaOkYmcgO4fqpa0u1JG7DRj5BWj/92n+dgPwrG0SF2HjzdyhIfoKr2HNdMev2Or
/naZ+dUY+JRzysn7EOVGp4orMSeQMA==
=eLH/
-----END PGP SIGNATURE-----

--cpcnvxnd7etut5yc--
