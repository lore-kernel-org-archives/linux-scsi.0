Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAC3C67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjALOIw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjALOIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:08:16 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A9F2618;
        Thu, 12 Jan 2023 06:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532289; x=1705068289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+U3NQ21Wje+POXdlQhtP/jWLO/Mjz9z16b/YMISBe5E=;
  b=O6oHsyHCGhG+rMxWdtpwObSEBjaSjQxzQG4q1SHjAoHxUeevDNbeP7Cz
   tBC+6XnJ7DWi96JveQaL1DHHPJ6VIlLtPj3fIKAeZJV3XcbHhnxCj+rjK
   tr/txAccnFn0FdJWMkb/pKHDmQAnswZa7ZRRo0AGYbACUIk51pT7DQ8dS
   yid9Bhk5BBbtSoTmOVgzRIEtQ3nK88eFJ6eQXqJ7dm5NnJI2eujWGXzQI
   lVFArhENiMxTTqj4wcWAutcvyoGltrnzuTFPO29Bw6WsbDNVzfjp/6zD+
   nN4QcZXlcdmtSyVx+0QMRXVWwJ0R/lLO5zyrf0izz15MNkuwqboxdk2qa
   g==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632706"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:45 +0800
IronPort-SDR: 2ZyiSXPuq0CsIr/JoXHPvFq61y6P2szTjaBnJvVkYzxQYCThUzg5qT9jCE3UdiNrtY2e6nCLNr
 QBnKhIyz6xU2MG9mLJ/1gD2/i+N/0U1SqLOPxL6o3rfq5dCUO0AvEFD/wO6OnUZfx2K1EiMZQw
 k+2oLHEpqOivhWNokKvXCLJWk5za3q0QaF68VtF7oEnAwx29olINjK4cVUqSG85qpoK66ZfkyJ
 1NUaS4lcC6RuP5iHjzJlqSVIODmzvs6wkiRsxz3Uljl5d+4sQ7BfPiAGudQuoR5H8SAHdlfMNK
 Pq4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:48 -0800
IronPort-SDR: i8UEcD9aT7utC6B4xug7WhS0g248lmyTYShwdVEe/6ov2V3OvSRThz0kpPluOxTOVPcc+41Mta
 ejmSWt27hu82RRQrxwW4iA+m0OIIIbKouMBjVE01FE4bqN7VgjzxetbVlVsaHxDmS4QbVo5dmi
 VXmmPV3pMBzU3EmSJsihSPS75almgWYSqV1SvrpJwewwqwMI4jVUOLgOyAr6RjoKmZbcbp6TiY
 NsryAmEM/xlOJPHyNxUTG8602xfrwzsaTY+wwLtKW0PyYghqMzyw+a8mmNZU9DFjfParfs4NGt
 nnM=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:44 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 09/18] ata: libata: detect support for command duration limits
Date:   Thu, 12 Jan 2023 15:03:58 +0100
Message-Id: <20230112140412.667308-10-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
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
index 6d4ee296450e..c64bd3095ea6 100644
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
2.39.0

