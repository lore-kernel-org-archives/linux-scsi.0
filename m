Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1EFC3DA7D
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Dec 2022 12:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiL1Mnl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Dec 2022 07:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiL1Mnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2022 07:43:40 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE56F5AC
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 04:43:39 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id g13so23453500lfv.7
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 04:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wyLEEKIyqkAjb9IQ0Oi9TdXRS+RdmpHpVD+IMGR2Kbs=;
        b=Y2dv+v5dkIAzONv9TPRC7w/+PzHLta6hYhIHZA/4acoueQatOfsspyB144denkYekh
         DuJ+mf9M+cyqWx//dBNZLvQTnyDQF06A5/ilUVpYmS5LgDZMWRDVwORd9kDBj+1CxTLY
         qOXWKtrgCb0n6HOCoYN3in5OJHIzAoBVOW6OtIv3/yeLi+0TJ1b+oM2Ib9nJ28ThxNwf
         y55psogOh1MG0bszg1YtBGJ0F4+fqqnxsNCm/nIkIoSSRIQ27vxyX391u3EtdCUyV6F6
         zqNKnm1ObLwQMYxYNLaareaMMPDTUIA6la9CXa5VTuPVyYN0dzSRgyyKWwz3knS0tl+r
         9KYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wyLEEKIyqkAjb9IQ0Oi9TdXRS+RdmpHpVD+IMGR2Kbs=;
        b=bXgp2HAnZKckOuAWauHKhipSIh3XOCSrRTup4TE+FPbnNNMQEWZm0ScUJmlqJRvOwU
         4vvuEIU1nrYqZNic/Me6L80+C+YI6L01ey2VgSJZztFFAysbCqEVgViRA5ifjNOBG4yF
         3xGRJ6w/nJH7sBkM7UZOx/bRaNeTPOQbROcyaBIvr/pMigavJ/bl9S03BGiNgpN/SU5G
         6OW8cQ/4R+ZYIkWLZgFJie/daKPxcRKirz7C5WjtKWnN4ct8XwGyYTq7u+T7o7gkFDb9
         ONsFUfjuJFEihkDqFySHSzbVCOv9DDB0AS9q+hLDJ8PwkNyC6Y2klfWCrrd/tZRGe1g/
         cs0Q==
X-Gm-Message-State: AFqh2krsKjb681tvENDTzEqr+4KooaVz87za5f3iIT4xAg16ur4xFSxH
        EhsCQ8vnTXlcPNKWpL941IR3X9v78snZn0Ir
X-Google-Smtp-Source: AMrXdXtJknrPqpsSn+QPvuHwcVlU6sMMhCqPKVdgnUPn88kT7MU7FTU5h/obHREzhpHJTWFCmh6zMA==
X-Received: by 2002:a05:6512:398c:b0:4ac:ec52:e063 with SMTP id j12-20020a056512398c00b004acec52e063mr7993973lfu.29.1672231417668;
        Wed, 28 Dec 2022 04:43:37 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c1-20020ac25f61000000b0049f54c5f2a4sm2647356lfc.229.2022.12.28.04.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 04:43:37 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] dt-bindings: ufs: qcom,ufs: document required-opps
Date:   Wed, 28 Dec 2022 13:43:31 +0100
Message-Id: <20221228124331.258416-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS device node on SC8280XP uses required-opps:

  sc8280xp-crd.dtb: ufs@1d84000: Unevaluated properties are not allowed ('required-opps' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index e53c6e203ac8..41ac2fe861f3 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -75,6 +75,9 @@ properties:
     minItems: 1
     maxItems: 2
 
+  required-opps:
+    maxItems: 1
+
   resets:
     maxItems: 1
 
-- 
2.34.1

