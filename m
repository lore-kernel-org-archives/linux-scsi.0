Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F06EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 11:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjFWLaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 07:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjFWLaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 07:30:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9892E268A
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:16 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-98746d7f35dso60684266b.2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687519815; x=1690111815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BAVdWTyVv3g73n3CI+aPBRAAgKOeuBE5xdTL21wVIwg=;
        b=WU2xliCvd4k0PhUDtYCukSTQgNP9IiMRwhkE2J29RhyOsvutK/TR4kgQpzmawI250J
         GOG03XVJm+9emx4oszUbYeVHs9gjUh7b7vu2oMGGhMmvRwAn6qJweCH9wdC0PgSB1sKO
         Rct9gMXEDBM59Q/QQfMQ+fk7n1/H13ThS0AA9VBveGdZ3mjHsPka8tUukz03sGmhYXAA
         21GNh5ot1k6SunbyV8wix9rCiSC2Fl9vDuP1F9Jjb+MfYRv5bPOtbKLpP8NIvdfVF/fa
         YhTkhRlINM4WmIVTOnEm5hDpJLNSaSrHMZMKeabp19NV3xtsZGmsH8wXYz8E96otd/s/
         uD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519815; x=1690111815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BAVdWTyVv3g73n3CI+aPBRAAgKOeuBE5xdTL21wVIwg=;
        b=NdFcHisyDjkB6I9s8vB+ixMEdKtE7fn2QDbh+6zOamUFdaXIwrbcmJp9kpmItfOyTW
         hMjUSJh+uxWQydG8NcgyD2O9CGSsrOpxxDopJGigkSVEeVZl/9DSph+LaqSYdz+MHs7U
         qskgMmKUplKsoXDopmj/AoYVUmgtOnWaxH+VdiY+kU26s1f0oIGBZXxwx0f1m+6xBMJA
         n4kTmZ4I2wtf3BIL61MMRg2qiMxN/v37cjokVQ8oRkLPHh3h0ftdF91MCUIbEidgJPKN
         M59BkPKu+vdMH6SA0QhClPtt6UI62gN+a3dNSDlsvi7WBiFUEdmSt2/qAdn8i/1O+bVK
         wsnA==
X-Gm-Message-State: AC+VfDwaz/hI0mSlkX2quscX5MvoHR48/aMDZNxp7XmGA5XnB3ZNfYjG
        0eiUZY7K71+rVeV3gMpDONB6vg==
X-Google-Smtp-Source: ACHHUZ7442WtdeZn/EbQNjnsNf4WN5KkBAVB7CFMsOO+BKNDLrNVoN9HuA2w7XSsTcE9PVr8p/76FQ==
X-Received: by 2002:a17:907:9810:b0:96f:bcea:df87 with SMTP id ji16-20020a170907981000b0096fbceadf87mr21417284ejc.42.1687519815129;
        Fri, 23 Jun 2023 04:30:15 -0700 (PDT)
Received: from hackbox.lan ([62.231.110.100])
        by smtp.gmail.com with ESMTPSA id z17-20020a1709063ad100b009821ce1ea33sm5908033ejd.7.2023.06.23.04.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:30:14 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] scsi: dt-bindings: ufs: qcom: Fix ICE phandle
Date:   Fri, 23 Jun 2023 14:30:05 +0300
Message-Id: <20230623113009.2512206-2-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230623113009.2512206-1-abel.vesa@linaro.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The check for 'qcom,ice' property is wrong. Fix it by checking using
if-required clause and expand the clocks minItems and maxItems for
platforms where 'qcom,ice' is not required so that it includes platforms
with single reg entry and clocks that do not provide an ICE one.

Fixes: 29a6d1215b7c ("scsi: ufs: dt-bindings: qcom: Add ICE phandle")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 943dafb69529..bdfa86a0cc98 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -194,9 +194,8 @@ allOf:
     # TODO: define clock bindings for qcom,msm8994-ufshc
 
   - if:
-      properties:
-        qcom,ice:
-          maxItems: 1
+      required:
+        - qcom,ice
     then:
       properties:
         reg:
@@ -207,10 +206,10 @@ allOf:
     else:
       properties:
         reg:
-          minItems: 2
+          minItems: 1
           maxItems: 2
         clocks:
-          minItems: 9
+          minItems: 8
           maxItems: 11
 
 unevaluatedProperties: false
-- 
2.34.1

