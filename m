Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AA3C41537
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A908D60FC3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhHLC1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 22:27:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbhHLC1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 22:27:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628735209; x=1660271209;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=rhENVR9t5E+3q6WsypqNKv3Sv5M/dUcXWGrLNHz3Cu8=;
  b=qpNh0HUdxYmw7g0B8iczBzlTlL491z+2Gi93kjX5rBKvYdlthTawgSNP
   tv2IpUX17uq1YvAVEWnaE2AYRjCgtJTZ0b/HaTfrJiSepZiTevrb0bC2Z
   Tlk1HMA1OxZXv4rS7FsMYpk9vF3TCK/D8dJ4f8T4G2OJbkr3pBs02bbOu
   QWPGOCmdwIga192BPWiG+1fou+hI30TVW6zllCExazvUXgMqmfRdecNhe
   WasUfMBhxZ+7RIZf+czIv171AUD9Vll+GDzeAB6s6YAilQhM7nKIf2M8/
   Nw871kPXMEaG90/pQRWAE1gQUIopiYzynK02/ZV08gcTGNR1Y1+ZG4bid
   w==;
X-IronPort-AV: E=Sophos;i="5.84,314,1620662400"; 
   d="scan'208";a="280823441"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 10:26:49 +0800
IronPort-SDR: LT3G1iZ2VgrMWDNxEL4569URfIYv//hIqngF6wf2SxzMVaLN37ulemGsPph/lO8sUYMYrP2y6G
 sN6x1+3ppHDU5zlKPioCwQPKWUfodq0940esdjBMwNf8iv4l6UYP5RMM4aC5Ffns84xT4fNU92
 jLpCpX3P/o5MZxAu+HBb/PcTJgI3rv/3K+lCmx0M0F1KjnW917S0Kl7/VvYAyAQ57J4vf/8MSS
 cviXKKyAqLajpHCJGVbJfB2k2c3ZrvyIdXOp4cJAklX4Mq/9ueQUxizuCzffOuZS6SL/8Lb7eI
 uIJTFgaDLLVi47MvOP8BodMB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 19:04:08 -0700
IronPort-SDR: ynF3CvuZN9pmYh8VqD38sE6htPC5v8pD1pgH5vfZFaj2THcOi/B8TA9TYVeB9I/ldVdS2bnSRy
 HxGRvj0wygh+fskfKIikWFhbmjlg9JpdaXESR8CUs3CQJICgN1VVEitR42ulqAuxDJsVyuhMoH
 8yzb8GBWq2PyZXQ+xkEYURMbhisJ/6GbdQEiEsWhfwHpfcaabCXpycTS6YOTUepYYtpKyKjLa4
 IG5OoTiOlqhYWKmDtV7GYg1ziQMKPy/Pg2rzsKLFF4cCjBSfMPyi9OMiriU3E9eQHLE+yLafwk
 1jA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Aug 2021 19:26:49 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v4 2/5] scsi: sd: add concurrent positioning ranges support
Date:   Thu, 12 Aug 2021 11:26:23 +0900
Message-Id: <20210812022626.694329-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812022626.694329-1-damien.lemoal@wdc.com>
References: <20210812022626.694329-1-damien.lemoal@wdc.com>
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

