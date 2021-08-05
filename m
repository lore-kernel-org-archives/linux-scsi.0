Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A234C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708D561107
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbhHEKUs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:20:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240232AbhHEKUr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:20:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175AElYP017619
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:20:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=+kPH02DbDT6dNMZZj1cWsg3T/FH2+adNpfblwstJuW0=;
 b=WhPex1apCXCRxoh+O5IfiIA1x0Bp+01zvGgYm51RDb8bWYNMQt6a6jMH/KCBiPrFWjtE
 OZhENzBl7v8v/zjqHjI4n8STZnhBmV8w3+bR+8YTQtcPozGcNOllM94RNlJf+Tcr1e15
 nRWSox+JP5uW1JwJ95sb0OzcqC+ewcnEuLPdCbJcJDKKWPEdikyBjJBU28WV0gklJMyu
 EYAh/l51YSC1wkwBlTKJGj3VJTcuSJGyDIY9MNaP+FmchKDWa8qN4DylsD+j9pokRaUM
 p5I0xnutV1ePLBKWdlMtl8zF5AmeDcUbyEZgBZiFQKmgxWJCPM2GU26wjHA1VAXO6yyp XA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a8ata0hvg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:20:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:20:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:20:29 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 29D353F7064;
        Thu,  5 Aug 2021 03:20:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175AKTe3020218;
        Thu, 5 Aug 2021 03:20:29 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175AKT5J020217;
        Thu, 5 Aug 2021 03:20:29 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/14] qla2xxx driver bug fixes
Date:   Thu, 5 Aug 2021 03:19:51 -0700
Message-ID: <20210805102005.20183-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6cAIYIQM8FePOJYroSPvYbst3Poxfow2
X-Proofpoint-GUID: 6cAIYIQM8FePOJYroSPvYbst3Poxfow2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

Thanks,
Nilesh


Arun Easi (3):
  qla2xxx: Add host attribute to trigger MPI hang
  qla2xxx: Show OS name and version in FDMI-1
  qla2xxx: suppress unnecessary log messages during login

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.06.100-k

Quinn Tran (5):
  qla2xxx: adjust request/response queue size for 28xx
  qla2xxx: fix debug print of 64G link speed
  qla2xxx: fix port type info
  qla2xxx: fix unsafe removal from link list
  qla2xxx: fix npiv create erroneous error

Saurav Kashyap (5):
  qla2xxx: Change %p to %px in the log messages
  qla2xxx: Changes to support FCP2 Target
  qla2xxx: Changes to support kdump kernel
  qla2xxx: Changes to support kdump kernel for NVMe BFS
  qla2xxx: Sync queue idx with queue_pair_map idx

 drivers/scsi/qla2xxx/qla_attr.c    |  25 +++++
 drivers/scsi/qla2xxx/qla_dbg.c     |   3 +-
 drivers/scsi/qla2xxx/qla_def.h     |  11 +-
 drivers/scsi/qla2xxx/qla_edif.c    |  78 +++++++-------
 drivers/scsi/qla2xxx/qla_gs.c      |   6 +-
 drivers/scsi/qla2xxx/qla_init.c    |  63 +++++++----
 drivers/scsi/qla2xxx/qla_iocb.c    |  18 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |  51 +++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c     |  58 +++++-----
 drivers/scsi/qla2xxx/qla_nvme.c    |  61 +++++------
 drivers/scsi/qla2xxx/qla_os.c      | 111 +++++++++++--------
 drivers/scsi/qla2xxx/qla_sup.c     |   4 +-
 drivers/scsi/qla2xxx/qla_target.c  | 168 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_tmpl.c    |   8 +-
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  18 ++--
 17 files changed, 384 insertions(+), 307 deletions(-)


base-commit: 2c03a047d2fcae6d526e8630c820bc40560ec1eb
-- 
2.19.0.rc0

