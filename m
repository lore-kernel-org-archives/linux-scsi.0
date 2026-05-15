Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AC7370D6F
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778868620; cv=none; b=rqp9pwpag45Acnejn0PoVwRSaGNGlnikGsv427ZUtLvz+AC0YmtJHT/F5FVPVJEk0gDvetj2b593ZftFp8MhoS0wQPmT1hst/6zS6ws/0zc+1eG4XCPwXiUFbAvXL13C3uejcgs0SkULPv6iGVABvs1g9iM+k7L232sLSIOXHLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778868620; c=relaxed/simple;
	bh=FJ/DdWgHeigV++xU0VksFlbN48BpQXYeM6cd99G9kmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T57IaxcIM74C0r9yum1DGStsfpsNoo626Z12EcKeOlHaWdkrjQGz/cmfbNtE7RrETTQOaKRhbZkDgZEsxvqBumCJNdJ/+7Rq/S2fRq4JizrfVqM9SX0Ndhqa/X2bYtNxGxwfRAQ+TZouBZelZEBinPa/IBXw2qdlL8P2u52ZaFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SfVhRIOb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfVhRIOb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778868616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0Q67hz8hJmbtUF8sz5dd3zBEylZoCXW8MMSCGJLxixs=;
	b=SfVhRIObLptFqiGpRVONY8GtccB2uFi+ycJQriJyu72KqdGpHesJ6ql9cCGZT+zlywZ7He
	S1CcDxPM255+z6h/Fclh2CwZSkfWqnqRgVouXDs0iX/y9eWfBZRS0VVat4Cjh6DrFyZV6a
	AommEQfhT7QUYe76AYF3BW95EiYk4TE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-0oYiplgiMqyCn7OuGQ5IFA-1; Fri,
 15 May 2026 14:10:13 -0400
X-MC-Unique: 0oYiplgiMqyCn7OuGQ5IFA-1
X-Mimecast-MFC-AGG-ID: 0oYiplgiMqyCn7OuGQ5IFA_1778868612
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A4A319560AA;
	Fri, 15 May 2026 18:10:12 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.89.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D12830001A2;
	Fri, 15 May 2026 18:10:10 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Bart Van Assche" <bvanassche@acm.org>
Cc: David Jeffery <djeffery@redhat.com>
Subject: [PATCH v2] scsi: core: run queues for all non-SDEV_DEL devices from scsi_run_host_queues
Date: Fri, 15 May 2026 14:09:41 -0400
Message-ID: <20260515180941.9698-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

Changes from V1:
Added a comment on why scsi_device_get cannot be used here.

 drivers/scsi/scsi_lib.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..1b2809f1a096 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -575,10 +575,33 @@ void scsi_requeue_run_queue(struct work_struct *work)
 
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *prev = NULL;
+	unsigned long flags;
 
-	shost_for_each_device(sdev, shost)
+	spin_lock_irqsave(shost->host_lock, flags);
+	__shost_for_each_device(sdev, shost) {
+		/*
+		 * Only skip devices so deep into removal they will never need
+		 * another kick to their queues. Thus scsi_device_get cannot
+		 * be used as it would skip devices in SDEV_CANCEL state which
+		 * may need a queue kick.
+		 */
+		if (sdev->sdev_state == SDEV_DEL ||
+		    !get_device(&sdev->sdev_gendev))
+			continue;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
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

