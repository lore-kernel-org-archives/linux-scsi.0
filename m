Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F43E8C44
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 10:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784282434; cv=none; b=P8GLv7DwSg4tieNh9mPwIVlrkyGUVbPBZJ67mdbyXGoAuC9N4Yh1B8gtRWmjr7zGrbwWeM000VJ8tMQuLD10AX3t1l3U1XcD9coFUNrvUqLVUd6TmaHRpCEhSeg1Jc0u6N++ahnWdwbJv2HNOHZE2DgJ/62sIDThCxofVfUcSCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784282434; c=relaxed/simple;
	bh=wqeOxIUmW/5rNTe7Q00XfnZ+4jLXJEKU4+fa0njPZgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLchS+AYwBpRR8byIz58DEo7JD6hf3i44gM+xhVaBaziksGhx6h0WgeaEWmC90zygCHYOqsgPFdZ6G3vUguw3zFl73h9qDvFNmKosnGIBle39BEnCzwkHBlYj1uU9jxf818e/4Hwb2aguLEfem8l/lUjR2ORwAJI1b1k+xGkMhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=W9xctcQV; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="W9xctcQV"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-475417f010dso4029929f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 03:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1784282431; x=1784887231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IyEIycUP0tCRfyw5Mgo3r7EgIuywkzFDlc2uwJwMEek=;
        b=W9xctcQV17589VXOX4QiHt8hKfte7aFOfI7jLYpX6jjoWiZcskNY9zLMp673vV4FRn
         K522ooQMKwTcr4SqKJzMDNoh9Eev6hbNRyImhOmBMqswhb1vAkG3mc/U+auJDI9lrX/3
         DD17p4FN8WBe376ZVlFrWSJYIuiijFgQB+AUNZM76OFic6mRinZX22ftrGcxtRr/IR1y
         1HEchMOjsvzQlWqm9pb+YUJawdwr26YuxnhBNwzVlsgyrE8ZmzecKU5keo1SxvKdlF3x
         wJce56M2AUrJqv5c4/wtsuexfjRO2B5oLXPxm/csEoyDFtDgjqPY3vXsYSLIg/DCC7o8
         KhpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784282431; x=1784887231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IyEIycUP0tCRfyw5Mgo3r7EgIuywkzFDlc2uwJwMEek=;
        b=MHC8CDs55hTtzmOt4yq9ihblPURCKQKDjiPGb1m2fwBIxo0R3Yz5nfPP3rtDPPySAQ
         eNl5Exh1oDjHlf0fDfmUnobdxJSr/thxojP/F65EqDCrqTIP+OgZtHYrrbbuTmO+MrLv
         Bf5ftpWGzz9LXoZATIE81jarNR9xnFH06KfmYHn0fclhmCnOr+jj2VD81NK4IYLmsXog
         qkRyLWoVb+e6dEsZbxuUNsxEcRVG58oexButhxIY3ds2jUO6F3PPoiLlprCw+X00Y3uw
         N8Bl7sgt47fx4iUeK80RiC7AnNjpsk63IcIKqweyHfkCePXOxLUAg5nCAYHb9aELzbfW
         TZ6w==
X-Forwarded-Encrypted: i=1; AHgh+RqNCyKfxwLa0heZllLTbEvJA5QXdOyg6PVvL0nnuKzfRIUxuVwEWbrRMGDAqBTNvJt+QPN8gq96fbRJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvi1ucSEm9DPirGAJ9M0dO0/Q9Ed5hL6YbTjkqPgUbQ2+CKUje
	5cRMl0dVrxC/ApGX4aoTUHHuHljtthMHrWLY5euPv7DDByfp92N9gCx7fmVqqOvX8Hk=
X-Gm-Gg: AfdE7cnGfDA0e+LG/zMRQVqt5bN7W8nDd4jPMjyAuGI97+24sGDjU6td/QoXVLqCA4Z
	ggvlxW8NcQ22zNPr/dF6lwXqWPZ/pCJpFCGFmxS/OtLy9KeWiIxnaWrFxcQYCbSYhtDUZ7awdrT
	a7jwCkQI4g68e5ieMpkiJ7DKAWVVlEdTPbQQ2zIICmAeeF64s3th+1sdGDVqXjk06fCvG+rg657
	f/mfPd/EQcn4vNy2UA1b/wga2YKT/bDSH+Hde2j1kMVg2V62y5Edv/WlJcvanACj+9dQWEnEtog
	z3hfnfAKZ8e+8rawl99g1FUcHTMlsfi2b6v0tfC0kyayTulKDd15W0z9fvReKX8pIXC+2haMX1e
	SU4FZ0PiyhbGej8FFqgX0G6Pmt0zvYbsY4TBA8R4o0CTdVFGTjOp2mhj0p4oWqBuvgy4VkYrCnV
	Dhg9OYJ7EtmhBtZhlxU9r8L+LjzytNT4sYHvbOMAcUySh03OOzL6hUYA8GbjRP26TyeZodVS0go
	JSA
X-Received: by 2002:a05:600d:10c:b0:495:409e:bc80 with SMTP id 5b1f17b1804b1-4954a51b852mr13356225e9.37.1784282430507;
        Fri, 17 Jul 2026 03:00:30 -0700 (PDT)
Received: from localhost (p200300f65f47db047d2d8b161e35ab77.dip0.t-ipconnect.de. [2003:f6:5f47:db04:7d2d:8b16:1e35:ab77])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4954a2e83ddsm32621095e9.10.2026.07.17.03.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 03:00:29 -0700 (PDT)
Date: Fri, 17 Jul 2026 12:00:27 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adam Radford <aradford@gmail.com>, 
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Matthew Wilcox <willy@infradead.org>, 
	Hannes Reinecke <hare@suse.com>, Finn Thain <fthain@linux-m68k.org>, 
	Michael Schmitz <schmitzmic@gmail.com>, Ram Vegesna <ram.vegesna@broadcom.com>, 
	Yihang Li <liyihang9@h-partners.com>, Don Brace <don.brace@microchip.com>, 
	HighPoint Linux Team <linux@highpoint-tech.com>, Brian King <brking@us.ibm.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Junrui Luo <moonafterrain@outlook.com>, 
	Kees Cook <kees@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Lukas Wunner <lukas@wunner.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Thomas Gleixner <tglx@kernel.org>, Duoming Zhou <duoming@zju.edu.cn>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, storagedev@microchip.com, 
	megaraidlinux.pdl@broadcom.com, Markus Schneider-Pargmann <msp@baylibre.com>
Subject: Re: [PATCH] scsi: Consistently define pci_device_ids using named
 initializers
Message-ID: <aln8-b9iFDzAPo6V@monoceros>
References: <20260429101820.3059523-2-u.kleine-koenig@baylibre.com>
 <aigySpryV0ptiBqr@monoceros>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r37dgzn723qnryre"
Content-Disposition: inline
In-Reply-To: <aigySpryV0ptiBqr@monoceros>


--r37dgzn723qnryre
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: Consistently define pci_device_ids using named
 initializers
MIME-Version: 1.0

On Tue, Jun 09, 2026 at 05:34:40PM +0200, Uwe Kleine-K=F6nig (The Capable H=
ub) wrote:
> [Dropping Bradley Grove and Michael Reed from Cc: as their addresses
> bounced]
>=20
> On Wed, Apr 29, 2026 at 12:18:20PM +0200, Uwe Kleine-K=F6nig (The Capable=
 Hub) wrote:
> > ... and PCI device helpers.
> >=20
> > The various struct pci_device_id arrays were initialized mostly by one
> > of the PCI_DEVICE macros and then list expressions. The latter isn't
> > easily readable if you're not into PCI. Using named initializers is more
> > explicit and thus easier to parse.
> >=20
> > Also use PCI_DEVICE* helper macros to assign .vendor, .device,
> > .subvendor and .subdevice where appropriate and skip explicit
> > assignments of 0 (which the compiler takes care of).
> >=20
> > The secret plan is to make struct pci_device_id::driver_data an
> > anonymous union (similar to
> > https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylib=
re.com/)
> > and that requires named initializers. But it's also a nice cleanup on
> > its own.
> >=20
> > This change doesn't introduce changes to the compiled pci_device_id
> > arrays. Tested on x86 and arm64.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig (The Capable Hub) <u.kleine-koenig@ba=
ylibre.com>
> > ---
> > Hello,
> >=20
> > the mentioned follow-up quest allows to do
> >=20
> > 	-	{ PCI_VDEVICE(TTI, 0x3220), .driver_data =3D (kernel_ulong_t)&hptiop=
_itl_ops },
> > 	+	{ PCI_VDEVICE(TTI, 0x3220), .driver_data_ptr =3D &hptiop_itl_ops },
> >=20
> > which gets rid of a bunch of casts and so brings a little bit more type
> > safety. This patch is a preparation for that.
> >=20
> > I assume a single patch for all of drivers/scsi is fine. If not I can
> > split per driver.
>=20
> Is this patch still on someone's radar?

Hmm, it seems it isn't? Who is the right person to prod?

FTR: The patch still applies fine to next-20260716.

Best regards
Uwe

--r37dgzn723qnryre
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmpZ/TkACgkQj4D7WH0S
/k4xwQf/VnEmioC8FCW5Ncvp7+gyqhkHvcGCyU/nsGhIZWW5IoHPdkJAiAiQPBRB
My/lY/RZxov08i89DVATsE25Ht1QLoTb7ACOfBzVd+X+Q6cCm/V1HsGrqGH7h5yz
tEjqztO+uiLCsB6/CjjnEIkrogjuoP6wT/fP4eSBy4Bggnx/sOyFX+uo3Zgo4MHm
JIBqSFu9qH+eeU4D+O8PxMl91zUsZ0S2/DbnnhfRmm3u3nWuQEhkGVuordux/EGC
qckWm81ioee2Qu+8lN8KmBWB3Nv2EMoQ6R7gDWs+fr5pzMHHnKzH6vjDQGa9xq3T
AvnzuB+KI/UCWcuR0medIUDxP2C/Gg==
=1KpO
-----END PGP SIGNATURE-----

--r37dgzn723qnryre--
