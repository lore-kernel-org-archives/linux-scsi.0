From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 15 Jul 2003 16:02:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058310172.981.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from login.osdl.org ([65.172.181.5]:9162 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S269834AbTGOWsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 18:48:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

Daniel McNeil and I have been debugging a hang with the aacraid driver
using the as I/O scheduler.  We found that scsi_request_fn would
de-queue a request and later re-queued it.  This left the
as_data->nr_dispatched variable in an inconsistent state (it was never
being decremented back to zero).  We added a call to
elv_completed_request to clean up the state before re-adding the
request.  This has fixed our hang problem.  The linux-scsi list is being
copied for review of the scsi_lib.c change.

===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
--- 1.99/drivers/scsi/scsi_lib.c	Sun Jun 29 18:14:44 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Jul 15 15:47:45 2003
@@ -1215,6 +1215,7 @@
 	spin_lock_irq(q->queue_lock);
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(q, req);
+	elv_completed_request(q, req);
 	__elv_add_request(q, req, 0, 0);
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)

-- 
Mark Haverkamp <markh@osdl.org>

