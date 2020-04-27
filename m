Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8534FC54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648BF206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgD0DDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34370 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgD0DDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so8286269pfa.1
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KnN3gqhxrVOA9xUZF22dqkY+K6Fqyg/4yvfETWknLFY=;
        b=teV6Gc5YTcaWoReXzKHhSdg6xNcvIJDBkA4tkbsNME0FJr3G/uNlkXcVc+ZehF1mzR
         9KZIw0uf4UyZMFYZbwCoBgMmR4kVVV1MeQdXShU8D0AFBKhDKctovrUO50hQLo3zu+E9
         Wjd26UlvQqOPtnZxKNBgL6WUlfO75/raDjCaQ4GX59hiiQ6uTcX43k/q4uoyRllOCBMa
         Lv05Y28nNMLemMARRjAxOazRgYJN7V1vL13+efosy7Tc105fv9/1yfNU1w7CDvxeIzUF
         CPYtzmDTmbzzwqxX0825BhvSOukmRSr5goOmi1Bp5beukzMLUxU0AqpsV1WqAxjMAxoX
         IA0g==
X-Gm-Message-State: AGi0PuZRJZ428jjAaEAxc7VArNDBXq/x1YrYaNtHvt6vuyivivcEo1CJ
        qwzCtXxpqK4Ue5OdNebpn5FFyg3cKBc=
X-Google-Smtp-Source: APiQypJ8FfQwkxb/bM88BNJs0MueROJ+YfoPBr2V60fCuK8/J2Um+bkeP4AnD1Xt0IHla2am1O+IOw==
X-Received: by 2002:a63:1160:: with SMTP id 32mr20460139pgr.441.1587956596837;
        Sun, 26 Apr 2020 20:03:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/11] Fix qla2xxx endianness annotations
Date:   Sun, 26 Apr 2020 20:02:59 -0700
Message-Id: <20200427030310.19687-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
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

