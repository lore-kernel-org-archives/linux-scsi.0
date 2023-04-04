Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF00C6FD1D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbjDDShg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjDDSfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:35:44 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FFC5BAB;
        Tue,  4 Apr 2023 11:33:23 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g19so30406524lfr.9;
        Tue, 04 Apr 2023 11:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sez0JqSEJDZoQCI4cYFTIkIcFqtr16cDfE+vpO4F2qE=;
        b=JbQxlfUSd8nsM9jpuQvq4jFTy/2F8bvj1Rd23hqmL6jbI9AVPrduyz3kkhvHiHPf93
         P+RKA+vI7G3CYWxWjb48unIDfxlrgdPBew6YlT069vyAUs1iZPcEZ6kisZvhh5ptSv8L
         S6ANN37BhxXydoIRAR+kCg1j/aFPr4Dhj6pAQzPsIJlfEOYruS1Gz6k0uUZSQbB0HLcW
         nb+Ny2ZzfOY+ghofWBW/A1cMGtLyFHg7HAMzAxPtYIqOkzrppFWuqChyC4G5cE5KHQH1
         yZhomnYSk807e1azodnnAg95HpUhS/bVeC4vGyKZE0B2SLnaRIXb0ztihUexiXENWCoO
         OitA==
X-Gm-Message-State: AAQBX9dvJWTLNEsM69kRUMEp+sKtDBPMChmLPhYwiK0cDtPdYd0EcnUk
        VmXOKCe+7nkk0gOCRlWdHzx8+AKGAAw05g==
X-Google-Smtp-Source: AKy350YOerJ4ucoQ4B+y1WZEHiff7uMIscPHe8lQ4sz28tu3Iv+ajC7LeBqy19zEk50OurAYaJub9A==
X-Received: by 2002:ac2:5214:0:b0:4ea:2bc6:e3c5 with SMTP id a20-20020ac25214000000b004ea2bc6e3c5mr693041lfl.64.1680633201213;
        Tue, 04 Apr 2023 11:33:21 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id q27-20020ac2515b000000b004eb07f5cde6sm2428490lfd.297.2023.04.04.11.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:33:21 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 25377865; Tue,  4 Apr 2023 20:33:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633200; bh=oHNYZ7iMW9cAnHwRR28IKXGzailtc9klvKBLS2ZCCbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlFG2UYbUKu9B/613ZAmIYNoU7eOhdyh8ldLW91Neo9FGN9rFUf/w1c0OzY1oXkqZ
         tnZ6azfthzU5bLoFE3AysjRe1zdndIf8KTaJMWdcIsmPgsdNk+4w/MKZIdRpyUoiP+
         8JCpgSDOJGexUeIaNH6HT/51kyz1Qt5ZzPbbiTG0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id A16DA1111;
        Tue,  4 Apr 2023 20:25:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632752; bh=oHNYZ7iMW9cAnHwRR28IKXGzailtc9klvKBLS2ZCCbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlhEM1Ac4XmcyqH4lNRXeqVBZYDSnaQIX924IzDUKAbjh5Z/xtcP6zKdSf8mawN4P
         ZmhI+T+j7/8fncs3KXgBReruXFxYRO4f2hvxZz1d/BfKuoNcsxScTfOGvsL0yYMnHY
         cydN/978k715lHk2hWBJg8tzvnJk5aL0znJDJKJ0=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 14/19] ata: libata: detect support for command duration limits
Date:   Tue,  4 Apr 2023 20:24:19 +0200
Message-Id: <20230404182428.715140-15-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
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
index 14c17c3bda4e..78e53f4fa741 100644
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
2.39.2

