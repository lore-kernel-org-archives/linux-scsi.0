Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCAFFA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJaSCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJaSCj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:02:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144A113D6F
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:02:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o7so7838556pjj.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lUeGzsrZuppVjIQtllMBu80KGrOeXpmn2SHkGIO0dZI=;
        b=PfJeKC0nW0q3FOQ1HV8xzNPscrseO9wqTqzlujbVfJPQuw7OoUcyI8/HA/e6PYuwT9
         3NterFjq9Q098c76cYnNqbeUtlN+WMHXuh7lACe917zc5WAf39BIAwfLrMwS2/aQsYZD
         B/OV3MzAXaa5x35p7F+o9zFuK0yDd5yBkAWrVkResNl6h/sBsLhwxS3rkKfV9dj8UdIC
         DW3vG619Oo5+c4yO875QCVLCP4aDNBfHKzCERADUuVj7MvxDl+0UGwOODaIF28SjJfdf
         1X9F3SBkWggTSH/xUQYCndFrMatu+5Rcoxkbt8VfJQLekIMJ/7qVYlfL7fC53l2wotZ3
         LDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lUeGzsrZuppVjIQtllMBu80KGrOeXpmn2SHkGIO0dZI=;
        b=KvmMfhOeR3I8IllleVFvPamWfchoO2dmuOzhjV/hoG9l5EI0M5uA8/bW0vFCYRB4wt
         e0PTtykcxI/k7W4RTbjnle8Bf+whzLoo97MyQCAMFXUoyrf5BB88JN+5hGVT/diqZqew
         5RfH0nfYruVl2cTpsdQUlUhSluM4lN2kkbcsHR0Ac3PglWTqvi87WRs7meR/8/kaYXtq
         MVPrKy1dmLNvezbup8IB/mGYxGqDM/JLQ00rw1q81brGw1/5Uaobtm5rhbVmjXOFdISX
         7iaJ4GiszR6LZP5KLyETlwbhJMgxgiojZwsSryWr+4QnB9OsjUXfdUORnUxIwFw3Sm8k
         3NPQ==
X-Gm-Message-State: ACrzQf3McddHbP0BSTnqFRrBJQnCnCx97rGMLuCpTYblIIGGP8QvevFY
        7QIc1DLYD4ImlqSV3lf91869
X-Google-Smtp-Source: AMsMyM6KutCiKgVhfqnh64n0pNMgZINaIjYKukeENSzy9/oeepbkEm7QVIBjPIPLzso18X716IcE3g==
X-Received: by 2002:a17:90b:153:b0:213:b853:5db1 with SMTP id em19-20020a17090b015300b00213b8535db1mr13077729pjb.168.1667239356552;
        Mon, 31 Oct 2022 11:02:36 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.221])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b00186c6d2e7e3sm4742224plb.26.2022.10.31.11.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:02:34 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 00/15] ufs: qcom: Add HS-G4 support
Date:   Mon, 31 Oct 2022 23:32:02 +0530
Message-Id: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

This series adds HS-G4 support to the Qcom UFS driver and PHY driver.
The newer Qcom platforms support configuring the UFS controller and PHY
in dual gears (i.e., controller/PHY can be configured to run in two gear
speeds). This is accomplished by adding two different PHY init sequences
to the PHY driver and the UFS driver requesting the one that's required
based on the platform configuration.

But this requires both the UFS controller and UFS device to agree to a
common gear. For finding the max supported gear, a separate register is
used for the UFS controller and devicetree is used for the UFS device.
Based on the max gear of both, the UFS driver will decide which gear to
use during runtime.

This series has been tested on Qcom RB5 development platform powered by
SM8250 SoC that uses HS-G4.

Merging Strategy:
-----------------

The PHY patches are expected to go through PHY tree and UFS, MAINTAINERS
patches are expected to go through SCSI tree. Finally, the binding and
devicetree patches can go through ARM MSM tree. There is no build dependency
between the patches.

Thanks,
Mani

Changes in v2:

* Collected reviews from Dmitry
* Renamed "max-gear" property to "max-device-gear"
* Used min() for deciding which gear to use instead of open comparision
* Added comment about the old register name

Manivannan Sadhasivam (15):
  phy: qcom-qmp-ufs: Move register settings to qmp_phy_cfg_tables struct
  phy: qcom-qmp-ufs: Add support for configuring PHY in HS Series B mode
  phy: qcom-qmp-ufs: Add support for configuring PHY in HS G4 mode
  phy: qcom-qmp-ufs: Add HS G4 mode support to SM8250 SoC
  phy: qcom-qmp-ufs: Move HS Rate B register setting to tables_hs_b
  dt-bindings: ufs: Add "max-device-gear" property for UFS device
  arm64: dts: qcom: qrb5165-rb5: Add max-device-gear property to UFS
    node
  scsi: ufs: ufs-qcom: Remove un-necessary goto statements
  scsi: ufs: ufs-qcom: Remove un-necessary WARN_ON()
  scsi: ufs: ufs-qcom: Use bitfields where appropriate
  scsi: ufs: ufs-qcom: Use dev_err_probe() for printing probe error
  scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
  scsi: ufs: ufs-qcom: Factor out the logic finding the HS Gear
  scsi: ufs: ufs-qcom: Add support for finding HS gear on new UFS
    versions
  MAINTAINERS: Add myself as the maintainer for Qcom UFS driver

 .../devicetree/bindings/ufs/ufs-common.yaml   |   5 +
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts      |   1 +
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 350 +++++++++++++-----
 drivers/ufs/host/ufs-qcom.c                   | 175 +++++----
 drivers/ufs/host/ufs-qcom.h                   |  68 ++--
 6 files changed, 390 insertions(+), 217 deletions(-)

-- 
2.25.1

