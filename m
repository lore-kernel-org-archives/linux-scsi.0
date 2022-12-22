Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7682EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 04:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiLVEjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiLVEjo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 23:39:44 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753DD193DF
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:42 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM1SDgD018335
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TEhfNeFDHjexOeRjg8N4KJOeVryUqTKsM6s8kZH2sQ8=;
 b=j3DrGKJS6Pa68czwAIIz1qQRdiKRiNkYFVho/hrPoGnTjyrb8nGgAew27Q8hutOSxd7f
 yJEodIQQUVh/wYcBwOx0+TRzNECJ/saUcYtFFdxHmSEmdkZFjgyejHYBrNIXbPApfspz
 HgkEdM4Gb4X65v5zAeGpuC7CVDMvuHhUM9+X2CfZ7hkX0kSzk2aSDtjcSbhsKF8fHEzP
 XbGt6JFcerutBMB0EhVgSkl0hmJJ4C5AiGMlDJTFsr5tH4p4UiRH8XlZfBjR1gnLgRwG
 SKfcCYXmOogSxzrfUjfJxmine2AT7V1+XQu6iL0kN3tDqYdDeo2uOT6NWGG+N87+rhNe 4A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mm79c2j8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 21 Dec
 2022 20:39:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 21 Dec 2022 20:39:40 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 32B393F7066;
        Wed, 21 Dec 2022 20:39:40 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 00/10] qla2xxx driver enhancements
Date:   Wed, 21 Dec 2022 20:39:23 -0800
Message-ID: <20221222043933.2825-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TV150BU-xuW-BCCrE_E4XgTglL_O5Haj
X-Proofpoint-GUID: TV150BU-xuW-BCCrE_E4XgTglL_O5Haj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_01,2022-12-21_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver enhancements to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.08.200-k

Quinn Tran (8):
  qla2xxx: Remove dead code
  qla2xxx: Remove dead code (GPNID)
  qla2xxx: Remove dead code (GNN ID)
  qla2xxx: relocate/rename vp map
  qla2xxx: edif - Fix performance dip due to lock contention
  qla2xxx: edif - Fix stall session after app start
  qla2xxx: edif - Reduce memory usage during low IO
  qla2xxx: edif - fix clang warning

Shreyas Deodhar (1):
  qla2xxx: Select qpair depending on which CPU post_cmd() gets called

 drivers/scsi/qla2xxx/qla_attr.c     |   5 +-
 drivers/scsi/qla2xxx/qla_def.h      |  45 ++-
 drivers/scsi/qla2xxx/qla_edif.c     |  89 ++++--
 drivers/scsi/qla2xxx/qla_edif.h     |   2 +
 drivers/scsi/qla2xxx/qla_edif_bsg.h |  15 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |  18 +-
 drivers/scsi/qla2xxx/qla_gs.c       | 407 ----------------------------
 drivers/scsi/qla2xxx/qla_init.c     |  75 ++---
 drivers/scsi/qla2xxx/qla_inline.h   |  55 ++++
 drivers/scsi/qla2xxx/qla_iocb.c     |  12 +-
 drivers/scsi/qla2xxx/qla_isr.c      |   3 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |   8 +-
 drivers/scsi/qla2xxx/qla_mid.c      | 302 ++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_nvme.c     |   4 +
 drivers/scsi/qla2xxx/qla_os.c       |  52 ++--
 drivers/scsi/qla2xxx/qla_target.c   | 103 +------
 drivers/scsi/qla2xxx/qla_target.h   |   1 -
 drivers/scsi/qla2xxx/qla_version.h  |   4 +-
 18 files changed, 529 insertions(+), 671 deletions(-)


base-commit: 1a5665fc8d7a000671ebd3fe69c6f9acf1e0dcd9
prerequisite-patch-id: be976009b5ea7851eb74cc9d2319ac6382f488d8
prerequisite-patch-id: 752681cb1db6b24e510674ec0d74df41eeca8cf8
prerequisite-patch-id: 0b446a33d76b16b1a439885ff70f49c1ece3ea5f
prerequisite-patch-id: 61d396fc35fa2735fd25b9cd0a272ec0541c3711
prerequisite-patch-id: eedf715f4751c46c16551b3a2148613c52021415
prerequisite-patch-id: 69cf2bdc6e811b5e2c34c525e738e4091746ec98
prerequisite-patch-id: 921e1903d89e66264af2378b608cdd1b2b62f61d
prerequisite-patch-id: b5fd5b67208c4a553cf4de664e671e07d899435d
prerequisite-patch-id: 96bbbf7f836bed5400912a1dcfb97716649e94f7
prerequisite-patch-id: 4c9a15be983c52b527cd83a242dd90f66b80655c
prerequisite-patch-id: 5c8db5ab15495994d808f149a1ce7a8bb126e697
-- 
2.19.0.rc0

