Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42B3C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBB461405
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhEMWjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:15 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:45771 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEMWjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:14 -0400
Received: by mail-pf1-f178.google.com with SMTP id d16so2283634pfn.12
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGU1OCDj+wjXJMk90iN4vIXJadY2eOHy8GiHGyF8C7o=;
        b=qiLB9Ow4B/LeL/njvGanpqsW3qRw27Ro95MYi+nsoTf3AgHrRAGQCfrz7aADOPXGAs
         oN3Jp0OYghpN/k/ofKm5NmD2F322PeSQfy3OyWp5kbDXtd49SJfw/ZUMm1ZpLpAHM+Gc
         BGdlm4Kacb+nclOyZtayqBFN0xgKwBVnFjvji0AtSQhW6hp5n5WDgXwQq2iIEaDzNbjN
         I+WISnvEybtmkLWAUe7DYXgKkF2I5b63Cgv0BR8QOzR7RBYUv74UAvewjjzMy5ZNZVN5
         0RZSSxDYCWidHTHPq9D/27OxFljFTK1kYfEVhlBI67pHtyJoFN5f9jxW9iJBPtjRiIQe
         bKZg==
X-Gm-Message-State: AOAM531RimMJTu++tpclw/171s1tfG6V2+xYzRtBzagwrZhs4GpLV5L4
        fcgrS1W3Bmabbn4IFyC7nyI=
X-Google-Smtp-Source: ABdhPJwbwS0VCwkT01vRNIShlcgZAcZtAjv6iJtiIXenNRXoMcTx6+bImjsavWNZV8FuE0NK9WnRpA==
X-Received: by 2002:a63:5158:: with SMTP id r24mr18916551pgl.41.1620945484033;
        Thu, 13 May 2021 15:38:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/8] Rename scsi_get_lba() into scsi_get_sector()
Date:   Thu, 13 May 2021 15:37:49 -0700
Message-Id: <20210513223757.3938-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series renames scsi_get_lba() into scsi_get_pos(). The name of
scsi_get_lba() is confusing since it does not return an LBA but instead the
start offset divided by 512.

Please consider this patch series for kernel v5.14.

Thanks,

Bart.

Changes compared to v2:
- Renamed scsi_get_pos() into scsi_get_sector() as suggested by Damien.
- Split the lpfc and qla2xxx changes into separate patches.

Changes compared to v1:
- Changed the "iscsi" prefix into "isci" for patch 4/7.
- Added support for READ(16) and WRITE(16) in patch 6/7.

Bart Van Assche (8):
  core: Introduce scsi_get_sector()
  iser: Use scsi_get_sector() instead of scsi_get_lba()
  zfcp: Use scsi_get_sector() instead of scsi_get_lba()
  isci: Use scsi_get_sector() instead of scsi_get_lba()
  lpfc: Use scsi_get_sector() instead of scsi_get_lba()
  qla2xxx: Use scsi_get_sector() instead of scsi_get_lba()
  ufs: Fix the tracing code
  core: Remove scsi_get_lba()

 drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
 drivers/s390/scsi/zfcp_fsf.c             |  2 +-
 drivers/scsi/isci/request.c              |  4 +--
 drivers/scsi/lpfc/lpfc_scsi.c            | 12 ++++-----
 drivers/scsi/qla2xxx/qla_iocb.c          |  9 +++----
 drivers/scsi/qla2xxx/qla_isr.c           |  8 +++---
 drivers/scsi/ufs/ufshcd.c                | 34 +++++++++++-------------
 include/scsi/scsi_cmnd.h                 |  2 +-
 include/trace/events/ufs.h               | 10 +++----
 9 files changed, 38 insertions(+), 45 deletions(-)

