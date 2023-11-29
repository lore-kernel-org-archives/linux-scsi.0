Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4401DDFA
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7a2kesU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2F7C433C8;
	Wed, 29 Nov 2023 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701277115;
	bh=tdKTLW9MjVNyXmF52ilkOBStKcI32S26AWAl0daQqG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7a2kesUXHeP3dygqbPbR5fH1rKvi2NZbwzBepzjisn3Q4caEWFP4KjslFD8swKZ8
	 xvF3tXyzTrCRF6TWQe/RyRfD2UbF5oEfg0xVzEr9psAQqgLqKhojqUJGqG5TrVO+w4
	 kIl7uIxWAlYdToQnsiRbYlxrxz4bbU5wMJBirg7saN3Rja3XJK1qe2Tu4BnG3Kfjff
	 1LZ2unXg36srcmW1xVCC14h39BzOGHCU/1meLu8lGvcw9CCCuEt853DBCKDmd9HuDk
	 YLtJhaU46pxnFcXV55oafs5gzDFIEAbfBsvhpRrXl5Yy4wSRaCp6+32ITkaWcDGC5z
	 YTgN3Z4efKZgA==
From: hare@kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] libfc: don't schedule abort twice
Date: Wed, 29 Nov 2023 17:58:30 +0100
Message-Id: <20231129165832.224100-2-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231129165832.224100-1-hare@kernel.org>
References: <20231129165832.224100-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

The current FC error recovery is sending up to three REC (recovery)
frames in 10 second intervals, and as a final step sending an ABTS
after 30 seconds for the command itself.
Unfortunately sending an ABTS is also the action for the SCSI
abort handler, and the default timeout for scsi commands is also
30 seconds. This causes two ABTS to be scheduled, with the libfc
one slightly earlier. The ABTS scheduled by SCSI EH then sees the
command to be already aborted, and will always return with a 'GOOD'
status irrespective on the actual result from the first ABTS.
This causes the SCSI EH abort handler to always succeed, and
SCSI EH never to be engaged.
Fix this by not issuing an ABTS when a SCSI command is present
for the exchange, but rather wait for the abort scheduled from
SCSI EH.
And warn if an abort is already scheduled to avoid similar errors
in the future.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libfc/fc_fcp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 945adca5e72f..3f189cedf6db 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -265,6 +265,11 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 	if (!fsp->seq_ptr)
 		return -EINVAL;
 
+	if (fsp->state & FC_SRB_ABORT_PENDING) {
+		FC_FCP_DBG(fsp, "abort already pending\n");
+		return -EBUSY;
+	}
+
 	this_cpu_inc(fsp->lp->stats->FcpPktAborts);
 
 	fsp->state |= FC_SRB_ABORT_PENDING;
@@ -1690,11 +1695,12 @@ static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
 	fsp->status_code = code;
 	fsp->cdb_status = 0;
 	fsp->io_status = 0;
-	/*
-	 * if this fails then we let the scsi command timer fire and
-	 * scsi-ml escalate.
-	 */
-	fc_fcp_send_abort(fsp);
+	if (!fsp->cmd)
+		/*
+		 * Only abort non-scsi commands; otherwise let the
+		 * scsi command timer fire and scsi-ml escalate.
+		 */
+		fc_fcp_send_abort(fsp);
 }
 
 /**
-- 
2.35.3

