From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: PC partition tables are little endian
Date: Wed,  1 Oct 2014 20:31:01 +0200
Message-ID: <1412188261-29632-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaJAS2f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 14:28:35 -0400
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XZOde-0007mT-B8
	for linux-scsi@vger.kernel.org; Wed, 01 Oct 2014 18:28:34 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

As sparse correctly pointed out scsi_partsize should use get_unaligned_le32
to read PC partition tables from disk, as they are little endian.

The result of this bug is that we returned incorrect geometries on big
endian systems when using the scsicam variant.  Which probably doesn't
matter as only old x86 systems every cared about the geometry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsicam.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index 92d24d6..910f4a7 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -163,8 +163,8 @@ int scsi_partsize(unsigned char *buf, unsigned long capacity,
 		    end_head * end_sector + end_sector;
 
 		/* This is the actual _sector_ number at the end */
-		logical_end = get_unaligned(&largest->start_sect)
-		    + get_unaligned(&largest->nr_sects);
+		logical_end = get_unaligned_le32(&largest->start_sect)
+		    + get_unaligned_le32(&largest->nr_sects);
 
 		/* This is for >1023 cylinders */
 		ext_cyl = (logical_end - (end_head * end_sector + end_sector))
-- 
1.9.1

