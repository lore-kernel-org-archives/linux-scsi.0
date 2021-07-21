Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A91C636C9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FA761222
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhGUKF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:05:27 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53609 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbhGUKBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 06:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626864149; x=1658400149;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=dvwRLyQ/uyyN0Ac8uzZ5GsxrgGBHTzT8Or9L4J+FKvU=;
  b=cfdtP8/T6tsfjCEnUimddZGezdKouHcETlXMkB9nhLNc61zY7fi4XfdB
   Wkip/NCYHXGJHQVT0xPSO/Yj5EoVcKlUsTT6RXwj1PPWKwSsn7iUVAmvC
   qt5iWpkRnYoYOIEiMwavOxRYnoCEA5mL24OfN+3tWS9ASkumLDkFp+ZYY
   oElPGLE01IghjnfnU4oSXy8zjRFVvkWvZNGqWKf7wJycphm7esEHK4glm
   RbAokMyimQAO2sig2hpuYLD23/QxdnC+y9lIFWpX8u5sNBJounH61Mx2+
   N95+8Ot31KOdLWXVPQBDQST/hS4cmtbxil1952mmrxIzoV1xs1xJEcHUv
   w==;
X-IronPort-AV: E=Sophos;i="5.84,257,1620662400"; 
   d="scan'208";a="179944868"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2021 18:42:11 +0800
IronPort-SDR: ZuYwIJ6Mw4a/5C7TC9Q381P/NEnMrjV5/nRZuAlMrhZ0+jjwbNouMv8ESgvFcPNVRj9GTjCGcK
 VfI8ey9ERirVUeLR/hM9obv8xcQNdx//MEgyk09tY+ka6bu7uzsEDAbvrCQYxpsfmZTGt1E0hE
 sLROZtS4uG+BRgLEyayIHy11V8XnGUzPdkHIJp6+L9UfmhYg5nLwFx0k3Jiryls7g9qqzNKbkA
 FcIeBjbNUa0JAiUDljXn5QSDUk6S+dWAOrBQpvA9dAulHVzZPrIPYvOE8YIbXwjn4FHiulUUPU
 2dFDLn2BFplAAMzt4iC0dnGQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 03:20:05 -0700
IronPort-SDR: ApW7V0ic12nGlCPn0gJz6PZ9yHNVNYJcvDDc1LLXYUzjt7JEVqKQexuUTKTjqreWk03tF8cm2V
 wQp1g8Q23BpIiGNvRFJnootyt3KZIv9aFwvMxGvuH7366hpDHsoPISnB1R7bkeKiuqP6qyYR7K
 3r/wtY2wm9+F75sbyupLJk7dq3WPC4ttmGOhQqLpBRCcvbk+ItV/fXdhqn26B8Cs4hJY5qm1da
 x5pbGQnLy4cXQJlDlGEy4XbLANBaz5wHJF1x33JIA+XQoXAlioRvIyfN8Cm5zKqtq8M9YIxOtc
 aUA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jul 2021 03:42:12 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 3/4] libata: support concurrent positioning ranges log
Date:   Wed, 21 Jul 2021 19:42:04 +0900
Message-Id: <20210721104205.885115-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721104205.885115-1-damien.lemoal@wdc.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support to discover if an ATA device supports the Concurrent
Positioning Ranges Log (address 0x47), indicating that the device is
capable of seeking to multiple different locations in parallel using
multiple actuators serving different LBA ranges.

Also add support to translate the concurrent positioning ranges log
into its equivalent Concurrent Positioning Ranges VPD page B9h in
libata-scsi.c.

The format of the Concurrent Positioning Ranges Log is defined in ACS-5
r9.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 57 +++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c | 46 ++++++++++++++++++++++++-------
 include/linux/ata.h       |  1 +
 include/linux/libata.h    | 11 ++++++++
 4 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..863287c77ba2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2363,6 +2363,62 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_TRUSTED;
 }
 
+static void ata_dev_config_cpr(struct ata_device *dev)
+{
+	unsigned int err_mask;
+	size_t buf_len;
+	int i, nr_cpr = 0;
+	struct ata_cpr *cpr = NULL;
+	u8 *buf, *desc;
+
+	dev->nr_cpr = 0;
+	kfree(dev->cpr);
+	dev->cpr = NULL;
+
+	if (!ata_identify_page_supported(dev,
+				 ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+		return;
+
+	/*
+	 * Read IDENTIFY DEVICE data log, page 0x47
+	 * (concurrent positioning ranges). We can have at most 255 32B range
+	 * descriptors plus a 64B header.
+	 */
+	buf_len = (64 + 255 * 32 + 511) & ~511;
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_CONCURRENT_POSITIONING_RANGES,
+				     buf, buf_len >> 9);
+	if (err_mask)
+		goto free;
+
+	nr_cpr = buf[0];
+	if (!nr_cpr)
+		goto free;
+
+	cpr = kcalloc(nr_cpr, sizeof(struct ata_cpr), GFP_KERNEL);
+	if (!cpr) {
+		nr_cpr = 0;
+		goto free;
+	}
+
+	desc = &buf[64];
+	for (i = 0; i < nr_cpr; i++, desc += 32) {
+		cpr[i].num = desc[0];
+		cpr[i].num_storage_elements = desc[1];
+		cpr[i].start_lba = get_unaligned_le64(&desc[8]);
+		cpr[i].num_lbas = get_unaligned_le64(&desc[16]);
+	}
+
+free:
+	kfree(buf);
+	dev->nr_cpr = nr_cpr;
+	dev->cpr = cpr;
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2591,6 +2647,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_sense_reporting(dev);
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
+		ata_dev_config_cpr(dev);
 		dev->cdb_len = 32;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 144e8cac44ba..922f130b8382 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1937,7 +1937,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
  */
 static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 {
-	int num_pages;
+	int i, num_pages = 0;
 	static const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
@@ -1950,11 +1950,14 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0xb9,	/* page 0xb9, concurrent positioning ranges */
 	};
 
-	num_pages = sizeof(pages);
-	if (!(args->dev->flags & ATA_DFLAG_ZAC))
-		num_pages--;
+	for (i = 0; i < sizeof(pages); i++) {
+		if (pages[i] == 0xb6 &&
+		    !(args->dev->flags & ATA_DFLAG_ZAC))
+			continue;
+		rbuf[num_pages + 4] = pages[i];
+		num_pages++;
+	}
 	rbuf[3] = num_pages;	/* number of supported VPD pages */
-	memcpy(rbuf + 4, pages, num_pages);
 	return 0;
 }
 
@@ -2164,6 +2167,25 @@ static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
+{
+	u8 *desc = &rbuf[64];
+	int i;
+
+	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
+	rbuf[1] = 0xb9;
+	put_unaligned_be16(64 + (int)args->dev->nr_cpr * 32 - 4, &rbuf[3]);
+
+	for (i = 0; i < args->dev->nr_cpr; i++, desc += 32) {
+		desc[0] = args->dev->cpr[i].num;
+		desc[1] = args->dev->cpr[i].num_storage_elements;
+		put_unaligned_be64(args->dev->cpr[i].start_lba, &desc[8]);
+		put_unaligned_be64(args->dev->cpr[i].num_lbas, &desc[16]);
+	}
+
+	return 0;
+}
+
 /**
  *	modecpy - Prepare response for MODE SENSE
  *	@dest: output buffer
@@ -4163,11 +4185,17 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
 			break;
 		case 0xb6:
-			if (dev->flags & ATA_DFLAG_ZAC) {
+			if (dev->flags & ATA_DFLAG_ZAC)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b6);
-				break;
-			}
-			fallthrough;
+			else
+				ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
+			break;
+		case 0xb9:
+			if (dev->nr_cpr)
+				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b9);
+			else
+				ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
+			break;
 		default:
 			ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
 			break;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 1b44f40c7700..199e47e97d64 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -329,6 +329,7 @@ enum {
 	ATA_LOG_SECURITY	  = 0x06,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
+	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device SATA settings log:*/
 	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3fcd24236793..94b7e152e76e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -670,6 +670,13 @@ struct ata_ering {
 	struct ata_ering_entry	ring[ATA_ERING_SIZE];
 };
 
+struct ata_cpr {
+	u8			num;
+	u8			num_storage_elements;
+	u64			start_lba;
+	u64			num_lbas;
+};
+
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
@@ -729,6 +736,10 @@ struct ata_device {
 	u32			zac_zones_optimal_nonseq;
 	u32			zac_zones_max_open;
 
+	/* Concurrent positioning ranges */
+	u8			nr_cpr;
+	struct ata_cpr		*cpr;
+
 	/* error history */
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
-- 
2.31.1

