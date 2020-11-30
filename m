Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36A5C64E90
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990822076C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgK3CrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:03 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41295 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgK3CrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:03 -0500
Received: by mail-pl1-f196.google.com with SMTP id x4so3928622pln.8;
        Sun, 29 Nov 2020 18:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mURMdpKybqVsBG6OTfl95lBCzweYYZbeQOLbkXBv1M=;
        b=jbG9KoZt7YH8/dg9Q7hPvUSRSzfuy1z/6NCr/uBYmdNkkXB8w40zMsIK73p2i+AYFG
         spfXJ2D+ox+RdeM54SjteSsl6qSrzlKpfuCOwvCnlmtINkzGECCICkCiFes2qXp4Wpx9
         1S4saS8Hvo/oWbGoU+dM5UFw+eoMmUBONwpt2z2YlQYOH4Yz+giS7/yF8eYmpQ1J+sHa
         cCru15mcuBa/4omIt2AyH2XB11CNHejfFB6mlrCCzknQ93i+Pbvg+7bvCgCoioXPkYP8
         MOi3/BA9Ef/OtqckSQim02YP4G9lfTCK9vTvxCtZs5jCivEkqRlQeDSr7DmYK5gIMBZH
         HXog==
X-Gm-Message-State: AOAM531F71N//07Rqt2jXKcLbXfd/YwbtJjXaWfbfKgistpJAs3XlDRM
        O7ePxz2THGaL4T6niayWu0IaS3F6KP0=
X-Google-Smtp-Source: ABdhPJwlLlZaffdVpkRLKqEMoroOpfkYOXjXrPiWfy3+i4PBaKy9x5JsuHcQ4XgpdW5MeFynvoFVsQ==
X-Received: by 2002:a17:90a:4281:: with SMTP id p1mr24170067pjg.87.1606704382480;
        Sun, 29 Nov 2020 18:46:22 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/9] Rework runtime suspend and SPI domain validation
Date:   Sun, 29 Nov 2020 18:46:06 -0800
Message-Id: <20201130024615.29171-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The SCSI runtime suspend and SPI domain validation mechanisms both use
scsi_device_quiesce(). scsi_device_quiesce() restricts blk_queue_enter() to
BLK_MQ_REQ_PREEMPT requests. There is a conflict between the requirements
of runtime suspend and SCSI domain validation: no requests must be sent to
runtime suspended devices that are in the state RPM_SUSPENDED while
BLK_MQ_REQ_PREEMPT requests must be processed during SCSI domain
validation. This conflict is resolved by reworking the SCSI domain
validation implementation.

Hybernation, runtime suspend and SCSI domain validation have been retested.

Please consider this patch series for kernel v5.11.

Thanks,

Bart.

Changes between v3 and v4:
- Instead of creating a second request queue for SPI DV, set RQF_PM.

Changes between v2 and v3:
- Inlined scsi_mq_alloc_queue() into scsi_alloc_sdev() as requested by
  Christoph.

Changes between v1 and v2:
- Rebased this patch series on top of kernel v5.10-rc1.

Alan Stern (1):
  block: Do not accept any requests while suspended

Bart Van Assche (8):
  block: Fix a race in the runtime power management code
  block: Introduce BLK_MQ_REQ_PM
  ide: Do not set the RQF_PREEMPT flag for sense requests
  ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
  scsi: Do not wait for a request in scsi_eh_lock_door()
  scsi_transport_spi: Set RQF_PM for domain validation commands
  scsi: Only process PM requests if rpm_status != RPM_ACTIVE
  block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT

 block/blk-core.c                  | 12 ++++++------
 block/blk-mq-debugfs.c            |  1 -
 block/blk-mq.c                    |  4 ++--
 block/blk-pm.c                    | 15 +++++++++------
 block/blk-pm.h                    | 14 +++++++++-----
 drivers/ide/ide-atapi.c           |  1 -
 drivers/ide/ide-io.c              |  7 +------
 drivers/ide/ide-pm.c              |  2 +-
 drivers/scsi/scsi_error.c         |  7 ++++++-
 drivers/scsi/scsi_lib.c           | 27 ++++++++++++++-------------
 drivers/scsi/scsi_transport_spi.c | 27 +++++++++++++++++++--------
 include/linux/blk-mq.h            |  4 ++--
 include/linux/blkdev.h            |  6 +-----
 13 files changed, 70 insertions(+), 57 deletions(-)

