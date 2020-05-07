Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748E7C38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5433C20838
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgEGE2o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:44 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55193 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgEGE2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:43 -0400
Received: by mail-pj1-f68.google.com with SMTP id y6so2065663pjc.4
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UGVI02czrPq86MbCuPaiCRiucQpOIoHSnHRcHGJLtsI=;
        b=bKBj2Db6erYeYqjctKUJF8hw0y73C5U05R72vkioZFwz5eXdeukCoaSpkVaO5FViQ8
         MQpz7A6OvPPI4VyuULFTkE7aCBdW6q4MvwogDFOeed3VQmV5EaCFx11SqcySqZLVLMPR
         PBf1kTKBdrUrqC7a4rPv5MAaLzBmdREwqQVFRbmTdNX3Q8Vi/Qc8XDUA/c39NXyVCxOl
         TLQY9YzD2RYKeRAppLVyTLnFwuf1YgGrNpHCypVSuRAg3Sh/CvCiuy1URCO173VI0ln+
         WS0Pn/G7p+APLmerayIvZzqC5DB9acyNagd86iQ8W73g0saiVNCocx5eSUgTWVTRGWYS
         zCAA==
X-Gm-Message-State: AGi0PuYHPo55U5NnkSVh0EAgrcVS5EYlLln5NwiUuM3DFfkVA2LLpMQB
        4h8GgCPU1wt5hjNc/aalBKUsXQBTWsA=
X-Google-Smtp-Source: APiQypKwWxF5IicST18tDR3At9Som7Cjl67LctRt+qCONlsay3awuDF6JCiqAh0jW4Vx91kTI66sOw==
X-Received: by 2002:a17:902:c113:: with SMTP id 19mr11334200pli.95.1588825722648;
        Wed, 06 May 2020 21:28:42 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 00/11] Fix qla2xxx endianness annotations
Date:   Wed,  6 May 2020 21:28:24 -0700
Message-Id: <20200507042835.9135-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes the endianness annotations in the qla2xxx driver.
Please consider this patch series for the v5.8 kernel.

Thanks,

Bart.

Changes compared to v4:
- Rebased on top of Martin's latest for-next branch.
- Added more Reviewed-by tags.

Changes compared to v3:
- Included several source code cleanup patches, e.g. to address isssues
  detected by checkpatch.

Changes compared to v2:
- Removed one BUILD_BUG_ON() statement.

Changes compared to v1:
- Left out the raw_smp_processor_id() patch because it may take time to achieve
  agreement about this patch.
- Added three patches to this series: two patches for verifying structure size
  at compile time and one patch for changing function names from upper case to
  lower case.

Bart Van Assche (11):
  qla2xxx: Fix spelling of a variable name
  qla2xxx: Suppress two recently introduced compiler warnings
  qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
  qla2xxx: Add more BUILD_BUG_ON() statements
  qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
  qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
    FCP_PRIO_CFG_SIZE
  qla2xxx: Change two hardcoded constants into offsetof() / sizeof()
    expressions
  qla2xxx: Fix the code that reads from mailbox registers
  qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into
    lower case
  qla2xxx: Fix endianness annotations in header files
  qla2xxx: Fix endianness annotations in source files

 drivers/scsi/qla2xxx/qla_attr.c    |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.c     | 672 +++++++++++++-------------
 drivers/scsi/qla2xxx/qla_dbg.h     | 443 ++++++++---------
 drivers/scsi/qla2xxx/qla_def.h     | 711 ++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_fw.h      | 746 ++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_init.c    | 280 +++++------
 drivers/scsi/qla2xxx/qla_inline.h  |   8 +-
 drivers/scsi/qla2xxx/qla_iocb.c    | 121 ++---
 drivers/scsi/qla2xxx/qla_isr.c     | 217 +++++----
 drivers/scsi/qla2xxx/qla_mbx.c     | 111 +++--
 drivers/scsi/qla2xxx/qla_mr.c      | 111 +++--
 drivers/scsi/qla2xxx/qla_mr.h      |  32 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  12 +-
 drivers/scsi/qla2xxx/qla_nvme.h    |  46 +-
 drivers/scsi/qla2xxx/qla_nx.c      | 161 +++----
 drivers/scsi/qla2xxx/qla_nx.h      |  36 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |  12 +-
 drivers/scsi/qla2xxx/qla_os.c      | 114 +++--
 drivers/scsi/qla2xxx/qla_sup.c     | 347 +++++++-------
 drivers/scsi/qla2xxx/qla_target.c  |  84 ++--
 drivers/scsi/qla2xxx/qla_target.h  | 208 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    |  12 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  14 +
 include/trace/events/qla.h         |   5 +
 25 files changed, 2314 insertions(+), 2196 deletions(-)

