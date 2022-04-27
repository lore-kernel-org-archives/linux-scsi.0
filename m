Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B92C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 06:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358486AbiD0HBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 03:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356295AbiD0HBT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 03:01:19 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40D518369
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 23:58:07 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id be20so803527edb.12
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 23:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocARHRASAyy5ekahF2LGjwlLKqc2XinQEkZtryZtbDg=;
        b=qdEAEjgJNuV9dtRj9apfVr6pewWgkwnSa880J5qM7FtcNLOWg+qr6CKXP1OKgi1NlH
         xHRnwe4EWAjW4wcd517OohN6aqWy8DL3GqFmJVZqzC/SNR5KbSP9DDLxx54fFbcVRAgF
         qwOVy8xv0LFKkl2NUQpgn5iSiippkxiBWSm9RBJABML8MvUn/xECJ6g7BQGlAvl/HifN
         A5+AqGfnx3bd3gizs+4HGtnkb0CaECJTZrnhEaRNO5a0UGUB+NRnrgbHTv7HN6hYu4r/
         t8ezU+0BgVAtm8aoHn7xZ9RBveUGzy0IydKBl2kiJYmhgbxxEp9YovyVL6nKRsu9Eqe2
         9tVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocARHRASAyy5ekahF2LGjwlLKqc2XinQEkZtryZtbDg=;
        b=7OgDOxYYQ+dJXoNnqLi7PrVydYqsLhczw8xf+h0Tc2u7gGr1ZNeLopZQvnccdtFuos
         RSNCI7yNYUu55THW4CIk3ltU7YaIl8+pJhOcxvLiR5cy0z6UP+MzOXgVyiqWQ+NMMn6X
         BQkUkO9ERxaLmGZ1qeoYeHwGf1eNzNXOuEmZJN+sXK6VBXDpFXIJn+aN5YC1l3y2jyvG
         S6hloiUtirbJBjLnXCh6CDG3EQtCfGWCL4gs1FpTexv54CRsbQKd+hSp7AYvYk1TUUZJ
         OHWxfF9PeqLC0KbQ7OHw8jTDns9tqpz39KhG3IBhesb8VSOCPUKSIJPCrZeKBnf+m6DU
         j8yg==
X-Gm-Message-State: AOAM532RX1dJG9PIoMHUQ6DIyr0m+nlwqSGPBkumeBxZGBKm4nbVd+QN
        YnxJAPj/qb32DaCG+OAv2NtTEA==
X-Google-Smtp-Source: ABdhPJy5D5/RNHf18wBa0Eg+t5e86Md66zOvKYCYi1Q/E6sb0yZTNAjy6T3W8kbfcazX8IhaNqcHHA==
X-Received: by 2002:a50:99c7:0:b0:419:225:80b6 with SMTP id n7-20020a5099c7000000b00419022580b6mr28917945edb.240.1651042686278;
        Tue, 26 Apr 2022 23:58:06 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id dc16-20020a170906c7d000b006f391eafd1esm3948648ejb.67.2022.04.26.23.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 23:58:05 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Kotas <jank@cadence.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH] dt-bindings: ufs: cdns,ufshc: Add power-domains
Date:   Wed, 27 Apr 2022 08:58:02 +0200
Message-Id: <20220427065802.110402-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Cadence UFS controller can be part of power domain (as it is in
example DTS of TI J721e UFS Host Controller Glue), so allow such
property.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
index d227dea368be..fb45f66d6454 100644
--- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
@@ -43,6 +43,9 @@ properties:
       - const: phy_clk
       - const: ref_clk
 
+  power-domains:
+    maxItems: 1
+
   reg:
     maxItems: 1
 
-- 
2.32.0

