Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929DEC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7BF60FD8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbhH0Hvk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:51:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42487 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244535AbhH0Hvj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 03:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630050650; x=1661586650;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Pct8EeEecztMeJWAOQS8KuUpCZvdxSholvmEQ5/zfBM=;
  b=aTd456tIZNCDqNHniPUjzDf5YewyrfuJx/waT2KNzl9psw55mmjHudNY
   tjbcFFnwdLkdAvA4Rvp6aMPCoGXmd7uyGJT2bkrenRSxjxml36qg6DX0c
   CIVZKcK+Jozk8RKA8qvjHB6hiSk5FRMRgXo8K7iRWWc7dA3nZnmnSpCYZ
   P7r6pRls1DNqWheYP3hUH2obHiNA1mcfrRZFpE18SKc/wZKptk4ubVTdB
   G0EjvsF2a5qYe8fB+9FQPLiojPrBnJg5esGu4YqdppRVCrvXLipVoufA4
   LZ9MpvqXCEpZPv2jIxdNZLhTiunznBkZNKaMj4I2HJoYXEkgVqYSmkiAs
   w==;
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="183342790"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 15:50:49 +0800
IronPort-SDR: 3LTNezyCi005tnZFpkAQxQtlVio5nvjrDjJtuE5D0cbOONsM/Na9nB+CNhdJKugVVBXy35NiZp
 3lEsXXiGhwmisVih1P42FM4Q+4XxGkXux8qWp1a+qqPqLZXw/8vAHtdm48+ARFcA+457iRTL3X
 YXyevaOx7RNHwUgWOrVyreA6NyH+A1rIAOtTreAEZDKTUUfXMQgu341eBLcjYBwreG23VIFs5F
 fDciRPMityU0tHJAMaOpwI/81hN1MMVTfCQUgppYHvpUBK4OJN/7lSz4ooumShLZJBOcgqzWhT
 NPsarmlN4pup87G6jcRc7ejv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:26:02 -0700
IronPort-SDR: E5E4rC9aQbtaqkAM7KwB41nw/V9aga4+ZwVHOmmEoEcJP87T9WRuI688/24vlfKY9xUFBiNiKK
 htjNJIMzYWer0e6sbMp0G8LNWRjKmg+z5IZBbqsLi0Rn52tOzf8gY6CSWdxkVe5HdnCePxtkoN
 bfaFvu9dxkCHvTE7aPwSTf/xum6KFcnUKjUa7Thilb8sZ6Z7QEW5sxu/hOn4j3mV0X7+Hp0O8D
 e6S16Htq2cbnOLbMp3KcB+W3MUBkEO40KkNoFk25DQdG8onewOckkm//Nt3IJTiF2ztqEVaggI
 q7o=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2021 00:50:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 3/5] libata: support concurrent positioning ranges log
Date:   Fri, 27 Aug 2021 16:50:42 +0900
Message-Id: <20210827075045.642269-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827075045.642269-1-damien.lemoal@wdc.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-core.c | 52 +++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c | 48 +++++++++++++++++++++++++++++-------
 include/linux/ata.h       |  1 +
 include/linux/libata.h    | 15 +++++++++++
 4 files changed, 107 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..ab3f61ea743e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2363,6 +2363,57 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_TRUSTED;
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
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2591,6 +2642,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_sense_reporting(dev);
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
+		ata_dev_config_cpr(dev);
 		dev->cdb_len = 32;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9588c52815d..5cadbb9a8bf2 100644
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
@@ -1947,13 +1947,17 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
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
 
@@ -2163,6 +2167,26 @@ static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -4162,11 +4186,17 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
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
index 3fcd24236793..b159a245d88c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -670,6 +670,18 @@ struct ata_ering {
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
@@ -729,6 +741,9 @@ struct ata_device {
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

