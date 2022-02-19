Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551C9C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 18:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242939AbiBSSnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 13:43:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242930AbiBSSnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 13:43:15 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F05F27B07
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:43 -0800 (PST)
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2E8513F1F6
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645296162;
        bh=rlo6dv8R8AO8D00xVoydpkfzh23wJWM99TpGFXJ1F5U=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=qCsQmBnSn20HdYPCj0ehf4ZtsdwuVy12To3s5uMRupC1ukuwRbKuwseW102ebx6AL
         BBRYO87kjRRY2nCl70UNhYmZgjXhXaYrcq2eMFeKL7AenQXq/8dueBIggBuE3xUDoc
         vEoX4fM0JUk8wEJnzlH2U18vk0bh7FoWRkNFinEOdxz+UXv3kmG33v//sHzgbDA7mR
         qE2iKzx4Ig/pJ0iHqc/SUcJ5Z9tczh22/JbYtFT96cZqxm/ItlHTLpZ+eJLP6eSgFO
         omSwNLsCNnmDVFhnqcv9i0FJPhypEm9pkP22t+mv4YkVBCNTx6cwTAGaMszFbdzmWY
         Zv5fs8EJcbGcg==
Received: by mail-lj1-f198.google.com with SMTP id s20-20020a2eb8d4000000b00244c0c07f5aso2132792ljp.7
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rlo6dv8R8AO8D00xVoydpkfzh23wJWM99TpGFXJ1F5U=;
        b=RnZg9+T1ZTCoHB/KDHs4fF29+S398OcREfGR44HrqSsbbN61a1pDZYzctIPzizykIz
         tOL0ktEM2a0A8ctmdZU+BU78SOhJwlANtYVQhA2/gHQip6YEwNWvUTrwkAKLU8CwcA5+
         wbeeYmybPM4Rn+SUZwITUFk8jak2uSmah00khXfk3YVPn64p99eUZhUEK62fz1aXk5Eb
         YOI6H1vVog+HvJpd9LyXfohLbUZdGGNl/OcUDpZom5JjwQRgDmlH29RtyzC+NaJdZx0Y
         wUHECSPQjZV5nHQ6P1zxgbH4Xkz746AenP/yR2TjVDVYckR0GTixEDiMv5TNG6hcFJ9i
         UMfg==
X-Gm-Message-State: AOAM532QxE1SvWr8re7yy6Bx/GC8NtelAluehdWiqEnjaV9yfhcWoZEp
        NtxmhqyDThafHggN4/slTFibmZkm5BrZzNPdDhYM6nOAke8cOH7+nEbDy8sCRcYglLbC+xG6SCs
        LdNs+L2Du98pElRIho+CCDVCKA7w8n1a4HLcejZY=
X-Received: by 2002:a17:907:3a13:b0:6cf:1186:1381 with SMTP id fb19-20020a1709073a1300b006cf11861381mr10792767ejc.539.1645296150907;
        Sat, 19 Feb 2022 10:42:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2naSdEU4Ep7cfPOis7zL8hDLMxXjvy+MqwgzXgYHKGMAwKMtnXxUn3sccavk0GfxDOqA4cQ==
X-Received: by 2002:a17:907:3a13:b0:6cf:1186:1381 with SMTP id fb19-20020a1709073a1300b006cf11861381mr10792750ejc.539.1645296150719;
        Sat, 19 Feb 2022 10:42:30 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id j8sm6680745edw.40.2022.02.19.10.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 10:42:30 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wei Xu <xuwei5@hisilicon.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jan Kotas <jank@cadence.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [RFC PATCH 2/8] dt-bindings: ufs: samsung,exynos-ufs: use common bindings
Date:   Sat, 19 Feb 2022 19:42:18 +0100
Message-Id: <20220219184224.44339-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
References: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common UFS bindings in Samsung Exynos UFS to cover generic/common
properties in DTS.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml    | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index 95ac1c18334d..e01408b4fcc2 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -15,8 +15,10 @@ description: |
   in the common ufshcd bindings
   [1] Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
 
-properties:
+allOf:
+  - $ref: ufs-common.yaml
 
+properties:
   compatible:
     enum:
       - samsung,exynos7-ufs
@@ -47,9 +49,6 @@ properties:
       - const: core_clk
       - const: sclk_unipro_main
 
-  interrupts:
-    maxItems: 1
-
   phys:
     maxItems: 1
 
@@ -67,13 +66,12 @@ properties:
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

