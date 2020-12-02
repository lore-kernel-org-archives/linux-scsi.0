Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C9DC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4621221FB
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLBNYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:24:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726567AbgLBNYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:24:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DFUgw016245
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:23:38 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8frr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:23:38 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:23:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:23:37 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 06D813F703F;
        Wed,  2 Dec 2020 05:23:37 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DNaGP020009;
        Wed, 2 Dec 2020 05:23:36 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DNa1c020000;
        Wed, 2 Dec 2020 05:23:36 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/15] qla2xxx bug fixes
Date:   Wed, 2 Dec 2020 05:22:57 -0800
Message-ID: <20201202132312.19966-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,
Please apply the qla2xxx bug fixes to the scsi tree at your
earliest convenience.

v1=>v2:
Incorporate review comments
Add call trace details
Add missing Fixes and stable tag
Add Reviewed-by tag

Thanks,
Nilesh

Arun Easi (5):
  qla2xxx: Fix compilation issue in PPC systems
  qla2xxx: Fix crash during driver load on big endian machines
  qla2xxx: Fix FW initialization error on big endian machines
  qla2xxx: Fix flash update in 28XX adapters on big endian machines
  qla2xxx: Fix device loss on 4G and older HBAs.

Daniel Wagner (1):
  scsi: qla2xxx: Return EBUSY on fcport deletion

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.104-k

Quinn Tran (3):
  qla2xxx: limit interrupt vectors to number of cpu
  qla2xxx: tear down session if FW say its down
  qla2xxx: fix N2N and NVME connect retry failure

Saurav Kashyap (5):
  qla2xxx: Change post del message from debug level to log level
  qla2xxx: Don't check for fw_started while posting nvme command
  qla2xxx: Handle aborts correctly for port undergoing deletion
  qla2xxx: Fix the call trace for flush workqueue
  qla2xxx: If fcport is undergoing deletion return IO with retry

 drivers/scsi/qla2xxx/qla_gs.c      |  8 ++--
 drivers/scsi/qla2xxx/qla_init.c    | 74 ++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_isr.c     | 34 ++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  9 ++--
 drivers/scsi/qla2xxx/qla_nvme.c    | 14 +++---
 drivers/scsi/qla2xxx/qla_nx.c      |  2 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |  4 +-
 drivers/scsi/qla2xxx/qla_os.c      | 10 ++--
 drivers/scsi/qla2xxx/qla_sup.c     | 10 ++--
 drivers/scsi/qla2xxx/qla_target.c  |  2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  9 ++--
 drivers/scsi/qla2xxx/qla_tmpl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 13 files changed, 121 insertions(+), 61 deletions(-)


base-commit: cf4d4d8ebdb838ee996e09e3ee18deb9a7737dea
-- 
2.19.0.rc0

