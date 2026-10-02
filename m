Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B19226CFE;
	Fri,  2 Oct 2026 03:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790910640; cv=none; b=B5uXrAHXCCgqee0iBlFosFOGNCQTdSsKiKCIE/WbsFCIUWzMjuCNQbRAR2ibTcg6CogXVTCYqzkyJpiHlO0CRLBkPvC86pTM8vf51p0bDnmsBpyyVW0Dl9S6YmnS6N/GeGZXUOd0Bp+KjP4W8XUWLhmHqCQ0ARGRbPfa8bB+QpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790910640; c=relaxed/simple;
	bh=hvByUueNj20DGLTScoJeXKAVWVNuLukJbf0xo7hBB5M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YWey4dF7kNKWxJ+vRiAlBEWiSfDF338STPbTnsYHPBwy5ve3lPWSPa4XCCwg9Yqv/4ecr2qdAax65RRba+dP/gEHcTHFnH6mjAaI0XpCHKOEYWdbDPfsUaOPjPJyafo8raSCltxCNpE4DUTv3S8KQds92UW4tEVJKhfqa4ofjvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2/HDqKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2/HDqKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05051F00893;
	Fri,  2 Oct 2026 03:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790910639;
	bh=eGVtnl9rHcaVyP0WXLdw6Whp5FwoIKCCMgtfGiFRDTE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S2/HDqKC/ZvaEPtJwZ0Nr7NX41EuybBX4P0T3m3UdOHBaLBTMYSiWoqTJWJrLPkIC
	 ftuKvkSyETnuz2ji0lJhAjChWG5GeVgqcBQMm/eSamEjxDHcg0SURjKiSVBBs1COAV
	 RObfUW23imyUvQ/0nHVleMhdR6uMEOY9pbTp/djrLTsfYFKmMhECUmp/yv7MbE3DFS
	 tNRWbZgRUTthMYRf+v4c5uGqY8n8ySwHtOWL4lgv4997G2advOJQCG1ffbFk/PgHr0
	 iEQrjuyb4eTII0eVjcSgJfN82o6CbpOPzI2XzeSMGY/nBHUUIXaXat1TFOlyQFZc70
	 nBcF+b1c6TU9w==
From: Yixun Lan <dlan@kernel.org>
Date: Fri, 02 Oct 2026 03:10:10 +0000
Subject: [PATCH v7 1/2] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-08-k3-ufs-support-v7-1-bb39007ff9ae@kernel.org>
References: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
In-Reply-To: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
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
 Yixun Lan <dlan@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2268; i=dlan@kernel.org;
 h=from:subject:message-id; bh=hvByUueNj20DGLTScoJeXKAVWVNuLukJbf0xo7hBB5M=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqvyCeOIwoLZJjMZOjkrtagBt/YRy/XHdcwy6NI
 5E62vEeGQmJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCar8gnhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+3nqRAAksBATAwXGSGunaPArd10BrVOoqWAPeEtdnTvyT/KFAZkj48jHMvCt
 1fOUb0eZCUIpJe520339+TU4MkhGRgUps4EHNIsKPd4Wvr7NhvBppm9AYQ9gjXkSPt5QsP8n2zS
 VIaBP7cxF23E+TQ5PqGTrIIQepZMpGLfvbJQbdoI060I4w3zu4h8tbZaQ5oshMBm6e1IlLu7JT8
 dJ5sizRJCncB+6Y3sXpDNllD8r8qn4CzsToyCKg6zhvhHUPgFscwsmX3OFwkC82aqtDTC7bmFuV
 Ylk+ptVCR0EuUDaGHwUdG2eTITxbgYl5oGUVhffQDk15wJWS7Sok351o2bquf2JNw2BViatFjEf
 MO8irVdx//gYj5IOSbSsTkHfNj3nAavDa+Xg5wfJ6Iae7rdpnNs7QwMqKLvSdqazkT/Gy/vB6iI
 W5LJOAUi1OwQyWGEvmgPgwbYbg/pWGBPP6BY8M7sKEyf8SnP+mvxZAtDJsR28V3E87pSECKRgUX
 h4SwGqGoDhIcr2VCBG4zYePurz4QjPkRifarQ9COZ1F5EhmPi+ar5RFkTinyPMt6kCLw2lBdWhu
 X5JneIx7PBOvmlv6aNX0AkFYCX/9kD1fP1awobkD8O713ND4TvsKU6sPnnBJU+zyt3LbwP12KCA
 9AgMc3yMk0efsOG/J/aUJbr963pHu8=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

Document the compatible for UFS (Universal Flash Storage) Host Controller
which found in SpacemiT K3 SoC chip. Its features are listed below:

- Compliant with MIPI UniPro v1.61 specification.
- Compliant with M-PHY v3.0 specification.
- Compliant with UFS HCI v2.1 specification.
- Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
- Supports standard low-power hibernate to reduce power consumption.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
new file mode 100644
index 000000000000..8512a81f1cc7
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
+      - const: axi
+      - const: ref
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
+        clock-names = "axi", "ref";
+        resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+        interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
+        lanes-per-direction = <2>;
+    };

-- 
2.56.0

