Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3FC492525;
	Mon, 14 Sep 2026 20:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416912; cv=none; b=dOUq/JdEknvhvQWgE9sC9c/CLQG3cwJrUyeKCZ2wORjXTJ9Env8o+4rQ9P7+1SbHSGbMJTmR7hzfWf4uRBbfqpAg60kgynZjyM66ksHDjYIHWYDq28BxSK8ye3ga9Muy4/iNv2a5wpi1H7wkiQD2xWf4GAJGLJErTobpPsqPsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416912; c=relaxed/simple;
	bh=iPU/cUTReClwZBpDhIeEHk/VkpfdLJRH0AkOL0ttLYA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GYArvMx1IfXbGmE04a+dv6f7jiW43z0P1nPY69ZajFY8yHUETvH7+RHQYdeY1E/633b5m6vkxd5xNfoyYxXa/F1g9Rh9X1nT+VSwpGqTNECmNoZqGruQsdSuw/hSYsdNOdmI6BY8wE8XTGp4b2aK7Jvlf7nmt5TDCrPFYYh0/LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+kYXrIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+kYXrIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278071F000FF;
	Mon, 14 Sep 2026 20:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789416910;
	bh=iPU/cUTReClwZBpDhIeEHk/VkpfdLJRH0AkOL0ttLYA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D+kYXrInK5NUw9BZT7ztkUsQGVhQZ+PlOib+lYW/VIcFu9lRIK3W4hXKoslPRuKNe
	 GaJs4FCU4V8iRgVQnKEgrEJLlmFN3zKxIe8H/cSUtTZB3JL8oT3RZq1i7WQ66uJD0F
	 9Gm/+XB6hykSt/6jtsVWaLuYMEx62xduyBlZeueT06cfCYFjIckmA3fLmfyEuFXfqr
	 v9l/HRBv/3p5qQG+1LK73HlvDCrycWiw0RuFKkEzDuoQJ5f3Ao+gnHVzt4/y+tY1l8
	 K8QX89UDZg/eQxwoxEwofQr/8LWIMOtGIvOJ7v9ia8PWGiITOwJW4XJQx6t2X3Ch4F
	 uGN/cfcfDwQ6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/40] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-20-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-20-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 20:15:09 +0000
Message-Id: <20260914201510.278071F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>=20
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>=20
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D20

