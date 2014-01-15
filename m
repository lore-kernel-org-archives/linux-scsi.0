From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/41] hpsa: only allow REQ_TYPE_FS to use fast path
Date: Wed, 15 Jan 2014 16:37:14 -0600
Message-ID: <20140115223714.5061.9240.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40337 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaAOVhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:37:15 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When commands sent down the "fast path" fail, they must be re-tried down the
normal RAID path.  We do this by kicking i/o's back to the scsi mid layer with
a DID_SOFT_ERROR status, which causes them to be retried.  This won't work for
SG_IO's and other non REQ_TYPE_FS i/o's which could get kicked all the way back
to the application, which may have no idea that the command needs resubmitting
and likely no way to resubmit it in such a way the that driver can recognize it
as a resubmit and send it down the normal RAID path.  So we just always send
non REQ_TYPE_FS i/o's down the normal RAID path, never down the "fast path".

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 56b0b48..81545a7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2330,7 +2330,8 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	if ((likely(h->transMethod & CFGTBL_Trans_io_accel1)) &&
 		(dev->ioaccel_handle) &&
 		((cmd->cmnd[0] == READ_10) || (cmd->cmnd[0] == WRITE_10)) &&
-		(scsi_sg_count(cmd) <= IOACCEL1_MAXSGENTRIES))
+		(scsi_sg_count(cmd) <= IOACCEL1_MAXSGENTRIES) &&
+		likely(cmd->request->cmd_type == REQ_TYPE_FS))
 		return hpsa_scsi_ioaccel_queue_command(h, c);
 
 	c->Header.ReplyQueue = 0;  /* unused in simple mode */

