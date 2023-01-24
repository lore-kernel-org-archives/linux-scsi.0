Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB06C54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjAXTEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbjAXTD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:56 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196434F353;
        Tue, 24 Jan 2023 11:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587034; x=1706123034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QHK96wjbqenc7PSXWPwg1n4f0guPd2Q706gRZq0k2ro=;
  b=heG4a5CspzZM9tLSOv4yEoITkYGQn0m6yq2sXmeuYJIFESOS12zJgTWp
   Wro72UD6hte2wy9S3SRtpWdHnqAD0Uz40ubbR4YCQdkIF9Nw506VBNIWJ
   WYZbQI56kQY9cTHxj7cYeVKBA5OqonVVfjOEqwjuGYYpQrcPqe7ib1ra4
   RFfGkqpkstpWTXBDCtkMiVkqAn74PQ4Fb8Snlk+hqtQk6fa5TKMaDhz46
   Vvt5i0J1rHmDHC5C01HfbpwsUQzQcWnYuIdVobLRH2V88XgWhoH4SEP1O
   R/AQxh2ixn+sS7RvrU/6dtobmxEDC/tsV/ZMM9Yqn/G967zh1IaiN232L
   A==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472974"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:54 +0800
IronPort-SDR: ONfjVCYd08WIIt4GZ1552urlBDzpNBIS5IygNrhf01YNBX3hRZIyvPiSIpOccOngN4MBRjV93j
 O01RRb+XRm9W/4GmpYeuX8wT5BUda+AKQNEGyLoclAnfxSUVYqOLw1xHsrMRO4yJU0ETWh8QcE
 VjSOhkyOkaqZ+01xOCt/QfiUlh6zByrtKY6GNMoQ+JjFU9AQ3blHwFOgyhGyDkwAoL99fUvAQx
 /EZ4MFU0QJU+Yimy3coSU1Hx2hjEiRXivTXhTURZuapTnxos+6720GlQmeuUAzAVNTZX0IPfnl
 jO4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:43 -0800
IronPort-SDR: rGcTGNzEvwN6lyQPmsYpxPZ+8n27KOx/xNyMXwVJOtk+w6F9w0FI4zpyfFL+soYzsdFHVItanT
 MXMgMp2urP2FheAN8x+iME6wpj3sE6fGD4iE5gG5Txttp7fAA4l+DYkMgICDietguc2mxvJUAa
 WwKrspcJOA6uN4ddw7Ub9jRg8s3mDp8KNR8LhcRMH0aYZuQmxI/sCXxmDwc4/y5EpmsrFRWd4I
 0+0SHS1DNpaPvp/uUmrBcwoof6Zx9KwCUoamCd9qAQkaOm1JyW3r8hLvOWXLrOEZzi/eQvCFl+
 24c=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:52 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 12/18] ata: libata: detect support for command duration limits
Date:   Tue, 24 Jan 2023 20:02:58 +0100
Message-Id: <20230124190308.127318-13-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Use the supported capabilities identify device data log page to detect
if a device supports the command duration limits feature. For devices
supporting this feature, set the device flag ATA_DFLAG_CDL. To support
scsi-ata translation, retrieve the command duration limits log page 18h
and cache this page content using the cdl array added to the ata_device
data structure.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 52 ++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c | 17 ++++++-------
 include/linux/ata.h       |  5 +++-
 include/linux/libata.h    | 29 +++++++++++++---------
 4 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 36c1aca310e9..17e32b0a6364 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2367,6 +2367,54 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_TRUSTED;
 }
 
+static void ata_dev_config_cdl(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	unsigned int err_mask;
+	u64 val;
+
+	if (ata_id_major_version(dev->id) < 12)
+		goto not_supported;
+
+	if (!ata_log_supported(dev, ATA_LOG_IDENTIFY_DEVICE) ||
+	    !ata_identify_page_supported(dev, ATA_LOG_SUPPORTED_CAPABILITIES))
+		goto not_supported;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_SUPPORTED_CAPABILITIES,
+				     ap->sector_buf, 1);
+	if (err_mask)
+		goto not_supported;
+
+	/* Check Command Duration Limit Supported bits */
+	val = get_unaligned_le64(&ap->sector_buf[168]);
+	if (!(val & BIT_ULL(63)) || !(val & BIT_ULL(0)))
+		goto not_supported;
+
+	/* Warn the user if command duration guideline is not supported */
+	if (!(val & BIT_ULL(1)))
+		ata_dev_warn(dev,
+			"Command duration guideline is not supported\n");
+
+	/*
+	 * Command duration limits is supported: cache the CDL log page 18h
+	 * (command duration descriptors).
+	 */
+	err_mask = ata_read_log_page(dev, ATA_LOG_CDL, 0, ap->sector_buf, 1);
+	if (err_mask) {
+		ata_dev_warn(dev, "Read Command Duration Limits log failed\n");
+		goto not_supported;
+	}
+
+	memcpy(dev->cdl, ap->sector_buf, ATA_LOG_CDL_SIZE);
+	dev->flags |= ATA_DFLAG_CDL;
+
+	return;
+
+not_supported:
+	dev->flags &= ~ATA_DFLAG_CDL;
+}
+
 static int ata_dev_config_lba(struct ata_device *dev)
 {
 	const u16 *id = dev->id;
@@ -2534,13 +2582,14 @@ static void ata_dev_print_features(struct ata_device *dev)
 		return;
 
 	ata_dev_info(dev,
-		     "Features:%s%s%s%s%s%s%s\n",
+		     "Features:%s%s%s%s%s%s%s%s\n",
 		     dev->flags & ATA_DFLAG_FUA ? " FUA" : "",
 		     dev->flags & ATA_DFLAG_TRUSTED ? " Trust" : "",
 		     dev->flags & ATA_DFLAG_DA ? " Dev-Attention" : "",
 		     dev->flags & ATA_DFLAG_DEVSLP ? " Dev-Sleep" : "",
 		     dev->flags & ATA_DFLAG_NCQ_SEND_RECV ? " NCQ-sndrcv" : "",
 		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "",
+		     dev->flags & ATA_DFLAG_CDL ? " CDL" : "",
 		     dev->cpr_log ? " CPR" : "");
 }
 
@@ -2702,6 +2751,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
 		ata_dev_config_cpr(dev);
+		ata_dev_config_cdl(dev);
 		dev->cdb_len = 32;
 
 		if (print_info)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 26746609bf76..716c33af999c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -47,15 +47,14 @@ typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
 
-#define RW_RECOVERY_MPAGE 0x1
-#define RW_RECOVERY_MPAGE_LEN 12
-#define CACHE_MPAGE 0x8
-#define CACHE_MPAGE_LEN 20
-#define CONTROL_MPAGE 0xa
-#define CONTROL_MPAGE_LEN 12
-#define ALL_MPAGES 0x3f
-#define ALL_SUB_MPAGES 0xff
-
+#define RW_RECOVERY_MPAGE		0x1
+#define RW_RECOVERY_MPAGE_LEN		12
+#define CACHE_MPAGE			0x8
+#define CACHE_MPAGE_LEN			20
+#define CONTROL_MPAGE			0xa
+#define CONTROL_MPAGE_LEN		12
+#define ALL_MPAGES			0x3f
+#define ALL_SUB_MPAGES			0xff
 
 static const u8 def_rw_recovery_mpage[RW_RECOVERY_MPAGE_LEN] = {
 	RW_RECOVERY_MPAGE,
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 0c18499f60b6..b01e2cebe1fe 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -323,15 +323,18 @@ enum {
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_NCQ_NON_DATA	= 0x12,
 	ATA_LOG_NCQ_SEND_RECV	= 0x13,
+	ATA_LOG_CDL		= 0x18,
+	ATA_LOG_CDL_SIZE	= ATA_SECT_SIZE,
 	ATA_LOG_IDENTIFY_DEVICE	= 0x30,
 	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device log pages: */
+	ATA_LOG_SUPPORTED_CAPABILITIES	= 0x03,
 	ATA_LOG_SECURITY	  = 0x06,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
 
-	/* Identify device SATA settings log:*/
+	/* Identify device SATA settings log: */
 	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
 	ATA_LOG_DEVSLP_SIZE	  = 0x08,
 	ATA_LOG_DEVSLP_MDAT	  = 0x00,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a759dfbdcc91..2b17d6c99a37 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -94,17 +94,18 @@ enum {
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
 	ATA_DFLAG_NCQ_SEND_RECV = (1 << 11), /* device supports NCQ SEND and RECV */
 	ATA_DFLAG_NCQ_PRIO	= (1 << 12), /* device supports NCQ priority */
-	ATA_DFLAG_CFG_MASK	= (1 << 13) - 1,
-
-	ATA_DFLAG_PIO		= (1 << 13), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 14), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
-	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
-	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
-	ATA_DFLAG_UNLOCK_HPA	= (1 << 18), /* unlock HPA */
-	ATA_DFLAG_INIT_MASK	= (1 << 19) - 1,
-
-	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 19), /* Priority cmds sent to dev */
+	ATA_DFLAG_CDL		= (1 << 13), /* supports cmd duration limits */
+	ATA_DFLAG_CFG_MASK	= (1 << 14) - 1,
+
+	ATA_DFLAG_PIO		= (1 << 14), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 15), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SLEEPING	= (1 << 16), /* device is sleeping */
+	ATA_DFLAG_DUBIOUS_XFER	= (1 << 17), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1 << 18), /* device doesn't support unload */
+	ATA_DFLAG_UNLOCK_HPA	= (1 << 19), /* unlock HPA */
+	ATA_DFLAG_INIT_MASK	= (1 << 20) - 1,
+
+	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 20), /* Priority cmds sent to dev */
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
@@ -115,7 +116,8 @@ enum {
 
 	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
 				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
-				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA),
+				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
+				   ATA_DFLAG_CDL),
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -709,6 +711,9 @@ struct ata_device {
 	/* Concurrent positioning ranges */
 	struct ata_cpr_log	*cpr_log;
 
+	/* Command Duration Limits log support */
+	u8			cdl[ATA_LOG_CDL_SIZE];
+
 	/* error history */
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
-- 
2.39.1

