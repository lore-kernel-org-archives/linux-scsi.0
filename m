Received: from cantor.telenet-ops.be (cantor.telenet-ops.be [195.130.132.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE9224888C
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741181675; cv=none; b=FURRhmjgZGVyfcbiH4ZY6m0ouECGEzUTrUxRkSQ/QWx5jPej5wiIvv/H4Xp8trRBCoe6Ui3BPJdkdXkYCBlbKfvMU9u+rnJCKhPxoqWOIQO27GqvmYhkRPJ1JMDaACDFZTECiUm4GRZwE3iorKxOTJylsU03hCLoOvlJPsj3Uog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741181675; c=relaxed/simple;
	bh=imVH2Wne9UX6v58rw6Wb8RgWDaX4qSg52ZAvFuprd3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBShgbcS2sT6nmyNFMuarKZG5mb7vxkH5uALiAjUNfYsG5zvD8MkKdtZxgKFZ4OU6BZWI07xCNm0+K9sLb43uDwfx7wKiFpHkC/Dlo2Jcl5iXUDBMHBeuPta0/Zv0iz4GMApV6jhEW1IFTT+lyOEHAvV2+TzVxfKtfURonUwjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
	by cantor.telenet-ops.be (Postfix) with ESMTPS id 4Z7D6t3xKHz4wwyC
	for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2025 14:34:30 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:fba:8cad:3d23:9db3])
	by xavier.telenet-ops.be with cmsmtp
	id M1aJ2E00F0exi8p011aJll; Wed, 05 Mar 2025 14:34:22 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tposn-0000000Cv3q-0yNA;
	Wed, 05 Mar 2025 14:34:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tpot8-00000008woN-1Iwi;
	Wed, 05 Mar 2025 14:34:18 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 1/7] dt-bindings: ufs: renesas,ufs: Add calibration data
Date: Wed,  5 Mar 2025 14:34:09 +0100
Message-ID: <2f337169f8183d48b7d94ee13565fea804aade84.1741179611.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1741179611.git.geert+renesas@glider.be>
References: <cover.1741179611.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On R-Car S4-8 ES1.2, the E-FUSE block contains PLL and AFE tuning
parameters for the Universal Flash Storage controller.  Document the
related NVMEM properties, and update the example.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - New.
---
 .../devicetree/bindings/ufs/renesas,ufs.yaml         | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml b/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
index 1949a15e73d25849..ac11ac7d1d12f6c9 100644
--- a/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
@@ -33,6 +33,16 @@ properties:
   resets:
     maxItems: 1
 
+  nvmem-cells:
+    maxItems: 1
+
+  nvmem-cell-names:
+    items:
+      - const: calibration
+
+dependencies:
+  nvmem-cells: [ nvmem-cell-names ]
+
 required:
   - compatible
   - reg
@@ -58,4 +68,6 @@ examples:
         freq-table-hz = <200000000 200000000>, <38400000 38400000>;
         power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
         resets = <&cpg 1514>;
+        nvmem-cells = <&ufs_tune>;
+        nvmem-cell-names = "calibration";
     };
-- 
2.43.0

