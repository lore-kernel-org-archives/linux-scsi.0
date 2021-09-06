Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B27C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAFE160FE6
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238747AbhIFB7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:59:38 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22462 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238887AbhIFB7V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893497; x=1662429497;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ISHlTPMJP9UUVggdxZ0huPi7O49JHqjc4UhUHb2wpms=;
  b=jaxP8Yw8kFq/3y/2Oy5olFms/l5xa3q+oCp3Il40EZN2jpeZm0uaWVBJ
   H+EU4axOa9+tE4r4isY7SyYM6ceDIyy65AoTDtvv35uFiNJr89XGAlQC4
   JRPEQL0KJpQNI/U6GWPIycDqw/CWrzXlZkKQIjRxQMs2H2Q6khVo04+hI
   BgB03/6h14xGTYm+joSTb3haVQ8st6AZZRgi3KwtKl/WQ3tvXwpiBSMQC
   5V2qBEJx2kHGl9/6mwER6BR8lx8e8l0N+RlbPQs5z/52zz+CRopjlBX1K
   W1yGljKhAHgiNFLrI6Oa3QBLiNYI4TuNfs5lRPEWyCSBH+SwcIpfS6eHx
   w==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="179789031"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:58:17 +0800
IronPort-SDR: 0w37D8GLhxvfSudUmVzepdS9BuXI0BEU9RjH9OKaJ10cfd20OEhft3pTDQvUwhYLnClzmr/zq1
 l+2ZPMRkbWOD1cjO5rCBS5SKbjVm1Gf+Mb+8y6Y8zvRYVlHiHArnC1VjxrS0hi3u+Ng18erHJa
 HAfqd3EknoFQ7PVT6WANI64yJjH936Ilfk+0rfrcHng4Ch+bADB+F21cLVaJlF/Ssoh4NOY6A0
 HR7BgW1HZAd5qmX6PfoK1jqBNEDL6vqSXXVlW1obM73/NYEDmGnxLVJYR8qPeJU9LhzLQoub08
 ESzV0LQprlQm1XHIz5dCfGot
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:33:17 -0700
IronPort-SDR: oGv8KdzoOXSblXamYynxE8PUDMwCIdF+/isTAHjhblplSVbDsysWH6JpvYF7IWIdkbR1AS18HM
 hFPFn/ubnTLEkC+EJFpNg68VsePz5W/4XuDWc5bJ4wIGcHhoPK9wNbB8iMPcogWfEMhz+yqZpo
 Ls4IMRWIcKsU8+tnIYjH1gjJdl/cwHPKByO3ytCxS/T5bPvTuCR0x3sG49eMb9I39O6qXFgNaT
 5CkDxSuAmgLvudkBUzL/+h+n14Lt5LFea++Waepj56UTAWI1WM0upzEjjoeKTl84G5ewjMb93B
 fVk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:58:16 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 2/5] scsi: sd: add concurrent positioning ranges support
Date:   Mon,  6 Sep 2021 10:58:07 +0900
Message-Id: <20210906015810.732799-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210906015810.732799-1-damien.lemoal@wdc.com>
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
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

