Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C779C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F388F207C4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgERVRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34539 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERVRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id f6so5430022pgm.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QnQgfLz2nHDiBLVtNL/q0ycI5I6jRr2sV6gZtrIHrQ4=;
        b=OuE+GiXW+aCn6q4QYvG1axJOJKnXNLlWzB5mhP/u7IBFgcO7rwv5ba5LmgjWR8C1eN
         fdWo+ThtdnBbbkEM21auhlPGRezrODF0NwFXljoJgFvIhBvKtHtYpF/riEnOo3GQigup
         skjvDjohn/iAUTxlZErUNEgAGwTVmQq+vr0ist+xtzHypEgDnpWkwnO8o6DTbQXZav1U
         yLfE8PPxwzWpgguhNdpEgMfLI89zEmR/IYMeXO9NxKXLBIVPhzcFi+Xrx0MH51LH4g1j
         4vBj6Eo3t7rk4Q8Uimpw6iWlTbgmgs9Hh3xy+kPhdDMM5f6WKqGeNhuxrB9eC458ioQU
         YMKA==
X-Gm-Message-State: AOAM5328SpPm4JZFfdIT6tHeULVXWgdt2wMfgDGOrqb6ttK7jKFwm/lo
        MoGT6hte+jgXKW3Nv7tkhy4=
X-Google-Smtp-Source: ABdhPJxjpIc0Dd1VeDCF9n7TxG0OsZkcbQ8n0HycKiL1JHEnMmaMOmz4WI54kq+cE1r72nRiqR11xQ==
X-Received: by 2002:a05:6a00:1342:: with SMTP id k2mr4810716pfu.32.1589836638874;
        Mon, 18 May 2020 14:17:18 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 00/15] Fix qla2xxx endianness annotations
Date:   Mon, 18 May 2020 14:16:57 -0700
Message-Id: <20200518211712.11395-1-bvanassche@acm.org>
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

Changes compared to v6:
- Changed the endianness of qla27xx_fwdt_template.firmware_version from
  CPU-endian into little endian.

Changes compared to v5:
- Added Reviewed-by tags posted as replies to v4 and v5.

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
 drivers/scsi/qla2xxx/qla_dbg.c     | 826 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_dbg.h     | 443 ++++++++--------
 drivers/scsi/qla2xxx/qla_def.h     | 715 +++++++++++++------------
 drivers/scsi/qla2xxx/qla_fw.h      | 768 +++++++++++++--------------
 drivers/scsi/qla2xxx/qla_gbl.h     |  21 +-
 drivers/scsi/qla2xxx/qla_init.c    | 286 +++++-----
 drivers/scsi/qla2xxx/qla_inline.h  |   8 +-
 drivers/scsi/qla2xxx/qla_iocb.c    | 135 ++---
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
 drivers/scsi/qla2xxx/qla_target.c  | 104 ++--
 drivers/scsi/qla2xxx/qla_target.h  | 232 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    |  41 +-
 drivers/scsi/qla2xxx/qla_tmpl.h    |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  14 +
 include/trace/events/qla.h         |   7 +
 28 files changed, 2454 insertions(+), 2414 deletions(-)

