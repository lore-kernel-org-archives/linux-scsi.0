Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A60509EF5;
	Fri,  9 Oct 2026 18:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571126; cv=none; b=kWw8a3E08aZUmyrm0R9PtYH5cX9aMi+V7Tok4MTgdozAELE8QfGRx5UTlnkSXU+3FvlrZmMsxCQXHKvbk8FHR/t/UzbuUb+CWrQcpN59KBHRDeOMA1xUGWSt7iK+XQt4Ni0rQu+dGjRhezKZwMgSSAGQvCGSpzx2asKJL1ctjk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571126; c=relaxed/simple;
	bh=bqkQD/zP3J/tsQX0wRYaRbA+6NDUvRGYQYgejR63mTI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IhtRRY5gaMRWMap73J83hggNAGrHnGOstKtLGz085A+OJTcxMdNXOxmsaXkDcZTPRl9ZRg9ppKwL0ySm6Nl491wVGp86avplcfZWBej+oSIUUpuO/B6omh/m1qtd8bi7dAQZmamLOKPIL2F6Nc1gm0PJuTzR0unoj7d89WlF2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPHU9jLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPHU9jLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D2E1F000FF;
	Fri,  9 Oct 2026 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571118;
	bh=bqkQD/zP3J/tsQX0wRYaRbA+6NDUvRGYQYgejR63mTI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fPHU9jLbul+/4priEHwM5cMJmSkp5TZOvUXZjyQ+rggeFCpFZAxMCYjacDkttnhzZ
	 TUkupONBhkz/nHkXc1/a6ayr2NQnBn0P2Pz8PPE26E5zQnk6TPl3sAHJKDYahBzxK0
	 rmtDbReGqteyF2CFU0N9+64i8Mf6omg0B7YH7vMcIzJVTt3yOcXmJ7HVz0nHlbBYlh
	 Rk+yTQIaUoHB3V0wTNK0tawgq4mpzrUViS9KEueG5lJJTjSboRIF8goqzxjDZbor1e
	 Zxp/3CR5lo/4kr3azciAZKZYzCZNmxIAS4n10gYSLfd9Jsl4kSjteakazHk/LmvtCO
	 /5AXw98F1+Erw==
Message-ID: <sashiko-outbox-165957@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/38] ALSA: pcm: use vm_insert_page() to map PCM
 status page
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev, selinux@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-12-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-12-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:38:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> There's no need to keep a fault handler around for this, instead map on
> mmap.
>=20
> While we're here, rename area to vma to be consistent.
>=20
> This correctly makes the mapping a mixed map mapping.
>=20
> This works towards establishing the invariant that only PFN mapped or mix=
ed
> map mappings may clear the VM_MAYWRITE flag. The status page mapping clea=
rs
> VM_MAYWRITE, so it must not be mm-managed; the control page mapping remai=
ns
> writable and is left fault-based.
>=20
> The assumption is made that the struct pcm_mmap_status structure is at mo=
st
> a page in size, which is asserted as a build bug.
>=20
> This is safe to assume, as the size of the structure is 56 bytes at most.
>=20
> Acked-by: Takashi Iwai <tiwai@suse.de>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D12

