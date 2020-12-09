Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E42C19425
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB7ED23B77
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgLIFar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 00:30:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34260 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbgLIFal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 00:30:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id w6so285405pfu.1;
        Tue, 08 Dec 2020 21:30:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQJISQRfqnfIEwhNSFqIfxEkoIa370X69ODE4/s7ieU=;
        b=p2tzmxCMOICQlpouIlH1Hump2qBfX6izvMh4Ws+jQPmfyWJw6k61UvXjM46GgePgic
         Akuk/9KIggsSw1mYj8NzrKmmvceS2TeX+grtCmCRKmwda0vTzgMCmKCEan1n9TnUFlxT
         TOtSHERfwL5spiWNaHxcusV2UhFpE+VkXQDlNnWrNZZ/3I/9C3oJyHTNs++6Df7GXQXX
         0owE3IZmFv02sEYs8b8TWG+epqq+W4ilJ95tasmGcSxxJqtUy49ETB94WW1J+vdDRFsM
         pXhR0Oxsq9vTmrukCfZb2nxg+9LGHtHVXPW821MJvJaGVrYXMkHFNnDIOS3KAp1wLKRI
         v9qA==
X-Gm-Message-State: AOAM533Qsb6OsVJoslVbhwILsKMbDwWyssNQCyK06hI9TVcPJntiHELE
        f3RjN3XLhsZH1fU/FoPvRkU=
X-Google-Smtp-Source: ABdhPJySd2Uz/D5FdeSW1k9M52O2X59ijCIoTJUVT7ffqHE7ich9XIsSVh27tT9oii/vwnYXvWiL/w==
X-Received: by 2002:a63:1d55:: with SMTP id d21mr501635pgm.324.1607491800294;
        Tue, 08 Dec 2020 21:30:00 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 77sm753097pfv.16.2020.12.08.21.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:29:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/8] Rework runtime suspend and SPI domain validation
Date:   Tue,  8 Dec 2020 21:29:43 -0800
Message-Id: <20201209052951.16136-1-bvanassche@acm.org>
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

Changes between v4 and v5:
- Fixed the CONFIG_PM=n build.
- Left out patch "scsi: Do not wait for a request in scsi_eh_lock_door()".

Changes between v3 and v4:
- Instead of creating a second request queue for SPI DV, set RQF_PM.

Changes between v2 and v3:
- Inlined scsi_mq_alloc_queue() into scsi_alloc_sdev() as requested by
  Christoph.

Changes between v1 and v2:
- Rebased this patch series on top of kernel v5.10-rc1.

Alan Stern (1):
  block: Do not accept any requests while suspended

Bart Van Assche (7):
  block: Fix a race in the runtime power management code
  block: Introduce BLK_MQ_REQ_PM
  ide: Do not set the RQF_PREEMPT flag for sense requests
  ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
  scsi_transport_spi: Set RQF_PM for domain validation commands
  scsi: Only process PM requests if rpm_status != RPM_ACTIVE
  block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT

 block/blk-core.c                  | 13 +++++++------
 block/blk-mq-debugfs.c            |  1 -
 block/blk-mq.c                    |  4 ++--
 block/blk-pm.c                    | 15 +++++++++------
 block/blk-pm.h                    | 14 +++++++++-----
 drivers/ide/ide-atapi.c           |  1 -
 drivers/ide/ide-io.c              |  7 +------
 drivers/ide/ide-pm.c              |  2 +-
 drivers/scsi/scsi_lib.c           | 27 ++++++++++++++-------------
 drivers/scsi/scsi_transport_spi.c | 27 +++++++++++++++++++--------
 include/linux/blk-mq.h            |  4 ++--
 include/linux/blkdev.h            | 18 +++++++++++++-----
 12 files changed, 77 insertions(+), 56 deletions(-)

