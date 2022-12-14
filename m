Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CE6C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiLNEua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiLNEu0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346B3CD0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:26 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gC9C020064
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=HUZ/Wf0t8J3tIlYKG4Vrw9mf0GfUf8TtnQI5qeugAww=;
 b=P3QSos6jtH18i21hikXYKvkeK2fPj1dibyoAit2UR+pwQINeBJB9OCM29tXywGWzEWPS
 7GKq+0TQ1/0qwDivFNT4/XcXUSDT+qjxnMvsZ/cABfhrSpcvdz08s1wsocuCr0Yh10vc
 PSN7M1D8gTJNQQUHVRFfOu7mmYWDyyEleI6B0Vf77Qv2Gk3oBf93pNkhQAaH8f5AcQ6x
 nXO08kMsHWvyr1I1uZG963uYN1D45s4muOYkdIFNMLRnlLUzJjSdlcJlRxHZ7yZ2q7K5
 Js2tcTAgVG0V0l0eZAM0LSLJ8zOxXc4H9j4PjX+sYCJaoxmXsfvI7kkoHwZbxsa7j3YI KQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CF3803F707A;
        Tue, 13 Dec 2022 20:50:23 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 00/10] Misc. qla2xxx driver bug fixes
Date:   Tue, 13 Dec 2022 20:50:04 -0800
Message-ID: <20221214045014.19362-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 14mpg_Rp1RJcDy6iEogV27K6EHOaPuDm
X-Proofpoint-GUID: 14mpg_Rp1RJcDy6iEogV27K6EHOaPuDm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the miscellaneous qla2xxx driver bug fixes to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Arun Easi (1):
  qla2xxx: Fix DMA-API call trace on NVME LS requests

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.08.100-k

Quinn Tran (6):
  qla2xxx: Fix link failure in NPIV environment
  qla2xxx: Fix exchange over subscription
  qla2xxx: Fix exchange over subscription for mgt cmd
  qla2xxx: Fix stalled login
  qla2xxx: Remove unintended flag clearing
  qla2xxx: Fix erroneous link down

Saurav Kashyap (1):
  qla2xxx: Remove increment of interface err cnt

Shreyas Deodhar (1):
  qla2xxx: Check if port is online before sending ELS

 drivers/scsi/qla2xxx/qla_bsg.c     |  9 +--
 drivers/scsi/qla2xxx/qla_def.h     |  6 +-
 drivers/scsi/qla2xxx/qla_dfs.c     | 10 +++-
 drivers/scsi/qla2xxx/qla_edif.c    |  7 ++-
 drivers/scsi/qla2xxx/qla_init.c    | 20 ++++++-
 drivers/scsi/qla2xxx/qla_inline.h  | 55 +++++++++++------
 drivers/scsi/qla2xxx/qla_iocb.c    | 95 ++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c     |  6 +-
 drivers/scsi/qla2xxx/qla_nvme.c    | 34 +++++------
 drivers/scsi/qla2xxx/qla_os.c      |  9 ++-
 drivers/scsi/qla2xxx/qla_version.h |  6 +-
 11 files changed, 188 insertions(+), 69 deletions(-)


base-commit: ae8011fe076da06f471258269b8ea28ed7df185b
prerequisite-patch-id: 90b76bde4a6af72694fc58a6b4cddae8e2415cea
-- 
2.19.0.rc0

