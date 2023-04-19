Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9341C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 12:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjDSMJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 08:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDSMJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 08:09:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC04E69
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 05:09:20 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2efac435608so2920418f8f.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 05:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1681906158; x=1684498158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ICV+ifexo83o57cRcwBX/lZ8ijdYT70+Vp9Lz3f2oAg=;
        b=ykMoH/onbS1531mCkS58WF+fhQb/0kz8ZY36KbB/9u0gHHuOZQOTNOcmePMMX3kdcC
         JrZg2yRBqAm6Bueq4rgEySjGr1NJE75dSQkn3jO1q5NFFu/3XDpN3QkIh3ZYNH1amdEa
         MglUuRz0NUd0vIE+JsxOWG4uSvWjcud65TMNLqrFHKUXZjbyxCt4tz0tl+SPCZecRDUt
         hvTGl+Qi8eb98CLLxeZCktJ9fd5qtP3LglWCDJs1KD/yRmust4LchvLPkPzJHp6U88yQ
         z24WJ5AiLKoRN+bHeQ6sisSV5ZVab8ED083r2ZGweEnFvBh6gromIbqRLY5tpYZ5ZD4l
         Vcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681906158; x=1684498158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ICV+ifexo83o57cRcwBX/lZ8ijdYT70+Vp9Lz3f2oAg=;
        b=B7s/K2qMM1AqoS2OGvUGc8aJhtI+/l5gafoBxfIMXIJMsoufT3i3sv51NJynWdpk5X
         bahLrR4vlGfFqcSu+wz368dirv7Q/hB0MBVn8mVptT8X22CW0MvuCMkz2A+kZWvXPOLs
         CMDKVp+Vkw0iFAQ4ycwP2izke7MzgglsC9SoFuN6znEnOHcYoOc1vXhpiVpifY/CQecx
         GxvE5yB8IDixZ+kPe2J3AC+ZZa2zhDTUO+HPJIB2NQofjaDJgeLB3QSB7sYRx9AdaZpK
         aZ1b2i2ZyQ8Ck0Xai49dfV5Szxi0DkDWKqB8hxRT0Jr+Pb2pvPzCSkxkJPDqoKR9D7BY
         KhGw==
X-Gm-Message-State: AAQBX9eWTZbb5jXbNs+SNZssomVOpsfvLEHp2W5whHUMH3MU3qn/Y6CO
        0HLiYltmJUwscUcHZbIht+bT2Q==
X-Google-Smtp-Source: AKy350aKXVkWQBioUWRD45UWirKdXtYI4Q7nfX+i1Dn7PTo4kmQYfduYh6Pb3t2kw30YkIia5o26xw==
X-Received: by 2002:adf:e688:0:b0:2fb:f93f:b96 with SMTP id r8-20020adfe688000000b002fbf93f0b96mr4416492wrm.31.1681906158527;
        Wed, 19 Apr 2023 05:09:18 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:e836:64e1:77c8:1d5b])
        by smtp.gmail.com with ESMTPSA id v11-20020a5d678b000000b002fa834e1c69sm7634899wru.52.2023.04.19.05.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 05:09:17 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v2] dt-bindings: phy: qmp-ufs: tweak clock and clock-names for sa8775p
Date:   Wed, 19 Apr 2023 14:09:14 +0200
Message-Id: <20230419120914.173715-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

maxItems is already globally set to 3. To make the binding easier to read
and remove redundancy, set minItems to 3 for sa8775p as this platform
requires exactly three clocks.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
v1 -> v2:
- rephrased the commit message as this is not a fix but rather
  a readability improvement

 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 94c0fab065a8..a1897a7606df 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -78,9 +78,9 @@ allOf:
     then:
       properties:
         clocks:
-          maxItems: 3
+          minItems: 3
         clock-names:
-          maxItems: 3
+          minItems: 3
     else:
       properties:
         clocks:
-- 
2.37.2

