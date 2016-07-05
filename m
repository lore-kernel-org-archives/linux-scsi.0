From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/4] scsi: bnx2fc: annoate unlock + release for sparse
Date: Tue,  5 Jul 2016 18:08:48 +0200
Message-ID: <1467734929-24442-3-git-send-email-bigeasy@linutronix.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:36103 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbcGEQJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 12:09:07 -0400
In-Reply-To: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

The caller of bnx2fc_abts_cleanup() holds the tgt->tgt_lock lock and it
is expected to release the lock during wait_for_completion() and acquire
the lock afterwards.

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index f501095f91ac..634e1e539850 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1080,6 +1080,8 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 }
 
 static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
+__releases(tgt->tgt_lock)
+__acquires(tgt->tgt_lock)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	int rc = SUCCESS;
-- 
2.8.1

