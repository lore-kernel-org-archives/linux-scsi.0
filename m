Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DFB599A5A
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173245; cv=none; b=MxIq/wsCFIGkEaxeDC90DEPSUYx9KJ2/Uk+BTNdC7wO4a+gkXwFtb6EIoOmkAOfARc40RVpAFckzVRCiqFitpyvH3q5h2C5SoW/k0RGN6P66xcOU+q8I8BFU9Ydy508G1keMtrwKf3/RyoSZg+riNQwOvp9JAiXw16h+zOUm8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173245; c=relaxed/simple;
	bh=nQnboS8n/o95nfVE4CSFE3bWTqDhB3K7AMxudY9O+3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzeaKyUDg/o50syjrcfXrUOCLkgyYeaxouoQ12euHkBqj6WEAyvEr0JdxaOzxwmCYvFwN/eVmvjWUOjLZnkC0661GTVeY2wqcbvRhKFDqF2EsEV76dST9moo3TCC77g67/jQIKzyYzz4ak9GenfgU4xgqdykFIoV0qFSRd8ztW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IEAut3JH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IEAut3JH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792173242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qI5ZztBBco7eIJ7EI/eAY7Jqp+wb0BKeXXmn/t8nQQ=;
	b=IEAut3JHcfJl/LszA+35SSbbI5dl1+WNg40tJMGk6gsKqLjSN/CImyw+NqdJw4038LmbJD
	rkjywxAtYm35a4O7l7CZu8p+Izw5wTE/rRKM1MfUtgSMuVK+rvJXXQfnm8I5UI0YFWn+c6
	Wdj9TVwhQDl5PIG7mgP/kI6IX4B0sxU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-iBxNCYSnPSuofDzNbLE7WQ-1; Fri,
 16 Oct 2026 17:53:59 +0000
X-MC-Unique: iBxNCYSnPSuofDzNbLE7WQ-1
X-Mimecast-MFC-AGG-ID: iBxNCYSnPSuofDzNbLE7WQ_1792173238
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B4C9180044F;
	Fri, 16 Oct 2026 17:53:58 +0000 (UTC)
Received: from loberman-thinkpadp1gen5.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 496DE1800257;
	Fri, 16 Oct 2026 17:53:57 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH v2 1/2] scsi: target: iscsi: Complete an aborted WRITE stuck before the first R2T
Date: Fri, 16 Oct 2026 13:53:34 -0400
Message-ID: <20261016175351.126373-2-loberman@redhat.com>
In-Reply-To: <20261016175351.126373-1-loberman@redhat.com>
References: <20261016175351.126373-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

A WRITE that arrives with immediate data, and whose data length exceeds
FirstBurstLength, is left in TRANSPORT_WRITE_PENDING by
iscsit_execute_cmd() until the first R2T is built. If a LUN_RESET or
ABORT_TASK from another session sets CMD_T_ABORTED in that window,
iscsit_execute_cmd() returns without sending the R2T.

Nothing then completes the command. No R2T has been sent, so the
initiator cannot legally send more data; no DataOut timer was armed, so
the ERL=0 timeout cannot fire either. The command stays in
TRANSPORT_WRITE_PENDING with CMD_T_ABORTED set, and
core_tmr_drain_state_list() blocks in target_put_cmd_and_wait() on it for
as long as the connection stays up:

  INFO: task kworker/5:2 blocked for more than 46 seconds.
   target_put_cmd_and_wait+0x6d/0xb0 [target_core_mod]
   core_tmr_drain_state_list+0x2dc/0x380 [target_core_mod]
   core_tmr_lun_reset+0x93/0x1a0 [target_core_mod]

Complete it in iscsit_execute_cmd() instead. No DataOut path can race
with this: without an R2T the initiator cannot send further data for the
command, and the branch is only reached when no unsolicited DataOut is
expected either.

That introduces a second site which can complete a command that
iscsit_release_commands_from_conn() would also complete during connection
teardown, because t_state is still TRANSPORT_WRITE_PENDING there.
target_complete_cmd() on a command that already has CMD_T_ABORTED set
goes straight into target_cmd_interrupted(), which queues
target_abort_work and returns without setting CMD_T_COMPLETE and without
changing t_state, so nothing in target core records that a completion has
happened. A second target_complete_cmd() re-initialises and re-queues
se_cmd->work while it is still queued and drops a command reference that
was never taken. Add a one-shot claim, taken under se_cmd->t_state_lock,
so that only one of the two sites completes the command.

This was reported against an Oracle RAC cluster on two-session iSCSI LIO
targets, where one node's LUN_RESET aborts WRITEs belonging to the other
node's session. It was not reproducible in a lab, so the diagnosis came
from instrumented kernels in the reporter's environment. Across two
hosts, every stalled command had the same signature: DMA_TO_DEVICE,
TRANSPORT_WRITE_PENDING, CMD_T_ABORTED | CMD_T_TAS, outstanding_r2ts == 0,
write_data_done == first_burst_len, and an empty cmd_r2t_list. 217 of 222
LUN_RESET drains completed in under a second; the rest took 46 to 54
seconds, which is where the hung-task panics came from. One 53.7 second
stall recovered on its own and the host ran for a further 19 hours. The
stall only ever ended when the initiator gave up and dropped the
connection, which let iscsit_release_commands_from_conn() complete the
command.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c      | 12 +++++--
 drivers/target/iscsi/iscsi_target_erl1.c | 10 +++++-
 drivers/target/iscsi/iscsi_target_util.c | 46 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h |  2 ++
 include/target/iscsi/iscsi_target_core.h |  5 +++
 5 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e7..aab9237a6776 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4198,10 +4198,18 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
 			/*
 			 * We never submitted the cmd to LIO core, so we have
-			 * to tell LIO to perform the completion process.
+			 * to tell LIO to perform the completion process --
+			 * unless iscsit_execute_cmd() already did.  t_state
+			 * stays TRANSPORT_WRITE_PENDING across that
+			 * completion, so the claim is the only thing that can
+			 * tell us.
 			 */
+			bool claimed = iscsit_claim_completion_locked(cmd);
+
 			spin_unlock_irq(&se_cmd->t_state_lock);
-			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
+			if (claimed)
+				target_complete_cmd(&cmd->se_cmd,
+						    SAM_STAT_TASK_ABORTED);
 			continue;
 		}
 		spin_unlock_irq(&se_cmd->t_state_lock);
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index d8ca06e697d6..cf72c79be355 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -927,8 +927,16 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 			if (!(cmd->cmd_flags &
 					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
+				/*
+				 * No R2T has been sent for this command yet,
+				 * so returning here leaves the initiator with
+				 * nothing to send and no DataOut timer armed.
+				 * Complete it, or nothing ever will.
+				 */
+				if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
+					iscsit_complete_aborted_cmd(cmd);
 					return 0;
+				}
 
 				iscsit_set_dataout_sequence_values(cmd);
 				conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index c1888c42afdd..31248cb9e915 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -14,6 +14,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
+#include <target/target_core_backend.h>
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
 
@@ -186,6 +187,51 @@ struct iscsit_cmd *iscsit_allocate_cmd(struct iscsit_conn *conn, int state)
 }
 EXPORT_SYMBOL(iscsit_allocate_cmd);
 
+/*
+ * A WRITE command still in TRANSPORT_WRITE_PENDING has never been passed to
+ * the backend, so when a TMR aborts it the fabric has to complete it.  More
+ * than one site can reach that conclusion for the same command, and
+ * target_complete_cmd() on a command that already has CMD_T_ABORTED set
+ * neither sets CMD_T_COMPLETE nor changes t_state, so target core keeps no
+ * state that would stop a second completion.  Serialise them here: whichever
+ * site claims the completion performs it and every other site leaves the
+ * command alone.
+ *
+ * Caller must hold cmd->se_cmd.t_state_lock.
+ */
+bool iscsit_claim_completion_locked(struct iscsit_cmd *cmd)
+{
+	lockdep_assert_held(&cmd->se_cmd.t_state_lock);
+
+	if (cmd->completion_claimed)
+		return false;
+
+	cmd->completion_claimed = true;
+	return true;
+}
+
+/* Complete an aborted command at most once.  Must not hold t_state_lock. */
+void iscsit_complete_aborted_cmd(struct iscsit_cmd *cmd)
+{
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	unsigned long flags;
+	bool claimed;
+
+	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
+	claimed = iscsit_claim_completion_locked(cmd);
+	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
+
+	if (!claimed)
+		return;
+
+	/*
+	 * No-op unless a DataOut timer was armed for this command; callers
+	 * that complete before the first R2T have none.
+	 */
+	iscsit_stop_dataout_timer(cmd);
+	target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
+}
+
 struct iscsi_seq *iscsit_get_seq_holder_for_datain(
 	struct iscsit_cmd *cmd,
 	u32 seq_send_order)
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 7ae48a8a5cbf..8f3fe7428428 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -18,6 +18,8 @@ extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsit_cmd *);
 extern void iscsit_free_r2t(struct iscsi_r2t *, struct iscsit_cmd *);
 extern void iscsit_free_r2ts_from_list(struct iscsit_cmd *);
 extern struct iscsit_cmd *iscsit_allocate_cmd(struct iscsit_conn *, int);
+extern bool iscsit_claim_completion_locked(struct iscsit_cmd *cmd);
+extern void iscsit_complete_aborted_cmd(struct iscsit_cmd *cmd);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_datain(struct iscsit_cmd *, u32);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsit_cmd *);
 extern struct iscsi_r2t *iscsit_get_holder_for_r2tsn(struct iscsit_cmd *, u32);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 51ca80abacf7..0707a9520810 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -496,6 +496,11 @@ struct iscsit_cmd {
 	u32			first_data_sg_off;
 	u32			kmapped_nents;
 	sense_reason_t		sense_reason;
+	/*
+	 * Set once the fabric has called target_complete_cmd() for this
+	 * command.  Protected by se_cmd.t_state_lock.
+	 */
+	bool			completion_claimed;
 }  ____cacheline_aligned;
 
 struct iscsi_tmr_req {
-- 
2.52.0

