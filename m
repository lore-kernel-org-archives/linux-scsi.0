Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937E4C43214
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 807E460FF2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244536AbhH0Hvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:51:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42485 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244495AbhH0Hvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 03:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630050648; x=1661586648;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ISHlTPMJP9UUVggdxZ0huPi7O49JHqjc4UhUHb2wpms=;
  b=bJIuT6NjZJ3DsZ8St0feOPIxG575pKDyQKw9goEER+XdsxOj5TcIs3xS
   xSKJDITmVC244td+ZcCan0VjkXAVp6Lwg1tqg49t1KaBUcEsOwPX79w4N
   HL4+Rdrvqdx9zLH/a/b2fvInVYhiKt7aFnwUxhNpP/HomVaaDi2kNGEJD
   XBzw3BVweTwGITo4meTPXtC+fQp0Sr66/WHgKcgWrYj+DsbPN/Ms/uvMz
   +p9VctogLJf7oxY++98R8nauq7aw2ejCN36DK52tfNG2Ko8xBugtrMLae
   WNiq/UXK3gISFE9BOfklKhw61Uv/+C6no1646T3wxCNLimP5JyvTRv77h
   w==;
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="183342788"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 15:50:48 +0800
IronPort-SDR: xLQLkIVohWynuewzNVreshDi1YszmnQMkpKcY7ulNeeg/PKAn931ryGvC7MkZNIz3cc46PT1MR
 HKJD8FOAmgZx0RfeDh0EUGNC0UfGuZsgY1+CsSr1l1HnSm8XJdD7u7Jrvjq6ACScF8YPvXIvDr
 1ZaOZWGWmLfoQrJIm3QNwWdbCwmnuStYH1t2oXkF39RmD8AColuhex8Q9AhL4hVBtWuS33CgJP
 SMBgVGBb+pDXD/RQ4fQHODbnVwcyax3KvgBCtYBjZih0atym9Wlin371w5PdrvoXV8eQDqumib
 6ABAZpPkdkPk+SJG6IByOAwt
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:26:01 -0700
IronPort-SDR: zZUgMCRPIIOcWSC6nOcWjThdcsg1VhpY72xJlmIxkgrE0vade1Tsd7qCNPx2aDfVRaU1XT91tI
 x7uNHoZFejJtLL3Le6w48Du1mQnc46JBAHsdXDjc5zdZ1DZ2AUjoLtoOExN3elvtgXKezVZ2AK
 pg7FyTKri8qDXuBbvnBB5f0kB+MZaWGEkjQ4/NYARkEO+XNiJ8VeKzsdSW2vaOQianeojAyj0k
 bnlP/PrQIl1zeqnvwwGCL3TM9+5wNP4gWfP+SbT2AG2fpCmu97C2OPyqzLElY1S/+PkmpipT3f
 qmc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2021 00:50:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 2/5] scsi: sd: add concurrent positioning ranges support
Date:   Fri, 27 Aug 2021 16:50:41 +0900
Message-Id: <20210827075045.642269-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827075045.642269-1-damien.lemoal@wdc.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the sd_read_cpr() function to the sd scsi disk driver to discover
if a device has multiple concurrent positioning ranges (i.e. multiple
actuators on an HDD). The existence of VPD page B9h indicates if a
device has multiple concurrent positioning ranges. The page content
describes each range supported by the device.

sd_read_cpr() is called from sd_revalidate_disk() and uses the block
layer functions disk_alloc_iaranges() and disk_set_iaranges() to
represent the set of actuators of the device as independent access
ranges.

The format of the Concurrent Positioning Ranges VPD page B9h is defined
in section 6.6.6 of SBC-5.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 610ebba0d66e..1bb49d74c3db 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3126,6 +3126,86 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
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
+	struct blk_independent_access_ranges *iars = NULL;
+	unsigned char *buffer = NULL;
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
+	iars = disk_alloc_iaranges(sdkp->disk, nr_cpr);
+	if (!iars) {
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
+		iars->iarange[i].sector = sd64_to_sectors(sdkp, desc + 8);
+		iars->iarange[i].nr_sectors = sd64_to_sectors(sdkp, desc + 16);
+	}
+
+out:
+	disk_set_iaranges(sdkp->disk, iars);
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
@@ -3241,6 +3321,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
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

