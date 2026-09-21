Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24C3499F0F;
	Mon, 21 Sep 2026 12:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994231; cv=none; b=Frv0w87910VPsP2A1I9H+AewQyYgkW6UE6vyYwpyoS+RKCxMjRfz5ojoCeDRVIS4ImTddzRtJiR6mbi6BcXFEs8Gzazm/TE8zuMObH7jB5wxT4zVzbfyOp/Zl1HPrzhHAegU0UxScAYUuF/2B8bhdkgZWXqvsUP+19B2bWtuEmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994231; c=relaxed/simple;
	bh=AiT8cj2rv853GLF+9MtAXTIW3QiaNa+78JJABet2UUM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T491IUPX2zqUclAqH9Ox6EWTTUBWcExgl1LORPuUrerxZfgyo82QVhY2MGLEe71Q3uH0WBWSjuzS+Vw7SYBtLXgEQNo6q0BhSCZtKuWKllGnZRwO2LYwyJRwH+OnzBdazrrlj/q3X6s3GjjonYxIHW/eXFJ3KTtvL5iFgl5R6lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uip5oA4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uip5oA4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A8C1F00893;
	Mon, 21 Sep 2026 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789994230;
	bh=hLnXXqweTbnZJWCTuUYvgYPdGMStjK8GuO3MeOUau+c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Uip5oA4TZ32/IGR8Z65C49tJkMnnH2KtXRYeVjjr/7s9VouOiP9ZyvbTLbu0O9asc
	 bKi4ylIygzXeD+gM9GuPW6/rh7cEN0wGKJJbcjvOQjBcnlUF5D3aF7Ys//b2/ybr7E
	 LT6nARwPm1dT3fPHndeuG++s6Uc/EcGZY3TMYkZGshPiQHWYtGY3ECwybWKlR7M/ZN
	 Kq0WJy1cJWX1Uy2Ip8YwJeRGe9s+NsMuyKvHtpp6ZjlgZ1zw6kLF18WvbsIuqwOPNN
	 +zr1XvSsIKz9iIRc99Txn+O33tNxOVSTjIzVwQ5Ku0zbJ067YPbDTUmmyu0AiUHImm
	 SjR2wTj3/r7TQ==
From: Yixun Lan <dlan@kernel.org>
Date: Mon, 21 Sep 2026 12:36:20 +0000
Subject: [PATCH v6 1/2] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-08-k3-ufs-support-v6-1-3479768a2299@kernel.org>
References: <20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org>
In-Reply-To: <20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org>
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
 h=from:subject:message-id; bh=AiT8cj2rv853GLF+9MtAXTIW3QiaNa+78JJABet2UUM=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqsSTjf4y3beWQaLLl4LklqE7Rrbt9ZEalSEK/R
 r5XHs361oqJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCarEk4xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0FYA/6Awljrw+Shnhvqx2o2cgUfW8/HU2U7aU/VzsXumketJDJeRnfoou8k
 Oba8yehkT2OyCWPoWCDFwzUrUqIFxlUN8hPZ/v4873+/WzB3z9TI/LHXEx9aqlqDWTjq2dLMPAF
 UocXfcjHxUytMJOOFMj1CWFPfJpvAFoZ+zrFmBN0REI5LRTBysWDpF2NVBkMS1FUvs7+fNhA7Sx
 9l9wRBSnjEfZWmfXoCblVAJgBaYft7SYVcuBR9hdKfwi56eBdaqck7nXrWZ0rUL+HoBayw13DtN
 OyNTVeQYgc4Z5Hm4d8aONGn10bxvdRitW5qYeUHTjeF7d5uUjirZ4RRjd0ziVsM4OS7KSHj7q6n
 /NZKj6MoufPHB/v5oJc764vY0S3ZBtnC4WJ/7NyosPB7pIiLYqQIqUj7AY+WRVqTFigliOCbMaw
 unM4Nh0mn/L8TfCN7B9XHuP+BN9iKD6q3PEpaCOWurOG0nQd92VRnPwPJRGxHEjMl7zSdHqpbrV
 r/2nmKw+9DCv3W/wbHyevDErl8luh+FOTvMRfu0vY01zkizT1v9vVTYkBV1rYka/oOwaAtgu46G
 x3u74Uqqag0XDZlXz3TzqRzufbQ9p+3jOomFIE04LSRm8rZbhpDPjZGfdnDAgrE+J98wovuA0GZ
 aB3OQW0zJ/C4WUhnO/B7vB5pSkraug=
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
2.55.0

