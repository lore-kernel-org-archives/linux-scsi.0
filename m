Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF753A2543;
	Tue,  8 Sep 2026 07:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788853351; cv=none; b=ADvMIfP6wGU3gE2F8OwYhXIpYyhBhCDp+KdUqFIoY0k1Jtze5jyn38OJQm4km1QFOpTUbO3tN1FeYKD+1LhnWqzJfqv9lM6K4rIBIxanvgtJ8N1dVKIzGqKu09mi9dNckjRZNCVcOUkqBcSgNuLrM2F6zHLw/AkKoOmXkxLVu8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788853351; c=relaxed/simple;
	bh=rk95kKGG/SkoEMHzqicwZcRd7bMRmZDFgL6+fZ2Pbbc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LIhi7Qn/mH6fPq+muEn+qwl6x/H5pLd36GdLce3dFN6+ezbhZlb89zRhQcBPYO+qN2h+iMws4MKvuY5QfJOCblrZQ7h+vc1vsGBSCzfsRkFrZw3q25tQoJoCaZ7bxuF88rnVVJ7EEUF8VvznTBbCVYIcyjMiatHL2EzfIKGDw2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6um0j6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6um0j6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9567B1F00A3D;
	Tue,  8 Sep 2026 07:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788853349;
	bh=tV9IUwoo59NJmLmcHHMkUhsXWOY7J5vyTiJOpbYBP9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e6um0j6ESrucysFwkf5r6HNWPzsTc0+Gd93YE8eQkDV0O5ssn78IWL99LdE7Lj/vZ
	 AHWFpovcNjiZJhO8dfW8UzVJ6bgv1U+zlq4t9kgCn5HsE5ZrcbYE24InaIXEWBfvZz
	 2rWidil0WTTqxbmU8KrvMfWhrgGhqnH1edKo8n3+7ipLW9xCoHnOfVwQvSgJhRNzQn
	 tRnQuk4K2XFFvtn2KeGgZ9altvoovhbdIYSmKHULsC+URcWcXuiVMZryg6Wi8aeRAH
	 W0aCMb8ME7XL6+6OWX0dYkGL3TxUpGe37TGFp28t/wuht9lgp93RS7K2cxa3NV5J9Q
	 ll3C5m+AL6RJg==
From: Yixun Lan <dlan@kernel.org>
Date: Tue, 08 Sep 2026 07:42:03 +0000
Subject: [PATCH v4 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-08-k3-ufs-support-v4-1-22aa2bd97d3b@kernel.org>
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
In-Reply-To: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2205; i=dlan@kernel.org;
 h=from:subject:message-id; bh=rk95kKGG/SkoEMHzqicwZcRd7bMRmZDFgL6+fZ2Pbbc=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqn7xR5wtNpffnuxRFGP1wvMK84k0sxnS1iCz8q
 o8c4X4MiRWJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCap+8URsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+1zbQ/6Aq+/pye8H0hu9O5u1yZRP39vD1lsFvltjrRqjX6kcGov/2fIGVAUO
 rfEqQRIsvy2aYsYk/L8qynu4+dEjBr0f1mJlJrQP6c/8hGoyETROQSDIYlR4tNq4aF6sjsu9Pzt
 +lCt8vs+X9p64Ap1UfviF5/73t1e0wvLg4v/E2YRFPJ6sAvzqOgPN18u4wO/FdE9rS61ppwzdfu
 kvuQ1IkXmmYKgK5xZiR15cMEH0RVVNFqXBrs/D+wDWf3RaA0Qy8vlgNo75Fb39ILLA5piDpCDFY
 g2sRw++KrXCp1ULNU/0uIbtzEvGDsdnlF220SlULNzVYkiiF4ChPKNuGVoDM3gi9SJLOFEmmr2A
 zI7kYYfWqm1vfqSn9rktTdMFtbPTkF5tlhMuJDtO370fOuyNB7/PuGIxrK4GZ+zfCox9AXXcq68
 su9H13StUaDlb3AplqsgPxLINMpAxnyx25Nxsn5PynFpFSPIwqaX0aheEYTEpUy19iZZQrj3NRC
 70+3RcjFfKnqmHJZaAJZAu1BxKEonLwcCj41/q4Jkox8M/PgVBQFM3cmBtBJSg/gMWPp9L3OHYn
 DvWZKHATf282ZJW4uOxcnUYvc92m3pulDqRi8EGv350OTof8+kbFy9rLqnRTo+P6ZuE+k5/Gq2f
 yaSezlEZCgwTGq5hq1tUTBDBqclruI=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

Document the compatible for UFS (Universal Flash Storage) Host Controller
which found in SpacemiT K3 SoC chip. Its features are listed below:

- Compliant with MIPI UniPro v1.61 specification.
- Compliant with M-PHY v3.0 specification.
- Compliant with UFS HCI v2.1 specification.
- Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
- Supports standard low-power hibernate to reduce power consumption.

Signed-off-by: Yixun Lan <dlan@kernel.org>
---
 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
new file mode 100644
index 000000000000..dda533c852e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/spacemit,k3-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: SpacemiT K3 SoC UFS Host Controller
+
+maintainers:
+  - Yixun Lan <dlan@kernel.org>
+
+properties:
+  compatible:
+    const: spacemit,k3-ufshc
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: aclk
+      - const: ref_clk
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/spacemit,k3-clocks.h>
+    #include <dt-bindings/reset/spacemit,k3-resets.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    ufs@c0e00000 {
+        compatible = "spacemit,k3-ufshc";
+        reg = <0xc0e00000 0x40000>;
+        clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
+                 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+        clock-names = "aclk", "ref_clk";
+        resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+        interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
+        lanes-per-direction = <2>;
+    };

-- 
2.55.0

