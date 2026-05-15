Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE63FDBE9
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778868701; cv=none; b=EDATSTJm6iUchbTcDecH/ClRPgSU05JKp/mlGRdruU5Amou5oYpIga1ofsnkLRtgKdq8v7+lHy+Hl9HdIrGtcKKSyS2GfpxIKjndJurY1A0mvLeFf5gic1jBrmS1rB9YGz8qlw9nX2THLdzaqx7E7G3hLa8qu4zf0jaRM/gTKIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778868701; c=relaxed/simple;
	bh=+nSim+uEjmcKMrFVB9FVCs46GHarEWqWYDNcoIDf5Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L8s+qoPZqM8w/dUTGTmdk9WySvvz9j3IPmL5wzYaaOQ27WuTCZe8nXZY9aXZVX2aR6S5WAe0lNtHGCCSM1KS7D/hCsM703/YX/3fRuiJwfAjrBzCjm5k2tKINlpauzZ9ubN3CrWIf/fccoYf+ZCUlKIEXyFyuhIvbgyElwmXRjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FX3h1kJf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FX3h1kJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778868699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dGSdcPY6xlPUsoTJzsGBrLigD5YW6u6K1LbAyPtxaps=;
	b=FX3h1kJfl0o3E9XS1T1PQKI32bS6i9Ph0AfCOa5FOlROHsLaYMkTspClIs10vK9dz1xRP0
	XrZW+SE4V7Z9euNtAjwW12rwX3P5U7KZiIf0kg1Ixc+pEl/EOtoUFLJCoQUzsTO6temRUw
	R3AEMDWWweqVj3LcrssOqYbuHXLqVN4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-1-D4ymb76OPyeqXNv0IzNaoA-1; Fri,
 15 May 2026 14:11:35 -0400
X-MC-Unique: D4ymb76OPyeqXNv0IzNaoA-1
X-Mimecast-MFC-AGG-ID: D4ymb76OPyeqXNv0IzNaoA_1778868694
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8A7F18005BB;
	Fri, 15 May 2026 18:11:34 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.89.30])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46C181800240;
	Fri, 15 May 2026 18:11:33 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] scsi: core: wake eh reliably when using scsi_schedule_eh
Date: Fri, 15 May 2026 14:11:12 -0400
Message-ID: <20260515181112.9758-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Drivers which use the scsi_schedule_eh function to run the error handler
currently risk the error handler thread never waking once all commands are
timed out or inactive. There is no enforced memory order between setting
the host into error recovery state and counting busy commands. This can
result in a race with scsi_dec_host_busy where neither CPU sees both
conditions of all commands inactive and the host error state to request
waking the error handler.

To fix this, run the scsi_schedule_eh's scsi_eh_wakeup from a new work item
which will use rcu to ensure scsi_schedule_eh's call to scsi_host_busy will
occur after the error state is globally visible and will be seen by any
current scsi_dec_host_busy callers.

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi
_mq")
Signed-off-by: David Jeffery <djeffery@redhat.com>
---
 drivers/scsi/hosts.c      |  2 ++
 drivers/scsi/scsi_error.c | 22 +++++++++++++++++++++-
 drivers/scsi/scsi_priv.h  |  1 +
 include/scsi/scsi_host.h  |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 0cc173e777ae..23cc953f5256 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -357,6 +357,7 @@ static void scsi_host_dev_release(struct device *dev)
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
+	cancel_work_sync(&shost->eh_work);
 	if (shost->tmf_work_q)
 		destroy_workqueue(shost->tmf_work_q);
 	if (shost->ehandler)
@@ -422,6 +423,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	INIT_WORK(&shost->eh_work, scsi_rcu_eh_wakeup);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..453a2232452d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -73,6 +73,26 @@ void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 	}
 }
 
+void scsi_rcu_eh_wakeup(struct work_struct *work)
+{
+	struct Scsi_Host *shost = container_of(work, struct Scsi_Host, eh_work);
+	unsigned long flags;
+	unsigned int busy;
+
+	/*
+	 * Ensure any running scsi_dec_host_busy has completed its rcu section
+	 * so changes to host state and host_eh_scheduled are visible to all
+	 * future calls of scsi_dec_host_busy
+	 */
+	synchronize_rcu();
+
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	scsi_eh_wakeup(shost, busy);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /**
  * scsi_schedule_eh - schedule EH for SCSI host
  * @shost:	SCSI host to invoke error handling on.
@@ -88,7 +108,7 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
 		shost->host_eh_scheduled++;
-		scsi_eh_wakeup(shost, scsi_host_busy(shost));
+		queue_work(shost->tmf_work_q, &shost->eh_work);
 	}
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 7a193cc04e5b..304e8e79bd91 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -91,6 +91,7 @@ extern enum blk_eh_timer_return scsi_timeout(struct request *req);
 extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
+extern void scsi_rcu_eh_wakeup(struct work_struct *work);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4..f6b286fa59f2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -750,6 +750,9 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	/* Used for an rcu-synchronizing eh wakeup */
+	struct work_struct eh_work;
+
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
-- 
2.53.0

