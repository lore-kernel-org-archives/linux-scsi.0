Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2163DC3F2CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0029F21556
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgCEEyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:54:39 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42374 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgCEEyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:54:39 -0500
Received: by mail-pf1-f196.google.com with SMTP id f5so2139249pfk.9
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2020 20:54:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a4arn3+z0djVRoPiaT9H3CuPNjHYfljY/DlqhcnXh7M=;
        b=it+Z/72UiqvkiWlDAFtHNKEFB7BUjC1uYb9OxjYyDE4LTM/o+ILPQKGq/nMDFIKk4q
         PgA/HZAvL78+e9McHchcR7ZIXlL1B4DcbB9vj44VofypBitBNK1/PX3FU5+pgPR0UD49
         zbHP3Hz+hUdDl+8ffg9KgzYjBvqh3xABaA/sqeRSANXpbh+1S+Z63mCEAAVxdn8OcqIx
         Bzq5Q/Ok3M/SOjXfj7NcD8jEKKF5OP+0leqZ+K97p1x7DvhWl12Z2DMHtYthsvsW3w5F
         ZIERB0RbejgycchwJPYBhdk/KN52HF2F0wiV4qjeRJ0Zu+XEoEGmNDbNDBfsdVFE9PGM
         jlUg==
X-Gm-Message-State: ANhLgQ0FDPb1PWDjrwru8KJaEH4bE/uX7f6DuYfEYke99Zy3vEu0YdB8
        ZG5LD/w4BbEM0GdNw17XcIE/VGrW
X-Google-Smtp-Source: ADFU+vtV1IMdaqsmOLB63u8jjXCZKxhnXDzl3VlUHNgeg60klNCowQTRCJZzjesXUmQ+C5MneMd2NA==
X-Received: by 2002:a63:7c54:: with SMTP id l20mr5709509pgn.158.1583384078045;
        Wed, 04 Mar 2020 20:54:38 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:ec16:4fc:3bb2:cb4a])
        by smtp.gmail.com with ESMTPSA id y14sm313721pfp.59.2020.03.04.20.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 20:54:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/6] Fix qla2xxx endianness annotations
Date:   Wed,  4 Mar 2020 20:54:25 -0800
Message-Id: <20200305045431.30061-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes the endianness annotations in the qla2xxx driver.
Please consider this patch series for the v5.7 kernel.

Thanks,

Bart.

Changes compared to v2:
- Removed one BUILD_BUG_ON() statement.

Changes compared to v1:
- Left out the raw_smp_processor_id() patch because it may take time to achieve
  agreement about this patch.
- Added three patches to this series: two patches for verifying structure size
  at compile time and one patch for changing function names from upper case to
  lower case.

Bart Van Assche (6):
  qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
  qla2xxx: Add more BUILD_BUG_ON() statements
  qla2xxx: Fix endianness annotations in header files
  qla2xxx: Fix endianness annotations in source files
  qla2xxx: Fix the code that reads from mailbox registers
  qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into
    lower case

 drivers/scsi/qla2xxx/qla_attr.c    |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.c     | 672 +++++++++++++-------------
 drivers/scsi/qla2xxx/qla_dbg.h     | 442 ++++++++---------
 drivers/scsi/qla2xxx/qla_def.h     | 711 ++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_fw.h      | 738 ++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_init.c    | 279 +++++------
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
 drivers/scsi/qla2xxx/qla_os.c      | 128 +++--
 drivers/scsi/qla2xxx/qla_sup.c     | 345 +++++++-------
 drivers/scsi/qla2xxx/qla_target.c  |  84 ++--
 drivers/scsi/qla2xxx/qla_target.h  | 208 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    |  12 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  14 +
 24 files changed, 2317 insertions(+), 2190 deletions(-)

