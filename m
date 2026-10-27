Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104133;
	b=kNU1tdg98mjJfLLT4AbxztL1vQHGOBiqXwSuexYDxCP+J7epMiI5QRh4nvcSnntVx2hf
	 qZmF292M9LqIOkUrzS+fzCLXMt/ASptrWFafyoHJDNBT6QiS9pEL3Gg5c24xuryMQdSZe
	 XJbvG9CilA+TIDLsBN8wyvmOiielg3Ab8P+Ed9C1r4/2CwL++TnJveA068N9kIos+7pwc
	 z/n4CzIzrLrW2YaSuLqaZiaUTQJGrc22FiaejLBmdKqHpMeKGOjCwGbFS/mvdkrLr6NSz
	 W8W/BZMZEK0eOvmJjsAp9z/aLneFrskqGV2kV8QFgeitm/gPA/t7vLXmSEpr4ZR/AhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104133;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=glmgTATyjnbg4wMqdjZ4FGtTGk0lbwbGFFdsyO9Mwrw=;
	b=ll3abWCt6122jHmPM2HYQgu8ofW0QPjXXlS9kqXJuJ1/11Ut1OuFvsopO9hckea9W16h
	 NmKmxVCxNhbM8yIaq4fjgQdNKLf3OSxFhjPAr3REp43IRDvQoTlQlNCbjkUJdh5hjcF9W
	 1Qrdg6zGULFWEoyV/cOb5RqTOREseuVS2xcMz/KptgqBUzqvQ8BMOj6OQA5+HsEiEenZ7
	 mHz3y5TrntoN/XZMRyw8gGNlBH3pdIjnlsGD9e65Hpwl6JcsUUyY4C2kGwrSXk87zFF3x
	 JMXwKPmDGd6sORJtODlsltQnzurjTi3uFTSpPrGro8izbDTEIxG1oyhSnvM0h/KsXVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UCZPqpwJ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61420606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 12:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61420606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UCZPqpwJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793104131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=glmgTATyjnbg4wMqdjZ4FGtTGk0lbwbGFFdsyO9Mwrw=;
	b=UCZPqpwJ5SOeFzcZUebbdnTnUOlV/pzxK4wXhl9g5cBoW867sgvGL5/KhalI48h5Ihbpkc
	sHbrU6e4bIfiseWI63FSg6bzNa6VcDuMvTJZHBfZmSbK3zO36iza+YRhit5c1Ax8NG74sh
	5l2rzNec4dP/0IdoNpJIVgXkE5pJmgU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-Wxh1G4CwPnWaNE5Bdvpbgg-1; Tue,
 27 Oct 2026 08:28:48 -0400
X-MC-Unique: Wxh1G4CwPnWaNE5Bdvpbgg-1
X-Mimecast-MFC-AGG-ID: Wxh1G4CwPnWaNE5Bdvpbgg_1793104126
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B39101955E76;
	Tue, 27 Oct 2026 12:28:46 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C66030000E7;
	Tue, 27 Oct 2026 12:28:45 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 2/4] scsi: target: Only release caw_sem if this command took it
Date: Tue, 27 Oct 2026 08:28:35 -0400
Message-ID: <20261027122837.2148074-3-loberman@redhat.com>
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

sbc_parse_cdb() installs compare_and_write_callback() as the command's
transport_complete_callback when it parses a COMPARE AND WRITE. The
semaphore that callback releases is not taken until much later, in
sbc_compare_and_write(), which runs when the command is executed. A
command that is aborted or fails between those two points reaches the
callback without holding dev->caw_sem, and releases it anyway.

compare_and_write_callback() tries to cover that case by returning early
when cmd->t_data_sg or cmd->t_bidi_data_sg is NULL, on the assumption that
a command with no buffers cannot have taken the semaphore. That assumption
does not hold: transport_generic_new_cmd() allocates both lists, and a
command aborted while it sits in TRANSPORT_WRITE_PENDING has the buffers
and not the semaphore. up() on a semaphore that was never taken raises its
count, which later lets two COMPARE AND WRITE commands run against the
same device at once.

The same callback can also run more than once for one command --
target_cmd_interrupted() and transport_generic_request_failure() both
invoke it -- which releases the semaphore a second time.

Track whether the semaphore is held in SCF_CAW_SEM_HELD, set once
down_interruptible() has succeeded in sbc_compare_and_write(). Release it
through sbc_caw_sem_release(), which tests and clears the flag under
t_state_lock and only calls up() if the flag was set, so neither a command
that never took the semaphore nor a second invocation of the callback can
release it. The early return for missing buffers becomes a goto out, since
the release is now decided by the flag rather than inferred from the
buffers.

Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    No Fixes: tag: the callback has been installed at parse time and the
    semaphore taken at execute time since COMPARE AND WRITE was added, so I
    am not confident which commit to name.  Please say which you would like
    and I will add it.  Cc: stable is on the patch because the consequence --
    a semaphore released without being taken -- is worth backporting
    regardless of which commit is cited.
    
    Not observed in the field; found while reviewing the double completion
    that patch 2 fixes.

 drivers/target/target_core_sbc.c  | 49 +++++++++++++++++++++----------
 include/target/target_core_base.h |  1 +
 2 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 8c52e1e..5193453 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -347,10 +347,33 @@ sbc_execute_rw(struct se_cmd *cmd)
 			       cmd->data_direction);
 }
 
+/*
+ * Release dev->caw_sem, but only if this command is the one holding it.
+ * sbc_compare_and_write() takes the semaphore when the command is executed,
+ * which is long after sbc_parse_cdb() installs the completion callback, so a
+ * command that is aborted or fails before then reaches the callback without
+ * holding it.  The test and clear are done under t_state_lock so that a second
+ * invocation of the callback cannot release the semaphore twice.
+ */
+static void sbc_caw_sem_release(struct se_cmd *cmd)
+	__must_not_hold(&cmd->t_state_lock)
+{
+	struct se_device *dev = cmd->se_dev;
+	unsigned long flags;
+	bool held;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	held = cmd->se_cmd_flags & SCF_CAW_SEM_HELD;
+	cmd->se_cmd_flags &= ~SCF_CAW_SEM_HELD;
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
+	if (held)
+		up(&dev->caw_sem);
+}
+
 static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 					     int *post_ret)
 {
-	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret = TCM_NO_SENSE;
 	unsigned long flags;
 
@@ -363,11 +386,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	}
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	/*
-	 * Unlock ->caw_sem originally obtained during sbc_compare_and_write()
-	 * before the original READ I/O submission.
-	 */
-	up(&dev->caw_sem);
+	sbc_caw_sem_release(cmd);
 
 	return ret;
 }
@@ -450,11 +469,12 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 
 	if (!success) {
 		/*
-		 * Handle early failure in transport_generic_request_failure(),
-		 * which will not have taken ->caw_sem yet..
+		 * Handle early failure in transport_generic_request_failure().
+		 * Whether ->caw_sem was taken is tracked in SCF_CAW_SEM_HELD, so
+		 * this is only about there being no buffers to compare.
 		 */
 		if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
-			return TCM_NO_SENSE;
+			goto out;
 
 		/*
 		 * The command has been stopped or aborted so
@@ -556,11 +576,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	return ret;
 
 out:
-	/*
-	 * In the MISCOMPARE or failure case, unlock ->caw_sem obtained in
-	 * sbc_compare_and_write() before the original READ I/O submission.
-	 */
-	up(&dev->caw_sem);
+	sbc_caw_sem_release(cmd);
 	sg_free_table(&write_tbl);
 	return ret;
 }
@@ -581,6 +597,9 @@ sbc_compare_and_write(struct se_cmd *cmd)
 		cmd->transport_complete_callback = NULL;
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+	spin_lock_irq(&cmd->t_state_lock);
+	cmd->se_cmd_flags |= SCF_CAW_SEM_HELD;
+	spin_unlock_irq(&cmd->t_state_lock);
 	/*
 	 * Reset cmd->data_length to individual block_size in order to not
 	 * confuse backend drivers that depend on this value matching the
@@ -592,7 +611,7 @@ sbc_compare_and_write(struct se_cmd *cmd)
 			      DMA_FROM_DEVICE);
 	if (ret) {
 		cmd->transport_complete_callback = NULL;
-		up(&dev->caw_sem);
+		sbc_caw_sem_release(cmd);
 		return ret;
 	}
 	/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 002b0fc..bd846ab 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -168,6 +168,7 @@ enum se_cmd_flags_table {
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
 	SCF_TASK_ORDERED_SYNC			= (1 << 19),
 	SCF_ATOMIC				= (1 << 20),
+	SCF_CAW_SEM_HELD			= (1 << 21),
 };
 
 /*
-- 
2.43.0

