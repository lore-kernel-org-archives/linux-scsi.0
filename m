Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4885D4C8FE8
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693803; cv=none; b=YhnRmTp6QmRs6Vg+0J+KGCJLeToRHdZs7EugEA4Jof5kCWrUsDrLXOS37g0DEJIkY40jymErMsCHKBdv3mRQK8iuha8ZVINOuOWK9bGJZZn4l6qZ+lxH+E+QR3r4HKVVjZF7rcTMVpuwOtFU5K8HY8P73gseEsxjn6D0EERVSeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693803; c=relaxed/simple;
	bh=7Zc+upjxIlRO7YFmkB9Qan7boQAUGy6LsNMtAzQ8t5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I/fWvDASB8DACvrSt8KbrJ+E/CaV9O4NUQCgzf8FHTWUyS3fQD6MiRqg18msm/hqiqtBHLLBdlBnR50ThRaLCgoI3r2F81YYWydf7bBgYebI5pcILcBahQfZA+ctM3xf4COZ7puhiyTRgLOx8PmaSxhUCwbgquO0RXSbuVnKPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b1Mz6Xcy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1Mz6Xcy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778693801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=knnC5iVZC2Xzfx3qx+OFWZIywu7s0xYRz1hqc1kJb20=;
	b=b1Mz6XcyKWdUKk4qpq4eTAGMaA7Y9VSJrCsZ0H3/ifuoqzfGwzSnrsv/2Ovi2QhjzZeQHG
	CJC1rEoTECrlkdOcHQr+GRKjBzBMRqKXHUfT4AiJXRryuXHdMRoDskUQ0eJJaMnf6gV9q7
	4FqFnK9Walx7DSf3L73SYPaXueOqt8o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-4YmT2RDJN2uiiYmTVnjcow-1; Wed,
 13 May 2026 13:36:38 -0400
X-MC-Unique: 4YmT2RDJN2uiiYmTVnjcow-1
X-Mimecast-MFC-AGG-ID: 4YmT2RDJN2uiiYmTVnjcow_1778693797
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F064B195608E;
	Wed, 13 May 2026 17:36:36 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.81.194])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6982B1800349;
	Wed, 13 May 2026 17:36:35 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] scsi: core: run queues for all non-SDEV_DEL devices from scsi_run_host_queues
Date: Wed, 13 May 2026 13:35:51 -0400
Message-ID: <20260513173552.9222-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

While a scsi host is in a recovery state, scsi_mq_requeue_cmd will not set
the requeue list for a requeued command to be kicked in the future. The
expectation is a call to scsi_run_host_queues will kick all scsi devices
once the recovery state is cleared.

However, scsi_run_host_queues uses shost_for_each_device which uses
scsi_device_get and so will ignore devices in a partially removed state like
SDEV_CANCEL. But these devices may also have requeued requests, leaving
their requests stuck from not being kicked and causing the removal process
of the device to hang.

scsi_run_host_queues needs to run against more devices than the macro
shost_for_each_device allows. Instead of using the too limiting
scsi_device_get state checks, only ignore devices in SDEV_DEL state or
when unable to acquire a reference. Attempt to run the queues for all other
devices when scsi_run_host_queues is called.

Fixes: 8b566edbdbfb ("scsi: core: Only kick the requeue list if necessary")
Signed-off-by: David Jeffery <djeffery@redhat.com>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..bb7281dc3633 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -575,10 +575,27 @@ void scsi_requeue_run_queue(struct work_struct *work)
 
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *prev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	__shost_for_each_device(sdev, shost) {
+		if (sdev->sdev_state == SDEV_DEL ||
+		    !get_device(&sdev->sdev_gendev))
+			continue;
+		spin_unlock_irqrestore(shost->host_lock, flags);
 
-	shost_for_each_device(sdev, shost)
+		if (prev)
+			put_device(&prev->sdev_gendev);
 		scsi_run_queue(sdev->request_queue);
+
+		prev = sdev;
+
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	if (prev)
+		put_device(&prev->sdev_gendev);
 }
 
 static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
-- 
2.53.0

