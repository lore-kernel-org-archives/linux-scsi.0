Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FE1C77B6E
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 19:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjCaT7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCaT7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 15:59:34 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9039C18F
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 12:59:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t4so18343765wra.7
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 12:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1680292772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZ4tY9ZYWjx+L/GieKh5Pi36vPyy7QPV1ldHuKzb5+s=;
        b=L3lmJ5z640wRzUBye8uUTVuzCzoYv4SJvO8Se0nlyyvbcnVcRskZ0cG5JeZbxW+GCH
         5fdlaKsLiDHgPWuMqm8GefeOXEHENJZanI4inA/wabzA/ncA10bbj5i343n1lbUxwDNC
         eMfKlH8HXgU5L3erhaIpY4mXcLd4KttOuvoGOyqbIUWDDCx6k4EwHf14rrS7MvBuUYOw
         z2nln4YQ69ilNrUY4VFW67QyeaYzK5P8TE8h0eRA/gknWVC4jR33obiB83UF2+1v5hin
         XXGj37mnQyb1yin+aS0atsQ15cDlQ8HvjUT0QwluUvIpdo7RT80R9HlIZoKtQZWJAk05
         qEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680292772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZ4tY9ZYWjx+L/GieKh5Pi36vPyy7QPV1ldHuKzb5+s=;
        b=UAi/L8G7qsMIIpmyt9XjEAYrRp5KaoeZiZCh1apLo0bbtT31r3vBbDaFL6A1JPrF4l
         ZMOM+M3Z+9R7sKQXkgRTZQVf4GkkmCoxlSGeqHXJJE0aKtotmZ5jSW/kthbFXrPZGZMo
         MBhGPOJiQ0bJmU6fxegz4q6U5xOeQJswFd1ee6YgVU7kaiy8ua56RkUmum1y3A9XDJTr
         eObUiRZ9XqfFQmNDHK1Tk6evIbinwOjjTng6vSlJBbFbcQNPChywrurIQ70tokqXpJLx
         4dmjFfPTaVEeEmN/YROaJ9iXzOGj+bTYf5DYRFFuyQE8Lvb687eUlJmP3CPatVwGN6nF
         hkFw==
X-Gm-Message-State: AAQBX9d8XIN6zRhzkCqDU2wCakIYKhDwXtqJUX9IAbTRbTyGnbENs3Y8
        3Oy642yD41rKlPw97SiYhg4MQw==
X-Google-Smtp-Source: AKy350YvQk00Iyf+Kahd6DxXZ7ieQXGXto0RYjH8G4uQwsyXBRPgD3ySLFWoWor+u6jzuP7Tjwr/HQ==
X-Received: by 2002:adf:eb0b:0:b0:2d8:4e4:8cf1 with SMTP id s11-20020adfeb0b000000b002d804e48cf1mr19296816wrn.21.1680292772089;
        Fri, 31 Mar 2023 12:59:32 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:1dc:d1f:e44f:2a1d])
        by smtp.gmail.com with ESMTPSA id c13-20020a5d4ccd000000b002cff0e213ddsm2990286wrt.14.2023.03.31.12.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 12:59:31 -0700 (PDT)
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
Subject: [PATCH 1/5] dt-bindings: ufs: qcom: add compatible for sa8775p
Date:   Fri, 31 Mar 2023 21:59:16 +0200
Message-Id: <20230331195920.582620-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331195920.582620-1-brgl@bgdev.pl>
References: <20230331195920.582620-1-brgl@bgdev.pl>
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
index c5a06c048389..4abd3c0950e2 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -27,6 +27,7 @@ properties:
           - qcom,msm8996-ufshc
           - qcom,msm8998-ufshc
           - qcom,sc8280xp-ufshc
+          - qcom,sa8775p-ufshc
           - qcom,sdm845-ufshc
           - qcom,sm6350-ufshc
           - qcom,sm8150-ufshc
@@ -106,6 +107,7 @@ allOf:
             enum:
               - qcom,msm8998-ufshc
               - qcom,sc8280xp-ufshc
+              - qcom,sa8775p-ufshc
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc
               - qcom,sm8450-ufshc
-- 
2.37.2

