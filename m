Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964A0C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 11:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjFWLaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 07:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjFWLaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 07:30:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B2F2697
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-988f066f665so57825866b.2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687519818; x=1690111818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzYeX68lKPlCz+L8LZ4YwI674b1AAUDgqY7Xo7im3/4=;
        b=uHJ4+gc4n6QbqMyBWtK7W1Xjt3MTzTnVUjya30Fb5NdXahoVDeLZRl3hgSp278tlE4
         VliyNQplaORSO0/kwQjLUpPqz96HPEJEQWotYXarNJMRZNaUhg5911D/zJmwidH4CFwr
         oTkv1BJJGZWaG4cul83ynqe+ClDig+Eh0r69dXzz6n/dMWh3Ypm5IJyZtq4TcDDyRfSs
         XCf+WWMscRVc8iFb4NuvjeOu3Aw/Z4WvUf+glGyrC0zFfFTDlbSBTilr7zPGYx2FltqR
         YM8RKimFT9j7RUKJQ7sK0lVTAh0i4Uu0yWYMFc0wX1mqz5Jv/JIOu/wUcyXNERoKQXuf
         ILxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519818; x=1690111818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CzYeX68lKPlCz+L8LZ4YwI674b1AAUDgqY7Xo7im3/4=;
        b=YZkMGCutuoW+vIbvCSH4Vs6frXgsljJl+x6HElcJnSfzZ12gWwCE9DjMQCwDCEdd9v
         /WOWsNqtlRXr6fe2wT5KnApD4P9AhZnyr00d7qrBttveG1Nv3ovkl0KmeKDyFkf+hEZu
         EJcOonkDzkmS957MM14YU/9+jt1mEAiMLEid9paf8ia9Rq7venIQrib+0KVfkqh5xNGY
         KxFnlYmEGBEs5z+TdAcEDLhI164hZSTuTLfuMxGJR524VFIqo/Yv2Zf19tH1ocyuS64u
         ZpO/BbTW1OOGueZnSdQDlbiCQ6P+JMdZy1H0S/TKxFqQyr/4aze+0t/agRBK+GLPYAy/
         cqYQ==
X-Gm-Message-State: AC+VfDxoViG/11BxGzd+TWgFUCT87XPPbmAJhabMsyervJiyp6rn6eIN
        ygguZwvoyaFj01XIQOImv4aArg==
X-Google-Smtp-Source: ACHHUZ6nwQNRD1YKOwwps0UGbxCzVqLniiQ53txsZ6ugpBw6DK6UIbEJhyYSWpw+zyT7teqY5aegMQ==
X-Received: by 2002:a17:907:60d6:b0:98d:264a:422e with SMTP id hv22-20020a17090760d600b0098d264a422emr3827978ejc.23.1687519818146;
        Fri, 23 Jun 2023 04:30:18 -0700 (PDT)
Received: from hackbox.lan ([62.231.110.100])
        by smtp.gmail.com with ESMTPSA id z17-20020a1709063ad100b009821ce1ea33sm5908033ejd.7.2023.06.23.04.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:30:17 -0700 (PDT)
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
Subject: [PATCH 3/5] scsi: dt-bindings: ufs: qcom: Add compatible for sc8180x
Date:   Fri, 23 Jun 2023 14:30:07 +0300
Message-Id: <20230623113009.2512206-4-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230623113009.2512206-1-abel.vesa@linaro.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the compatible string for the UFS on sc8180x platforms.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 46f454ec3688..4dad3f9ba81f 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -27,6 +27,7 @@ properties:
           - qcom,msm8996-ufshc
           - qcom,msm8998-ufshc
           - qcom,sa8775p-ufshc
+          - qcom,sc8180x-ufshc
           - qcom,sc8280xp-ufshc
           - qcom,sdm845-ufshc
           - qcom,sm6115-ufshc
@@ -113,6 +114,7 @@ allOf:
             enum:
               - qcom,msm8998-ufshc
               - qcom,sa8775p-ufshc
+              - qcom,sc8180x-ufshc
               - qcom,sc8280xp-ufshc
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc
-- 
2.34.1

