Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411FF39280A;
	Mon, 14 Sep 2026 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410638; cv=none; b=gLZ0hcFIXJVFYDGoOV9FX/vNYNgRNvPqdxsjafuc0o4nmWpm1GQqKkoEOjhMSgovAFuVTtLXFLcYCWe6nAd8rG9wjEcENi2XhZd12fraWpU3lu+UoiBAyf4TfBiSlaClU4M3QRZs9ilfUAdSMlhwRep66RQ9osAKDatbiGoh25o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410638; c=relaxed/simple;
	bh=TN+rut0I1XYvZcnHuZOYCeZgZ5ZDU9HMLBazCYUtiaI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nfu/83BpM8acZ6Y1qVaeWgvRgzvll15r6w8RURo7PkeDNaQ2ClJMRJwJmQm1vc2t9E0MyXIE8HmsRIdLHUaxA77mHBYh5yztiq1z9lIRim22byBBd8urH36SIiItlzxjiuL16RilQhMW/aE17s54mTlhQV6vRBYIYyh6VA1NQao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyFQdnAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyFQdnAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96A41F000FF;
	Mon, 14 Sep 2026 18:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789410635;
	bh=TN+rut0I1XYvZcnHuZOYCeZgZ5ZDU9HMLBazCYUtiaI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oyFQdnASfXCoqxdHmJN4QRLPsnyvPPxQBO2GkpDeKHWyug/cFf+euE/Ozwv7xUFjP
	 W0ohIRVky6dZsmeNFG1kVANPLsKu8TwJrTFg6UxT/wLKIObhicSrRbbGhLK7NgNFjJ
	 VoNTBcd3XurHyBBmqnk+pFKMEvJZ+YfAuYbnmSsRGPcwLlMq2vcCsaWQRtmDcdlnuK
	 +5LVVeRNeh6NP4iO4Op3Yi6FM5ydSw0WI5B60Eyo7qHD5LhbRWGkKkaRNuYwKNQBHb
	 8zmPu0v8eZSThhVpun7VL/zCnZrsK5AiJ1g33+Q9cW7PJrSQJspNAxdDVBO53TJfXB
	 oJLrdN/a1Wm1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/40] ALSA: pcm: use vm_insert_page() to map PCM
 status page
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-13-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-13-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 18:30:34 +0000
Message-Id: <20260914183034.A96A41F000FF@smtp.kernel.org>
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
> VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
> writable and is left fault-based.
>=20
> The assumption is made that the struct pcm_mmap_status structure is at mo=
st
> a page in size, which is asserted as a build bug.
>=20
> This is safe to assume, as the size of the structure is 56 bytes at most.
>=20
> Acked-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D13

