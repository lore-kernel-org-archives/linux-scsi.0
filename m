Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7694DC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 07:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbjD1HyX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345261AbjD1HyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 03:54:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D6C19BB
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:50 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S4FLoh032403
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=iqYN7Pzl/ntpE2Eqrvfogc4hl734RE7/pQ7wG/popH8=;
 b=aErA8JKYKXbncDMVONrUd4O0Dcr7r/lhRbZgLrHskxK3Dwns3G5zbDhSBdqIZ8jx1/x/
 qy2D/5GwtOewTdU8vpHX/bFrXuBb2d/OY+ETcFl3bWUivtxdf/RcfzHiCNOu7cPfNhB8
 EsfG8MdWZ+qWCzYgydWOaLo5Cs4FsDehjmEbe6DvA9XEW6WS0CZWUgGvnPqHmpYBonai
 IJL9Xutfrg5Xd7uRxIJd+6ChhogLyCM8uuqPudVF+Pr/6C1KTszupPVZOqp3hChGDXul
 UBou7ssoLHARlYmkhNDGtfR353NwGFd8ZLMaqLo3FRuonUj124V//uUyEMspK72Z6/8S iQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q85x60va8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 28 Apr
 2023 00:53:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 28 Apr 2023 00:53:45 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 146175B6930;
        Fri, 28 Apr 2023 00:53:45 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 0/7] qla2xxx driver update
Date:   Fri, 28 Apr 2023 00:53:32 -0700
Message-ID: <20230428075339.32551-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: NMEneATzfrDuz_UNcNOdo7PS9wS4EZ6u
X-Proofpoint-ORIG-GUID: NMEneATzfrDuz_UNcNOdo7PS9wS4EZ6u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_02,2023-04-27_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver enhancement and bug fixes to
the scsi tree at your earliest convenience.

Thanks,
Nilesh

v2:
- Fix warnings reported by kernel robot.

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.08.300-k

Quinn Tran (6):
  qla2xxx: Multi-que support for TMF
  qla2xxx: Fix task management cmd failure
  qla2xxx: Fix task management cmd fail due to unavailable resource
  qla2xxx: Fix hang in task management
  qla2xxx: Fix mem access after free
  qla2xxx: Wait for io return on terminate rport

 drivers/scsi/qla2xxx/qla_attr.c    |  13 ++
 drivers/scsi/qla2xxx/qla_def.h     |  21 +++
 drivers/scsi/qla2xxx/qla_gbl.h     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c    | 256 ++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_iocb.c    |  33 +++-
 drivers/scsi/qla2xxx/qla_isr.c     |  64 ++++++--
 drivers/scsi/qla2xxx/qla_os.c      | 130 ++++++++-------
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 8 files changed, 418 insertions(+), 105 deletions(-)


base-commit: c8e22b7a1694bb8d025ea636816472739d859145
-- 
2.23.1

