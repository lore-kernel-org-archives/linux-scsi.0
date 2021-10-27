Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF68C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 09:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB3E6109E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 09:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbhJ0KCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241457AbhJ0KBj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 06:01:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I9j6032384
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=GO9VgERVdZyyav8A15MX4BBRc2bhaWW4edmYp121roE=;
 b=DpQ64zb+HyCRzWNXjGn1Bgj9EK01E4aWM9RXvNNzZrbgytRLE9/8nsAqju3s8yWKraqv
 Sd8RVHgGW+xpBp2Y7yyV7TcnHYQlpAvrwsdgQs/YOBaSSHhm5I4ev9g9JJzfliJt0K1e
 5+KjoyKtcVqz/vjacah/NjR4kh6gRXu6mfub3e+ELQamAQErcwDD4QQYBJFNx1wodlvG
 j0vKOMfVTdDx5e63YIsrGf3J3MCAC7u7RjM6Ln/33oynDR9/ptXtxFTb7hfL6Gervlfd
 wJ3UTtlGTGPlMqqc6YitX7W1TdJUhM9k9a1JAMd5T+3//uyLgy2pABLOYQnndF4CnxU0 VA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8the-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:59:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 02:59:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 67DA63F7070;
        Wed, 27 Oct 2021 02:59:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19R9x64E016397;
        Wed, 27 Oct 2021 02:59:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19R9wpEd016396;
        Wed, 27 Oct 2021 02:58:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 00/13] qla2xxx - misc driver and EDIF bug fixes
Date:   Wed, 27 Oct 2021 02:58:38 -0700
Message-ID: <20211027095851.16362-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: oqmEaZXfcbk74pTHt9zLZAdNcSygnjbv
X-Proofpoint-ORIG-GUID: oqmEaZXfcbk74pTHt9zLZAdNcSygnjbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the miscellaneous qla2xxx driver and EDIF bug fixes to the
scsi tree at your earliest convenience.

v4:
- remove split lines from debug message for patch 04/13

v3:
- Change port_id display format to %06x
- Add meaningful debug messages
- Add Reviewed-by tags

v2:
Add Fixes tag for relevant commits

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.200-k

Quinn Tran (12):
  qla2xxx: relogin during fabric disturbance
  qla2xxx: fix gnl list corruption
  qla2xxx: turn off target reset during issue_lip
  qla2xxx: edif: fix app start fail
  qla2xxx: edif: fix app start delay
  qla2xxx: edif: flush stale events and msgs on session down
  qla2xxx: edif: replace list_for_each_safe with
    list_for_each_entry_safe
  qla2xxx: edif: tweak trace message
  qla2xxx: edif: reduce connection thrash
  qla2xxx: edif: increase ELS payload
  qla2xxx: edif: fix inconsistent check of db_flags
  qla2xxx: edif: fix edif bsg

 drivers/scsi/qla2xxx/qla_attr.c     |   7 +-
 drivers/scsi/qla2xxx/qla_def.h      |   4 +-
 drivers/scsi/qla2xxx/qla_edif.c     | 325 +++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_edif.h     |  13 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   4 +-
 drivers/scsi/qla2xxx/qla_init.c     | 108 +++++++--
 drivers/scsi/qla2xxx/qla_iocb.c     |   3 +-
 drivers/scsi/qla2xxx/qla_isr.c      |   4 +
 drivers/scsi/qla2xxx/qla_mr.c       |  23 --
 drivers/scsi/qla2xxx/qla_os.c       |  37 +---
 drivers/scsi/qla2xxx/qla_target.c   |   3 +-
 drivers/scsi/qla2xxx/qla_version.h  |   4 +-
 13 files changed, 290 insertions(+), 247 deletions(-)


base-commit: efe1dc571a5b808baa26682eef16561be2e356fd
prerequisite-patch-id: 505841911eadc4a52bd4b72393ab50f095664f55
-- 
2.19.0.rc0

