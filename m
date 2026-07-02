Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1222F30C176;
	Thu,  2 Jul 2026 02:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782959538; cv=none; b=ltdK4EQ2cay2GRismZUa+WsG27gYGKk+0DiTCHg5kXz7R4C73AoB58DWhmYUY++tk59i+loyqS6TtUCwGC8DesxuU+esG8+4sFk9h54VHmuzMYscKavzNWBu0Hk67yaT4+WfgeXKQkBVTXogWZ7Tau+eWwyGvrMuRKwmDsnri7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782959538; c=relaxed/simple;
	bh=umn98I1DXmAMjrQ1TLwM14+BWqYWOVozRg/TMara5lQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UIYhQvMCXFsR9wwIHtiKuuOCtLNKHveehrBPN5NBPo9ZrxJRyBhl6otHrOxor9tCVRZAssfvaf2RR04BPKg62/jw8GVZcXFjy6yHDy0M22WKQ+AqzKA9FbpzC4+yAQcrwYjT6eohvob2xaijCxRSmny5dMlf2JH2lkaGqW0hEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8eR/NQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8eR/NQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F7A1F00A3E;
	Thu,  2 Jul 2026 02:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782959536;
	bh=emOkDmfG2STZLaSMkvxawB0ay9hEQME3tZW+Xh2U1o0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F8eR/NQJbBbyOWi84JCbK67dKVIqwbSwQVy63Secmnp9j6bvny6tIEAGPxi5YTZdz
	 h+sWl9JO+xDeBnEIWJj7NlB95s5Dw+zo8JSatzZTBC9KYVQuCGmjYI2H282YTORE+6
	 Rf8TkiQblKyAhNGq1rdduIdEnO5t6lHil2lDcPO6VTDioJmGnSIgQ3ZNhLa+4dB4JU
	 fJFn2QGgDfc1s65ItP5r/tpn3q/YhzpzQ83zR6v5rSBDkxauukBiiw+RkpUjQzcdT9
	 yA3cb9vZxE3SGSQ6aHgohUuMGWcfpbhcIWv9c/zj4ezN8QhedpgzEXwS/ChtkOTct2
	 0+SZL2+Lk418w==
From: Yixun Lan <dlan@kernel.org>
Date: Thu, 02 Jul 2026 02:31:37 +0000
Subject: [PATCH 3/3] riscv: dts: spacemit: k3: Add UFS support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-08-k3-ufs-support-v1-3-1a64a3ab128f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1958; i=dlan@kernel.org;
 h=from:subject:message-id; bh=umn98I1DXmAMjrQ1TLwM14+BWqYWOVozRg/TMara5lQ=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqRc2awHZ2ozwoZE1YwXu2hLobFcHw29ROvi3BP
 BgYHyjrBXOJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCakXNmhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+1dog//VswC+e+1V9gsErZaaIJb00liG5Li36yDIYzoVmd1oJ1/OwFI1iYEA
 fjS2uXEjkXQckX5WjxVVPjade78H0kpKk/0fCEMby5/d9l5jMXFIB3g/uzwIfFXzWRG4BUsHiCJ
 +Xzt/bNWmGeSNYmhbb/5KAmfK4loF+zOfJOCQcBiCHYCDQ1Sf79dIcTs7Qx9z9+Im2f0Vii45h2
 stnoYIgO5nqF58lai2HHnAAqRWQWkDoy0dg+f0xEmsvte+FZAkfcX1osMBcdO3IAKnPTJHSntlA
 zb69/+JXa+d8gVR98P0RZE8wJ87qY6uU+Z4oVOwx8B+/vHN4jzglmvwsQdtXUBHRTPsI7+r2mLZ
 TNsYPFGHsjqEE+p8bXfUI6T2/fuET1aEhDyD4AmAlkUpJcqjHMEMSfQDObNlk07XFpwxuCG231D
 fM0DaH8x+8z1fbL89K8YblIq+w5LTdEE/bZodwlo7oNHfjn8TTukeZrkx9GYsPGAZwnLp9Hb4gq
 pAVzB11apYEQF7n2XzpMfHuq6JyaEGoD5iVSLCNBGvV3gx7WbwNLHqQF4lg9SD+dcqV8qNobVzG
 a2/qdT60NoJaKr7ZWDyTEa8A2KK1AQlD3Z7ywtSDxwEIxwCn/6mUel5O+GTDM+Er7FT07YFMJ1Z
 YakhxHWtKm7cE+ppgYOMbePsvqUWcw=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

Add UFS Host Controller support for SpacemiT K3 SoC, and enable
it both on both Pico-ITX and CoM260-IFX boards.

Signed-off-by: Yixun Lan <dlan@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts |  4 ++++
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts   |  4 ++++
 arch/riscv/boot/dts/spacemit/k3.dtsi           | 13 +++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
index 238bb03d0e9e..b37e1c7b03e3 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
@@ -19,3 +19,7 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 };
+
+&ufshc {
+	status = "okay";
+};
diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index b89c1521e664..f1560a5a9031 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -221,3 +221,7 @@ hub@1 {
 &usb2_phy {
 	status = "okay";
 };
+
+&ufshc {
+	status = "okay";
+};
diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index 19fc9b49668e..6c0b0598d5c8 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -1186,5 +1186,18 @@ maplic: interrupt-controller@f1800000 {
 			riscv,num-sources = <512>;
 			status = "reserved";
 		};
+
+		ufshc: ufshc@c0e00000 {
+			compatible = "spacemit,k3-ufshc";
+			reg = <0x0 0xc0e00000 0x0 0x40000>;
+			clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
+				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+			clock-names = "aclk", "ref_clk";
+			resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+			interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
+			freq-table-hz = <491520000 491520000 19200000 19200000>;
+			lanes-per-direction = <2>;
+			status = "disabled";
+		};
 	};
 };

-- 
2.54.0

