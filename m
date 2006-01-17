From: brking@us.ibm.com
Subject: [PATCH 1/1] sg: Remove aha1542 hack
Date: Tue, 17 Jan 2006 17:04:05 -0600
Message-ID: <200601172304.k0HN46YN013092@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50871 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932404AbWAQXEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 18:04:12 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0HN47i6016638
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 18:04:07 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0HN47sx123666
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 18:04:07 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k0HN46E4013132
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 18:04:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove a hack in the sg driver that alters the total buffer
length for SG_IO commands to ensure buffers are not odd byte
lengths. This breaks on the ipr driver since it requires the
request_bufflen to equal the length specified in the cdb.
The block layer SG_IO code does not appear to have this hack.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~sg_remove_aha1542_hack drivers/scsi/sg.c
--- linux-2.6/drivers/scsi/sg.c~sg_remove_aha1542_hack	2006-01-17 16:50:16.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/sg.c	2006-01-17 16:50:29.000000000 -0600
@@ -2162,7 +2162,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request 
 
 	srp->res_used = 1;
 	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
-	rem = size = (size + 1) & (~1);	/* round to even for aha1542 */
+	rem = size;
 
 	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
 		num = sg->length;
_
