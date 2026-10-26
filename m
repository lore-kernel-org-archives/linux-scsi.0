Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027245;
	b=Oqqblt9F9FU0m5BWmqR3/1lbMJ0IAn/cqbm/Q4eiC0SMeqoVZaup5OeKOPRiEH11ZTA3
	 AamYHUsieKgNIQhji3UJ3mce9dzqQrIy5pA6Eayj+EXW4LpvcIVb4WuOZqOpPc0Pura6Y
	 Vg3XZHwWi3F4emHVusN9IkAWf/L5J04d6PBFrKEyrUpXMipS5g/IIwUrnzTbAeLHP+1sq
	 mv7zGpCivGn9zjySs/1nkCKZCTgJqglkLKXJvNffq5lT282MArfxFsWdG161s8fhHne6F
	 M2qfn1nzmt6B0XwebyLO8Sib/PHaZ7OFDgpyKgZW+5ifAa85th9Iy28pHc+y2mbpMPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027245;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=knXRq142e85M+kupUkJy646qboEKARTEaWQ97s0UgTA=;
	b=wHX9ie7c0h0Syjn+c84k8CmY+zAIi06sEDwiyxpW+TzwCa2tXUVO1LTt7siCTqhqS1ew
	 to+uLFHoTOPhXeYVyYlnDhdJMNKwA4YWqvmWZvkqBqG44JV9VhjTts3CHriZCZhpBCNtU
	 ezSdgAgqYeLVPyXKXwRUcg4LHvG7C3C16mNBLQs47+ZnLdqamWL5vOoLageNcgbx31QBg
	 ZXjF8xrqfNCE5zKoOR7jBCKcZNZULkqZV0K4jkgqwUbCdWJFLIMnCkOjJaX+c721m+Ypx
	 FyKsFgrxWkkrEGqQA88LZ/wcTEWiw1b5pnVT//XgoOHZefolDbmPYdDNcQ5ZdZTPvIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eromITRV;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4B606A33A
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:07:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7F4B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eromITRV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793027243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=knXRq142e85M+kupUkJy646qboEKARTEaWQ97s0UgTA=;
	b=eromITRVVJEEaTXHKvDy4XU5ZR3sx6laDgMqrf028/Qkh5YKA9Koh3c/6iX38dV44xqFRo
	H4ecNNiwpK107NPM98EaShiRwjm0KAdlLqw0xeDe/AvAll5riraZgESvo3p1h3OhuqDJi2
	dnhFTAPf+77hG4oKBZVxIp8hqy67Bgk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-226-xkKoX4nDOE6tI3u5x_u0EQ-1; Mon,
 26 Oct 2026 11:07:19 -0400
X-MC-Unique: xkKoX4nDOE6tI3u5x_u0EQ-1
X-Mimecast-MFC-AGG-ID: xkKoX4nDOE6tI3u5x_u0EQ_1793027237
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C085F1953966;
	Mon, 26 Oct 2026 15:07:17 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8310D30000E3;
	Mon, 26 Oct 2026 15:07:16 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4 1/3] scsi: target: iscsi: Complete an aborted WRITE stuck before the first R2T
Date: Mon, 26 Oct 2026 11:07:08 -0400
Message-ID: <20261026150710.1063511-2-loberman@redhat.com>
In-Reply-To: <20261026150710.1063511-1-loberman@redhat.com>
References: <20261026150710.1063511-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

Commit aaa00cc93c1d ("scsi: target/core: Fix TAS handling for
aborted commands") is what left it that way. Before it, this site
called transport_check_aborted_status(), which sent the delayed
TASK_ABORTED status for the command; that commit replaced the call
with a bare CMD_T_ABORTED test and a return, on the basis that the
target core would send TASK_ABORTED from the ABORT TMF context
instead. That holds only for commands the core can finish on its
own. A WRITE still in TRANSPORT_WRITE_PENDING has never been passed
to the backend, so the core's abort path is itself waiting in
target_put_cmd_and_wait() for the fabric to complete it, and since
that commit the fabric no longer does.

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

Fixes: aaa00cc93c1d ("scsi: target/core: Fix TAS handling for aborted commands")
Cc: stable@vger.kernel.org
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c      | 12 +++++--
 drivers/target/iscsi/iscsi_target_erl1.c | 10 +++++-
 drivers/target/iscsi/iscsi_target_util.c | 46 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h |  2 ++
 include/target/iscsi/iscsi_target_core.h |  6 ++++
 5 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff26..aab9237 100644
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
index d8ca06e..cf72c79 100644
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
index c1888c4..31248cb 100644
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
index 7ae48a8..8f3fe74 100644
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
index 51ca80a..5eb3cf2 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -496,6 +496,12 @@ struct iscsit_cmd {
 	u32			first_data_sg_off;
 	u32			kmapped_nents;
 	sense_reason_t		sense_reason;
+	/*
+	 * Set once one site has claimed the completion of this command.
+	 * The claim is taken before target_complete_cmd() is called.
+	 * Protected by se_cmd.t_state_lock.
+	 */
+	bool			completion_claimed;
 }  ____cacheline_aligned;
 
 struct iscsi_tmr_req {
-- 
2.43.0

