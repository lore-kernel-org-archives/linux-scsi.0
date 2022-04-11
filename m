Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEB7C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 15:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348221AbiDKPqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348178AbiDKPqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 11:46:24 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699AB624C
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 08:44:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l7so26320934ejn.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbNpbkkEChotn+zfIrEUISzZtq6Ebit9E8w1dEveKi4=;
        b=aYr0ukfkZGIsCt/4FT/QKR69G8IU6TdAGT0VhxtNMxD/ZM2av3R60rfzy0Lr+z2jqX
         RNffGh7JAzN/ky5V6U8TCJAnWdy3iGs3KhP04uuK3EugGOnpLwwcGZ2fTIgLFM56bQaF
         tbuWxvmlORJFEJxu81ME/WoTRcDnrFtKZ4M8HuZecRxEPgqPKITFt+ju1BeHb2YcHKUa
         iR8iLpWXca6o/Mwk8EvwYFqlUBxH0JRF0IUfHs1g6bPNU08wkfwWhQOP7w/whgOjQjfI
         YX1kzMwC0NEyR+1iPz3swS1o1S5TWeDzVAip9VKO1Jfd+vnYpKHzQSkH5s+HiHLRM0Jw
         MFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbNpbkkEChotn+zfIrEUISzZtq6Ebit9E8w1dEveKi4=;
        b=ncIQGmi9TcYAOBj9324ZUCLeoDX+Shpm7Uk3nU5hV0HOfxrFaj6LJdJW470EJJEZLn
         XlT66wqZ52gapu65u1xRgo8TRnef1DEHzP/014OrkazKjpPRexw5RmNkpuSEiqO7DQWn
         DI+Ym3AWSUUjeWUGtLpgscuOubmbs7gsWZ8+xKXXOrH5NbEfO24k3WLX8Faja0cT/4V4
         8p4tTqnMjbOCeamZGqs8NvF5xLYkZFC8oqF66YippMvClY2sLlTSBxunpIx29Z1IUCt1
         +bfkV4YcSRMTia6bmfeWA24XSR4z7zHjjsT7cEL7a8fuESqnRkQqe1KIbuXUbWItCIaA
         xxlQ==
X-Gm-Message-State: AOAM533UVStIBkq/arDu2L9Nx95UKecDW3EpBBt73+mTfZmc89xyrzFG
        2YpekXX7Z5chr4d8/Z0gQEy9Lw==
X-Google-Smtp-Source: ABdhPJwrK+vLq5FHXsKcsbi/1tugMQSwYKotl7aV7TAwegLV/VGDWOX0mMt4H3we7pNjfWm9PA2Pzg==
X-Received: by 2002:a17:906:d108:b0:6e8:7765:a70b with SMTP id b8-20020a170906d10800b006e87765a70bmr8961267ejz.436.1649691847786;
        Mon, 11 Apr 2022 08:44:07 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm12173177ejj.74.2022.04.11.08.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:44:07 -0700 (PDT)
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
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RFC PATCH v2 3/6] dt-bindings: ufs: common: add OPP table
Date:   Mon, 11 Apr 2022 17:43:44 +0200
Message-Id: <20220411154347.491396-4-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
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

---

Not adding Rob's review tag because patch changed significantly.
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

