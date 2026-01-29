Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0C13590B9
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 03:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769656833; cv=none; b=PuAdO5eeLl5eXD9Zsg4GXIsnZ6nRVbeoD6WRH6Z99Hrq9gTkInsRfu3BqZBrgC8AwHmjjMgripTCbOEDyvbyW3r7QGMn4KviZV/Vd1AfRpAmNLBzteAiY3OnK3VptVguBTen05kFKik5pgIuvggNVrQqk7A0Nzuv/Ik0M7OrGAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769656833; c=relaxed/simple;
	bh=r1zZE+GFEgHS9vmoV/VN0hnRqc/Nv5C4HJKaBSOzL68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=q7LoVcHCKz6umr5sWu77z9P84ZeBAlTIhhOTgeB/DdMy+OUiVD05OkYqE2XCn/FDIl4DA3xf3kwA+zAgyDq71KbP0Q7TE/n4teuwIlgz+LvYMlclNQEidKukpwneVqTzai+bA/S+Nv2sNG0HQHxFWzknq6ZgxWnVNoMSaWU/Cag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jgSwf5/P; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jgSwf5/P"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260129032030epoutp043d52066e77e408a780bc8c33a993d80f~PFYLK3K-W0460104601epoutp04B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 03:20:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260129032030epoutp043d52066e77e408a780bc8c33a993d80f~PFYLK3K-W0460104601epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769656830;
	bh=BKwBvGTDSaYD6Jv5WgtOt+tOGgb83G4qiTZTJ/o76pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgSwf5/PkIOBGCJ5sJYxZ6pmjtUU02rwJKj3+NAK3SIKeLLB8CGE3dJkikJPjbMlU
	 nDZQu9Rub1+lhHitLkMT7iwh4vbXPxaEVkDG/1Xp9Sk52mDvrLdCSaqIe/vkW2LGfY
	 +wwoMr6SOPFhyz7QrZWb9x37P+/Ix+vxxAGOx5x4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260129032029epcas5p4f70191b8b27d31e1e31b0698609fe213~PFYKrbDwq0559805598epcas5p4O;
	Thu, 29 Jan 2026 03:20:29 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f1kt449Kmz2SSKf; Thu, 29 Jan
	2026 03:20:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260129031046epcas5p2e13b31bc0b4c47b82020e08c45cb32ca~PFPrwIEEu2896328963epcas5p2M;
	Thu, 29 Jan 2026 03:10:46 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260129031045epsmtip17448d004f7400b2b0da9061c72d99843~PFPqw-bZV0450604506epsmtip1S;
	Thu, 29 Jan 2026 03:10:45 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v4 3/3] dt-bindings: ufs: Add binding for ufs-keyslot-offset
Date: Thu, 29 Jan 2026 11:10:33 +0800
Message-ID: <20260129031033.3428295-4-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260129031033.3428295-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260129031046epcas5p2e13b31bc0b4c47b82020e08c45cb32ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260129031046epcas5p2e13b31bc0b4c47b82020e08c45cb32ca
References: <20251112031035.GA2832160@google.com>
	<20260129031033.3428295-1-zheng.gong@samsung.com>
	<CGME20260129031046epcas5p2e13b31bc0b4c47b82020e08c45cb32ca@epcas5p2.samsung.com>

Document the new 'ufs-keyslot-offset' dt property used to configure
a fixed offset for crypto keyslot remapping in UFS host controllers.

This is useful in virtualized or multi-domain environments where keyslot
layout is partitioned (e.g., per-VM isolation). If the property is not
present, the keyslot is used as-is (identity mapping).

The binding is used by the exynos UFS driver to support secure inline
encryption in domain-isolated scenarios.

Signed-off-by: zheng.gong <zheng.gong@samsung.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml          | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b4e744ebffd1..0ed60bbd959e 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -72,6 +72,11 @@ properties:
 
   dma-coherent: true
 
+  ufs-keyslot-offset:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Offset added to logical crypto keyslot for multi-domain isolation.
+
 required:
   - compatible
   - reg
-- 
2.50.1

