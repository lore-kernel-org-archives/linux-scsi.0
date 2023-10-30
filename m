Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66429C41535
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 09:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjJ3JnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjJ3JnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 05:43:18 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC7C1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 02:43:14 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-5079f6efd64so5909152e87.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698658993; x=1699263793; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xnHWU+WQVP4k7S5E1faDC22pH1GlE3IL+UX99IRJ/aQ=;
        b=XgZS+8nA7BtugN15UdAxZuelmYGAKJXNViErHG47Ph0lzREonmtRnAkBFB2UPlmtDb
         f16p9N362/JjPMTrZxJtI/Qg0HhwRVx7EIM+gjEcoEq2tGbkAf0mMXrMAdg6njdQKwhc
         tmBK549VtBw4RzAcS7nGsnxIeUm56q3R3/Euxc5toABJiAt8h82aeYznSKARFTTtdW+3
         uJoR0Qua3SjE+yXfBRpRttlyYDki9voHn+g1T+TqI5esbKT6uK0Sh+DVlcRxn47/8iTU
         +rQvt1N9/lVGQun5bXRoVwWiIkLgtcd2SctI8KLUcMDIh0smdoCqZcANIbVb2A/F5aM3
         PDmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698658993; x=1699263793;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xnHWU+WQVP4k7S5E1faDC22pH1GlE3IL+UX99IRJ/aQ=;
        b=Ul7IMwO5tvSBu9L4PN0ESZEls5v0yjjeyya3qpNV1AVM7n6hpvsPBAOHLDgLqBGK7m
         XVHpYqPZwXESZUP4Rp1/1bi6oU8yyRQAwscX0vsqJnmjQXuHgcEZbhy6f0Nklqzlfk6c
         MBkcJGvdcdzNZGrw4WHovW/ZYNsIHwEddALkYtwXLQp/8SBXevA6kCFLorxTpab72ytu
         /VrmI2ec7SGYIOeQWZYhWqS3GRenagIKF+MNS5rUgdfE4sk7JN/35c9af3BnLNvFUCEn
         lTmU7ixr//f0mlsp1RSlX7AW2lVVdKhfrK1WLtgb/Q/bFw6x7SRRUwUH090A7iQaDlAg
         vGbQ==
X-Gm-Message-State: AOJu0Yw3TfC0CCMtv1Fg7kvSPBkfM9Zs8szvOLMpSzicgxpEXVIaESC7
        EaGn6ZFRNcHtDnn/csv8FogSZA==
X-Google-Smtp-Source: AGHT+IGNM/yQoF6/HdXJLNHPDgyk9s8UeWq68znES/T8/ru4wJ0so2bXxVd7UradeFcVRwrKDKRIvA==
X-Received: by 2002:a05:6512:401b:b0:509:e5e:232a with SMTP id br27-20020a056512401b00b005090e5e232amr4816819lfb.42.1698658992838;
        Mon, 30 Oct 2023 02:43:12 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id a17-20020adfe5d1000000b003142e438e8csm7880556wrn.26.2023.10.30.02.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 02:43:12 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 30 Oct 2023 10:43:11 +0100
Subject: [PATCH v3] dt-bindings: ufs: qcom-ufs: document the SM8650 UFS
 Controller
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231030-topic-sm8650-upstream-bindings-ufs-v3-1-a96364463fd5@linaro.org>
X-B4-Tracking: v=1; b=H4sIAK56P2UC/5XNvQ6CMBSG4VshnT2mv2icvA/jUNoCJ5GWtNBoC
 PduIS5uOpzhPcPzLSS5iC6RS7WQ6DImDL6EOFTE9Np3DtCWJpxywSirYQojGkjDuVYU5jFN0ek
 BGvQWfZdgbhNYKkyruFUnq0iBxuhafO4jt3vpHtMU4mvfzGz7fniufuEzAwZaKOXK1Uqw6wO9j
 uEYYkc2P/P/TV5MKqm2zEjZyPrLXNf1DYbBbAUpAQAA
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1824;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=pi242ASpvMoXd5cxDim+bVxNqfCmgVxX4FXXbCCELqw=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBlP3qv5KVtyXLPavDx/xKMLCC63AR7cuF7sX7duPjd
 KjNPGy2JAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZT96rwAKCRB33NvayMhJ0bf+D/
 9GB1KDkr7jr5XU/Ks6BiAKKFKmVnKkSezGTV6EloIVHKkdtQ2zyT6op88OjGBCKprKF2CVCQnRmxEi
 fZyG2t86ochCEXPu9GYDJSjJJA8Tr6RiyA832K3D9RwPCmkBO1lZFgDJoP+BHwg0cvpIC6DnjCr13A
 uxV9W9BPJZZjBYWOKQWTMT7cKBfCQ/gxaRXY+8LhTA2befEE5Q58V4/XphIVZrxOXFDguHEJ2YpdF3
 3P4hhq6UaX23cQs6by/DddWX2X2j4P5ZNmRCMRO7YkM0WQUpUAsd2sggR6IiMv343upTN61KHlA8xR
 MtYMIQ35EOzZdcMWA8iJac5AvaWZsUNtPxp04kBDbyiMH7iJKkHGGXq//Yq2vImDnFRUU9SIMHjbrM
 C7ekW+EOLEGuiQeBZkzBlk5Pb/MLHJiUuD/ftAwDwet1UUzyO4RJvF0qNvV89JvBRCyH8Q8hyXMWqi
 JGCyJFfIZ93WJh7c87igguQ5dtKzQJsORID90kxAo6I6DmplNYrBYhdpwl2GYJNnrRDCpeLFfWCcU4
 hxolI3XH3eVZ3Xk8CMLOZWRAM1N0OO8/c+B972ZZU0yCzFVK1uf74cJ8tRBx1+2Xv+mxrXEU+9l8Dk
 4o/5/RK6LBHnOuRJ+FR70pGy9daCti868vaBjXdaf76dfhnyqFTyT5oGdnJg==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document the UFS Controller on the SM8650 Platform.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
For convenience, a regularly refreshed linux-next based git tree containing
all the SM8650 related work is available at:
https://git.codelinaro.org/neil.armstrong/linux/-/tree/topic/sm8650/upstream/integ
---
Changes in v3:
- Add missing sm8650 entry in allOf:if:then
- Link to v2: https://lore.kernel.org/r/20231025-topic-sm8650-upstream-bindings-ufs-v2-1-040ad1c44b46@linaro.org

Changes in v2:
- Fixed subject
- Collected review tags
- Link to v1: https://lore.kernel.org/r/20231025-topic-sm8650-upstream-bindings-ufs-v1-1-a355e3556531@linaro.org
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 462ead5a1cec..2cf3d016db42 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -36,6 +36,7 @@ properties:
           - qcom,sm8350-ufshc
           - qcom,sm8450-ufshc
           - qcom,sm8550-ufshc
+          - qcom,sm8650-ufshc
       - const: qcom,ufshc
       - const: jedec,ufs-2.0
 
@@ -122,6 +123,7 @@ allOf:
               - qcom,sm8350-ufshc
               - qcom,sm8450-ufshc
               - qcom,sm8550-ufshc
+              - qcom,sm8650-ufshc
     then:
       properties:
         clocks:

---
base-commit: fe1998aa935b44ef873193c0772c43bce74f17dc
change-id: 20231016-topic-sm8650-upstream-bindings-ufs-d03cf52d57d5

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

