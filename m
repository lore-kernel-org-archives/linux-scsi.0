Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90F5C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38C06101A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243930AbhIIChB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:37:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42516 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhIICg6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 22:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631154950; x=1662690950;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=b5aQHVCUqaNLjgwXMsVMbT/4vRRyOAdv1TQpXmZcR6I=;
  b=MP64AVcZ8JkUJ1ucU3Z5f0KipXBq7E3TojrXuFZR0sy0VMqN3mHzBcCu
   CVNzWw3XZeLzJDsAtBSZW1+GWUFSbsTCWo63v/eBj0mQMDvmAFadSM0Ni
   UeKT1ZAUHKZ3gkVoHMLKIFDuj2JWYUe/9Az6+qOU17r9B0XR8EVbLqeXi
   J28D5+k7oSnh5y39dHOiSEE2dL7vpmF3yoQTSi8Gydg0YYDynga+j7lSG
   mqzKdzjp6PNvY6g9tez04N1e5dGmMajRoOzdKRCFiCgAL/t1IdQfnh9et
   dOGit7M9IaEcX5f3K2cQTcZHuLx+a9hwB25HGKxE/oOzMYJO44tsfjNES
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="180062212"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 10:35:50 +0800
IronPort-SDR: Dl52bq/bvXJMCVKK0APAzdNbRdQUlRlqqmpjnnCKp9S/Xbnsd3TGemxyDo95nk4qe2XUitJHff
 +TW2uLWSpo9969ppBBVpnn2kJhVnyOOb0HV7NijV11M72HXdnebrwszBngeola2cAcmeyfObFX
 UfZ0sOS1Omv/qzOSpHFLTcMdrMYRdMIJ1Ls5j17zZPD3Wl4gydWnZt3yXggD9eFUZI/jYCKcrM
 aZO6EOD7BIGOuWZEawkt2ZCt6aGkpnCb3BHYYy66IF9ga8kaYRk5ymBN9NuQLuHKeKtNj6Mtd8
 1DFLeWTRV1z2/dWDAJWxkUKo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 19:12:25 -0700
IronPort-SDR: NPw7z3Lsk2wxu/BTmtEEDGPuOcPAiFXydGsgAXaiQPiqXWy2TgLT9YgUMm3j1Rta+hhPdVD9cP
 wmFhoiS9hDlj5Jwojv91ZOLsh+ZDHX2Cu4fyx/VSnFqi9OGThwSndaK5+27nPiHtsUA9IiSK2G
 G1qtQhnrO6QfsvSjJGxfehw4fPux9apEeikPy3Ys1+GEWVp4WRcXYqexknak2EwSZ9NHNpgX9C
 df732VVaNpi1vKbSHiUT3CLFr26qZlhjdJj2G0DzIDrAdWlFK5VRUNC7rlqVT1+5EiNOXWaIKT
 vGQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 19:35:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v8 2/5] scsi: sd: add concurrent positioning ranges support
Date:   Thu,  9 Sep 2021 11:35:42 +0900
Message-Id: <20210909023545.1101672-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
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
layer functions disk_alloc_independent_access_ranges() and
disk_set_independent_access_ranges() to represent the set of actuators
of the device as independent access ranges.

The format of the Concurrent Positioning Ranges VPD page B9h is defined
in section 6.6.6 of SBC-5.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 610ebba0d66e..acffd8a0ba48 100644
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
+	iars = disk_alloc_independent_access_ranges(sdkp->disk, nr_cpr);
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
+		iars->ia_range[i].sector = sd64_to_sectors(sdkp, desc + 8);
+		iars->ia_range[i].nr_sectors = sd64_to_sectors(sdkp, desc + 16);
+	}
+
+out:
+	disk_set_independent_access_ranges(sdkp->disk, iars);
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

