Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD343B9616;
	Sat,  3 Oct 2026 17:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050224; cv=none; b=oKCPMUs60529BMpZapUtNimdGKOAsjGZv+U61vOJr3hF0IceRUst0Mdk40W7KOvuX30oIjOYPHezcEDy8OBGBJKjHQ15JoYQO3lTQ5gPamk0YKpIhuTpB3QpiSox62xQCb6Kon2KyVumyEi1e1+GvVuLq09Y7ckyoGUy8LWOtRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050224; c=relaxed/simple;
	bh=24nrbL8RIT+6/KLDj30o4CAiwcbrAadW3J9zkkSxsCU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WzU7O7TF2nEYiurDh/NHEEK0hKBgUq2j2UwzZ0OQBGlV+DBewK8pPaMtlCOYfNe89D24+PKD7TKbeW2dzm9akrmHeQNbqfKSlBpqSDrCMtWDwbCmsbUcYzMRkoQJrK0BKYhCus6iVSRtA4dtLaBzxyauK8rv/D7FZuWaroUXTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SD8empGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SD8empGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A4E1F0089D;
	Sat,  3 Oct 2026 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050222;
	bh=24nrbL8RIT+6/KLDj30o4CAiwcbrAadW3J9zkkSxsCU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SD8empGIK8fMk6UVsAjJz2csSq3tQn4bap5f1F3rd17UrwIlxmr00kWyE7OTQCzIN
	 UlbSgQk7jF2M3KHONAxFA7+MVSIE4L97Kj0tmJ3BevJ51OzG1zNiUFMXCkQmNj2pm5
	 OZ65oeeRCfg4es7p6mBUxsHC2qQ4Lq6koytKDe5QE4T+/AXiMfHcnDlx3VQmerqJZe
	 xHwhBJctidB6a9GTdanQEDhi8OoXXnl/Z8ZkDgV/+IzqKtAbOne0+ahgbIa4dqycLX
	 w+lQiPWIYMHA/js2/omiLZQrTcboeorX3+zswGIkNiE52AF9zSTdQ1yD7z9ZhDU9CH
	 rJoRXJMWEOHMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/38] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:01 +0000
Message-Id: <20261003175702.05A4E1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, t=
he
> driver might have done something crazy that is not permitted by the kerne=
l.
>=20
> Currently we check for three such cases in __mmap_new_file_vma(), but only
> if the legacy f_op->mmap hook is used:
>=20
> * Did sparc ADI result in invalid flags?
>=20
> * Did the driver alter vma->vm_start?
>=20
> * Did the driver make a file-backed mapping on a read-only file writable?
>=20
> Generalise these checks for both mmap_prepare and mmap and apply to all
> invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
> in the core VMA code and the mmap_prepare compatibility layer.
> [ ... ]
>=20
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D3

