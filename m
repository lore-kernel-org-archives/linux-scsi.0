Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D54EC43216
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F02D60FC4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbhHLHuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:50:44 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51846 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbhHLHuo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628754620; x=1660290620;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=rhENVR9t5E+3q6WsypqNKv3Sv5M/dUcXWGrLNHz3Cu8=;
  b=kfTsaG5KGICyY/4D8pxbc+1XLiEs7EldE2v6MVH8ypvb1T5F1aehyBnY
   PcewsTw6Jivs/zax4q8Dae3wujR6RPfB2mWDwbYySgOZPPYFXSSU/fe7e
   H6YpuU1geVQY6L8/SWp4SwO7k1SfVR85R+KyCgdAb8D2SyfxvulzfMV+Y
   VQCzWhbbpkFXjpDprSTLbh+hxpbMDKE47IoLSML/2K34zx0gPQKt74drc
   X4go7tFaJ0Kg0AWTERiClv7MYmfBUEOxRQb7VW5LOqhf+8+6jlDs6JpYX
   9n8U/CHGDI/nhGmbZ94bgXPAivDwoKLrwEgyugHv04BTiS1qFos8hwWFt
   g==;
X-IronPort-AV: E=Sophos;i="5.84,315,1620662400"; 
   d="scan'208";a="177596934"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 15:50:20 +0800
IronPort-SDR: JLJbVB67WV7LjYoGGN0PlW0gGmrPQSWA/G08R00DNd+CGQ//HGnPS7AwPghX35O7rx8PtKaprY
 5qPfG9nZxbxWq0BKryndjGnfU8kj9+kj8M6yjImstT0WPx0V14Q4xB74JiFRVlqjczYY9W6jPe
 wnyUJm4rwtx6remvGa3CM6Ib2WCJl8CjtoP7wAQBtm3hFVuz8hhw4bTUgsAK7Vtf/rJnz7vEAO
 GzEIJYPZ7hU/XSwlhfX/Ofc7l9kx5Ddbmu82k+5qsqk/li76MQhpIejr7R4XTC0jcpCK7q6Tan
 JCqCj96HiH/3mKXOW2vM2LXj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 00:25:48 -0700
IronPort-SDR: Ybz0OWujfIJQNhJbVM+lyGtpEz7f/pFIoCUo632bOvlpuh6BT5C/3wvfI2N8uxXWKpMQMbU2Fh
 5QCi7Z7yLJ8Yq6Sw2Vk269evFF2Sm2Ot7q3XLXiHygEkSRX1g4xKLReoHnFWqPWOgq44ZAdv3J
 A6Y1vfehxWTwP8UJ8y9AqebyjAXXj2G0w7lvBcQ+eTQXDM6eLJNUGRZ4dDuEL6oy70BI+cQvc7
 ChTKp5xAMkQmf4nXm+M4L7gLC0zghbOextktNYpuefvk8pMpSTzIDetdmF4dVWrGHGbDvd55lS
 q2I=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Aug 2021 00:50:18 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v5 2/5] scsi: sd: add concurrent positioning ranges support
Date:   Thu, 12 Aug 2021 16:50:12 +0900
Message-Id: <20210812075015.1090959-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812075015.1090959-1-damien.lemoal@wdc.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the sd_read_cpr() function to the sd scsi disk driver to discover
if a device has multiple concurrent positioning ranges (i.e. multiple
actuators on an HDD). This new function is called from
sd_revalidate_disk() and uses the block layer functions
blk_alloc_cranges() and blk_queue_set_cranges() to set a device
cranges according to the information retrieved from log page B9h,
if the device supports it.

The format of the Concurrent Positioning Ranges VPD page B9h is defined
in section 6.6.6 of SBC-5.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b8d55af763f9..5480d75f4883 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3125,6 +3125,86 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->security = 1;
 }
 
+static inline sector_t sd64_to_sectors(struct scsi_disk *sdkp, u8 *buf)
+{
+	return logical_to_sectors(sdkp->device, get_unaligned_be64(buf));
+}
+
+/**
+ * sd_read_cpr - Query concurrent positioning ranges
+ * @sdkp:	disk to query
+ */
+static void sd_read_cpr(struct scsi_disk *sdkp)
+{
+	unsigned char *buffer = NULL;
+	struct blk_cranges *cr = NULL;
+	unsigned int nr_cpr = 0;
+	int i, vpd_len, buf_len = SD_BUF_SIZE;
+	u8 *desc;
+
+	/*
+	 * We need to have the capacity set first for the block layer to be
+	 * able to check the ranges.
+	 */
+	if (sdkp->first_scan)
+		return;
+
+	if (!sdkp->capacity)
+		goto out;
+
+	/*
+	 * Concurrent Positioning Ranges VPD: there can be at most 256 ranges,
+	 * leading to a maximum page size of 64 + 256*32 bytes.
+	 */
+	buf_len = 64 + 256*32;
+	buffer = kmalloc(buf_len, GFP_KERNEL);
+	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
+		goto out;
+
+	/* We must have at least a 64B header and one 32B range descriptor */
+	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
+	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Invalid Concurrent Positioning Ranges VPD page\n");
+		goto out;
+	}
+
+	nr_cpr = (vpd_len - 64) / 32;
+	if (nr_cpr == 1) {
+		nr_cpr = 0;
+		goto out;
+	}
+
+	cr = disk_alloc_cranges(sdkp->disk, nr_cpr);
+	if (!cr) {
+		nr_cpr = 0;
+		goto out;
+	}
+
+	desc = &buffer[64];
+	for (i = 0; i < nr_cpr; i++, desc += 32) {
+		if (desc[0] != i) {
+			sd_printk(KERN_ERR, sdkp,
+				"Invalid Concurrent Positioning Range number\n");
+			nr_cpr = 0;
+			break;
+		}
+
+		cr->ranges[i].sector = sd64_to_sectors(sdkp, desc + 8);
+		cr->ranges[i].nr_sectors = sd64_to_sectors(sdkp, desc + 16);
+	}
+
+out:
+	disk_set_cranges(sdkp->disk, cr);
+	if (nr_cpr && sdkp->nr_actuators != nr_cpr) {
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%u concurrent positioning ranges\n", nr_cpr);
+		sdkp->nr_actuators = nr_cpr;
+	}
+
+	kfree(buffer);
+}
+
 /*
  * Determine the device's preferred I/O size for reads and writes
  * unless the reported value is unreasonably small, large, not a
@@ -3240,6 +3320,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
+		sd_read_cpr(sdkp);
 	}
 
 	/*
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b59136c4125b..2e5932bde43d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -106,6 +106,7 @@ struct scsi_disk {
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
 	u8		zeroing_mode;
+	u8		nr_actuators;		/* Number of actuators */
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.31.1

