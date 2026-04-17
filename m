Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D5B30EF9B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776427114; cv=none; b=hpuIRDmAR/ghsvLmQGf6MNzxLAMp/znzZmhd1lf895P5r6gqG46AjPFzvBZq+9MgtgLZmu+A3xrZ/K0yNWLNKw6hNgBB8eOwfAnVVrKXWc7pWBk9YIJGFHbUEyQrZhVKNGPtVIhS8h+/V37/FgXQiT2fKG+naB65my7BxHPy4LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776427114; c=relaxed/simple;
	bh=9JIyl//kwjCYLNOV2103lot1jY0NX1t9FFIgbTT2W08=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dGx3Mbti7ahST14LuLPmRCNuj/jNZCJoRpAbacaUv49jLJFMbLXTGdgKBCfTW0DJE3lnCvv/G0acojbk+nO0LgyGfvZ+RWOsx/pjeL51IbWnzHpnLg/8Ddh6IsrA6FjqoqKWXaqO6OrUmkiX3TbDxcvGJ3xZwnsdIHodSey0yOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fdPaiD8Z; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fdPaiD8Z"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260417115828epoutp01ab2ce5e72b6aea8c4940e9e55b4a961b~nIwsJw2-o2937029370epoutp01d
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 11:58:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260417115828epoutp01ab2ce5e72b6aea8c4940e9e55b4a961b~nIwsJw2-o2937029370epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1776427108;
	bh=tAtME2oAeGw1VYgG3bdSyu5+5ymiofHX2zHNHbOWdQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdPaiD8Zx/vk4Hv+SzdixP1t337+RoRvRzCGIB42UtelLLg7XWrrRAjO7wDGcW8uJ
	 yPE4dcd725YVSCLRlgkDfHlrAPOenRNUplFz0OyeaNWNnlui4DHaSXYeySEAaaYC3W
	 5EbHIih47OJeWpCwCZOYJlTDoOLR8sswmYujvgKg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260417115827epcas5p1678828b1a8e4c5476548edc8396421ad~nIwrOzL0R1376213762epcas5p1b;
	Fri, 17 Apr 2026 11:58:27 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fxtgk2M8Bz6B9m4; Fri, 17 Apr
	2026 11:58:26 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260417115825epcas5p15b81597e14c7ffcee59293e181f1ae1d~nIwpxwWSL0070100701epcas5p16;
	Fri, 17 Apr 2026 11:58:25 +0000 (GMT)
Received: from bose.samsungds.net (unknown [107.108.83.9]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260417115819epsmtip2516c61249898d4b5efdf1361d9c0ede9~nIwj4foTf0979909799epsmtip2h;
	Fri, 17 Apr 2026 11:58:19 +0000 (GMT)
From: Alim Akhtar <alim.akhtar@samsung.com>
To: avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org,
	martin.petersen@oracle.com, krzk+dt@kernel.org
Cc: sowon.na@samsung.com, peter.griffin@linaro.org,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, Alim Akhtar
	<alim.akhtar@samsung.com>
Subject: [PATCH v2 1/4] arm64: dts: exynosautov920: Add syscon hsi2 node
Date: Fri, 17 Apr 2026 17:44:49 +0530
Message-Id: <20260417121452.827054-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260417121452.827054-1-alim.akhtar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260417115825epcas5p15b81597e14c7ffcee59293e181f1ae1d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-543,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417115825epcas5p15b81597e14c7ffcee59293e181f1ae1d
References: <20260417121452.827054-1-alim.akhtar@samsung.com>
	<CGME20260417115825epcas5p15b81597e14c7ffcee59293e181f1ae1d@epcas5p1.samsung.com>

Syscon HSI2 block has system configuration settings for
HSI IPs, like ufs, usb etc. Add a syscon_hsi2 node entry
so that related HSI controller can make use of the same.

Signed-off-by: Sowon Na <sowon.na@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynosautov920.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynosautov920.dtsi b/arch/arm64/boot/dts/exynos/exynosautov920.dtsi
index 0bf7c4cb9846..0eb853770732 100644
--- a/arch/arm64/boot/dts/exynos/exynosautov920.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynosautov920.dtsi
@@ -1426,6 +1426,12 @@ cmu_hsi2: clock-controller@16b00000 {
 				      "ethernet";
 		};
 
+		syscon_hsi2: syscon@16c00000 {
+			compatible = "samsung,exynosautov920-hsi2-sysreg",
+				     "syscon";
+			reg = <0x16c00000 0x800>;
+		};
+
 		pinctrl_hsi2: pinctrl@16c10000 {
 			compatible = "samsung,exynosautov920-pinctrl";
 			reg = <0x16c10000 0x10000>;
-- 
2.34.1

