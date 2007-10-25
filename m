From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Set default command timeout
Date: Thu, 25 Oct 2007 16:06:34 -0500
Message-ID: <14670.2615464621$1193346427@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:40720 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXJYVGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 17:06:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9PL6aRf030302
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 17:06:36 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9PL6Zjg061006
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 15:06:35 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9PL6ZLJ023742
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 15:06:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Set the default command timeout for ibmvscsi disks to 60 seconds
to ensure we don't prematurely timeout commands. This fixes a problem
seen where the default 30 seconds was not long enough due to
congestion on the server.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_slave_config_timeout drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_slave_config_timeout	2007-10-25 10:52:06.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-10-25 10:55:14.000000000 -0500
@@ -1371,8 +1371,10 @@ static int ibmvscsi_slave_configure(stru
 	unsigned long lock_flags = 0;
 
 	spin_lock_irqsave(shost->host_lock, lock_flags);
-	if (sdev->type == TYPE_DISK)
+	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
+		sdev->timeout = 60 * HZ;
+	}
 	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
 	return 0;
_
