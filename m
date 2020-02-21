Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C09C35669
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 23:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0FB7207FD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 23:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YXFllx4C";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YXFllx4C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgBUXec (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 18:34:32 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51090 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbgBUXeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 18:34:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 514248EE3D5;
        Fri, 21 Feb 2020 15:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1582328071;
        bh=QjTWCrNNRKTh3nBDLldTHJSH4oMOdX2jLr9tgHrHUXg=;
        h=Subject:From:To:Cc:Date:From;
        b=YXFllx4Cwghk/lbKVX6j0UcEeceu4hjPB6m0jnoMpqWxJL9I8RfxfkZQdFCk6fVFa
         9gK/7aWgyIYjoQRwQpIsEQ8CH4s4Q2MvlpWXCApNrbGilB6E6Bx+Y9bq6LccSy0NOp
         MkwzHDpka+Tk97Q6eTvXeifilh4z00FmQ5JN21J0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cdVUbEkUFqsL; Fri, 21 Feb 2020 15:34:31 -0800 (PST)
Received: from jarvis.ext.hansenpartnership.com (jarvis.ext.hansenpartnership.com [153.66.160.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E02F18EE180;
        Fri, 21 Feb 2020 15:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1582328071;
        bh=QjTWCrNNRKTh3nBDLldTHJSH4oMOdX2jLr9tgHrHUXg=;
        h=Subject:From:To:Cc:Date:From;
        b=YXFllx4Cwghk/lbKVX6j0UcEeceu4hjPB6m0jnoMpqWxJL9I8RfxfkZQdFCk6fVFa
         9gK/7aWgyIYjoQRwQpIsEQ8CH4s4Q2MvlpWXCApNrbGilB6E6Bx+Y9bq6LccSy0NOp
         MkwzHDpka+Tk97Q6eTvXeifilh4z00FmQ5JN21J0=
Message-ID: <1582328069.3692.13.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.6-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 21 Feb 2020 15:34:29 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four non-core fixes.  Two are reverts of target fixes which turned out
to have unwanted side effects, one is a revert of an RDMA fix with the
same problem and the final one fixes an incorrect warning about memory
allocation failures in megaraid_sas (the driver actually reduces the
allocation size until it succeeds).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (3):
      scsi: Revert "target: iscsi: Wait for all commands to finish before freeing a session"
      scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"
      scsi: Revert "target/core: Inline transport_lun_remove_cmd()"

Tomas Henzl (1):
      scsi: megaraid_sas: silence a warning

And the diffstat:

 drivers/infiniband/ulp/isert/ib_isert.c     | 12 +++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 +++--
 drivers/target/iscsi/iscsi_target.c         | 16 +++++----------
 drivers/target/target_core_transport.c      | 31 ++++++++++++++++++++++++++---
 include/scsi/iscsi_proto.h                  |  1 -
 5 files changed, 48 insertions(+), 17 deletions(-)

With full diff below.

James

---

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b273e421e910..a1a035270cab 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2575,6 +2575,17 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
+static void
+isert_wait4cmds(struct iscsi_conn *conn)
+{
+	isert_info("iscsi_conn %p\n", conn);
+
+	if (conn->sess) {
+		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
+		target_wait_for_sess_cmds(conn->sess->se_sess);
+	}
+}
+
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2622,6 +2633,7 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
+	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f3b36fd0a0eb..b2ad96564484 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -623,7 +623,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 	fusion->io_request_frames =
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				GFP_KERNEL, &fusion->io_request_frames_phys);
+				GFP_KERNEL | __GFP_NOWARN,
+				&fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
 		if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
 			instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
@@ -661,7 +662,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 		fusion->io_request_frames =
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				       GFP_KERNEL,
+				       GFP_KERNEL | __GFP_NOWARN,
 				       &fusion->io_request_frames_phys);
 
 		if (!fusion->io_request_frames) {
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b94ed4e30770..09e55ea0bf5d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1165,9 +1165,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		conn->cid);
 
-	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
-		return iscsit_add_reject_cmd(cmd,
-				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
@@ -2004,9 +2002,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			      conn->sess->se_sess, 0, DMA_NONE,
 			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
 
-	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
-		return iscsit_add_reject_cmd(cmd,
-				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -4149,6 +4145,9 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4231,11 +4230,6 @@ int iscsit_close_connection(
 	 * must wait until they have completed.
 	 */
 	iscsit_check_conn_usage_count(conn);
-	target_sess_cmd_list_set_waiting(sess->se_sess);
-	target_wait_for_sess_cmds(sess->se_sess);
-
-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
 
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ea482d4b1f00..0ae9e60fc4d5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -666,6 +666,11 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 
 	target_remove_from_state_list(cmd);
 
+	/*
+	 * Clear struct se_cmd->se_lun before the handoff to FE.
+	 */
+	cmd->se_lun = NULL;
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
@@ -693,6 +698,17 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	return cmd->se_tfo->check_stop_free(cmd);
 }
 
+static void transport_lun_remove_cmd(struct se_cmd *cmd)
+{
+	struct se_lun *lun = cmd->se_lun;
+
+	if (!lun)
+		return;
+
+	if (cmpxchg(&cmd->lun_ref_active, true, false))
+		percpu_ref_put(&lun->lun_ref);
+}
+
 static void target_complete_failure_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
@@ -783,6 +799,8 @@ static void target_handle_abort(struct se_cmd *cmd)
 
 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
 
+	transport_lun_remove_cmd(cmd);
+
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -1708,6 +1726,7 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 
+	transport_lun_remove_cmd(se_cmd);
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
@@ -1898,6 +1917,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		goto queue_full;
 
 check_stop:
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2195,6 +2215,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 		return;
 	}
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -2289,6 +2310,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (ret)
 			goto queue_full;
 
+		transport_lun_remove_cmd(cmd);
 		transport_cmd_check_stop_to_fabric(cmd);
 		return;
 	}
@@ -2314,6 +2336,7 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;
 
+			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2349,6 +2372,7 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;
 
+			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2384,6 +2408,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		break;
 	}
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2710,6 +2735,9 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		 */
 		if (cmd->state_active)
 			target_remove_from_state_list(cmd);
+
+		if (cmd->se_lun)
+			transport_lun_remove_cmd(cmd);
 	}
 	if (aborted)
 		cmd->free_compl = &compl;
@@ -2781,9 +2809,6 @@ static void target_release_cmd_kref(struct kref *kref)
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 	unsigned long flags;
 
-	if (se_cmd->lun_ref_active)
-		percpu_ref_put(&se_cmd->se_lun->lun_ref);
-
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 533f56733ba8..b71b5c4f418c 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -627,7 +627,6 @@ struct iscsi_reject {
 #define ISCSI_REASON_BOOKMARK_INVALID	9
 #define ISCSI_REASON_BOOKMARK_NO_RESOURCES	10
 #define ISCSI_REASON_NEGOTIATION_RESET	11
-#define ISCSI_REASON_WAITING_FOR_LOGOUT	12
 
 /* Max. number of Key=Value pairs in a text message */
 #define MAX_KEY_VALUE_PAIRS	8192
