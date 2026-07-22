Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7D7361DCB;
	Wed, 22 Jul 2026 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784732946; cv=none; b=OkgFl8cdqxi6Je2atNIqpSF+i3NeetUqwnRKRq/IaUBw+T9i+TUYewCoFDk6m7NOoq+5PwNjKp6/fvhpJK99AEERAQBpLtIMojT+1kZEeGXPOdLC49P/+t52KyK7hrNX6cLOfl/Mh3evVQDXPHSld1nhJdlrDk42PBCTJA478X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784732946; c=relaxed/simple;
	bh=sLNSzKieJAZse/oyE/R+8t6EIeKrMXrPP3SOffBeO94=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4YnkOPOlcnPxRCnxrLgIKgoRfIAOw/no/nMHDhEw6WstKE9i7p5RDBzakdIpqztYG9k+DWNv/eyqQRQ7MarMVfYLnq75nAsKyZmD3Jpy18pO3CGgUqOgUPbUr28jYuuA0mTQH5pgHoY0w++OIOoL3oG74loDAni79o4XppzBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mfNOwFgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mfNOwFgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE41F00A3A;
	Wed, 22 Jul 2026 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784732943;
	bh=QvP9d15jYvscsuW7FvA4UI67DOSLotsiPnAoDt2liZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mfNOwFgR55yqKNFiwxcHPceE6xJiNJyT4A2MJmsxnr1uwYNnn0lUdV6fFtXtQuhNd
	 e1cIzdB+VCRLo6q6Jdd7996FRBtSXQSWAcqmRacDJmpgcJyl8B6vM4qX4bs3KogsOL
	 U6ybTt6nZ2kOEVWKfiRMX1m1iOfCi3NknVQ8fFFn4IZS3rBOgGlzpoZLCEa1mAIujl
	 sQSkmrkN4LtvDjhZ6LtnKBGPPkfgS3G3McAWXnfYQgd5Zg8txe3E6TqvlinHhWfQ7U
	 S6wObqhCtMfgqoUGkEOecRjxdQeErV3/tkWb3vHHFhiDUXG9Ow3FpS7/DYgXIvcAm7
	 8yqTW6f95a6kw==
Received: from localhost ([::1])
	by mail.kernel.org with esmtp (Exim 4.99.4)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1wmYZB-0000000A2K5-45PR;
	Wed, 22 Jul 2026 17:09:02 +0200
Date: Wed, 22 Jul 2026 17:09:01 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH 
 <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, Chris Mason
 <clm@fb.com>, Roman Gushchin	 <roman.gushchin@linux.dev>,
 linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <20260722170901.30bdae6a@localhost>
In-Reply-To: <5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	<20260722042744.5C1B01F000E9@smtp.kernel.org>
	<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
	<2026072224-moisture-gonad-409f@gregkh>
	<e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
	<e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
	<5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Jul 2026 10:17:40 -0400
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2026-07-22 at 16:00 +0200, Johannes Berg wrote:
> > On Wed, 2026-07-22 at 09:42 -0400, James Bottomley wrote: =20
> > >=20
> > > Well, I noted that in my reply above.=C2=A0 The way I was thinking of
> > > implementing it was to add a general instruction file for drivers
> > > which would make hardware trusted for pretty much everything and
> > > then instruct the AI to consult driver specific files for overrides
> > > to this so we could add the additional threat checks to usb.md and
> > > virt.md =20
> >=20
> > I guess it's a question which way around it should be - but I'll note
> > that generally for wifi customers tend to not trust the "hardware"
> > because it's mostly firmware, is generally buggy and can be attacked
> > over the air too...
> >=20
> > Personally (with that background) I'd tend to lean towards saying the
> > high-performance stuff that does want/need to trust the device should
> > opt out, it's harder to get that wrong. If we generally opt out as
> > you describe and then forgot to include something, we might have
> > issues. =20
>=20
> So this is just an efficiency thing.  There are 144 driver subsystems,
> so if most of the want to trust the hardware it makes more sense to
> have this as default but overriden by subsystems.  However, if most of
> the 144 don't trust their hardware then absolutely, I agree, it should
> be per-subsystem opt in.  Part of the reason for the post was to gauge
> this ... and so far I count three opt outs.

I don't trust hardware/firmware. They can be buggy.=20

For instance, there's currently a bug at UEFI spec affecting RAS where
one particular field may have 3 different meanings because UEFI changed
its meaning on different versions of the spec without changing the version
field inside the CPER record:

	https://github.com/tianocore/edk2/issues/12708=09

If even firmware specs can't be trusted, I don't think it is safe to
assume that any particular implementation of the firmware or hardware
would be safe.

Thanks,
Mauro
