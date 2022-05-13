Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D64C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 May 2022 06:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377261AbiEMGOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 May 2022 02:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377217AbiEMGOS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2022 02:14:18 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64E926FA20
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 23:14:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j25so8987552wrc.9
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 23:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5QCjzQNVfIHTI2M93e76yaRYudMGDMABQBv/3THcrs0=;
        b=vYS6qMmJEZVFNULnMGiG3qsBGiCBybGyHh3F32mu4gPpUhpEKTMXB3gNlbkeTpK+Jj
         Pb1PByrmtrKmUCYDJxjKWvOADoYhS+ecZHjhbJgxims2cBAc3m3IPvin4c2Rr5JX9jbG
         fnHmkLvQwm9NOzay2YWyWOTZ4WCQa5mfTtqIvWC2GNXG2vmtqr91ds6Cb8b9noveYIIo
         CLQnKsoGKvHQa+kSFLgb00XcdQ6qxXUeuTHHoKG6RjorWj/swLRWQKFBOpUWOOv++3f+
         fpvUEQna6eVt8v33qsJKuh8VFQsKHQnnJUWwtjlC9fZh1h741IBejnMZgXz/SMusYNw5
         B9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QCjzQNVfIHTI2M93e76yaRYudMGDMABQBv/3THcrs0=;
        b=UneIn7uRYyINiT4fqxypYp7yS4ez0sDngi2PZ+u46HLVXqC0z5qSGyGBH2x1GppscB
         6k408r1ZMVDMwGt4cuTc32NkSyZIrMsXbziWAkrmjiC5ff+H9hu0TWCDXnwLuBv8dEZY
         YlZdV4PAYylU2npaRGXG9bD4dXGfdMSK4AcA2+JGDX5hyv5lPzAnFjbgWi32cpQgT0E2
         nBlgzR7+2VmG2tzJ6W871bcK1xKOngnYMXEymodydfJKaxesa38oAaM/LtHebOJ/MRBZ
         MJj8jOsXu6xZEfQI0OT/A7Ti8szMmZ9BTboSfBDmSBs5f21oAA5EszM7Jc/XH1z5Hoes
         KIUQ==
X-Gm-Message-State: AOAM531sC8UTUVynAkzroXGPKkj1JJcAJU+7VFCsrkvUCAnnEf/EwPaf
        nROSYTpvzOM+HTxSrdtgUbwHpw==
X-Google-Smtp-Source: ABdhPJyyIATyKjiRUxeid5jOjreYwVZ6wwH6YSUPZtqc4E+NEAssOgxzP1UL9k5cqWgrg0H/MOTBlg==
X-Received: by 2002:a5d:630d:0:b0:20a:e1a3:8018 with SMTP id i13-20020a5d630d000000b0020ae1a38018mr2429406wru.489.1652422455421;
        Thu, 12 May 2022 23:14:15 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id g4-20020adfbc84000000b0020c5253d8f3sm1477760wrh.63.2022.05.12.23.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 23:14:14 -0700 (PDT)
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
Subject: [PATCH v3 3/7] dt-bindings: ufs: common: add OPP table
Date:   Fri, 13 May 2022 08:13:43 +0200
Message-Id: <20220513061347.46480-4-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220513061347.46480-1-krzysztof.kozlowski@linaro.org>
References: <20220513061347.46480-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Except scaling UFS and bus clocks, it's necessary to scale also the
voltages of regulators or power domain performance state levels.  Adding
Operating Performance Points table allows to adjust power domain
performance state, depending on the UFS clock speed.

OPPv2 deprecates previous property limited to clock scaling:
freq-table-hz.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>

---

Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index 47a4e9e1a775..d7d2c8a136bb 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -20,11 +20,24 @@ properties:
       items:
         - description: Minimum frequency for given clock in Hz
         - description: Maximum frequency for given clock in Hz
+    deprecated: true
     description: |
+      Preferred is operating-points-v2.
+
       Array of <min max> operating frequencies in Hz stored in the same order
-      as the clocks property. If this property is not defined or a value in the
-      array is "0" then it is assumed that the frequency is set by the parent
-      clock or a fixed rate clock source.
+      as the clocks property. If either this property or operating-points-v2 is
+      not defined or a value in the array is "0" then it is assumed that the
+      frequency is set by the parent clock or a fixed rate clock source.
+
+  operating-points-v2:
+    description:
+      Preferred over freq-table-hz.
+      If present, each OPP must contain array of frequencies stored in the same
+      order for each clock.  If clock frequency in the array is "0" then it is
+      assumed that the frequency is set by the parent clock or a fixed rate
+      clock source.
+
+  opp-table: true
 
   interrupts:
     maxItems: 1
@@ -75,8 +88,23 @@ properties:
 
 dependencies:
   freq-table-hz: [ 'clocks' ]
+  operating-points-v2: [ 'clocks', 'clock-names' ]
 
 required:
   - interrupts
 
+allOf:
+  - if:
+      required:
+        - freq-table-hz
+    then:
+      properties:
+        operating-points-v2: false
+  - if:
+      required:
+        - operating-points-v2
+    then:
+      properties:
+        freq-table-hz: false
+
 additionalProperties: true
-- 
2.32.0

