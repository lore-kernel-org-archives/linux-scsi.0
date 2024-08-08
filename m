Received: from mail-m19731101.qiye.163.com (mail-m19731101.qiye.163.com [220.197.31.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43565C;
	Thu,  8 Aug 2024 03:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723089255; cv=none; b=bLEW0x6y0EsZ7IpTgUFfvHExj8LaGEh4dkV8Na4RxNVtQM8kdDSIQAkEccCF8fGTb70VCGfJnUscuuMshzJK9eMO9ot/o16hw+Auk+uu0CrAFx8a6fNgynHP092Fx/uC0ZfAgI7u3cLJFwN8slmc5JN2C7+zOV23O5IYBuL5dyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723089255; c=relaxed/simple;
	bh=4W35/XbovlxYoMbolzXIdO4gXW95FkGrGHGDV9mnDcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=WmjxWx3ZycHeg4qu9kNX5wfyV9MFykUNA8eApjwrruN/QqdwUoPBkEtLB4VyKF9UPNI4bQ9JGpSmye8GbhtvP4bWTaINOK1YDWO5VUYcowrnKZd26mR5XDWL+SyuvuWSJB9Bs3tOwan79+TTHA14N+4mKerNyHWKX6L6UzCs0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=kFaVLnmx; arc=none smtp.client-ip=220.197.31.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="kFaVLnmx"
DKIM-Signature: a=rsa-sha256;
	b=kFaVLnmxJ0WqyG9uyAzc2wSGNjmA7umrS3fRsCE8PPp0trWDtDyqmW40bngSnC3QOTGZiKQ1ttOi7uaY+ZO/f/K5C3fCtKCdbROWqE9sK0o5Hqw6Fg9HOpvx6dYXgyfgzfGgQVGyeRyPRn97ml7xra20CPQ6EfRAw/nkX7Xek3g=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=Q2TCGiFQuP7Aex+0R9cXIqy0nyZPoAyhqD5py5ZHqSI=;
	h=date:mime-version:subject:message-id:from;
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id EE56F4603EB;
	Thu,  8 Aug 2024 11:53:12 +0800 (CST)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>,
	Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v2 2/3] dt-bindings: ufs: Document Rockchip UFS host controller
Date: Thu,  8 Aug 2024 11:52:42 +0800
Message-Id: <1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGkkdS1YaSk9JSkpDTB8YS0tWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91301e8bce03aekunmee56f4603eb
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAw6GRw4DTIyOQsrPws0KD4e
	H0swCQ1VSlVKTElIS0NCSkJPT09OVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQU5ISUs3Bg++
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Document Rockchip UFS host controller for RK3576 SoC.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

---

Changes in v2:
- renmae file name
- fix all errors and pass the dt_binding_check:
  make dt_binding_check DT_SCHEMA_FILES=rockchip,rk3576-ufs.yaml

 .../bindings/ufs/rockchip,rk3576-ufs.yaml          | 96 ++++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
new file mode 100644
index 0000000..1844fe3
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
@@ -0,0 +1,96 @@
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
+      - const: hci
+      - const: mphy
+      - const: hci_grf
+      - const: mphy_grf
+      - const: hci_apb
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
+  reset-names:
+    items:
+      - const: biu
+      - const: sys
+      - const: ufs
+      - const: grf
+
+  reset-gpios:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - interrupts
+  - power-domains
+  - resets
+  - reset-names
+  - reset-gpios
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/rockchip,rk3576-cru.h>
+    #include <dt-bindings/reset/rockchip,rk3576-cru.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/rk3576-power.h>
+    #include <dt-bindings/pinctrl/rockchip.h>
+    #include <dt-bindings/gpio/gpio.h>
+
+    ufs: ufs@2a2d0000 {
+          compatible = "rockchip,rk3576-ufs";
+          reg = <0x2a2d0000 0x10000>,
+                <0x2b040000 0x10000>,
+                <0x2601f000 0x1000>,
+                <0x2603c000 0x1000>,
+                <0x2a2e0000 0x10000>;
+          reg-names = "hci", "mphy", "hci_grf", "mphy_grf", "hci_apb";
+          clocks = <&cru ACLK_UFS_SYS>, <&cru PCLK_USB_ROOT>, <&cru PCLK_MPHY>,
+                  <&cru CLK_REF_UFS_CLKOUT>;
+          clock-names = "core", "pclk", "pclk_mphy", "ref_out";
+          interrupts = <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>;
+          power-domains = <&power RK3576_PD_USB>;
+          resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>, <&cru SRST_A_UFS>,
+                    <&cru SRST_P_UFS_GRF>;
+          reset-names = "biu", "sys", "ufs", "grf";
+          reset-gpios = <&gpio4 RK_PD0 GPIO_ACTIVE_HIGH>;
+    };
-- 
2.7.4

