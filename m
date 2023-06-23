Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52109EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 11:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjFWLa7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 07:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjFWLab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 07:30:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369A32711
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-988b204ce5fso56635966b.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687519822; x=1690111822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNvuq6mkva9AEwJO9JM3pF+J3bkYwlLNxD1WUPaScDY=;
        b=JyzgYeYGNAXiEO38g990qGezFImnyLJ1NctOgLVYfhN+FMGZDp/HilrsHhxCJZpjmH
         nCBpKvS9F3ZF6idUmrS193Ui/0nlt4M/2OjUtXfjlrFTNme1BnHY+fNqcOBS1GCz2xd/
         6r6vV2lrrZcKuUVc+ICPmjrckuoU/WU8rhpu/vKVuddYUfh5v+Me19Phemob4mtUZJLA
         3wL6DR1hhWkmjp4/FcAhlVzMaYOPpGXPCD0AjAiZd/+Re1FkBordvtJxNB6+82ipo97d
         TyfbwGNG9OPG6+2g0D1tQxKccI+juogcvLHXNjgMIkuw+N1mVN82BRcNM9c3pMgQOHKA
         4i1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519822; x=1690111822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNvuq6mkva9AEwJO9JM3pF+J3bkYwlLNxD1WUPaScDY=;
        b=EJAvJf90UDVA5jiYPIGFNlLDT6VhwJoLTTCsuf+RUtYTMyoq2iwk1YQGBbDm2YNung
         bJxGWHxzJ+t5TOnga8yCZocBfLimgig2MQua8vyBEJEdffB1XqMDk3qsUmFuDoYs6Zu6
         DKvI7AUS70Eax2HW/6T8dhdj2FAA5Gy8FBVW1kTQhdCiRcb08yW/4TBJgNxx99RXDjAK
         e3ajkqBP93QvDzJXmX8v+aeNJGmctKBd0bTPQ8h7UruMDStF+xrsVt+hEz7Vjin7rZID
         OvjcQJFqFikRDOJ+zNVQA9EgaNBRRIFvtTFQfmVfBxuDjJ/xEXmss5J0x1q1Ps0hHJAK
         yl9Q==
X-Gm-Message-State: AC+VfDwH0+YCHBSlOdIZ6fyxXVBqWVfnur0vwvoC9aiM9Roz6+8ip9km
        38T3JaLEvnE/NLc7tikqG8TLDg==
X-Google-Smtp-Source: ACHHUZ4fCA7KAKMZZcYPseVlCdJe079NwRS/tCOOQIdkW+evoYdAnQ9CHxOezcJFLlSf7FY9Jf/Xtg==
X-Received: by 2002:a17:907:a421:b0:987:5761:285f with SMTP id sg33-20020a170907a42100b009875761285fmr15875704ejc.42.1687519822320;
        Fri, 23 Jun 2023 04:30:22 -0700 (PDT)
Received: from hackbox.lan ([62.231.110.100])
        by smtp.gmail.com with ESMTPSA id z17-20020a1709063ad100b009821ce1ea33sm5908033ejd.7.2023.06.23.04.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:30:21 -0700 (PDT)
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
Subject: [PATCH 5/5] scsi: dt-bindings: ufs: qcom: Fix warning for sdm845 by adding reg-names
Date:   Fri, 23 Jun 2023 14:30:09 +0300
Message-Id: <20230623113009.2512206-6-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230623113009.2512206-1-abel.vesa@linaro.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a warning on dtbs check for sdm845, amongst other platforms,
about the reg-names being unevaluated. Fix that by adding reg-names to
the clocks and reg properties check for such platforms.

Fixes: 462c5c0aa798 ("dt-bindings: ufs: qcom,ufs: convert to dtschema")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 0209713d1f88..894b57117314 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -166,6 +166,10 @@ allOf:
         reg:
           minItems: 2
           maxItems: 2
+        reg-names:
+          items:
+            - const: std
+            - const: ice
 
   - if:
       properties:
-- 
2.34.1

