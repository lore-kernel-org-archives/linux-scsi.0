Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE694D4890
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780184; cv=none; b=PTTmYARKgpAXv9Kov3WMeg/ECYwdojqsU/pFNR2Sf67Oys2KV2oL3XixSndhyDsR79QabVOwzfTSaMBQ0V54e0OlibNrVg161eKKDBa+u5xRUrkS8rxr9lDOMLGx7LcjEmovlDfiyPkBD8DKaqRQMLVTxekF126rUMH7fGuwuQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780184; c=relaxed/simple;
	bh=Diglc94M4WCrKqEp4aPrdGIGbGLwCtTAZra85TtSeZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRVhMtU3haNCpMvYWmErNQdCeWgs5IsN5lQ1bx5LaVMKQTDmYuI31QTfy1VAxkqriH6cgfj+x/IqOUq/cmqq/98NlN3WD1R1FPknHvdqRD+cU/lPJViBPm+/xO7wpy/cozMsqLx28XToEudOISX9cRIHzzTIQqsPc8F4d98s4eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y34TTkKr; arc=none smtp.client-ip=95.215.58.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y34TTkKr"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Diglc94M4WCrKqEp4aPrdGIGbGLwCtTAZra85TtSeZM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790780171; v=1; x=1791384971;
 b=Y34TTkKrqUlYw8SDqecAAy7U5q4jjvB1wa3jym5jGyn36nsiCA4Tkt4hvJrF1DruwkWW5Gy0
 +39mcWZdHAymaqJf+LTqmrFHBCiBT4e4aMUBJK9ek/kaQA8C3v1XCiF8F2bywtFarL0wq+KriL2
 MnVBziekYgy9kDzE0Ec+e2Ws=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 3012bf07ec3973ec;
	Wed, 30 Sep 2026 14:56:11 +0000
X-Mizu-Trace-ID: 3012bf07ec3973ec
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: mkp@kernel.org,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	thenzl@redhat.com,
	hare@suse.de,
	himanshu.madhani@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/2] scsi: mpi3mr: Poll a reply queue that an interrupt found busy
Date: Wed, 30 Sep 2026 07:55:48 -0700
Message-ID: <20260930145606.2632749-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930145606.2632749-1-usama.arif@linux.dev>
References: <20260930145606.2632749-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpi3mr_process_op_reply_q() returns without looking at the queue when
another context owns it. Task management polls all reply queues with
interrupts enabled, and a submitter drains the reply queue when the request
queue is full, so either can own the queue when an interrupt comes in. If
the owner made its last check just before the reply arrived, the handler
finds the queue busy and, unless enable_irq_poll happens to be set,
returns. Nobody looks at the reply until the next interrupt on that queue
or the command timeout.

Let's set enable_irq_poll when the queue is busy, so that mpi3mr_isr()
hands over to the IRQ thread, which polls until it has processed the
reply. The flag cannot be cleared before mpi3mr_isr() reads it, as the
thread only writes it while the interrupt is disabled.

Fixes: 463429f8dd5c ("scsi: mpi3mr: Add support for threaded ISR")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd00..102f84667a5cf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -588,8 +588,11 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 
 	reply_qidx = op_reply_q->qid - 1;
 
-	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
+	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1)) {
+		/* The owner may have missed a reply, let the thread poll */
+		WRITE_ONCE(op_reply_q->enable_irq_poll, true);
 		return 0;
+	}
 
 	exp_phase = op_reply_q->ephase;
 	reply_ci = op_reply_q->ci;
-- 
2.53.0-Meta

