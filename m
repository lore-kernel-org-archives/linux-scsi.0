Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2475EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 05:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjGTFo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 01:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjGTFnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 01:43:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B8E30CD
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 22:43:07 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b8b2886364so2285185ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 22:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689831782; x=1690436582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1pcWt8K+FK2wfI9pVkhS/rPdimyJshB0C7q20l1ZU8=;
        b=hTbAwQGQvoq90ltUGcgpTFRLiSddOhNlJPqRcLxSBdobh+X4c2foZzFwy2AFMnyjvq
         rGQyQvDJjIeR4egbJW1hEkIjym5J5YlTD98zhwQwa1tnEIR7TNLtwgxsTz3yA3BFIfc1
         a9PI/UghB01jaNrMg+Tg1TkUgiipnA7xuRF7378lnCPJTB1fiMesfmFlMRRWcFJFoKKa
         1MxYCzwgA4IXrQ2fYLrMk5dkBFwJAFFKgFRpXmkRByrEAhO81roJnokfIUElhfsEq2/d
         s1C6/KmxyJmG40FragZ9iJQrGfx7oN4rhe6wyRFfAdWaqWYB5CwQQUEN4ZTyXGqFyDeB
         klnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689831782; x=1690436582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1pcWt8K+FK2wfI9pVkhS/rPdimyJshB0C7q20l1ZU8=;
        b=Ye/jjuJdpKmRqCagu4AYtrtWPGY1QkXKkoHbl0uLQkB235BMUIQ3OzHIQD6HpRXyjZ
         FKFOWcKHK+XH1l30Vb0Zak3/o1RhVRJMuBseUPXKParlRuGvDUI6wm6yVGn3HcaSW9bn
         IUgGiWPSh8RkXoQJukKz72Uh0DBwS+2LOUvx8ltgFdw9u95nl3anug8DaRLrwi7TBa6V
         hIn0aY3ui7GvGQGiaktwj8GbUSr2Z66U2AdxzPtsOXtfVGXF2mMBHc60SKthl2VgZ7eF
         1Zn1DJ8L3ofkStLNZ7ejpYklCE/s2GgCWWrgHSdrqukL+nG/tz1cs1hzF5p6A8MHSRs6
         qHww==
X-Gm-Message-State: ABy/qLZ9StrCPYpwReLwI3rHMJxv7mCzxqJf2ESjiJfTiLx6roEhpEjY
        O3/xxeXJG0nsl0I8DR0nhn9q
X-Google-Smtp-Source: APBJJlG55HVqVD8VAAuTNsFGHB2PljWCVRcl6DGWV6zErupcqmf2bXv/gJEjCi6phx01jKOIL7/bcw==
X-Received: by 2002:a17:902:eacb:b0:1b8:76d1:bdcf with SMTP id p11-20020a170902eacb00b001b876d1bdcfmr4001732pld.23.1689831782191;
        Wed, 19 Jul 2023 22:43:02 -0700 (PDT)
Received: from localhost.localdomain ([117.206.119.70])
        by smtp.gmail.com with ESMTPSA id r2-20020a170902be0200b001b85bb5fd77sm263367pls.119.2023.07.19.22.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 22:43:01 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 12/15] arm64: dts: qcom: sdm845: Add interconnect paths to UFSHC
Date:   Thu, 20 Jul 2023 11:10:57 +0530
Message-Id: <20230720054100.9940-13-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230720054100.9940-1-manivannan.sadhasivam@linaro.org>
References: <20230720054100.9940-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS host controller requires interconnect path configuration for proper
working. So let's specify them for SDM845 SoC.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
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

