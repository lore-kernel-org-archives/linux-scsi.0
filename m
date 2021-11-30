Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72777C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhK3Xgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:36:54 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:40505 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbhK3Xgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:36:51 -0500
Received: by mail-pf1-f180.google.com with SMTP id z6so22258695pfe.7
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rV1ZZzSarJLW8nbK5P8T8LflXTUN6IUbBWW0dei57Rs=;
        b=jYBeOCtIFPkTlV8oI6v2LVTc4XBVcg6Afk5/fneZLUAa08rfnu97ur0c+14QL+IYUX
         nlyWyLEdgtIxVyW9uqmknaTHLHlyk1QjiBXpacsCSZ51BWouAtEaJFNYyIYySEcFGFVL
         dxKB/kZq6sF7yVPwxfj7hhjm+rOGxddQ+I+WT3qoDHMP/znNUehXA3tMaMvqTNAVdgER
         /kiP6+MAlfATutMHDXYgvbI1FbVYvd7X6x7X8c0cklkUVRwuktyu/hsIY+8Aez498t7i
         8It7vEbtPvjNOxp0S8mio9cAdpvmGDVKgl0BjJU3K9f2VQgfdXtkjWVhjzWZLbuZ8oAR
         feVg==
X-Gm-Message-State: AOAM531FoNcF50RBWDj1w8GFfkM0vUkhl5aXpcP4/yyt7P4zTmdHjMwO
        wW10y1QMeop+KtLkyODQFXO6BypY+Y4=
X-Google-Smtp-Source: ABdhPJxrIZD+0vPNvClBUYrmfScEFu+j8/GZy3aDmWOk2rXLDZ4u4Hq9h5W+rqUxb3zJzfnDzunKVA==
X-Received: by 2002:a63:80c7:: with SMTP id j190mr1809517pgd.239.1638315211110;
        Tue, 30 Nov 2021 15:33:31 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/17] UFS patches for kernel v5.17
Date:   Tue, 30 Nov 2021 15:33:07 -0800
Message-Id: <20211130233324.1402448-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
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
  scsi: core: Fix a race between scsi_done() and scsi_times_out()
  scsi: ufs: Rename a function argument
  scsi: ufs: Remove is_rpmb_wlun()
  scsi: ufs: Remove the sdev_rpmb member
  scsi: ufs: Remove dead code
  scsi: ufs: Fix race conditions related to driver data
  scsi: ufs: Remove ufshcd_any_tag_in_use()
  scsi: ufs: Rework ufshcd_change_queue_depth()
  scsi: ufs: Fix a deadlock in the error handler
  scsi: ufs: Remove the 'update_scaling' local variable
  scsi: ufs: Introduce ufshcd_release_scsi_cmd()
  scsi: ufs: Improve SCSI abort handling further
  scsi: ufs: Fix a kernel crash during shutdown
  scsi: ufs: Stop using the clock scaling lock in the error handler
  scsi: ufs: Optimize the command queueing code
  scsi: ufs: Implement polling support

 drivers/scsi/scsi.c                |   4 +-
 drivers/scsi/scsi_error.c          |  22 +--
 drivers/scsi/ufs/tc-dwc-g210-pci.c |   1 -
 drivers/scsi/ufs/ufs-exynos.c      |   4 +-
 drivers/scsi/ufs/ufshcd-pci.c      |   2 -
 drivers/scsi/ufs/ufshcd-pltfrm.c   |   2 -
 drivers/scsi/ufs/ufshcd.c          | 268 ++++++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h          |   7 +-
 8 files changed, 165 insertions(+), 145 deletions(-)

