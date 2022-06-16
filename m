Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28894C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358671AbiFPFf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358602AbiFPFfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA2B5A08B
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:15 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9uIJ014684
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ejg6OU7omzFafpffGf21xfVoXYtghjmtg/wlhUsdrlU=;
 b=D3vYjYYcUrm0JcIXiYtf59OxGS2mVvA9A4IhzWmZrh0bZZlYO3YK/y55atkSLeHmj4gD
 BRDtNgZ07M5MghFnJQUqo36DdbYNlEqNLqJm87uYXTnBoXd0vmh36AAO5jLj7pD8li1y
 tN8mC1SPtGY1+aC7uuo0HzXqyZAtAoNClfBD1tPIhvbRF7pJRY3FYuf3fXnITZy+Jn6t
 L+HD1PljyDi2QyhTPd0vS2PGMMFLPJQwWDUCze7nALrdVVoMAuB6e+gYupWOdFBoZ5lX
 kkJ8FnGMJG753n6oJ7FQxv+ftyDjCKuTjCFHDYkxz4caNH4CjjtWa9CYRUgUjTwDgg82 vA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977u-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Jun
 2022 22:35:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:13 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 12C313F70AF;
        Wed, 15 Jun 2022 22:35:13 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 10/11] qla2xxx: Fix erroneous mailbox timeout after pci error inject
Date:   Wed, 15 Jun 2022 22:35:07 -0700
Message-ID: <20220616053508.27186-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EmT-2DzaT7aTw1G_jN_sBWmQOYv7uKnO
X-Proofpoint-GUID: EmT-2DzaT7aTw1G_jN_sBWmQOYv7uKnO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Clear wait for mailbox interrupt flag to prevent stale mailbox
Feb 22 05:22:56 ltcden4-lp7 kernel: qla2xxx [0135:90:00.1]-500a:4: LOOP UP detected (16 Gbps).
Feb 22 05:22:59 ltcden4-lp7 kernel: qla2xxx [0135:90:00.1]-d04c:4: MBX Command timeout for cmd 69, ...

To fix the issue, driver need to clear the MBX_INTR_WAIT flag
on purging the mailbox. When the stale mailbox completion do arrive, it
will be dropped.

Fixes: b6faaaf796d7 ("scsi: qla2xxx: Serialize mailbox request")
Cc: Naresh Bannoth <nbannoth@in.ibm.com>
Cc: Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Cc: stable@vger.kernel.org
Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
Tested-by: Naresh Bannoth <nbannoth@in.ibm.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 16a736a7130d..643fa0052f5a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -274,6 +274,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		atomic_inc(&ha->num_pend_mbx_stage3);
 		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
 		    mcp->tov * HZ)) {
+			ql_dbg(ql_dbg_mbx, vha, 0x117a,
+			    "cmd=%x Timeout.\n", command);
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 			if (chip_reset != ha->chip_reset) {
 				eeh_delay = ha->flags.eeh_busy ? 1 : 0;
 
@@ -286,12 +292,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				rval = QLA_ABORTED;
 				goto premature_exit;
 			}
-			ql_dbg(ql_dbg_mbx, vha, 0x117a,
-			    "cmd=%x Timeout.\n", command);
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 		} else if (ha->flags.purge_mbox ||
 		    chip_reset != ha->chip_reset) {
 			eeh_delay = ha->flags.eeh_busy ? 1 : 0;
-- 
2.19.0.rc0

