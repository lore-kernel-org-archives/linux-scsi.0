From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Fix slave_configure deadlock
Date: Mon, 01 Apr 2013 09:44:26 -0500
Message-ID: <201304011444.r31EiRb3018412@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:39373 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3DAOrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Apr 2013 10:47:04 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 1 Apr 2013 08:47:03 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 74E8019D8045
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2013 08:46:15 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r31EkHND050334
	for <linux-scsi@vger.kernel.org>; Mon, 1 Apr 2013 08:46:17 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r31EiUFA018594
	for <linux-scsi@vger.kernel.org>; Mon, 1 Apr 2013 08:44:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: rcj@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


No locks should be held when calling scsi_adjust_queue_depth
so drop the lock in slave_configure prior to calling it.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_slave_configure_deadlock drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_slave_configure_deadlock	2013-03-06 16:36:26.000000000 -0600
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2013-03-06 16:36:26.000000000 -0600
@@ -1899,8 +1899,8 @@ static int ibmvscsi_slave_configure(stru
 		sdev->allow_restart = 1;
 		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
 	}
-	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	return 0;
 }
 
_

