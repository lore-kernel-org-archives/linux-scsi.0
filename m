From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] cciss: use upper_32_bits() macro to eliminate warnings
Date: Sun, 11 Nov 2007 20:59:47 -0800
Message-ID: <20071111205947.de9091e8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:37728 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbXKLFBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 00:01:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: mike.miller@hp.com, iss_storagedev@hp.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Use upper_32_bits(x) macro to handle shifts that may be >= the width of
the data type.

drivers/block/cciss.c: In function 'do_cciss_request':
drivers/block/cciss.c:2655: warning: right shift count >= width of type
drivers/block/cciss.c:2656: warning: right shift count >= width of type
drivers/block/cciss.c:2657: warning: right shift count >= width of type
drivers/block/cciss.c:2658: warning: right shift count >= width of type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/cciss.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.24-rc2-git2.orig/drivers/block/cciss.c
+++ linux-2.6.24-rc2-git2/drivers/block/cciss.c
@@ -2650,12 +2650,14 @@ static void do_cciss_request(struct requ
 			c->Request.CDB[8] = creq->nr_sectors & 0xff;
 			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
 		} else {
+			u32 upper32 = upper_32_bits(start_blk);
+
 			c->Request.CDBLen = 16;
 			c->Request.CDB[1]= 0;
-			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
-			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
-			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
-			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
+			c->Request.CDB[2]= (upper32 >> 24) & 0xff;	//MSB
+			c->Request.CDB[3]= (upper32 >> 16) & 0xff;
+			c->Request.CDB[4]= (upper32 >>  8) & 0xff;
+			c->Request.CDB[5]= upper32 & 0xff;
 			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
 			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
 			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
