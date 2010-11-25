From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix mm leakage of block request in SCSI FiberChannel transport
Date: Thu, 25 Nov 2010 21:53:05 +0800
Message-ID: <AANLkTi=08YvR9O7c7+asB3d-PkguutKepFZfUbCXmYZR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37777 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0KYNxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 08:53:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>, devel@open-fcoe.org, linux-kernel@vger.kernel.org

When blk_rq_timed_out_timer run, only requests that are not completed
are selected for processing with LLD callback function.

In the case of fc_bsg_job_timeout, if BLK_EH_NOT_HANDLED returned, the
block layer will be signaled to do nothing for the request, but the
request still remains uncompleted since it is already marked with
REQ_ATOM_COMPLETE by the timer function and blk_complete_request()
will check it. Thus mm leakage is triggered.

It is fixed by returning BLK_EH_HANDLED, instead of
BLK_EH_NOT_HANDLED, with warning also recorded.

Thanks all for comments when preparing this work.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_transport_fc.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_transport_fc.c	2010-11-24 20:55:12.000000000 +0800
@@ -3626,9 +3626,9 @@ fc_bsg_job_timeout(struct request *req)

 	/* the blk_end_sync_io() doesn't check the error */
 	if (done)
-		return BLK_EH_NOT_HANDLED;
-	else
-		return BLK_EH_HANDLED;
+		printk(KERN_WARNING "%s: fixing mm leak...done\n", __func__);
+
+	return BLK_EH_HANDLED;
 }

 static int
