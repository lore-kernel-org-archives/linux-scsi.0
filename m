Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D060C43933E;
	Wed, 22 Jul 2026 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784751951; cv=none; b=jKmO090X6UBfUQK2C0iCsbrp9f6VjC0gy5ombEPfT0NoPDmhlmEvThU+Y4LPXh2tMMzwdrPR6AlMwGsDQuk5Tjk4+/76ekKcTZ1HSSDmrILAlfa0R8hO1GvJoe0/pizRRg5DZtuGIaarmUPo598ONYBMVMpff+VkhCgRpKvQ+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784751951; c=relaxed/simple;
	bh=79urgaqBei75EenLhvUZ0F2DLG/0QKpQ9L58tzCfTfw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttA/HCFHk7Zhh4ec4cQYRTjvdPvHxZIWjhGvHYyyDH2p+gb/088DKk9EYznIpXkD42bWJMqoZWsYUoCYVX4SxxWg0OOI67eCU++C/A0tf3Q+Ttk8Rf7kT7kNB5gzQcqrkyG7FQVAFOXWFbecQxvAHJznRHa8yncb5YacfAPaXtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdoQby1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdoQby1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DE1F000E9;
	Wed, 22 Jul 2026 20:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784751949;
	bh=4nEAXoFntF8VgCkl8w1GI6aqAiYf84Td6tNogyTbW74=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OdoQby1ymbwJnETnnxXBvIK0j3kWjZa7oaf/tjXlIV+NDaKgEThIu5HbLDolciZ7Q
	 VfokpebCZeoXQAzl/4eaumJ9vgY0OLsMXmJRHkhTGGMRIvwIUFYooXt6LG7Y8ZgYdW
	 RFH0SG/d4dhbY9iQmlsJbBsh/bU9Tp7zNYOg1umeGLXibaqyYPuS/NgOIjeRzHAEfM
	 y647xCGucXXHkekFpWkS3Fvy2cIHcolHYOc3yfdk7gptrXpCbEkfkytIV9+e5J9CRY
	 QmJ5BP9oQVF5PVBbXPfUFtub/B1MjEDdI0p7b0Qxlx4FvbMatyfDGIlbliKHl+11Wa
	 U/mQ+WKGVKU0A==
Date: Wed, 22 Jul 2026 22:25:44 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH 
 <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, Chris Mason
  <clm@fb.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <20260722222544.06a1dd1a@foz.lan>
In-Reply-To: <a05e2ddea75895afdff63425d2fd47f90bdf65c8.camel@HansenPartnership.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	<20260722042744.5C1B01F000E9@smtp.kernel.org>
	<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
	<2026072224-moisture-gonad-409f@gregkh>
	<e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
	<e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
	<5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
	<20260722170901.30bdae6a@localhost>
	<a05e2ddea75895afdff63425d2fd47f90bdf65c8.camel@HansenPartnership.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Jul 2026 11:24:38 -0400
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2026-07-22 at 17:09 +0200, Mauro Carvalho Chehab wrote:
> > On Wed, 22 Jul 2026 10:17:40 -0400
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >  =20
> > > On Wed, 2026-07-22 at 16:00 +0200, Johannes Berg wrote: =20
> > > > On Wed, 2026-07-22 at 09:42 -0400, James Bottomley wrote:=C2=A0  =20
> > > > >=20
> > > > > Well, I noted that in my reply above.=C2=A0 The way I was thinking
> > > > > of implementing it was to add a general instruction file for
> > > > > drivers which would make hardware trusted for pretty much
> > > > > everything and then instruct the AI to consult driver specific
> > > > > files for overrides to this so we could add the additional
> > > > > threat checks to usb.md and virt.md=C2=A0  =20
> > > >=20
> > > > I guess it's a question which way around it should be - but I'll
> > > > note that generally for wifi customers tend to not trust the
> > > > "hardware" because it's mostly firmware, is generally buggy and
> > > > can be attacked over the air too...
> > > >=20
> > > > Personally (with that background) I'd tend to lean towards saying
> > > > the high-performance stuff that does want/need to trust the
> > > > device should opt out, it's harder to get that wrong. If we
> > > > generally opt out as you describe and then forgot to include
> > > > something, we might have issues.=C2=A0  =20
> > >=20
> > > So this is just an efficiency thing.=C2=A0 There are 144 driver
> > > subsystems, so if most of the want to trust the hardware it makes
> > > more sense to have this as default but overriden by subsystems.=C2=A0
> > > However, if most of the 144 don't trust their hardware then
> > > absolutely, I agree, it should be per-subsystem opt in.=C2=A0 Part of
> > > the reason for the post was to gauge this ... and so far I count
> > > three opt outs. =20
> >=20
> > I don't trust hardware/firmware. They can be buggy.  =20
>=20
> Wait, buggy is different; we have potentially buggy in SCSI as well
> (rather a lot of it, in fact).  However, we don't fix theoretical
> hardware bugs, we require users to specify a device (which they could
> add to the code as comments to keep sashiko quiet).

That depends on the type of theoretical bug: for instance, if a value
is used to calculate an offset into an array, it makes sense to have
a check to avoid accessing data outside the array size. Also, if
a value is used as a denominator, it makes sense to check if the value
is not zero.

We do have such kind of checks on most media drivers - and there
ended helping to avoid OOPSes due to problematic hardware. That's
specially true on peripheral hardware like USB devices: they tend
to have a lot of such bugs, up to the point that we can't really
trust the device.

So, I'd say that, instead of a global prompt saying to trust hardware,
the best is to do it only on places where people are absolutely sure
that the hardware is trusty enough.

> The general tenor of my driver/ prompt would be that hardware may never
> be assumed to be malicious but could be buggy.  In the event that the
> fix is for buggy hardware, the submitter must state which hardware is
> buggy and confirm they've tested the fix on the actual hardware.

In practice, on most cases, it is hard to distinguish buggy from
malicious. IMO, it is better to prevent cases that could be=20
too dangerous, even if aren't there any confirmation that the
issue happened on an actual hardware.

Thanks,
Mauro
