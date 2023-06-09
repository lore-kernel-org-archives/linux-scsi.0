Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1DAC83003
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jun 2023 14:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbjFIOHA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jun 2023 10:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjFIOG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2023 10:06:58 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEB230FA
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jun 2023 07:06:55 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9786c67ec32so312057866b.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jun 2023 07:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686319614; x=1688911614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8ez83xrnUgbw0MAP7/4bHfz4IcI1smRL2ein9QCNd6Q=;
        b=MWLzBqFecgIKNf1kgPAbYdebxEuEwkAqBZ/e49ZS5gOtgYOKtpD8LQ66Vnv9LPxiJF
         Mo9RX6D+aYNPiN9nEWemYZ6fCyB7Hqdx00XbM3YtyU6iX6l3saQ6vFZCasD2zN5AKmli
         wHWkF3yxP8aqdzkMYYz+zxRIdZFMgMBPLMI99CLY3WSQOqFCjvgSoqxOo2E9jPdueDAg
         TdG04blH0/lMwU9GRTQpsDIE+hyW/ePw7XJHVgV4b9z3jvWj6PpTE/AN2OPP1MMFGs/H
         qFE96ooOh70XorMN5d40jzSzZRDM+LU0W+0oU8GvzDStCIxJHYaW9lHRgC3vDieyK1lT
         sqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686319614; x=1688911614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ez83xrnUgbw0MAP7/4bHfz4IcI1smRL2ein9QCNd6Q=;
        b=a0f8QHB1P9R1z6OxjroF252X2o2TxGqBJmFhLXXjDLTsnfADYfWwJwVkwWEn84jmfA
         ba78u+5r5O0RgbJHOUKLk3yJuy0lrBICNRR/239P1TJkM4nX243v1+DlUkb1pdQb7vSZ
         6b2ouo34h4pWyV5XtVW5Br6l/cU5vKm0iD6cerVrVXxZdv1lCi9ZV2HD7ubskh1c89B7
         PDhHJhqlWMh8P5k4kpcKUq1R8Z75XE8WYh9iioyAz04nZOc5MjbYa9KzcBwI4n8jgIeR
         Zl2wKxlk4aRcDVHfUenVfg8axgBYtVYNdH4aDXiwu3wedMxfzVJf0cuZu4wyErB7WKzG
         XFVw==
X-Gm-Message-State: AC+VfDxx/hq6K8vz2+AaXQq5g+dXIJCsWzDvrWad9cGt3fkciciPdnUt
        FwWj6+tsmx5/WKcugrdhPngZBA==
X-Google-Smtp-Source: ACHHUZ6eNQSN6PIFn6NAH6sD5EEzqacvW4Z3scV2BWSPG/097RqqphuqnMSNGCi9/N3LutXcW3LILw==
X-Received: by 2002:a17:907:2d06:b0:973:da59:7c91 with SMTP id gs6-20020a1709072d0600b00973da597c91mr2053621ejc.51.1686319614494;
        Fri, 09 Jun 2023 07:06:54 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id kf10-20020a17090776ca00b00965f6ad266bsm1307695ejc.119.2023.06.09.07.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 07:06:54 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] dt-bindings: ufs: samsung,exynos: drop unneeded quotes
Date:   Fri,  9 Jun 2023 16:06:51 +0200
Message-Id: <20230609140651.64488-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cleanup bindings dropping unneeded quotes. Once all these are fixed,
checking for this can be enabled in yamllint.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index a9988798898d..88cc1e3a0c88 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -54,7 +54,7 @@ properties:
     const: ufs-phy
 
   samsung,sysreg:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description: Should be phandle/offset pair. The phandle to the syscon node
                  which indicates the FSYSx sysreg interface and the offset of
                  the control register for UFS io coherency setting.
-- 
2.34.1

