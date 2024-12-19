Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A065B8F6D;
	Thu, 19 Dec 2024 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734644977; cv=none; b=LRr7SFDlVdcnBA6J/5zqDGWkf1mOQFlwbZPoVOixhOhb+jDe6g3T6TQmviGrHIzrN4kFz+l+cUxqNsswQXFm2hZC6uk4xdxHTc73ZV+INK722ogWHINYzUW8PpkZOPVHA5NE/n7bdV0cSBJIZjDKLK7LzYNd7hQF47q7pwoTBUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734644977; c=relaxed/simple;
	bh=pOuqnKIFfDOuJbt8wzSYVnYP0AGZfUm7m4WIaN0n8GM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bc50NfXO/+PQqDIWRgJHkV3XpeBYG4fy4MuOza4S5XlOJh+EQm9R7kCfEOfP+TLb/UjiAfNOdgao9/5yuosqGXC/GuG2oSH1+clqZeI7G2iHuAMS+T56mnWsAySs39qr6ePvFlQnEYfj+fhnWu00Rumu0QIG0PCo7HKz653i2NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NQftOciz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NQftOciz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CG+y38/wd3+mfeCBhwqUa50I/70VetXzAPAvCxo6yCE=; b=NQftOcizPZ3VUp9U52EOFBKitV
	W+MTH/frVXHRDADQuz48UipKW2mJSpqkRNSPcCBW4bZPnZjXC+88v7hLhz195IgKwFkkEB7YzrFGo
	77uQPGrZPQtxeT09ZVrYpKk810Wdegq2ks00OKNeAkYLN6f/SYDVKQZvaz4oGkmeYSjumNkGkw6yj
	KxgkvYrQmrIFkAK17SUlhNTTUIXwCfMe635Tjx31os7QribmqTxCCxxSYzt7nDQSwpT1Ejmc6NtP9
	b3ge6qplxkZbaIrItIahU/MxhgJqiZL1sE3udLy8aO/RMj+q5s7CwtV23iRsZb8Oux1u/dLdWCgC2
	t+tDczHw==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tOOOi-00000003CZ4-2CAl;
	Thu, 19 Dec 2024 21:49:32 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: documentation: scsi_eh: updates for EH changes
Date: Thu, 19 Dec 2024 13:49:28 -0800
Message-ID: <20241219214928.1170302-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SCSI_SOFTIRQ and scsi_softirq() are no longer used. Change to block
layer equivalents.

scsi_setup_cmd_retry() has been deleted. Remove references to it.

SCSI_EH_CANCEL_CMD has been deleted. Remove references to it.

scsi_eh_abort_cmds() has been deleted. Remove references to it.

START_STOP_UNIT command should be "START_STOP" instead.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 Documentation/scsi/scsi_eh.rst |   46 ++++++-------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

--- linux-next-20241218.orig/Documentation/scsi/scsi_eh.rst
+++ linux-next-20241218/Documentation/scsi/scsi_eh.rst
@@ -54,13 +54,13 @@ invoking hostt->queuecommand() or the bl
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 For all non-EH commands, scsi_done() is the completion callback.  It
-just calls blk_complete_request() to delete the block layer timer and
-raise SCSI_SOFTIRQ
+just calls blk_mq_complete_request() to delete the block layer timer and
+raise BLOCK_SOFTIRQ.
 
-SCSI_SOFTIRQ handler scsi_softirq calls scsi_decide_disposition() to
-determine what to do with the command.  scsi_decide_disposition()
-looks at the scmd->result value and sense data to determine what to do
-with the command.
+The BLOCK_SOFTIRQ indirectly calls scsi_complete(), which calls
+scsi_decide_disposition() to determine what to do with the command.
+scsi_decide_disposition() looks at the scmd->result value and sense
+data to determine what to do with the command.
 
  - SUCCESS
 
@@ -110,7 +110,7 @@ The timeout handler is scsi_timeout().
     retry which failed), when retries are exceeded, or when the EH deadline is
     expired. In these cases Step #3 is taken.
 
- 3. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
+ 3. scsi_eh_scmd_add(scmd) is invoked for the
     command.  See [1-4] for more information.
 
 1.3 Asynchronous command aborts
@@ -277,7 +277,6 @@ scmd->allowed.
 
     :ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
 
-	- scsi_setup_cmd_retry()
 	- move from local eh_work_q to local eh_done_q
 
     :LOCKING: none
@@ -317,7 +316,7 @@ scmd->allowed.
     ``scsi_eh_get_sense``
 
 	This action is taken for each error-completed
-	(!SCSI_EH_CANCEL_CMD) commands without valid sense data.  Most
+	command without valid sense data.  Most
 	SCSI transports/LLDDs automatically acquire sense data on
 	command failures (autosense).  Autosense is recommended for
 	performance reasons and as sense information could get out of
@@ -347,30 +346,6 @@ scmd->allowed.
 	   - otherwise
 		No action.
 
-    3. If !list_empty(&eh_work_q), invoke scsi_eh_abort_cmds().
-
-    ``scsi_eh_abort_cmds``
-
-	This action is taken for each timed out command when
-	no_async_abort is enabled in the host template.
-	hostt->eh_abort_handler() is invoked for each scmd.  The
-	handler returns SUCCESS if it has succeeded to make LLDD and
-	all related hardware forget about the scmd.
-
-	If a timedout scmd is successfully aborted and the sdev is
-	either offline or ready, scsi_eh_finish_cmd() is invoked for
-	the scmd.  Otherwise, the scmd is left in eh_work_q for
-	higher-severity actions.
-
-	Note that both offline and ready status mean that the sdev is
-	ready to process new scmds, where processing also implies
-	immediate failing; thus, if a sdev is in one of the two
-	states, no further recovery action is needed.
-
-	Device readiness is tested using scsi_eh_tur() which issues
-	TEST_UNIT_READY command.  Note that the scmd must have been
-	aborted successfully before reusing it for TEST_UNIT_READY.
-
     4. If !list_empty(&eh_work_q), invoke scsi_eh_ready_devs()
 
     ``scsi_eh_ready_devs``
@@ -384,7 +359,7 @@ scmd->allowed.
 
 	    For each sdev which has failed scmds with valid sense data
 	    of which scsi_check_sense()'s verdict is FAILED,
-	    START_STOP_UNIT command is issued w/ start=1.  Note that
+	    START_STOP command is issued w/ start=1.  Note that
 	    as we explicitly choose error-completed scmds, it is known
 	    that lower layers have forgotten about the scmd and we can
 	    reuse it for STU.
@@ -478,9 +453,6 @@ except for #1 must be implemented by eh_
 
  - shost->host_failed is zero.
 
- - Each scmd is in such a state that scsi_setup_cmd_retry() on the
-   scmd doesn't make any difference.
-
  - shost->eh_cmd_q is cleared.
 
  - Each scmd->eh_entry is cleared.
