Received: from mail-m127175.xmail.ntesmail.com (mail-m127175.xmail.ntesmail.com [115.236.127.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D91607BD;
	Tue,  6 Aug 2024 09:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722935710; cv=none; b=l7bR6tE8c2jKN2uLlLaDfl+MDeN/b5JXtvsSvBi4NaL7h4Sz7N6hI06LJkfla5xFyxUeR9Nh8imXrjGT3C812SJl7qB3gb9ifR+McCZRJzSREUaxlntWXJHhNX+ES3cG6BbZAAFrxAIiWC78u5lgcke1MgLQwzNYGA2mCpZXpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722935710; c=relaxed/simple;
	bh=U7CC4FRHymHCqssl1IA3pMgvF9xhzgHxO7SntYYtcGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=D73yVWTfBSPYeW8AyeFeB0Jt7kiq6Ges2k39KGL359w2Brf05pufUUfa5wG5t6NCCbcqFRnhzSxzwqb61tO8l/LH+ui5N/ASR7mt8ZCPTCj9cnMSfExezx4csIvbgdXpeJYOv4oC6LKMXn8WRfurpzHjIdHcZNHeYkWeCzKP7+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=csuHE/b3; arc=none smtp.client-ip=115.236.127.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="csuHE/b3"
DKIM-Signature: a=rsa-sha256;
	b=csuHE/b3StOi/ls1Sa2rMC6zBwf9yGJ+8oh4hx9GLHyKONb3p2jIQUQxXCkoEahXQ4LTycMkNtMhShTAZv3tpI8V8HcncE+roBDGSeMdtytyAdOHvdIbZ9uCUimKgvsiQJzGBYgK+QTBIEaneXVJlG1MQRyUZQSclixSHdTeTss=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=LMVMwH7LofqOvPfrqlYHp9W5j7CWVyj4pSOchCn8W2E=;
	h=date:mime-version:subject:message-id:from;
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 48F154604F8;
	Tue,  6 Aug 2024 15:20:19 +0800 (CST)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Rob Herring <robh+dt@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>,
	Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v1 2/3] dt-bindings: ufs: Document Rockchip UFS host controller
Date: Tue,  6 Aug 2024 15:19:59 +0800
Message-Id: <1722928800-137042-3-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
References: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGUlNGVZLSUwdHRhDSB0eGkNWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91268f6eaa03aekunm48f154604f8
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N0k6Fyo4ODI*ExI4Cj8OSk0I
	HTwwCShVSlVKTElJQklDQ0lLTkJPVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQU9JSE03Bg++
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Document Rockchip UFS host controller for RK3576 SoC.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 .../devicetree/bindings/ufs/rockchip,ufs.yaml      | 78 ++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml b/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml
new file mode 100644
index 0000000..e2e492c
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/rockchip,ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip UFS Host Controller
+
+maintainers:
+  - Shawn Lin <shawn.lin@rock-chips.com>
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    const: rockchip,rk3576-ufs
+
+  reg:
+    maxItems: 5
+
+  reg-names:
+    items:
+     - const: hci
+     - const: mphy
+     - const: hci_grf
+     - const: mphy_grf
+     - const: hci_apb
+
+  clocks:
+    maxItems: 4
+
+  clock-names:
+    items:
+      - const: core
+      - const: pclk
+      - const: pclk_mphy
+      - const: ref_out
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 4
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - power-domains
+  - resets
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/rockchip,rk3576-cru.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/rk3576-power.h>
+
+    ufs: ufs@2a2d0000 {
+            compatible = "rockchip,rk3576-ufs";
+            reg = <0x0 0x2a2d0000 0 0x10000>,
+	          <0x0 0x2b040000 0 0x10000>,
+		  <0x0 0x2601f000 0 0x1000>,
+		  <0x0 0x2603c000 0 0x1000>,
+		  <0x0 0x2a2e0000 0 0x10000>;
+            reg-names = "hci", "mphy", "hci_grf", "mphy_grf", "hci_apb";
+            clocks = <&cru ACLK_UFS_SYS>, <&cru PCLK_USB_ROOT>, <&cru PCLK_MPHY>,
+                     <&cru CLK_REF_UFS_CLKOUT>;
+            clock-names = "core", "pclk", "pclk_mphy", "ref_out";
+            interrupts = <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>;
+            power-domains = <&power RK3576_PD_USB>;
+            resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>, <&cru SRST_A_UFS>,
+	             <&cru SRST_P_UFS_GRF>;
+            reset-names = "biu", "sys", "ufs", "grf";
+    };
-- 
2.7.4

