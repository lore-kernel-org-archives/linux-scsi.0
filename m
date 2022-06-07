Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1836C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiFGEqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiFGEqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:44 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9DDD0293
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXafo025411
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=dkxAQJ8xS5GofZyF7m1KR7S3FBe+I/uX6H4CkD1ZnuE=;
 b=c9fHaJEdyWPvphuV7zOtoTmwFSKQ+iTYjvK7OI3WZDr+38eXPM5G0woyLATFek2IR+Ma
 Y6sX2xzyClI0SknF7RcUo+GKo3S+B4fQeaGWPCSTqYekeImMr6yRIjB3PGgMvrEM7j7p
 TuQwcvXY0xiHl8ELzRFG+8Ujha9Xt5kjW6J6QqMhMvmMMLL+w+H4uy1fSTdqEXUd38J5
 P2mwzLs60Gyy+I7o1BeU8fUlivBqG1ZSeNiO4uMUxsJA6dBqKXQyg77eP+Dq1bZH5J/l
 mHXpvLFOWug0+MbO7TJIbPCVXY8NfXeL3wr8lP1GzO/ZFBOJ+7CZmoBNUTQavBXWjKLi mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 21:46:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 337203F7069;
        Mon,  6 Jun 2022 21:46:40 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/11] Misc EDiF bug fixes
Date:   Mon, 6 Jun 2022 21:46:16 -0700
Message-ID: <20220607044627.19563-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PLpusIVKp3QYAhoEwMx-X8c0l1g2MKpA
X-Proofpoint-GUID: PLpusIVKp3QYAhoEwMx-X8c0l1g2MKpA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver misc EDiF bug fixes to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.500-k

Quinn Tran (10):
  qla2xxx: edif: Reduce Initiator-Initiator thrashing
  qla2xxx: edif: bsg refactor
  qla2xxx: edif: wait for app to ack on sess down
  qla2xxx: edif: add bsg interface to read doorbell events
  qla2xxx: edif: Fix potential stuck session in sa update
  qla2xxx: edif: Synchronize NPIV deletion with authentication
    application
  qla2xxx: edif: add retry for els pass through
  qla2xxx: edif: remove old doorbell interface
  qla2xxx: edif: fix n2n discovery issue with secure target
  qla2xxx: edif: fix n2n login retry for secure device

 drivers/scsi/qla2xxx/qla_attr.c     |   2 -
 drivers/scsi/qla2xxx/qla_dbg.h      |   2 +-
 drivers/scsi/qla2xxx/qla_def.h      |   4 +-
 drivers/scsi/qla2xxx/qla_edif.c     | 523 ++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_edif.h     |   3 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 106 ++++--
 drivers/scsi/qla2xxx/qla_gbl.h      |   4 +-
 drivers/scsi/qla2xxx/qla_gs.c       | 118 +++++--
 drivers/scsi/qla2xxx/qla_init.c     |  11 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c      |   6 +-
 drivers/scsi/qla2xxx/qla_os.c       |   2 +-
 drivers/scsi/qla2xxx/qla_target.c   |  35 +-
 drivers/scsi/qla2xxx/qla_version.h  |   4 +-
 14 files changed, 536 insertions(+), 286 deletions(-)


base-commit: f9f0a46141e2e39bedb4779c88380d1b5f018c14
-- 
2.19.0.rc0

