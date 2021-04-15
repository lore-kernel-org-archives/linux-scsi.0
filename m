Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC27C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6480610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhDOWJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:00 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:36636 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhDOWI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:08:59 -0400
Received: by mail-pg1-f179.google.com with SMTP id j7so8441288pgi.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XoXBJg5q8tcFIijbIfBlaEvCz9vRJHgYgg2LxOD3F8Q=;
        b=DFAmwnRxGX/zyllrG03OPT+6RQwmbjyaGtLcIOFLk4/kAGjI8pvS5tpKpD1qC4D1hG
         AMhKTeymOliB3ERIf4g2FGJjEMmVpegcCMU0SKPXVtbRAdLWYsooVbiBsFy8Z+y09qbz
         bWlRetk4zqEHQl8eQFnzUlsuLYWKbqTUBaMXInht6t418Fjc4x/3X92NsLkLyQ/Rq3ns
         TkTj4eOL4ne26hL9TykQj1NZqmjxcEk7nXXv5MWy72le1R6T5+wRXXJxstc75fzxJJ7x
         xDpGo8kduoOHdFF+USIIco64W+GcY0IC0Qm7fw3Xk3wmmZuuX5uDHdLVNPbLkY5Ght1h
         HGQg==
X-Gm-Message-State: AOAM532NeleXEL8LIxeMuxSTTBBDcTq2XjFlZfu0DTuZGi4NyRqcTM2T
        u4tYPPIWeWYpbTCFvrLdIJH8UwZ/nXA=
X-Google-Smtp-Source: ABdhPJx054KWuy+UwByX1I4oVQ8cxjUXxkfIX/xFSx9YX0Hwc0HzHzU39ubxMsPQkXQh3VmhYlOw5Q==
X-Received: by 2002:a63:df42:: with SMTP id h2mr5424415pgj.410.1618524515819;
        Thu, 15 Apr 2021 15:08:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/20] SCSI patches for kernel v5.13
Date:   Thu, 15 Apr 2021 15:08:06 -0700
Message-Id: <20210415220826.29438-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the following changes:
- Modify several source code comments.
- Rename scsi_softirq_done().
- Introduce enum scsi_disposition.
- Address CC=clang W=1 warnings.

Please consider these patches for Linux kernel v5.13.

Thanks,

Bart.

Changes compared to v1:
- Dropped the patch "iscsi: Suppress two clang format mismatch warnings".
- Split patch "target: Fix several format specifiers" into two patches:
  "target: Fix two format specifiers" and "target: Shorten ALUA error messages".

Bart Van Assche (20):
  Make the scsi_alloc_sgtables() documentation more accurate
  Remove an incorrect comment
  Rename scsi_softirq_done() into scsi_complete()
  Modify the scsi_send_eh_cmnd() return value for the SDEV_BLOCK case
  Introduce enum scsi_disposition
  aacraid: Remove an unused function
  libfc: Fix a format specifier
  fcoe: Suppress a compiler warning
  mpt3sas: Fix two kernel-doc headers
  myrb: Remove unused functions
  myrs: Remove unused functions
  qla4xxx: Remove an unused function
  smartpqi: Remove unused functions
  53c700: Open-code status_byte(u8) calls
  dc395x: Open-code status_byte(u8) calls
  sd: Introduce a new local variable in sd_check_events()
  target: Compare explicitly with SAM_STAT_GOOD
  target: Fix two format specifiers
  target: Shorten ALUA error messages
  target/tcm_fc: Fix a kernel-doc header

 drivers/ata/libata-eh.c                    |  2 +-
 drivers/scsi/53c700.c                      |  4 +-
 drivers/scsi/aacraid/aachba.c              |  5 --
 drivers/scsi/dc395x.c                      |  4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |  4 +-
 drivers/scsi/device_handler/scsi_dh_emc.c  |  4 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |  4 +-
 drivers/scsi/fcoe/fcoe_transport.c         |  2 +-
 drivers/scsi/libfc/fc_lport.c              |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c        |  4 +-
 drivers/scsi/myrb.c                        | 71 ----------------
 drivers/scsi/myrs.c                        | 99 ----------------------
 drivers/scsi/qla4xxx/ql4_nx.c              |  6 --
 drivers/scsi/scsi_error.c                  | 66 ++++++++-------
 drivers/scsi/scsi_lib.c                    | 19 +++--
 drivers/scsi/scsi_priv.h                   |  2 +-
 drivers/scsi/sd.c                          |  5 +-
 drivers/scsi/smartpqi/smartpqi_init.c      | 10 ---
 drivers/target/target_core_configfs.c      | 11 +--
 drivers/target/target_core_pr.c            |  6 +-
 drivers/target/target_core_pscsi.c         |  2 +-
 drivers/target/tcm_fc/tfc_sess.c           |  2 +-
 include/scsi/scsi.h                        | 21 ++---
 include/scsi/scsi_device.h                 |  2 +-
 include/scsi/scsi_dh.h                     |  3 +-
 include/scsi/scsi_eh.h                     |  2 +-
 26 files changed, 89 insertions(+), 273 deletions(-)

