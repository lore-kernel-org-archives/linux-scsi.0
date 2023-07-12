Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE4CEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjGLKvF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjGLKvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:51:04 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB43011D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:51:03 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b9ecf0cb4cso12541445ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159063; x=1691751063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:resent-to:resent-message-id:resent-date:resent-from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gW/Rn79XK+Jon3f7wv6t0M4u9Do+bTGAD75094KkDlA=;
        b=CnHEI+ZRbTEFTT/uqbrQYngwSzFYwdWg9MvoM/tVHbE9Tgrm3RyjTS5W5AQAuAehd/
         ckPGCTJHmr8VJIInSfC4e7diYEqofCBmB+9JoZi41sZ/1d2N+Y8aMkXLvRhpaDZL5rgc
         XGHlsqsH3pRh9Mi+aJzQ8FvkxNXpflXRMap6aBIM7smQxhLVj0BOA/iraR1xLrbY7HBm
         DiBvc94UeOgzPtcDWd2O0/fJTj9D3AZHLo1vhFlGWa+TT7MG3GsfLVBmpe+PU46uyEWO
         tEeu21vDE7ERUz2BQHEFxNLRtYcs8sAyefqELlshRRHwZD6LItEF0Uv2qpncx/+rTVs9
         hxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159063; x=1691751063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:resent-to:resent-message-id:resent-date:resent-from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gW/Rn79XK+Jon3f7wv6t0M4u9Do+bTGAD75094KkDlA=;
        b=WNOX0jX4TmjbiTqgqzGFligUlSkVKh/dt642jsas9MM9nVa5rfHNJlVRB12XF7i2Vk
         +fHlGbcBUo7YLVX7EVG60R402zOeJCKaZQ64PHY0c3BETXTsc5ya9w5JQMLwwQXdAYvU
         YdeTUtPhGd5ErhUeWFtYqJHPTmg5/O/CBbOkwNZsfFYVqUgK97/JozyTJ6cT81lkb2ti
         S9ZTODQVACOS3DqC+/M04G1nm1cxUZS7F3XIZpZIzDFq/ZMMMdXesx3v96MPjvoto2jI
         uiTk8RlqRI4F6UecEYYGpCw/OKlRJXGRy65vbjr6ikaopUAkWXSqHeHvluRlJ+Dt3wDD
         6K1w==
X-Gm-Message-State: ABy/qLb4jgnw1P6RmBLHPx2s7spKPAHewWJd7PliWpXHzs9UYeqO1FUk
        D45nLeN4t2p9eLE1peYMraGpEVVcP5rH80LPuA==
X-Google-Smtp-Source: APBJJlEMejyLt7oPx5bQBOe2kVjjv/z3qUU90oBFHyaJg7hVJVIWIbfgU/DdSKe4a32pE0XZ1Q9xsA==
X-Received: by 2002:a17:903:11cd:b0:1ac:8475:87c5 with SMTP id q13-20020a17090311cd00b001ac847587c5mr16830895plh.56.1689159063233;
        Wed, 12 Jul 2023 03:51:03 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id b3-20020a170903228300b001b8528da516sm3653958plh.116.2023.07.12.03.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:51:03 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:32:34 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 00/14] UFS: Add OPP and interconnect support
Date:   Wed, 12 Jul 2023 16:01:55 +0530
Message-Id: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: K+GnWLBUEF/Z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This series adds OPP (Operating Points) support to UFSHCD driver and
interconnect support to Qcom UFS driver.

Motivation behind adding OPP support is to scale both clocks as well as
regulators/performance state dynamically. Currently, UFSHCD just scales
clock frequency during runtime with the help of "freq-table-hz" property
defined in devicetree. With the addition of OPP tables in devicetree (as
done for Qcom SDM845 and SM8250 SoCs in this series) UFSHCD can now scale
both clocks and performance state of power domain which helps in power
saving.

For the addition of OPP support to UFSHCD, there are changes required to
the OPP framework and devfreq drivers which are also added in this series.

Finally, interconnect support is added to Qcom UFS driver for scaling the
interconnect path dynamically. This is required to avoid boot crash in
recent SoCs and also to save power during runtime. More information is
available in patch 13/13.

Credits
=======

This series is a continuation of previous work by Krzysztof Kozlowski [1]
and Brian Masney [2]. Ideally, this could've split into two series (OPP
and interconnect) but since there will be a dependency in the devicetree,
I decided to keep them in a single series.

Testing
=======

This series is tested on 96Boards RB3 (SDM845 SoC) and RB5 (SM8250 SoC)
development boards.

Merging Strategy
================

An immutable branch might be required between OPP and SCSI trees because of
the API dependency (devfreq too). And I leave it up to the maintainers to
decide.

Thanks,
Mani

[1] https://lore.kernel.org/all/20220513061347.46480-1-krzysztof.kozlowski@linaro.org/
[2] https://lore.kernel.org/all/20221117104957.254648-1-bmasney@redhat.com/

Krzysztof Kozlowski (2):
  dt-bindings: ufs: common: add OPP table
  arm64: dts: qcom: sdm845: Add OPP table support to UFSHC

Manivannan Sadhasivam (12):
  dt-bindings: opp: Increase maxItems for opp-hz property
  arm64: dts: qcom: sdm845: Add missing RPMh power domain to GCC
  arm64: dts: qcom: sdm845: Fix the min frequency of "ice_core_clk"
  arm64: dts: qcom: sm8250: Add OPP table support to UFSHC
  OPP: Introduce dev_pm_opp_find_freq_{ceil/floor}_indexed() APIs
  OPP: Introduce dev_pm_opp_get_freq_indexed() API
  PM / devfreq: Switch to dev_pm_opp_find_freq_{ceil/floor}_indexed()
    APIs
  scsi: ufs: core: Add OPP support for scaling clocks and regulators
  scsi: ufs: host: Add support for parsing OPP
  arm64: dts: qcom: sdm845: Add interconnect paths to UFSHC
  arm64: dts: qcom: sm8250: Add interconnect paths to UFSHC
  scsi: ufs: qcom: Add support for scaling interconnects

 .../devicetree/bindings/opp/opp-v2-base.yaml  |   2 +-
 .../devicetree/bindings/ufs/ufs-common.yaml   |  34 ++++-
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  47 ++++--
 arch/arm64/boot/dts/qcom/sm8250.dtsi          |  43 ++++--
 drivers/devfreq/devfreq.c                     |  14 +-
 drivers/opp/core.c                            |  76 ++++++++++
 drivers/ufs/core/ufshcd.c                     | 142 ++++++++++++++----
 drivers/ufs/host/ufs-qcom.c                   | 131 +++++++++++++++-
 drivers/ufs/host/ufs-qcom.h                   |   3 +
 drivers/ufs/host/ufshcd-pltfrm.c              | 116 ++++++++++++++
 include/linux/pm_opp.h                        |  26 ++++
 include/ufs/ufshcd.h                          |   4 +
 12 files changed, 574 insertions(+), 64 deletions(-)

-- 
2.25.1

