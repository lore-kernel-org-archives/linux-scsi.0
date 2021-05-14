Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF41C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 23:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F3C6144A
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 23:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhENXY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 19:24:28 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37668 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbhENXY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 19:24:27 -0400
Received: by mail-pg1-f170.google.com with SMTP id t193so437093pgb.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 16:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2RLiqctNqi6zwOyHJRP8An0MrtTiEe2uQCREc1/5zCg=;
        b=R5oN1eeLyWHLiOjiey5AiP3TvNbE9i+VHZZXave7lX5mhtOWSgVSrKZMCNsuZ3CcXb
         LItl+p2a1yaq0AbqS0Rfquc+jL73I/qVFkbgb1pnFtkYTtAvIsHVmr97Y8vyBLYVahXh
         6SLrUB0dzLHICdIRLaZnAVNyaqnF8iVWrliKtuYojG+Ivz5/9eIsej0IIZUc1lxTc1er
         8nMjNUYH3oEK5n4Q4QlU2WAp/D3eFtGx0bMHT3szOLBdBW6t68oPEqfH2Avb5OhLahNV
         B5MX+BbYRkciG544j7XJt0SCgyPqx1QUMd2n40cXFgw+TeA23du2wv9+4+v4eYyNv5C0
         vU+Q==
X-Gm-Message-State: AOAM530dDuU6/dn3+mM5YfvIJEF0k29KLml4ADbqt0/dQ3WrN5xRanrS
        JLvpFqdcGBMlkVQttRCr81M=
X-Google-Smtp-Source: ABdhPJyOw3jZFL6yYiVjHNdiyjL/WtOKpVvIrF4qhVpx6iVdBDQHkTz+f+uqLUycuSjWiHHh66yxxQ==
X-Received: by 2002:a63:5a43:: with SMTP id k3mr48951198pgm.308.1621034595443;
        Fri, 14 May 2021 16:23:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id a7sm4623106pfo.211.2021.05.14.16.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 16:23:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Introduce enums for SCSI status codes
Date:   Fri, 14 May 2021 16:23:05 -0700
Message-Id: <20210514232308.7826-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series introduces enums for the SAM, message, host and driver
status codes and hence improves static type checking by the compiler.
Please consider this patch series for kernel v5.14.

Thanks,

Bart.

Bart Van Assche (3):
  libsas: Introduce more SAM status code aliases in enum exec_status
  Introduce enums for the SAM, message, host and driver status codes
  Change the type of the second argument of
    scsi_host_complete_all_commands()

 drivers/scsi/aic94xx/aic94xx_task.c    |  2 +-
 drivers/scsi/constants.c               |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  8 +--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  8 +--
 drivers/scsi/hosts.c                   |  8 ++-
 drivers/scsi/isci/request.c            | 10 +--
 drivers/scsi/isci/task.c               |  2 +-
 drivers/scsi/libsas/sas_ata.c          |  5 +-
 drivers/scsi/libsas/sas_expander.c     |  2 +-
 drivers/scsi/libsas/sas_task.c         |  4 +-
 drivers/scsi/mvsas/mv_sas.c            | 10 +--
 drivers/scsi/pm8001/pm8001_hwi.c       | 16 ++---
 drivers/scsi/pm8001/pm8001_sas.c       |  4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c       | 14 ++---
 drivers/target/target_core_pscsi.c     |  2 +-
 include/scsi/libsas.h                  |  3 +
 include/scsi/scsi.h                    | 81 +-----------------------
 include/scsi/scsi_host.h               |  2 +-
 include/scsi/scsi_proto.h              | 24 +++----
 include/scsi/scsi_status.h             | 87 ++++++++++++++++++++++++++
 21 files changed, 161 insertions(+), 143 deletions(-)
 create mode 100644 include/scsi/scsi_status.h

