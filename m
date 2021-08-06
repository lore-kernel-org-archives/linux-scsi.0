Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD0FC43214
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00BB8601FD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbhHFLMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:23 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47134 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245327AbhHFLMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248319; x=1659784319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AW+WeAAVoWBZ5Xzke7ckGr0pia2nd7Z3obDvplpfqaM=;
  b=p5X4kxhYuLOhLYLGjj8rtWctkAfQL9NLPmHMzUz3UdvjR9KxQUTp234S
   FmxHRpSCPbaV9oXYW5bdkaQFcn8a8Wv1aB+YcsoQweRJDAkxHJUAAIHLD
   VOXNxe0IQ64KHqFxxjKXlKfbbXtfn8MHrzsVjR6NDkUo+/rnW9gSnWVbr
   EO2syQBIVYaAaxGWydA4eWfQnHuGv+Q7QZZzRkHjkOj9gRxY1BLROcL85
   9bYMKGRXoFFHA55EUbbZRgcGbJ4bGyaZ6J0s+GCA9zbK1Ekc/amB7u+j/
   9ZrkP8c7DK2spD5mGj5RWK/0XrBOp17PrecHC0nkBFAA/ffpd6FQGQ3dN
   A==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055560"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:11:59 +0800
IronPort-SDR: SE3Bu0f/Sbf+1Z192Ky+lUurC4K92qKHzAYluwxMN+rSU0vdNFRUp0+oJwEg6L6QmVrKQn2HGT
 Lv8XGHOcE+dGo+FaTwAQbq8ynhxnvCivrL0Ggtf/5kLYNgILXOS05kDoZEp2ewhmDZvDtDUW4e
 YBo6UF3T+QX0qMq4XggejO+AtdH7ZgEP5SdDklRq74HGaLh9WPhM9qKIuvEHunwatY1814cROy
 v8mXIBdJ/CaBQSBqSK91mdN7FRkMx88umuze0ENxXU4S22QGSEQAr0zpApSnHEVS24QPXE4jp+
 j6NNSx3m80rLCXazyXH083cY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:34 -0700
IronPort-SDR: 42pkL+znsmzjRO7FYmL90I20wu07z1dG0mXXS1Q2yAt/MlvUwXVA3qL9F6ihPZKOw1RPTnzBQG
 S9WnOcGH3sUYPDEkg35m4t28aCGr+Wzkf/ruYZdqSkO3VvhsfjyyRS6JC/7/KuMA9fKg3zcvdF
 1Q83wePpMhe3YLcUpkggMSmHO1NyjMfboli9UxBHXARjAVWYOLlYOBq8AiQ9IeNnbTdk3YSof/
 6R8n3eTdggGwXQochBP2w25EYepch/m7/H9/RQp5a+cdvICIErbYERd+RJ41610yUZoDOfcLlP
 rbw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:57 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 6/9] libata: fix ata_read_log_page() warning
Date:   Fri,  6 Aug 2021 20:11:42 +0900
Message-Id: <20210806111145.445697-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support for the READ LOG PAGE DMA EXT command is indicated by words 119
and 120 of a device identify data. This is tested in
ata_read_log_page() with ata_id_has_read_log_dma_ext() and the
READ LOG PAGE DMA command used if the device reports supports for it.

However, some devices lie about this support and using the DMA version
of the command fails, generating the warning message "READ LOG DMA EXT
failed, trying PIO". Since READ LOG PAGE DMA EXT is an optional command,
this warning is not at all important but may be scary for the user.
Change ata_read_log_page() to suppres this warning and to print an
error message if both DMA and PIO attempts failed.

With this change, there is no need to print again an error message when
ata_read_log_page() returns an error. So simplify the users of this
function.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 47 +++++++++++----------------------------
 1 file changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3e574e29ee37..e0ab03f59a8f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2026,13 +2026,15 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
 				     buf, sectors * ATA_SECT_SIZE, 0);
 
-	if (err_mask && dma) {
-		dev->horkage |= ATA_HORKAGE_NO_DMA_LOG;
-		ata_dev_warn(dev, "READ LOG DMA EXT failed, trying PIO\n");
-		goto retry;
+	if (err_mask) {
+		if (dma) {
+			dev->horkage |= ATA_HORKAGE_NO_DMA_LOG;
+			goto retry;
+		}
+		ata_dev_err(dev, "Read log page 0x%02x failed, Emask 0x%x\n",
+			    (unsigned int)page, err_mask);
 	}
 
-	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
 }
 
@@ -2061,12 +2063,8 @@ static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
 	 */
 	err = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE, 0, ap->sector_buf,
 				1);
-	if (err) {
-		ata_dev_info(dev,
-			     "failed to get Device Identify Log Emask 0x%x\n",
-			     err);
+	if (err)
 		return false;
-	}
 
 	for (i = 0; i < ap->sector_buf[8]; i++) {
 		if (ap->sector_buf[9 + i] == page)
@@ -2130,11 +2128,7 @@ static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
 	}
 	err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_SEND_RECV,
 				     0, ap->sector_buf, 1);
-	if (err_mask) {
-		ata_dev_dbg(dev,
-			    "failed to get NCQ Send/Recv Log Emask 0x%x\n",
-			    err_mask);
-	} else {
+	if (!err_mask) {
 		u8 *cmds = dev->ncq_send_recv_cmds;
 
 		dev->flags |= ATA_DFLAG_NCQ_SEND_RECV;
@@ -2160,11 +2154,7 @@ static void ata_dev_config_ncq_non_data(struct ata_device *dev)
 	}
 	err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_NON_DATA,
 				     0, ap->sector_buf, 1);
-	if (err_mask) {
-		ata_dev_dbg(dev,
-			    "failed to get NCQ Non-Data Log Emask 0x%x\n",
-			    err_mask);
-	} else {
+	if (!err_mask) {
 		u8 *cmds = dev->ncq_non_data_cmds;
 
 		memcpy(cmds, ap->sector_buf, ATA_LOG_NCQ_NON_DATA_SIZE);
@@ -2181,12 +2171,8 @@ static void ata_dev_config_ncq_prio(struct ata_device *dev)
 				     ATA_LOG_SATA_SETTINGS,
 				     ap->sector_buf,
 				     1);
-	if (err_mask) {
-		ata_dev_dbg(dev,
-			    "failed to get SATA settings log, Emask 0x%x\n",
-			    err_mask);
+	if (err_mask)
 		goto not_supported;
-	}
 
 	if (!(ap->sector_buf[ATA_LOG_NCQ_PRIO_OFFSET] & BIT(3)))
 		goto not_supported;
@@ -2347,11 +2333,8 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 
 	err = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE, ATA_LOG_SECURITY,
 			ap->sector_buf, 1);
-	if (err) {
-		ata_dev_dbg(dev,
-			    "failed to read Security Log, Emask 0x%x\n", err);
+	if (err)
 		return;
-	}
 
 	trusted_cap = get_unaligned_le64(&ap->sector_buf[40]);
 	if (!(trusted_cap & (1ULL << 63))) {
@@ -2440,12 +2423,8 @@ static void ata_dev_config_devslp(struct ata_device *dev)
 				     ATA_LOG_IDENTIFY_DEVICE,
 				     ATA_LOG_SATA_SETTINGS,
 				     sata_setting, 1);
-	if (err_mask) {
-		ata_dev_dbg(dev,
-			    "failed to get SATA Settings Log, Emask 0x%x\n",
-			    err_mask);
+	if (err_mask)
 		return;
-	}
 
 	dev->flags |= ATA_DFLAG_DEVSLP;
 	for (i = 0; i < ATA_LOG_DEVSLP_SIZE; i++) {
-- 
2.31.1

