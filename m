Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC8B379999
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 22:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884190; cv=none; b=hL0niwZkcualD8sPuuEhJWjGcqvHiJLEG9MJNClaZ+Z4DNkBPrquQqen3rGGJliimAyS31y5yYsglxIGzjdTelc2h1z6xUJVITrqW9Wk5KoD3tV/oqFb+YiDpIjJ3cYIhaA034fQu9zcY1bkcJzwpMjv2sPmjiNzKZzVLGERvCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884190; c=relaxed/simple;
	bh=RpAhE9r22npbM9BsWlbQn7ZMmDDAGl3nfOjnsxFKEco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su97NGupaoj7z+R+0K2tnOnR5HOidUVfKAijDtkvii4gkv5vsxsg0SI1mEIk7jmyqlhdwqfLf2v6SJrmIcElywGt55on0Wiq5kagl84czzv1vU5HIMY7vcjkKdwp/1HFO9bR8GHt7OoaGO8fvOiVJSyUFC4nnk0to5qkHgjOqaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uW7J6Rh9; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uW7J6Rh9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771884187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6WYV+RYD8F55D+aSz2Pa8PWyUJmjrbupsrCQtG2IOqk=;
	b=uW7J6Rh9rkxCxWP5dtPhIiNajkzMPUl2QTsJXxZgDUDzWF9ezhCOqy3wY0BZu4woMJAVQf
	R0H6gkipx1EiBDaDTHYnQ1Le0zP9InflsuYmaNyoPI7y+NzvhkAe+ppMBuvGxiWyAD8IPj
	CL3h0gUPzMFzLujoZtzPbVRHZSyF+4k=
From: Bart Van Assche <bart.vanassche@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 29/62] fnic: Make fnic_queuecommand() easier to analyze
Date: Mon, 23 Feb 2026 14:00:29 -0800
Message-ID: <20260223220102.2158611-30-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-1-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bart Van Assche <bvanassche@acm.org>

Move a spin_unlock_irqrestore() call such that the io_lock_acquired
variable can be eliminated. This patch prepares for enabling the Clang
thread-safety analyzer.

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 29d7aca06958..f47c92dfbfd0 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -471,7 +471,6 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Host *shost,
 	int sg_count = 0;
 	unsigned long flags = 0;
 	unsigned long ptr;
-	int io_lock_acquired = 0;
 	uint16_t hwq = 0;
 	struct fnic_tport_s *tport = NULL;
 	struct rport_dd_data_s *rdd_data;
@@ -636,7 +635,6 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Host *shost,
 	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 
 	/* initialize rest of io_req */
-	io_lock_acquired = 1;
 	io_req->port_id = rport->port_id;
 	io_req->start_time = jiffies;
 	fnic_priv(sc)->state = FNIC_IOREQ_CMD_PENDING;
@@ -689,6 +687,9 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Host *shost,
 		/* REVISIT: Use per IO lock in the final code */
 		fnic_priv(sc)->flags |= FNIC_IO_ISSUED;
 	}
+
+	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
+
 out:
 	cmd_trace = ((u64)sc->cmnd[0] << 56 | (u64)sc->cmnd[7] << 40 |
 			(u64)sc->cmnd[8] << 32 | (u64)sc->cmnd[2] << 24 |
@@ -699,10 +700,6 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Host *shost,
 		   mqtag, sc, io_req, sg_count, cmd_trace,
 		   fnic_flags_and_state(sc));
 
-	/* if only we issued IO, will we have the io lock */
-	if (io_lock_acquired)
-		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-
 	atomic_dec(&fnic->in_flight);
 	atomic_dec(&tport->in_flight);
 
