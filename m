Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F597C001DE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjF0I2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjF0I2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:28:13 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C9D19BA
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:28:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-991e69499d1so157225966b.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687854486; x=1690446486;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5S8b9e8wV8xKSwJr6FIOGYxZbEUIfMfKiefXhXE2fI=;
        b=WvS4ixi7RLF9rs8ir6CIdtvBRGxXJkwk9dQyHDgQkJKLtSWcLoLSXjySELrY9z/kAi
         gS5y+YYHTG38DZ2+ZzUlDVrdm9dJ8/cQ1gjFDtguUio2eM/J+3LAr82eMqnU0Xeu7MV9
         2VIm96wr6fKE44OvL/K2YZm2TZphKBp8XEfzt7JnV+wEoPIm3V0WttneYB10aStr4JZ5
         JoHYr+enBDX3UjZV+qS/8MEfnBESnJCKgLeojtjBZsr/91x5gkPaEJMQwpCfKgkfsnIj
         1KjKt6RLusvZPnx95fM/VsGfrsx7Ut29u7EIoMlZxUoptutJTHoCO8+Vdo/b89QVbqFa
         Az0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687854486; x=1690446486;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5S8b9e8wV8xKSwJr6FIOGYxZbEUIfMfKiefXhXE2fI=;
        b=WrYoIiVeTuNHIcmB9kgGId8NooQ/w9iHVdGqRDzBK7+JZmWWb2wyUo/xTcywF/M4hc
         D0COOiRcNmAU5aYyduKB2uDJ5TzJxAtqoiPNdtEGjiyd1Oc71f0XdNm65ORWcxVe1/xW
         bgxCiE0ThTFbJ3jVDcRcrTp4UOafEU/sb/PLmwWDISUCl5swNRLbLqcqkanWheAt7jDk
         UiuS29aph5hX+hBHhfbXBUFx8Fs60G4x2AmTQ/Zw2IiPwI2nSNfGOdkt+HdyA2k7MeGH
         BnSeddCyiYVHEVthqkvKtOQr9CLoYk62uIDwbBanRS+K27iWPY0LJYDJQqhVOo8ykpnb
         5Z7Q==
X-Gm-Message-State: AC+VfDwaRXIzXCbc5E3FDvbs0kLBCeCh0oUvnLk1LFIW+ZjLk2xMOWTO
        s9Pny1yL4J4D9tPvQxipv3JZZg==
X-Google-Smtp-Source: ACHHUZ47LEa3Ui0Hkcok9eFLfT/UA+Fa2+OJf8EMfROejOK13tBI/LP+tNrmfvjx6Q+gBgR/IdOSUw==
X-Received: by 2002:a17:907:724c:b0:991:f427:2fdf with SMTP id ds12-20020a170907724c00b00991f4272fdfmr2659833ejc.76.1687854486214;
        Tue, 27 Jun 2023 01:28:06 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id kt19-20020a170906aad300b009894b476310sm4253038ejb.163.2023.06.27.01.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 01:28:05 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Tue, 27 Jun 2023 10:28:01 +0200
Subject: [PATCH v5 1/5] dt-bindings: ufs: qcom: Add reg-names property for
 ICE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221209-dt-binding-ufs-v5-1-c9a58c0a53f5@fairphone.com>
References: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
In-Reply-To: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
in the bindings so the existing dts can validate successfully.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index bdfa86a0cc98..4cc3f8f03b33 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -79,6 +79,11 @@ properties:
     minItems: 1
     maxItems: 2
 
+  reg-names:
+    items:
+      - const: std
+      - const: ice
+
   required-opps:
     maxItems: 1
 
@@ -134,6 +139,8 @@ allOf:
         reg:
           minItems: 1
           maxItems: 1
+        reg-names:
+          maxItems: 1
 
   - if:
       properties:
@@ -162,6 +169,10 @@ allOf:
         reg:
           minItems: 2
           maxItems: 2
+        reg-names:
+          minItems: 2
+      required:
+        - reg-names
 
   - if:
       properties:
@@ -190,6 +201,8 @@ allOf:
         reg:
           minItems: 1
           maxItems: 1
+        reg-names:
+          maxItems: 1
 
     # TODO: define clock bindings for qcom,msm8994-ufshc
 

-- 
2.41.0

