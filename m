Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3D2C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C56A2601FD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245371AbhHFLMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:12 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245330AbhHFLMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248316; x=1659784316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pVcHlmpRoWuO37/J7WKk29Grb6YsuafHSBbKZmTx2+Q=;
  b=cSE1A8Jwwkl/gJRjRHv3wdRADdJmVxaeYEOmjOOtxv6nlJ89lX7cog72
   qB01/fGtOTslEP40utNQw2B5n+kbf6a5OKi1++guNnFViq2+4OPLFNzG1
   8zFn/a6MNNUfDv9oXYQTNZGKDhTtcLQ+Jrk+emt8CC2k1Gtlb9xjCYl5J
   sE5lW6FP9j5bFMhN4C4dkNGHvm7ECWc3QX6LjnXVdzqzBUvyT3+0wDNRM
   RQNzFW5Kb1qdFpq17Ee9vK3rIq+F/sRRXzTN8Db3YDXhuKX52G09UZdkF
   mTxF3jXJnUeRslPUFRGIo7dSrXVDNK/4/6O0uNHElxalocaDteosI/4c6
   g==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055554"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:11:56 +0800
IronPort-SDR: 7U+dBcQ43mhsqRQGfCOdEM9Jfz9ok1q+iSIt3EJ8I8HVLgaTEVOTvkul1ZHPsBS0q25W68CT1r
 uHh8IxJu0n1JxYF+hUXVQojTIdO5e6KM5Qrdzi63iJYbV7/DzIqBvNz7LvhhNoDDCA9O01I9n7
 Y6ElP1gdlNXWH/hrbjukw8//HcdlVTmNDkxmECIgIA++vcvqUHIs05nyY/eOZ5s8bFchihpoiH
 aHZl41EgLmlZCpuwsyF5yoYfcd+pcuD5ONDor4bL52i/YpM3eGvwcHieAUza9xnavWdVBGTFyp
 Ypaidz9cYHIOnh89stqGI8YM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:31 -0700
IronPort-SDR: 6gChgECcAZRXhIbYrmfT7f6uI1LWL7fDf3Vn6OCNymRjRbZEjcLgtdaoy+HZYw/GEACTpn30z0
 ZWstvCrj51pbOXpCsjG1e4Wtq5AbsYT8IBLrFKSY4ol5snsJkmYQAI3iVKLjlUUMSBxTRgsosh
 J6Wb85P3ncBTS5lL2fbLiXBrDoTNvCGQdgrUVaXW4lYCTBNLKIOA4ihk3Djf27+WmHSXzAmEsg
 Qc6Lzu500TcNHmpIRKlmX+aEeCHN0Zk5oTonCTicUuqXtg7SppCgzBFabih+GHxayFCRXkpLDG
 pkw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 4/9] libata: cleanup ata_dev_configure()
Date:   Fri,  6 Aug 2021 20:11:40 +0900
Message-Id: <20210806111145.445697-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the helper functions ata_dev_config_lba() and
ata_dev_config_chs() to configure the addressing capabilities of a
device. To control message printing in these new helpers, as well as
in ata_dev_configure() and in ata_hpa_resize(), add the helper function
ata_dev_print_info() to avoid open coding for the eh context
ATA_EHI_PRINTINFO flag in multiple functions.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 131 ++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 56 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b13194432e5a..d3076283f9ce 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -159,6 +159,12 @@ MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
+static inline bool ata_dev_print_info(struct ata_device *dev)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+
+	return ehc->i.flags & ATA_EHI_PRINTINFO;
+}
 
 static bool ata_sstatus_online(u32 sstatus)
 {
@@ -1266,8 +1272,7 @@ static int ata_set_max_sectors(struct ata_device *dev, u64 new_sectors)
  */
 static int ata_hpa_resize(struct ata_device *dev)
 {
-	struct ata_eh_context *ehc = &dev->link->eh_context;
-	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
+	bool print_info = ata_dev_print_info(dev);
 	bool unlock_hpa = ata_ignore_hpa || dev->flags & ATA_DFLAG_UNLOCK_HPA;
 	u64 sectors = ata_id_n_sectors(dev->id);
 	u64 native_sectors;
@@ -2363,6 +2368,65 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_TRUSTED;
 }
 
+static int ata_dev_config_lba(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	const u16 *id = dev->id;
+	const char *lba_desc;
+	char ncq_desc[24];
+	int ret;
+
+	dev->flags |= ATA_DFLAG_LBA;
+
+	if (ata_id_has_lba48(id)) {
+		lba_desc = "LBA48";
+		dev->flags |= ATA_DFLAG_LBA48;
+		if (dev->n_sectors >= (1UL << 28) &&
+		    ata_id_has_flush_ext(id))
+			dev->flags |= ATA_DFLAG_FLUSH_EXT;
+	} else {
+		lba_desc = "LBA";
+	}
+
+	/* config NCQ */
+	ret = ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
+
+	/* print device info to dmesg */
+	if (ata_msg_drv(ap) && ata_dev_print_info(dev))
+		ata_dev_info(dev,
+			     "%llu sectors, multi %u: %s %s\n",
+			     (unsigned long long)dev->n_sectors,
+			     dev->multi_count, lba_desc, ncq_desc);
+
+	return ret;
+}
+
+static void ata_dev_config_chs(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	const u16 *id = dev->id;
+
+	if (ata_id_current_chs_valid(id)) {
+		/* Current CHS translation is valid. */
+		dev->cylinders = id[54];
+		dev->heads     = id[55];
+		dev->sectors   = id[56];
+	} else {
+		/* Default translation */
+		dev->cylinders	= id[1];
+		dev->heads	= id[3];
+		dev->sectors	= id[6];
+	}
+
+	/* print device info to dmesg */
+	if (ata_msg_drv(ap) && ata_dev_print_info(dev))
+		ata_dev_info(dev,
+			     "%llu sectors, multi %u, CHS %u/%u/%u\n",
+			     (unsigned long long)dev->n_sectors,
+			     dev->multi_count, dev->cylinders,
+			     dev->heads, dev->sectors);
+}
+
 static void ata_dev_config_devslp(struct ata_device *dev)
 {
 	u8 *sata_setting = dev->link->ap->sector_buf;
@@ -2410,8 +2474,7 @@ static void ata_dev_config_devslp(struct ata_device *dev)
 int ata_dev_configure(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
-	struct ata_eh_context *ehc = &dev->link->eh_context;
-	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
+	bool print_info = ata_dev_print_info(dev);
 	const u16 *id = dev->id;
 	unsigned long xfer_mask;
 	unsigned int err_mask;
@@ -2538,62 +2601,18 @@ int ata_dev_configure(struct ata_device *dev)
 					dev->multi_count = cnt;
 		}
 
-		if (ata_id_has_lba(id)) {
-			const char *lba_desc;
-			char ncq_desc[24];
-
-			lba_desc = "LBA";
-			dev->flags |= ATA_DFLAG_LBA;
-			if (ata_id_has_lba48(id)) {
-				dev->flags |= ATA_DFLAG_LBA48;
-				lba_desc = "LBA48";
-
-				if (dev->n_sectors >= (1UL << 28) &&
-				    ata_id_has_flush_ext(id))
-					dev->flags |= ATA_DFLAG_FLUSH_EXT;
-			}
+		/* print device info to dmesg */
+		if (ata_msg_drv(ap) && print_info)
+			ata_dev_info(dev, "%s: %s, %s, max %s\n",
+				     revbuf, modelbuf, fwrevbuf,
+				     ata_mode_string(xfer_mask));
 
-			/* config NCQ */
-			rc = ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
+		if (ata_id_has_lba(id)) {
+			rc = ata_dev_config_lba(dev);
 			if (rc)
 				return rc;
-
-			/* print device info to dmesg */
-			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_info(dev, "%s: %s, %s, max %s\n",
-					     revbuf, modelbuf, fwrevbuf,
-					     ata_mode_string(xfer_mask));
-				ata_dev_info(dev,
-					     "%llu sectors, multi %u: %s %s\n",
-					(unsigned long long)dev->n_sectors,
-					dev->multi_count, lba_desc, ncq_desc);
-			}
 		} else {
-			/* CHS */
-
-			/* Default translation */
-			dev->cylinders	= id[1];
-			dev->heads	= id[3];
-			dev->sectors	= id[6];
-
-			if (ata_id_current_chs_valid(id)) {
-				/* Current CHS translation is valid. */
-				dev->cylinders = id[54];
-				dev->heads     = id[55];
-				dev->sectors   = id[56];
-			}
-
-			/* print device info to dmesg */
-			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_info(dev, "%s: %s, %s, max %s\n",
-					     revbuf,	modelbuf, fwrevbuf,
-					     ata_mode_string(xfer_mask));
-				ata_dev_info(dev,
-					     "%llu sectors, multi %u, CHS %u/%u/%u\n",
-					     (unsigned long long)dev->n_sectors,
-					     dev->multi_count, dev->cylinders,
-					     dev->heads, dev->sectors);
-			}
+			ata_dev_config_chs(dev);
 		}
 
 		ata_dev_config_devslp(dev);
-- 
2.31.1

