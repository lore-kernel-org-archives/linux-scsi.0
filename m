From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 7/8] cciss: change cciss_open for consistency
Date: Thu, 2 Nov 2006 09:04:14 -0600
Message-ID: <20061102150414.GF16430@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:32153 "EHLO palrel10.hp.com")
	by vger.kernel.org with ESMTP id S1751204AbWKBPEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 10:04:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


PATCH 7/11

This patch changes our open to test for drv->heads like we do in other
places in the driver. Mostly for consistency.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)
------------------------------------------------------------------------------------------
diff -urNp linux-2.6-p00006/drivers/block/cciss.c linux-2.6/drivers/block/cciss.c
--- linux-2.6-p00006/drivers/block/cciss.c	2006-10-31 15:48:46.000000000 -0600
+++ linux-2.6/drivers/block/cciss.c	2006-10-31 15:57:39.000000000 -0600
@@ -494,7 +494,7 @@ static int cciss_open(struct inode *inod
 	 * but I'm already using way to many device nodes to claim another one
 	 * for "raw controller".
 	 */
-	if (drv->nr_blocks == 0) {
+	if (drv->heads == 0) {
 		if (iminor(inode) != 0) {	/* not node 0? */
 			/* if not node 0 make sure it is a partition = 0 */
 			if (iminor(inode) & 0x0f) {
