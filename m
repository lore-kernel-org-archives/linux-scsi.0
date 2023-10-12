Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFC0C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 17:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379653AbjJLRWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379612AbjJLRWH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 13:22:07 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8450E8
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 10:21:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c9e95aa02dso3267605ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 10:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697131311; x=1697736111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emz03f3uxdP7Dq6lqeINaZBEdrIm5oTH0vEaEEX0iS4=;
        b=Jsp8cAqZRfPoQAwyDLvOynGiSaXDUBIpdQIr9Sr23jifeiqV1AVkD9mJr/dTBRlynR
         KzkeSfRdRsqx6ez3115boHO09wZqYQJuJ67bSH1WWI8g0srt3Vocn1BKnnYToSZ6wJ3F
         sx6RS8jsItRWx7EXxbgz+qORos3T8PSdZrwGPdI0+A0f4YD1Jp2qe6NOpzAV5+DnlsOr
         ikwyGtUbcTk4LEZWJb8e8bi+3rnDo3scwgSAoxRNahKhjSYpd1dBfi9POhKNSebJYJhe
         HO+smd61N3vYZIq7uhoWf3QecIJfMwrzwVDxKMWqV7ynX3zSlVOSp+LO5zmiQaTMOYmX
         FRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697131311; x=1697736111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emz03f3uxdP7Dq6lqeINaZBEdrIm5oTH0vEaEEX0iS4=;
        b=BDFvbZwcGx9eKQRB/ge3p8teis7/BRL3EfYJ89Bj6mf8N4n+kebpMAlFPkaep8Nxe2
         jourx+++4aYWoD/uPT56towBiPB0SbbpClxX0UMlqHWuDkrnxEsAlwccIt4pLTspY8WN
         RefLdg1iWheRac3BLVvARj1YDPqiqNw3ll6v693xW0zKlufwHxmEcTl5GTQ2nPn/ERH5
         gXmCWNqY4wqEJbIa6qIYRvX5pXqwI+V8KksS02ycnnbNIFs3z3euaJrtCTOBHN0xCaW/
         fRWrbJVhWWBwSyDxIYwRdU7KqmVx9ICvPBAt8gEdd4bhlPoqICon3gG0m4bmYMfLeKPg
         LYjA==
X-Gm-Message-State: AOJu0YxkO9FdCT3PEukcA0MUUeg/zvYTN9evbupAsbMp0KIz4GTAKlxK
        bfjHNWy0vfCs2nVOVkLBrwBT
X-Google-Smtp-Source: AGHT+IEw8ngM9ONqiOY/Lpq6bCfVEQBRoq3XO4ZLXCgxF2MnAul4Mauj/JUwnqv5RWxQLqInE84Psg==
X-Received: by 2002:a17:902:e5d1:b0:1c6:362:3553 with SMTP id u17-20020a170902e5d100b001c603623553mr31262262plf.31.1697131311172;
        Thu, 12 Oct 2023 10:21:51 -0700 (PDT)
Received: from localhost.localdomain ([120.138.12.180])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902ce8900b001c75a07f62esm2242359plg.34.2023.10.12.10.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 10:21:50 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, alessandro.carminati@gmail.com,
        Rob Herring <robh@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v7 1/5] dt-bindings: ufs: common: add OPP table
Date:   Thu, 12 Oct 2023 22:51:25 +0530
Message-Id: <20231012172129.65172-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231012172129.65172-1-manivannan.sadhasivam@linaro.org>
References: <20231012172129.65172-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Except scaling UFS and bus clocks, it's necessary to scale also the
voltages of regulators or power domain performance state levels.  Adding
Operating Performance Points table allows to adjust power domain
performance state, depending on the UFS clock speed.

OPPv2 deprecates previous property limited to clock scaling:
freq-table-hz.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index bbaee4f5f7b2..985ea8f64de8 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -20,11 +20,25 @@ properties:
       items:
         - description: Minimum frequency for given clock in Hz
         - description: Maximum frequency for given clock in Hz
+    deprecated: true
     description: |
+      Preferred is operating-points-v2.
+
       Array of <min max> operating frequencies in Hz stored in the same order
-      as the clocks property. If this property is not defined or a value in the
-      array is "0" then it is assumed that the frequency is set by the parent
-      clock or a fixed rate clock source.
+      as the clocks property. If either this property or operating-points-v2 is
+      not defined or a value in the array is "0" then it is assumed that the
+      frequency is set by the parent clock or a fixed rate clock source.
+
+  operating-points-v2:
+    description:
+      Preferred over freq-table-hz.
+      If present, each OPP must contain array of frequencies stored in the same
+      order for each clock.  If clock frequency in the array is "0" then it is
+      assumed that the frequency is set by the parent clock or a fixed rate
+      clock source.
+
+  opp-table:
+    type: object
 
   interrupts:
     maxItems: 1
@@ -75,8 +89,23 @@ properties:
 
 dependencies:
   freq-table-hz: [ clocks ]
+  operating-points-v2: [ clocks, clock-names ]
 
 required:
   - interrupts
 
+allOf:
+  - if:
+      required:
+        - freq-table-hz
+    then:
+      properties:
+        operating-points-v2: false
+  - if:
+      required:
+        - operating-points-v2
+    then:
+      properties:
+        freq-table-hz: false
+
 additionalProperties: true
-- 
2.25.1

