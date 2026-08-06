Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D935966;
	Thu,  6 Aug 2026 02:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785985014; cv=none; b=N8jhKkPOmDlftJUCCl4nalSGV5isz3jPZdhTajWnXjYV0/iEyYhXI8XXii73tc34dd0Byg9ZtknPREEzJFO7JtRq4hQIv9H93BP72RK0CFEYbo51DarFkY7AwmI/IukMho6+hfNNhV3DO8PHsnSbmNxjy4CRBTV/CyX3tN9iAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785985014; c=relaxed/simple;
	bh=rk95kKGG/SkoEMHzqicwZcRd7bMRmZDFgL6+fZ2Pbbc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p07JrxYKBRv83C3DpBkqdDhjUuX9iJJPnLp3O4AXd8XU7sZjU1tyZVstPOEQWktawCzG1mmws965rH7COGMLWPIryTPWJPqVi3UkatzuWqN7DlxfvoRd8SoHilpoxuS1bbFz0QH3lTO4DlPiG5+JnSib9/qhUI71Ov/Nf216QJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDj0gAuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDj0gAuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0411F00A3A;
	Thu,  6 Aug 2026 02:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785985013;
	bh=tV9IUwoo59NJmLmcHHMkUhsXWOY7J5vyTiJOpbYBP9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XDj0gAuLeC7MWqW0c2SPca4DFPqtpXvoT6kiBqmELVYSiyTl26bLuDtjnl2ENpAhp
	 4koH9qxhY0nFlJW89y1J4C1yoQH2TidTqrlTiQIAxHOF5QYguO1IWjQFeFZO7gfAIj
	 lHRgNa37wJCqI0xlbn2F1JjCoNPGEpxGJAAVBNRuEY5bR85ezwnFOgZQKJzBnMf8F6
	 ZyvQ2ToRLi4JqFaltpKi/MUQMRm57+Ziu4V8WCp2UysHi58i6FDT4LPr/vr5+GZK4L
	 ig7JxbuBMjkyQq0FtBjG/9oLXvRsYaFfgVK4Q44eJhaH+bQ4ndQRwLqPMPvEgGw1z8
	 gEmK+8FfpoQRA==
From: Yixun Lan <dlan@kernel.org>
Date: Thu, 06 Aug 2026 02:56:18 +0000
Subject: [PATCH v3 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
In-Reply-To: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2205; i=dlan@kernel.org;
 h=from:subject:message-id; bh=rk95kKGG/SkoEMHzqicwZcRd7bMRmZDFgL6+fZ2Pbbc=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqc/fgPHVxzfEDiS3x9/JzjpYht0L6ZNUIuFsUp
 njnGrXusRqJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCanP34BsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0FcA//X/edkMvgnBJ9mmIDmNZRE6x1/7phE7/KKhVlb1iWHZm1Ukg8Olf6x
 RI/0q5d/hXtIy3X/fcA6Cgfc/4fADVq23JkTRkPIHbuGF842tzIlHoejejnJToT9eUS3jEjtjFx
 77L69uC766l6a1R30I+7nulgnkntrBzc7TynMuDYXrT7XQ1DG2Pzj0IcYmP2+bm+UdEQ0SKQg8k
 2aJH5K8mylqC1R7SIf9sPgkldXmVrjNju7JL8ynUe4ta1tjM/bZ2A7GL5kUT5pi2gLGGe3ka1SB
 T/wlWfprSXIH+2PpUly0+1BE+X7OdPN4uVtYVL2FRBPuFDitAp86yBVOTbkn7UhcK3U4FN0B1z2
 APnkj4eYxG2ejcoM+iTFXEPQ4/lY1XSB38GYo5GJ1w7vssM2/i/oIWjsnXSvACWRKmdrmIbiK32
 ZxUmA93hHrRMbv0xo1WJz8S9tNCEEKPN2yI+rU9qcksL/FF4OGuhbvMbHWsiwQVEwn17ae7bHGt
 sh5st7a4Xl4tWd4kXDj3VqCuAs5lTzsFW9YobsFwOExSEiTRPJJPzfspzKiM+Il5HIIu4vlaYWc
 LsmovfFab9hLMM4N0NZbc+2aONOnV05sPADnAzGWx5KI9FYyVjtCxV5fdccxM527+pZ7rNVbO8l
 XOZcQBkJ1brXoWE0XE7NnRytVI9oug=
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

