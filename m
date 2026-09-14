Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A86B368D78;
	Mon, 14 Sep 2026 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406302; cv=none; b=AWONmy239gryeApOulMgK1UwrIJwL5M2Ayhc5n8yn7+YMYJ4p+5E+ITz4rPNMIB/amIQW1BatOkClKBl4bBYQODAwIYAgSWrZS9dc/oqFiEVDoYZGAW+0z3ZC0jHEaed/9WQeP8cx8/XbHLbViJsy06SfLFdaAGLbpJVF/+ryjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406302; c=relaxed/simple;
	bh=pauKHZWnefu0Gep+Yagb66UL066ySpulAaOVGUW/esM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E+3totgCV23ycw+37cWOGe8UdIyPAX2GGVkUqZ+jhXipYv3BJvMj+PnP/bVUrNdPJ40aFUXcGBBJeJiqUV3UgzPYbteeN03ZhQOzcheDccYBPiSnwFftIiIyj0Lx3AjBr3qK0bETmKZmM42oEvcAxRf7eQQDfLuiZEjlpKB9Yj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqegBZjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqegBZjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219E01F00893;
	Mon, 14 Sep 2026 17:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406301;
	bh=pauKHZWnefu0Gep+Yagb66UL066ySpulAaOVGUW/esM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqegBZjGFHivvTOkcrd4LsU6SjsE8bS8wg2bRQG8dmb2zUi5lEW0EoUQKKt/mVLPM
	 R3j92zYpwoXFeJm9yoBqTTi+o+hA+S3S+Soqt2apm6sVHlfgLona+cic7xsflOyCyQ
	 wWv8L14X10AIIUfCi9+tttmMuNTPrWTXiuX+subvlixhkxhMz1C6GdwjctkMGXUkjW
	 B1vkJW21v8DOTs5PcgL6Pdfm2k62grfrGkl1/ewXLbSmcMBzdQV/ZGPheKIyDArAhF
	 NfObdDplPUCHMeK1yHqjpNVRk7/vrkwnmceVPoN1FvBX40nA8kE17QCq850HUDR5BX
	 1g27ty4UyIF6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/40] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, selinux@vger.kernel.org, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-10-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-10-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:18:19 +0000
Message-Id: <20260914171820.219E01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
> part of this change, additionally take the approach of mapping pages upon
> mmap rather than providing a fault handler.
>=20
> The page span cannot be mutated when an mmap mapping is in place, so this
> is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
> -EBUSY if it's attempted, gated by the rp->mmap_active reference count).
>=20
> Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to =
do
> this, which allows for iteration over pages in mon_bin_discontig_get().
>=20
> mon_bin_discontig_init() increments the rp->mmap_active reference count to
> stabilise page spans. Should an error arise the core unmaps the VMA and
> mon_bin_vma_close() drops the reference again.
>=20
> [ ... ]
> page discarded with MADV_DONTNEED is not repopulated and a subsequent
> access raises SIGBUS, as with other pre-populated kernel mappings.
>=20
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D10

