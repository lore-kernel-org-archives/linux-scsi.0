Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF344B4863;
	Tue,  8 Sep 2026 20:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900311; cv=none; b=QVW4RdVnr7GWNnbq4aXDNOx7rMUIioC7zCcSRw100nb0J/i4IY0sB7SM0uu9rr0puevQ/YGU8IaE7DICL7kR8lWZhH8zFlcNaF3Mybl0gpiNSL2dwMel9LrDhmuw+83HVeFHBJQYfuwwfAWX/Ja1ZYGUEcIQzeVY//p6thCdTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900311; c=relaxed/simple;
	bh=0fO0jNCzDdgYQ+m+Mnx4uE6iZxrpMVb7m/K40BKb6lc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CT9f8g7qdGm4BPCRGwTG59MiS3PJMiKvVF+rt8kz1t5xAmdjiqtzBxic4FMu0hnPod/VIFyeW0Ql/XSCP4/PYuzLYosuqClsNp3Vkp8owXEixtjJbQ1pevXURizOhCdXIAmgPjiEE+dQkMsqoOWbisDLL3Ce15/He3OQ/DfFOdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGq9Hnzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGq9Hnzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5D51F00A3A;
	Tue,  8 Sep 2026 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900309;
	bh=0fO0jNCzDdgYQ+m+Mnx4uE6iZxrpMVb7m/K40BKb6lc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FGq9Hnzma0sRuMFy06PQhOJtreLYfH+xlVBb0qaUU1Et0Z3jf+EL+AuLMBiCxT2rZ
	 7vcomFIba5gndT/jNvd7guQTerBonsFuzeYOk6gg5xogb6acZiW5W1qLGH1Uanu2VY
	 fpA6+6ZXxVCWLo/w2mTt7rebVSEbXkzgzwdEvFVlQ4aPjl72cjEfhLkCT+d5KvICGn
	 IXTLhTvRSqXhLQZWSLJSCtVbyBygt20ZmM20t4shX9k5+K+JaKtkJaqNO9hxHMy05v
	 /zc3G3nlGbU7leauqYtCqgbbyVcFMH6HSfg9gOVOgpsnZkEiSL/nrr+4HOr4EHlYVO
	 mb+tpCIYcsYKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 38/39] mm/huge_memory: remove vma_is_special_huge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-38-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-38-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:45:08 +0000
Message-Id: <20260908204509.2C5D51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
> but with a DAX carve-out.
>=20
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no long=
er
> required.
>=20
> Therefore test for vma_is_kernel_owned() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that only
> kernel-owned mappings can set this flag.
>=20
> This also eliminates another overloaded use of 'special' within mm.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D38

