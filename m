Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46534DD3A8;
	Thu, 17 Sep 2026 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666706; cv=none; b=NnmmhgLuTsQ5VYjQRWd3gxYkCnh0VYgAjE8wvNPSrHiRTyzBECwYzcgsIXUQQAYeI/Jt/r22D360buOD+xLYKk/AeFMBUV7pwCmAgnjc6HiXux2/BguBs5RPQ0ah41QA6DL2/BAAndMmSx+0vyGcWtxWKsU/wyq0MGnq1a21Sy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666706; c=relaxed/simple;
	bh=X1lkuup7zNn8Eu1xpYO3JByDrxmF2P6l4aA9z3CM3dA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PWt21nIWF1z56/NrNzyXUK8Ayr+68Y7Hc0CcjXBdVudiNvTBSWh3w7TB9U/0MOd8MuMlPU9+6LMaMtkHcQg+FoCA+CESny2qHGe1TTNpIUTkK4K3h05IQZ467zUDRYqxnupVApJ1gR8RCO7X/vmiXVnZ3+WBlyAISHG58xvzGoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdSUMuB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdSUMuB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6531F00893;
	Thu, 17 Sep 2026 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666704;
	bh=X1lkuup7zNn8Eu1xpYO3JByDrxmF2P6l4aA9z3CM3dA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hdSUMuB0q8oIMp2cw/YAP4AZLv4TTXPR7tzfG1jM8KhH0ePqWfsSLKNpfjRZ7DpzW
	 a2CIuWFe6g4F5pBI2vgNTtrAHEy7iRnJATY+MkfDDPZjFyAACFZo34RdKv/9CvdEFP
	 j6himalQuu40J/resGeID4vz417LqOdTvAAkXfAwNUoMpIDGTFEbTzPSM0sqEUVKnt
	 JyKkHZJE6QUxy/C5aLulR81tNmRR5vH+Iic4HGmyB8FmOq79yl9tRraoVZ/kYIsNYJ
	 PtXpvLNdFxMEjPMePxY/NFMBeYEQc7OlWhcx/haGi7Gxyox39Zt6KxT2otY7D4Fp25
	 HYcjAopFgi9PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 39/40] mm/huge_memory: remove vma_is_special_huge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, bpf@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:38:23 +0000
Message-Id: <20260917173824.3C6531F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D39

