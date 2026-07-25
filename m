Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7EB31E838;
	Sat, 25 Jul 2026 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784975895; cv=none; b=J6r4trQ5t9P9tT0KG4eZw+LLnswhzs0jhf7f2YY2gtrLZjBSvLJSVLAOfL8KAM8Jof7bcXsdbi5o5IAnmBJ15Znp82cTCgnWCaavYc5UqaAkUG87e7xgi4be6frNCUz3qXMqobkRsnwlb9GS8ba8byaaIWHgcd05Q29TEbNik7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784975895; c=relaxed/simple;
	bh=oSJO3yoJYVvJDeEnPs20tzu2JSaIKWppJJZ2mCc9qjA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ll26TBKAKJXoBNBKUMzVXgNowfqkWXm/u/LeNde0jbc65bRnDxL7SjiWb+JSGdkdEpw8d5GEt646Duo2QWcWEq7XC30KGgVpPdQ5A2kLWmLpfmieTjJkaC/kL3BTMGbWRz9WL1jPDqBczsi3O2NJEw+g6PcLlAowEMsUuG+0d0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNKK1cZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNKK1cZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D001F00A3A;
	Sat, 25 Jul 2026 10:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784975893;
	bh=qMwH8GdhJg7z206OvV6OmLahq8C+BVbYd1oMzwz8zgg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kNKK1cZ31qEVzKbS310ezgPPLdab+CQrrUStw3SQ1C6bKAdrLwzlI30v7D+Tj8ko7
	 TUGum5x12EVfv8Y6REs88QiL7CLC1Kira4YCyxJk7xu8n0bZEH6OaA+tdo/PcWYffo
	 mCJbXU04q/gD81SvkxYJR1+WZadwLPZuJ/xPB9FeiDrPhhvAe5ZHsgLZ3HFvn02j/L
	 iSIG1Czff8IKmaZgBzJQZf7iPXSAcDknA6nHpFduHyFHISTuNP2iHRcw2OcqyPt9n9
	 p0HYtI0ef29174ZwRyyUzsZTM/zAQY4mekafq1u0hXX8IE9vuh0r7nsbSS8fMizs1q
	 O7EJyO+s95JNg==
From: Yixun Lan <dlan@kernel.org>
Date: Sat, 25 Jul 2026 10:37:44 +0000
Subject: [PATCH v2 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260725-08-k3-ufs-support-v2-1-45036a2a2418@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
In-Reply-To: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2246; i=dlan@kernel.org;
 h=from:subject:message-id; bh=oSJO3yoJYVvJDeEnPs20tzu2JSaIKWppJJZ2mCc9qjA=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqZJICi6M4D8a9g/g+d6tA3tPZmyfQ1U0jObTpW
 eb6egcU6QeJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCamSSAhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0QJg//Y8/RJvZD+l0dBcAcDjhUum9+dyfWZJSjxIPvyFPbB2cg4O+063lCD
 qpQesZARY6hjlZdauTIj8TEKm0jJhODLYRaG7LZQ8OO/p/r0uCkYs+zJ1B254XOq6mVKpwh8uhT
 yemVO5YWmJGk0KS/Vg9LWjUTuV78yA0tYxNa2bYeL9TBiEClfY0+48CvYbM2QUyWcNHCRjCEtM/
 1n4KihmOHBsGJojI/KejAzEB8qtAlrsWTont4fKSRB3DksD9ElhLiibRynFomHiAhG39UJI2v92
 CActjezZeDFrvWMRc6cB5qa3hby2OqlMZwylJEquynXSMdqOtJZUGmHT3s6AE8SJ6rKjyzwlHFv
 dkbvx6BD2eM9WVbEPDbjXbCnoDao78tV+QS+LsHMv2n/dyEG2ZXBpFhg8oU3Z0AWf3ojTAaR+Yr
 eJ89c/a3PTRWLdXFYnsmNNzN1b/5BFYqFsJg9Uhuu+W0pF2oV4Y/2v7Z5kkbpwLzvOwcW35Yevj
 1oCw/Oliy+j28a30FITrT61NQcU2lRatBR7AKk7sgY5xC/EfkJTCIl+cC0B701WbKt9AII6zao+
 DyhVpR/GgwxbM1kePK4fz2AX3d5SVPwVeQZv2AN5rYp8HJ50+L8ALNY63pKXywLV7V2JieEvh2l
 VBW1uCNyufhzhqsfg7xsrdD2VIp0B4=
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
index 000000000000..45cd7837c3f7
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
+        <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+        clock-names = "aclk", "ref_clk";
+        resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+        interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
+        freq-table-hz = <491520000 491520000 19200000 19200000>;
+        lanes-per-direction = <2>;
+    };

-- 
2.54.0

