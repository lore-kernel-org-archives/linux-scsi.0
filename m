Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4083B47E5;
	Tue,  8 Sep 2026 20:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899785; cv=none; b=EsgL1jbearVAYEbIyOu0wkH11oOLmOx34ByY8X4QbhpNgpUgUld4kAgNCmbK5GSsWmhUou6vvpzUEgwtPzeI4hVyKr+nWrrrA0dFgJCJ4mG9zX3Yc87JxfCWW9qsfDuZHwysHXHB0oAmq210b7Gq1umjZNbPYtCXmUcHOmjySG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899785; c=relaxed/simple;
	bh=HVCGLoPkn126rN0odc8hwsZOlqSwM04IzYk3VuN3iB0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mJsBCw2d72s7G2aEtQmeXPd3Bv4p2o4aHdJ4yKjq+r4Pp1xglpss1Zc3iXQ/ZubkAW+uaSLzdRuRooeZlH418euTgaFMp5Wnu5YuhxC4jmGtiHosXKOg1Ld1IuJl3u8/KiLP2PS417r2ZxjyTcBDQkXcecw0Mllz3xqVyXkrNJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WB6J2sE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WB6J2sE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849E21F00A3A;
	Tue,  8 Sep 2026 20:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899784;
	bh=HVCGLoPkn126rN0odc8hwsZOlqSwM04IzYk3VuN3iB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WB6J2sE20seCrJUdHDGgLIlfMQlUur2DjkJVyDDLKkqm+uw9oDyxq/f7jpRCRAZAK
	 ZNUwEsHjOJkzPA5V0RyuVZLyPdc2c5W4KAkAff7M0Xc+sUsYkmtZvpqvdYhbfbTIe8
	 L9ulDhYQ/ekCUvBkFq3wuA3b2qj/NJOSMv98MR0JEGcXdZ16q7G7TFXJ/o8HJ828LA
	 JAeAUCKGBtmIj4LdvDmd+koX9VzNJ9VaD+fAOt22S+l6i2hgDpJcCe1Faw7MF34eag
	 KAC8aCz+BZdj5MdZx2hDVZCQcY2Q14WNvYh0DSPwybS2QW7lzS0zymLlAfi4BoF+6G
	 tQlWmsfz8VN5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/39] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-19-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-19-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:36:23 +0000
Message-Id: <20260908203623.849E21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>=20
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>=20
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D19

