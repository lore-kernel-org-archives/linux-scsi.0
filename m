From: brking@us.ibm.com
Subject: [PATCH 05/16] ipr: Use sector_t type in sector_div call
Date: Wed, 04 Aug 2004 17:31:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042232.i74MVxoo399302@westrelay02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:62648 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S267472AbUHDWck
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 18:32:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, pluto@pld-linux.org


From: Pawel Sikora <pluto@pld-linux.org>
The first parameter for sector_div must be sector_t rather than int.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_sector_t drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_sector_t	2004-08-04 17:17:28.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:28.000000000 -0500
@@ -2787,7 +2787,8 @@ static int ipr_biosparam(struct scsi_dev
 			 struct block_device *block_device,
 			 sector_t capacity, int *parm)
 {
-	int heads, sectors, cylinders;
+	int heads, sectors;
+	sector_t cylinders;
 
 	heads = 128;
 	sectors = 32;
_
