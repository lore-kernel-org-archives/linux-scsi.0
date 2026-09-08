Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32B35AEC64;
	Tue,  8 Sep 2026 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899681; cv=none; b=mW6jEk16WQ+L3r1RqmBFaOXPpnMvgOj20dasAnFUmn9VtXs8ghVDg13t0RrprliAZV55NgkRsnat48wpDsze4GnFLwZXP3PjcR3T3RzsQOECa9SBAVTSaK3uHsWsOgzu2v43P950lGczw0O0eimxM2Fn7LxDc/01XCCtoT6JR5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899681; c=relaxed/simple;
	bh=qUqXvKxxXiUI2Z6BlbfFAF4xv+3v4ywt9F9wctfbeX0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oNAHu4wZeyFDAgA36Zxng2LXjhFjW9KCkeEJ82mAMeQxAtwBtFf7WumsN7NoXvZaA8cuaHQvfVBZCWx0kyyyPOpPYcoLF18mMNA3NSFpBugMCZa414+Ho/FBAF9Wfvt0aLBLfIQO5//nD5CtQGVc7JT9xmdAR+9XaK5/kDg8TZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUgNQSRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUgNQSRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597861F00ACA;
	Tue,  8 Sep 2026 20:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899679;
	bh=qUqXvKxxXiUI2Z6BlbfFAF4xv+3v4ywt9F9wctfbeX0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mUgNQSRkEFqX3iOnwuUf4mB0qF1os53i5Hk1cJCVSkSbxtwcRvxdfOwTvVvXmkra+
	 VL+lGKB8dRmhqJ1BJzutIsYOPqiDO16k+znkfDPQ/sKgdjHIkqiyH4CTkEVFKcs0IQ
	 lXGERSfYhQOrviyRxTqrmwbv5DqleNPWiaItfrTjhhOYPjJ8mdntOCTAgmNee2xPnf
	 QRyvlls/s4nb2ES408QQx87Me/m+iCpI9IiBVmtaNVviknIMxnJe+kCgCf3rGDhWXw
	 gyTTxBDFwrvWsy3BqgJVKw4uEwfyOyxq/F+pIPEOEc6dbIEH5se/8/7UGkusawaDgK
	 sW9++qOBNMp7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/39] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-13-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-13-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:34:39 +0000
Message-Id: <20260908203439.597861F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>=20
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so the core mm knows not to treat them as ordina=
ry
> page cache or anonymous memory.
>=20
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>=20
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
>=20
> This patch corrects this and updates the comment to reflect it.
>=20
> The pages are refcounted and vm_normal_page() finds them regardless of the
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
>=20
> The intent of this patch is to be able to establish the invariant that on=
ly
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D13

