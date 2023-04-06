Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4BBC77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 19:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbjDFTrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbjDFTrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 15:47:17 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241553C27
        for <linux-scsi@vger.kernel.org>; Thu,  6 Apr 2023 12:47:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j11so939804wrd.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Apr 2023 12:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1680810434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QvGwHE8712SOIXKJ/RICuObIng9cSrbflgnP7B8Dcg=;
        b=XhxatPnPUEgyW/8dv0QXuGkNPW6wibJ2hl8Z/1fUMqgaxvjrPhQMbOjCMis4w480En
         zAfjp18OG8yb77ILEIBfWuy+Dj3WG9t7PKd+so3aA9oF0JfB+5uykdq5FBMHP+pPNpZL
         jw0mIS4iMR3WwwEIaI6QIzwaxFhJ/lCRFUaO/lsE1e177DFiCp60pH/ypEvZCSTqokl9
         mafQOEl7IwtOetoJu5gUEXa6/Sez7JAp16bF/iUru2CVsX2pvZXxQm9SYwiWdf7OkEHq
         2dgc4rR6ZCwfJCzHIcdV03cWTVRSICmw8xRybkpNj+5nsW37S7i4Sebk/+fMZ0QJlEeT
         FLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680810434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QvGwHE8712SOIXKJ/RICuObIng9cSrbflgnP7B8Dcg=;
        b=oNx8RgH6NsTcJvunpFY4XZx+4HS0jLfwjQ2RTPmxH/h/G1KWxroVzSkuwG5SKQ+K/T
         deDwu2clnG30HYRyn7q1TzlYO2MaG9QVo/HGSu8NkaBx12SQUade0J1qCntjA7Pd8KFy
         mdbt/bkkHlvCZoZbRZkfR/6l6grpsxpvQNzviB8bNqNZGPN7+7H1M6QuH1xahuPHHkvO
         WeJ5zh2P6AKnTjNPVrpIOSEbyXBghqgHsaqS0igEm6hRYxFM0DikSGsj+iQ2TN0U35GX
         JQtvtIi97gsrN2y77WjTDmIci+OMEmSG9UOhbYO3jp9rdhkUop5/s9J512C3/6hbGKTK
         BwQg==
X-Gm-Message-State: AAQBX9fT8X83wCw7e8zFB+lVF0c/XWYosaQuuDkCYfrI4FIDKpntwx+3
        Ty+ui+RX9D1zCwYnLHlMFBm2Dg==
X-Google-Smtp-Source: AKy350Y6WVpr26JrjHi+2PDXFAstDUbANXU9nW0JbJo5gDYwejiR9/qIlYpT9L0PhWqFuI87C0d4Uw==
X-Received: by 2002:a05:6000:114b:b0:2ca:5c9a:a548 with SMTP id d11-20020a056000114b00b002ca5c9aa548mr7643576wrx.60.1680810434627;
        Thu, 06 Apr 2023 12:47:14 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:4793:cb9a:340b:2f72])
        by smtp.gmail.com with ESMTPSA id k15-20020a056000004f00b002c71dd1109fsm2593323wrx.47.2023.04.06.12.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 12:47:14 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v2 1/5] dt-bindings: ufs: qcom: add compatible for sa8775p
Date:   Thu,  6 Apr 2023 21:46:59 +0200
Message-Id: <20230406194703.495836-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230406194703.495836-1-brgl@bgdev.pl>
References: <20230406194703.495836-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add the compatible string for the UFS on sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index c5a06c048389..b1c00424c2b0 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -26,6 +26,7 @@ properties:
           - qcom,msm8994-ufshc
           - qcom,msm8996-ufshc
           - qcom,msm8998-ufshc
+          - qcom,sa8775p-ufshc
           - qcom,sc8280xp-ufshc
           - qcom,sdm845-ufshc
           - qcom,sm6350-ufshc
@@ -105,6 +106,7 @@ allOf:
           contains:
             enum:
               - qcom,msm8998-ufshc
+              - qcom,sa8775p-ufshc
               - qcom,sc8280xp-ufshc
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc
-- 
2.37.2

