Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8AD34E74D;
	Wed, 16 Sep 2026 03:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789527629; cv=none; b=dyiRzHVvnohq/ltN5q0izUGIVDeE9fdtVUyDBwVBf3jSTqPHFagiu3ZwlNFlNSYaHIiWLpbofI4V69Cz/jNwgnNpxkbvYoL9wmYpPHStigdgYUanBBSj/Rz/U4+SLo+xw5kctvO914Zjw432lnUr3d1qlLc3VGouvz2HgFE83Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789527629; c=relaxed/simple;
	bh=vt89jht2m3Ep0liti7ZE9hLLPYbn/0dky2+jXcoj8zg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=notg+P/1/0pQycLglIbCIY7DxPTJjrdQVYkJIiEywVeqlRdNfiMGZPoZUTG9pKaCnH0WYfBXlzIje/qY5mx38OvI0c4YxKont+jODvtbvCy7hJnRCjxvwaGC8m+vZnCES/8H/26hK2CXfUafvFDrVk6hgOVqgGfGVoI2Zw8Yzbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F05s4Wrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F05s4Wrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DB71F00899;
	Wed, 16 Sep 2026 03:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789527627;
	bh=hkmhqw9n6hp7sJoT22gikIyabRyx9UwfObiWsFoBFds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F05s4WrxIFaTZF6s5CnqIn5uxmeC8BlLL8wQyUHgHlWYj68s8SBh/Ql5LM9+VYqAL
	 3AhfwIQqZyTKBpRNTS2y4WcyXA+ESk2/ZZ6OneydD2zc2PLNt2YagO5ZSNplLXbaUt
	 7dXj/XXpT4TcY4ocKJwlXYV5GmStnettK1AOA1+ugW5Kp1Sh0h4K+HtxLJ5DtjZNkk
	 7Yiq7KX9pbqdTDHG90wqwTWoAyoN8LQs1a6VONdqU/mJ2PE6UCk1lThLj3EWAUsdze
	 xCHrFFoeuIOG2A/eSZNKykMr6E3HOqtD6n/CDlxfi+WTxPXQi+6vr20hQL2zS+oA6m
	 7EKTxf8ttFBIg==
From: Yixun Lan <dlan@kernel.org>
Date: Wed, 16 Sep 2026 02:59:55 +0000
Subject: [PATCH v5 3/3] riscv: dts: spacemit: k3: Add UFS support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2352; i=dlan@kernel.org;
 h=from:subject:message-id; bh=vt89jht2m3Ep0liti7ZE9hLLPYbn/0dky2+jXcoj8zg=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqqgY1xxCzoIyq7a+5nPPaArvuDeChhiDxQf3l/
 hIP4UbAu5+JAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCaqoGNRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+29dg//ZYip3V26PLUcmI1IEYPO1shkw/wDL21rJ7EIp4ofs8bmQ01IXl5DQ
 VjaSJ30tsnUH3Yafip/L/fbkE3CKdJtcU5lPzgqL7qgULQMVrNVCL8VENbU+BW9nQ7hHVUFiaXA
 vpq78DsdqP19rZalScaTXW00S19bIe6YNA4U+v/QWIsB5W4e+diaXKKyjyaGnrqkFv9n/EZG+Hr
 luGHsQ8pvNppeglXVt9yAudNW//BxqxB93XodtiNHeC5fwIThCRnquoptjc0JyNA+ZrnRCV9wUT
 fRIb8qS4voFvkyb2xCMTmAZpyCMQzeKHV9dFkR8VTEeu/jpwBjT5KsNjJLxlozrMc4cdkknnd1L
 MHuVFHRqOnaq3ZVFdRNGGQ3ZqYA+ND1ujcgT73xkES6V1g/dEZ5hzoApvGsIJbCZx54vEFfqhCo
 xQgU0+zDM0Dbn9hRSFg4RDDCeNGWi8CzqQmtMVNaBRBIwQcYdTQkWLli68m9IR5YStanRDHAx2A
 JPB9tZM7QwkLxb2oKKHQB+5aNHEnDLCTlW/hUFt1UYVsewXhmzOASyWEEUB5oVRuA16uKRl1Op2
 T4wJ6xnEaV+/RObqHE0h1EcLS4m5yE9Fj1fQLgzFwJoZGNfrPrPJOKAadK9wmSGhuUKRfzLG3gU
 D7wzpAQsNkiaEOXkqCCisSuQKwPOxg=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

Add UFS Host Controller support for SpacemiT K3 SoC, and enable
it both on Pico-ITX and CoM260-IFX boards.

Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi  |  4 ++++
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts |  4 ++++
 arch/riscv/boot/dts/spacemit/k3.dtsi         | 22 ++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
index 37627963a649..3251ee8405de 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
@@ -220,3 +220,7 @@ &uart0 {
 	pinctrl-0 = <&uart0_0_cfg>;
 	status = "okay";
 };
+
+&ufshc {
+	status = "okay";
+};
diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index b084a35aa00e..6369602e81da 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -307,6 +307,10 @@ &uart0 {
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
index c3f2dce0969c..436e98f1a17b 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -513,6 +513,28 @@ usb2_phy: phy@c0a20000 {
 			status = "disabled";
 		};
 
+		ufshc: ufshc@c0e00000 {
+			compatible = "spacemit,k3-ufshc";
+			reg = <0x0 0xc0e00000 0x0 0x40000>;
+			clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
+				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+			clock-names = "axi", "ref";
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

