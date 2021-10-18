Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D560C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 14:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 814A86058D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 14:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhJROCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:02:49 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48816 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234588AbhJROAj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 10:00:39 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3591241253;
        Mon, 18 Oct 2021 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1634565502; x=
        1636379903; bh=aA6Ft8tDrOPQEeGGun4ebXEd66+dGl6I0OCBvKRX0RA=; b=O
        Wkb7JR9tqvZT4TXfRW+gGc9q+uFLZrvpxgXinIXXQS3Xec6FTZfj8cKawVez84Zv
        6wwBntY0D6alj7EYNvuw0HtnGY1A4n5vpsMgmV4mgCYxzVDkfi7NmbzeWai5lsSm
        e76z9DlZAkqdGU4VyKY+mVLxKxpOcjfukAEfgLNkMg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HxTxLK8gE6gy; Mon, 18 Oct 2021 16:58:22 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 843864120B;
        Mon, 18 Oct 2021 16:58:22 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.178.112.183) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Oct 2021 16:58:21 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v4] target: core: remove from tmr_list at lun unlink
Date:   Mon, 18 Oct 2021 16:57:53 +0300
Message-ID: <20211018135753.15297-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.112.183]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently TMF commands are removed from de_device.dev_tmf_list at
the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
up on a command status (response) is queued in transport layer.
It means that LUN and backend device can be deleted meantime and at
the moment of repsonse completion a panic is occured:

target_tmr_work()
	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
- // - // - // -
<<<--- lun remove
<<<--- core backend device remove
- // - // - // -
qlt_handle_abts_completion()
  tfo->free_mcmd()
    transport_generic_free_cmd()
      target_put_sess_cmd()
        core_tmr_release_req() {
          if (dev) { // backend device, can not be null
            spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH

Call Trace:
NIP [c000000000e1683c] _raw_spin_lock_irqsave+0x2c/0xc0
LR [c00800000e433338] core_tmr_release_req+0x40/0xa0 [target_core_mod]
Call Trace:
(unreliable)
0x0
target_put_sess_cmd+0x2a0/0x370 [target_core_mod]
transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
tcm_qla2xxx_complete_mcmd+0x28/0x50 [tcm_qla2xxx]
process_one_work+0x2c4/0x5c0
worker_thread+0x88/0x690

For FC protocol it is a race condition, but for iSCSI protocol it is
easyly reproduced by manual sending iSCSI commands:
- Send some SCSI sommand
- Send Abort of that command over iSCSI
- Remove LUN on target
- Send next iSCSI command to acknowledge the Abort_Response
- target panics

There is no sense to keep the command in tmr_list until response
completion, so move the removal from tmr_list from the response
completion to the response queueing when lun is unlinked.
Move the removal from state list too as it is a subject to the same
race condition.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

---
v4:
 remove superfluous transport_lookup_tmr_lun that could race with lun
reset
v3:
 remove iscsi fix as not related to the issue
 avoid double removal from tmr_list
v2:
 fix stuck in tmr list in error case

The issue exists from the very begining.
I uploaded a scapy script that helps to reproduce the issue at
https://gist.github.com/logost/cb93df41dd2432454324449b390403c4
---
 drivers/target/target_core_tmr.c       | 17 +--------------
 drivers/target/target_core_transport.c | 30 ++++++++++++++++++++------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index e7fcbc09f9db..bac111456fa1 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -50,15 +50,6 @@ EXPORT_SYMBOL(core_tmr_alloc_req);
 
 void core_tmr_release_req(struct se_tmr_req *tmr)
 {
-	struct se_device *dev = tmr->tmr_dev;
-	unsigned long flags;
-
-	if (dev) {
-		spin_lock_irqsave(&dev->se_tmr_lock, flags);
-		list_del_init(&tmr->tmr_list);
-		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
-	}
-
 	kfree(tmr);
 }
 
@@ -156,13 +147,6 @@ void core_tmr_abort_task(
 			se_cmd->state_active = false;
 			spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 
-			/*
-			 * Ensure that this ABORT request is visible to the LU
-			 * RESET code.
-			 */
-			if (!tmr->tmr_dev)
-				WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) < 0);
-
 			if (dev->transport->tmr_notify)
 				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
 							   &aborted_list);
@@ -234,6 +218,7 @@ static void core_tmr_drain_tmr_list(
 		}
 
 		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
+		tmr_p->tmr_dev = NULL;
 	}
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 14c6f2bb1b01..e60abd230e90 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -676,6 +676,21 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
 }
 
+static void target_remove_from_tmr_list(struct se_cmd *cmd)
+{
+	struct se_device *dev = NULL;
+	unsigned long flags;
+
+	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		dev = cmd->se_tmr_req->tmr_dev;
+
+	if (dev) {
+		spin_lock_irqsave(&dev->se_tmr_lock, flags);
+		if (cmd->se_tmr_req->tmr_dev)
+			list_del_init(&cmd->se_tmr_req->tmr_list);
+		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
+	}
+}
 /*
  * This function is called by the target core after the target core has
  * finished processing a SCSI command or SCSI TMF. Both the regular command
@@ -687,13 +702,6 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
-	target_remove_from_state_list(cmd);
-
-	/*
-	 * Clear struct se_cmd->se_lun before the handoff to FE.
-	 */
-	cmd->se_lun = NULL;
-
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
@@ -728,8 +736,16 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 	if (!lun)
 		return;
 
+	target_remove_from_state_list(cmd);
+	target_remove_from_tmr_list(cmd);
+
 	if (cmpxchg(&cmd->lun_ref_active, true, false))
 		percpu_ref_put(&lun->lun_ref);
+
+	/*
+	 * Clear struct se_cmd->se_lun before the handoff to FE.
+	 */
+	cmd->se_lun = NULL;
 }
 
 static void target_complete_failure_work(struct work_struct *work)
-- 
2.25.1

