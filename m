Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD12C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB15C61288
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbhELVXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:15 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41793 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385581AbhELUKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:05 -0400
Received: by mail-pg1-f176.google.com with SMTP id m37so19067960pgb.8
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZ/lNq4LI+TlcoloGvmk9wZ3NvSa2TryRUCZ6gPTbGA=;
        b=MTcqF+MjsH5K0RKgkSSMWnJ8FO87zKMF5hcc//5GZ3fZUr+Yqo4A2qYHnILHIKrem+
         B84KhzRtGPBST4TC7phLBArqa0HVcFF3r+oSp8jmMdgXmSGDkeAMQVQIVGeQMutSTHrx
         8AfzS6fEFM3SJlOyWIR61vXbrSvfc72BRkiFID+yj5vEDorYhKwx6Mby7HmpeXEOT5vc
         HBCIxQhpmBowzMMw+yMe51LBtJ8RfJmheKOxPG2+qoKPePN31lhe1dW9yQXG6tOxQf21
         xMfOYid4UqDcdEdlbS1tvPfnwfQH3FgZXn5NHmKycLS6Y77Ma5ayEve+nS9n7pqymTZH
         WAsw==
X-Gm-Message-State: AOAM533dAai+DqoceLLTrHIijWuzI2bygs+6fWqiRuLx3souqrHxzwvR
        +/ZVGeW89ldRR6aiET3HdxI=
X-Google-Smtp-Source: ABdhPJyyYvmoPe0GDKjsBa9JJc4hP19wWW9biHmEg4pepGIpEhjf/r8B1KrOMAeZ/PsNfDp46cSwFQ==
X-Received: by 2002:a63:4f4a:: with SMTP id p10mr286446pgl.384.1620850136278;
        Wed, 12 May 2021 13:08:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:08:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
Date:   Wed, 12 May 2021 13:08:42 -0700
Message-Id: <20210512200849.9002-1-bvanassche@acm.org>
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

Changes compared to v1:
- Changed the "iscsi" prefix into "isci" for patch 4/7.
- Added support for READ(16) and WRITE(16) in patch 6/7.

Bart Van Assche (7):
  Introduce scsi_get_pos()
  iser: Use scsi_get_pos() instead of scsi_get_lba()
  zfcp: Use scsi_get_pos() instead of scsi_get_lba()
  isci: Use scsi_get_pos() instead of scsi_get_lba()
  qla2xxx: Use scsi_get_pos() instead of scsi_get_lba()
  ufs: Fix the tracing code
  Remove scsi_get_lba()

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

