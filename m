Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15FB4EF153;
	Thu, 17 Sep 2026 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665451; cv=none; b=dYlKHhZEVrIWskPCQWzBvlScKewWxxNA5y/sFIPHQS78KbM8/iOdwEL6+RsOQda1YYQ6L2WgNZCTC8XnAd9v2a5/fNMjtb+70wkD+yMVOh7VflT2EX9qWrEGJAGTPm5BHDBj9uUNYcRHAjEp0CA5hnd/Wzli+uofu5qWgRyS9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665451; c=relaxed/simple;
	bh=K+k6hoLMn9pJwKqjLzGlrknYrKi13raycDsBE/Cf+Og=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rVZEZXf/VnYxNx5ynLQln0Lb+o5RJm7FUdsPTMnXMaGFUp2UtQyIlUJtW7gZM5CUg92MsMlRuCBKhqKkPRtkKPUYaYLMUC3zw1jlna6FUNrxf6mUIJj6UMqyRFez+HPSCuZ2XOaC//iTfqEqD/NVBC22oxKpRa2yX4VkPgNWiQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbTJ0R1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbTJ0R1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E801F00893;
	Thu, 17 Sep 2026 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789665450;
	bh=K+k6hoLMn9pJwKqjLzGlrknYrKi13raycDsBE/Cf+Og=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DbTJ0R1SEi6NuxkTn+cMFHFRT2UFEkOtPN9kzwL29IdbHq61SeWBJijQjFw5iWzSK
	 VEHo4nveFr0nx018iMe5cXROl/XIv/+vYNT7EVvm67xqx2C7HMVIb2C3uvwQfhT5VY
	 /zYVI1EHJrSBz46BqywuZ1WW3tdqntd2T8pTT7BlTfrieQjLU2XXKktsNSimnAlnKy
	 Dxdr4Mrcc8FsxYUWmgZGWJdtN9L4XwfeZ3KEzkA2RuX8FdyI7cb7n+L1x7oYVg/Iin
	 5hncF2lJbOCk9xOzosW0W2+kJBaAUseT9+JrAG/DlRdodvDPitTJrDbTNw7RcRbvjz
	 6gIA4+kLJFJOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, "Oliver Upton" <oupton@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:17:29 +0000
Message-Id: <20260917171729.B4E801F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D6

