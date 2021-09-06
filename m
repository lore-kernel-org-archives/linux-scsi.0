Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8F8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC466103B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhIFB7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:59:39 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22455 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238907AbhIFB7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893499; x=1662429499;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=JvrFu+U1V8PAYrjm6bWrGsnC1QXXCBxJtUJePkupkKw=;
  b=ejVu7cRiN/b3kThODUfs6weuNmoUBGZS7asyzVirCau2TDt2XcPkA9AX
   EW4eYU9X6GbekDB80yDU/0SgIAID8GRCt6Vprtjo6+B7+IcMNttHtsPPH
   0Yhw91078Ui1iDy+jrl5Dllams436VbsFK/B5Fqes1WZsoDAD+pFGKnpw
   goQ71x/mxEFzk2ZzJMGTYNffUGvm6oFQfUm79ypGqwAbRyz6lGdQNjZP5
   qPTRlXC4hIHWoXofmTvWjQc4r64W+ihAGJlz/Pa4csAKj3+fl2gxgrKoz
   g/ATOATb4aqDlk1BlcDP4WmJeHFxIRCnVK/itdC7Vdq7WV4TnYDT8cShx
   g==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="179789033"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:58:18 +0800
IronPort-SDR: S3+WxJWoEoI2U9b5r4AdKcYr4NVx9H7Ti8vd3jj3YNyPW7guZOA4PVEeCfC0pkdDzGziaVN/oR
 +1QjmNzIqsNYdzVc55cNS8z4kprYZ1SFwowrTlLuB8hTY+pspdtlJiIDLWI8Tkq3QxzoLArxw4
 bHuNnbKR59N9ZFX6owFwuXo/nnUO1vt4J4x2kNB3KNJgD+HD+Alnlj9WIExKuXJycyuP8dSs/8
 XGnx5CoEJX4zUx6jJOR7Ipli6TPodwaseDDXeesvAXFZdymhIlZT8AVnf9KQbrebCcbPd/PcXe
 SByH65oduyxIY+UcV03whkyf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:33:18 -0700
IronPort-SDR: uSGcK8gj7u4tf65uzutmd6T9YqR9JwiDAhLlo6qUBI1/sxwR6iPXbXHf3+Uy8dQfj4uRcAwZGq
 0SKRILE0fNMpK4s0tF+IxA8XtfMFaa/5to/OdzLiGpvS2vmJOmI/8ftuT2gupR0uOwvbNHQL4I
 iW+zZFq+wllx6/u2KSk2pvz9BFOj1/KrIFE0iWBErx0HSxsnQum+V/P3wVuE1SZTWCnJoeHgFu
 1FgelTqyTBMXDzgkDQdA5relkGcDmJsaWD5Pkqb7mw23NIypR6QVDJ9u/bHD7Ts/oj4uWMUKPx
 7gs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:58:18 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 3/5] libata: support concurrent positioning ranges log
Date:   Mon,  6 Sep 2021 10:58:08 +0900
Message-Id: <20210906015810.732799-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210906015810.732799-1-damien.lemoal@wdc.com>
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
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
---
 drivers/ata/libata-core.c | 57 +++++++++++++++++++++++++++++++++++++--
 drivers/ata/libata-scsi.c | 48 ++++++++++++++++++++++++++-------
 include/linux/ata.h       |  1 +
 include/linux/libata.h    | 15 +++++++++++
 4 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b8459c54f739..b083e5dae6f3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2433,18 +2433,70 @@ static void ata_dev_config_devslp(struct ata_device *dev)
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
@@ -2608,6 +2660,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_sense_reporting(dev);
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
+		ata_dev_config_cpr(dev);
 		dev->cdb_len = 32;
 
 		if (ata_msg_drv(ap) && print_info)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0b7b4624e4df..e1e97e62f716 100644
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
index 860e63f5667b..e3ab85964f94 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -675,6 +675,18 @@ struct ata_ering {
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
@@ -734,6 +746,9 @@ struct ata_device {
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

