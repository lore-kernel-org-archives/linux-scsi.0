Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793042935;
	b=jvqi5dA8YOC8yJyQgkTMHYeuugU8f47ymDaDgNgB+F31WYWHlHRQEkm9EcoA63Bf3FWn
	 lL3zKHfbGraThT2QrBRUhLjExCSLwWyoyg+XTPoOoJOnbCNYrOgtOhIv6ND85Zo7bDV6j
	 XzOoqt0FSJok6klAuz7Xv+M1r8eOGSh72FDjXt1Ncr7arZCMxZ1bTdhGrG9HtMf/+GjSV
	 eWqpeHQImlrL54osxBqELIoI/8d5CzaCBLCTd5uZMQIKOS2PpUCG5zdUNF2fh8jwzX1kU
	 IM9CoUCMh6Vvn4VLmMqQkwD/xlR7o0fWxMnVlMwXpsfN9i9wxIUPJUFo7IxXeJerigA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793042935;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=/+clPk1hjSLqNCvPzIA08CV3arVH0SH3THT/TSky46I=;
	b=wLkp/pKf+8JSZqmyG7yKgL8b5fKsU2UVLWT4qYIlkRbadxOc68O/aHtSn8Laj/rNsQIl
	 T3XuubjkL0/0+xp5um1bgOSnhSujQYz8eSIG2BGthdeykMTjbWGjsltB9r2Kjw02W1X89
	 YagClRG8XdrJI7JKEV8saPAK2vLMWtiWW1cYMJIcG+l/Sq0x6isEiMABNXsh25IqJfbUR
	 nYJmJSej21KAxc9CulGq0NeGRs89kRoFPfQnLKZIEqYhfCS96hXax4Pt6JU99xi/EAKYe
	 nJQQiX7UchRKhhZ0UF4rnhuaXg9DETrE+9TM9QiAmPw2KzLu0LKnxe+wLCbK0cNpCjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gWTq+Fb2;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C300E606A323
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 19:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C300E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gWTq+Fb2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793042934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+clPk1hjSLqNCvPzIA08CV3arVH0SH3THT/TSky46I=;
	b=gWTq+Fb2B91xpHS75XaogR80ITu1mDuCptR6fPRpOo+WVKKKCc1Hm8cgbV3vo2kREn9Oan
	OutVkehDJlJhu2n4hxX5hYPgMOKTuDF791qI23fm0IuQEhN8XD4FM/Cd4x0qXunzYEV1HX
	r3QP2OSDQo+4v21qi6JvJVwnE0EVPDA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-seZ8Fz0GNyG6_SmLnbe4pw-1; Mon,
 26 Oct 2026 15:28:50 -0400
X-MC-Unique: seZ8Fz0GNyG6_SmLnbe4pw-1
X-Mimecast-MFC-AGG-ID: seZ8Fz0GNyG6_SmLnbe4pw_1793042929
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCA54195606A;
	Mon, 26 Oct 2026 19:28:48 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAE297C6;
	Mon, 26 Oct 2026 19:28:47 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/2] scsi: target: Complete an aborted command at most once
Date: Mon, 26 Oct 2026 15:28:34 -0400
Message-ID: <20261026192835.1431767-2-loberman@redhat.com>
In-Reply-To: <20261026192835.1431767-1-loberman@redhat.com>
References: <20261026192835.1431767-1-loberman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

target_cmd_interrupted() queues target_abort_work for a command that has
CMD_T_ABORTED set and returns without setting CMD_T_COMPLETE and without
changing t_state, so target core records nothing that would stop a second
completion of the same command. A second call re-initialises and re-queues
cmd->work while the first is still queued or running, and calls
transport_complete_callback() again. For COMPARE AND WRITE that callback is
compare_and_write_callback(), which releases dev->caw_sem, so a repeated
call releases that semaphore twice.

More than one site can reach that conclusion for the same command. A WRITE
still in TRANSPORT_WRITE_PENDING has never been passed to the backend, so
the fabric has to complete it when a TMR aborts it, and for iSCSI both the
DataOut paths and iscsit_release_commands_from_conn() during connection
teardown will do so.

Guard the CMD_T_ABORTED branch with a one-shot CMD_T_ABORT_QUEUED flag,
tested and set under t_state_lock. The CMD_T_ABORTED test moves under that
lock as well, which is the lock __target_check_io_state() sets
CMD_T_ABORTED under, so there is no window between the test and the set.
Second and later calls are a no-op by design and still return true, so
callers do not proceed with normal completion. A fabric that completes an
aborted command exactly once never reaches the guard and is unaffected.

The CMD_T_STOP branch is deliberately left unguarded. complete_all() is
idempotent and t_transport_stop_comp is initialised once in
__target_init_cmd(), so a repeated call there is harmless. A guard shared
between the two branches would also be wrong: a first call taking the
CMD_T_STOP branch would then suppress the queueing of target_abort_work if
CMD_T_ABORTED were set afterwards, which is the hang this series started
from.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    Prerequisite for patch 2, which relies on a second completion of an
    aborted command being a no-op.  Both need to travel together to stable.
    
    I have not put a Fixes: tag on this one -- the double completion is older
    than the iSCSI hang and I am not certain which commit to name.  If you
    would like one here, please say which.

 drivers/target/target_core_transport.c | 37 ++++++++++++++++++++------
 include/target/target_core_base.h      |  1 +
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c..4896a92 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -882,24 +882,45 @@ static void target_abort_work(struct work_struct *work)
 	target_handle_abort(cmd);
 }
 
+/*
+ * Returns true if the command has been aborted or stopped, in which case the
+ * caller must not carry on with normal completion.  For an aborted command the
+ * work that must not run twice -- the completion callback and the queueing of
+ * target_abort_work -- is done once, under CMD_T_ABORT_QUEUED.
+ */
 static bool target_cmd_interrupted(struct se_cmd *cmd)
 {
+	bool queue_abort = false, stop = false;
+	unsigned long flags;
 	int post_ret;
 
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		if (cmd->transport_complete_callback)
-			cmd->transport_complete_callback(cmd, false, &post_ret);
+		if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+			return true;
+		}
+		cmd->transport_state |= CMD_T_ABORT_QUEUED;
+		queue_abort = true;
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
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 002b0fc..7fa6733 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -537,6 +537,7 @@ struct se_cmd {
 #define CMD_T_STOP		(1 << 5)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
+#define CMD_T_ABORT_QUEUED	(1 << 12)
 	spinlock_t		t_state_lock;
 	struct kref		cmd_kref;
 	struct completion	t_transport_stop_comp;
-- 
2.43.0

