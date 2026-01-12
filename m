Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1E235B139
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226006; cv=none; b=J8ws/afFB5agFNLVSiixLumnZzMYl0oC1jTn2KL9DgzHOr6yYersFo3TiU9AJloiG4pTREwILhNob0YvZBaYUK4vnhDZn3baW9h8PqyYjC74ktF6cvGYp70hwIub8Bj7ypsCxvK3J1PeL7EUtc5cUjHhXY+OyyvkdoUCS0BsJyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226006; c=relaxed/simple;
	bh=CUg9RtlgmTKAudwK4F/5CcUGQgOlVJhlba1HTU9ItqQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CaR689af2CJ1qKZUXwG+XCKJ1O/PV0G/ra7ExKD5VeKL+QcUjwO772ZXu0x2bbSS4OcAHaQlB/CL4zatyu55avHGb8Fzx53PliLxkbkSCKD1CX4i5N3CjRn/MUAN6Y5tMTwaYwAP/YwR1EE9u4qHMDuOyiMqavYNVMZXzJwJHn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=xbrejhcD; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="xbrejhcD"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b87108066c3so164930066b.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 05:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768226001; x=1768830801; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WWPfLmZoRs9e9HhXu15SJ7NQdaAV3N8zf0i6m2MJpE0=;
        b=xbrejhcD0L9yC++GyaS5RgDRRI2zQPXMPkf6PFm9Cw/Vcs38dchwBUhTMXTGpiXWLF
         qAz76gIoiErdd1tGWbT4dK9el/ficVB5TzbuahmnOXveK/yvrJ/o6MgYNz5/XklBl4Nw
         vS2XJj99I2Mad20VHsSX6KTZUwBNBzzBz1heb8RuLuTHu7JrlVbyUeeh9QHinMNKHBSh
         OqAw7T3wZ4RdGtYe4ETgES3Avf65256BPMF9sKWaoRYxItM6zaWyvHjeJ7sdJ4p3evdy
         MbWSGQCUqqzMJv2GFC/SKiyWnT2C8CdRsgvIYhqU/owykoxxHUSdiX9yZS6psLqBY2Ej
         jTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768226001; x=1768830801;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WWPfLmZoRs9e9HhXu15SJ7NQdaAV3N8zf0i6m2MJpE0=;
        b=eThQQVBcxTGKYDX3JzGADEbq+i2EmbV0rGMFxwRZXlNEDmb6drPaShDqgSjOR1rNzx
         G9i9Pr8eePlNH6CYcFxtZ2dnNhxBz8UOx3VgIMth8Vv8KYI0L9jXT7ku8fK/KCh2mdxx
         lzfmrx4cA39qKJXqo/lueMw+hq4Fsz+63zjJtnNrVcxM7g3LGdzITiw6boc9deGxZ7iV
         2Hcs/Wo/Mm4pcWpsvoX5fjRKf0f/48DltHfMSz6iBL2eem3X+MTpkgznAyppJeYwVXd5
         zU7z5ALOJDT4p4f87GCc0eIsNzgvt2QqP7v4r51as8h6mUcgyA1SmoZ3qbbZ0sobcckR
         8ftQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKxAo4byK8vW6AA/WYPz/8Y4dO0ciI2r325DVaBwhaVATL6KSIyK61Xgs/8J+mmQkXsAkREi0Z20vK@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3YTcYD5HrLhpTkyB69ZcOjljr9q+g5V5JZUazVI4Zvymq4Bi+
	T5c3HtJDEPKZY8K88+Ae2cxsFHep9N6Pea43+lRUE8LTgEULnDNChubrlZYFx62Omho=
X-Gm-Gg: AY/fxX5N4EtxwgR3guPpuJyaWKy+fx2KLzDjvAuPvTk7Xmpk9O4EhOuCUIpF10SGFBG
	g6ev/lEm7Xh+qzzG/EM+ZfsckQM52EusfsYUWQBprQH/ejSbkhTxckVG+bCytN7bZYOfeIl4sZm
	VNguy53eZTHTkltZppcO+CJrNW3BY0roKV7gXgdXngE8NJ7tYs+aUWG+OfRRFmtRc84nhUIxrZ+
	fThVzBrLqDNl92V94kiUD3gNsHMssNIbMKYIYThjoDnZ155P7GtVcDXXKm5diXfPH9v5pJQmJ5H
	UE9qcvZa9qUYhTY6+CQs/Ukx0kVNd2IKexTvCo2qX9/lq8VNoEZMOIJ0LD/CpQygpoKknGdM2xf
	UPTr/7w+/KSsYMGy+B7B+p2Cwzkqh+VhKxmzcK30zM1IzsIYxm3ZnHWITuYb9A+lXQjdxDW1Gpt
	/gpAiAj6LdMcmcrEOINaf5ZGmn0+h9appNZul4BfKiV6eLFz2zch4Iqhpk6Nmno9MV
X-Google-Smtp-Source: AGHT+IHo/SgZTpXi092MWQdzw3Mh3q7aWX3FCIQ5HQG66gZ3V+BycBgpDyYQd2eNtV28CNmM83lI4g==
X-Received: by 2002:a17:907:96aa:b0:b87:2f29:2062 with SMTP id a640c23a62f3a-b872f2938fcmr90697166b.19.1768226001088;
        Mon, 12 Jan 2026 05:53:21 -0800 (PST)
Received: from [172.16.240.99] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8731f071e4sm25700466b.66.2026.01.12.05.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:53:20 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Mon, 12 Jan 2026 14:53:18 +0100
Subject: [PATCH v2 5/6] arm64: dts: qcom: milos: Add UFS nodes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-milos-ufs-v2-5-d3ce4f61f030@fairphone.com>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
In-Reply-To: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768225995; l=4488;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=CUg9RtlgmTKAudwK4F/5CcUGQgOlVJhlba1HTU9ItqQ=;
 b=RQ6deTnI/3+rRHNUFcgGtLLU70SWfA3Fva/Z/K6kIe2KRwZzfV7I7f+oKi4y6aUHbF+0iGjQt
 1ESFhFt+hz7CwwvzsLsu5vweg2wkRqD6PkYnTLcNYGAyK7sMIPomtAx
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add the nodes for the UFS PHY and UFS host controller, along with the
ICE used for UFS.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 129 +++++++++++++++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index e1a51d43943f..7c8a84bfaee1 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -797,9 +797,9 @@ gcc: clock-controller@100000 {
 				 <&sleep_clk>,
 				 <0>, /* pcie_0_pipe_clk */
 				 <0>, /* pcie_1_pipe_clk */
-				 <0>, /* ufs_phy_rx_symbol_0_clk */
-				 <0>, /* ufs_phy_rx_symbol_1_clk */
-				 <0>, /* ufs_phy_tx_symbol_0_clk */
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>,
 				 <0>; /* usb3_phy_wrapper_gcc_usb30_pipe_clk */
 
 			#clock-cells = <1>;
@@ -1151,6 +1151,129 @@ aggre2_noc: interconnect@1700000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
+		ufs_mem_phy: phy@1d80000 {
+			compatible = "qcom,milos-qmp-ufs-phy";
+			reg = <0x0 0x01d80000 0x0 0x2000>;
+
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 <&tcsr TCSR_UFS_CLKREF_EN>;
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
+
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+
+			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
+
+			#clock-cells = <1>;
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		ufs_mem_hc: ufshc@1d84000 {
+			compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
+			reg = <0x0 0x01d84000 0x0 0x3000>;
+
+			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
+
+			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>,
+				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+				 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
+				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+			clock-names = "core_clk",
+				      "bus_aggr_clk",
+				      "iface_clk",
+				      "core_clk_unipro",
+				      "ref_clk",
+				      "tx_lane0_sync_clk",
+				      "rx_lane0_sync_clk",
+				      "rx_lane1_sync_clk";
+
+			resets = <&gcc GCC_UFS_PHY_BCR>;
+			reset-names = "rst";
+
+			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &cnoc_cfg SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "ufs-ddr",
+					     "cpu-ufs";
+
+			power-domains = <&gcc UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			operating-points-v2 = <&ufs_opp_table>;
+
+			iommus = <&apps_smmu 0x60 0>;
+
+			dma-coherent;
+
+			lanes-per-direction = <2>;
+			qcom,ice = <&ice>;
+
+			phys = <&ufs_mem_phy>;
+			phy-names = "ufsphy";
+
+			#reset-cells = <1>;
+
+			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <75000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <300000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
+		};
+
+		ice: crypto@1d88000 {
+			compatible = "qcom,milos-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x01d88000 0x0 0x18000>;
+
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.52.0

