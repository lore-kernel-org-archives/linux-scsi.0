Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24713371D1F;
	Fri,  9 Oct 2026 18:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791572193; cv=none; b=iKxE6e3XwZwOz4lJRC8gpNFd8STSmpxm0ERL2MtxRe+5/ZGFiGZKMSFMiPgh/00UaSnDBlKJUwo7eLGZscf5/z/XraPy+LyDAVOlScqHi0e/5S/CWLbnIdAIjiJE549Gh+eWpTRmDfVPNHMdWEfvmFpIIKBb6VcCM6J0mcaL8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791572193; c=relaxed/simple;
	bh=uvQMXHnxTG4FqAgA5JTVZhUD6rORKeAmVBvuWWpVtA0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tWZ5/f5pn8Sd/mAL2gLZDTZYP1yTAV2qhy6YjzRP0tkmhiVlRoBpq8XGIsUGuKbA83cv1OhJHJh8/PZEttctZfCtwMZv5ReV9DP/dvxfXtGqgg3tDrgIyVTtaJNtp1W/yS0edPvaVdFiBR2ijA8H2m8EGZ3wyA6TnE/srCKPZc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKZyk5W4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKZyk5W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B189E1F000FF;
	Fri,  9 Oct 2026 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791572191;
	bh=uvQMXHnxTG4FqAgA5JTVZhUD6rORKeAmVBvuWWpVtA0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WKZyk5W4pD59iAu6zCeNv37305I8x6p4gQbX+FP/PZ/jZ6MixSoMwKHDVo1vp6B/i
	 6qv3VXaVJ4/99m6GfjNLjmY/WLt2Q4vRrS658OHa47WI8N6KQtIvNiAYQx3S48PVB3
	 3ibP5klygvAjp1tHR0m7rNySQR0utfDlb/VGUL0VWjMmAFPu4ohjWAZ+yAW32aqKio
	 7XR3CPCQg8LZUqLcnUs1uVhMK1Wmz5yupyN3Lx/IJFjjh8lkm9Xqed9oEIm2gOlW4x
	 M77vORQr0bcYqTrbFtxibgXIY5DnbebAi4O814UfFmQblSKKl05MwA8sY2FvDcX8sJ
	 agzjiELTSI7cw==
Message-ID: <sashiko-outbox-165989@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 37/38] fuse: dax: do not set VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-37-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-37-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:56:30 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
> prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
> relies on it to direct core mm paths.
>=20
> The fuse DAX implementation, added later, copied the old pattern and still
> sets it.
>=20
> Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
> ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
> insert ordinary refcounted pages and so do not require VM_MIXEDMAP.
>=20
> Setting it only serves to mark the mapping as not mm-managed, making fuse
> DAX the sole DAX implementation whose mappings are unmergeable, cannot be
> mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
> MADV_DODUMP.
>=20
> It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX o=
ut
> of its check for mappings not managed by core mm explicitly.
>=20
> There is no reason for fuse DAX to keep on using this flag so drop it.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D37

