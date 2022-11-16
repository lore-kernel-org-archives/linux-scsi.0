Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2ECC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 12:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiKPMVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 07:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiKPMUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 07:20:35 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FBA1FD
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:18:24 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o30so11769833wms.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CexamFfG/FS3ngrrhitZZy7mpo4nC1L6pbUeLp3AZOw=;
        b=IQjngCj4wfNPukaelqxkn801Xy0n+XGs7+sLDNi04oV/9sqU681Ttlp6daRmvopjZf
         I/ajH5ntEj3VXVASzTkRifAA7GY2f4l/ZOkVTm0bmCHh6Uuyv9zHJFK7mgV+l7bAIjEV
         3esZRwGrxWnXbhN4U6JY49Op29UbveXSMv7cTx/G/cixGNEM26bAsOYxOh7dNNnShvtG
         ajiAKSBLb5A9dTXhvgFsHfSB7MWTwFDP4pGmWQgn5bD/42/+sPq1vOMkyMo4KPFOVFYX
         obU8HFVGUDGe6SqAk/NEr2lxuiK9s3QobFcKSfipDz7YE+1YPO1jG9p5uoGFh+Ndiust
         F7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CexamFfG/FS3ngrrhitZZy7mpo4nC1L6pbUeLp3AZOw=;
        b=5TatbgAvuV6GMkdk8Durz/vZrLMmVWkgUalC3FZKxVXHDIQMtLHLxvcATKXkl1wvBe
         oIZ0pgUA0j5ErFJU85/wLU9+yKt70hhhLCxcFzg+hNJ5EehKfXKvNYAEIgpXW6cddwPm
         dsPkCjZog7cjZzuV2Z8CKscDDmwgQ+UZMSNhgXqZU1fKblVWYZRcUbuRg3tmbJspW4/5
         QP45LnRRxf8YwMCqx4L+eTvC+3mQROtLGFDO/W4Q1CG/IUwEjfUhFSC6SYd/FLwzsKMg
         UTfLj1GLLg+XY5otexdeJBvq2gtw5dej08kN5hCX98XJMi3r/lvcV/MQ93P39kH5a+hr
         BB2Q==
X-Gm-Message-State: ANoB5pnuVae6Cc6QxNgV0hwsLQAzl3Eu5TVCcICXlU7AoW4eVMBgXhAH
        fZGE/IuASOUzmGRjOhoZSFen6g==
X-Google-Smtp-Source: AA0mqf7mxdTG3n6ju8hRQCVZ7ABXa/QvWKlq7iL5OlfERBYM2FmYxv/F53D5YL8+EN9TQB69Wl+Tmg==
X-Received: by 2002:a05:600c:5014:b0:3cf:a18d:39a4 with SMTP id n20-20020a05600c501400b003cfa18d39a4mr1908881wmr.125.1668601102577;
        Wed, 16 Nov 2022 04:18:22 -0800 (PST)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d42ce000000b00241a8a5bc11sm1090359wrr.80.2022.11.16.04.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 04:18:22 -0800 (PST)
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
Subject: [PATCH 0/2] ufs: host: ufs-qcom: Add support for SM8550
Date:   Wed, 16 Nov 2022 14:17:30 +0200
Message-Id: <20221116121732.2731448-1-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset adds UFS HC support for the new Qualcomm SM8550 SoC.

This patchset depends on:
https://lore.kernel.org/lkml/20221029141633.295650-1-manivannan.sadhasivam@linaro.org/

To: Andy Gross <agross@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
To: Avri Altman <avri.altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>
To: Rob Herring <robh+dt@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


Abel Vesa (2):
  ufs: host: ufs-qcom: Clear qunipro_g4_sel for HW version major 5
  dt-bindings: ufs: qcom: Add SM8550 compatible string

 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 drivers/ufs/host/ufs-qcom.c                         | 4 ++++
 drivers/ufs/host/ufs-qcom.h                         | 2 ++
 3 files changed, 8 insertions(+)

-- 
2.34.1

