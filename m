Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D7CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 04:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F4620801
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 04:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rZfG+IDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgFHE5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 00:57:48 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13345 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgFHE5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 00:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591592267; x=1623128267;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZJ7tROwKvtfYPY1/UBqH6KyTNq32QgrXYzoWlXT3tNI=;
  b=rZfG+IDu3DfZCjDmBYZ2KCHTHsL//v9xKvgjRdRF/YywZf17TXGuI8VR
   98aLDc5szFkjRCovUmyaUCMOYBVYA/xuBF9w8GuAULPohBeMPZVN8mBW1
   Vci+tl1fCyScyKIh1353V4ttuMHCiSRqA3VFLDlElqjTGQOBU4A+cuF+u
   +51SX/kLO9DnlIIJWhiQmBBbKNLQNrWjhWhvP7IsvvMEcKF47feRlZ30D
   Ji/0WJBvn0FmYyTHvaTmgDc6fvXcz8z52ap2kIN+c3hZvOffUtWGjSFOb
   ZQQd0/0vEAWzPn/Rt/Njf0kf4DfnnfNQUJJuWxJUobKyIPEHuwIh3WiG8
   w==;
IronPort-SDR: 2+Ztkaz0GM7guYqX70dkEymEG+q4mhbBjtgNXOFTNgqQq5NG4YvJqf26KldfQyL9ZJ+aBVhTLu
 CsHFrS/0U0f3cqlq98vGkQGjI6Ns8EY2d9HBU/Td30YC2ZYShpatEx30h3jTkzmg3FqqLO3L0u
 IHfY56KC1PQr/1a8Pkgx9Z7t3yZp6Pbqejx1bSnHQm/DnJ+AJmWjG9XRqz3E6P73QnYBRU5cxC
 NgLEfT8lfkvsAzxlj0qBXfuNOQLzdcVhV8bLTyUDjPPc4Es0lEjSPRHF1v3gX6AsUrPXCS6Xdx
 zZw=
X-IronPort-AV: E=Sophos;i="5.73,487,1583164800"; 
   d="scan'208";a="248547594"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2020 12:57:47 +0800
IronPort-SDR: DjgFgqi7Er6NnJJ0FlEMJCThEWJbltLsrrbk5gToKA5vbqS1sp4OFMkaKbZ6hMjFYqK5XqfXOh
 FXq7lNPy+1+icKYZyt7WHTSyGfGgkIN2Q=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2020 21:46:45 -0700
IronPort-SDR: xo5euSVFzM+MyMWiiUh9ECIsBf5n4zaiunmx566iPPyvWmJe8DNooCZZs1+NdoIDaa9htNj+8o
 hUk13wTfSaQA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Jun 2020 21:57:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Use sd_first_printk() where possible
Date:   Mon,  8 Jun 2020 13:57:46 +0900
Message-Id: <20200608045746.1275523-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In sd.c and sd_zbc.c, replace sd_printk() calls conditional to
sdkp->first_scan with calls to sd_first_printk(). This simplifies the
code (no functional changes).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c     | 19 ++++++++++---------
 drivers/scsi/sd_zbc.c | 18 +++++++-----------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..dfa94b5c84c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2362,9 +2362,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
 	blk_queue_alignment_offset(sdp->request_queue, alignment);
-	if (alignment && sdkp->first_scan)
-		sd_printk(KERN_NOTICE, sdkp,
-			  "physical block alignment offset: %u\n", alignment);
+	if (alignment)
+		sd_first_printk(KERN_NOTICE, sdkp,
+			"physical block alignment offset: %u\n", alignment);
 
 	if (buffer[14] & 0x80) { /* LBPME */
 		sdkp->lbpme = 1;
@@ -2978,14 +2978,15 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 			 * with partitions as regular block devices.
 			 */
 			q->limits.zoned = BLK_ZONED_NONE;
-			if (sdkp->zoned == 2 && sdkp->first_scan)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "Drive-managed SMR disk\n");
+			if (sdkp->zoned == 2)
+				sd_first_printk(KERN_NOTICE, sdkp,
+						"Drive-managed SMR disk\n");
 		}
 	}
-	if (blk_queue_is_zoned(q) && sdkp->first_scan)
-		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
-		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+	if (blk_queue_is_zoned(q))
+		sd_first_printk(KERN_NOTICE, sdkp,
+			"Host-%s zoned block device\n",
+			q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
 
  out:
 	kfree(buffer);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6f7eba66687e..cb3c291c03db 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -571,9 +571,8 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 	 * are not supported.
 	 */
 	if (!sdkp->urswrz) {
-		if (sdkp->first_scan)
-			sd_printk(KERN_NOTICE, sdkp,
-			  "constrained reads devices are not supported\n");
+		sd_first_printk(KERN_NOTICE, sdkp,
+			"constrained reads devices are not supported\n");
 		return -ENODEV;
 	}
 
@@ -609,11 +608,10 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 		/* The max_lba field is the capacity of this device */
 		max_lba = get_unaligned_be64(&buf[8]);
 		if (sdkp->capacity != max_lba + 1) {
-			if (sdkp->first_scan)
-				sd_printk(KERN_WARNING, sdkp,
-					"Changing capacity from %llu to max LBA+1 %llu\n",
-					(unsigned long long)sdkp->capacity,
-					(unsigned long long)max_lba + 1);
+			sd_first_printk(KERN_WARNING, sdkp,
+				  "Changing capacity from %llu to max LBA+1 %llu\n",
+				  (unsigned long long)sdkp->capacity,
+				  (unsigned long long)max_lba + 1);
 			sdkp->capacity = max_lba + 1;
 		}
 	}
@@ -622,9 +620,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	rec = buf + 64;
 	zone_blocks = get_unaligned_be64(&rec[8]);
 	if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
-		if (sdkp->first_scan)
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Zone size too large\n");
+		sd_first_printk(KERN_NOTICE, sdkp, "Zone size too large\n");
 		return -EFBIG;
 	}
 
-- 
2.26.2

