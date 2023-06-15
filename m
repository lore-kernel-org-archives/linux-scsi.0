Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CE3EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 07:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbjFOHqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 03:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245112AbjFOHqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 03:46:44 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E991FC2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 00:46:39 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35ELTIcd009903
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 00:46:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=3MW825//g362GcyeEO7wp3YUfHX4VKcih5yX0UoxJoU=;
 b=idnyDpQH/G4o7Qmt4aEpogGENVEgOwzVwUvrIQsewCE7XtBUqSje+XgdtK0NHgSOe7qZ
 wV82tCIu/fQyoZyA05HgvOjjCJvw8H4R63q7qNwNKKVj6nj1RcEKzBwFUcfiWGCo1WNe
 Cp9Dm5jQyI2538mL6b8OMAMJ4Tve+KVEODWKzZzOXoqGVniysRACWrHOkoUD1SS6qvmB
 iptD6RvhsE4AQWfAziMeHsZkCQ4dp1cikM6iN/CcRjeMOEWTnil1sRuIjy6Jm41yhBpD
 Bk9hFlA0ibdafDSnlYk4HYTKKxYxob43F50BBdYUVgy+gGfkLWkOLraXBphpYXkCCd/U uw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r7ky1sy8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 00:46:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 15 Jun
 2023 00:46:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 15 Jun 2023 00:46:36 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id B02193F703F;
        Thu, 15 Jun 2023 00:46:34 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH] qla2xxx: Remove unused nvme_ls_waitq wait queue.
Date:   Thu, 15 Jun 2023 13:16:33 +0530
Message-ID: <20230615074633.12721-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: cwvn--DBzh57As6_eSrHmGirHXZIXH3p
X-Proofpoint-ORIG-GUID: cwvn--DBzh57As6_eSrHmGirHXZIXH3p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_04,2023-06-14_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

System crash when qla2x00_start_sp(sp) returns error code EGAIN
and wake_up gets called for uninitialized wait queue
sp->nvme_ls_waitq.

    qla2xxx [0000:37:00.1]-2121:5: Returning existing qpair of ffff8ae2c0513400 for idx=0
    qla2xxx [0000:37:00.1]-700e:5: qla2x00_start_sp failed = 11
    BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
    PGD 0 P4D 0
    Oops: 0000 [#1] SMP NOPTI
    Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 09/03/2021
    Workqueue: nvme-wq nvme_fc_connect_ctrl_work [nvme_fc]
    RIP: 0010:__wake_up_common+0x4c/0x190
    RSP: 0018:ffff95f3e0cb7cd0 EFLAGS: 00010086
    RAX: 0000000000000000 RBX: ffff8b08d3b26328 RCX: 0000000000000000
    RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff8b08d3b26320
    RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffe8
    R10: 0000000000000000 R11: ffff95f3e0cb7a60 R12: ffff95f3e0cb7d20
    R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
    FS:  0000000000000000(0000) GS:ffff8b2fdf6c0000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000000 CR3: 0000002f1e410002 CR4: 00000000007706e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    PKRU: 55555554
    Call Trace:
     __wake_up_common_lock+0x7c/0xc0
     qla_nvme_ls_req+0x355/0x4c0 [qla2xxx]
     ? __nvme_fc_send_ls_req+0x260/0x380 [nvme_fc]
     ? nvme_fc_send_ls_req.constprop.42+0x1a/0x45 [nvme_fc]
     ? nvme_fc_connect_ctrl_work.cold.63+0x1e3/0xa7d [nvme_fc]

Remove unused nvme_ls_waitq wait queue. nvme_ls_waitq logic was
removed previously in below patches,

scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands
scsi: qla2xxx: Simpify unregistration of FC-NVMe local/remote ports

Fixes: 219d27d7147e ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Fixes: 5621b0dd7453 ("scsi: qla2xxx: Simpify unregistration of FC-NVMe local/remote ports")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 1 -
 drivers/scsi/qla2xxx/qla_nvme.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c262cfcdbac8..95a12b4e0484 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -703,7 +703,6 @@ typedef struct srb {
 	struct iocb_resource iores;
 	struct kref cmd_kref;	/* need to migrate ref_count over to this */
 	void *priv;
-	wait_queue_head_t nvme_ls_waitq;
 	struct fc_port *fcport;
 	struct scsi_qla_host *vha;
 	unsigned int start_timer:1;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 648e8f798606..86e85f2f4782 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -360,7 +360,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
 		    "qla2x00_start_sp failed = %d\n", rval);
-		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
 		qla2x00_rel_sp(sp);
@@ -652,7 +651,6 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	if (!sp)
 		return -EBUSY;
 
-	init_waitqueue_head(&sp->nvme_ls_waitq);
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
 	sp->priv = priv;
@@ -671,7 +669,6 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x212d,
 		    "qla2x00_start_nvme_mq failed = %d\n", rval);
-		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
 		qla2xxx_rel_qpair_sp(sp->qpair, sp);

base-commit: aca416ac0b1fbe89d563f88cdb9884f986863d34
-- 
2.23.1

