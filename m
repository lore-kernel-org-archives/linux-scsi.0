From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] scsi_transport_sas: needs to call blk_end_request_all for SMP requests
Date: Wed, 17 Jun 2009 15:10:10 +0900
Message-ID: <1245219011-20481-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1245219011-20481-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47176 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZFQGM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 02:12:57 -0400
In-Reply-To: <1245219011-20481-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com

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

