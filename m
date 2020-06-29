Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8A5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7675E20780
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgF2WzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35843 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgF2WzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id j4so7677168plk.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=98jXunz1PnJssWJjku0YmZmjLInks8J/Dx0b0PkJqVE=;
        b=ddAfuZiZ5rGR8fw7neRbZt+Xoi4JydyTEiPZ/AX6gKD8FZfMkzi0Y/Lnb96CPfEomg
         JJmb4iKpVHSSrsUvb5Asbz9buuSKp0RcL4m6evJ98AAXjKBLiKxz2qG6hde3JLa9PfX7
         TLsFeyExPiuI5JpXOuCV3GwRxG5ny/IvwpEYTcZb/H/WAMo77FswLz+HwAswwxU7XhtR
         cVUPB+KwXBCxkUYo8rMxnhKu2C0/+CGfnZWwHgN4bA41K4fvgwv3x2Ve/KUiz2fKWfi4
         d5wO6LhEM03kjMFS/2GcQ4NuiluQ4vTerySAIzW5TodU+7xgy5N6T9XXx2DLKKbo8y30
         1wSg==
X-Gm-Message-State: AOAM531HFXatIAicZmSopk7EYxLN2S1aIYqmcU2hb2Cp1WxuQwsA4UgJ
        m4y//PkTglMWVlPhCoA+swy6UPzv
X-Google-Smtp-Source: ABdhPJzs1pVxziHAIhaV+Qk2HzCDBtd5r2czh/R0QWruQ7cEpPk6xJ1m7DR1JN4QdbNm43fEAPdoIg==
X-Received: by 2002:a17:902:c24a:: with SMTP id 10mr9093672plg.82.1593471304877;
        Mon, 29 Jun 2020 15:55:04 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/9] qla2xxx patches for kernel v5.9
Date:   Mon, 29 Jun 2020 15:54:45 -0700
Message-Id: <20200629225454.22863-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes cleanup patches and also patches that address
complaints from several static source code analyzers. Please consider these
patches for kernel v5.9.

Thanks,

Bart.

Changes compared to v1:
- Rewrote patch "Fix a Coverity complaint in qla2100_fw_dump()"

Bart Van Assche (9):
  qla2xxx: Check the size of struct fcp_hdr at compile time
  qla2xxx: Remove the __packed annotation from struct fcp_hdr and
    fcp_hdr_le
  qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
  qla2xxx: Initialize 'n' before using it
  qla2xxx: Remove a superfluous cast
  qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of
    request_t.handle
  qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
  qla2xxx: Make qla2x00_restart_isp() easier to read
  qla2xxx: Introduce a function for computing the debug message prefix

 drivers/scsi/qla2xxx/qla_bsg.c     |  3 +-
 drivers/scsi/qla2xxx/qla_dbg.c     | 98 ++++++++++--------------------
 drivers/scsi/qla2xxx/qla_dbg.h     |  1 +
 drivers/scsi/qla2xxx/qla_init.c    | 39 ++++++------
 drivers/scsi/qla2xxx/qla_iocb.c    |  4 +-
 drivers/scsi/qla2xxx/qla_nx.c      | 20 +++---
 drivers/scsi/qla2xxx/qla_target.h  |  4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
 8 files changed, 70 insertions(+), 100 deletions(-)

