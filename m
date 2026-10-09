Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EAF4F7CDB;
	Fri,  9 Oct 2026 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570143; cv=none; b=IUMP5jCjekM5AGG85fN0/GuwKZZTFbRqo5KKVmDP70Qhyn9tBGg+cBbvUCIz4z2xsAFGZHQvusNOIfiVKSCL7AHrPD8f+QF+C+sX/AjsKZDVKxQdea46HivkO73wRhpB6iZRMh1YAvrgk9ahPWoZkJXiuKKcMpybHOIk95V+Sps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570143; c=relaxed/simple;
	bh=PSgtuvzTKTQ258s7HGhGgijbC/siZGtncf0Y5xLeOr0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OpEMd7uvFn6t0ybEO5VrdjjP5qRtNCv2cFehH6olKCiBSxDWXi5c5QdTlhR5y2f4RzvppHVtdq9CzGt7bdRfEo2cQzQ1NziDma3GyIeRd4Bwpm5E+A5fb1lhs8Q9JR3SQiCDt/3XmkTEJ6JeCD79AwQjOqIb3/Xc//3bSidIouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0rGnCjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0rGnCjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96C41F000FF;
	Fri,  9 Oct 2026 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570141;
	bh=PSgtuvzTKTQ258s7HGhGgijbC/siZGtncf0Y5xLeOr0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n0rGnCjYDiMCsNVjOOoHjnmd4kyfeAM6oB+89nwOyMR1YV5pZ+l5wOH3ERyHtXapk
	 BT+Pq5nez707hOE+c0j7/wVswk3GtYtbP/Yls8htZ+NSf82av2pA1Q3/qplNKrUunf
	 4OV8xTuQwlu4uK4/AOymitVv/mf3z6X6YTBcS+ZzffDjpXF6moTXKqSmCtfQ0V49dk
	 9/hBt3VRCVq+qwZvaR1P1ZYiSO/Z1CQH9Z5pDG2Nvu1ZwuiTJAw0os8ZFY5cNBxglm
	 y9MrszJBu1iMdD3Cyeasy8qmWK+p5n3Ca5eLcwDztO/CdcD0941RYe/xgIZB41E9Y4
	 pmYFHlJRqTG9Q==
Message-ID: <sashiko-outbox-165936@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/38] mm/vma: ensure mmap_prepare doesn't set
 actions on a mergeable vma
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-4-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-4-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:22:20 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>=20
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>=20
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>=20
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D4

