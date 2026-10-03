Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FE83A7D98;
	Sat,  3 Oct 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050212; cv=none; b=I8cVH3uwP+esubtZwJBdp/fZELteTCubSs+xeDz9KDt2bkzMy+4oAyUZguPqRo6/n9+84A6cbc2/MyhiM7b9ibZazovWYKIpxb8KaDSfdJuQ4KDdWk9SbPtr9oEeBUqXIzzeoZdhPUv4XsIALD4a9b6gVfoRBwo32+ySMhp0Vjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050212; c=relaxed/simple;
	bh=iSVlcTDDIwilpTIFpoJd4dbbYhXAYFyiKbuOnRJzCTQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W6YxGXcxIbhuN4c88XF8TNqmM+2jxb+FVeO++pifq/FAa8g8zrJ1+AHUs5j8kiAFPDZlaV3Ll7airkaAjchzMuPmHKG7Vm1G/8Q2AxfIXZhJ5+6SmULAQmUyPASqGTuNlvdu0nl2oc4LaUuYmZRaKhp9hbVeuepPt7bhqn80P+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8UjPvb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8UjPvb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0B91F008A0;
	Sat,  3 Oct 2026 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050210;
	bh=iSVlcTDDIwilpTIFpoJd4dbbYhXAYFyiKbuOnRJzCTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S8UjPvb0uyFG2SIoLBKdnmLEppjDvwQsuoJsiNJiUqsrrcscO12yTa4/DeE0YGwqi
	 RDHTsjecBuoyJ5d077/IiCui0EJTgMoXaJeW7Y+wz+3CEuGblujSmDoOXtDAGEtCiG
	 XO6eEv+lpSNmJi7eL7T6ws1e3nc/+/zKJ+RaKpaQ6n3SquTCjaABkT77gKDOdRM1Lb
	 NL6uNd5gsYBDXwFHyuBaZ2/+8opsCOj7jxdLmterkVLfM/R+aLlwUMDLKTlP6A7x6j
	 fQH816Lye5Ud//q63qAFBBIQPQrM2RCXaRUQOICZubydjeDVVOXVRB1KMgBOqlySYQ
	 0J3FhibLulEWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 15/38] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if not mm-managed
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-15-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-15-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:49 +0000
Message-Id: <20261003175649.8D0B91F008A0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
> the underlying file is itself read-only.
>=20
> This means that mprotect() cannot mark a shared mapping of a read-only fi=
le
> as read/write, as doing so would violate the read only attribute, and
> permit writes.
>=20
> In general, we do not want file systems to be able to do this for
> read/write files.
>=20
> Doing so would violate fundamental user expectation of file attributes and
> likely break userspace.
>=20
> However, drivers pose a tricky problem here - the /dev/xxx file may be
> read/write but provide access to a resource which is fundamentally
> [ ... ]
> As no driver which clears VMA_MAYWRITE_BIT establishes an mm-managed
> mapping, no functional change is intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D15

