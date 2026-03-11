Received: from mail-m19731108.qiye.163.com (mail-m19731108.qiye.163.com [220.197.31.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9091EEBB;
	Wed, 11 Mar 2026 01:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194163; cv=none; b=pYFvipxxkOPNiUW3bB41GEC2BDyK9IZDfP5pgcFBasA7Mnha0fHOsyWAneyunv21HdzL2NN0GkEXlA7DGUoKzw4/vE94xViglKh2GsQF32e9A0p4f/PAjXgYmmGFRJCLwjZMQBLcSprMc3os1vPEjltDBGBaYZ3rSypqb0Fy0Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194163; c=relaxed/simple;
	bh=Fzed9yWGw2Ea+oV2oRi6h1s6vv8a329SCzQjuZwWclI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=tRbuzeiRBFbvULyznb7y+8oK5lo8qx+2cyQip7L+qbx1B5IkBo/6S22IsUEy1Bwgu926IXX+iVG+XCHJ5yKAdACE3+k4G7dtK6nBQgYf236mp7IBScb/xb3+sPIV8K75tmCpvUofLSevuX8MqHcBy5kvIXMdF6+SNoU0J+9HQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=DcDiOK9U; arc=none smtp.client-ip=220.197.31.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="DcDiOK9U"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 367a6a39c;
	Wed, 11 Mar 2026 09:40:30 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Heiko Stuebner <heiko@sntech.de>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	devicetree@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 1/2] scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add new mphy reset item
Date: Wed, 11 Mar 2026 09:40:17 +0800
Message-Id: <1773193218-215988-2-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Tid: 0a9cda8d780f09cckunm2316bf2d1584d3
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQksZGFZNTE5OTEhKShofTB1WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=DcDiOK9UgW5VDSwCSDgoyi960SHWHHDJXbnjQ1OEKKFLhn1ciEWmP9kXVP/9HZlZTgbRtP7ER7IFGLY+V231wEGdcwdrX2fJqpxRy/xSUu8vnJZMnkSUgrF6XKIOsuZ5qeVGlDs32dmkZgNDCQ/K8eh/2L8+205UNT4N9DAq3Dc=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=7vHX/ndpyQ5HONdUqRl6wEYepWOsN4qPEBemZvRsf0c=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Add the mphy reset property to the devicetree bindings for the Rockchip
RK3576 UFS host controller. The mphy reset signal is used to reset the
physical adapter. Resetting other components while leaving the mphy
unreset may occasionally prevent the UFS controller from successfully
linking up with the device.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
index c7d17cf4..e738153 100644
--- a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
@@ -41,7 +41,7 @@ properties:
     maxItems: 1
 
   resets:
-    maxItems: 4
+    maxItems: 5
 
   reset-names:
     items:
@@ -49,6 +49,7 @@ properties:
       - const: sys
       - const: ufs
       - const: grf
+      - const: mphy
 
   reset-gpios:
     maxItems: 1
@@ -98,8 +99,8 @@ examples:
             interrupts = <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>;
             power-domains = <&power RK3576_PD_USB>;
             resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>, <&cru SRST_A_UFS>,
-                     <&cru SRST_P_UFS_GRF>;
-            reset-names = "biu", "sys", "ufs", "grf";
+                     <&cru SRST_P_UFS_GRF>, <&cru SRST_MPHY_INIT>;
+            reset-names = "biu", "sys", "ufs", "grf", "mphy";
             reset-gpios = <&gpio4 RK_PD0 GPIO_ACTIVE_LOW>;
         };
     };
-- 
2.7.4

