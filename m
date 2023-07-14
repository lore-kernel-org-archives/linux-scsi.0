Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BD8EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 07:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbjGNHBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbjGNHBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 03:01:10 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF31171D
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:09 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DL45df017666
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=n+KIdnBi4A8Ct21T7wjmTHU/ZS2tqGHl5a2ssiAYoGA=;
 b=hOyYXfGOVXyqO+b9rCQfJvpmY5QGjMmlB+tMK6+tylD+uxpD9RSD6xq5rwTwTJV7Garj
 cYnU5VRG0EF2Pd7fW/QlJkTZMYGtAM7P3au/kZ67pWIp4KTHYBV1CLs5WsNSkU5SxMIv
 SeNLK02vIt1/IPngUn7GlAeh9g2iuBhg6mDJ33WGz4uf2cENLfeDlanM7D97t2sLp5sl
 swsDlAEf4XnuuUKKr+/UOZ1tC8En1ZG9OAZlab0UNbR7ScT809r1VA2N8bHyNLsL2Zi7
 87p3pj7zK9Fq8LvbK7zsqL12GfhxuHjMCLvDrUXMWYuY6GKWU2FkG2DiF3DeI363Xlau Aw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rtrux9mg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Jul
 2023 00:01:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 14 Jul 2023 00:01:07 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id E40BB3F7064;
        Fri, 14 Jul 2023 00:01:05 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 00/10] qla2xxx driver bug fixes
Date:   Fri, 14 Jul 2023 12:30:54 +0530
Message-ID: <20230714070104.40052-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 36QUrhvqFwB2z7peg-YcbBxApHt-ayZa
X-Proofpoint-ORIG-GUID: 36QUrhvqFwB2z7peg-YcbBxApHt-ayZa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to
the scsi tree at your earliest convenience.

v2:
- Remove extra line from qla_gbl.h in 02/10
- Add Reviewed-by tag

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.08.500-k

Quinn Tran (9):
  qla2xxx: Fix deletion race condition
  qla2xxx: Adjust iocb resource on qpair create
  qla2xxx: Limit TMF to 8 per function
  qla2xxx: Fix command flush during TMF
  qla2xxx: Fix erroneous link up failure
  qla2xxx: Fix session hang in gnl
  qla2xxx: Turn off noisy message log
  qla2xxx: Fix TMF leak through
  qla2xxx: fix inconsistent TMF timeout

 drivers/scsi/qla2xxx/qla_def.h     |   9 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   1 +
 drivers/scsi/qla2xxx/qla_init.c    | 217 ++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c    |   1 +
 drivers/scsi/qla2xxx/qla_isr.c     |   7 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   3 +
 drivers/scsi/qla2xxx/qla_nvme.c    |   3 +-
 drivers/scsi/qla2xxx/qla_os.c      |  11 +-
 drivers/scsi/qla2xxx/qla_target.c  |  14 +-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 10 files changed, 168 insertions(+), 102 deletions(-)


base-commit: 6f0a92fd7db1507b203111ee53632eeeba2daca5
-- 
2.23.1

