Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F3CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 May 2022 06:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377246AbiEMGO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 May 2022 02:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377201AbiEMGOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2022 02:14:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5032226FA01
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 23:14:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bg25so4194173wmb.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 23:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j60Q+m0nDVDVeq/kqo9om6jZKItdmd/25D1fiKUieoo=;
        b=RXdzPf6RIzYbLiWfscYfUw6T2WzdY+PgkUVapfUOjjVwymUsMjbC26PCR35K/9ros3
         NFCHpbJFnlIG89xtEy3Y8fJuHDs+f8y2VWtdjyFzlJNHqMWyxu/4TS0DPZBsmdXlvRfO
         gOLDtt3A/M8SMk1hz6AeH3bZfptUbnH8srkE0oGQgkPBc4uhxYckRGx+iphp7MkOWgBT
         Ebk/eV5bimzuyoo0GoKPNTzwrrxVsJuRM3lyE2FTid1oRakLXfLEAbUMBbZ6azdMuZck
         AT14UTj/IIsDlEaeXLMvp4YOFlzorgSQCY7QkLrxR7FJ5oZSqzKhgU4mKwztI8qW8DHA
         pRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j60Q+m0nDVDVeq/kqo9om6jZKItdmd/25D1fiKUieoo=;
        b=ZMUPlx7KhkjXswH3/NIWTmc7VXhTQWJ5LbRLm+ooHz8TaVhanO0FpgHsyCKaXRedKc
         1Ixw1Rtm0PgfNsAz51/eZ5tFlEwfbsIkt/Qcn0B3KfR6AltNvM7O6seuCyZu8/gNt6nU
         YOQUZuOomhXzYE7pY+34YLiVbn8fbmFTLESW6xEgWuKh0jODgUubYpurbyetcT0HxIJ/
         SkN+RLUGdouScd3ZSha5dMoqh/U+B7fqtAcG+bLz20tyon/zshnyURQWAEMCZRWNitrL
         KUrn42IW0jrPC8vDwcVGOD8WxTcpX+7O7rlH1MOBzAfDSXnQeUIuFVIAHo5JX968cJMo
         0Fdg==
X-Gm-Message-State: AOAM531P3PsacgAAbxuG6KDKQBzHk5nz5kQPwpSs2o1K2XSeX/vlsDvH
        qP7LXcXeEYx1D2NZHwYoSUWLwQ==
X-Google-Smtp-Source: ABdhPJxxiNFky+FKvagxgESN3eexGwvVdyb6o64BeUJIDlYUYHYzW412ZYFbVs0kakubT1n7lNKQ5A==
X-Received: by 2002:a1c:19c1:0:b0:393:a19f:8f95 with SMTP id 184-20020a1c19c1000000b00393a19f8f95mr2940751wmz.149.1652422451913;
        Thu, 12 May 2022 23:14:11 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id g4-20020adfbc84000000b0020c5253d8f3sm1477760wrh.63.2022.05.12.23.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 23:14:11 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 1/7] dt-bindings: clock: qcom,gcc-sdm845: add parent power domain
Date:   Fri, 13 May 2022 08:13:41 +0200
Message-Id: <20220513061347.46480-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220513061347.46480-1-krzysztof.kozlowski@linaro.org>
References: <20220513061347.46480-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow Qualcomm GCC to register its parent power domain (e.g. RPMHPD) to
properly pass performance state from children.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>

---

Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
index d902f137ab17..daf7906ebc40 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
@@ -43,6 +43,9 @@ properties:
   '#reset-cells':
     const: 1
 
+  power-domains:
+    maxItems: 1
+
   '#power-domain-cells':
     const: 1
 
-- 
2.32.0

