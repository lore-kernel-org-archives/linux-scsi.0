Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDEAC48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 05:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7921F6115A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 05:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFXF2v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 01:28:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49610 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229448AbhFXF2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 01:28:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O5GDnN024376
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 22:26:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=5zWB0kgYqBSjAEwxSrLy9qekZ1ZiEM4uzPZNe/mo8KM=;
 b=lQQsEv8Y5gTPThx7KdGFuNX46wdwuIK0bD8jm2llP/P72DHZjTUp+0DbGXcPQSIijL1b
 YLObwHM1MEs/rHg35lU8M84cujGEXo+dzhdKQseRzPtB0dnzidfbOL4CSSP+ernrNyKx
 XugLqPMphMIDvkt4m7Y86ACRM6Zruk2yA1d40rvm6HmE0l5pORVvs8CMk3QK5yl2s2E9
 51290b9gWbb5H0L+xOZXyNHzkm8UkuW4CJBoOetKrSjcc77VZZRraZVDZ7TvfK3l/IX5
 xrNCMez7UJ66CN4dg/6E9vhhUfmCKUmH4skMPvCBywwB2gkTxDPbqCvHcFe9dwVi4Qj3 yQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39cgc88qvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 22:26:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 22:26:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 23 Jun 2021 22:26:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B27B45B6953;
        Wed, 23 Jun 2021 22:26:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15O5QUNs021648;
        Wed, 23 Jun 2021 22:26:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15O5QU7n021647;
        Wed, 23 Jun 2021 22:26:30 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 00/11] qla2xxx: Add EDIF support
Date:   Wed, 23 Jun 2021 22:25:55 -0700
Message-ID: <20210624052606.21613-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DfJkUdVzpVyGa2ddjWl6ruDEUEWZplNy
X-Proofpoint-GUID: DfJkUdVzpVyGa2ddjWl6ruDEUEWZplNy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_03:2021-06-23,2021-06-24 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,
Please apply the EDIF support feature to the scsi tree at your earliest
convenience.

v4:
Reword subject line for patch 10/11.

v3:
- Incorporate the review comments.
- Enable recently added heartbeat validation for EDIF.

v2:
Split the EDIF support feature into logical commits for better readability.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.107-k

Quinn Tran (10):
  qla2xxx: Add start + stop bsg's
  qla2xxx: Add getfcinfo and statistic bsg's
  qla2xxx: Add send, receive and accept for auth_els
  qla2xxx: Add extraction of auth_els from the wire
  qla2xxx: Add key update
  qla2xxx: Add authentication pass + fail bsg's
  qla2xxx: Add detection of secure device
  qla2xxx: Add doorbell notification for app
  qla2xxx: Add encryption to IO path
  qla2xxx: Increment EDIF command and completion counts

 drivers/scsi/qla2xxx/Makefile       |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c     |    5 +
 drivers/scsi/qla2xxx/qla_bsg.c      |   90 +-
 drivers/scsi/qla2xxx/qla_bsg.h      |    3 +
 drivers/scsi/qla2xxx/qla_dbg.h      |    1 +
 drivers/scsi/qla2xxx/qla_def.h      |  195 +-
 drivers/scsi/qla2xxx/qla_edif.c     | 3409 +++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_edif.h     |  128 +
 drivers/scsi/qla2xxx/qla_edif_bsg.h |  220 ++
 drivers/scsi/qla2xxx/qla_fw.h       |   12 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   50 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    6 +-
 drivers/scsi/qla2xxx/qla_init.c     |  168 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |   69 +-
 drivers/scsi/qla2xxx/qla_isr.c      |  320 ++-
 drivers/scsi/qla2xxx/qla_mbx.c      |   33 +-
 drivers/scsi/qla2xxx/qla_mid.c      |    7 +-
 drivers/scsi/qla2xxx/qla_nvme.c     |    4 +
 drivers/scsi/qla2xxx/qla_os.c       |  101 +-
 drivers/scsi/qla2xxx/qla_target.c   |  145 +-
 drivers/scsi/qla2xxx/qla_target.h   |   19 +-
 drivers/scsi/qla2xxx/qla_version.h  |    4 +-
 22 files changed, 4845 insertions(+), 147 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
 create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h


base-commit: 041761f4a4db662e38b4ae9d510b8beb24c7d4b6
prerequisite-patch-id: 62258e2861a8064d0d7fc3ea4efbf71758054bde
-- 
2.19.0.rc0

