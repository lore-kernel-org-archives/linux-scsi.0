Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDAAEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjGLKxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjGLKwx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:52:53 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A83173C
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:52:47 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-3459baa237bso33676865ab.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159167; x=1691751167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=e13SfAv3mkxr13sh2zccycdVfYk3DnppP3UbAnCxXg0=;
        b=UueLl2MXrT1Yag3+TI9h5tN6UN4vj0Jz4NVvBO1uYLZ9O/h9tbkLrFWupLLoTT6ySS
         vSQYeT3T1lDt2RCwsUXJ0ZOcVi3Op+8FNzUC2vSISncWAUGoZ53hRxvtrJqZkpc2gFWB
         sK83Zm7OnvrO67ktFgg6P9876LUWYryUNTAswERy5hu4Gm5/jDHiCRhBdC3XXdPZzWlP
         hDJFz++efySmGlisnHWzhqUvPivf8INhB4HWOrfPGBB3a3yndiO1yREHVaukbg1xxCvW
         z/bjQ049v1hUwICJTSzDvrT13sVuYvmx/0AnOQQolptW+qsmc2fzfcG81QFh0A2PUz5e
         r9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159167; x=1691751167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e13SfAv3mkxr13sh2zccycdVfYk3DnppP3UbAnCxXg0=;
        b=jfQF2+QLGJ+va3ya1nLfyq2HU4D1bFcjbkQc5RqUrIi2ZhfdctTgFA8+FKFxT4cRAs
         jMecn6MDfyv673Rvm3ZhVpH6APNHt0ctwyzSf0aO4VSuyiX1Scd6vJr4pp2sNkPPbR8J
         4E6lFOWTtAcZrN/dtLzYgBNwfUzrWp7h7unE/77/yJnmXrsEGTdBjmX7i73er989/pHh
         JiEAdyMdo9mvt/9CoCkSU5uoExF27XI3SY3vFdft3CLCOsxgfZCFQpHJIhH+z9ZUGN+v
         vtkzkfxH6v9Mc6ORkbMFwCURFB25NKyLZGEHxerLwPiO6EEGtmNoSLkI0kJDkcVQ9Azz
         YoOw==
X-Gm-Message-State: ABy/qLaWjG4vcy1cjFog5FmjyLV4bio7/WYxWOc8ybinC0PQkpYXv0T4
        7reIolsB9PQmylKvSm46Kf8X
X-Google-Smtp-Source: APBJJlF5P9BD40qWZLr1TlFJAWHA7etXDMH11oL/d9l+4HkgR/SP0GtUyW6LCwPXiJbUHotxcxUnYA==
X-Received: by 2002:a05:6e02:d88:b0:346:50ff:adc5 with SMTP id i8-20020a056e020d8800b0034650ffadc5mr12161432ilj.3.1689159167231;
        Wed, 12 Jul 2023 03:52:47 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id v15-20020a62a50f000000b00640dbbd7830sm3443966pfm.18.2023.07.12.03.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:52:47 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:33:00 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 02/14] dt-bindings: opp: Increase maxItems for opp-hz property
Date:   Wed, 12 Jul 2023 16:01:57 +0530
Message-Id: <20230712103213.101770-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: coAeY70TCtjo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current limit of 16 will be exhausted by platforms specifying the frequency
for 9 clocks using opp-hz, like Qcom SDM845 SoC: 9 * 2 (64 bits) = 18

So let's increase the limit to 32 which should be enough for most platforms
(hopefully).

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 Documentation/devicetree/bindings/opp/opp-v2-base.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
index 47e6f36b7637..e2f8f7af3cf4 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
@@ -56,7 +56,7 @@ patternProperties:
           need to be configured and that is left for the implementation
           specific binding.
         minItems: 1
-        maxItems: 16
+        maxItems: 32
         items:
           maxItems: 1
 
-- 
2.25.1

