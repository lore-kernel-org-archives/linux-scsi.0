Received: from mail-m19731106.qiye.163.com (mail-m19731106.qiye.163.com [220.197.31.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044D331AF07;
	Thu, 12 Mar 2026 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773278856; cv=none; b=J/w48iR4t70S6K7GpO9nn3MCk5ezIJosUfl3EKhIcxDxNmvZFcU3+OOsSI58DlhG1W80TQaD9SoYQtvlkTI9jN/2PmKb7UjiK/FMNqU5gaaIIu6MwsAYPL5EglMjJ6SWqyxPSyDA5qhUYAW+82lzVzpggWBLWgHRx+emlfw4mCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773278856; c=relaxed/simple;
	bh=3w8achzH8/E232WgzN5AkJYy+/gTu4Tsc1H4+Pbttjk=;
	h=From:To:Cc:Subject:Date:Message-Id; b=I2CFmMu3T+xVD3r/ehQqQCXNn51oLzID10YrjrobtZ8M9dlv0qWApuN4xVv5EMAxP3gV3KJMG8txORpjVRyGHprwgwbQQJIa6TFRgx1I+6wa5roEK7jkVnXLCmg3ZYOPeH72JxsuH7d4HwwJibEIqXVnEXE9X9/uZrFB+nrdM1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=Pa3gm9LP; arc=none smtp.client-ip=220.197.31.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="Pa3gm9LP"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 369efffad;
	Thu, 12 Mar 2026 08:51:57 +0800 (GMT+08:00)
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
Subject: [PATCH v2] scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add new mphy reset item
Date: Thu, 12 Mar 2026 08:51:47 +0800
Message-Id: <1773276707-24857-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0a9cdf875eb709cckunmc99ce7d957335
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQklJTVZOTUwfTUNNSkMYTxpWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Pa3gm9LPU8atHGfwjM6pFp1/paSeulsxByOX5OBJ7JhU2lpd1sLpbm+Gmkx8B3eq4fd3n4ZT2QiDAsl97YeCpYqv0RoxAVYZiQ2hjHFOkLomSMMer2/vN9ie+c9gK6cM+PXEO5xIFipTK3FGTJSWCpeWTCl3Yh+npTvcYYYP+Uo=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=1CdTSXSgbu7pjk01TaZ9yRuCgv2po2xbhjwyMUCPEKg=;
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

This addresses an intermittent hardware bug where the UFS link fails to
establish under specific timing conditions with certain chips. While
difficult to reproduce initially, this issue was consistently observed in
downstream testing and requires explicit mphy reset control for full
stability.

Although this change increases the maxItems for resets and adds a new
entry (which technically alters the binding ABI), it does not break
compatibility for existing Linux systems. The driver uses
devm_reset_control_array_get_exclusive() to manage resets, allowing it
to function correctly with both older Device Trees (without the mphy
entry) and newer ones.

Fixes: d90e92023771 ("scsi: ufs: dt-bindings: Document Rockchip UFS host controller")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

Changes in v2:
- update commit msg to indicate Linux is not affected and describe the
  what is happended(Krzysztof)

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

