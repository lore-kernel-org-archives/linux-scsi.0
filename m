Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6D8C63718
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiLHLDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiLHLDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:03:01 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E458A60B68;
        Thu,  8 Dec 2022 03:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497283; x=1702033283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mVpZtl2tFg3Ckd5fmjDsooFADqyv2MXcG51EfFVn4Gw=;
  b=BPmpaQq/ifZP+ee4Ny23HIBuHoAub+7G+rLp+o4TNH2q2DwV+hTQ26tW
   kNya5xM2CxtHXIMI0swuxJdnTRl2PYCgrdjKjLjKyks1O71C9rpKvl8w/
   rXEWqY7hCXd0JLSwAq2QB0uhoLPtM0gCNWY231fQuOUTmf/70uV1yGs6P
   f31EqwkrfoM4F6YJ3ynvBDPTYLbhnqa3fAoJVYgqw+y+qhoESQiTM2z9L
   L9+c1HXKSPwq3294cKoOqHp9g5kstNvc+gzhZwdwTbOTOeLBAEt3LUsZl
   y4iOu/615ssYb/PvRkqf/68UEG/WN+1lQ1f+MiUAikL48XazEyNHsUFXw
   g==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333406"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:21 +0800
IronPort-SDR: 0gjqIPQ4dXlP2OlfhqXmsP/xUstL15MpvsoQ6k2M/3d45yBo46cAZkfcAOzzPEcKQEtZqjUX9a
 LBpuhkfRvm7nV64s2uSXJ7x80eLlALNwqjPvp4ZdGzXnRC8YvpHeKh4VRvtOllRg2dz1bV5uGl
 8BxC+Uf2JDNHK9pRQzRQ3IqxpVMO4cMaPMwPt0N3aii7IqZ+T5m+G+onotVvm09SsPt1WZ37BN
 RSr9BoT948V54mqnZO6CD45qCKGg3Wlzr8wf/0EvcotXTazHShMfRG5JaUUPD8sMU9qY+k79FO
 B9Q=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:14:06 -0800
IronPort-SDR: uzGC6IonMacszw9EqOqzPuQBHfQnyeh0/tyvolQbsjn5TVv2JgzmstWyo5s6NI47/fXGJi3iUe
 HEbtAqXdg4Txee4LoMBc7N8rMaN1lS7gtuiXOjMeAbHgyLc41FYJS8k9r05jywuiyMg/bbGv5P
 dtQZrHbNKh7WJKZ6HMlOdn4xHRsiPDhb1BsC+Ev1/DZH4jUKdNLX09dy5Aon7AmyvG//pU2SkI
 MyQpNrlu2GKFrKH+h/JP5lzd/OTc5C5jq5B6TNmFAG2iQkI/BeLMxd6z8OrS5ceZ6ReQPrgAQH
 xqY=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:20 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 16/25] ata: libata: detect support for command duration limits
Date:   Thu,  8 Dec 2022 11:59:32 +0100
Message-Id: <20221208105947.2399894-17-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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

Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libata-core.c | 52 ++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c | 17 ++++++-------
 include/linux/ata.h       |  5 +++-
 include/linux/libata.h    |  6 ++++-
 4 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6b03bebcde50..d7a602a8f59e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2363,6 +2363,54 @@ static void ata_dev_config_trusted(struct ata_device *dev)
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
@@ -2508,12 +2556,13 @@ static void ata_dev_print_features(struct ata_device *dev)
 		return;
 
 	ata_dev_info(dev,
-		     "Features:%s%s%s%s%s%s\n",
+		     "Features:%s%s%s%s%s%s%s\n",
 		     dev->flags & ATA_DFLAG_TRUSTED ? " Trust" : "",
 		     dev->flags & ATA_DFLAG_DA ? " Dev-Attention" : "",
 		     dev->flags & ATA_DFLAG_DEVSLP ? " Dev-Sleep" : "",
 		     dev->flags & ATA_DFLAG_NCQ_SEND_RECV ? " NCQ-sndrcv" : "",
 		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "",
+		     dev->flags & ATA_DFLAG_CDL ? " CDL" : "",
 		     dev->cpr_log ? " CPR" : "");
 }
 
@@ -2674,6 +2723,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
 		ata_dev_config_cpr(dev);
+		ata_dev_config_cdl(dev);
 		dev->cdb_len = 32;
 
 		if (print_info)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 78729fd9fbfd..042c1748815a 100644
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
index 3b7f5d9e2f87..2bb8027ae148 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -90,6 +90,7 @@ enum {
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
 	ATA_DFLAG_TRUSTED	= (1 << 8), /* device supports trusted send/recv */
+	ATA_DFLAG_CDL		= (1 << 9), /* supports cmd duration limits */
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
 	ATA_DFLAG_NCQ_SEND_RECV = (1 << 11), /* device supports NCQ SEND and RECV */
 	ATA_DFLAG_NCQ_PRIO	= (1 << 12), /* device supports NCQ priority */
@@ -114,7 +115,7 @@ enum {
 
 	ATA_DFLAG_FEATURES_MASK	= ATA_DFLAG_TRUSTED | ATA_DFLAG_DA | \
 				  ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
-				  ATA_DFLAG_NCQ_PRIO,
+				  ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_CDL,
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -707,6 +708,9 @@ struct ata_device {
 	/* Concurrent positioning ranges */
 	struct ata_cpr_log	*cpr_log;
 
+	/* Command Duration Limits log support */
+	u8			cdl[ATA_LOG_CDL_SIZE];
+
 	/* error history */
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
-- 
2.38.1

