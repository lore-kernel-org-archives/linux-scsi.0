Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38EBC2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3229206A2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDYZ8VF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgDPUbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 16:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728880AbgDPUbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 16:31:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8696AC061A0C;
        Thu, 16 Apr 2020 13:31:44 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d77so221117wmd.3;
        Thu, 16 Apr 2020 13:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09naRPgL1bqA35y3my5iEt3xLonpJCAbtNqGmru8/JU=;
        b=BDYZ8VF+SblIK/ZXXPaHE0nXKeELo3Cyk9r1DgkgY4LoBSDWeZvyoAe65fb5R6rtTK
         Ge516032LE2WwWKGE3IkebO00eh6D+zhLPGY2tYhfrvgQ6xSbO7BTfasV9ukv3fLZ0tp
         UhrpTU9/9RbDBD2k5acymJkVRgPgSfGDJjegKnempYnsSutstKHaAo0/85DvVspK2BjL
         ObIqf/1BQbYkqZeUK7I6ZoBG/oxPjwBUogb+uAhd4/+oVR7nkUexM+tICw1J1DhIBx6f
         /sFV8N+/18mTBghNL3wy0tsH/dUrN3e5TbaLjaOQgo51gAI8YHaXCf3epNFqlQnmBufS
         DaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09naRPgL1bqA35y3my5iEt3xLonpJCAbtNqGmru8/JU=;
        b=JprTqvQ5NeBQSdIKAdWVXR7Md9xJnfyAHRSBaLnguteVR+QifEPcX5vErmR4o1QeYB
         erl1dk1ALW2d8REpWRiZH/Sr0WZs1mkc+4Y1Wg5bABdXl2YOs77ba682Th1DofIaVT8/
         sgR2oCF4KEycmQc6tOGjUBuMfzLeDsEGjsn08s8WEc6j4m9H76hL0CwBQ++yv4blRMz5
         WNzB9ax3S7zsadmO/DDfck+VPcShkKrRSCoNHuMqd2/4F1ApWaC5pFExwF7TK0EHtm8D
         /P0I2c06zWNQPidFMliYD8QvKEZlYVVjF8X1AEUO4cYxJ9XT+UObk/ZB81KhJSo+ZPvU
         /Z/w==
X-Gm-Message-State: AGi0PuYUCliDTta/hFqHvNz9zZHFMk2XBLUAN3+1YJe3hVqcNJlWX2VG
        EbUGvGzGzl7TUw8OZYBGFk0=
X-Google-Smtp-Source: APiQypKjqpYjModqFmb+9mv33wGizvjmei63UI9dSujg/oM/+/A8Dpqdtri9+Qq2QpT/S1hAuFo0rw==
X-Received: by 2002:a1c:7416:: with SMTP id p22mr6856379wmc.80.1587069102952;
        Thu, 16 Apr 2020 13:31:42 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id s9sm17638864wrg.27.2020.04.16.13.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:31:42 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] UFS Host Performance Booster (HPB v1.0) driver
Date:   Thu, 16 Apr 2020 22:31:21 +0200
Message-Id: <20200416203126.1210-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Hi,
I disclose my development/changes on UFS HPB (UFS Host Performance Booster) to
the community, as this would enable more UFS developers to test and start an
iterative review and update process.

The HPB is defined in Jedec Standard Universal Flash (UFS) Host Performance
Booster (HPB) Extension Version 1.0, which is designed to improve  read
performance by utilizing the host side memory. Based on our testing, the HPB
can increase the random read performance by up to about 46% in the random read.

The original HPB driver is from [1]. Based on it, I did optimizations,
simplifications, fixed reliability issues, implemented HPB host control mode
and make it much more readable. which's pushed to here [2] as V1.

To avoid touching the traditional SCSI core, the HPB driver in this series HPB
patch chooses to develop under SCSI sub-system layer, and sits the same layer
with UFSHCD. At the same time, to minimize changes to UFSHCD driver, the HPB
driver submits its HPB READ BUFFER and HPB WRITE BUFFER requests to the scsi
device->request_queueu to execute, rather than that directly go through
raw UPIU request path.

v1--v2:
    1. Rebased the patch on the [3] branch 5.8/scsi-queue
    1. Optimized and simplified several functions
    2. Add parameter read_threshold in HPB sysfs, by which the user can change
       read_threshold for the HPB host control mode
    3. Add HPB memory limitation, let the user adjust its size according to the
       system memory capacity

[1] https://github.com/OpenMPDK/HPBDriver
[2] https://www.spinics.net/lists/kernel/msg3449471.html
[3] https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

Bean Huo (5):
  scsi; ufs: add device descriptor for Host Performance Booster
  scsi: ufs: make ufshcd_read_unit_desc_param() non-static func
  scsi: ufs: add ufs_features parameter in structure ufs_dev_info
  scsi: ufs: add unit and geometry parameters for HPB
  scsi: ufs: UFS Host Performance Booster(HPB) driver

 drivers/scsi/ufs/Kconfig  |   62 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufs.h    |   15 +
 drivers/scsi/ufs/ufshcd.c |   66 +-
 drivers/scsi/ufs/ufshcd.h |   15 +-
 drivers/scsi/ufs/ufshpb.c | 3279 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  450 +++++
 7 files changed, 3881 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.17.1

