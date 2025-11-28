Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812C52D738F
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 03:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764301068; cv=none; b=MScB7mPkGVYBhMpJ2YTHo4CAfAVdq8dnl6bEBwJbOm/ZO8KlFSFaL7XKlvmfqTTPMtwSzL9HzWfh3LHbKltLlYix/wkRwoucEmtM/DN9528XcSWyoYp0r4Rar1ijWPK+ztqSNVcdt+NP0fC/QbIg+pRc1tr4/SRnyv2HjDx294E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764301068; c=relaxed/simple;
	bh=9fqWtvPsesdRVddDbQdwe6RHkDTPUOFusNe4LSM5TW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EdDNhtPhIer/5BV6KwMMJ1ZNBB4kZPvfcI2+Pw7Fv44MsTx5oVPIiTDetx4MzI4CL+zQP08NA4So+YSVhas/L2i3GcSLnBgIOiBLaPAjk003jY8X+OsYMmTVa8fAGAydbDLqrs4bsSz6YhrenlTIJ9vWPH4k16SIRVfuulqmrbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ughtu1Ac; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ughtu1Ac"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251128033737epoutp04d5914d68e9e1e0dc9d2a9553a6620d25~8DnbP5y3r0167801678epoutp04X
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 03:37:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251128033737epoutp04d5914d68e9e1e0dc9d2a9553a6620d25~8DnbP5y3r0167801678epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1764301057;
	bh=pNMxVaSfZrn/lV7i9Ks6uC8VfPHEl3nFd9sIdOkJKZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ughtu1AcG4PNKuu6/sY12O+Y3wVRIo959voL0UsdIaTGQZVlxs9mOyWaTsVB2qvkd
	 6QTj0+QYxuwGrw4HXVvEwu3cEHZdUDjYy9o+dawZ7tdUItOGgkys7W2zoymy6FzesW
	 lAHnIpL0qOoiJ87qineTp7vv0NsLU/1PnpM/4tRY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251128033736epcas5p2ebab850126d105dd4bb9786867e28c3d~8DnamsK5u0473904739epcas5p2N;
	Fri, 28 Nov 2025 03:37:36 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dHfBR5bB4z6B9m5; Fri, 28 Nov
	2025 03:37:35 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251128033713epcas5p450da60155377b3ae43af4d38edb935b2~8DnFFkZsw2226822268epcas5p4G;
	Fri, 28 Nov 2025 03:37:13 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251128033712epsmtip290643d4fdc2cbab1972e0b1b26fa64ae~8DnEJIduz1463714637epsmtip2y;
	Fri, 28 Nov 2025 03:37:12 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v3 0/1] scsi: ufs: Add crypto_keyslot_remap variant op
Date: Fri, 28 Nov 2025 11:37:08 +0800
Message-ID: <20251128033709.1342579-1-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251112031035.GA2832160@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251128033713epcas5p450da60155377b3ae43af4d38edb935b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251128033713epcas5p450da60155377b3ae43af4d38edb935b2
References: <20251112031035.GA2832160@google.com>
	<CGME20251128033713epcas5p450da60155377b3ae43af4d38edb935b2@epcas5p4.samsung.com>

Thank you very much for your feedback, Eric. I truly appreciate your review and the time you've taken to point out that a real user is required.
You're right. Adding a new variant op without a clear use case would not be acceptable. Let me clarify the context behind this patch.

This hook is not theoretical. It is designed to replace an existing out-of-tree variant op (`crypto_keyslot_cfg`) used in Samsung's ExynosAuto UFS driver for multi-VM inline encryption.
In production, each VM has its own keyslot range per hardware allocation, and the keyslot is remapped at request time:

    lrbp->crypto_key_slot += vm_id * UFS_KEYSLOTS;

This was already in use on automotive platforms.

But the reason this usage isn't visible in mainline is due to ExynosAuto's kernel architecture:

Starting from kernel 6.1, we adopt the dual-repository model (similar to Android Common Kernel):
- `kernel.git`: Mainline-based, minimal patches
- `exynosauto-modules.git`: Hosts platform-specific drivers (as .ko or built-in)

Our UFS driver, including FMP and IOV support, resides in `exynosauto-modules/drivers/ufs/*`. It couldnot be upstreamed due to:
- Hardware-specific SMC calls
- Security-specific key management
- Non-public register interfaces

Despite this, we aim to minimize out-of-tree divergence by upstreaming reusable hooks like this one.

Purpose of the Patch
This change:
- Replaces the private `crypto_keyslot_cfg` with a clean, upstreamable interface
- Eliminates the need for out-of-tree patching
- Reduces rebase effort across kernel versions
- Maintains backward compatibility (no impact if not implemented)

Design Principles
- Minimal: only adds one callback
- Reusable: fits existing `variant_ops` model
- Non-intrusive: no changes to core crypto logic
- Generic: can support virtualization, multi-domain, or security-isolated keyslots

While `ufs-exynosauto.c` is separate from mainline `ufs-exynos.c`, they share the same goal: enabling robust UFS support on Exynos platforms. This hook benefits not only us, but potentially other vendors with similar scenrios.
I'm fully open to feedback. If there are concerns about naming, placement, or future-proofing, i`m happy to adjust.

Thank you again for your guidance. I hope this explanation helps bridge the context gap while supporting real-world use cases.

Changes since v2:
  - Removed test module (ufshcd-crypto-test.c) per feedback
  - Clarified that this hook replaces an existing out-of-tree feature

zheng.gong (1):
  scsi: ufs: crypto: Add ufs_hba_variant_ops::crypto_keyslot_remap

 drivers/ufs/core/ufshcd-crypto.h | 10 ++++++++--
 drivers/ufs/core/ufshcd.c        |  9 +++++----
 include/ufs/ufshcd.h             |  6 ++++++
 3 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.50.1

