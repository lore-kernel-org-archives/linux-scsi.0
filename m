From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] scsi_debug: check for bigger value first
Date: Tue,  6 Jan 2015 23:03:18 +0200
Message-ID: <1420578198-24241-1-git-send-email-andy.shevchenko@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:56187 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbbAFVKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 16:10:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D . Milne" <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>

Even for signed types we have to check for bigger positive value first.
Otherwise it will be never happened.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8bcf6ad..a34df1d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4850,10 +4850,10 @@ static int __init scsi_debug_init(void)
 	/* play around with geometry, don't waste too much on track 0 */
 	sdebug_heads = 8;
 	sdebug_sectors_per = 32;
-	if (scsi_debug_dev_size_mb >= 16)
-		sdebug_heads = 32;
-	else if (scsi_debug_dev_size_mb >= 256)
+	if (scsi_debug_dev_size_mb >= 256)
 		sdebug_heads = 64;
+	else if (scsi_debug_dev_size_mb >= 16)
+		sdebug_heads = 32;
 	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
 			       (sdebug_sectors_per * sdebug_heads);
 	if (sdebug_cylinders_per >= 1024) {
-- 
1.8.3.101.g727a46b

