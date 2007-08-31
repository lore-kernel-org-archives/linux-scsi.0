From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/5] tgt: fix can_queue bug
Date: Sat, 01 Sep 2007 02:02:16 +0900
Message-ID: <200708311702.l7VH2Gj6016024@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:59586 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569AbXHaRCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 13:02:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu

should use host->can_queue instead of host->hostt->can_queue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 5851c8e..66c692f 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -237,7 +237,7 @@ int scsi_tgt_alloc_queue(struct Scsi_Host *shost)
 	 * command as is recvd to userspace. uspace can then make
 	 * sure we do not overload the HBA
 	 */
-	q->nr_requests = shost->hostt->can_queue;
+	q->nr_requests = shost->can_queue;
 	/*
 	 * We currently only support software LLDs so this does
 	 * not matter for now. Do we need this for the cards we support?
-- 
1.5.2.4

