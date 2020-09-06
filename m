Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC96C43461
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BAB20C09
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgIFBW2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:22:28 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35222 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFBW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:22:27 -0400
Received: by mail-pj1-f65.google.com with SMTP id g6so4762187pjl.0;
        Sat, 05 Sep 2020 18:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y8P3mIHd6ojJKrdWs6XRkjCCCxjWTf60yFc1j4m7E/w=;
        b=W/xnP0fgmvK9XIpahiSk2pOrvz9zRH+zX5TiA+3cSmIqBrghKAzQ83yl9trjRGf752
         zBqENj7LaHACFFxwNYC/p6W74BJ3soqyZN/DG0jRKAlziLvHGEFvbLtiKjwPmKVipImn
         m+WjImipaMwfkYm9JO6B5MHdKc1CP7f5ogMfx/D+kZOFh/6P1D1pULIkdVGu2p2AW918
         q/UOOR8KItmuFHvHeUejnwV6EL0ONIZzdubQQRl3Eo0h542tXYpCOJJVHDzNqnVI/SuQ
         cjo4BtuSw7efeYprfo8OkV/49BDBxX+0V+aThNaZqTC1UNsW9tAHLKPvI5OfuJl1mN7J
         4h7w==
X-Gm-Message-State: AOAM531BCKbWJkMrdh6uF+NAAlkc5uli7nq0Nu1giLvdCIxx4SYeHfis
        9AXWgD6T4nqbilmkTQ36Ws0=
X-Google-Smtp-Source: ABdhPJxas14xGh5T55KwWXMiIx7io1GuyxS3OcNkcqQo73B8qM2lruLbEVWsLzBFoxqqG/SV4rQTww==
X-Received: by 2002:a17:902:e993:: with SMTP id f19mr14625702plb.270.1599355346755;
        Sat, 05 Sep 2020 18:22:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/9] Rework runtime suspend and SCSI domain validation
Date:   Sat,  5 Sep 2020 18:22:10 -0700
Message-Id: <20200906012219.17893-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

The SCSI runtime suspend and domain validation mechanisms both use
scsi_device_quiesce(). scsi_device_quiesce() restricts blk_queue_enter() to
BLK_MQ_REQ_PREEMPT requests. There is a conflict between the requirements
of runtime suspend and SCSI domain validation: no requests must be sent to
runtime suspended devices that are in the state RPM_SUSPENDED while
BLK_MQ_REQ_PREEMPT requests must be processed during SCSI domain
validation. This conflict is resolved by reworking the SCSI domain
validation implementation.

Hybernation and runtime suspend have been retested but SCSI domain
validation not yet.

Please consider this patch series for kernel v5.10.

Thanks,

Bart.

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
 drivers/scsi/scsi_error.c         |   3 +-
 drivers/scsi/scsi_lib.c           |  73 ++++++++--------
 drivers/scsi/scsi_priv.h          |   2 +
 drivers/scsi/scsi_transport_spi.c | 139 +++++++++++++++++-------------
 include/linux/blk-mq.h            |   4 +-
 include/linux/blkdev.h            |   6 +-
 include/scsi/scsi_device.h        |  14 ++-
 15 files changed, 158 insertions(+), 135 deletions(-)

