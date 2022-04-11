Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518A8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbiDKPqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 11:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348167AbiDKPqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 11:46:24 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33737271E
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 08:44:08 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k23so31736013ejd.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 08:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/VH4iXX/HSvKxY6FnWRf9tFEMBnPZdBMAJ6em5xnqg=;
        b=UGGTSUjSAL9NJgQLtybygrDJb4vXO3cNduQvPayzRK+bZW0CJAg/czgJYYpwUkCkz/
         g2sVarYA4gjU4dM3pX/7gZQJJV0Rf3mP673DCCsOSXT2a5wv0OR+lDBY9UIbgVk5fPEj
         Hmj11yCdw1n7nlh2Iptx3Bjw3oUf27qh5v2nVFKVdT/bcBzwz9jxxJMW1goeUwzgyVa6
         y8+HnYKi19tDgn18Vk6ieukuQVPeLbijXrNeTGVZNoCKcKPqFQbTUD3bGT/6AxqcrEyj
         n/nv/lqpTOcTxkcfHs6oaiA3R65VSov7sb/iBdypQzoO4eb+tGYdvmQt4gF5v0KXsvjD
         Grbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/VH4iXX/HSvKxY6FnWRf9tFEMBnPZdBMAJ6em5xnqg=;
        b=a1YujhWFjlsDKb9Ij1waN16TSIGbYmyzZt66GvwDwfooM5km+uOJdU6v+veI3U0zW3
         KYlTnUI1KVzoGEhTb2iQYigNbvMfYaYPnf6m7JpMaMqM5mCaXmbY2cH7v9gLSV3S7XIF
         wCScSvZMmStJfA9RZhY/vzDFcyplTtpqEc3Lb37acwrqH6BRFBAx5kWywFGNBnbMMqIR
         qMBl/gbgRkRW7OxqStjw/Kc4uFhj15g4CZzyPxk1MtkI+r3/dmzyOZ2+2ae6d4DVVbJm
         ON3TiILcwORIP8DkTIy3yElQ7OdodArLvKwHSDMMjtMoSAgqTVbAALSdNW6kAilZefLU
         B/lQ==
X-Gm-Message-State: AOAM531s4NYTU2VPZNJSjyeqOsoxeOW9Mf+6SsJwzg3B5x9mCDo1ajq7
        5HvVkbsJVTQ6R5JgKF2YVDMBug==
X-Google-Smtp-Source: ABdhPJyyTzBko5kSxEeXxWHuBtOf1c1YnoIFTwVmCQmEzWG+0S2JVR3bspyNTYSGSf/bPjPbl7Ff2Q==
X-Received: by 2002:a17:907:7ea3:b0:6e8:92eb:3dcc with SMTP id qb35-20020a1709077ea300b006e892eb3dccmr5019092ejc.75.1649691846674;
        Mon, 11 Apr 2022 08:44:06 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm12173177ejj.74.2022.04.11.08.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:44:06 -0700 (PDT)
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
Subject: [RFC PATCH v2 2/6] dt-bindings: opp: accept array of frequencies
Date:   Mon, 11 Apr 2022 17:43:43 +0200
Message-Id: <20220411154347.491396-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Devices might need to control several clocks when scaling the frequency
and voltage.  Allow passing array of clock frequencies, similarly to the
voltages.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/opp/opp-v2-base.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
index 76c8acd981b3..1d7216008f95 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
@@ -50,6 +50,14 @@ patternProperties:
           property to uniquely identify the OPP nodes exists. Devices like power
           domains must have another (implementation dependent) property.
 
+          This can be also an array of frequencies for each clock provided to the
+          device.  In such case value of 0 means the clock frequency should not
+          be configured for given clock.
+        minItems: 1
+        maxItems: 16
+        items:
+          maxItems: 1
+
       opp-microvolt:
         description: |
           Voltage for the OPP
-- 
2.32.0

