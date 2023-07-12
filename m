Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DEDEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjGLKx4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjGLKxy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:53:54 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77BE1986
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:53:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-666e5f0d60bso4005523b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159233; x=1691751233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=7R3B8EY4EOyQ9QJJeQXVuUhZWY60knY6YNAPx/POrbU=;
        b=A50DSGwVduIhnXISXxoyvEeL/0oWjmLGhYouWKuYcS3AsO9Ht7CUyLqc6BvGB+zsqf
         u9fGePsD++NWgfQCbZozQt0QZeTEqlnNxH3jrD3SuqnparDy+aMxtew0ehKqX14aP3lJ
         6/4af2w4ThO/nQX3ZrzFl6MQ1mOQEziDBdgChoXWO7lPrcdz7EPwa4SdFsaa7gNpIcfy
         HFvzRrOA4R0ZQeq8bnr5O+uQDsvWE3vQjx7vYiLvh5cEpZMSwOliXwsrrRfwqVmtvqHE
         ezrXFKyTS0ySXMjBa/4FbNVZoHxraBKhxTDiCSJuCLIcrwYjf3DOxW/MbaldJghgqmPL
         SzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159233; x=1691751233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7R3B8EY4EOyQ9QJJeQXVuUhZWY60knY6YNAPx/POrbU=;
        b=krjH1dHio2BO9t+9/BElMP0ZBktKoLlwZfkh8m6VDk2wi7jr23Zpw8Eg9V1xTfFZeR
         XeDi1F7m3Ekc9bT20i4n9m5j0cGYYESU+t2D3x9HD0MGa0rxiNwnQL0yuEdvTSaNVapt
         LmkqU2OcL2dmQa03yBkE6DAthmq1tUfC5xCVUqf2+CBK/bM9T+UTH+NTCwhde98Cy1FP
         D4GxMld+T4ihLT7iBE8y8tpkuKkX0nOAlbScD/Mwr2QbVFZtG76wm6P/+HiJf2KP/w5j
         fOwkBDqyi4Eedxy7f1jqNUFRwp7C8qCEMWG1Ws9S73twWx2YPvSSKWeERZCpWVKIpJeJ
         Fs8w==
X-Gm-Message-State: ABy/qLYhifQ1kd0aHjqzuxFM5vXEhDtAfvt48WNosTQN5VG8KoCi8aPB
        s8A8hhqirsenoI7FZImCnkZ+
X-Google-Smtp-Source: APBJJlGraezrqQb9gJw1KuNnhKyK7zRrpK5rrr86wdm1KtvhtZLzpuCA6cxV2w492Xo4FyqMqdRYig==
X-Received: by 2002:a05:6a00:1593:b0:65e:ec60:b019 with SMTP id u19-20020a056a00159300b0065eec60b019mr17309298pfk.25.1689159233275;
        Wed, 12 Jul 2023 03:53:53 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id g5-20020aa78745000000b00682af93093dsm3343969pfo.45.2023.07.12.03.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:53:53 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:33:25 -0700 (PDT)
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
Subject: [PATCH 04/14] arm64: dts: qcom: sdm845: Fix the min frequency of "ice_core_clk"
Date:   Wed, 12 Jul 2023 16:01:59 +0530
Message-Id: <20230712103213.101770-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: z76KvsIeYMmA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Minimum frequency of the "ice_core_clk" should be 75MHz as specified in the
downstream vendor devicetree. So fix it!

https://git.codelinaro.org/clo/la/kernel/msm-4.9/-/blob/LA.UM.7.3.r1-09300-sdm845.0/arch/arm64/boot/dts/qcom/sdm845.dtsi

Fixes: cc16687fbd74 ("arm64: dts: qcom: sdm845: add UFS controller")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 9ed74bf72d05..89520a9fe1e3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2614,7 +2614,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<0 300000000>;
+				<75000000 300000000>;
 
 			status = "disabled";
 		};
-- 
2.25.1

