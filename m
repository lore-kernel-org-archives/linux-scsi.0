Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9440C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 10:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA952251F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 10:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbhAEKjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 05:39:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57678 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728006AbhAEKjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 05:39:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105Aa8LF014013
        for <linux-scsi@vger.kernel.org>; Tue, 5 Jan 2021 02:39:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=QUvJ7q4NdBL90desMVmRKDjOS5XBhsvbXnyVKbb27zE=;
 b=UxzFIltPn814yr3/8ZwtIKkX53tX9ibF4cmYuX+LOkMeBz+dGNEA1CPdpXpmGYyuCdN4
 RzQpdb7fPuGgSd3ZvBETMA+0uMyS5eSQJK/KZm2rC9cG4ymyvFQ5/zqT1aILdxDbMXzb
 zmozZxt0opU+/bBPwipI9QyRMUog7pY6QTucRCmuQhxuoZhK5TDhJVQM2VC190qM5NPU
 14KtUSkW5x+QK60Hru+LdbVtCE1+hR7KTy8Qbk+FbDVxNpQCVxrIQ9ry9WALhV09yRLe
 UOczJUDz5sAoheEbjZtYaoseywQ5m/s+RL8J6kl/qBPFVQ/xyM7XZS4YpbYz4yNsG/v1 vA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ts7rnwkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 02:39:14 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jan
 2021 02:39:12 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jan
 2021 02:39:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 5 Jan 2021 02:39:12 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B46CE3F703F;
        Tue,  5 Jan 2021 02:39:11 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 105AdBUN025076;
        Tue, 5 Jan 2021 02:39:11 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 105AdBLA025075;
        Tue, 5 Jan 2021 02:39:11 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 0/7] qla2xxx driver enhancements
Date:   Tue, 5 Jan 2021 02:38:40 -0800
Message-ID: <20210105103847.25041-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-05,2021-01-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver enhancements to the scsi tree at your
earliest convenience.

v3:
Add complete fix for the warning reported by kernel test robot.

v2:
Fix warning reported by kernel test robot.


Bikash Hazarika (1):
  qla2xxx: Wait for ABTS response on I/O timeouts for NVMe

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.105-k

Quinn Tran (1):
  qla2xxx: Fix mailbox Ch erroneous error

Saurav Kashyap (4):
  qla2xxx: Implementation to get and manage host, target stats and
    initiator port
  qla2xxx: Add error counters to debugfs node
  qla2xxx: Move some messages from debug to normal log level
  qla2xxx: Enable NVME CONF (BIT_7) when enabling SLER

 drivers/scsi/qla2xxx/qla_attr.c    |   9 +
 drivers/scsi/qla2xxx/qla_bsg.c     | 342 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h     |   5 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   1 +
 drivers/scsi/qla2xxx/qla_def.h     |  83 +++++++
 drivers/scsi/qla2xxx/qla_dfs.c     |  28 +++
 drivers/scsi/qla2xxx/qla_fw.h      |  27 ++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  29 +++
 drivers/scsi/qla2xxx/qla_gs.c      |   1 +
 drivers/scsi/qla2xxx/qla_init.c    | 230 ++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |   8 +
 drivers/scsi/qla2xxx/qla_isr.c     |  82 ++++---
 drivers/scsi/qla2xxx/qla_mbx.c     |  18 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  90 +++++++-
 drivers/scsi/qla2xxx/qla_os.c      |  25 +++
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 16 files changed, 942 insertions(+), 40 deletions(-)


base-commit: be1b500212541a70006887bae558ff834d7365d0
-- 
2.19.0.rc0

