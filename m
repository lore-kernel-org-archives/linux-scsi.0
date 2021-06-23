Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55547C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37EB660E08
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFWK3v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:29:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59220 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230036AbhFWK3u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 06:29:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15NACQ2A013614
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:27:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=8jMjxC4gvgiWnDKTAOmKUI0D5dews+6NDfMfxXFDirI=;
 b=ZZ+oTp7kD6ee6tUA9PXOlTimodxtHCPr+5ZbeMJ0pPZL9tnO6hxPNelmuWil7K2Dhsfy
 hhcgAxYNsv4EWk1Mzaj0f5AFpfIF05V/2tP9nC+aNHpDHRlUdrI8yYQFYSqOlpVN8ndC
 ZFQpHAAxUbESgBRgP2w7O8DHjDCSYcBWGT/dqRTXtP2FmMbrNkG2NnuspbBi7namktcl
 0UJBXKSGtznoVLVUavW6W9Mmfpus/xctgLiiWeBIvWW5dPv+1+VDy32qpQ5ywqDIOOfv
 yEgHJXWnrTxIPQjCWVIWaIqjPweB0qePIqmnrEzgvrG8Mc1NfYfQnjozxtW8hbUa5OW9 1A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39bptj2hy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:27:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 03:26:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 23 Jun 2021 03:26:35 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E0D275B6938;
        Wed, 23 Jun 2021 03:26:35 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15NAQZxs003672;
        Wed, 23 Jun 2021 03:26:35 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15NAQZ5Z003671;
        Wed, 23 Jun 2021 03:26:35 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 00/11] qla2xxx: Add EDIF support
Date:   Wed, 23 Jun 2021 03:26:00 -0700
Message-ID: <20210623102611.3637-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 8Y7hQ11NWSFvZJpGuYXx2uLTyHzmMvRM
X-Proofpoint-GUID: 8Y7hQ11NWSFvZJpGuYXx2uLTyHzmMvRM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_03:2021-06-23,2021-06-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,
Please apply the EDIF support feature to the scsi tree at your earliest
convenience.

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
  qla2xxx: enable heartbeat validation for edif command

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

