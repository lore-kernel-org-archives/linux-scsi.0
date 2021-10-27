Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBDAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 813DE60F92
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhJ0CYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:24:55 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63769 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbhJ0CYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635301347; x=1666837347;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=h/Xxjrt7YMtL1pD+fOkp/1u40o82dNbTOS7rcXFeRFw=;
  b=b2m2IidSuXFjnne9F2Hvvq3XYOrxhxhWuFQ/0iGNjUJksSeh/9xBqKYS
   /ZY1Y9IitiP8w7Iw2wwS8BitPj20w+gUBNKxGCEl3lOxQAfaJQSI1iRNQ
   IUaocv0605/jf+0boPDVGT7cibg/nJX6XjtYOaKN5pS8pYklt959/v739
   BjYur3b2EOWEW4SwxeL2GZwF9b2vLiC3+zTxIS8FZ5ABskfzLByDI/10d
   jDgHsaIFxCgkbIWAAdfX/Nsem+QAHcNhRs1CMhIqis/aH0LqHQ8Ww7mQv
   Vt/nCEiJBWGqYRxkkDOCJALL5f6ipzTpT+X9/mgHBPEKUjSMnSfi1FA3v
   g==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="183924738"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:22:27 +0800
IronPort-SDR: 6xBt7vPJa4M23Kf9ALIFlolH0rhzfX3/WqaRjfnQXT9D7dkRB5PUA9x2JGz5ruiydvwMugm4uK
 XqAhJsB4lVYG/HlkPS6ZMcJBYMclO0N8BKmC8HYsMccNWD//FD8R7gZrwCad0me2SzdWGZpinE
 ti0BcdpMiCoT0Kgfs8QVlpV1JT2uKl5BOaIm4lpS7izUI1yQNhPurJ01zLn1Jb3zcodE8k11PA
 epUOZjkwXJFst8FpHQ7yoT+CatXPOMDhbR/tedkPAMdnWMMgdTVtXESinRaV9Qy5tb5AD+hTm5
 BtXycH7a2BrEw1AogqnP8qCQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 18:57:57 -0700
IronPort-SDR: PJqnmRRhkeX5pbq8B6ADciJXi/uoFfoe0a1ERRVNnJKjjWE/WZiPah8cp4jSDhtv+yXBHO25W/
 dBax60Wikg/5XxuXsrKz2O6/4Aqw3a6+IxwoXAuMi5IHLBgAI4kQncuDPI/gIVvukHdB/dM0IX
 SEusqvxxTXQ3u5CdwzHDE0o1N5IJwD28gow93GKxq1ZpVM6m3qiSUAbsSgaO6JyU0HqhTeYk7O
 5vEsu+NwfUdCHk4wXp50f2TQnvRoWT3C95Ev9Ir/RqQVYvvl1lmX2+TLkBaicu4xHZdpo/PGBL
 eac=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2021 19:22:28 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v9 3/5] libata: support concurrent positioning ranges log
Date:   Wed, 27 Oct 2021 11:22:21 +0900
Message-Id: <20211027022223.183838-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027022223.183838-1-damien.lemoal@wdc.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support to discover if an ATA device supports the Concurrent
Positioning Ranges data log (address 0x47), indicating that the device
is capable of seeking to multiple different locations in parallel using
multiple actuators serving different LBA ranges.

Also add support to translate the concurrent positioning ranges log
into its equivalent Concurrent Positioning Ranges VPD page B9h in
libata-scsi.c.

The format of the Concurrent Positioning Ranges Log is defined in ACS-5
r9.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/ata/libata-core.c | 57 +++++++++++++++++++++++++++++++++++++--
 drivers/ata/libata-scsi.c | 48 ++++++++++++++++++++++++++-------
 include/linux/ata.h       |  1 +
 include/linux/libata.h    | 15 +++++++++++
 4 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index eed65311b5d1..75f1a6cd6621 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2459,18 +2459,70 @@ static void ata_dev_config_devslp(struct ata_device *dev)
 	}
 }
 
+static void ata_dev_config_cpr(struct ata_device *dev)
+{
+	unsigned int err_mask;
+	size_t buf_len;
+	int i, nr_cpr = 0;
+	struct ata_cpr_log *cpr_log = NULL;
+	u8 *desc, *buf = NULL;
+
+	if (!ata_identify_page_supported(dev,
+				 ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+		goto out;
+
+	/*
+	 * Read IDENTIFY DEVICE data log, page 0x47
+	 * (concurrent positioning ranges). We can have at most 255 32B range
+	 * descriptors plus a 64B header.
+	 */
+	buf_len = (64 + 255 * 32 + 511) & ~511;
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_CONCURRENT_POSITIONING_RANGES,
+				     buf, buf_len >> 9);
+	if (err_mask)
+		goto out;
+
+	nr_cpr = buf[0];
+	if (!nr_cpr)
+		goto out;
+
+	cpr_log = kzalloc(struct_size(cpr_log, cpr, nr_cpr), GFP_KERNEL);
+	if (!cpr_log)
+		goto out;
+
+	cpr_log->nr_cpr = nr_cpr;
+	desc = &buf[64];
+	for (i = 0; i < nr_cpr; i++, desc += 32) {
+		cpr_log->cpr[i].num = desc[0];
+		cpr_log->cpr[i].num_storage_elements = desc[1];
+		cpr_log->cpr[i].start_lba = get_unaligned_le64(&desc[8]);
+		cpr_log->cpr[i].num_lbas = get_unaligned_le64(&desc[16]);
+	}
+
+out:
+	swap(dev->cpr_log, cpr_log);
+	kfree(cpr_log);
+	kfree(buf);
+}
+
 static void ata_dev_print_features(struct ata_device *dev)
 {
 	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK))
 		return;
 
 	ata_dev_info(dev,
-		     "Features:%s%s%s%s%s\n",
+		     "Features:%s%s%s%s%s%s\n",
 		     dev->flags & ATA_DFLAG_TRUSTED ? " Trust" : "",
 		     dev->flags & ATA_DFLAG_DA ? " Dev-Attention" : "",
 		     dev->flags & ATA_DFLAG_DEVSLP ? " Dev-Sleep" : "",
 		     dev->flags & ATA_DFLAG_NCQ_SEND_RECV ? " NCQ-sndrcv" : "",
-		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "");
+		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "",
+		     dev->cpr_log ? " CPR" : "");
 }
 
 /**
@@ -2634,6 +2686,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_sense_reporting(dev);
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
+		ata_dev_config_cpr(dev);
 		dev->cdb_len = 32;
 
 		if (ata_msg_drv(ap) && print_info)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1fb4611f7eeb..15a279f773c7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1895,7 +1895,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
  */
 static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 {
-	int num_pages;
+	int i, num_pages = 0;
 	static const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
@@ -1905,13 +1905,17 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0xb1,	/* page 0xb1, block device characteristics page */
 		0xb2,	/* page 0xb2, thin provisioning page */
 		0xb6,	/* page 0xb6, zoned block device characteristics */
+		0xb9,	/* page 0xb9, concurrent positioning ranges */
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
 
@@ -2121,6 +2125,26 @@ static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
+{
+	struct ata_cpr_log *cpr_log = args->dev->cpr_log;
+	u8 *desc = &rbuf[64];
+	int i;
+
+	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
+	rbuf[1] = 0xb9;
+	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
+
+	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
+		desc[0] = cpr_log->cpr[i].num;
+		desc[1] = cpr_log->cpr[i].num_storage_elements;
+		put_unaligned_be64(cpr_log->cpr[i].start_lba, &desc[8]);
+		put_unaligned_be64(cpr_log->cpr[i].num_lbas, &desc[16]);
+	}
+
+	return 0;
+}
+
 /**
  *	modecpy - Prepare response for MODE SENSE
  *	@dest: output buffer
@@ -4120,11 +4144,17 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
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
+			if (dev->cpr_log)
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
index c0c64f03e107..236ec689056a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -676,6 +676,18 @@ struct ata_ering {
 	struct ata_ering_entry	ring[ATA_ERING_SIZE];
 };
 
+struct ata_cpr {
+	u8			num;
+	u8			num_storage_elements;
+	u64			start_lba;
+	u64			num_lbas;
+};
+
+struct ata_cpr_log {
+	u8			nr_cpr;
+	struct ata_cpr		cpr[];
+};
+
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
@@ -735,6 +747,9 @@ struct ata_device {
 	u32			zac_zones_optimal_nonseq;
 	u32			zac_zones_max_open;
 
+	/* Concurrent positioning ranges */
+	struct ata_cpr_log	*cpr_log;
+
 	/* error history */
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
-- 
2.31.1

