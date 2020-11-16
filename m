Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A3DC56202
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC8D222B8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgKPDFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 22:05:08 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36184 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgKPDFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 22:05:08 -0500
Received: by mail-pf1-f194.google.com with SMTP id a18so12654576pfl.3;
        Sun, 15 Nov 2020 19:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+mi5CAoQ0xOzeSSJo9a36UpsXsOrb4YFz3QtQezbL+k=;
        b=mU61poq8Yc31UTkA5Y5vwXDiJzXxPEKjRo+nFRwOgwPPg1UUmklZy3oGLcFXgRePUY
         BTb9OiMK8/NJJw8eC3sjvhgsX9FUolU0u+XCIKN42smaUT49CpWmorWZoDoXnHMP0oFZ
         1MdJvgnypIMxkOWm5zrnW2nOq8P35NwoyIio8Vf3HphkeozQylQ/pTyE99QZvPFc/A9G
         0MIsmNrfu2R5csEpXlLLIZI21ZzWFUwOClS+pwes9AhzBX8KjTD2G4YY1+6HmV+3EGDx
         klp3oP/w5fgL+vTMbHFPEx9FzWRKy75K8fzi7u74FGkaRsA5FSB/JfQvlbgZPG4APM7s
         G8hg==
X-Gm-Message-State: AOAM5312Z4LFbUGJHVEx/boYCKWN+2K8yMayLotIL+95Nt+jEE8BUgWQ
        KC0elXb8bSBSBW/02UrLZo0=
X-Google-Smtp-Source: ABdhPJxzroLnijNI68s6nTf6ZKLHRYyg2przot/KZ4LJVaCdA9zQ4sEFOO1xpre3+XAtbiOBtj5NLw==
X-Received: by 2002:a62:e116:0:b029:18b:d325:153f with SMTP id q22-20020a62e1160000b029018bd325153fmr11739289pfh.2.1605495907498;
        Sun, 15 Nov 2020 19:05:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r3sm17148131pjl.23.2020.11.15.19.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:05:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/9] Rework runtime suspend and SCSI domain validation
Date:   Sun, 15 Nov 2020 19:04:50 -0800
Message-Id: <20201116030459.13963-1-bvanassche@acm.org>
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

Changes compared to v1:
- Added Tested-by tags for the SCSI SPI patches.
- Rebased on top of mkp-scsi/for-next.

Alan Stern (1):
  block: Do not accept any requests while suspended

Bart Van Assche (8):
  block: Fix a race in the runtime power management code
  ide: Do not set the RQF_PREEMPT flag for sense requests
  scsi: Pass a request queue pointer to __scsi_execute()
  scsi: Rework scsi_mq_alloc_queue()
  scsi: Do not wait for a request in scsi_eh_lock_door()
  scsi_transport_spi: Make spi_execute() accept a request queue pointer
  scsi_transport_spi: Freeze request queues instead of quiescing
  block, scsi, ide: Only process PM requests if rpm_status != RPM_ACTIVE

 block/blk-core.c                  |  12 +--
 block/blk-mq-debugfs.c            |   1 -
 block/blk-mq.c                    |   4 +-
 block/blk-pm.c                    |  15 ++--
 block/blk-pm.h                    |  14 +--
 drivers/ide/ide-atapi.c           |   1 -
 drivers/ide/ide-io.c              |   3 +-
 drivers/ide/ide-pm.c              |   2 +-
 drivers/scsi/scsi_error.c         |   7 +-
 drivers/scsi/scsi_lib.c           |  74 ++++++++--------
 drivers/scsi/scsi_priv.h          |   2 +
 drivers/scsi/scsi_transport_spi.c | 139 +++++++++++++++++-------------
 include/linux/blk-mq.h            |   4 +-
 include/linux/blkdev.h            |   6 +-
 include/scsi/scsi_device.h        |  14 ++-
 15 files changed, 163 insertions(+), 135 deletions(-)

