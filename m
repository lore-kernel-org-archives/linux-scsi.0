From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_transport_sas: needs to call blk_end_request_all for
 SMP requests
Date: Wed, 10 Jun 2009 19:18:42 +0900
Message-ID: <20090610191708Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34438 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZFJKSr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 06:18:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org

This is scsi-merge tree (since this patch needs blk_end_request_all).

I'll revert commit c1d4c41f2fdfe66dea957b76d005affba3e56b26 after this
patch is merged and scsi-merge is rebased against 2.6.30.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_transport_sas: needs to call blk_end_request_all for SMP requests

We need to call blk_end_request_all to complete SMP requests properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_transport_sas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d606452..0895d3c 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -173,9 +173,9 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 		ret = handler(shost, rphy, req);
 		req->errors = ret;
 
-		spin_lock_irq(q->queue_lock);
+		blk_end_request_all(req, ret);
 
-		req->end_io(req, ret);
+		spin_lock_irq(q->queue_lock);
 	}
 }
 
-- 
1.6.0.6

