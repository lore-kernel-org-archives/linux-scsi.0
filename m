Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E124CEE44;
	Thu, 17 Sep 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666291; cv=none; b=bocsMr+FOuDtiXLl/2wyjXZpuD9QOSSZVbkcXddYWYz40OU5wGZq7/fTp6w3SP9XRp9E9dqlJ7Rn8L/puVV1uN+Z+55oYxxU3g+0KYjj/4CB/0FtzP4Yxl9EDT+oPL9LoGgnwO7JLsUuvc5dgWNnFgw0BNIZjXr8CkPGrSsKUh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666291; c=relaxed/simple;
	bh=5t2pyfa+ZV+DF8Cp6HUNCSEP7MdHGqhNWZWzoyl/M0c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YhiKduy2cH+UXzGAsRv8PqbteoC572EAidkx+/745hlQaKkMqqMPsReyJ6+G/c+qtN3cs6XxqLRxAq4yinH3wU0GYvVlsrSkFIQ9lKraGRetJ9D0rDY0Edg0dpplbz7nvAsmLB1hokNvTKs+kK5dnoOrBn/RVXrr7Q9r77KhOmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhElYz7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhElYz7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7AA1F00893;
	Thu, 17 Sep 2026 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666289;
	bh=5t2pyfa+ZV+DF8Cp6HUNCSEP7MdHGqhNWZWzoyl/M0c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NhElYz7KSG/fHTz+Cp6hKCvdLM/A+F8Ic4+ZsU9hvWhNlxtEu6lAwP9r45OKZI7pM
	 sj727UIfvOFhFhizgn4Vd+dx+sc4ar8nNOx3grC8B3KdaaSgGR9UdeVqPQxI1WCvJx
	 gI3DMeRAOqYvZFx86MYZWmQn71ArMbkNnBI5Dk9V43Ir3vEUGhf7OH9Xho84U6TtdK
	 F1Yg1/jgrJ9tPGYeFX8Eutg+6jrL2ATBix4wkuqVi6UVp/S+K78yhDyZ2Ke8Ep9Naz
	 wICve7V6Ua/vj6ZMBrwst/Sjc5fTX+rFmcVEVgcPgBCEsanj7JHfmRidzjV8ZO1mp2
	 y9VVG5w1cnBcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 20/40] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-20-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-20-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:31:28 +0000
Message-Id: <20260917173128.9F7AA1F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D20

