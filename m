Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82793AF676;
	Sat,  3 Oct 2026 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050201; cv=none; b=WcWAq0+PkvbVOnzd3th0ShF84jytXzq+Q2PagjxiuRHNveTZApgYQRWNz3zid4EIHZ8AMhRVBCbATPNwp/ZZPgpY/62By1DuCAeDgBu6WBaQniuSME/dxxOpPk/UyR6cPRwM0htoCom6yp70Iw6U/sQGIQ7bwQCHK4Y5aAzv0so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050201; c=relaxed/simple;
	bh=1YZ+3CTx3D+IY5bUPkcwg/IoLb+ArrEEbg/91Zo5C6A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MGH3rKUupiw8c6ataT15xnN30hprClRdWGu0R0cZOdFAa/Xhm4B3/iBlno6w1sCdwMvYMplYiEe3JThD9Jm6DFLba47symRaxrPcW7jLVd2uAjRl/PrtlaKuGOn8Pxegz7wTJ7wZKnTw136sDhu2VCSr1Q+bkxEv/S0tPM7mSxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZEWzZja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZEWzZja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063DD1F0089B;
	Sat,  3 Oct 2026 17:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050196;
	bh=1YZ+3CTx3D+IY5bUPkcwg/IoLb+ArrEEbg/91Zo5C6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TZEWzZjawR2CQUUrpugwi4rP7raVrpty5GIDGE3z9QCS/bsRORWv+1iwjc0TVNwxj
	 kUzlCUM4qePZ7B91jOKf98dfaEf9u/YSke8la0JsdD35Ydup0+pd/hql0gwj3bpd7e
	 WZws0u/agOuFUFXSCgb9a57Mu05zlfS0WzqIhyB02MNdx/cBlHtLuWpPoauXFvVnPf
	 F7+p8cxgG2Tv6Y+4gyr1KSjsucQuAa32dPKppevwVk33UFDItx8xuKArDWLcT8VqZz
	 FfJVdZWeK8cXwnBU7CEKXwBOSdMcWx/QyDBP1zdFyQItrFoWj7EWWwV8LFE9alGFuk
	 6GckbED6BH5wg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/38] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-5-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-5-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:35 +0000
Message-Id: <20261003175636.063DD1F0089B@smtp.kernel.org>
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
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D5

