Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC44374E62
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 07:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260423; cv=none; b=oRz6U2ZX8/ywPzXNs6dOly2Zw+xr2fz0t5lLVT/637R4ZHyLarla7KOsxPkwjOsbGBPkab8LwabombP12zjGyKEsgmg6XOQRca+gbQqjqLUzG3b0ZyfL0SECTGBE/oE92SUhwWOHPHL1hlVvIf/jDSVrLsNh4boLBHNMxUKqXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260423; c=relaxed/simple;
	bh=aTefV9gDKH9ehGh9UgUBqzQwsIyHSgP+K5IpILXCayI=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=CM36pLUgt0NGBQzzVWBUmJUVYyJKlqBjTMEZ0wN4Yv8MnxhSN8z4tV2N+371dHV/hxD25aBvJfnFNL2j2k5QvSqFJPX8EHy/CXbtHjMb5zPn9ECGszIXiQlZNSTDwJ0f9oR3Ou/aptBPKa1tU77eDrhraUzlTaXSoUA1brsHp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DDGk9XtM; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DDGk9XtM"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260520070011epoutp031e0d7af75a3123cb4a8273684e491ba9~xM_roH9pv1466914669epoutp03U
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 07:00:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260520070011epoutp031e0d7af75a3123cb4a8273684e491ba9~xM_roH9pv1466914669epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779260411;
	bh=yNqAydHBTQbwRrt8nI9bmMP5KZ1ofVBcbLbOyTH/OE4=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=DDGk9XtMlG3POr8AI4YFWGPeQ0UdIHqszSo/l7Tl/RBvv/pTyRe3oHYJGHOaHtpJW
	 KZwEtowcgXT3hZPy8T2OKQLzLvW8U1/Ylu/vE3AxbtWJKDd+89802EidjlZKaUlCeM
	 v3iFZJrR+fLDntltjzKtbQKbyHwVsZQmhvcWxJE0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260520070010epcas2p2284258c881da6cd459013964d5a16ec1~xM_qnX52Z2046920469epcas2p2y;
	Wed, 20 May 2026 07:00:10 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.207]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gL2VL2cyDz6B9mf; Wed, 20 May
	2026 07:00:10 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Skip link param validation when
 lanes_per_direction is unset
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, ALIM AKHTAR <alim.akhtar@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"palash.kambar@oss.qualcomm.com" <palash.kambar@oss.qualcomm.com>,
	"mani@kernel.org" <mani@kernel.org>, "shawn.lin@rock-chips.com"
	<shawn.lin@rock-chips.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
Date: Wed, 20 May 2026 16:00:09 +0900
X-CMS-MailID: 20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3
References: <CGME20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>

ufshcd_validate_link_params(), added by commit e72323f3b09f ("scsi: ufs:
core: Configure only active lanes during link"), is called
unconditionally from ufshcd_link_startup() and fails link startup with
-ENOLINK when the connected lane count read from the device differs from
hba->lanes_per_direction.

lanes_per_direction is only set by ufshcd-pltfrm (default 2, or the
"lanes-per-direction" devicetree property); ufshcd-pci controllers
(e.g. Intel) leave it 0. As the device always reports >= 1 connected
lanes, the check can never match and link startup always fails.
Reproduced with QEMU's UFS device.

Skip the check when lanes_per_direction is unset: with no expected value
to validate against, restore the behaviour from before that commit.

Fixes: e72323f3b09f ("scsi: ufs: core: Configure only active lanes during link")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1aad1c03c3fc..0a510f43ce76 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5222,6 +5222,16 @@ static int ufshcd_validate_link_params(struct ufs_hba *hba)
 {
 	int ret, val;
 
+	/*
+	 * lanes_per_direction is only populated by the platform glue (it
+	 * defaults to 2 or is read from the "lanes-per-direction" devicetree
+	 * property). Controllers probed via ufshcd-pci leave it unset (0), in
+	 * which case there is no expected lane count to validate the connected
+	 * lanes against. Skip the check instead of failing link startup.
+	 */
+	if (!hba->lanes_per_direction)
+		return 0;
+
 	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
 			     &val);
 	if (ret)

base-commit: 016d484531e3169cd7bcb26e0ac2c5523080809f
-- 
2.43.0

