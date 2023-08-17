Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEF6C27C7A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 06:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348249AbjHQGbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 02:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348296AbjHQGbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 02:31:40 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF968B8
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 23:31:39 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37H3VIWU015951;
        Wed, 16 Aug 2023 23:31:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=iUkW2hqp6i3WU78msruejKwRkMd4GRsJ6y2zwDW3wX0=;
 b=YdKVBgEXL3vAaxvVq6Yk4ar3o8ey/PVvzoGaqsPGwQyWHDZRSGc6azhXec6jyYc2rCya
 tJpJziR7yBMgU/LUG30Zl8tjTuGi8Y5aj6CzLzxglKrs8YmzB6vuKP/HFqsZuS5FSLQu
 YoGTLONbzMNwJGdUro3hyspGX17FePxK2QCrH20R45XPnqhuMFt72YqIG6qR0vczehZh
 VCphtl+aoBqJ9LgxLwbhVdawG9PDB83NcRSqWpXDDwFaV2d02zBAlrCOWa65j2DyJ1h7
 DDoKjD83KH3jyqrt+dIIMiqJRZCPCX6qzv4kwklvfjN3dJmp34FB8ARt5+Dt+pxNCwv6 ZA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3sgptkvss4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 23:31:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 16 Aug
 2023 23:31:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 16 Aug 2023 23:31:35 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 7F1AE3F7074;
        Wed, 16 Aug 2023 23:31:33 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 0/2] qla2xxx: allow 32 bytes CDB
Date:   Thu, 17 Aug 2023 12:01:30 +0530
Message-ID: <20230817063132.21900-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: u9-AHB9ZalP-wu3rD7LLxqmqfzKL5bHS
X-Proofpoint-GUID: u9-AHB9ZalP-wu3rD7LLxqmqfzKL5bHS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-15_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fix, allowing 32 bytes
CDB, to the scsi tree at your earliest convenience.

v2:
- remove extra lines and fix comments format
- Add Reviewed-by tag

Thanks,
Nilesh

Quinn Tran (2):
  qla2xxx: Move resource to allow code reuse
  qla2xxx: allow 32 bytes CDB

 drivers/scsi/qla2xxx/qla_def.h  |  11 +-
 drivers/scsi/qla2xxx/qla_init.c |  14 ++
 drivers/scsi/qla2xxx/qla_iocb.c | 289 ++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_nx.h   |   4 +-
 drivers/scsi/qla2xxx/qla_os.c   |  36 ++--
 5 files changed, 319 insertions(+), 35 deletions(-)


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

