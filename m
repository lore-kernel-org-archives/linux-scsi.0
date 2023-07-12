Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC9EEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjGLK5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjGLK5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:57:22 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1360519B
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:57:22 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6682909acadso3797907b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159441; x=1691751441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=XaN+I/hkvd3QzA25nZ6WowbgECymtQYUL0zIvSOgjdA=;
        b=SJIrFXQr485OvyST/wnvhHrXs0g+aklQEYTwcKnrKcCsQSCrLGp59fV0q16hBtPtl1
         w+AxZ1UHlwdLaWsreqJwKgU92RIlLVmX2uU2i1ri+IDE47O6sWDi4gjbqpxmVL9Rkkj+
         Ezhd2v2/cFKHwQSfxS4ffw8br8R1pmakVqLEEaQ2Ry4OYMmZ+ssqoaEUUeGU9/yqLNE1
         Yqj8Cb3jO6kTiS87HMybsQpd+pM7uwGzXHZ9ZMyfSMeVrd0IpvjK6qDPU2uTVkHrqxFo
         GfzmOzZ8HKZfp91Z4MsPbq1EEI2N2/PoULA+flQh999bZpSSv2JZSMnVCax2RwCLICCh
         vD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159441; x=1691751441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XaN+I/hkvd3QzA25nZ6WowbgECymtQYUL0zIvSOgjdA=;
        b=hzAVE3j9Yb3X73X6tigrea/4OI8Sd/e8omrko36NrViFMdaXhN+lT3Pym0RTmVt1WX
         0ZoHgjQOV9D7e1PPdvO5MHSeO/4pvBEGHg34l25mtdY734MTXdjd5XhAvMp3GfwK3xwy
         vYyVWIvixBKp/7SsCQ3sKj4X1ygC7ybhz8fL+yaZShvK78B+7VU5xdiW6NS+UeTtMrTI
         55pQClRfz0DQDDxC4iyBFjZF1+37my93/5XddA8oJCS9YsLtlErQG9WujBXWbxN4evdX
         IfBP5KH152Oj8A9IQ69NqfmZU8rMaZXN25uKhNeR4jrQC6ukx9TLABhX/tzRBoybJbjj
         czAg==
X-Gm-Message-State: ABy/qLbq/8gkMuf/2kZ8UIoELC1jpWyEkjFjZJ5HR8cvMsndJaGm/bpy
        DOLX7IXnkTFUHHRXw6iSFjjj
X-Google-Smtp-Source: APBJJlGMPs507H4wiKDCiebQX/M/RFpJybEnVbebhySjnSsNj0zT/xEwfbX7tC5WoiX9jQFxAYI69g==
X-Received: by 2002:a05:6a21:3d8b:b0:132:c07c:f042 with SMTP id bj11-20020a056a213d8b00b00132c07cf042mr1123979pzc.15.1689159441504;
        Wed, 12 Jul 2023 03:57:21 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id g23-20020aa78757000000b0067a1f4f4f7dsm3315637pfo.169.2023.07.12.03.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:57:21 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:35:29 -0700 (PDT)
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
Subject: [PATCH 12/14] arm64: dts: qcom: sdm845: Add interconnect paths to UFSHC
Date:   Wed, 12 Jul 2023 16:02:09 +0530
Message-Id: <20230712103213.101770-15-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: KHyfq6rY8hKF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS host controller requires interconnect path configuration for proper
working. So let's specify them for SDM845 SoC.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index e04a3cbb1017..2ea6eb44953e 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2607,6 +2607,11 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 
 			operating-points-v2 = <&ufs_opp_table>;
+
+			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mem_noc SLAVE_EBI1 0>,
+					<&gladiator_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
+			interconnect-names = "ufs-ddr", "cpu-ufs";
+
 			status = "disabled";
 
 			ufs_opp_table: opp-table {
-- 
2.25.1

