Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EFEEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 09:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjGLJGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjGLJFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 05:05:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D381703
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:40 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C7L0H7028091
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=OTeBWRGcF7pZd7wcGY19gxniBaK2hqXsKXhmMPRfRuw=;
 b=FDP0xKlchcMSYpINlDwBMRO76A/wB/B/s5OvS8VGK9xHOIw9MyACEkvMGlZ7Es8kTzPr
 355YFm3OyjJgOue5ZduSS4v3dtZG5lRsFOPj4ImFHCRGmERQG32n/5/3ioPg4nXlQWDE
 glxPERMydIz5LcfFVcGYZS/TpSC5QCwn4sIcaxfBL6FxrigCxIVobt84sGLXtqleGeOo
 mE5gGNT5gXxSBEDEpssvHerfR70LxaCIYp9yAeXSXjDjnJxonuXd117MZL8QW3JAkdEC
 rg5bW83++VzvwuO8yJ0Lm9f0VbonkrKVifcTXljnxVAbQt/AW+Rb8ARMHCW8CBewXfFP Lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rsb7rb0fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 12 Jul
 2023 02:05:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 12 Jul 2023 02:05:38 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 3D9E63F7069;
        Wed, 12 Jul 2023 02:05:36 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 00/10] qla2xxx driver bug fixes
Date:   Wed, 12 Jul 2023 14:35:25 +0530
Message-ID: <20230712090535.34894-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bELIcga91HGwVkfSLrklXUh2OG35G9Qu
X-Proofpoint-ORIG-GUID: bELIcga91HGwVkfSLrklXUh2OG35G9Qu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to
the scsi tree at your earliest convenience.

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
 drivers/scsi/qla2xxx/qla_gbl.h     |   2 +
 drivers/scsi/qla2xxx/qla_init.c    | 217 ++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c    |   1 +
 drivers/scsi/qla2xxx/qla_isr.c     |   7 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   3 +
 drivers/scsi/qla2xxx/qla_nvme.c    |   3 +-
 drivers/scsi/qla2xxx/qla_os.c      |  11 +-
 drivers/scsi/qla2xxx/qla_target.c  |  14 +-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 10 files changed, 169 insertions(+), 102 deletions(-)


base-commit: 6f0a92fd7db1507b203111ee53632eeeba2daca5
-- 
2.23.1

