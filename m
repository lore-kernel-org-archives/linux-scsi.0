Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A0CC3404C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E7724670
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgBTEet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:49 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36857 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgBTEet (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:34:49 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so1039471plm.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DhP8A8h0NC+CqW/sCfRK1urZh7G9en8Vph2CdYi2UK4=;
        b=Tp/+f8qsU8KvZR686re1/xT2r6Ey6ap/Nr4sGD7tZfSCqkZLHKQM9Xf2avCEoPkA7m
         PehbsPJPH15evVOLKDkuMEG9Fo5NTdS9PlqwJM/TSXdExChdrcb/Eb7aPCqvkGoIt+mL
         DraY7bhvhhq/Rd1ANLFq1+fXkO2ChVyv1d+zspGIsA/zD6ewzCD75CpV+sXMTB1uAp9e
         4MXK34+/llbJv8jjmzcfGUkKk6QX7Kl9bEb1ZWcZ7MV8KyOIpaGsaoxT5mTj5GNGTurG
         v0chltMwcHVnqyn6cwaPw9nChdCvLLbE+oWmbALQnKSmxuw/cM8T4oR7ueVr8DMTxgTD
         r0ww==
X-Gm-Message-State: APjAAAWcVHrAC2p8rPgPIoUtaGT+VtxMVESZVGhE3h/6RLF5dV7sG9jk
        PEmttcTpIka23yUx+/Lfi4o=
X-Google-Smtp-Source: APXvYqxjMaSKngWZE92SMHp26/0vGujWqx5LzdJHhQXH8cFJlpMoGKJlOV5M3ql3aDB+yWlLUIju3w==
X-Received: by 2002:a17:902:9f83:: with SMTP id g3mr29450527plq.101.1582173288351;
        Wed, 19 Feb 2020 20:34:48 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id b5sm1236263pfb.179.2020.02.19.20.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:34:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/5] qla2xxx patches for kernel v5.7
Date:   Wed, 19 Feb 2020 20:34:36 -0800
Message-Id: <20200220043441.20504-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these five qla2xxx patches for kernel v5.7.

Thanks,

Bart.

Changes compared to v2:
- Left out a patch that is already in Linus' tree.

Changes compared to v1:
- Dropped patch "Fix point-to-point mode for qla25xx and older"
- Added three new patches.

Bart Van Assche (5):
  qla2xxx: Simplify the code for aborting SCSI commands
  qla2xxx: Suppress endianness complaints in
    qla2x00_configure_local_loop()
  qla2xxx: Fix sparse warnings triggered by the PCI state checking code
  qla2xxx: Convert MAKE_HANDLE() from a define into an inline function
  qla2xxx: Fix the endianness annotations for the port attribute
    max_frame_size member

 drivers/scsi/qla2xxx/qla_def.h    | 14 +++++++-------
 drivers/scsi/qla2xxx/qla_gs.c     | 14 ++++++--------
 drivers/scsi/qla2xxx/qla_init.c   | 11 +++++------
 drivers/scsi/qla2xxx/qla_iocb.c   | 22 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_isr.c    |  5 -----
 drivers/scsi/qla2xxx/qla_mbx.c    | 15 +++++++--------
 drivers/scsi/qla2xxx/qla_mr.c     | 13 ++++++-------
 drivers/scsi/qla2xxx/qla_nvme.c   |  2 +-
 drivers/scsi/qla2xxx/qla_os.c     | 27 ++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_target.c |  6 +++---
 10 files changed, 60 insertions(+), 69 deletions(-)

