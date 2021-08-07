Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0B6C4320E
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CA061186
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhHGET3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:29 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhHGET0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309949; x=1659845949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U84M9F3y/4VazXMtbdvkj4XojBngq+NUivd0VWyCXps=;
  b=AM8vezkIqkbdSWZX55/rX63gAP3WYOBtApQgPtlmvYzyXcocW9r1f+8V
   mvc3aisnSu0mc9E60QsJFlIkiY0j6iIojxvsiaqT4k/bqm1SJbLoUl6Kn
   NbxuSXcx2XMrTALYb2IDKvXzFxKHNzZxTMeZy5KI1hCj49gz8R/P2UTyj
   XYKnGn3HmsOWx9Ho7Xhg1Wxd0tRAJ1wlOGPMRIZWg0ttyLmQvrv+eMSXO
   39dzxGPqr5pQdGg4WrrQqS3HIohngj2QAHLQK+FZ4ChaknIdQiZOycTYU
   cChlAlKwTRbgJOKBaEHQCb+z1rfR6BAfJQJbkzrtWrcTJSkG2c7lxstCO
   g==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363663"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:09 +0800
IronPort-SDR: L2e2YAXmmYBsXZ8wIuPV9Gx7OKKBoaIAZuBIu67r/4P75xAsRHCDHjkoSWLlhEku5NGlwhpOMG
 Fvu6PnG6bA8i2aZoHyaezP9w/gUg5MjqsZGKnNWKGiT5qvn3CkaxZlKEkAzFZZYavuhg+JZTl5
 Kdrfkz7BapQ6BsAvX15i3SugLZk8i/7VfQuGkqGX/gmmiH0rau56F01XyfY2fFOKN7Lrw8mHOS
 pMAcKbNoUon6bQwTgrfqdnGYSN/p1EvydCU6ZpklSyCTmKaBuCyQwYs3KthN+uIIGERNetGwym
 gf5A5sR7G9k22nyUYjZEYyk4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:37 -0700
IronPort-SDR: Ngon84kmLIzaYJMQj5PCSWIzx2IqOfgX0a8/tszlpFotsifLpexT57uXURDdoylAN3U4aBYxGr
 /4sjFTOR1d1q3rvn+0HADXYNEf7GgWA9VOttAmOTyciSfPT5MvuDlONBJaqvUWHmUvVzOp4bUi
 6xVUCLKKvqSRG8lxtdrv8xK5qJZ9Zf9UuHAdCNfV/Hb3/npg38gwPZlbzS3UqyJ1SM/vfqGsMk
 a+86wQ7R5sqLnqMON+SGy20seQ6v58KkItE6LZp1KM8fR6hLmwh2vmF2kO3mBJR1DHDD7HEOj5
 jME=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:08 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 05/10] libata: cleanup ata_dev_configure()
Date:   Sat,  7 Aug 2021 13:18:54 +0900
Message-Id: <20210807041859.579409-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 131 ++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 56 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index febf46b87a42..c6a2e34e0892 100644
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

