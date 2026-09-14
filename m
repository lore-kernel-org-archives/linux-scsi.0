Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BC8486E51;
	Mon, 14 Sep 2026 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404467; cv=none; b=AjfnpTLgApvbR2WvdnsVLLStt1iANzfxzaN53c1v39B2koyayFLGg0urcgtNuKK5ksTLtxC+muNjqk1jsEmDTnblbuHe0BAgY3sWknxghvRn8Zzui+PcCgjqHO6P7SXrv/kxM2qh7GtdkiFq/MmSpguDgLa+h9b4rxuySJKT5aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404467; c=relaxed/simple;
	bh=YCW6FK4aAAXisU4xzaLCp+w+MBA5h3keA3icwQAIT/E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I+i/5JzmQYzY5ZKXZRG7rdpDDATnpuSPRZNd6Hi1d3Fq5yZwWY89ZmavBXrH6kTPonVd9NmMMqDNAia8Mx0I/gBSPW/O2Oe5aZJbQ98Ko38a8eADVxmuhTmM3xwx0xz4fkR4fqYotzEPsHrwiRyzYkwNVt5s6Ge+MkJv+IwHl+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYdl79ze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYdl79ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DF31F000FF;
	Mon, 14 Sep 2026 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789404465;
	bh=YCW6FK4aAAXisU4xzaLCp+w+MBA5h3keA3icwQAIT/E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYdl79zePhxkAy3dLA7+gt9Ntl/6uVUcUoTlXGCFVR1oGCz2WdUq0kz8WG4ITAxlC
	 TOTJyFFSv/Fnv9RtdISy6ZJdAVICni9epBNsOFqc9XcFZT9rM9Y2vtRjjy8IR18TOh
	 t8FymO3DImuc5jH7yw+fS0LJuK4I+yGzTyTeG1fgVUrEDGGeBpZcb1W4qk7OM0XEYU
	 ha8zRWueOX9ERQQHGZew5VqY2vMnGdHFgRFBTzJa2YtKp/FPRMuFzIJfg+bxb12DkO
	 HDznohZIRx6BSST3z5t5Zwfy81O0F/65fcmMF/aLMx+ZUYnwXKNi0TueplvXRt+2cN
	 cLmF4Or01dIww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-6-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-6-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 16:47:43 +0000
Message-Id: <20260914164744.74DF31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> There's no reason to export the symbols for these functions which are only
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
>=20
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D6

