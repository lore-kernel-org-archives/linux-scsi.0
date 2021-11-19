Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AD8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6783761B30
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhKSUAx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:00:53 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:34443 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhKSUAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:00:52 -0500
Received: by mail-pg1-f181.google.com with SMTP id 200so9524971pga.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GegOpaN18ndW39nDUilwLFv4+ZRzDjkAcQwGS36tzxU=;
        b=fiMaG5wJ0nnG8+5sX57WfNPtYPy6EBoFjNEBIeqjopWuPlYokLsVzNP7DXKqQhd7bj
         Ek7tf7ha7UGhfK6eyKIRIWJDmgQuh2ZQ+Vid3IpthzIvbFcSTJIfKTem1tsW45MiYQlA
         0D9VjSOXlH06fNzrIywpN0DUpfpHkIIo8rWKbtc3qdiyefC2dQEDgraDZZrQggnIJ+Wj
         OO7/m4B6DWY3+q3ul7WOe/AfM2oyK2fIfCFKrLVUvskKStQCYAmql+4Kvwy3sa6apB7f
         K/bWqkAvQj4iochMwUmSZWoUg5TR7apPfKBNfxzE2WRkKH6Q6pNPMWYhyAFD12j9eHOT
         542g==
X-Gm-Message-State: AOAM533oXEr0pdqIHsYCeGuFShqUAhNluKdxcrlpRZDHw+LF7JxSQlFL
        vIwN51Sfk22c/7rp0L4AzSY=
X-Google-Smtp-Source: ABdhPJw8vGr4BYWIolWm9PtLQyGBaOXBQ4fSFbcvl3NPKlKD2SPc393cGv/PZTG3KvPYXTD3RjmmKA==
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id l14-20020a056a00140e00b00444b07751efmr25038941pfu.61.1637351870128;
        Fri, 19 Nov 2021 11:57:50 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/20] UFS patches for kernel v5.17
Date:   Fri, 19 Nov 2021 11:57:23 -0800
Message-Id: <20211119195743.2817-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the following changes:
- Introduce internal command and reserved tag support in the SCSI core.
- Fix a deadlock in the UFS error handler.
- Add polling support in the UFS driver.
- Several smaller fixes for the UFS driver.

Please consider these UFS driver kernel patches for kernel v5.17.

Thanks,

Bart.

Changes compared to v1:
- Introduced the symbolic constant UFSHCD_NUM_RESERVED.
- Changed the behavior of the patch that removes the clock scaling lock from
  ufshcd_queuecommand() such that it again waits until all pending commands
  have finished before changing the clock frequency.
- Split the patch that optimizes ufshcd_queuecommand().
- Added patches that introduce support for internal command management in the
  SCSI core.
- Introduced a new function ufshcd_release_scsi_cmd().

Bart Van Assche (18):
  scsi: core: Unexport scsi_track_queue_full()
  scsi: core: Fix scsi_device_max_queue_depth()
  scsi: core: Fix a race between scsi_done() and scsi_times_out()
  scsi: core: Add support for reserved tags
  scsi: ufs: Rename a function argument
  scsi: ufs: Remove is_rpmb_wlun()
  scsi: ufs: Remove the sdev_rpmb member
  scsi: ufs: Remove dead code
  scsi: ufs: Switch to scsi_(get|put)_internal_cmd()
  scsi: ufs: Rework ufshcd_change_queue_depth()
  scsi: ufs: Fix a deadlock in the error handler
  scsi: ufs: Introduce ufshcd_release_scsi_cmd()
  scsi: ufs: Improve SCSI abort handling
  scsi: ufs: Fix a kernel crash during shutdown
  scsi: ufs: Stop using the clock scaling lock in the error handler
  scsi: ufs: Optimize the command queueing code
  scsi: ufs: Implement polling support
  scsi: ufs: Fix race conditions related to driver data

Hannes Reinecke (2):
  block: Add a flag for internal commands
  scsi: core: Add support for internal commands

 block/blk-exec.c                   |   5 +
 drivers/scsi/scsi.c                |   5 +-
 drivers/scsi/scsi_error.c          |  29 +--
 drivers/scsi/scsi_lib.c            |  50 +++-
 drivers/scsi/ufs/tc-dwc-g210-pci.c |   1 -
 drivers/scsi/ufs/ufs-exynos.c      |   4 +-
 drivers/scsi/ufs/ufshcd-pci.c      |   2 -
 drivers/scsi/ufs/ufshcd-pltfrm.c   |   2 -
 drivers/scsi/ufs/ufshcd.c          | 375 ++++++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h          |   5 +-
 include/linux/blk-mq.h             |   5 +
 include/linux/blk_types.h          |   2 +
 include/scsi/scsi_device.h         |   4 +
 include/scsi/scsi_host.h           |   9 +-
 14 files changed, 301 insertions(+), 197 deletions(-)

