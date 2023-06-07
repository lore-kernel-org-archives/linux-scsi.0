Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21F0C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 11:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbjFGLiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 07:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjFGLiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 07:38:51 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7A11730
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 04:38:49 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357BIesp030024
        for <linux-scsi@vger.kernel.org>; Wed, 7 Jun 2023 04:38:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=nE9zLv/HSNb4fDsWyXulh38a/z46yFnmg/muj8mYep0=;
 b=amc74j27m6Ym5BG7YckRKZS6Evt4s9H2hbdgYjT8xUmFB+l0/aP8EYgGOdHMYS+MZwb3
 tseCq7M7GDbjSXE2TDGzfsV1akWKfKyb0IPW2+6RNQurEPWEbjdvbLjeS45GEnytVsnW
 ytJW+leLhs5M+AZG5y+UTMPNEVoAMpo4S0ZYm5qrbSwhCWm//g9sK+y5umITqAaIFhJZ
 j+61nsdVX0E+F2cbVmqTqzuS3XfNVHVPK9CrZEBnKtrQUubaRCkYO6yDX2PAU2sUEJR/
 7ry0+J5Bp1U9CdiohSehcwSj9R546Ftzmh2UBPyqLGxcDIEmHGMp3zYrRRPsgBGA8PkM TQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a75afe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 04:38:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 7 Jun
 2023 04:38:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 7 Jun 2023 04:38:46 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 17BA73F7045;
        Wed,  7 Jun 2023 04:38:44 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 0/8] qla2xxx klocwork fixes
Date:   Wed, 7 Jun 2023 17:08:35 +0530
Message-ID: <20230607113843.37185-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Svv2wHXn2zfpM0OT3aZfwj_wU72rII50
X-Proofpoint-GUID: Svv2wHXn2zfpM0OT3aZfwj_wU72rII50
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver klocwork fixes to
the scsi tree at your earliest convenience.

Thanks,
Nilesh

v2:
- Incorporate review comments for patch 2/8, 3/8, 7/8.

Bikash Hazarika (2):
  qla2xxx: klocwork - Fix potential null pointer dereference
  qla2xxx: klocwork - correct the index of array

Nilesh Javali (4):
  qla2xxx: klocwork - Array index may go out of bound
  qla2xxx: klocwork - avoid fcport pointer dereference
  qla2xxx: klocwork - Check valid rport returned by fc_bsg_to_rport
  qla2xxx: Update version to 10.02.08.400-k

Quinn Tran (1):
  qla2xxx: klocwork - Fix buffer overrun

Shreyas Deodhar (1):
  qla2xxx: klocwork - pointer may be dereferenced

 drivers/scsi/qla2xxx/qla_bsg.c     | 6 ++++++
 drivers/scsi/qla2xxx/qla_edif.c    | 4 ++--
 drivers/scsi/qla2xxx/qla_init.c    | 2 +-
 drivers/scsi/qla2xxx/qla_inline.h  | 5 ++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c      | 3 ++-
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 7 files changed, 19 insertions(+), 8 deletions(-)


base-commit: 44ef1604ae9492a7d9238ea79aa0cc7b4c4de860
-- 
2.23.1

