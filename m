Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304D3C7618D
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjDFLrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238842AbjDFLr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:47:29 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEA9E046;
        Thu,  6 Apr 2023 04:43:29 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id k37so50479483lfv.0;
        Thu, 06 Apr 2023 04:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sez0JqSEJDZoQCI4cYFTIkIcFqtr16cDfE+vpO4F2qE=;
        b=P4qhWEL6z6uCb+VTIzxKm+/WGnHGHE+80I5FxAHj5b3a+OD9RCAULUXzh1djwBULTo
         xh1ngLn1sK6rv7/NSS5s815KTkbW6n/fD8zfjA4/Ck/FEkzEq6PZV+bsReDZ/iMN0NUE
         rZKrffv9a8qM6UHpXwDvtld778VWymcauCM88ornSVndVY5IeS5UHqt8/G84au2aIOc2
         rMPB/zW5A8zejoBM4Uwv627kQ2PePwiNwrkoctvxDrj6Oo5wobeC1LRzHjDTN1ip1qZm
         LB9ofoqURgl+zk2kDnmwZDQTIQlJyMT/2SBN1+XTFbGkQ/XHNvn4UTFKrG8LGNSrDnX9
         f8FA==
X-Gm-Message-State: AAQBX9ciRNnPkNP0boAMIA7J5LEL2ydWT3CaRJyTei11phAxI4/i9Mn7
        Y5KV+TBQT4k9rn6s+7cAnivLjB49u94/Ag==
X-Google-Smtp-Source: AKy350Yqsa3Ciqr7Svgz1Zc4XlQUX6KE97DlxNagShM+YMU6F7pwM/8ZEfWjHs4eNwpy0Wjjb7t+Ug==
X-Received: by 2002:ac2:555e:0:b0:4eb:c18:efae with SMTP id l30-20020ac2555e000000b004eb0c18efaemr2178241lfk.17.1680781335882;
        Thu, 06 Apr 2023 04:42:15 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id m7-20020a056512014700b004eb2db994e7sm226863lfo.239.2023.04.06.04.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:42:15 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id A2B2867E; Thu,  6 Apr 2023 13:42:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781334; bh=oHNYZ7iMW9cAnHwRR28IKXGzailtc9klvKBLS2ZCCbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFIkqqsl+V7J0IsMv4R0OAkwK0ISheSnMPs8UCqSdbxoavaPnm5Ky7nstkj0LQgXu
         CT85yF81ef6ABi/0fBYLWPQjKxbF9tYIenBoeFkC9qzcigR4bEhgCqePWEyG5F2xUD
         dWSjWb4P1fAi2BXWT2oWrhhlWUwAHCFXyt323hIE=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 1F33FEC7;
        Thu,  6 Apr 2023 13:33:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780797; bh=oHNYZ7iMW9cAnHwRR28IKXGzailtc9klvKBLS2ZCCbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQYopmM68qHtx682jAO+Yrq43M+FAmgXSIgQtlZabYAVPdwKXzihOvF8M9akZ4mAp
         vLOO6vieUzD8ZP7+NKj7Pb/XRFDLRXuRMEzY5nS2SBIKJxsQLgJoHlMa2g081Zkjlt
         Kl4BFcvIrc/bL/wicii5MHYQixiW5TlS2E57WQCo=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 14/19] ata: libata: detect support for command duration limits
Date:   Thu,  6 Apr 2023 13:32:43 +0200
Message-Id: <20230406113252.41211-15-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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

