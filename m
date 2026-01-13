Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21306344047
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768320670; cv=none; b=QAouLSDjPeOeOVeNEkcxfWDl9jjPo7e+TilEkppdV9Q0G514uiglVDJEbrXLIZmhGLhECquJIIUk8xNo8XSsom7kLrFxCTAVHrGlTpeSpGLEFdUm9QGNbad5LhiqmQoSdcQ2HTTccacaJBtWgdrQQMWoRSU8chtJBaKnNVDnyuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768320670; c=relaxed/simple;
	bh=XbI8mVZcv9MNPf3K/PEAreq/wE4n+aZJofUUJuO5Rrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=swsM/8M462gg4kFHbtm+SFGxqXlBGIgMUCkKpv+bapGwQRLRiYbV8/o3+gHzUWjZBmdrxr9nd1l/qYWUeFPvB6DBDjQNPJlEf2rw10gD7n+Q68FLSjD3zjhOT0ReO5uHXiB3wrRtogp0B9+1eA2m0M4ojD/ddXWqRELRFQ3l+G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYibz7Cc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYibz7Cc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768320667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q6mFcoRTbBYRKdkpqMG8/1c+agOuNnuoPjgftfABaiw=;
	b=JYibz7Cc3bH6k2sQi2K4lAgFQX0Y+eXG3IaQTu9/73cV4aH3+9s8etndYxOS6oEsay6YIg
	rYvuG13Iw9C4d98iXyvFTIYpI+yQ0ddZsVGXP47Gyu7kp7ctfEdRGkAS5YtvmI0MoeFyGB
	IivDWQmgVT0ubDvQvc1foe5ExUoslus=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-MqVob8NiPMGqAddr3rmr3A-1; Tue,
 13 Jan 2026 11:11:04 -0500
X-MC-Unique: MqVob8NiPMGqAddr3rmr3A-1
X-Mimecast-MFC-AGG-ID: MqVob8NiPMGqAddr3rmr3A_1768320663
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B2AF18002C5;
	Tue, 13 Jan 2026 16:11:03 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.89.254])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CF6819560A7;
	Tue, 13 Jan 2026 16:11:00 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] scsi: Wake up the error handler when final completions race against each other
Date: Tue, 13 Jan 2026 11:08:13 -0500
Message-ID: <20260113161036.6730-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The fragile ordering between marking commands completed or failed so that
the error handler only wakes when the last running command completes or
times out has race conditions. These race conditions can cause the scsi
layer to fail to wake the error handler, leaving I/O through the scsi host
stuck as the error state cannot advance.

First, there is an memory ordering issue within scsi_dec_host_busy. The
write which clears SCMD_STATE_INFLIGHT may be reordered with reads counting
in scsi_host_busy. While the local CPU will see its own write, reordering
can allow other CPUs in scsi_dec_host_busy or scsi_eh_inc_host_failed to
see a raised busy count, causing no CPU to see a host busy equal to the
host_failed count.

This race condition can be prevented with a memory barrier on the error
path to force the write to be visible before counting host busy commands.

Second, there is a general ordering issue with scsi_eh_inc_host_failed. By
counting busy commands before incrementing host_failed, it can race with a
final command in scsi_dec_host_busy, such that scsi_dec_host_busy does not
see host_failed incremented but scsi_eh_inc_host_failed counts busy
commands before SCMD_STATE_INFLIGHT is cleared by scsi_dec_host_busy,
resulting in neither waking the error handler task.

This needs the call to scsi_host_busy to be moved after host_failed is
incremented to close the race condition.

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
Signed-off-by: David Jeffery <djeffery@redhat.com>
---
 drivers/scsi/scsi_error.c | 11 ++++++++++-
 drivers/scsi/scsi_lib.c   |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f869108fd969..065fd4af9b3c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -282,11 +282,20 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
 	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost = scmd->device->host;
-	unsigned int busy = scsi_host_busy(shost);
+	unsigned int busy;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * The counting of busy requests needs to occur after adding to
+	 * host_failed or after the lock acquire for adding to host_failed
+	 * to prevent a race with host unbusy and missing an eh wakeup.
+	 */
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 93031326ac3e..5dfe1cbae985 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -376,6 +376,14 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
+		/*
+		 * Ensure the clear of SCMD_STATE_INFLIGHT is visible to
+		 * other CPUs before counting busy requests. Otherwise,
+		 * reordering can cause CPUs to race and miss an eh wakeup
+		 * when no CPU sees all busy requests as done or timed out.
+		 */
+		smp_mb();
+
 		unsigned int busy = scsi_host_busy(shost);
 
 		spin_lock_irqsave(shost->host_lock, flags);
-- 
2.52.0

