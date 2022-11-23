Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A797DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 07:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiKWHwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 02:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbiKWHvk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 02:51:40 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1177BFC701
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:50:34 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g5so112438pjd.4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pljquG0hkdcBPdXIDtkq1v6aN8iyQB1w4S/2qg/cek=;
        b=riPHLLSPLvU4P+d6u9OTtrSXJONvT4DAWehSTt8MlAkRICfZiHBToxi4kDEWfviIsZ
         h4GppwDuuDtXzzjSle39EzY+sWR9P2DfAoziF1MiznuN458awUnLiX/RsQVdSjhwa9Ms
         N7ygqjsasMBdsGnhMbFuz8KQKDG3sgS/nb0h0LVdwiKMu8JgiDY8oI8doDST/Z72ZCYT
         tOmvkb6tOyXbn1sYrt5J6aXGX7NYMQ5KuIDCIMqYJRE/bssq6GURpxVq7JGlg2buknlK
         VWlCBZ2geenSJVXVHz6jVyyq2m82Ua+nFlNCMkC42mjSdkzzVQp3p4YoKphWcZ+5LkHO
         vXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pljquG0hkdcBPdXIDtkq1v6aN8iyQB1w4S/2qg/cek=;
        b=FCK4ibpFEvcF8yf3lCv5xsnHO7AKkhg0nmNpKAw38l5R6n8FoXb+5/IrLGcSPSDYdn
         ewZeE+Ks0D7lNrZVA7J3WEdYaH1NARwGMdsAoLYSYGkZ6Np8ACzC0tYuZd2R/4RtvH9S
         5ZUgjlz6mtPY9tgq3oCwjWInu2tkdJgsBNzDvdidp1JpRvy7YlXnt8JFN+eKfwkZiesQ
         TsFm1d8ft3fMaqG7REaD6dukoIKTJDL7pqzNsnC1Ft9Iu0gndS6XTXsl7vSysR61jwLd
         kUYyj3YfxPdI/DNoRgb/wAJC2PJgASnsuBBGv+SZ95QYVep8T3ggWfePwY3E9HvZgEFc
         8lkg==
X-Gm-Message-State: ANoB5plweeZcJFs30Tn6eeh4cjY67AZem2ZG2UbtJhnNnmJvTCc6jloO
        UQ8Vy5eMAQVKP3FZJEEN3Mox
X-Google-Smtp-Source: AA0mqf4oJohuIJiFaMQ1NxpUqgruyQRg1aKK4w0wEW+uEmRdgL4uVGadHWpYVlHujlCe+RkwM2jNBQ==
X-Received: by 2002:a17:90a:307:b0:213:ff80:b37f with SMTP id 7-20020a17090a030700b00213ff80b37fmr35775172pje.118.1669189833465;
        Tue, 22 Nov 2022 23:50:33 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.0])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902a51000b001869f2120a5sm13334059plq.34.2022.11.22.23.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:50:32 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 20/20] MAINTAINERS: Add myself as the maintainer for Qcom UFS driver
Date:   Wed, 23 Nov 2022 13:18:26 +0530
Message-Id: <20221123074826.95369-21-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
References: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qcom UFS driver has been left un-maintained till now. I'd like to step
up to maintain the driver and its binding.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf0f18502372..149fd6daf52b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21097,6 +21097,14 @@ L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/ufs/host/ufs-mediatek*
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER QUALCOMM HOOKS
+M:	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
+L:	linux-arm-msm@vger.kernel.org
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	drivers/ufs/host/ufs-qcom.c
+
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
 M:	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
 L:	linux-renesas-soc@vger.kernel.org
-- 
2.25.1

