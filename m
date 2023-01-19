Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5484CC004D4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 15:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjASPON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 10:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjASPOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 10:14:12 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A220A66EE4
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 07:14:11 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so3792850wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 07:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HD3jSa6zl99b1k1iQFDMjEt5nT4zeae/hJhML5gvv2o=;
        b=FxNqCf7FYUdZoUA8KDytXhw/BOb3S+qc4gbNrZ37p892yoDAYgsyZzjNgpFnRyqlPR
         N+0cKqDvKFNo98kWKPg/XJLV1UQPr0sddD1k/bItHmQnxFn8XJ1p8TE+RWLX2MWKIhRR
         +gNR+BDWKwVU26J1wR18s2ZUDFQ8RjVvoeY2vA5iFYj7kfm3Z9erAJd1zHvczOSI/aux
         rvJg64HFjZ/wi5MXUPkdLltIqiyijcquE2UckRHTi4BRXhoY4YRASm9AqCSnjY/RYQI3
         F/HKzr8iETMLtDhQ7pVS8iIbS5/P62nxTwBvjwGNrvRs0YyfdfioED9mBNlIA+RtXIDI
         dNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HD3jSa6zl99b1k1iQFDMjEt5nT4zeae/hJhML5gvv2o=;
        b=YRUSawsimVXtGutgskeC9n9MLcTds0HUBtPb8I3ujFqfoRjlznESSTWgIHNwwm6Zpl
         M2saS1pSig1SbQ+lvcwENoW3fpu/hhA7aN4FOAZkKbruwMtmyZ8bVof2x9woKNcTTj1m
         DH83nFUJ4Kq3eGhrU6TMgLn7DeY7UuDeXoil6u/kH9LGhHNE3wMFfUOcdjBjw2n0m/8N
         4KqOO/V4M1I8lGaYQt2KOzPMwLswauaIIxQqGOF6mVgrsWw2INv59y4LN3Xw9jUkuK8N
         UGneVuLDC1WGKhtg4YFqhJ6wA5AmfcX4TPQjiuM1XDTfYqgUbVPc6TJR8s878rYiQgBL
         hReg==
X-Gm-Message-State: AFqh2kpDS+xfGd6vvSGrJMsAx8Oxhc+FhJGq/6EO2ScQ56joCDnJoNm1
        GfmInqO1/ql8WhmPU4lEGb9j/A==
X-Google-Smtp-Source: AMrXdXv9erm4zRyGtwJNCFo1mbvzOCOLFjZuhebCW2xo4EiMv+d2zQZFAHx0NYxVXcgYc2/G9z3ZfQ==
X-Received: by 2002:a05:600c:3596:b0:3da:1357:4ca2 with SMTP id p22-20020a05600c359600b003da13574ca2mr11196032wmq.11.1674141250122;
        Thu, 19 Jan 2023 07:14:10 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c379000b003db15b1fb3csm4566605wmr.13.2023.01.19.07.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 07:14:09 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] ufs: host: ufs-qcom: Add support for SM8550
Date:   Thu, 19 Jan 2023 17:14:04 +0200
Message-Id: <20230119151406.4168685-1-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset adds UFS HC support for the new Qualcomm SM8550 SoC.

The v1 was here:
https://lore.kernel.org/all/20221116121732.2731448-1-abel.vesa@linaro.org/

Changes since v1:
 * replaced REG_UFS_PA_LINK_STARTUP_TIMER with REG_UFS_CFG0 and added a
   comment saying that the older version use the first name as reg name
 * moved QUNIPRO_G4_SEL in a separate section dedicated to CFG0 bits
 * forces the update_link_startup_timer condition to be skipped in case
   of HW version 5.x

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
  scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5
  dt-bindings: ufs: qcom: Add SM8550 compatible string

 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 drivers/ufs/host/ufs-qcom.c                         | 8 ++++++--
 drivers/ufs/host/ufs-qcom.h                         | 6 +++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.34.1

