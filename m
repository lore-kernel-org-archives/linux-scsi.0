From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [REPOST PATCH 4/5] scsi: bnx2fc: annoate unlock + release for sparse
Date: Wed, 17 Aug 2016 12:10:02 +0200
Message-ID: <20160817101003.30055-4-bigeasy@linutronix.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:40555 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbcHQKKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2016 06:10:20 -0400
In-Reply-To: <20160817101003.30055-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

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
2.9.3

