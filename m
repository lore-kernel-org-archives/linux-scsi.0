From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] SCSI: fix request flag-related build breakage
Date: Sat, 30 Sep 2006 21:28:22 -0400
Message-ID: <20061001012822.GA25208@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:22229 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751990AbWJAB2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:28:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>


The ->flags in struct request was split into two variables, in a recent
changeset.  The merge of this change forgot to update SCSI's libsas,
probably because libsas was a very recent merge.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7f9e89b..e46e793 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -126,7 +126,7 @@ static enum task_attribute sas_scsi_get_
 	enum task_attribute ta = TASK_ATTR_SIMPLE;
 	if (cmd->request && blk_rq_tagged(cmd->request)) {
 		if (cmd->device->ordered_tags &&
-		    (cmd->request->flags & REQ_HARDBARRIER))
+		    (cmd->request->cmd_flags & REQ_HARDBARRIER))
 			ta = TASK_ATTR_HOQ;
 	}
 	return ta;
