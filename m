Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35F2EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjGLK6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjGLK6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:58:13 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E480D11D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:58:12 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-66767d628e2so4672278b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159492; x=1691751492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=aFjFH233scMmITorrcsknOFXDQIt6REL4AFr2F5rKyQ=;
        b=jrFTPMO89q0bgOzMSkYWHwKOcklTpq6EHXeJIhILsbJQ9xe3hEuJFNoSipPHZorO9T
         kB0yduqTA4sN7rMKpLPNLkZJOdVD9nZkmNEvQEqawtBWG3dASx0eR9XXj4un+ALJTOxV
         E2Qcr2CF3I4Cp6JZm5OpJTpJED0iB6cctXWxoGnXt7ZNrmfN2LlLg3FkCDUKc3S59dox
         BuILzk5e5McPAlBUm9oxiWsYvfPWVxiSYT//ZjsEOi+u1ev4dRaqUtLSfBJ8Hlg9VaC4
         vE43/P7Cdt8vFfBH3mjg3yneEPJvogivFuwjntoAEwOROZFzzjnUEE9q5PWitCr53F+u
         mQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159492; x=1691751492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFjFH233scMmITorrcsknOFXDQIt6REL4AFr2F5rKyQ=;
        b=ekJR4X9eXK3cMrDwvaasgrCKG7wXcp4L99qzIMnJRfSu2vQYzri8YurS2JR/FjUwWi
         Lt59d5CIH2NB+H6QOmdOo9BpGSKSMLazHrSKGwUVb/Tw53TqJREUEVdPFVcbkyNgVVQH
         r2r9YV6XZmwNYN02AanJQa35L+YB1BbSxDvzC6+8wjHB0Qgo+ASYPAxh5AHpkUph7bqD
         /YCCD1w0LP/893k4yfcajdhR/yR/P4PfMCoG4Fj33EISC8I4GZ2C27hqmY7BsvY02Gze
         TtC9eWaT9A5WhqYDdchnZMpCKR7NMAlZRl7a5IWcufuwq2tVtPsTOOugL0+SyilR67di
         HkHw==
X-Gm-Message-State: ABy/qLZNQ0c4co7GOYDrUkFnB0lNfTn6Ln87+hGqBO55yhQGShHtsAf4
        ptinzXjvvC4aOLtAQH7JrnXh
X-Google-Smtp-Source: APBJJlG0VcCY6DtV+bFkrKlIas9FCWT8IjD5A9MqvVmpEtWWXNmVzeNDE9F5k5AlAYIRvDUc8t5s/A==
X-Received: by 2002:a05:6a20:2584:b0:132:c7de:7e6c with SMTP id k4-20020a056a20258400b00132c7de7e6cmr1070115pzd.15.1689159492406;
        Wed, 12 Jul 2023 03:58:12 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id o17-20020a639211000000b00553ad4ae5e5sm3222130pgd.22.2023.07.12.03.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:58:12 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:35:52 -0700 (PDT)
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
Subject: [PATCH 13/14] arm64: dts: qcom: sm8250: Add interconnect paths to UFSHC
Date:   Wed, 12 Jul 2023 16:02:11 +0530
Message-Id: <20230712103213.101770-17-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: W5o19/1eF8im
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS host controller requires interconnect path configuration for proper
working. So let's specify them for SM8250 SoC.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 72fd66db9c51..7a495ff7512f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2197,6 +2197,10 @@ ufs_mem_hc: ufshc@1d84000 {
 
 			operating-points-v2 = <&ufs_opp_table>;
 
+			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mc_virt SLAVE_EBI_CH0 0>,
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
+			interconnect-names = "ufs-ddr", "cpu-ufs";
+
 			status = "disabled";
 
 			ufs_opp_table: opp-table {
-- 
2.25.1

