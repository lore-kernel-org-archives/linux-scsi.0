Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093444FECE7;
	Fri,  9 Oct 2026 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570988; cv=none; b=hrBgfBUq1HbnYVMPUEVg9w7o+awxH4cVknfQjBi5oaH8XWz9cOuV1KcLO4DUIJZTwn4ImOC5VYqLCJzjR6LeRzRl96gFJ1KOPvZpIEbo3DmckD/uH19geu05w/TIkTk5iW6XGFEKBMXuknpphN4l0wlRFfKRW57wpnXVkWKpwCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570988; c=relaxed/simple;
	bh=5yU3oYlTV8gcZejm1fragzKXmsd0AwWHUWcPg57ZaYs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rxs7O74xruRLHFIajHW7lqKhGfPUVjJNyNgrZ+7o1TcXlthW8Nk7V1xzosazpSrud2KAdKqO6mxszGonBwBacsvmFEubXP1NDXvor/hWKmlzuSggyReLWqfA4YBZHj+FKkNsy/+h1duSSuCyq8P0C+ys7ZXARs67Q6faYzpYCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQw4quvV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQw4quvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B947D1F00893;
	Fri,  9 Oct 2026 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570985;
	bh=5yU3oYlTV8gcZejm1fragzKXmsd0AwWHUWcPg57ZaYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FQw4quvVPkYv5NfuiCxEiARNHJOpRtpshbUMR/PjhKuzJozfklyWcC64mJcXnOgOY
	 qQbqc62OzIeNujHF96CgBO7re+aRRsLgpI2plLVadv0n6wVDczXJJ12r/F0pJVp30R
	 O5sP2acEKSj8sHE7ZKH1Q/MJ/x0QuUXAgJpyTSWgJE2nUnODqspsgymQZ4dba16yS1
	 qC6Nap3L/3EzKqhgW8koZsW/ar/1GGpnVFDQsOzvqtMMxIf5lpF8/euDZEDceCv//Q
	 F3Kd5UGvpgjKeubuoUvLOOH+4hWH6iSXM94PGTtZMuLn6PMRVkOV7yT72eUSeOf9oL
	 pacAsAEe/MsiA==
Message-ID: <sashiko-outbox-165955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop
 VM_IO, add VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, selinux@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-18-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-18-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:36:24 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocat=
es
> system RAM, so simply failed to set this flag when it ought to.
>=20
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>=20
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>=20
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>=20
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D18

