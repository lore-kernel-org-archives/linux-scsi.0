Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB4D175A88;
	Wed, 16 Sep 2026 03:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789527619; cv=none; b=XJ6SJOD6GWuVbfCgq9z4jZdd0OosgrSH/n0bdIXj7yMN7SocjGGvdZvT6DWgfHMtPcvVZcpYgrUor/WAAJLZ5fMoMkTbDsgpKdXsoYPzXetlYszxa5iiSyLq8c3dDOnMGNJG29HA9CQyeWwVacpqkho8QKTAlGZI+1IFzVOdIXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789527619; c=relaxed/simple;
	bh=r4HfCvyvP+oc+XKN13XucNXtX6AXjd3A/sn2IsmO2pU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kePRyVe+U9rYnNcpX7eAbYsW06PnmDjXPPVxsPcgiJUgAIkdPKZ/jpG1YVMm6gSzQhCn0P1cxdbC1uLqiNJ1G+LkejuLDMcHYM8i3O9wbSikt7UQN5eMQmlNHgqknEpqNyy3q7Gf8fGRrczPkxMzOXA666xqXDnCi8iWZPVdIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0D/6wE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0D/6wE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E731F00898;
	Wed, 16 Sep 2026 03:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789527618;
	bh=UlhJ9vAyN4mHuYSRvRgKEn68Lr+Twi3vzz7+VSRMtnA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L0D/6wE2Ac3iiGLA0YnVWlxnTK78GHk5Dzo+kyGQt8BQ4OKO6RUyiwZxhh1hg3rzl
	 jxIAsPcvjHlKf37uevV7EF+LDStzdadWfsVMWU9rqjNVSDxoLpT4eJb80agP2SbUfb
	 5VZ525VECRTR15inQqkj0IBGAPfMqB/+XQEpNBRmricNnl9CzgdLezF2E+Oab2Ch30
	 qmWnIe3cIDuaTk/Sg9zwA727Di1m7PbImEi49wE1WWaiD2hvgCewphel9dcclN6nXx
	 1DAqTQZFos946tydEiK2u7zZV+CIAm360DYWfOQrkXuSCctQzPJChq6tEFu+6pBNMR
	 lUqYuXgZj1iaQ==
From: Yixun Lan <dlan@kernel.org>
Date: Wed, 16 Sep 2026 02:59:53 +0000
Subject: [PATCH v5 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-08-k3-ufs-support-v5-1-1f5d71f1027d@kernel.org>
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
In-Reply-To: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2195; i=dlan@kernel.org;
 h=from:subject:message-id; bh=r4HfCvyvP+oc+XKN13XucNXtX6AXjd3A/sn2IsmO2pU=;
 b=kA0DAAoBMarqR1lNu+0ByyZiAGqqBi6gciJP6I0eC2xDzLWDWQd/XnGlYbM2joBgJG215JTdP
 YkCrwQAAQoAmRYhBLW6uMnDG3EVZwIj3DGq6kdZTbvtBQJqqgYuGxSAAAAAAAQADm1hbnUyLDIu
 NSsxLjEyLDIsMl8UgAAAAAAuAChpc3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9
 yc2VtYW4ubmV0QjVCQUI4QzlDMzFCNzExNTY3MDIyM0RDMzFBQUVBNDc1OTREQkJFRAAKCRAxqu
 pHWU277Y+SD/9BXzdhfl0mvQKNsiHX7qkmSMoIutErTxBXl8mwrLneEVMmhBk93DC9hvBl7g6ga
 zC3GzQmJYQ/2OPU60IMwrCyAgsSX7MAm9o/GgVtyJyQH7okB64OnJ20aO+7eUZeHVlXN+JVQADC
 Eicfwf4f/0F2E7d33mLF6WHZXPTSXJ6TJpZ3ChT1RXe+Is56E9RMp7kdlymkcLxU9fJz++UouZH
 OSh9Uap9q52GOQP/HWj4QlJ/OvFifh4gjuonnYvGXupLlGlvcOkI/zUG8W8t2IMuaMS21oz7ql3
 2kS4Sxz6xkPI6nzndLA8iARaeGD6Ci+Uu6oOKZVzB017H2S/Vg2OJvnmx98IHraHFAFYK6n4BL3
 xm2M7ZeColKcn6wWP4pkg6dnRWK39GX+P+yC+rVouEOzdY1vxH7PIenski2pgh9v3PKOplGB6rO
 zkIk6XthlWfijOyHgCinw4hJwwvqLR6wfsKD9NIAdtvjI8xa3pefL0gwMQed/6Crmgm9Vj5//Qu
 nh/rPkpDIMaaPkFz6QzaDWUSqPIV3Xr0NOUa2GFtwYXMlU/ta7u/XNytVQmjR3fJBVdN8W2u+g6
 1WCXqa+YbqmXahqarInEUyxtpHQa6QJAuaA/B80R5gKUA6KUTH2YAzjuhIFWyL+P5qwQOfK9b6x
 5cQkywulr7UryGIERkz3Q==
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

