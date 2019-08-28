Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50984C3A5A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 19:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2346E22CF8
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 19:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OXzfzF8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfH1TSC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 15:18:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39993 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfH1TSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 15:18:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so404527pfn.7
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2019 12:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vHp+AlJWbxwSEhvcybAlK/zvFEbIb+ho63MMWY45s5U=;
        b=OXzfzF8SHK5OVa1FXapO5oDS5zvMZGPSS9RJWui7hSNBkf4ory1gv0WNv6XKxIJ7rP
         0x1eIiwgvL0/ZU9x0ljGPdVoCDiejKmy92yBw/kXT3Gx6hrJK9vGNWCIeWeFs9t6potT
         r1pIx37KVjyTFCkjkSf32IMnD8jHtn28GUXVjqi/Gl1uS7IvguN7uqQS0unKPritvTba
         XTfw91vQOs2MoxPwx9i0LC6p/8rDJFj8YFABW8SLcTbtjAjOexvJdrUHD+oXBc7WiVbt
         SP+Yny2sx/cBesb+y1XpGnT7bOe8NjLz1PT7XVFfeNLryROzcooQ5b4b7wC/JsgoGm5j
         iryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vHp+AlJWbxwSEhvcybAlK/zvFEbIb+ho63MMWY45s5U=;
        b=bx0T5QTqn6WZPOjVagmU/fLuE4UKCXQahDfMebX5W4L4bgkam1Vv1h5V6cYQM7QT/6
         tszPxK+EJU/QfyIC+TCiJEBFsQ5mfcf1XUnKv8ts/ZlXf/jyvMcwkvw8VV/Ss/HpRqBP
         lOO4lHzhFc6xpLfKgSkIDpPpR1Qw8F0BJcFKn6H1o2lw7YFWf+uetkcVIbysAYUf01R3
         4ffFsx+jG2/n4GGTYrapXtSoVZckygoMDV7PIVpzb8vjzZ7+yL5JZ0g1Nxxk9udI6buQ
         jf4T4m2FDgSVV4MzOhxjtVK9xwOecaEwUNo0YvvEB7D4qKFxsmeE6cZ6TKRe0HgspaYJ
         dVZg==
X-Gm-Message-State: APjAAAXoI8TB7JsEFOMMKQ/TPGTBuPV44KuonQidf1V044kZQETaxT+Y
        QQFT5VRGtFOKPoqYQM9bFZY1zA==
X-Google-Smtp-Source: APXvYqx067TVuFdfipJijenpJw8x/0zHsb2O7KTSR5Ivwe9Nw0BicO9ZvzvDmQ1alVdoCVidC06fWw==
X-Received: by 2002:a63:4e60:: with SMTP id o32mr4933655pgl.68.1567019880871;
        Wed, 28 Aug 2019 12:18:00 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id n128sm122717pfn.46.2019.08.28.12.17.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 12:18:00 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Gross <agross@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bean Huo <beanhuo@micron.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v4 0/3] Qualcomm UFS device reset support
Date:   Wed, 28 Aug 2019 12:17:53 -0700
Message-Id: <20190828191756.24312-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series adds a new ufs vops to allow platform specific methods for
resetting an attached UFS device, then implements this for the Qualcomm driver.
This reset seems to be necessary for the majority of Dragonboard845c devices.

Bean requested in v3 that a software fallback mechanism, using
UIC_CMD_DME_END_PT_RST. I have not been successful in validating that this
works for me, so I'm postponing this effort and hoping we can add it
incrementally at a later time.

Bjorn Andersson (3):
  scsi: ufs: Introduce vops for resetting device
  scsi: ufs-qcom: Implement device_reset vops
  arm64: dts: qcom: sdm845: Specify UFS device-reset GPIO

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  2 ++
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |  2 ++
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts       |  2 ++
 drivers/scsi/ufs/ufs-qcom.c                   | 36 +++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h                   |  4 +++
 drivers/scsi/ufs/ufshcd.c                     |  6 ++++
 drivers/scsi/ufs/ufshcd.h                     |  8 +++++
 7 files changed, 60 insertions(+)

-- 
2.18.0

