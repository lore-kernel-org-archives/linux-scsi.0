Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16522C4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 12:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiKPMb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 07:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiKPMbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 07:31:01 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DAF5F6A
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:30:38 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l14so29678569wrw.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nJxt9QrKnPjdX4FLTqxuaRyNG0lj0vQQUUKMLh4iHk=;
        b=rIlo6EgH1ESzdhDRESiPYw617PV6yijGCXHCINyQ0owOLcAWoim0ahP6gC4RLTix9n
         V/x9m5pwlyv0bUtMKrMB0AN4Qd8MuOmGQMBSivtdsvSHWkO8p3IMgpQohZd+eLBg52M+
         28SikkR+0COasuKSGoFTj7lASWLSHY8QjcjuZJVxGNEUnnBbedGUGDTj8WqzscFFd0aR
         vnx4Xgst+Dwo9yZD0Vcs/s7CyiTL86fq7RmhTaQHbisF6ko7w7Z0dW70KsTPCsuMDr5/
         ZHdxuQoDhkDP0ATh7U1LwuXoDQ3aVOakSRrz3k7K4XbgoNi/BvXb0DKQjlKvmCQKMQO9
         ThHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nJxt9QrKnPjdX4FLTqxuaRyNG0lj0vQQUUKMLh4iHk=;
        b=gEvnVaLwr4SmKQwzktDnDGB3CU1zV5SLgUv7WR1YZG4CSZoaVY3PFU5Pv3Cfe/4zPg
         k+l66wkB16tQRhQ+uAq2OwLuPYkRPRnUFSWEaw25cHZ+dcCh7DQidXLTHvqqUu0gs2gF
         ZFxDJdmhUEs9ivlwiVp6wLVpCATCI6yfFbuXkYBIvsn06DfRiaqHPfdD0AqYnaUJUHnU
         InI+exrtAWAzBPxeRN3YX1I7PX9o2YG65o6zf0e5/ZmSFgB54ZdAE2m05zmSRxnKFqI7
         gxk6nPvWD6CokeYZR0GUPRoMJuhlBP4UJeP2c4awrC7Fzw8wn95jy4JlJXR4SnUXSVMP
         5etQ==
X-Gm-Message-State: ANoB5pkXmmVRcWuJyw81I2AYBVBz89BTEsHCerjEUAuRWrgrIJUTzkr3
        Wkng2VQzxIZqzAEOhkuauFfQLA==
X-Google-Smtp-Source: AA0mqf6PF+Qp6K54utHjDeimLXRwvJcd0r8AJLNshUMa5u5sOw0j9nHS3DLyQ5z5OkZwkLbBMYkGSg==
X-Received: by 2002:adf:e507:0:b0:236:6442:3a48 with SMTP id j7-20020adfe507000000b0023664423a48mr13432715wrm.41.1668601836673;
        Wed, 16 Nov 2022 04:30:36 -0800 (PST)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id l42-20020a05600c1d2a00b003cf4eac8e80sm2870991wms.23.2022.11.16.04.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 04:30:36 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [RFC PATCH 2/3] dt-bindings: usb: Add qcom,snps-eusb2-repeater schema
Date:   Wed, 16 Nov 2022 14:30:18 +0200
Message-Id: <20221116123019.2753230-3-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221116123019.2753230-1-abel.vesa@linaro.org>
References: <20221116123019.2753230-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add dt-binding schema for the Qualcomm SNPS eUSB2 repeater.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 .../usb/qcom,snps-eusb2-repeater.yaml         | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/qcom,snps-eusb2-repeater.yaml

diff --git a/Documentation/devicetree/bindings/usb/qcom,snps-eusb2-repeater.yaml b/Documentation/devicetree/bindings/usb/qcom,snps-eusb2-repeater.yaml
new file mode 100644
index 000000000000..f2b5ace675eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/qcom,snps-eusb2-repeater.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/usb/qcom,snps-eusb2-repeater.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Synopsis eUSB2 to USB 2.0 repeater
+
+maintainers:
+  - Abel Vesa <abel.vesa@linaro.org>
+
+properties:
+  compatible:
+    const: qcom,pm8550b-eusb2-repeater
+
+  reg:
+    maxItems: 1
+
+  vdd18-supply: true
+
+  vdd3-supply: true
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/spmi/spmi.h>
+    pm8550b: pmic@7 {
+        compatible = "qcom,pm8550", "qcom,spmi-pmic";
+        reg = <0x7 SPMI_USID>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        pm8550b_eusb2_repeater: usb-repeater@fd00 {
+            compatible = "qcom,pm8550b-eusb2-repeater";
+            reg = <0xfd00>;
+        };
+    };
+...
-- 
2.34.1

