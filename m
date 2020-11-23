Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A67C63798
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74F12158C
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgKWDR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:17:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44560 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbgKWDR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:17:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id y7so13570110pfq.11;
        Sun, 22 Nov 2020 19:17:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdacO1PAka2oa8mQksw1pu4/yi2dGdopCnDapBlAxf0=;
        b=B6nkBYVYegoslGXaLiga1mnoEnOqoEjKa6S5FMgwkkSYCVvAJHFuM3HGMzpY72uuPW
         9sbcDSLuQCesl2pX4VEKtiIjt3W7Jgw2USSQazxkBNjTo6v02Z4J7HeT98mGdP9eLqBd
         KLSiKOwg+PFzcBuAu5ISLDn/JPJzVqjq8Q236CRQ6BFWFilIM2dsuJ1M2inBYBfDV4XZ
         oxWAXR/nS8UKwRPB6GJq0czjuoCPOaZ0OVkEiptQ2beBqtcK1Ci8J1DBqZXg7aRXWBWY
         OUdF6g4/v+8kbWrcAH623Ft5mpVPmnHpsvM1kMl3gY308o+MTQJ0ByCDuQnzXtg0F6iS
         fkVQ==
X-Gm-Message-State: AOAM533+WFE4Geq2F9LnHFUpe9LQLw2cFPXCB1zZDYcnYauVA5m6PUgp
        hKeL0lGp7LRxu9EgFL0ggaQ=
X-Google-Smtp-Source: ABdhPJwyCJz/xswKK8RgXirTVtta98y+e6uasurYUM3006ZYr7Yb2rwEFSqSIH1NbyPMBTTwMWB3Yg==
X-Received: by 2002:a17:90a:f691:: with SMTP id cl17mr1534082pjb.206.1606101476735;
        Sun, 22 Nov 2020 19:17:56 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:17:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/9] Rework runtime suspend and SCSI domain validation
Date:   Sun, 22 Nov 2020 19:17:40 -0800
Message-Id: <20201123031749.14912-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The SCSI runtime suspend and domain validation mechanisms both use
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

Changes between v2 and v3:
- Inlined scsi_mq_alloc_queue() into scsi_alloc_sdev() as requested by
  Christoph.

Changes between v1 and v2:
- Rebased this patch series on top of kernel v5.10-rc1.

Alan Stern (1):
  block: Do not accept any requests while suspended

Bart Van Assche (8):
  block: Fix a race in the runtime power management code
  ide: Do not set the RQF_PREEMPT flag for sense requests
  scsi: Pass a request queue pointer to __scsi_execute()
  scsi: Inline scsi_mq_alloc_queue()
  scsi: Do not wait for a request in scsi_eh_lock_door()
  scsi_transport_spi: Make spi_execute() accept a request queue pointer
  scsi_transport_spi: Freeze request queues instead of quiescing
  block, scsi, ide: Only process PM requests if rpm_status != RPM_ACTIVE

 block/blk-core.c                  |  12 +--
 block/blk-mq-debugfs.c            |   1 -
 block/blk-mq.c                    |   4 +-
 block/blk-pm.c                    |  15 +--
 block/blk-pm.h                    |  14 ++-
 drivers/ide/ide-atapi.c           |   1 -
 drivers/ide/ide-io.c              |   3 +-
 drivers/ide/ide-pm.c              |   2 +-
 drivers/scsi/scsi_error.c         |   7 +-
 drivers/scsi/scsi_lib.c           |  72 ++++++--------
 drivers/scsi/scsi_priv.h          |   3 +-
 drivers/scsi/scsi_scan.c          |  12 ++-
 drivers/scsi/scsi_transport_spi.c | 151 ++++++++++++++++++------------
 include/linux/blk-mq.h            |   4 +-
 include/linux/blkdev.h            |   6 +-
 include/scsi/scsi_device.h        |  14 ++-
 16 files changed, 175 insertions(+), 146 deletions(-)

