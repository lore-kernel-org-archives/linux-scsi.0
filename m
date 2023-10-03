Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7CFE7544B
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 11:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbjJCLMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjJCLMx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 07:12:53 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E70BD
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 04:12:50 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c5cd27b1acso5644995ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696331569; x=1696936369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9tBABO7GPyJwZw3Nk8JykIKdvU51HhvEtWXYIL3h5YI=;
        b=PgHhF3Sdw9k3XNoVvq2aN22cVzV+dotmdsIJfOMyVWL16ZstbTSeiMCiVTkHhsrocc
         WQHs6RdXnHZv+w0Fep/WQPM4Gkls3mJh8Qa66x25yK/SgPEIvE5XPvTqxBSZUcWAtUfz
         +8vkxO0+i5KldeIffnIDVOkhqsn54N1FpKtErNBORz8FHt9SJm6RGrG3MjAfIV8tZ9QH
         men/1PgZ+mKutOw55lCn32r1b7yoXEMfzgfgmAT7GU7T4RqSzWAMLIMnJT78bR0I7umQ
         FQOMvFZjna5oqVbG6jMgHQDqq7hOm62dsHIEkgKHQeL5W97qrcM16Pl/iGuJpf4D+zSb
         iTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696331569; x=1696936369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9tBABO7GPyJwZw3Nk8JykIKdvU51HhvEtWXYIL3h5YI=;
        b=Zzlg5Uw5WHpKZTP1YL/legkwwcYmELT1nOnUBICDA9gDkqy2/VhfG0579poO09/KAQ
         Xz0cJJC3jYxgbTZq8c8ZKcX+4su0IKrzBmgFqT8JjybCwyhq7DzgKYj4cCb/KZylI5ZH
         ooghiF1j5YTag4W/QKncrHiAnSuK2oW9Ce0Tf3AQkONZCqSdnGxEWCp6Kozaf1BSZteM
         rlnLU9VwJGnbR2OA6WIsyTVmo6pw19liA6ksS9NbRH5PW+h4d7BBQB5r6li70QjOl4Ub
         XiG4u3DHsUce+LsyOzrLwF+N4hhv1k6ZM57C9Dk3agm1Qb5aQUZdpLApVKFxf7PL8g6j
         WirA==
X-Gm-Message-State: AOJu0Yxnk+Uz35N1vwJCzyvHmxg34FnB1uqRPyUbGgX4a5WGgHluAaml
        b8fymiGeMPt2uQk/1w/aJfVi
X-Google-Smtp-Source: AGHT+IHzp+SOMu/BZxx+P/nC6osmYhEk82BGK9A+pP8pfPwut57hIo4DZE6nffFz8+zx+Z9d247D5w==
X-Received: by 2002:a17:902:c948:b0:1c4:4c73:94e6 with SMTP id i8-20020a170902c94800b001c44c7394e6mr16668612pla.51.1696331569220;
        Tue, 03 Oct 2023 04:12:49 -0700 (PDT)
Received: from localhost.localdomain ([117.217.185.220])
        by smtp.gmail.com with ESMTPSA id d9-20020a170903230900b001ab2b4105ddsm1250328plh.60.2023.10.03.04.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 04:12:48 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v4 0/6] UFS: Add OPP support
Date:   Tue,  3 Oct 2023 16:42:26 +0530
Message-Id: <20231003111232.42663-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This series adds OPP (Operating Points) support to UFSHCD driver.

Motivation behind adding OPP support is to scale both clocks as well as
regulators/performance state dynamically. Currently, UFSHCD just scales
clock frequency during runtime with the help of "freq-table-hz" property
defined in devicetree. With the addition of OPP tables in devicetree (as
done for Qcom SDM845 and SM8250 SoCs in this series) UFSHCD can now scale
both clocks and performance state of power domain which helps in power
saving.

For the addition of OPP support to UFSHCD, there are changes required to
the OPP framework and devfreq drivers. The OPP framework changes are already
merged and the devfreq change is added in this series.

Credits
=======

This series is a continuation of previous work by Krzysztof Kozlowski [1].

Testing
=======

This series is tested on 96Boards RB3 (SDM845 SoC) and RB5 (SM8250 SoC)
development boards.

Merging Strategy
================

Since the devfreq patch got an Ack from the maintainer, either it can be merged
to scsi tree with rest of the patches or merged separately through devfreq tree.

Thanks,
Mani

[1] https://lore.kernel.org/all/20220513061347.46480-1-krzysztof.kozlowski@linaro.org/

Changes in v4:

* Rebased on top of v6.6-rc3

Changes in v3:

* Rebased on top of linux-next/master tag: next-20230731
* Dropped the already applied patches (dts, opp binding and framework)
* Moved the interconnect patches to a separate series:
  https://lore.kernel.org/linux-scsi/20230731145020.41262-1-manivannan.sadhasivam@linaro.org/
* Moved ufshcd_opp_config_clks() API to ufshcd.c to fix the build failure
  reported by Kbuild bot: https://lore.kernel.org/all/202307210542.KoLHRbU6-lkp@intel.com/
* Collected Acks
* v2: https://lore.kernel.org/all/20230720054100.9940-1-manivannan.sadhasivam@linaro.org/

Changes in v2:

* Added more description to the bindings patch 2/15
* Fixed dev_pm_opp_put() usage in patch 10/15
* Added a new patch for adding enums for UFS lanes 14/15
* Changed the icc variables to mem_bw and cfg_bw and used
  the enums for gears and lanes in bw_table
* Collected review tags
* Added SCSI list and folks
* Removed duplicate patches

Krzysztof Kozlowski (2):
  dt-bindings: ufs: common: add OPP table
  arm64: dts: qcom: sdm845: Add OPP table support to UFSHC

Manivannan Sadhasivam (4):
  PM / devfreq: Switch to dev_pm_opp_find_freq_{ceil/floor}_indexed()
    APIs
  scsi: ufs: core: Add OPP support for scaling clocks and regulators
  scsi: ufs: host: Add support for parsing OPP
  arm64: dts: qcom: sm8250: Add OPP table support to UFSHC

 .../devicetree/bindings/ufs/ufs-common.yaml   |  36 +++-
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  42 +++-
 arch/arm64/boot/dts/qcom/sm8250.dtsi          |  39 +++-
 drivers/devfreq/devfreq.c                     |  14 +-
 drivers/ufs/core/ufshcd.c                     | 179 ++++++++++++++----
 drivers/ufs/host/ufshcd-pltfrm.c              |  78 ++++++++
 include/ufs/ufshcd.h                          |   7 +
 7 files changed, 332 insertions(+), 63 deletions(-)

-- 
2.25.1

