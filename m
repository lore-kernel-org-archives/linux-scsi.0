From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/8] stex: fix biosparam calculation
Date: Fri, 1 Dec 2006 20:43:53 -0800
Message-ID: <NONAMEBsBt8sBjukJ1z00001497@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:42536 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S1162765AbWLBEn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Dec 2006 23:43:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


Fix biosparam calculation.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 185c270..91d484c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1100,18 +1100,18 @@ static int stex_reset(struct scsi_cmnd *
 static int stex_biosparam(struct scsi_device *sdev,
 	struct block_device *bdev, sector_t capacity, int geom[])
 {
-	int heads = 255, sectors = 63, cylinders;
+	int heads = 255, sectors = 63;
 
 	if (capacity < 0x200000) {
 		heads = 64;
 		sectors = 32;
 	}
 
-	cylinders = sector_div(capacity, heads * sectors);
+	sector_div(capacity, heads * sectors);
 
 	geom[0] = heads;
 	geom[1] = sectors;
-	geom[2] = cylinders;
+	geom[2] = capacity;
 
 	return 0;
 }


