Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CC4C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 10:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiKQKwa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 05:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239427AbiKQKwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 05:52:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421D817046
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 02:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668682231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gjXLVyb6zwFPJe/OWlCp49ZVjP/sJNSDFeUY35Ol3A8=;
        b=W6q/bekgWbQSZm44C3hxfB2kt2AUHmuMcmOXoSSFzC2B5nbXPVlzQVmMSQYIJ+gX3O6+bL
        R/FLtYkf6FqHS9l3QpGYHHYiDdAahW1uHpwHjhTl1CwoqXdrjEdqUI5iQY9P+C2LypVg7/
        pCx7EFofAHyrq71FVD34Sinj4LZPFkM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-575-I6EeI8wKP7W24Xn1pBWg2Q-1; Thu, 17 Nov 2022 05:50:30 -0500
X-MC-Unique: I6EeI8wKP7W24Xn1pBWg2Q-1
Received: by mail-qk1-f200.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so1735422qkn.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 02:50:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjXLVyb6zwFPJe/OWlCp49ZVjP/sJNSDFeUY35Ol3A8=;
        b=PqcG1K4cyMAgbuULTOoKRayJMmzYXI2m/dSb3zX7IS/FEFaoG4H++gNx0QEAdWREMT
         SLwzdozEhhpIaJ3DnjAN+LaabOe94tkHWOKB9rS9xiMrVyiEUsDGWBDuvGaWUqsXZd/c
         bMzrWye97tXX84IvKcHgzVW8k6SR7YTRUyVa/00kXaqU2UxDW7WNrvznVCS9Fx2Qg0zE
         miDpbs2IPvPdftYTjGPKL2BeT0IckJNb9cDgclWtbCDfxqNCx2VDYfov92+lBplBh8dS
         ppQzr996YCq3A3Ux2YfkXnNPu3zbMsFT9xGmsY6oKSlqUww0N9IF1ZZ5J0A5/zJD5cvF
         Q+0g==
X-Gm-Message-State: ANoB5pk0MIC219L3JOrD+iXhO+mXMxJfE+usksOI48EKaE9yWebnFUhK
        VYUfE4yKLVR1AnIjy8jVU6yYRyUsxoydE5Bn2ykJQ5dPKUcWgJNnf8JoM3JIKOco42TJnY/F0wM
        y33PTEYiMzZjn+YVhDPDv7A==
X-Received: by 2002:a37:5fc2:0:b0:6fa:9812:42f2 with SMTP id t185-20020a375fc2000000b006fa981242f2mr1057172qkb.754.1668682229905;
        Thu, 17 Nov 2022 02:50:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4RXZjMGaetDJxgafbFUWe5YQR5qu294zU1xPcswkZUjgobAH+kXp2W1odUKDMEVqvGYKrhTw==
X-Received: by 2002:a37:5fc2:0:b0:6fa:9812:42f2 with SMTP id t185-20020a375fc2000000b006fa981242f2mr1057156qkb.754.1668682229703;
        Thu, 17 Nov 2022 02:50:29 -0800 (PST)
Received: from x1.redhat.com (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a248f00b006fa9d101775sm236022qkn.33.2022.11.17.02.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 02:50:29 -0800 (PST)
From:   Brian Masney <bmasney@redhat.com>
To:     andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: qcom: sc8280xp: add interconnect properties to ufs nodes
Date:   Thu, 17 Nov 2022 05:49:57 -0500
Message-Id: <20221117104957.254648-3-bmasney@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117104957.254648-1-bmasney@redhat.com>
References: <20221117104957.254648-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the missing interconnects and interconnect-names properties to the
ufs_mem_hc and ufs_card_hc nodes.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 6bc12e507d21..17c8dc8d4767 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -856,6 +856,10 @@ ufs_mem_hc: ufs@1d84000 {
 
 			iommus = <&apps_smmu 0xe0 0x0>;
 
+			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mc_virt SLAVE_EBI1 0>,
+			                <&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
+			interconnect-names = "ufs-ddr", "cpu-ufs";
+
 			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_UFS_PHY_AHB_CLK>,
@@ -924,6 +928,10 @@ ufs_card_hc: ufs@1da4000 {
 
 			iommus = <&apps_smmu 0x4a0 0x0>;
 
+			interconnects = <&aggre2_noc MASTER_UFS_CARD 0 &mc_virt SLAVE_EBI1 0>,
+			                <&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_CARD_CFG 0>;
+			interconnect-names = "ufs-ddr", "cpu-ufs";
+
 			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_UFS_CARD_AHB_CLK>,
-- 
2.38.1

