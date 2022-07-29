Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06F2C19F2A
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 02:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiG2CFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 22:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiG2CFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 22:05:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AD81116C
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 19:05:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pw15so3405616pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 19:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VrPTwHjfC5QxsVG3vayD8eV3MqvBjr0U91L8fruvcYg=;
        b=aJhskqxfHu9Y2ZpoWFbtIeFpB4Imk6JZOVzW4D8S2y6DMUoufx0RE3fq/be6nFU2au
         wb6GvuodPNYVan8O0B3whcvlFn4/n8AhT2jZkHIEoTkVg7fSan0w+KAxcqCGumWgdZKq
         Y8yHiqpMBrxaF5Xp6vWy4dcZrEmkbsuJo0bbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VrPTwHjfC5QxsVG3vayD8eV3MqvBjr0U91L8fruvcYg=;
        b=wSJqrfSHuTcLZlCPjPp3xoxyYacTgWyoRoLtS+n19PuR/UcjoNxEHSKU5zGLInr1xV
         Jldf1EKFnsNmVbXtRT4lB1px6C1Lmofd9mE08taxmHmI6fUP0gTSlxl1CNy29MAk2Zjp
         5a2UBwCA6YMEpGnm1SFar4fMiFcQeSHHHpVB/AWnjgiolPOl7bmhLCrpQ/RF73ZkaqBg
         pMty5EflMxgRoG1DoRFbf+7Q/jFOyOp7oAk5ggpHBJdQ95NlV2DBKPoVh38Qoips8x4m
         Rb5F7zadZqcZlo4v8hbQJdjD+FO0BlJR5IPJJiO1Pez+a0GtLGPRYvSnKy/SYymwgxlX
         VqfQ==
X-Gm-Message-State: ACgBeo0jZf8VJslicd51y3Fnb+nm8p3IIZjMOcssiSdHreroNP/LxZ7M
        R6tnsK5Nx0RRxLRhHAc3sm3voEYLR+XjsNLC
X-Google-Smtp-Source: AA6agR4yg+hJT2sTUv6xIxgwqftaALBJ1dWWW39BU5Dsu1TjnAGWtGgfMYa2Uq/BoKZakwmgeNMCPw==
X-Received: by 2002:a17:90b:3e8a:b0:1f0:4157:daf8 with SMTP id rj10-20020a17090b3e8a00b001f04157daf8mr1583417pjb.222.1659060320809;
        Thu, 28 Jul 2022 19:05:20 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id y124-20020a62ce82000000b005258df7615bsm1571901pfg.0.2022.07.28.19.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 19:05:20 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH v3 0/2] Expose UFSHCD capabilities in sysfs.
Date:   Fri, 29 Jul 2022 12:05:06 +1000
Message-Id: <20220729020508.4147751-1-dlunev@chromium.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patchset introduces new sysfs nodes, which userspace can check to
determine support for certain capabilities. Specifically the patchset
exposes Clock Scaling, Write Booster, and Inline Crypto Engine
capabilities.

Changes in v3:
* Expose each capability as an individual node
* Add preleminary CL to align checking for capabilities
* Modify documentation to represent new scheme

Changes in v2:
* Add documentation entry for the new sysfs node.

Daniil Lunev (2):
  ufs: add function to check CRYPTO capability
  ufs: core: print UFSHCD capabilities in controller's sysfs node

 Documentation/ABI/testing/sysfs-driver-ufs | 39 ++++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 41 ++++++++++++++++++++++
 drivers/ufs/core/ufshcd-crypto.c           |  8 ++---
 drivers/ufs/host/ufs-mediatek.c            |  2 +-
 drivers/ufs/host/ufs-qcom-ice.c            |  4 +--
 drivers/ufs/host/ufshcd-pci.c              |  2 +-
 include/ufs/ufshcd.h                       |  5 +++
 7 files changed, 93 insertions(+), 8 deletions(-)

-- 
2.31.0

