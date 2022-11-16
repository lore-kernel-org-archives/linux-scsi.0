Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A4AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 12:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiKPMV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 07:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbiKPMUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 07:20:39 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FED2639
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:18:26 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y16so29604250wrt.12
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJEtub8V1LnQBPuC/j+4CZ4Uf34CBafwgkOL5JcKXZs=;
        b=QP2wtvzqTHk70Ufy5qLlZu444lFQPCngrbtt3UAP/WOtUufcT4lYsanK04d99j0W18
         IytzeaelnkfTxcirY1rOxyK6ElTHtQePUIrXG15F8PBNQR0g0eIZ2D1zQcblSRcs1FFl
         u10n4OA14EsUM83rPrWDVvRWiONkXnF9ujCgD0tIN9K+ML6rr1n5bKedVcsyq2R3j1LG
         GAK8PF3v5rErB3h3p7rlklRfTf18+0ziSY83PlKKdBu9pqBqhMe9HAjf08M/8b5QHmtb
         oWU7AmGFR7nEmQNKDVhYitTYHvlMStj4zjOgW7LF1Pu78/wSP0LBO2tVRrnuKcdttdkO
         mJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fJEtub8V1LnQBPuC/j+4CZ4Uf34CBafwgkOL5JcKXZs=;
        b=1ncyk97skJoz6RBj74u9rLbJa+106dicBcER4NU4QteNPMavtLSScAePSJLNfpoAXf
         W1jjQyfuuPQP34I4rmetbgVYnxhFXyG4Z+lNyYJiIIY45tzoPXe1pDIxLcZEh4QV1R+K
         WhRf731PgICKVxRaLaaBAU+adOehXZvW9AyppLIpUCJKDYCOmdagALXcwYMGxNfjUU7l
         CVfOs+slGBOiQI8HCk7kYnRPOl8DbqHZZxIbS4JxKpsOXsfwvn1xnLhk/6ejXPHnfDVJ
         o5lY2FaighevpCwosBiEmwtVvF6hdc1B5nybw/Ik/AoKzAuUUGXYC4o7wUVWhC6uyrH9
         weAQ==
X-Gm-Message-State: ANoB5pnTyvMNdhzf1RpaSRBGO1sjmuYm00gyLM0IGdTPULTOL+cuMhMJ
        zqIvMmOnMCDsl2CDDJC/LVvG+A==
X-Google-Smtp-Source: AA0mqf5j/ZQT6HbQ/iuTie2i710FZ8rhLlrvaUCCfCkCR6ERkMaYmLNVizqEGUg4ksc2+8M/DsZN+w==
X-Received: by 2002:a5d:6086:0:b0:22e:71db:47ba with SMTP id w6-20020a5d6086000000b0022e71db47bamr14186962wrt.359.1668601105326;
        Wed, 16 Nov 2022 04:18:25 -0800 (PST)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d42ce000000b00241a8a5bc11sm1090359wrr.80.2022.11.16.04.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 04:18:24 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: ufs: qcom: Add SM8550 compatible string
Date:   Wed, 16 Nov 2022 14:17:32 +0200
Message-Id: <20221116121732.2731448-3-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221116121732.2731448-1-abel.vesa@linaro.org>
References: <20221116121732.2731448-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document the compatible for the UFS found on SM8550.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index f2d6298d926c..66554adeb515 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -33,6 +33,7 @@ properties:
           - qcom,sm8250-ufshc
           - qcom,sm8350-ufshc
           - qcom,sm8450-ufshc
+          - qcom,sm8550-ufshc
       - const: qcom,ufshc
       - const: jedec,ufs-2.0
 
@@ -103,6 +104,7 @@ allOf:
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc
               - qcom,sm8450-ufshc
+              - qcom,sm8550-ufshc
     then:
       properties:
         clocks:
-- 
2.34.1

