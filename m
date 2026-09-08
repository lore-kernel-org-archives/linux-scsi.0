Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB66E30DECE;
	Tue,  8 Sep 2026 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900335; cv=none; b=jYHkAFnvirrZi2M/gN8Vo4Ku1hrX9GH3a6UWE+LPfaBubxRbuUm2iYRRdNTDI5N+ThFOjR0tSw1gGBBgAhU3RpASxflC7Ci1b2VQ2zQEyRsGy+EC07PHc2znfHm6gutFyUBN/FI/gu+Pu8W8WpZt+EeyNaL5TSrJuSygQEFflW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900335; c=relaxed/simple;
	bh=JHusAbsM1Jq/q2msxxZARsh1g6aTv3BLE2tFclqVzns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=huQdwIolHnWeZqeEOMt0PT81edof3YTLUOtcAzhxvHANgtiCL+N+HuRpmrK0iD59fEw26eqR7aleewgT6OKjS8chl1rM5x5QHpaPjsqraJvk2/xVgK6tSXeYOV/iR7Mcel5LC51HgRzLhHK2K+1tloaatChEavWez/ZeSGdlfcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrgLIS59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrgLIS59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAC21F00A3D;
	Tue,  8 Sep 2026 20:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900334;
	bh=JHusAbsM1Jq/q2msxxZARsh1g6aTv3BLE2tFclqVzns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UrgLIS59Kt8qQ3K4lOfJeTqo/Whczszd23C0+SmmVjE70kdrQVe/V9MLu3q8mp6a3
	 xeG3Epr9aKdq2rsH2sJ2sRiasnWUXwI7I0IoUdZycWYg1ld0WOhGBBN6ecVd6WkHST
	 PUpdq29RBY6MvIg9++ZLfGGOLz/cQLyrgyTqmghAWJQa2EjbG7gIRVyxp18qHnqt0M
	 WiMddCvVUJBc2ensJA3/nbdZ6ErAuuefoHuIEsrPY054ZAt50qKzO2otHaBKv+hQEc
	 ioPKPel60iCIpv+oOV4WQrfwiat6fzYNYCbgEA5V53laTZXBgkE51EhaQR5qs65jNx
	 TRW2JlJspbNMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 31/39] mm/uffd: use predicates for userfaultfd checks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-31-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-31-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:45:33 +0000
Message-Id: <20260908204533.9CAC21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than directly checking VMA flags, use the newly introduced
> vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>=20
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>=20
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>=20
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that only kernel-owned mappings may set
> VMA_IO_BIT so the check is now redundant.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D31

