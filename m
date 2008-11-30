From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/7] ibmvscsi: switch to block timeout
Date: Sun, 30 Nov 2008 10:20:37 -0600
Message-ID: <1228062037.4115.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53687 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbYK3QUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:20:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>, Brian King <brking@linux.vnet.ibm.com>

ibmvscsi sets the timeout in its slave configure routine for disk
devices.  This now needs to update the request queue timeout in block.

Cc: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 87e09f3..6cad175 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1442,7 +1442,7 @@ static int ibmvscsi_slave_configure(struct scsi_device *sdev)
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
-		sdev->timeout = 60 * HZ;
+		blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 	}
 	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);


