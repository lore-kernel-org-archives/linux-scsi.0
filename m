Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE7415381C
	for <linux-scsi@vger.kernel.org>; Sat,  3 Aug 2024 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722697487; cv=none; b=rvzHr9YwqzB8yy07AzIdoox8iIHjbAlEupcYZweCnoakj2tnh/LeSGl20z/b9zTYKkk56XJdOyDYdkitkPMbcBObNupXkgzhNJCWJzk2+5biJ0fjRS4V1VFkPjYQISh0d1xRAWNSX5qAkUO/Lq+4wFQenszkiepyZllRCt42Mzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722697487; c=relaxed/simple;
	bh=H5ETfG7BCCrL1MyB67CWziOXWzNneBorzJKzilKmkQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=odgVSSUFElgEX/pBxoNi6vua5zW1hyoHQB2+KTMk/tbXf6giGNTCXDHiBbnFmxivkIoxabuT4qUC4d/dlt7Mqd8FZ6WEeM23DMLBr3O5vk6C6r/RqydYViA02AoPKy9qmg/+rnRQ1GPVEgIlZeFDlLmHYC5ihwhMHr8tIeVBTa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPiV7IiM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPiV7IiM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722697484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oRvFBpmyOh9b9w2NS2Jjtbj/fbLCej5bv8aclvEAq3w=;
	b=aPiV7IiMhQOyZZ8Cl0OBYKx5hPFlozDkWv8YKHoYzLzD3veapAgULXXtHHgKlKZgHNTyhq
	vNqRZo1cNCWumD4Z22pRoeMqyUH+K1hplii9WpZedrbUlyyeZuXlB63lPX7M5tkKXk/IUU
	X7s0tcVuF/QF4LMpu7ZVSbcblYTT60g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-MjeyHkY9MHulNwT9Lv7Qlw-1; Sat,
 03 Aug 2024 11:04:38 -0400
X-MC-Unique: MjeyHkY9MHulNwT9Lv7Qlw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B07D19560AA;
	Sat,  3 Aug 2024 15:04:37 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.45.224.31])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18DBB300018D;
	Sat,  3 Aug 2024 15:04:34 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	jjurca@redhat.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com
Subject: [PATCH] mpi3mr: a perfomance fix
Date: Sat,  3 Aug 2024 17:04:33 +0200
Message-ID: <20240803150433.17733-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Patch 0c52310f2600 ("hrtimer: Ignore slack time for RT tasks in schedule_hrtimeout_range()")
effectivelly shortens a sleep in a polling function in the driver.
That is causing a perfomance regression as the new value
of just 2us is too low. In certain test the perf drop is ~30%.
Fix this by adjusting the sleep to 20us (close to the previous value).

Reported-by: Jan Jurca <jjurca@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dc2cdd5f0311..249c1a7285d6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -178,7 +178,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_DEFAULT_SDEV_QD	32
 
 /* Definitions for Threaded IRQ poll*/
-#define MPI3MR_IRQ_POLL_SLEEP			2
+#define MPI3MR_IRQ_POLL_SLEEP			20
 #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
 
 /* Definitions for the controller security status*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c196dc14ad20..5695c95fca15 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -710,7 +710,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 			    mpi3mr_process_op_reply_q(mrioc,
 				intr_info->op_reply_q);
 
-		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
+		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP);
 
 	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
 	    (num_op_reply < mrioc->max_host_ios));
-- 
2.45.2

