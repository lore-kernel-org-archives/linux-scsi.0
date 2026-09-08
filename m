Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D973B7744;
	Tue,  8 Sep 2026 20:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899779; cv=none; b=oO1dAr+IGdpzO1RqAtw9fgmML05JY5xBxKD1dKMYgzECz4bZ5bmGGtFRtRFMa9widb5/aL6XxG99MFdPj48UxKp2yb2pKuzxXxNNVwuVn93gda1J3aYESnptRQhSPqQRlJ5MftapuQY72Ab1BM5qj8krCd9fuvkILsyl7ntOokQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899779; c=relaxed/simple;
	bh=E/wOJJaiN86yA6C+CnI8JxBGKVbnXnR8Q05fxWG5SNY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cJaEVg9axTL9yizPD73X31lKCO7x3qTWkdUtWg/eAO82wHDLHqlVS13MXSnFRNPRvDByax8wbGrsG12r54XH7Rf63/Fe3gZ83KD72wLf80a1FMCcfSz+si3BUjBrO2PWwgftIkcE82L63CFZ5/JlsmCjmuNmqUVTaZDY2Nv8vVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+6XI0RL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+6XI0RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397921F00A3A;
	Tue,  8 Sep 2026 20:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899778;
	bh=E/wOJJaiN86yA6C+CnI8JxBGKVbnXnR8Q05fxWG5SNY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F+6XI0RLwgUtgRuWhZf/pCBWO0VMC6KyA+v47Wtby5K7oj0fOfra4NSugp/25gBj+
	 J0h+5saCtRVkXQlbg1l6Hhasq83eAChqqN6aADJoSQ6KNNvmhDp9AktWvznNsTTh5x
	 0nNDewgPoFwHJNZYNEkM4ml0fZsMF3Gs5b21W4pB6PN9k1CR5XEAqzUkyIQY+U4vC7
	 Hxl4DoIc16Uv+JIHNakHLd/GpMAKlki1GXihpu3ftx9AOw/20ro5Pl2jsy9n+veVzd
	 m/I4i8572VH4N5JnA8fpTmTvBodoXdqnqJ5ohQ9bzw7OjDOnsKdtUNe5rRiOG8603d
	 pB2nPzq+43jbg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:36:16 +0000
Message-Id: <20260908203617.397921F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> kernfs does.
>=20
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> check in sel_mmap_policy() cannot be reached. Remove it.
>=20
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D11

