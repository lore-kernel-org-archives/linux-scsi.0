Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61197C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 429A66112D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhJTVmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:42:49 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:36693 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTVmr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:42:47 -0400
Received: by mail-pl1-f169.google.com with SMTP id f21so17077828plb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUQWfjykAY3JQ8y9CvyOa/4SVMWOHiFCRctFJWrLTWM=;
        b=GQmFNVMibVhGFGLr1f/Yl50AuMPHmFA2ZyqY7syz4wy/gBnPyGwxD9MgbFEPYPfduQ
         iSDZk+vM5uHG/BRvdABUaFWHQJDCPBQH5OtUwLbZW+PUrM6cE8B7SASWbyfiZU+DxAHd
         W84YcIsi76bDGUiRuH3vPDiggcua0qIvKzqq64S6bEFL3Gc2nWCqfz+ThHo9SkmUte2r
         m33D6BnKEqsoj0+nms6BFTZOfncwkWRkebsQBcNkmGKfCQykmgpnnEZbqcDOEjmZh3Zn
         lvYeXQ10QW7twyUKS+HL6jmx6yebB6hBvpshXYRfj2TrPav5a70bQ3Fb/VsXU7fBcAvi
         Mv1A==
X-Gm-Message-State: AOAM532fAe5c375np/HhgUMRA09Qp+H33NlIPF6Z42sNXndR3J2vvW9n
        FbG7Oytd9SMbfipWHJmHytDZDQYR36E=
X-Google-Smtp-Source: ABdhPJzUt4coDFs3hiZxueWYA8gBShBa6EfHYnVqREwxZDxmnoEvjg+EuflN143JKWW4QJhpYiICRQ==
X-Received: by 2002:a17:90a:49:: with SMTP id 9mr1794974pjb.80.1634766032710;
        Wed, 20 Oct 2021 14:40:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:40:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/10] UFS patches for kernel v5.16
Date:   Wed, 20 Oct 2021 14:40:14 -0700
Message-Id: <20211020214024.2007615-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the UFS driver kernel patches I would like to see
included kernel v5.16. Please consider these patches for kernel v5.16.

Thank you,

Bart.

Changes compared to v1:
- Converted the sysfs attribute for triggering the error handler into two
  debugfs attributes.
- Use ufshcd_schedule_eh_work(hba) instead of scsi_schedule_eh(hba->host) to
  trigger the error handler.
- Added three patches that implement a small performance optimization.

Bart Van Assche (10):
  scsi: ufs: Revert "Retry aborted SCSI commands instead of completing
    these successfully"
  scsi: ufs: Improve source code comments
  scsi: ufs: Improve static type checking
  scsi: ufs: Log error handler activity
  scsi: ufs: Export ufshcd_schedule_eh_work()
  scsi: ufs: Make it easier to add new debugfs attributes
  scsi: ufs: Add debugfs attributes for triggering the UFS EH
  scsi: ufs: Remove three superfluous casts
  scsi: ufs: Add a compile-time structure size check
  scsi: ufs: Micro-optimize ufshcd_map_sg()

 drivers/scsi/ufs/ufs-debugfs.c |  98 ++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.c      | 102 +++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h      |   1 +
 drivers/scsi/ufs/ufshci.h      |  15 ++---
 4 files changed, 168 insertions(+), 48 deletions(-)

