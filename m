From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 6/7] stex: switch to block timeout
Date: Sun, 30 Nov 2008 10:38:08 -0600
Message-ID: <1228063088.4115.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40485 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYK3QiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:38:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>, Ed Lin <ed.lin@promise.com>

stex sets the timeout in its slave configure routine for all devices.
This now needs to update the request queue timeout in block.

Cc: Ed Lin <ed.lin@promise.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index fd3d4f5..a3a18ad 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -477,7 +477,7 @@ stex_slave_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
-	sdev->timeout = 60 * HZ;
+	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 	sdev->tagged_supported = 1;
 
 	return 0;


