Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B51C07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6B56124B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhGVCyQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:16 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:45921 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhGVCyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:15 -0400
Received: by mail-pj1-f51.google.com with SMTP id h6-20020a17090a6486b029017613554465so3605629pjj.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/4HUTwp/bu/xYkF+DiAv8jqct+eVcWT1ndjndj2Kps=;
        b=cKSEWQJBEY+ThUvRgwrIfG3/3q0ooY2J6qAnL7d99c5HqmocvPastb/cL/fPDXObUj
         ZiSrzn4IP50MbjBDykdPFNWl8pD+wuQpTVBOfob0OW1aLu49aYO40w7U7REFZbw3yA98
         SULYEwE8llkEf43frJjNFrNecVFrOEJUoVO4y2Qjgx5T0FwykI1+djnS/ibzVTXGpLPN
         xc3by83NErEh7WPu/EOZzFSmUFROOuP4GwOD6C+J2WmuFGAzt+M6apJWkm4lGR4yh/tN
         AZIb+xeNq3gheX77TBnp6Ca3QfDbMMnQd3gE7Bumz/rDTFR6B33iGAuFjTxM1hNsq7bK
         43Cw==
X-Gm-Message-State: AOAM531lOjL96Aam4z/kJFJiQ6oTWDUZeIQKFqP7xGXP8f43tvxCaQRT
        Ulaaa2j+rhX9mD105u0OTSedUvpy3YM=
X-Google-Smtp-Source: ABdhPJy/J5amI29RuGA1hsqZSYzFGpYhfVACnPQxC504RADNEM6t7nac6SL7XBL6no6VK7V3Zn1OrA==
X-Received: by 2002:a63:a18:: with SMTP id 24mr38875510pgk.309.1626924889353;
        Wed, 21 Jul 2021 20:34:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:34:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/18] UFS patches for kernel v5.15
Date:   Wed, 21 Jul 2021 20:34:21 -0700
Message-Id: <20210722033439.26550-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the patches in this series for kernel v5.15.

Thank you,

Bart.

Changes compared to v2:
- Included a stack corruption fix.
- Dropped patch "Remove a local variable" and added patches "Revert "Utilize
  Transfer Request List Completion Notification Register"" and "Optimize
  serialization of setup_xfer_req() calls".
- Added patch "Optimize serialization of setup_xfer_req() calls".

Changes compared to v1:
- Left out the SCSI core patches for the SCSI error handler in order not to
  delay the UFS patches by the conversation around the SCSI error handler
  patches.
- Restored the WARN_ON_ONCE(tag < 0) statements in the patch that removes
  ufshcd_valid_tag().
- Split "Fix a race in the completion path" in two patches.
- Added a fault injection patch.

Bart Van Assche (18):
  scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
  scsi: ufs: Reduce power management code duplication
  scsi: ufs: Only include power management code if necessary
  scsi: ufs: Rename the second ufshcd_probe_hba() argument
  scsi: ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
  scsi: ufs: Remove ufshcd_valid_tag()
  scsi: ufs: Verify UIC locking requirements at runtime
  scsi: ufs: Improve static type checking for the host controller state
  scsi: ufs: Remove several wmb() calls
  scsi: ufs: Inline ufshcd_outstanding_req_clear()
  scsi: ufs: Revert "Utilize Transfer Request List Completion
    Notification Register"
  scsi: ufs: Optimize serialization of setup_xfer_req() calls
  scsi: ufs: Optimize SCSI command processing
  scsi: ufs: Fix the SCSI abort handler
  scsi: ufs: Request sense data asynchronously
  scsi: ufs: Synchronize SCSI and UFS error handling
  scsi: ufs: Retry aborted SCSI commands instead of completing these
    successfully
  scsi: ufs: Add fault injection support

 drivers/scsi/ufs/Kconfig               |   7 +
 drivers/scsi/ufs/Makefile              |   1 +
 drivers/scsi/ufs/cdns-pltfrm.c         |   7 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c     |  32 +-
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c  |   7 +-
 drivers/scsi/ufs/ufs-exynos.c          |   7 +-
 drivers/scsi/ufs/ufs-fault-injection.c |  70 ++++
 drivers/scsi/ufs/ufs-fault-injection.h |  24 ++
 drivers/scsi/ufs/ufs-hisi.c            |   7 +-
 drivers/scsi/ufs/ufs-mediatek.c        |   7 +-
 drivers/scsi/ufs/ufs-qcom.c            |   7 +-
 drivers/scsi/ufs/ufshcd-pci.c          |  48 +--
 drivers/scsi/ufs/ufshcd-pltfrm.c       |  47 ---
 drivers/scsi/ufs/ufshcd-pltfrm.h       |  18 -
 drivers/scsi/ufs/ufshcd.c              | 491 +++++++++++--------------
 drivers/scsi/ufs/ufshcd.h              |  63 ++--
 drivers/scsi/ufs/ufshci.h              |   1 -
 17 files changed, 373 insertions(+), 471 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.c
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.h

