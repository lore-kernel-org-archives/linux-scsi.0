Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34E1ECAAD4
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343672AbiHZK0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239595AbiHZK0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4566CCE35
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q319Bi027726
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=tu/uZzRxZuI74yVsFyhXuWA93tfXuFEUd2ATj5JolLI=;
 b=clJsIZ3QnqcXlAEM988V8R7dKaLpW4/hXmu6l/rPw3lLRBgMhWOCEkq074iQv0DK0fLy
 bvayl+M/JWU0NiWvMtusKbyFTAColF53AtWBD97yqzBiOglDcm4/VZMZ7uLQyLnhWp0O
 mT+Nw9JcslFavlgGnjmMr692s2zx86oxGha2pkFZsSYd6ax55I+p6dzLWUAu3UyUqDJy
 frSqph8KBmgheufExq76RWzP8o+qOIrJHvbeUtdqj5qxKg1uzICTakt1iCctYTylPFZc
 2/7EaU2oNtseiXQN9XIhlKbPMKhfl/pbAMQk1jh+WfZNazOxGwGUShNtG4Ksm+jmnlt6 aw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Aug
 2022 03:26:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:18 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E6C593F712F;
        Fri, 26 Aug 2022 03:26:16 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 0/7] qla2xxx driver features
Date:   Fri, 26 Aug 2022 03:25:52 -0700
Message-ID: <20220826102559.17474-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QPmPxny-agTp3vdbP3T-drE5F-7-M8gQ
X-Proofpoint-GUID: QPmPxny-agTp3vdbP3T-drE5F-7-M8gQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver features to the scsi tree
at your earliest convenience.

v2:
- Revert and incorporate fix based on review comments for,
"qla2xxx: Fix response queue handler reading stale packets"
- Incorporate review comments for adding enhancement to driver tracing
infrastucture.

Thanks,
Nilesh

Anil Gurumurthy (1):
  qla2xxx: Add NVMe parameters support in Auxiliary Image Status

Arun Easi (4):
  Revert "scsi: qla2xxx: Fix response queue handler reading stale
    packets"
  qla2xxx: Fix response queue handler reading stale packets
  qla2xxx: Add debugfs create/delete helpers
  qla2xxx: Enhance driver tracing with separate tunable and more

Nilesh Javali (2):
  qla2xxx: define static symbols
  qla2xxx: Update version to 10.02.07.900-k

 drivers/scsi/qla2xxx/qla_bsg.c     |  8 ++-
 drivers/scsi/qla2xxx/qla_bsg.h     |  3 +-
 drivers/scsi/qla2xxx/qla_dbg.c     | 50 +++++++++++-----
 drivers/scsi/qla2xxx/qla_dbg.h     | 43 ++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h     |  7 +++
 drivers/scsi/qla2xxx/qla_dfs.c     | 93 ++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_fw.h      |  3 +
 drivers/scsi/qla2xxx/qla_gbl.h     |  3 +-
 drivers/scsi/qla2xxx/qla_init.c    |  8 ++-
 drivers/scsi/qla2xxx/qla_isr.c     | 22 +++----
 drivers/scsi/qla2xxx/qla_os.c      | 47 +++++++++++----
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 12 files changed, 242 insertions(+), 49 deletions(-)


base-commit: d957e7ffb2c72410bcc1a514153a46719255a5da
-- 
2.19.0.rc0

