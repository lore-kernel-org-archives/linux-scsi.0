Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98B282F27;
	Thu,  2 Jul 2026 02:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782959528; cv=none; b=uvKqCdCpPlpqXMgaKnSqP3tWwM8hdwSjrkgd6TgnzE+b/qjgeL0spodVV1JpjWo5dX6wtRkvKUthmONrp2EVtHqK0Si6b40tfcpissBSRmGISWS7oAgaTw8Ne1PGhhsjXmJbAn2hhoGjd75LkdyYFy5HE7Y7XfpXuidLUsYvbgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782959528; c=relaxed/simple;
	bh=0DzLo9kHtCEbIpdfvRxJ5ac/4r14M0Je4bo1/GIYVLA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KZ/Njmc2Nn9EjwNEfK3+XYEu9LjSln7bQK2Wo7yr5ZI8oMiDVemzCgE3ZbCz4Iex2XR0tulvbQZXRD0OhvgzclfhM10JwCUSEJfZYE35+xEUhxplbJWz4wbJPO0KohyFezq06zoE1UQbb7Fv+nUI/Kr96+oXcxUyivj+uX0hauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAgTIJFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAgTIJFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FDD1F00A3A;
	Thu,  2 Jul 2026 02:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782959527;
	bh=sb/AhCIO26GuC3Uw19TdrTEQzdISj6y/ZzHjKhcogZI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KAgTIJFtWQcV2pX7SIsYmlqrUrngEY1eRY8JlDEpoRL3PXTzKjqrNNmj/CDWbny+I
	 t4EO7Ez/pjCILmoVdfxn9Fc6Cr0+xSDl/m1F7T57P8nB/q3EAX9J+8nHDlRn4C0t3o
	 GD3XfMUEaw0eJtjFzrnQtCDXBY9ttdV4P+kZyVv0uxR5IwPpu05ZyVcyaILdjFD2Ns
	 r6oh4US//37Al93Xv1Cyc3H1xVWfgCnDYj9alhGmzAnBEVg3dEaPd4I6PzkeIIdM2w
	 UnRk7b6pWeDwlj9eRGg0cWTN/jxndPXKP8Tu8MOTClboSxhSAe4GYRKN055NeJoTJm
	 Vulu5S6jOLEbw==
From: Yixun Lan <dlan@kernel.org>
Date: Thu, 02 Jul 2026 02:31:35 +0000
Subject: [PATCH 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS controller
 for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-08-k3-ufs-support-v1-1-1a64a3ab128f@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
In-Reply-To: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Yixun Lan <dlan@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2140; i=dlan@kernel.org;
 h=from:subject:message-id; bh=0DzLo9kHtCEbIpdfvRxJ5ac/4r14M0Je4bo1/GIYVLA=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqRc2TH4Ck36sb3GRMfq03yztUSfJqX2AvqJ8Gu
 9bTSZndsLmJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCakXNkxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0dxw//fyiur2eAIQj69Agy5fKb6dT0gIdaXdpXgYpikCxfBpM10XUxQJ5wh
 FsIFTdBVIu6ZDCQe7Qc7/W3pEd7O4pd3OivsRfK1KQT2S3Rem0GkqNzS9oH0I4WS/w4BhxehWaf
 3ZoY+TBSPBTv57gcfFozHECiGuDM6QIK9qdZGoYQJx7VQ7EW/7oIUR76wSdlslKNnG0cPzFEaiM
 NPun2NKrwPjSVOZVYbYGio0lsdTy3iRiWa8rpKqg3j5dElRNlJy47RU3WoaeaR9jwW1IuZFy1AU
 V4uw96kww0c+3RBfG57n5V6n+QhY4Z/0sJYK7tp1FVybV7bon7I/fdTkR+9fD6zHFGLcm8BxgIV
 +gfyM5wfBYyIHtbuUvTZc02cQp/Fgts76Ad5bHAxskSsV9YO8TNLipuEETrYV54+dVlQbKHXQoB
 URJIziqoRCR16Z7IWZfrZm/Ngd6FypuCFHAuJHMSBInkRQVKTZT0jCJIhBy+2b8bWSvEm8rg+Kf
 R1uSCfCaorHJ0csOz/I0M1WrefaVTtqfR542HCG9FrWSLXH6e9l2598khFJgnB2eptYGjw9CR8g
 ptdfUNNLWvO8sW68HEmGlcV6RKDpU1gVlSxnEB0gYVfw8x57TcHgFrxwG6TfLLfma9rSz4UF81m
 S9LWNbyITj4dpAGjRAMN97HrR+ujOc=
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
 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
new file mode 100644
index 000000000000..e6cb6fb2496c
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
@@ -0,0 +1,54 @@
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
+    ufs@c0e00000 {
+        compatible = "spacemit,k3-ufshc";
+        reg = <0xc0e00000 0x40000>;
+        clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
+        <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+        clock-names = "aclk", "ref_clk";
+        resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+        freq-table-hz = <491520000 491520000 19200000 19200000>;
+        lanes-per-direction = <2>;
+    };

-- 
2.54.0

