Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67314C678DC
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 14:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjASOqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 09:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjASOqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 09:46:18 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6C58C922
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 06:43:35 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bk15so6195957ejb.9
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 06:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/SjsBNMpD4lZAQm70QlBxW7ORK3Yy/nXIpNP1UrfVfI=;
        b=RPWI3CM2kjPcSfl13sUQ7vn8lWKboXorxsiuNW+wn6crJkRE/ul1u0E/TTvKK/YTyz
         ErEE7x6dH0839U1IPasUeVBM54g+r0m7YdAmDMlq3obYdJ3vkxaoqWF2xXVaUT0IIRye
         NndvlOLutR2hSUSFdIAKwA9Qe4D1SZfJAlTA5C8ARAdPpVhniKdTmklzJb6+RiZ51UV1
         Qk9eQ9wMVQxrB0d/14AJOou2woLdZPzytgeets4hDlyZ84bkbC6cNxRArcxzC0K8FSDE
         gN4AxoPuZ1fJ2LvDqOOoP1c1tvsn/ulz1u5w9R+MsP/CZMToaQ0ls0IohvxYlNxBSvG2
         4GeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/SjsBNMpD4lZAQm70QlBxW7ORK3Yy/nXIpNP1UrfVfI=;
        b=ZRQL/UCLISGq515smK9ZUj2VCKeD/IFCMu5UPfPp3G3VZaupwaAdEmuOZuXNxbLyG1
         0Y74Sf4og+ZceLsX/5fXzWXFCPRvOJoDy2X0x60oamcOPsD/CGx+Ojd2KnOg1txfUozL
         XqIByFgYv6eESHWbyJKliGZSq3NrM6HdXztj5mWo1bTV7luD5PoBYxFR+0yjfcweWqp4
         fqLffadFhBfuK3SpdCNic7BRCimVGHe17qySrzdRUSsaIMgDgqDGjg5+NuCBx5u5uTHf
         Px+I1LeQ39BiXbxECsJLkEhPLQSTzn1ORBCWxFqayo4eaB91Tf591gOPAd3DDqym/XAJ
         XcgQ==
X-Gm-Message-State: AFqh2kqZX9lpgnFPP2+iYDGdWuIwl59PWF4Q22XmwkrPPF2sikP85it2
        WLrzwEcxwfIW/SbaILV8uWArWg==
X-Google-Smtp-Source: AMrXdXvFKWEUSD94XSs6bCoHqhRdPLttSrOIIiZQ0FY8j9hZ4PpgLaSGE8/M1Z9Y3wVkY1THHheeOA==
X-Received: by 2002:a17:907:9620:b0:871:2051:6377 with SMTP id gb32-20020a170907962000b0087120516377mr15201852ejc.60.1674139409664;
        Thu, 19 Jan 2023 06:43:29 -0800 (PST)
Received: from eriador.lan (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id fn4-20020a1709069d0400b0084d4b907ff8sm13434169ejc.120.2023.01.19.06.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 06:43:29 -0800 (PST)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: qcom: msm8996: enable UFS interconnects
Date:   Thu, 19 Jan 2023 16:43:26 +0200
Message-Id: <20230119144326.2492847-3-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119144326.2492847-1-dmitry.baryshkov@linaro.org>
References: <20230119144326.2492847-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Specify interconnects to be used by the UFS host controller.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 55180586f7b6..0c2f7be9f205 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2037,6 +2037,10 @@ ufshc: ufshc@624000 {
 				<0 0>,
 				<0 0>;
 
+			interconnects = <&a2noc MASTER_UFS &bimc SLAVE_EBI_CH0>,
+					<&bimc MASTER_AMPSS_M0 &cnoc SLAVE_UFS_CFG>;
+			interconnect-names = "ufs-ddr", "cpu-ufs";
+
 			lanes-per-direction = <1>;
 			#reset-cells = <1>;
 			status = "disabled";
-- 
2.39.0

