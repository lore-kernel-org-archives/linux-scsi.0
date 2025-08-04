Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E10126F44D
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754314493; cv=none; b=jydKJHN/u90VssKiaeZ0Kzh2ePMAiyXrUBow5qO78aLaVtL+5yxlMWZ/HsGSoK+UTZlGWEgM9cEhFOqss29716seD02kkqIld4D1AWAMKmYxP4eLajPUCCi0j89uSeRFzoBj9NZxRiIEMSGJfqTQwu+OfCJgsajEvAN7vRWn1+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754314493; c=relaxed/simple;
	bh=NK+E7i4SF9xONO+tY0AUV10ypXRnVmeU59H+CPBgCM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=fBkG6KZPdAowOR+ZM65Zl4eHeGkblurNhFsa5EboICGHMMFAPvxLqvb6NNqbNu5jeUSsMYZJ9pFUhJLtw42P+/rawn0Wh2nkPFY3ZmRhgdFkzcQiDxZOTKYgyhdivViBF04P1zo1zRBN9slH0DuYyWlu9lfjCfDDUS1R+ASB8bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UeB9aEBW; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UeB9aEBW"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250804133443epoutp011dfcaf2b0883c05961d6e8a979e76efc~Yk7pnRK-M2936829368epoutp01a
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 13:34:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250804133443epoutp011dfcaf2b0883c05961d6e8a979e76efc~Yk7pnRK-M2936829368epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754314483;
	bh=sueo5FzJALTgcvMOuRIM5QQ0PClRb+SDXbInCek3SMA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=UeB9aEBWEFlrA5DhY7AzlHd0VxJgsYpQndITSlMkzmCrkDNgnUx6oK+ieOQVbtH/v
	 rDu/I3g4tuje/GmqsubqXaegC+d7EwJahFJmzk5vvM+CHvCoIYetwriWHVvtXHVE1N
	 A5o41RdpumwW3mPNFIe1jQuc9LlOe3QGm4UYw6Q4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250804133442epcas5p2f2ea67fdb98a648a8f980c284c050ce4~Yk7oNtz_c0438204382epcas5p2J;
	Mon,  4 Aug 2025 13:34:42 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.92]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bwcwx3WChz6B9m5; Mon,  4 Aug
	2025 13:34:41 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23~YjUx9a2j51246212462epcas5p1D;
	Mon,  4 Aug 2025 11:36:54 +0000 (GMT)
Received: from cheetah.samsungds.net (unknown [107.109.115.53]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250804113652epsmtip213f4596d1526ebbf9840e78bb83ae723~YjUwbwAjr0602706027epsmtip2T;
	Mon,  4 Aug 2025 11:36:52 +0000 (GMT)
From: Bharat Uppal <bharat.uppal@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	linux-samsung-soc@vger.kernel.org
Cc: pankaj.dubey@samsung.com, aswani.reddy@samsung.com, Bharat Uppal
	<bharat.uppal@samsung.com>, Nimesh Sati <nimesh.sati@samsung.com>
Subject: [PATCH] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device in
 reset on suspend
Date: Mon,  4 Aug 2025 17:06:43 +0530
Message-ID: <20250804113643.75140-1-bharat.uppal@samsung.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-541,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23
References: <CGME20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23@epcas5p1.samsung.com>

On FSD platform, gating the reference clock (ref_clk) and putting the
UFS device in reset by asserting the reset signal during UFS suspend,
improves the power savings and ensures the PHY is fully turned off.

These operations are added as FSD specific suspend hook to avoid
unintended side effects on other SoCs supported by this driver.

Signed-off-by: Nimesh Sati  <nimesh.sati@samsung.com>
Signed-off-by: Bharat Uppal <bharat.uppal@samsung.com>
---
 drivers/ufs/host/ufs-exynos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3e545af536e5..b19a9f0d25f6 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1896,6 +1896,13 @@ static int fsd_ufs_pre_pwr_change(struct exynos_ufs *ufs,
 	return 0;
 }
 
+static int fsd_ufs_suspend(struct exynos_ufs *ufs)
+{
+	exynos_ufs_gate_clks(ufs);
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+	return 0;
+}
+
 static inline u32 get_mclk_period_unipro_18(struct exynos_ufs *ufs)
 {
 	return (16 * 1000 * 1000000UL / ufs->mclk_rate);
@@ -2162,6 +2169,7 @@ static const struct exynos_ufs_drv_data fsd_ufs_drvs = {
 	.pre_link               = fsd_ufs_pre_link,
 	.post_link              = fsd_ufs_post_link,
 	.pre_pwr_change         = fsd_ufs_pre_pwr_change,
+	.suspend                = fsd_ufs_suspend,
 };
 
 static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
-- 
2.49.0

