Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29A1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376636AbhLCXXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:23:25 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:36650 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhLCXXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:23:25 -0500
Received: by mail-pg1-f173.google.com with SMTP id 137so4542545pgg.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKAyAmIiCEJ34ioNVZ8Od4OPrKOrZR9lU0T8l7rVuLc=;
        b=5gHnw9BRyJNs8xCIXMYawgbEQ61nZPLv/zH+zDA8rVE3Ldy2K2RTs8I19B9YeMH+/l
         GlFhicyj99uIbjLrqhrlNMI9Clq5O1EguDeNlhSYTWtKYz6vjbIxsYrPoc8qBrfSGJ2e
         74N/zAuTX5KxvTkxbobShcG047/z1mxToE0wzFQpWMx+FWKSTSKJd/lUsGyEU2Lp5r3O
         OPnXJxfSyAj/YlV/9hq5LfKM7zFh0yJLPxFw2q940kCLZFy2fcryNU8GqrWFpzljHuFl
         DXL+kv8nMhKrNaxHm8xDzd/XqgxUPTW2+PiiTNGBxynSspfoT8C0NyUXVzjvWY8vy9AO
         bHEQ==
X-Gm-Message-State: AOAM530yXApy2N7p9pmk6kv7dRgERIghiw37CsOCUncdh3B8BvPvo3CK
        XRCPKVkt6aVkH7GFNkhKL0o=
X-Google-Smtp-Source: ABdhPJz2mvNufEYs6GtZwpTK1ENYrLf80JtIAtbW1cyJ74XBJZNvqN9Ty7PpB5L/Y17Mlq/1JVqi0g==
X-Received: by 2002:a62:9202:0:b0:4a4:f09e:7d75 with SMTP id o2-20020a629202000000b004a4f09e7d75mr22822692pfd.33.1638573600256;
        Fri, 03 Dec 2021 15:20:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:19:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/17] UFS patches for kernel v5.17
Date:   Fri,  3 Dec 2021 15:19:33 -0800
Message-Id: <20211203231950.193369-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the following changes:
- Fix a deadlock in the UFS error handler.
- Add polling support in the UFS driver.
- Several smaller fixes for the UFS driver.

Please consider these UFS driver kernel patches for kernel v5.17.

Thanks,

Bart.

Changes compared to v3:
- Dropped patch "scsi: core: Fix a race between scsi_done() and
  scsi_times_out()" since the conversation around that patch is still ongoing.
- Added patch "scsi: ufs: Remove hba->cmd_queue".
- Modified patch "scsi: ufs: Optimize the command queueing code".

Changes compared to v2:
- Dropped SCSI core patches that add support for internal commands.
- Reworked patch "Fix a deadlock in the error handler" such that it uses a
  reserved tag as proposed by Adrian.
- Split patch "ufs: Introduce ufshcd_release_scsi_cmd()" into two patches.

Changes compared to v1:
- Add internal command support to the SCSI core.
- Reworked patch "ufs: Optimize the command queueing code".

Bart Van Assche (17):
  scsi: core: Fix scsi_device_max_queue_depth()
  scsi: ufs: Rename a function argument
  scsi: ufs: Remove is_rpmb_wlun()
  scsi: ufs: Remove the sdev_rpmb member
  scsi: ufs: Remove dead code
  scsi: ufs: Fix race conditions related to driver data
  scsi: ufs: Remove ufshcd_any_tag_in_use()
  scsi: ufs: Rework ufshcd_change_queue_depth()
  scsi: ufs: Fix a deadlock in the error handler
  scsi: ufs: Remove hba->cmd_queue
  scsi: ufs: Remove the 'update_scaling' local variable
  scsi: ufs: Introduce ufshcd_release_scsi_cmd()
  scsi: ufs: Improve SCSI abort handling further
  scsi: ufs: Fix a kernel crash during shutdown
  scsi: ufs: Stop using the clock scaling lock in the error handler
  scsi: ufs: Optimize the command queueing code
  scsi: ufs: Implement polling support

 drivers/scsi/scsi.c                |   4 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c |   1 -
 drivers/scsi/ufs/ufs-exynos.c      |   4 +-
 drivers/scsi/ufs/ufshcd-pci.c      |   2 -
 drivers/scsi/ufs/ufshcd-pltfrm.c   |   2 -
 drivers/scsi/ufs/ufshcd.c          | 300 ++++++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h          |   9 +-
 7 files changed, 174 insertions(+), 148 deletions(-)

