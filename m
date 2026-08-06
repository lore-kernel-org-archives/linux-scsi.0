Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203B32B108;
	Thu,  6 Aug 2026 02:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785985026; cv=none; b=Dw2+FOE1MbBHSpg8Actf7QKLI6Vtvrj88tUqQ11w91430QMyVbdBD9n6tGm1aGhVFBi8x3ICxXJf6cYAKc8QvJSGfhFD01hL2tzFwowVnH2je6pFVIQHH5p4Um6nNN3vzq1vfs/BG+74xeoK5fRaKJHxjgNab/vHwHTxKw2oKdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785985026; c=relaxed/simple;
	bh=nykwdQ1lawCD1f20Ut4zh5W92JnzXk/8R4UaYQSg1nY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O3VkzBu6EyhWKDTvl2FNhFkfXvYiuHN/OHVeFASvXKesC0Nwz1J6fB8H7JARnT2XwdZ32oeJXY/NX/bsnzTd+7DooAwsMGRRKMRtdLjvhzsnwoexSLerN9/EIXuSanO45r4cFJgYpIdVJ5bDRJbLoadU/6mKUBSXDarqveHtfKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1nq3RSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1nq3RSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F17C1F00A3A;
	Thu,  6 Aug 2026 02:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785985024;
	bh=6SPLTG/S37Iver7+JwBm2lv7CYLiHOhuP0JvkwUs67g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J1nq3RSlYZ0Od/xggdNb+RJu/lCz+yHP/s8prjKqx21lu7ZUtPi9duBjgFYiUVesW
	 eckWckziyXrla5fTr3D8YZxoJMB7hYa2o5DtlU6Y67S75OnSRO/TyQnGXhaKmX2gZI
	 KoDxNULrOtM6+e4thG8Br+YHGDJXARuokwVzXTU2ZKCOzG1FWLTUErRkzZKhVPZz0M
	 HgTvP3yqNGeqZx+K/KLXE3X0I3CZB1PwrpviJHTNtB/9I5pQV+kPXT6c2gqdQegucT
	 WwjhQToYxl/jxxePbXo+bZFVVYBw9ck+sw8cRgRJV2xg+DPh5B2DI1UthSE6o83dXc
	 jAPbH0eJxhiJA==
From: Yixun Lan <dlan@kernel.org>
Date: Thu, 06 Aug 2026 02:56:20 +0000
Subject: [PATCH v3 3/3] riscv: dts: spacemit: k3: Add UFS support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-08-k3-ufs-support-v3-3-037fb322acdb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2242; i=dlan@kernel.org;
 h=from:subject:message-id; bh=nykwdQ1lawCD1f20Ut4zh5W92JnzXk/8R4UaYQSg1nY=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqc/fndJ7/EeUC+XIA/eUWldubrWY86RP/a3Fel
 YWRpm92LwCJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCanP35xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0sjg/7BVVMRhGnGCTJ3fekrosx7d8WIatRibuXkAVtm+A5JOSlgmfeoifbv
 tG6RVNFJvcFPjqbPtXY+rkMraE+Tp+xdzm7wsO4T7LBwJvi+HIeqvzxiCZsynp1xmMWlJltIetA
 peWlxkaK/1B14+57ufCP9lEV6PNj5ByremvBdcoyZOWMoyLGWjP3DC8r5BYUqJCRcrtLRR+n+gs
 787l97wRcxMPc9BaWRQB+6U4DriabY54YaG7Mn1QIjdseL1nMktNEjy42mOMFhXhoYLlRzXxeiM
 aZbXXH9qbhe/Yr9Co1DbmJ4c3i9C9l9R5WhiBcYbPbXGT+/9cotUK2vtk3bN4nVQc85xwGekgPZ
 FaV8U2cg7dp14X0sGi+cpa9ooXLLF4dUFQKAkw5nqpnjQCVgB5dzTA0+0cPgkpLdYdUjPxLlMjp
 BLwJzeg5pXMRTqy0BGu17r9RmdFgPRWrRONU7RqPOfCE6SmdGAmFbJNVKye0pIlZx0PLGbv7raz
 EHXs3hL3MIjVH6DLhab3kBkST2GV9V2cCEP6wCn1RvkKSc8T0oNNduEMQ7LiHKSDbqANUBa23R1
 fueHp5Ga2Lk5HDcBjhlvJhCeZT1VoVuqRG3w/t1yqxtA2wPMwSDRhDCuZJxgzU/zFctJsnGOmq6
 3z/qA+P3EePNhco6Xoa9LUb4XUA9FU=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

Add UFS Host Controller support for SpacemiT K3 SoC, and enable
it both on Pico-ITX and CoM260-IFX boards.

Signed-off-by: Yixun Lan <dlan@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi  |  4 ++++
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts |  4 ++++
 arch/riscv/boot/dts/spacemit/k3.dtsi         | 22 ++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
index a38d7b738258..a68a55c8e73d 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
@@ -188,3 +188,7 @@ &uart0 {
 	pinctrl-0 = <&uart0_0_cfg>;
 	status = "okay";
 };
+
+&ufshc {
+	status = "okay";
+};
diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index b89c1521e664..eab8c430f2d1 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -206,6 +206,10 @@ &uart0 {
 	status = "okay";
 };
 
+&ufshc {
+	status = "okay";
+};
+
 &usb2_host {
 	#address-cells = <1>;
 	#size-cells = <0>;
diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index 19fc9b49668e..cee1569608ea 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -469,6 +469,28 @@ usb2_phy: phy@c0a20000 {
 			status = "disabled";
 		};
 
+		ufshc: ufshc@c0e00000 {
+			compatible = "spacemit,k3-ufshc";
+			reg = <0x0 0xc0e00000 0x0 0x40000>;
+			clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
+				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+			clock-names = "aclk", "ref_clk";
+			resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+			interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
+			lanes-per-direction = <2>;
+			operating-points-v2 = <&ufs_opp_table>;
+			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-1 {
+					opp-hz = /bits/ 64 <491520000>,
+						 /bits/ 64 <19200000>;
+				};
+			};
+		};
+
 		eth0: ethernet@cac80000 {
 			compatible = "spacemit,k3-dwmac", "snps,dwmac-5.40a";
 			reg = <0x0 0xcac80000 0x0 0x2000>;

-- 
2.55.0

