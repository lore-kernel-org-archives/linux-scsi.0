Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E9233CEA8;
	Thu, 17 Sep 2026 17:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666211; cv=none; b=W2L63+mpyfyaYrpbES/ri9sbKy2Qf+7qQwsBsHRGUogvpAV7CEWHuWTk8wuTsF/vSomZx3EKGfjJYlagXgz0z9wp9mzyzPDgB6mOF5OS7gs8r9wIzJfMUvEz9GnB/OioZOBOGL3ede1IoZCE5GlHPYKnnFXvZWfoyhk00aU2jDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666211; c=relaxed/simple;
	bh=TQUt3Ft0KayLMo0d7si3tE5C0B89992OAzVxI96NWsg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n48B4VsR4jwRLZXk2tIs+9cqVcupkDquzRuDA2kgKCky2BxmhwZiaNRpbBxIwUgkqXqFKjEQQJVIrJuGYw3Cv59ENXrMg+MyoT85b4Ow5P9RIwDNuHYWV+F3jP2Nk+Z4kIR4P7rPOjq2fewQw8yQ74eQJ8tH3GBYDpuHAi/f4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfAgDV6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfAgDV6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5401F000FF;
	Thu, 17 Sep 2026 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666209;
	bh=TQUt3Ft0KayLMo0d7si3tE5C0B89992OAzVxI96NWsg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lfAgDV6Snf0fVDvkZdXdA4cdlt7zKxZ2lAQ47ceAnxNHyvgzz3xIjTX79k00k7V3+
	 pvyNUNoCg72svQbb/pt4t8OSkCr5WGCSb3+e3GmUoZoDMQDgAFw3nQpHFDw22wYg0E
	 kMM3Riml7CVNuX+TmqkXKpb+arKNWWh1LjI/NI2kijbbLWO0xn2kqUg/JuRQOXT7gz
	 8MuYvKuXjDCMxfK+nBt3vPVjSfgdktQRF3593d/HgnQVXX3coN6L0tLg1k2gW0FX4+
	 d5M0ZwZAYb7RDyNxBIpMbtbOFj/pDhjFPJcd+Vku5eGhmZu0Gj5QdvZWHH+SsPQabT
	 TZpV6nTE8cKRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/40] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-22-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-22-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:30:08 +0000
Message-Id: <20260917173008.BA5401F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
>=20
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> the appropriate flag to set for those.
>=20
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
>=20
> However this has no meaningful impact as these are refcounted and thus can
> be GUPed.
>=20
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is =
no
> longer required.
>=20
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
>=20
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D22

