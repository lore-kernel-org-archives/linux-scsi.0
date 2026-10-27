Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104135;
	b=icCvEgFyVdHHlcv3GhiJFK+d7NRQy++jIgHAJJI3rb0mEZtE6YILo2NOZN0cAHJZM91x
	 SLFemPAeNDFlrMRS98CfRtI2mLOHiMenHROv8Fib2C5c0vQXpJH4+q24MNi0WzHkTvRVO
	 /TPPMezv4MV8IX9uF+44KIPy9vnB0q5wzHcCDgnhZVc6Vi7NXd1E8Zs/Zd7SU3tu21GDr
	 lZ8LEUeocc4xpfSA1g/yCCx6CMOvaYESKf7yO58Y5Sw7SanoTHJ9klGQ0oPdpo9PzsoAP
	 kQ4qRuLO9sGSdIs0MnhuON/FPGM0pLoG/U4NDOKNOO3W1clIZD6lCkBe5GqqaI7uxbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104135;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=9bf+WSrJj08T2EnJTuDUiU9BXqBOTuz/X6gAw7vyxoI=;
	b=g3NBT0uk9AQTKjdJR1YBd8clRWrgfI5mLdjIzrWK2G9+idBYYQzpv0kt8lW0e3w0hbSp
	 5h6ZpXqtu+eBoE2HtAlxvgMgbY2CuMsU1WJIkV5hMpf1uz5pn62JzFTjNCYye/q7f2EhJ
	 pZfDwq7VcnNLfj13U7sHoWakhAjT4DamYJfOE52hVInjVBJ2DgAInEZS40/CZ6YC0XzNe
	 MPZRzOC7ZQyFLOsqqH1TjWcEgL/gauU708V46bFb4/Hgoza0gzyYwq3aowrEkU5UvJGfv
	 g/ZVNp/HeyGcyPxCSe4VxNUZmDv+fvzGEfeGC51twfECQOHayV93umouCfj6mGeIDEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E8Od8vIb;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64824606A335
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 12:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64824606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E8Od8vIb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793104133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9bf+WSrJj08T2EnJTuDUiU9BXqBOTuz/X6gAw7vyxoI=;
	b=E8Od8vIbalCaunp9stSOkiwSr9LJz7LgAIecN4YY7tx0tQBE1CQNlSfbUmJx1M3upge+m0
	n1+/a3Zq13nhTSzP6UtxH1GlEeD2wEni9S7VYDMY2fl7Jgc4i9Rlq9dLiCcnF0SkOm7XUm
	tsL5uo8oacY0Bje/CRJPbvzAIY3m5do=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-xiYosnpXMSGuzjm38u4FUg-1; Tue,
 27 Oct 2026 08:28:50 -0400
X-MC-Unique: xiYosnpXMSGuzjm38u4FUg-1
X-Mimecast-MFC-AGG-ID: xiYosnpXMSGuzjm38u4FUg_1793104128
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFA911954225;
	Tue, 27 Oct 2026 12:28:48 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9889830002C9;
	Tue, 27 Oct 2026 12:28:47 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 3/4] scsi: target: Queue the abort of a command at most once
Date: Tue, 27 Oct 2026 08:28:36 -0400
Message-ID: <20261027122837.2148074-4-loberman@redhat.com>
In-Reply-To: <20261027122837.2148074-1-loberman@redhat.com>
References: <20261027122837.2148074-1-loberman@redhat.com>
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

target_cmd_interrupted() and transport_generic_request_failure() both
queue target_abort_work for a command that has CMD_T_ABORTED set, and
neither records that it has done so: CMD_T_COMPLETE is not set and t_state
is not changed, so nothing stops a second site reaching the same
conclusion for the same command. The second call re-initialises and
re-queues cmd->work while the first is still queued or running.

More than one site can reach that conclusion. A WRITE still in
TRANSPORT_WRITE_PENDING has never been passed to the backend, so the
fabric has to complete it when a TMR aborts it, and for iSCSI both the
DataOut paths and iscsit_release_commands_from_conn() during connection
teardown will do so. The two queueing sites can also reach each other: if
CMD_T_ABORTED is set after target_cmd_interrupted() has returned false in
target_execute_cmd() and execution then fails,
transport_generic_request_failure() queues the work, and a later
target_execute_cmd() -- from iscsit_task_reassign_complete_write(), for
example -- queues it a second time.

Add a CMD_T_ABORT_QUEUED flag, tested and set under t_state_lock by
__target_claim_abort(), and use it at both sites. In
target_cmd_interrupted() the CMD_T_ABORTED test moves under the same lock,
which is the lock __target_check_io_state() sets CMD_T_ABORTED under, so
there is no window between the test and the claim. Second and later calls
are a no-op by design and target_cmd_interrupted() still returns true, so
callers do not proceed with normal completion. A fabric that completes an
aborted command exactly once never reaches the claim and is unaffected.

target_cmd_interrupted() runs for every completion, so it keeps a lockless
test of the two flags and only takes t_state_lock when one of them is set.
A flag set immediately after that test is handled exactly as it was when
the whole function was lockless.

The CMD_T_STOP branch is deliberately left unguarded. complete_all() is
idempotent and t_transport_stop_comp is initialised once in
__target_init_cmd(), so a repeated call there is harmless. A guard shared
between the two branches would also be wrong: a first call taking the
CMD_T_STOP branch would then suppress the queueing of target_abort_work if
CMD_T_ABORTED were set afterwards, which is the hang the next patch is
about.

transport_complete_callback() can still run more than once for a command,
across the two branches here and from
transport_generic_request_failure(). The only callback in the tree is
COMPARE AND WRITE's, whose side effect -- releasing dev->caw_sem -- is
made one-shot by the previous patch, so a repeated call now has nothing
left to repeat.

Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    Prerequisite for patch 3, which relies on a second completion of an
    aborted command being a no-op.  All three patches need to travel together
    to stable.
    
    No Fixes: tag: 2c9fa49e100f added the same abort-queueing pattern to both
    functions, so it is arguably the right one, but the double queueing is
    not what that commit set out to do.  Happy to add it if you would like.

 drivers/target/target_core_transport.c | 77 ++++++++++++++++++++++----
 include/target/target_core_base.h      |  1 +
 2 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c..9ef8e93 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -882,24 +882,72 @@ static void target_abort_work(struct work_struct *work)
 	target_handle_abort(cmd);
 }
 
+/*
+ * Claim the queueing of target_abort_work for an aborted command.  Returns
+ * true for the one caller that must queue it; every later caller gets false.
+ *
+ * Caller must hold cmd->t_state_lock, which is the lock
+ * __target_check_io_state() sets CMD_T_ABORTED under, so that the flag cannot
+ * be set between a caller's CMD_T_ABORTED test and this claim.
+ */
+static bool __target_claim_abort(struct se_cmd *cmd)
+	__must_hold(&cmd->t_state_lock)
+{
+	lockdep_assert_held(&cmd->t_state_lock);
+
+	if (cmd->transport_state & CMD_T_ABORT_QUEUED)
+		return false;
+
+	cmd->transport_state |= CMD_T_ABORT_QUEUED;
+	return true;
+}
+
+/*
+ * Returns true if the command has been aborted or stopped, in which case the
+ * caller must not carry on with normal completion.  target_abort_work is
+ * queued at most once per command; a later call for an already-claimed abort
+ * is a no-op and still returns true.
+ */
 static bool target_cmd_interrupted(struct se_cmd *cmd)
 {
+	bool queue_abort = false, stop = false;
+	unsigned long flags;
 	int post_ret;
 
+	/*
+	 * This runs for every completion, so stay out of t_state_lock unless
+	 * one of the two flags is set.  A flag set just after this test is
+	 * handled the same way it was before the lock was introduced here.
+	 */
+	if (!(cmd->transport_state & (CMD_T_ABORTED | CMD_T_STOP)))
+		return false;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		if (cmd->transport_complete_callback)
-			cmd->transport_complete_callback(cmd, false, &post_ret);
+		queue_abort = __target_claim_abort(cmd);
+		if (!queue_abort) {
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+			return true;
+		}
+	} else if (cmd->transport_state & CMD_T_STOP) {
+		stop = true;
+	}
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
+	if (!queue_abort && !stop)
+		return false;
+
+	if (cmd->transport_complete_callback)
+		cmd->transport_complete_callback(cmd, false, &post_ret);
+
+	if (queue_abort) {
 		INIT_WORK(&cmd->work, target_abort_work);
 		queue_work(target_completion_wq, &cmd->work);
-		return true;
-	} else if (cmd->transport_state & CMD_T_STOP) {
-		if (cmd->transport_complete_callback)
-			cmd->transport_complete_callback(cmd, false, &post_ret);
+	} else {
 		complete_all(&cmd->t_transport_stop_comp);
-		return true;
 	}
 
-	return false;
+	return true;
 }
 
 static void target_complete(struct se_cmd *cmd, int success)
@@ -2084,6 +2132,7 @@ EXPORT_SYMBOL(target_submit_tmr);
 void transport_generic_request_failure(struct se_cmd *cmd,
 		sense_reason_t sense_reason)
 {
+	unsigned long flags;
 	int ret = 0, post_ret;
 
 	pr_debug("-----[ Storage Engine Exception; sense_reason %d\n",
@@ -2099,8 +2148,16 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+		bool queue_abort;
+
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
+		queue_abort = __target_claim_abort(cmd);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
+		if (queue_abort) {
+			INIT_WORK(&cmd->work, target_abort_work);
+			queue_work(target_completion_wq, &cmd->work);
+		}
 		return;
 	}
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bd846ab..0341844 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -538,6 +538,7 @@ struct se_cmd {
 #define CMD_T_STOP		(1 << 5)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
+#define CMD_T_ABORT_QUEUED	(1 << 12)
 	spinlock_t		t_state_lock;
 	struct kref		cmd_kref;
 	struct completion	t_transport_stop_comp;
-- 
2.43.0

