Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B50FC04A6A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 07:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbjHDHUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjHDHUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 03:20:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A12137
        for <linux-scsi@vger.kernel.org>; Fri,  4 Aug 2023 00:20:21 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 373NXOdm027576;
        Fri, 4 Aug 2023 00:20:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=e5Y6DDaK9zXycvp9dsxprlVjDp1qlrfotmujDM+DCjo=;
 b=D5W3Nkq4bhZ4+X0c27GkeR79+wupUkexVYEV66U5OQB3ic9aQwl8cAlOJMSme1iUYchi
 7Lx+jniHrXsr3U5SXI8RAdY6MwhJVNqItUZy6t2kjKk3inlB+JU+Wic6R1k5eXG8n4HL
 aIgIJ041rm1NYBOCb7aYMjANkjN/QtR4KlPUq4asLy7Ef14MljF3RUw+A7NiLtsQptK9
 d40q6wM4UfD0NfbP1WrUIgmCtD0GNZH5tIrhAOufmU9exKMf7WXfIYGDcV2SB1V8aZx6
 8UzFlK0yWvT+c6/fx1sM1SvwysjD5PjjgZaWZYpvsDebhfdqX3xQp3SQF06iYS5vMHqu ZQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s8p0xgyj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Aug 2023 00:20:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 4 Aug
 2023 00:20:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 4 Aug 2023 00:19:40 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 3C2443F7088;
        Fri,  4 Aug 2023 00:19:45 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <loberman@redhat.com>
Subject: [PATCH 0/2] qla2xxx: allow 32 bytes CDB
Date:   Fri, 4 Aug 2023 12:49:42 +0530
Message-ID: <20230804071944.27214-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Jw1P6HHpDKtRZs4qoAkLvHjNUQAws1SS
X-Proofpoint-ORIG-GUID: Jw1P6HHpDKtRZs4qoAkLvHjNUQAws1SS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_05,2023-08-03_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fix, allowing 32 bytes
CDB, to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Quinn Tran (2):
  qla2xxx: Move resource to allow code reuse
  qla2xxx: allow 32 bytes CDB

 drivers/scsi/qla2xxx/qla_def.h  |  11 +-
 drivers/scsi/qla2xxx/qla_init.c |  14 ++
 drivers/scsi/qla2xxx/qla_iocb.c | 290 ++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_nx.h   |   4 +-
 drivers/scsi/qla2xxx/qla_os.c   |  36 ++--
 5 files changed, 320 insertions(+), 35 deletions(-)


base-commit: 7e9609d2daea0ebe4add444b26b76479ecfda504
prerequisite-patch-id: d86bbaeff15b7b91410a36c1ed6c02cd0ec8eb7a
prerequisite-patch-id: bcdca8c3a808ea82616360dc16901496f968947d
prerequisite-patch-id: 09073f96e2b72cf77ec053715a352f599e1033eb
prerequisite-patch-id: 23489cb800d80529a52c4b932d5b5337f38011c5
prerequisite-patch-id: 60be5386d266940029805f97d9b50d80508bccba
prerequisite-patch-id: f7c7b4c54d59eb3a6be3d4fb2ebd389e3691cf87
prerequisite-patch-id: e3367d9b6ddf17690e6d93422560e883194d7672
prerequisite-patch-id: 37c20b4cbd91a5ee59b5dbdcf86b7868e781339a
prerequisite-patch-id: 85425d60b3756a782fcfe34e8821b7de72e6456b
prerequisite-patch-id: 221684fee877c7c533b11db3bd6e6b1e54a42ccb
-- 
2.23.1

