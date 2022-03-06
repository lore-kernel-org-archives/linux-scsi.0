Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF0AC4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbiCFLM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiCFLM0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:12:26 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04428606E3
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:11:35 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B1E3D3F62F
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565093;
        bh=l+3yBFGs2kRX1wnF/pKhhZHPFcB8pp4apl6TxfDIAEo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=cNaou40RPlvBhEhsJwKhPo6bGSoddqMe9MgHZCG9Jb2UvptSeUqi4YeEgCS5/2SsX
         FXECURlxxqHJ3t5jsrjVRGj+Qy3g0+Ne3NKJVAVIwMi7zNdhHo/KwLQTkq2eXAnHGK
         /oPD3YcMzb5W5h7cNz302qKYUF/ZZ0rzr4GYx1+C471gNOmpV1tfOUlr9EA42/xE4u
         wGclw7t9Oo3Jz46gQaEor5Pgjwt0e7DgXJDL0wPJuhI9hbFAFLgQZR8ApFfpWCAT59
         szwUrzxsvny96weNlj4vDtYyvvmNp5Lr1lQboLNEAje+9XQAXdvF4djXmYOTLXhcze
         YZSjtKi0EUWTw==
Received: by mail-ej1-f72.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so6085118ejw.9
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:11:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+3yBFGs2kRX1wnF/pKhhZHPFcB8pp4apl6TxfDIAEo=;
        b=AnbzhE24/xHHyRNA3BlT9zRVs2lPAojAgUc213igE4L2t7Ad+Iz/zP8Zglyyt9ke6j
         lZPy8q1lIimvw/T900F3Wo+Z6yxHSvf1H4lundzAv09V5s3eyQXoEE17mTh3lTLWR13V
         e810R7xP/oQ0rXv1nH6ap7ZFBSwR8AMqibESPkQvEGRlWG1W/wbr36rgxx2J37zass0R
         Jgenye8+ZJG+ODLLi5a9vyhOMjqAFF95Nrlisee72G5J8rbpLOGYhYUacnU+s9hP1CnD
         00bLW0mpIRH8h9kyly8ucB4bg88th6tulATOcyu/Inr2af7LfvlTldfAoaS0/1nA61u1
         0j2g==
X-Gm-Message-State: AOAM533ac+/o7XnXo5GTOSo8KYjIQSAIb9vYc2h/FhFQ0LjksNdpFxlA
        V77EmRLCQ91TYSny9++oX4+blEY8C/yYdAFLFFvhUHOyMMgacGRvlaYe7pa2IDCOHP0XbM1s6LF
        mOif00VAHDFIK+ciRaTzQPoZs6+tm40jaSTDlyM8=
X-Received: by 2002:a17:906:2bd7:b0:6cd:f89d:c828 with SMTP id n23-20020a1709062bd700b006cdf89dc828mr5685952ejg.232.1646565092948;
        Sun, 06 Mar 2022 03:11:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFqqBEGSiJykeoRQrbuWpAeTlK57pqo/2+l/saQ7OCHi1VkQZAPsAbz54RGXOqql4jg2q7ZA==
X-Received: by 2002:a17:906:2bd7:b0:6cd:f89d:c828 with SMTP id n23-20020a1709062bd700b006cdf89dc828mr5685937ejg.232.1646565092784;
        Sun, 06 Mar 2022 03:11:32 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:32 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Cc:     Rob Herring <robh@kernel.org>
Subject: [PATCH v3 02/12] dt-bindings: ufs: samsung,exynos-ufs: use common bindings
Date:   Sun,  6 Mar 2022 12:11:15 +0100
Message-Id: <20220306111125.116455-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common UFS bindings in Samsung Exynos UFS to cover generic/common
properties in DTS.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Rob Herring <robh@kernel.org>
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

