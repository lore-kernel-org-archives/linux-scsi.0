Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B522101C1
	for <linux-scsi@vger.kernel.org>; Sat,  3 Feb 2024 02:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706928384; cv=none; b=bgL6FIawaMpPxa9BXWNReyWKGGStb6HvEk2AvAEADNeOdRxAbxXsnSRPTpl2md+KtwRpcv0f901d/nJLQ76XmHiHoevymmFsZA1JdyDKedv8pvwQWoPO3h1Hw6fs3hUSO6+v32AnfZkgilRhCqRsLdBY3eSTmZ9MuI+wuzAoz7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706928384; c=relaxed/simple;
	bh=EFcD1FHMbODFBDZQUusU/ufZc+W1oK+05Ch9Zs5IzjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OWYBfp8dGmOL+FTASMsZIxOnXJYlbGE94HW1S7Ne91A12ljLEegiFXfSUUFb7c9n6VBhN96MQMt4KcvkuIKPIE9j09fLQDatpImjJSRbft8CQ5lHQBccYs29XJ38HAJ3f3WOPWyMR3fcoAU28uQdYaC0Pgb7Off8MJE4kunqIwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DAxHobGC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DAxHobGC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706928381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BzbMYabS278m4m9+LsWWwH4A+1hWB9XIkf/DS2FqO/g=;
	b=DAxHobGCEmQWohzBY2PqzFSs1Wco3TuisFXfn60eMuyqulQ4almOx0U1ERkMuLHoAvwZqs
	VKzI5uKUQAxck6rFDmQlTM4Fws7jJIsNhJViVDil2scSF4QkCqXkftODfsgtRSpWZIGJti
	OYfFNf4XKFz6M57B2aD2mSJSMV/QoEI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-K8adQ7VmPm29u61ZqDGAig-1; Fri, 02 Feb 2024 21:45:37 -0500
X-MC-Unique: K8adQ7VmPm29u61ZqDGAig-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFEC4837228;
	Sat,  3 Feb 2024 02:45:36 +0000 (UTC)
Received: from localhost (unknown [10.72.116.16])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0ADF7492BC6;
	Sat,  3 Feb 2024 02:45:35 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Ewan D . Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: core: move scsi_host_busy() out of host lock if it is for per-command
Date: Sat,  3 Feb 2024 10:45:21 +0800
Message-ID: <20240203024521.2006455-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Commit 4373534a9850 ("scsi: core: Move scsi_host_busy() out of host lock for
waking up EH handler") is for fixing hard lockup issue triggered by EH.

The core idea is to move scsi_host_busy() out of host lock if it is
called for per-command. However, the patch is merged as wrong and
doesn't move scsi_host_busy() out of host lock, so fix it.

Fixes: 4373534a9850 ("scsi: core: Move scsi_host_busy() out of host lock for waking up EH handler")
Cc: Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_error.c | 3 ++-
 drivers/scsi/scsi_lib.c   | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4f455884fdc4..612489afe8d2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -282,11 +282,12 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
 	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost = scmd->device->host;
+	unsigned int busy = scsi_host_busy(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
-	scsi_eh_wakeup(shost, scsi_host_busy(shost));
+	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1fb80eae9a63..df5ac03d5d6c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -278,9 +278,11 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
+		unsigned int busy = scsi_host_busy(shost);
+
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->host_failed || shost->host_eh_scheduled)
-			scsi_eh_wakeup(shost, scsi_host_busy(shost));
+			scsi_eh_wakeup(shost, busy);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 	rcu_read_unlock();
-- 
2.41.0

