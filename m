From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/7] aacraid: switch to block timeout
Date: Sun, 30 Nov 2008 10:15:37 -0600
Message-ID: <1228061737.4115.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50744 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbYK3QPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:15:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>, aacraid@adaptec.com

aacraid updates the timeout in its slave configure routine if it is too
small.  This now needs to update the request queue timeout in block.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: AACRAID list <aacraid@adaptec.com>

---
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1c5ac39..9f6f157 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -427,8 +427,8 @@ static int aac_slave_configure(struct scsi_device *sdev)
 		 * Firmware has an individual device recovery time typically
 		 * of 35 seconds, give us a margin.
 		 */
-		if (sdev->timeout < (45 * HZ))
-			sdev->timeout = 45 * HZ;
+		if (sdev->request_queue->rq_timeout < (45 * HZ))
+			blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
 		for (cid = 0; cid < aac->maximum_num_containers; ++cid)
 			if (aac->fsa_dev[cid].valid)
 				++num_lsu;


