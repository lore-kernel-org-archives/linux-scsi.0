From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] sg: Remove aha1542 hack (resend)
Date: Tue, 14 Feb 2006 12:42:24 -0600
Message-ID: <200602141842.k1EIgQjZ027388@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38803 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030416AbWBNSma
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 13:42:30 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1EIgT1S030370
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2006 13:42:29 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1EIix0e176766
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2006 11:44:59 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k1EIgQb6027424
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2006 11:42:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, dougg@torque.net


Remove a hack in the sg driver that alters the total buffer
length for SG_IO commands to ensure buffers are not odd byte
lengths. This breaks on the ipr driver since it requires the
request_bufflen to equal the length specified in the cdb.
The block layer SG_IO code does not appear to have this hack.

Signed-off-by: Douglas Gilbert <dougg@torque.net>
Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~sg_remove_aha1542_hack drivers/scsi/sg.c
--- linux-2.6/drivers/scsi/sg.c~sg_remove_aha1542_hack	2006-02-14 12:35:22.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/sg.c	2006-02-14 12:35:22.000000000 -0600
@@ -2162,7 +2162,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request 
 
 	srp->res_used = 1;
 	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
-	rem = size = (size + 1) & (~1);	/* round to even for aha1542 */
+	rem = size;
 
 	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
 		num = sg->length;
_
