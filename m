Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC403655D9
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782348804; cv=pass; b=db/5Rp+HBuEepjais/qJxsJfKL5bN8FddRbDVBwBj7tL7L/FbPcG3iUxGlsPfLruRCJCAJmAQMETOkYmiizIxaNu9475jjcwP2xmxoKTG2MHG4EZ3QBi8X3CEFE5wEAt/IITRzLp90hkxr//93MKU9PErjqnieuOV0vICppaYyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782348804; c=relaxed/simple;
	bh=azxv2GY0G+rJ+lOMGsdtnmCxRBE0KOlKQqQxuEUNZns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MaGbNUYmEvZP72zmZRo7dC9ZvnkCuP7bz1SKJUXs4zzx8oQxaCB3MY5SCVL9v9UsNjBhku4kfl680AqEFmUDM0lbXMzXx1Fes/ZNONGGzaeN7F4jsrgtCNFAy4r9anyfFnPY2f/pHZsRoShWQq8QjUSQhTRLdf1lot5WYBfY6xQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=everpuredata.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=everpuredata.com header.i=@everpuredata.com header.b=aibwBtv/; arc=pass smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=everpuredata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=everpuredata.com header.i=@everpuredata.com header.b="aibwBtv/"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-730ac3bec38so593038137.2
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 17:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782348802; cv=none;
        d=google.com; s=arc-20260327;
        b=GZ08O/HBEswmhcbmMod0KGq+1NOjqI+3tG0SOMo1s2tSqNXiYakc5eb9LuiZqiuUVF
         +lcqKONfuPwy5Trm2c6BrQxKyubgzjJjW44IOu6mLsS3ZcOPwcN+29fMxsYmg1GF9a0c
         nPCGyFBVjUIP0xjT/paghxR7lsWsrupy9+cGE3+01IVbMxG94inCJCeCzngqC03Xp3ny
         5yKLt/6pqMqe4vRe0DYUg/KOkLg58tznkbA3rG0riqA49N+qimPtwHyqJp0DfBkTNGk4
         6B9Zm1MFrC9g+Zw11JJyzxVAlUT/swnJhu2VAwa/AiSnxpheyecmkWGSol/m8xz6uSlG
         VI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qY6KgmWUgw7fhczkkTMBwJb+99IHOmGzkMWso7v9Fqw=;
        fh=jb06RPnbSZnzBdqpStRef1ODf3RAl01+nmB1gbeY+QI=;
        b=YnWQOGmqUhDbpF116vSJtlOE48SOMHb8xvhD0AO+xI9zD9I/8dDV0VlDh07BuSExP6
         T69D5XskYDNYDA3vQVrpBWMCxfSsc0QK4qO4YYihq7XE1Icm4ACAQfmHLTna5pzD19ia
         PDTYZNzXfI7KzpEuOO/8p/cnr8EHyklRXd78xm6acNaCWgpZhVzNhh82M2AausAXyw3y
         QVlCWatnlIknYhGrgWA/G+nAUyS49u3h40Bkw+i6IE6zLKYPCBzH3TR8T8YIxIrAwk0h
         7Tmb/6SsolI1lQ0Dh3mDQmlzFgRtXBtsYu1Gm0+ZXzT0J+Sqtvmv8ZxJ4lxkrCWcngAr
         rDuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1782348802; x=1782953602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qY6KgmWUgw7fhczkkTMBwJb+99IHOmGzkMWso7v9Fqw=;
        b=aibwBtv/Ul6GFnq2aoQfYkatF+93/42USH5Rz5zZOLFMbEL9qM9vHJoXNtzmYmD9Og
         XFLoMwnP9/ENGsDx+wQX36jnpKVjdbBjsqrAfTG8WGwXh4WNC4f41HO9utQibS5vQNGy
         8CE37P/rTvod9lIqVOYx6mEkKzQ8nraPhtgPwI3sMjuwPZVa8h752EHLcM7IjNJ4vSZB
         ck+XpCufOPr84jghTjzckq1svl+zwkH6nioV8T4hp/MaNYsJyb7xd4iQ55ZXA9v7LGJM
         qm4cjW2wNcgvft6Laq5Rb1GMH5XVtyk3fA0IfID64N7kXItfHEoHyqIKuu2k8ioIGW3V
         cqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782348802; x=1782953602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qY6KgmWUgw7fhczkkTMBwJb+99IHOmGzkMWso7v9Fqw=;
        b=eo/f6tBDK9f5pBRPb2VlY5TQBjWqrMhZL4vp9pdXUsYDN1rhC9/WLoxDmHmIiFPBKP
         ihWoAr9p26GjaqNaT9qt6yOVX+dFceZo9QF5veP8gXxJzJ9nDAeWQYMooThBaUEByl5O
         wdyOShQNpPKGevqlGrIxg5zqYlibwqnjKn/HECueowmqshw0/x/qMS4j4H6TE0hBj7OR
         OLOlMoyYS+hRii5SLuQ9jJf1fTsP9rMmFnIOC1kv4mbUdOyC8wspGX30gEwDp9oKd7Om
         6y3y7KffJjKUDHFJ4QCapcZpLCd5KKrmegKB8/oRsBKyon8tjNgN3tpq3K7TsmJ+OtkX
         TVVA==
X-Forwarded-Encrypted: i=1; AHgh+RpS79b7t/thnPkK0VrVA0Ezz31F+W4l5ub/iAihpBS3Fa+Rl2CSKqwlmBbCXZAjZ098B4AnDB2c9lnR@vger.kernel.org
X-Gm-Message-State: AOJu0YxTNZEa5Ua6f64RVbbdOdVBfN61YUEnml8v9hbizKQh/o14r/AV
	pebTwtGNcRwMc4/mUlY0mQFksrhU7kFwmQclrUvj9+oEefkb3EL1NYKqUVd9+rJ/wCEFw+ow/ub
	xAwkeT+ZvKUnpHpC0UCIjm3yRYU4WmRfcFYE1Lm9nhQ==
X-Gm-Gg: AfdE7cnOtYUAHP3Hs653Xqe2wCmth+y4OYsPlZK24I+ZbjFK/ENjwtI5ERHdd+fvaun
	iop6HtDYSJ8ivz1nhZSp9I8JiE2XGXWhSkObns+epv3/RMPWMLhV4mkFNu1WRljs9f08TqTU0IE
	eO7mFkdp4bLALvcKQIdXckrOMNybxeltJnPCiqIJRkT6sNpF1VdGCeaxwRO2/nm0x3Vhc9Sogu4
	Esn4f5yhuVGil2D5IwhNOOBMdzKw6uoPqh4lpcOXR932y15enjWMq0arkbhmZvWzFH67nhL/grG
	xEgIPutZCycCvgxCPFd36IsgpHp492XTwuvk1wIvji36S5vkiQQRlsTpz9s=
X-Received: by 2002:a05:6102:3e20:b0:66b:a0d7:abc4 with SMTP id
 ada2fe7eead31-73430d8bccdmr122489137.0.1782348801771; Wed, 24 Jun 2026
 17:53:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu> <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp> <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
 <aaXE4s3AT45UIAN8@kbusch-mbp> <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>
 <ajRpWLqaEyA6cwkJ@kbusch-mbp> <531aa19b-a9ae-44f7-82ce-3714621ceee8@suse.de>
 <ajWOWdD0P5ri9bWY@kbusch-mbp> <d46493a3-3c9c-4799-bd63-e8759f04463c@suse.de> <ajxXMblhuipjnbtS@kbusch-mbp>
In-Reply-To: <ajxXMblhuipjnbtS@kbusch-mbp>
From: Randy Jennings <randyj@everpuredata.com>
Date: Wed, 24 Jun 2026 17:53:08 -0700
X-Gm-Features: AVVi8Ce3Xi6Wvuopbv3TazswoE4m1dwi9cB-m_9FXoP2lZ-zwtOvtLKD2Qf4kjc
Message-ID: <CAPpK+O3tdk7X34od+WoM+dM0BQCajjDeBOUx1jja0zF0uUuUmw@mail.gmail.com>
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during async scan
To: Keith Busch <kbusch@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Maurizio Lombardi <mlombard@arkamax.eu>, 
	John Meneghini <jmeneghi@redhat.com>, Maurizio Lombardi <mlombard@redhat.com>, hch@lst.de, 
	chaitanyak@nvidia.com, bvanassche@acm.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, James.Bottomley@hansenpartnership.com, 
	emilne@redhat.com, bgurney@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 4:02=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> > In general I fail to see the issue here.
> > Any modern distro should be using persistent device links to access
> > devices, so the actual device name is pretty much irrelevant.
> > We on our side haven't had any issues here since ages.
>
> I agree there's not a real issue here. The suggestion is purely a
> quality-of-life improvement to provide a visual clue that aligns with
> people's expectations, reducing any surprises. There are people and
> documentation that still think the "n1" in the nvme0n1 means it's NSID
> 1. If we can easily align to that, then why not? But I'm not exactly
> needing this feature either, so if you think there are some "gotcha's"
> here that may destablize the current scanning, then I have no
> problem shelving this one.

There is the issue where the NSID of a specific namespace can change
when there are no hosts connected that it is attached to.  It does not
happen often, but it can need to happen (even without namespace
migration).  This is not speculative.  Over the course of years, our array
has had to do it for specific scenarios a couple of times.

However, the more fundamental problem is this:
> That said, many users still rely on /dev/nvmeXnY links, for example for
> some nvme-cli commands. Because kernel 6.11 made these names totally
> random across reboots, it's causing some confusion for them.
Relying on NSID to fix references to a specific namespace is not a safe
way to operate.  And making the device name predictable leads to people
taking these shortcuts.  To find a specific namespace, the NGUID should
be used.  That guarantees you are on the same storage.  Enabling
shortcuts that are not reliable is not a good practice.

Sincerely,
Randy Jennings
