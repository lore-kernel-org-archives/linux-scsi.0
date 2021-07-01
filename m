Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B811DC11F6B
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98B8E61410
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhGAVPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:06 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41482 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhGAVPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:04 -0400
Received: by mail-pg1-f179.google.com with SMTP id m26so7363902pgb.8
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v1NwDK7l5raqN9KXVSNJrXy1gKkRhsIzuBFuf5G1o2g=;
        b=J4WR9hOZ0U4BBzFwV5XWDnR7kZc7Jp5XmLxy8F8xWaI3SZ6JD8P+Vpb0kTk2/yw0Pb
         9mNYYwg1ZdDkb5Bm/IDYKIizby4Hb5YwCpjGQ/0dexkCnSjUQWH61APGNs0hJfVyssb3
         /UeK49CpIqsUUVIHxnIZBa5LZYIe3Kix1NXvucVAExS32SqZjP0b6VsZBhi6fKRlf/8X
         e0eNBxNksKA9Qvzc10ZO5WQ+NLiFtaPUOgC2x0+yGhBKppfHseDj1ubc7PxkeRBycGnd
         RLOdrAFZG4Hy5FvRn/EQ3gsbpKiMP0UTjqfS244X6goU4YWBnB4N9Brjk4s6qA6aUI0/
         +wIw==
X-Gm-Message-State: AOAM5313hbZ9FnybjpQiCSNoUspoKrUE3nbmQZ2pppVpeaa1eyTPCaFa
        Rm+1C7td68T9G+FIYI515bo=
X-Google-Smtp-Source: ABdhPJwCHAf01GZp/rlpWW5I1YL/aiV47Iv7a1cKlQFcDfpjBZRBtJ5HNy/B3BGBchpefe/iaqKNNw==
X-Received: by 2002:a63:565f:: with SMTP id g31mr1537242pgm.164.1625173952868;
        Thu, 01 Jul 2021 14:12:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:12:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/21] UFS patches for kernel v5.15
Date:   Thu,  1 Jul 2021 14:12:03 -0700
Message-Id: <20210701211224.17070-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the patches in this series for kernel v5.15. As one can see
this patch series includes one ATA patch, four SCSI core patches and 16 UFS
patches.

Thanks,

Bart.

Bart Van Assche (21):
  Fix the documentation of the scsi_execute() time parameter
  libsas: Only abort commands from inside the error handler
  Clear host_eh_scheduled from inside the SCSI error handler
  libsas: Stop clearing host_eh_scheduled from the error handler
  ata: Stop clearing host_eh_scheduled from error handlers
  ufs: Reduce power management code duplication
  ufs: Only include power management code if necessary
  ufs: Rename the second ufshcd_probe_hba() argument
  ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
  ufs: Remove ufshcd_valid_tag()
  ufs: Verify UIC locking requirements at runtime
  ufs: Improve static type checking for the host controller state
  ufs: Remove several wmb() calls
  ufs: Inline ufshcd_outstanding_req_clear()
  ufs: Rename __ufshcd_transfer_req_compl()
  ufs: Fix the SCSI abort handler
  ufs: Fix a race in the completion path
  ufs: Use the doorbell register instead of the UTRLCNR register
  ufs: Request sense data asynchronously
  ufs: Synchronize SCSI and UFS error handling
  ufs: Retry aborted SCSI commands instead of completing these
    successfully

 drivers/ata/libata-core.c             |   2 -
 drivers/ata/libata-eh.c               |  30 +-
 drivers/scsi/libsas/sas_scsi_host.c   |   9 +-
 drivers/scsi/scsi_error.c             |   7 +
 drivers/scsi/scsi_lib.c               |   2 +-
 drivers/scsi/ufs/cdns-pltfrm.c        |   7 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c    |  32 +-
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c |   7 +-
 drivers/scsi/ufs/ufs-exynos.c         |   7 +-
 drivers/scsi/ufs/ufs-hisi.c           |   7 +-
 drivers/scsi/ufs/ufs-mediatek.c       |   7 +-
 drivers/scsi/ufs/ufs-qcom.c           |   7 +-
 drivers/scsi/ufs/ufshcd-pci.c         |  48 +--
 drivers/scsi/ufs/ufshcd-pltfrm.c      |  47 ---
 drivers/scsi/ufs/ufshcd-pltfrm.h      |  18 -
 drivers/scsi/ufs/ufshcd.c             | 467 +++++++++++---------------
 drivers/scsi/ufs/ufshcd.h             |  48 ++-
 include/linux/libata.h                |   1 -
 include/scsi/libsas.h                 |   1 +
 19 files changed, 271 insertions(+), 483 deletions(-)

