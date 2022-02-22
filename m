Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59425C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiBVPAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiBVPAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:11 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD6010DA5A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:45 -0800 (PST)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E41713F1DD
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645541983;
        bh=74/pBhghHeWH7/mWTs7/IJw313x+oiYcimgGGTWLW0I=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=lZzY+9CANg/mFRjWa8pOexhcMYuFW0b6a/t344ieDX4kPDvTBUtc49+xGyINzLd6p
         9vuBEFyrnjPz3gpFCW/JvPW2EyMBvK+BauXG5/fS4+PrGDoX1eMrDqcb5lBz6r04gk
         6BoHNqnfE1x0aoXoLXOJaglTIKh7nJ/95RY5jWupGLot9pN2zLp+3LEHrbfBfqnzO8
         +NnIVHOzYOj5j7ZeDN202F8KkY4itiYgJ9fzMp5gcI4pWBAX4gIpBmM/325yFaQ6Kz
         Ek0Xs1u0FxfLdY74beC+TSaNKqWZxqiIU4mSdHf10RbX2NSPik4AKPRPGoeoQ+OZV7
         Yu9uLfJAHGFpw==
Received: by mail-ed1-f72.google.com with SMTP id r9-20020a05640251c900b00412d54ea618so6361611edd.3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74/pBhghHeWH7/mWTs7/IJw313x+oiYcimgGGTWLW0I=;
        b=gfmnvUQRJQjhWiOciv33UGpIDQyHo77OB+E6eZJxrval+U0P1nzdg8QduahmqT2X66
         1M0kfhb1AsKW8frnW1cZuQKdl0MErIsQXjHAFo2Wxad4D5t9TXiEsnWx+GfJ8v7U1Pkw
         kMeuYFJheVRv/uq+8uekhu1icLUsTS5cq2sk1af+CMjdnOPhaU9l9inp41GZZ+05T8Wx
         4QXmRYPdtOrYBaVwFu8UUAZt/XTHNz9iSvZRrBQ8EaZ9RcFdUPZK/C8zs/tyGJABrmvJ
         aqwMkqZ4VjrjFLTrJsRaMtX+fvH6DWOm9amqJjYMCd6AYirh/nuDK3QA4lGCtuPEvBbZ
         vD0A==
X-Gm-Message-State: AOAM533S3Itq5K/u/wv7/RPkCsYsx3SSTg+jHpsD2Lms5U+yOVjjDRZf
        /DEKDETxIAKTH7Ga3/SnFhcKOe7918guvW0OdPC8umiHRbqIihz8QwbsIVNpLyCeZj/FaC9lYky
        xt0NDvtMALTpDzZa1ANr+40dCp8WeA6t13EH84/w=
X-Received: by 2002:a17:906:194f:b0:6ce:3670:92b with SMTP id b15-20020a170906194f00b006ce3670092bmr19235869eje.737.1645541983425;
        Tue, 22 Feb 2022 06:59:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnm5ZDMw7fGj3UZIRVOLHmbWI713Qr92YShXMsW7GfodY/Q/WqKceA948ZzJpTHBhv2Bc9gQ==
X-Received: by 2002:a17:906:194f:b0:6ce:3670:92b with SMTP id b15-20020a170906194f00b006ce3670092bmr19235863eje.737.1645541983264;
        Tue, 22 Feb 2022 06:59:43 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:42 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 02/15] dt-bindings: ufs: samsung,exynos-ufs: use common bindings
Date:   Tue, 22 Feb 2022 15:58:41 +0100
Message-Id: <20220222145854.358646-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common UFS bindings in Samsung Exynos UFS to cover generic/common
properties in DTS.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index 95ac1c18334d..c949eb617313 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -11,12 +11,11 @@ maintainers:
 
 description: |
   Each Samsung UFS host controller instance should have its own node.
-  This binding define Samsung specific binding other then what is used
-  in the common ufshcd bindings
-  [1] Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
 
-properties:
+allOf:
+  - $ref: ufs-common.yaml
 
+properties:
   compatible:
     enum:
       - samsung,exynos7-ufs
@@ -47,9 +46,6 @@ properties:
       - const: core_clk
       - const: sclk_unipro_main
 
-  interrupts:
-    maxItems: 1
-
   phys:
     maxItems: 1
 
@@ -67,13 +63,12 @@ properties:
 required:
   - compatible
   - reg
-  - interrupts
   - phys
   - phy-names
   - clocks
   - clock-names
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.32.0

