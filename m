Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C903C3EDAA9;
	Fri,  9 Oct 2026 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570071; cv=none; b=RM3Sgm6adNyF6WvxMDS7sl2Mr1rN7EqEH6s2cd+09jWoVdWN+Pdfb2vxKLzh2/RKxkjShqwW0M/6jzY8fSkHUeWrVtwbpvwnzCu3Solks5CxAel5OiStXbOReBwUXifaPisG3dPL8ifeOwNyp36m+Yec8vMXa6N0WwtZFEud5LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570071; c=relaxed/simple;
	bh=xtGx4Gq1WvzVTM2zfvyvTx67BIWOKdC0hAh3b1eOewo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pP2PRgE4ESA9GjrWlJobNIklrdHKlZV/Hxt/NS4/G86L2O+VWfi2Nzhh2qz5qMvPsqS5XKvFVEpO5tKWfZsuhY2KKPxfP7gic+EMAfiiPRlpGjdoIuH14ra5OzijKPaTM/7WcTUk14PnOfzdLWMsUvC5DIOkjFfbVpnT9R0DCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcB3DY1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcB3DY1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CFF1F000FF;
	Fri,  9 Oct 2026 18:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570069;
	bh=xtGx4Gq1WvzVTM2zfvyvTx67BIWOKdC0hAh3b1eOewo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kcB3DY1WJ3x/nDWF5SIT25GGU8+thhnkK7dxjw06pi2Klg/hLQjwX1Cpf2qI0907T
	 oG0EEtNgxNPY63RXOmOVnsgkm3Qzxh5f6nh/lnxIcQQcsKHPUmQdPQwfKZdPY+z0Mp
	 Sxu042rfsK3zoGp+M8B8b7URjrtFPL758lBbkJrQE19uZx600BJZJGe7T5ytNnr1wr
	 CHkXF22Hyz3t/Wjf4GlloujGXRqElYaDLxk1+xdzRPaRwbdF/n3ctZd4iYePkY1FAF
	 5hXA0M/Rz6Kj9ONZw5j+daYitv6LqZM4pAZZMMGHC/45brH7zmXnoECgimI6dmOLX1
	 jWY+ios/Jxtkg==
Message-ID: <sashiko-outbox-165934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/38] mm/vma: introduce and use
 vma_[flags_]can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, bpf@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-2-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-2-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:21:08 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
>=20
> This abstracts the check and expresses it in terms of the desired behavio=
ur
> rather than an arbitrary and confusing VMA flag.
>=20
> This also lays the groundwork for making further improvements in VMA flag
> usage.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D2

