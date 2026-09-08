Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1D49893D;
	Tue,  8 Sep 2026 20:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899881; cv=none; b=sNe29yfEWuE3f8IU8Vp4k9hIJiT6aYe8Im01gPz7ZCMiHL/yWbOeF+nO2wDCwJmpNyf/K2c5dYLaDS3Nqkl7cfRaFW14SK2JvTqZouFVWlE6Qep6RCEKAz540eOEIvEj7TC1v7/NoKj6fmEA3AtzrpgUgAvUDuA3BowZQIfXtdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899881; c=relaxed/simple;
	bh=F7DmoYHsBg14zxdNM6f82a6mXZ80MX2i1zvDc4vpwg0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=daXEGuqTVow1UHzcqDEh5civmTg5jzbu2e8HZUEsSw1B8oHex8AyI3aJ7vYKPxv0uVpyOfb20mV8zSFSCZumXw3P+k7VlqGVZmnWj/AQjDXRlK0h3tliOkfU/rNID+a7WUrmTly+rJ6r13Xa6cYA3aIzHvq2mBTeyHCoBeX5pmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE9GmdLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE9GmdLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD691F00A3A;
	Tue,  8 Sep 2026 20:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899880;
	bh=F7DmoYHsBg14zxdNM6f82a6mXZ80MX2i1zvDc4vpwg0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eE9GmdLDwKtb/fVSpKHf42maGv86xcNqPguLsD4Ja85IBBHdNRQWyDBDp4krhIxaT
	 IUmNEIDghowO1nMJoInHcn7Ki2FoWqmrVSkY/tuneHPeBePBlny4eRLjcpRGqY9faj
	 +0/0QD8toMXpPD6H3WEBSPw8qU3Frua+06CoCN+OpGLKxEZTo16QtWaVqTfdRwR6vb
	 gwm2r+oQ3s5UK776IO/DofRpLAo9AVk529/oPLbQliUwZZ2dSG09vofCJOTnOtCFhB
	 B6fGn+474oNFE+wPzNGiwNsIrTHk4RNxpE9ED6Kt1Z4L2Bt6zITRfb51XWPAHNprvP
	 mmQ+xfbg3qetg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/39] scsi: sg: convert mmap hook to mmap_prepare and
 rework
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, linux-s390@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-17-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-17-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:37:58 +0000
Message-Id: <20260908203759.7AD691F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Move from the deprecated mmap hook to the new mmap_prepare hook.
>=20
> We are mapping kernel pages here, so use the discontiguous kernel mapping
> mmap action to do so.
>=20
> Unwind the rather confusing loop and instead map as many pages as we can =
at
> one time.
>=20
> Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
> the pages are populated for the length of the buffer at
> rsv_schp->page_order granularity as compound pages.
>=20
> The discontiguous kernel page mapping logic handles the compound pages for
> us.
>=20
> sfp->mmap_called keeps the buffer stable for us. As before it is never
> cleared, so a failed mmap also leaves it set.
>=20
> We also remove some useless vma, vma->vm_file NULL checks - these will
> always be non-NULL if you reached the mmap hook logic.
>=20
> We retain log output for consistency, but change what's output on page
> mapping to indicate that sg_discontig_get() does the work now.
>=20
> Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
> necessary as we invoke alloc_pages() which gives us refcounted folios that
> are fine for GUP to access (VMA_IO_BIT would prevent that).
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D17

