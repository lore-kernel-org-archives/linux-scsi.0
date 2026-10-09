Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28177511180;
	Fri,  9 Oct 2026 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570744; cv=none; b=W5uMwePg5Gc9RUfB78WbnrcObZ+9zigqA5SAM54PYsqliNPsjNIg/RhGr9RZ5iEUDZTWmApz0lD2NTf0+O7w2+iWyAHZF354sB1r1DR7V5cK80P3R5XpLShpk8x/SLkZQeVzLA9mphWqSWdVkZwaoz0pdk54dNt04wqWZi0o4R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570744; c=relaxed/simple;
	bh=dWoiqwv5hFhF2N7XevjMQMsUxNw8poxalnyEJOMtA9o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=G8MshHcrtnoTqct1virb+6b96rmNR3/BjrZv6eMtGdP5XVuAn43bgV74gJSiScEofNiWpw8y24//sBPZ+Yp66kcveagj/TS7S+rnAftyZc5M1ZT+kHYQ1dWhxR+O4rKN3ZEqOwso3BRw9FZ3xdYC3AUfbGPVffmeQpXiPZa8wO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGL4BBTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGL4BBTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10B01F000FF;
	Fri,  9 Oct 2026 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570739;
	bh=dWoiqwv5hFhF2N7XevjMQMsUxNw8poxalnyEJOMtA9o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NGL4BBTxutynEwrZ1EiGVProAV04rgdMFNkP60J7yBLPoazdSBqplVMHk2qzTCQDR
	 o8dR+H0WlYycRHbAne4rYsdhkmhpVAAh+l6CD1UlaZrq4nlzq4sck6Q3ZbQFtOi4Jd
	 p8a/o8zvxVNhFVfwyzI8K+c3hufAFaKwLOnYkgRminXE/Zpt0SzWs3ja32n7Sry+rU
	 FkUBYmPDddJusCl1uDqMlvGsBU82roFnqCJRLG88LTFUE805DoRHOVS5aCvviXO/m3
	 iSRoPLVkGg9WWRt+BWrdgqxIi7zp+OnrHGV0s8nw/Y7IXv3qkRqk9euHcxxojex4vc
	 vSl3Wq0UxudgQ==
Message-ID: <sashiko-outbox-165951@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/38] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-usb@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-9-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-9-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:32:18 +0000
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
> access raises SIGBUS, as with other pre-populated kernel mappings.
>=20
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D9

