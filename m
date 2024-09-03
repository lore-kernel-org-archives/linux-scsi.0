Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBACB1422A2
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374861; cv=none; b=jLC18b2QEEyQVuzNe67UFR5DwKZvj9Lfc6vT/SQ+NoFxmaq1w/cpaQvayaXn3AU7NK/lzKfMsXWPfro0OtefYeZywQzOxf0TtKfWAEYD42jWvLSPVN/mu+gfQFnlWFLxChLaIbifzgnA/5ZLIa1H9Ng+V1nWxls3vU82EuNwtgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374861; c=relaxed/simple;
	bh=VDab0Vm9JaaWX1fKXKcqdKsXBM6M718Rsprq0NSK+GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tcJPlvBtkarx47yyRSr5W1yXqXnf48A1GPGUVGovytfPieDfOeSVWjihXX6E5toe+LLTSsCNH/Xez3hOG1q1vZkJzQCmrdeXnnbu408Xt8z8B/Mw55dCOdxSbW+sdsCK6bRGcbFnPs2BThmlWwCb2ZBPHMCWhTj9MPeCOWnGLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZRLn7A9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZRLn7A9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725374858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=akAmdofOK29d84VlYXM2XqitwBAbU+CCdVPrNLMeleo=;
	b=EZRLn7A9LbupIh7vZ+jlyLZebTgLsCk+pjAwOGOh2udF4hjm1XasgH33cbM2sRoP0ZDfHB
	fuhxT+kCiuu5i+u9vDwuVqVXmKRCFOVEKHBUnXkxpHsMg2MQoRlPFDriOlsmVe2tNQtuU9
	jF591mCQnJVhgKYSlt6+Elxd/OZkOLg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-98-dCgouLRzMmKFSQTIoH_TZw-1; Tue,
 03 Sep 2024 10:47:33 -0400
X-MC-Unique: dCgouLRzMmKFSQTIoH_TZw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 548D818EA81A;
	Tue,  3 Sep 2024 14:47:32 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.45.225.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68F631956048;
	Tue,  3 Sep 2024 14:47:30 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	jjurca@redhat.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com
Subject: [PATCH v2] mpi3mr: a performance fix
Date: Tue,  3 Sep 2024 16:47:29 +0200
Message-ID: <20240903144729.37218-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Commit 0c52310f2600 ("hrtimer: Ignore slack time for RT tasks in schedule_hrtimeout_range()")
effectivelly shortens a sleep in a polling function in the driver.
That is causing a performance regression as the new value
of just 2us is too low, in certain tests the perf drop is ~30%.
Fix this by adjusting the sleep to 20us (close to the previous value).

The '+1' added to the max parameter in usleep_range is there just
to silence static code analyzers like checkpatch.
 
Reported-by: Jan Jurca <jjurca@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
V2: added a '+ 1' to silence checkpatch.
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
+		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
 
 	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
 	    (num_op_reply < mrioc->max_host_ios));
-- 
2.45.2

