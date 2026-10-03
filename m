Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1573F9281;
	Sat,  3 Oct 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050232; cv=none; b=ROUALrftNVSH25qELHFll9jbwafTZnviigNhsiWiPA6jkSV+Atza73IhjHmTGf5CJFgx67j8pgv5JAtky5EjvYbAqQE+1QjjyIbGJIryXWOCReFVbFQTQDf+2l+NNND/sr3CPYfd59hntsW+yjgENB1jwWIHYX8UNS2nahxEukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050232; c=relaxed/simple;
	bh=UisgaVbv88NLT9Yta6Qy/E4jcLCpHSovyF5C0heraeQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZHdHHpbNUSk2or0fGDi0R81uoo4mf9wa9ULL/iQKFWVBERaH59xCsZicWv3dHeEEZtfMkLTT34x2E141aZ+iaJt5ObWAs8MQ+LpXHfE7G1doNnOwdkv/kUQS+JxZsgBxD2RzghfriARmo+wuDhO+9fi0oOqwb0INdugyxO4zQp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuliweE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuliweE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C611F0089B;
	Sat,  3 Oct 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050230;
	bh=UisgaVbv88NLT9Yta6Qy/E4jcLCpHSovyF5C0heraeQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OuliweE1iDHkcjHm6uSGxL4cj05vX42vHS/YhYOsulrCxk97Vae+aooWhhyB5aya7
	 BazrcumHSXJ8NVHnosyvUUptg7EomPb0OqfPRtST0Zz9DMXSeB7Y3M3p9XuPsWior6
	 BRCedIycwub5gyPE1atpOi2z3Ex8gBrgvlQeWmb/6hRUIU/8Gnn6i4OA+Fc434S/2S
	 mo1FIOrrQb5kXshzX80OPTiaKZzlo+K/MkePk40N5gLm7j9RiwFjfxLyzfpsRNn+oZ
	 UCbNOCbrMpvy1bqVDJepB9eBtyyvWzV2AQR4dVxHalsOeJH3BXTLqwrmAI0u0GmRSU
	 bmniaSFT8n4/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/38] ALSA: pcm: use vm_insert_page() to map PCM
 status page
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:09 +0000
Message-Id: <20261003175710.28C611F0089B@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D12

