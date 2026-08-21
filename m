Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930C631E823;
	Fri, 21 Aug 2026 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322796; cv=none; b=AoNvORWs4PBWw2SmkTCeBx2ABD0L8SIJ/w8YjdX/CnfmBHJJlpAnplrtWbZvDrxpkzlNKsc6jwsw0aWQps06FncHvhtYjbltb26KKsBBx55GoGYy5+PnU2zDzDUUuXBrQeLecklGkTqhIaRKNA/Wi7qFgw0XA01s5z3AA6gTfPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322796; c=relaxed/simple;
	bh=wGSBf+vKweSW8H73GeyQyCgV6jGVtGNoLE9+Dp4K3BY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GyzfeIN9gmwmPBNswe4bDvFZxs7Gv4eUOI7/jSTSlSgHr91vrTVxXAS27xZhSpcm0+KWIDvaXSZujYfuRKTF2Lvnw2c6DmqQ7drSSHv8q20XUuk9C4Z2l07QEYJxIlAgjchuBXE/0HEFrsXIFIKQoNWe7zkXqbcZu6gMKoi9inA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTns+OGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTns+OGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA8B1F000E9;
	Fri, 21 Aug 2026 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322792;
	bh=wGSBf+vKweSW8H73GeyQyCgV6jGVtGNoLE9+Dp4K3BY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UTns+OGUsSIM8zmVsNhlGTY6w5k4AXJqNCQesTdfonLrxz4AtujPWSb+6PzSzlDFS
	 bxarUnOqFVoilJJPuHrSKBs3/VvMYtmFEL4o5B5ue9Y36Ged5ef4GjtlX7Ws/QvHaj
	 ZmsDOdbw3JOHct0vRyRY0E3aZ3uTvPHGFMX4CMR9n7kJMjDEG2uaTlFGwBylTzaLMy
	 K24dVBTiWMfAwajm3p1L8WbklGcpXfQq/GBF0AZel5XVpHYBsJ4NxWiRgHnxSXFuTT
	 B9Vz8mg7fMOT0cSBAowgk7L8a3svVtbGSgEhVOrBfC6oMkezjUJPuXW4zI64Tln4Ym
	 WheLiK5pOyzbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] driver core: do not always lock parent in shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260821142414.150892-6-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-6-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:33:11 +0000
Message-Id: <20260821143312.2AA8B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Don't lock a parent device unless it is needed in device_shutdown. This
> is in preparation for making device shutdown asynchronous, when it will
> be needed to allow children of a common parent to shut down
> simultaneously.
>=20
> And only acquire a reference to the parent device if the parent is to be
> locked.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D5

