Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7554FD78B;
	Thu, 17 Sep 2026 17:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666169; cv=none; b=MQgow1uzdk61GGV9WxRX6yUdnUMNsQcfdFTzxINfEu1t/Jp/rwnwFnzriQDqtOfW0hboF+yAAhHttjkdhbq9aC22wki+A8tXSSHjwkM5YEUvq7zA035ZgUT7ZSvTm9nOIqnSHQtqulyrhWLwJroiVaiNzH6A9UvsiVF0WDFUJvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666169; c=relaxed/simple;
	bh=5TE3qraq7GClwJXcdkSpAaHBNVCfGvz6TieZ+P6h8cg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tTv91lWa6e6N6G1nI1JwAdfBec0BRpWGNAaVjTbVrgUia896Fx3Wyqmp3QRScNVJjuY11yMvE+FEs4G27jSnJSy6jEkXuunEBRyVHiT+IeCfNhYJNKyMoBzQifXDaQfsTInaWh531rxXdoqNdZV9fF/9CCsCA+BAOekTUhZFMXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKAaiMyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKAaiMyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5541F000FF;
	Thu, 17 Sep 2026 17:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666167;
	bh=5TE3qraq7GClwJXcdkSpAaHBNVCfGvz6TieZ+P6h8cg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UKAaiMyJRcTTdjILjPZhFLx1ia0R5fr4Q2L4BO0353r2fHbr9EF1yru36ZCwTtLlh
	 7Mel+t/Jb29foIL+qi6vxSgiWhm+5E5yz6aDl6WQmGe9zplkKlWjaFLRDqB0G8hWWT
	 8fRf3FQGtQKshwcyoTEO+mK2tK03P8xgqXqxwHqL6Uo7wzLSxmNzTSPRoP9NqqKQED
	 MwsidzL62y6qNQOvUXoggTkbT12zrEFTaoDMdh0tlRZDMykWtZ0WnPNrdeQgwg9Fip
	 +FeLaYP7JEps7CjaHcZR63cvj3lG5q1KDBv7/UQ8Bg+fCKWPLyti1hMPYvkrWIio10
	 1pyrMuSbMcVAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/40] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:29:26 +0000
Message-Id: <20260917172927.0B5541F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D10

