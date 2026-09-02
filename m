Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44834360EEE;
	Wed,  2 Sep 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369466; cv=none; b=nPjHSz8kkALkbBI/LcQWxjQFdxGMs4tX/uPjNfmvVyLcfv0+l21Tx/H6zD3Sl0i8bWv+LGsyEwBmrk7ZAbgXegU/dsRpR2kBsY1b7KQ+/yKY37Su/rozRIvvOgwmbaoRb/nRMFkdiqSlIJORnBY1lrxXKnt0saqukGgFWYUwTGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369466; c=relaxed/simple;
	bh=pfcC21zi1KOxBU0XYkxU/iG3obDjmrNB0l62JAA/2hA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s585kE0iCBq+oy5tSxb36EetruGt3PUeAAgJLTIrnHy/O0aFR8mPsqMydU4bUov7VaDO1XjfcaFr76QHE9RD89QkqT3+S3j9djHqiTD+C3eSOLpmNxVKvo09/e1pCtuNdEvh7jl3ZHRY6vdENnMg6V8aGOogNuI3EbdoYpgnM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nK5DRzFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nK5DRzFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AE11F000E9;
	Wed,  2 Sep 2026 17:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369464;
	bh=pfcC21zi1KOxBU0XYkxU/iG3obDjmrNB0l62JAA/2hA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nK5DRzFfougTGks6YoYbxJ0G0efXWLB+1JxqjsL3xRfRg2jNuQu9SxE22dF2LCyLO
	 KTV1QZn2TstAED4cfo+2TgrI/S2Yc53Dr2B310YLUeJOKIZWvIGv6PDNO44V08gvW8
	 Jdzvuv8nMByYF02crkrJDr5CGkDjN9syIWTNp6fGFED7LcNtaHcTUNp1vkRjYC96k0
	 GQKr+XDR2JLj24N8vv1x84wNdMUphTCsGgCVmY9xZ2SXqd2P89z1kz8OJQYe85G4QW
	 FumroL3bUn70f0NimMHzSIdHvVP9fpiCCrIlWfMabWsP8L/Bb9zDCJXkDmYn1WBnWM
	 aonZ1Uo9npArw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] driver core: async device shutdown infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260902170734.95504-7-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-7-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:17:44 +0000
Message-Id: <20260902171744.B9AE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for the=
ir
> dependencies to shutdown before executing their shutdown routine.
>=20
> Sync shutdown devices are shut down one at a time and will only wait for =
an
> async shutdown device if the async device is a dependency.
>=20
> Enabled by default, async shutdown can be explicitly enabled or disabled
> by using the kernel parameter "core.async_shutdown=3D<bool>"
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D6

