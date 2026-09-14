Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5979341A91E;
	Mon, 14 Sep 2026 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424710; cv=none; b=iX9njZ2KqMJ736Bn1AZ7gJSe1444WW6q7pE08qhBMbpKiRzhnrdYSy72snkPHEy3aCvmeaN+8aKIAE1vkB9KzmKLQD1oj2SqGzoq/LuCzufJtxIalcxATNijyJR/k2vz77bn+JaO9z0gxix2WiTewkEDQWycFNYacDKWcv8PxPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424710; c=relaxed/simple;
	bh=SF+Wh6RIXHujXtKVmSp2fyGTqjNOayUqu/OXLG8KKSI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LWUrY8CExilMghu98xeDNI/XQx6zc4B5YnEanW6ke69BljpxeMVzvOLTtZZtwpnTtvBMiIeHQBficEqYNKG5C2+jAJBh2ZvZoweSIIIJKeazb9dxSq6jGYqEjGoC088mafsrngJ+l1/vLjMXkKQCi75G9eqr7uuGok8uhMw27ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJmWlPfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJmWlPfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFBC1F00893;
	Mon, 14 Sep 2026 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424709;
	bh=SF+Wh6RIXHujXtKVmSp2fyGTqjNOayUqu/OXLG8KKSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eJmWlPfOaZdbrRg4nnnTG4A9u25SHz/RbsYaG1f1t97yPtOtPfrmZnSYI7CBoQzk4
	 JbzBI2n9IcLsw1UpbHcxZyKgxWS8FSZicqIJPbIPGZQ9O4T3nliXApn+78mMu89YRC
	 1s9fa2emo0JnMIFgKqD5un8thT5TBtjTjhLyYsXx8WwJ7CpU7hSObcJkVFd4UG+oww
	 oSzjF2LtfLbKQBgrXPOt+6JMWRFWbwO5VkX7UWBKCdY4fRhddbN/WXgtc9UtPKt2OV
	 CjZsnhjObA64bxQM/W93wQlBhzWwcYXybW4Ejadc/K/XXuvxccX2LxrmE9dsH2nWBW
	 JDmCR6BQ9YVTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 40/40] mm/vma: introduce and use
 vma[_flags]_can_gup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-40-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-40-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:25:07 +0000
Message-Id: <20260914222508.5AFBC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
> I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - becau=
se
> PFN maps have no folios which the kernel is permitted to access.
>=20
> Rather than keeping these checks open-coded, abstract them to
> vma_flags_can_gup() and its VMA wrapper vma_can_gup().
>=20
> A number of other places make the same check to decide whether a mapping
> can be populated or accessed as GUP would, so update those too.
>=20
> While here, drop a reference to 'special' and replace a use of the
> deprecated VMA flags API in vma_dump_size().
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D40

