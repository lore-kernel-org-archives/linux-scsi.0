Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33064C54E4B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A15520720
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgEKUJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:09:55 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35791 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUJy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:09:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id t11so5060081pgg.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r7t9mX+ynCZukHIMwO5viAv6h8NNfbIWW/U9afp856w=;
        b=G7WUY1O52Zn5F/ttHNDFgO7Z+w/NgRlT09V1G9v2DNadvM2wNfg5LYjL9a1rJX4mp2
         iV1yy4qXltiXwsFYYijOupkXVGol4wP+COXzICZysakcCsfHDsvSZWIRALktrHmD+1he
         WskkO59GPLWbuspa53VNZVIwF4Cig+VHUOADZNTzrl3c7fMgkyip6m092jMSBkMeBRSZ
         I1zEkZme+JU5CfnYDv7Z+87C2Um646uTKd57hLOlcQnD1O7uBLxZxOFcuEur1clcpYUU
         QzjDpOFrLXfVo6lEOQYT0Rvfq5m1wb5c9JY+SHtmDewJP7g0yAcL/xQzJt93omMHbnd9
         EYzg==
X-Gm-Message-State: AGi0PubByir7GZnpegVi9GTdx08SJGVGxfr4SieM9AEV9BDs//G3p6dV
        tfDGhFNaA8yRxWTdM9sDPTY=
X-Google-Smtp-Source: APiQypJKWaRufuikHkY86vF4TR7+v6u7Xw9JSS64ey9xF1RbQoan9+kIuHRbkg7zIG6qH5s2WWKZXA==
X-Received: by 2002:a63:6f07:: with SMTP id k7mr16925161pgc.274.1589227792399;
        Mon, 11 May 2020 13:09:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:09:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 00/15] Fix qla2xxx endianness annotations
Date:   Mon, 11 May 2020 13:09:31 -0700
Message-Id: <20200511200946.7675-1-bvanassche@acm.org>
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
- Addressed Hannes' and most of Arun's review comments.
- Suppressed a clang warning for the patch that suppresses a gcc warning.
- Included three new patches. Two of these patches compensate for recently
  introduced changes (broken C=2 build and using register offsets instead of
  register names) and one new patch to make the last patch in this series
  easier to read.

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

Bart Van Assche (15):
  qla2xxx: Fix spelling of a variable name
  qla2xxx: Suppress two recently introduced compiler warnings
  qla2xxx: Simplify the functions for dumping firmware
  qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
  qla2xxx: Add more BUILD_BUG_ON() statements
  qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
  qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
    FCP_PRIO_CFG_SIZE
  qla2xxx: Change two hardcoded constants into offsetof() / sizeof()
    expressions
  qla2xxx: Use register names instead of register offsets
  qla2xxx: Fix the code that reads from mailbox registers
  qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into
    lower case
  qla2xxx: Cast explicitly to uint16_t / uint32_t
  qla2xxx: Use make_handle() instead of open-coding it
  qla2xxx: Fix endianness annotations in header files
  qla2xxx: Fix endianness annotations in source files

 drivers/scsi/qla2xxx/qla_attr.c    |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   8 +-
 drivers/scsi/qla2xxx/qla_dbg.c     | 825 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_dbg.h     | 443 ++++++++--------
 drivers/scsi/qla2xxx/qla_def.h     | 715 +++++++++++++------------
 drivers/scsi/qla2xxx/qla_fw.h      | 768 +++++++++++++--------------
 drivers/scsi/qla2xxx/qla_gbl.h     |  21 +-
 drivers/scsi/qla2xxx/qla_init.c    | 286 +++++-----
 drivers/scsi/qla2xxx/qla_inline.h  |   8 +-
 drivers/scsi/qla2xxx/qla_iocb.c    | 133 ++---
 drivers/scsi/qla2xxx/qla_isr.c     | 237 ++++-----
 drivers/scsi/qla2xxx/qla_mbx.c     | 123 +++--
 drivers/scsi/qla2xxx/qla_mid.c     |   4 +-
 drivers/scsi/qla2xxx/qla_mr.c      | 115 ++--
 drivers/scsi/qla2xxx/qla_mr.h      |  32 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  16 +-
 drivers/scsi/qla2xxx/qla_nvme.h    |  64 +--
 drivers/scsi/qla2xxx/qla_nx.c      | 163 +++---
 drivers/scsi/qla2xxx/qla_nx.h      |  36 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |  18 +-
 drivers/scsi/qla2xxx/qla_os.c      | 124 +++--
 drivers/scsi/qla2xxx/qla_sup.c     | 323 +++++------
 drivers/scsi/qla2xxx/qla_target.c  | 102 ++--
 drivers/scsi/qla2xxx/qla_target.h  | 232 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    |  39 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  14 +
 include/trace/events/qla.h         |   7 +
 27 files changed, 2447 insertions(+), 2412 deletions(-)

