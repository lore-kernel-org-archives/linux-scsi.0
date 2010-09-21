From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] SCSI: remove noop in fc_bsg_goose_queue()
Date: Tue, 21 Sep 2010 23:19:39 +0800
Message-ID: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48048 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0IUPZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 11:25:43 -0400
Received: by wyf22 with SMTP id 22so5502966wyf.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 08:25:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.>

The tests for QUEUE_FLAG_REENTER seem unnecessary.
And check for get_device() is added.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-21
22:05:38.000000000 +0800
@@ -3766,16 +3766,11 @@ fc_bsg_goose_queue(struct fc_rport *rpor
 	if (!rport->rqst_q)
 		return;

-	get_device(&rport->dev);
+	if (! get_device(&rport->dev))
+		return;

 	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
-	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
-		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
-	if (flagset)
-		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
 	__blk_run_queue(rport->rqst_q);
-	if (flagset)
-		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
 	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);

 	put_device(&rport->dev);
