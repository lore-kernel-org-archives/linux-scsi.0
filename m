Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF1AEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjGLKxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjGLKxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:53:21 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC56173C
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:53:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-666e916b880so3365363b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159197; x=1691751197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=w6D9impE6kDqR+MOUS2gWXvCWxf9bLcZG7WLF2GZCOw=;
        b=CW0mC38lmavwAGAyc/ESd3ZAvGb9MyUHXehFBz4rU5U1hxDszMgWWWLPctcnZoxpxx
         VuynJXhT/OZg3rrvu3oZ5FCqApp3u0gWasJ93kS8jrrZtvCY5slbjErJTUfGhJ4QMvgO
         wb3zSS/dwTaYi878QR3VidsJBRrbIVvXUQ8Mu9SpMQ9uodDaqVRo3B4DVpINntY0Ob0L
         1pi7X/eKeyzZD0ywgXCIIsufF0UlBQ8Z2rQtVsrkbQVwaz4FOVeQd/lShGnm7lQMJLl5
         pog1iaymA/89GoSjfKQhiC47DWXbOvlUHOb42x+BdAq/BmActAC1aRLSMC82/JV1z/OW
         kPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159197; x=1691751197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6D9impE6kDqR+MOUS2gWXvCWxf9bLcZG7WLF2GZCOw=;
        b=Up+UvWqYwVMMwe064W1LF+lvDLTd/fwuu3Va5plpFEB79E04a+KzMlIaM0xhe73peZ
         6txUCWXVEhYrAR1n1VPyulFmLd+JItbzpALy2PdrW5RrKaQ7wFIQYHRGaG6NHR3Knc76
         D6NJbKZybkK7MsXPUiRL+p3MTn/Vu5DGn2FFWAhypN9a3TejbnxOAg70TXBC1VqUU1zU
         WsxxY1fluk9ameTK/ulAkfDprN14S/yTvLUXSIotpyvZnlR4Q0s+YkDwYwjv1LUHUD+a
         5qm9FUV3ajeBLLjw4+UPw2tPQv+25j2gsFsb7Ih/lZKGp+pqspAaEvqrtxcaKAEw3OdF
         eToA==
X-Gm-Message-State: ABy/qLaCrxga1yoHz80RABbrA+oVSYXxNVv82L13UHn0Py2g3ZePKy7X
        ddIGP/KV7gRy/c+Y5XM28pIX
X-Google-Smtp-Source: APBJJlEPoQIOUE4bc/u5pCZgFN41MTqgIC1ISonXCqIZR4RPEjaq3+Maop0Xgx9r0AoraFAfBJyT/g==
X-Received: by 2002:a05:6a20:3d10:b0:130:bdc8:2294 with SMTP id y16-20020a056a203d1000b00130bdc82294mr13611035pzi.17.1689159197417;
        Wed, 12 Jul 2023 03:53:17 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id bc1-20020a170902930100b001b3fb2f0296sm3651859plb.120.2023.07.12.03.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:53:17 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:33:13 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 03/14] arm64: dts: qcom: sdm845: Add missing RPMh power domain to GCC
Date:   Wed, 12 Jul 2023 16:01:58 +0530
Message-Id: <20230712103213.101770-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: 1AsetsiCBkgR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

GCC and it's GDSCs are under the RPMh CX power domain. So let's add the
missing RPMh power domain to the GCC node.

Fixes: 6d4cf750d03a ("arm64: dts: sdm845: Add minimal dts/dtsi files for sdm845 SoC and MTP")
Co-developed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 02a6ea0b8b2c..9ed74bf72d05 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1207,6 +1207,7 @@ gcc: clock-controller@100000 {
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
+			power-domains = <&rpmhpd SDM845_CX>;
 		};
 
 		qfprom@784000 {
-- 
2.25.1

