Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FFBC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 01:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F60560EBA
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 01:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhGWAlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 20:41:31 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43106 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhGWAla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 20:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627003326; x=1658539326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obRrtrdNI8ZnmW532ciGoaL+n+JdATCeY+pJxx35DX8=;
  b=XEDotzOrK+D9YMo2lEQXWDzqD1MtkaThNxH96ZVbjhDmmryiEaBg+I0o
   peobMfBbk48oSNrz89+YD/IvH4lSRTBn7jU4jtdatrtvaDwm36mpiCYVf
   DZfiiset0hexiJFHVWkE5EtD9AlsskKCqm8v+HTEdREroKKBA8KCzAGE/
   JyNed069YOmJdpAmVDklu9Mme1toXyNlGPo+27pM56QPi0vchJrmz+PpS
   V4IWizmBdbDS9xbjOzKJVk5H40B9e+PypldJTgOU9XnBlwBlx9whOqzQw
   sY/datNMmRX4T0JbjLldX/HrszzMH0oDFpuuWQP+BABnlZ/Blsej1uecJ
   A==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="175874117"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 09:22:06 +0800
IronPort-SDR: zDK3n3x8WbBMAYihxLJTykWrjV+nM9wLv7t82nLYYbTXY4zIL0pvuTB04CulyCdrHUVq4xpjzY
 UYNyXtwWdzA41PzQmX8LA17+4wvg9GMSF2zjcIZjdBOrYDN4ZtWKUWlyjxwmCW5JH6NDJW84HD
 /vWREb85p5adCsulO67A51IHvFhIYS9SqRJ/B/zZ6vO5qwEc1HD23eQB1k2sp9TBWnTSZyB5BC
 NtoHVB4HCoadSeBnG7EegjCEwb50vlApJID1/FgKEEYC2enKUD4lDmb30tlVdK4WINIWycSEi7
 ipHrtdwz3/1HDX6FVpBz8W+v
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 17:59:55 -0700
IronPort-SDR: b4XwSubDch5vZ8R9I3m/ri5TOHeM1e0pL0hbOlM8WHvPb9ZbL50gBacc9jdRzQT//FtYC4cwjs
 mEDss3Frw7MJ6R2pgLqoJ6HJETVtbqRgkHKbEs16ctcjhA1yBM7QGsdP2lPlnyfJI4EexcAdDW
 fgiTkALpGTcWujrm/lGhU4dE1tdxQklLAnzRAoA08cO/hLQrhS6aveJFOKRSY4IVGvO+FbFYxX
 0p7+RhtSb6JXCZMffcp4DbhPmVqoRZKsMDcQQaLKus994FTpguOlYyMYgojR5n3R54w4O18QCK
 DWs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 22 Jul 2021 18:22:03 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 2/4] scsi: sd: add concurrent positioning ranges support
Date:   Fri, 23 Jul 2021 10:21:58 +0900
Message-Id: <20210723012200.953825-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210723012200.953825-1-damien.lemoal@wdc.com>
References: <20210723012200.953825-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/sd.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b8d55af763f9..8e83099b49f6 100644
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
+	cr = blk_alloc_cranges(sdkp->disk, nr_cpr);
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
+	blk_queue_set_cranges(sdkp->disk, cr);
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

