Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AF0C636CA
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A80161244
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbhGUKEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:04:38 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53613 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbhGUKBn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 06:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626864137; x=1658400137;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=eVdP8gEwYf4LJlTw6lqJ7/xD91dkYaBGnEouf+NGHy0=;
  b=Ridags+ICRLzVeBAmYoa2Nq2tn6fu9zhh2TSGHl5BbE9AlXmvg8gZJzM
   seyrLFwED+1htCH4j3+kKiRGBCYLSVuItP7syVO+aDA/3Kpm4z97Wafj1
   bo+t+FKTx+jtpBsTw6Po95ZAocgl8oh958NwBp8hmxrMt37Fn0M8uK9RI
   MS1Yh/t46f4HGgbJr5IQylMuTtWGV/7ktFxsthNwphlLsoXJOnoD4BFx4
   382FEN2NizZsQu15FNgzBlwu1Bed2qThVpTFfSSJnmm6u2zQ/NcyBvLiP
   Dbgnt4w7L+ujuHaef6sP1ymKOIht+xVm0+zdQt7lNeMQySq8YNHevpv6w
   g==;
X-IronPort-AV: E=Sophos;i="5.84,257,1620662400"; 
   d="scan'208";a="179944864"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2021 18:42:10 +0800
IronPort-SDR: Wp9IfKAJV7RmcCqBb56iNgxHKjlbO64GLakLhmTZVA1VSnJ5Vhx4uGtpF/OiYFTcpv+YABKLlF
 1W3Dbi8E3ZYS0FvRdhhdhF8TBMJansM6aOGqynJ3pDyfSas5PjhBQjQ7larWMFbRihPX7ycxmb
 tRTVU0BTyHlKYpX9azijUekAiceTRh6/VpFl3uG2aqbf0jMyjiud7obK89TMCrrhyUmhDxcTvR
 e009g2hMNpxaiRuiQB9PuSiKoCYEew/Ii9jDQJYEp/66CiNg8E8tGrrAExg7QZNPzRIV2TYz5+
 nUujgpO5Z3q7Jp1++J+9jFFL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 03:20:04 -0700
IronPort-SDR: bTMR8BTD0ma/ePjNUwX7cj+5dpncOyhvfCpEgFIFfzTsk8nP3OoG5ZS10kFmIz2Ty6X51XIusa
 GO64HUf7asGxV01BE4W6aeSaLSDpV2zo9atgdj+tVrIGxOoHVFvJr7pGPJsH10/yd1+8IufS/Q
 w0Wl9d7UYwZPPDZj65EOFmjWA4/JtKk1sjcYFEHYmaeauAkw/muXPb9G4EzEZIhbuYiZfAlGfQ
 JFE3Qyu7Pey83V12d+Bw0wICJxvLnytHQip6cUNOpb/hi9qWAxGRYabJ0GLwbJ3XVOxZEG5Hrq
 EcQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jul 2021 03:42:10 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 2/4] scsi: sd: add concurrent positioning ranges support
Date:   Wed, 21 Jul 2021 19:42:03 +0900
Message-Id: <20210721104205.885115-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721104205.885115-1-damien.lemoal@wdc.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/sd.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 81 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b8d55af763f9..b1e767a01b9f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3125,6 +3125,85 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
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
+	unsigned char *buffer, *desc;
+	struct blk_cranges *cr = NULL;
+	unsigned int nr_cpr = 0;
+	int i, vpd_len, buf_len = SD_BUF_SIZE;
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
@@ -3240,6 +3319,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
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

