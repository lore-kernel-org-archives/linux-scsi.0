Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD59C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 22:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiKVW01 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiKVW0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 17:26:25 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F8579E2B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:25 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id z26so15682729pff.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YV+ncF2FD7uDlkKIUjkVd4ircf+uuGyUCcUB1Dxg0Dg=;
        b=ea0HqLK7Q+QnKNMQzq9dthDkWnXvLHhvcMd1wiHGjgbatwUBRCR0U7PglxgC+JZLcb
         //WuH3630qC6eP81fcpfHzRo27DBqQgWbpqlV/eJoO4Je3RMf9//1crk6vn3yPGmVAef
         B2/0NvIUNUSCsJix+ZFAUSUGxxSwxBGiOvLy4adjSUYrvA0KTX8DBmikAy6WmMCjDjc+
         rQXmUlGUBWRzjaQGXLs2C8ZtK3qzg9LcC+oKTekW/NXBWzaHo5cMRHRNyqRb1cGhxy0b
         SN4d+uOCiorTsAis2VmjGncSQikGWZF3303wiyFPi0cALinHbTD+53p45lUmjtouHDRD
         YkPg==
X-Gm-Message-State: ANoB5pkGC/3hKXK8CYuF3pMm3vg2Vh8qcBHVIZzZYeWcfa4JTpaNjyJS
        SaYF5W04RLo7KhwayS5RMpw=
X-Google-Smtp-Source: AA0mqf6ReZrGp6ADR1ucgjMKRBPPkjmZODDIR9RVNIp5dgEecXcePH/7A7RMj+3dfCWUbTSMGXjoyw==
X-Received: by 2002:a63:470e:0:b0:440:69bc:c972 with SMTP id u14-20020a63470e000000b0044069bcc972mr5138764pga.86.1669155984467;
        Tue, 22 Nov 2022 14:26:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b00172973d3cd9sm12539551plb.55.2022.11.22.14.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:26:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/5] Prepare for upstreaming Pixel 6 and 7 UFS support
Date:   Tue, 22 Nov 2022 14:26:12 -0800
Message-Id: <20221122222617.3449081-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The Exynos UFS controller requires that SCSI command processing is suspended
while reprogramming encryption keys. This UFS controller is used in e.g. Google
Pixel 6 and 7 phones and also in Tesla cars. The patches in this series are a
first step towards integrating support in the upstream kernel for the UFS
controller in the Pixel 6 and 7. Please consider these patches for the next
merge window.

Note: instructions for downloading the Pixel kernel source code are available
at https://source.android.com/setup/build/building-kernels.

Thanks,

Bart.

Changes compared to v3:
- Changed SCSI_UFS_VARIABLE_SG_ENTRY_SIZE from user-selectable into selected
  only if needed.

Changes compared to v2:
- Addressed more review comments from Avri.

Changes compared to v1:
- Addressed Avri's review comments.
- Added patch "Allow UFS host drivers to override the sg entry size".

Bart Van Assche (4):
  scsi: ufs: Reduce the clock scaling latency
  scsi: ufs: Move a clock scaling check
  scsi: ufs: Pass the clock scaling timeout as an argument
  scsi: ufs: Add suspend/resume SCSI command processing support

Eric Biggers (1):
  scsi: ufs: Allow UFS host drivers to override the sg entry size

 drivers/ufs/core/ufshcd.c | 89 +++++++++++++++++++++++++++------------
 drivers/ufs/host/Kconfig  |  4 ++
 include/ufs/ufshcd.h      | 33 +++++++++++++++
 include/ufs/ufshci.h      |  9 +++-
 4 files changed, 106 insertions(+), 29 deletions(-)

