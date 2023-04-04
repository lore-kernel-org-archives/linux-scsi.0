Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD3BC77B6E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbjDDSiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbjDDShe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:37:34 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560594EFC;
        Tue,  4 Apr 2023 11:36:21 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id q14so34886273ljm.11;
        Tue, 04 Apr 2023 11:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sXque4FQIR07CqaRh47mjfT3BshsIL2ZmUjnfpt9gSU=;
        b=roY44PPHBLuXLl10V/6bEpoPbhLTTPfadAw7XBSzJlwgXNEitG2SaN71WVUrh5wvO+
         0dN8Y7jEKn4xbnhD71MutpMGsNprqRfvYlNeRQBJTAhAnIqnpENrfW6uvOkc2fVe4SVW
         yV9twAZg8BSJ1zpX9BetnBbXhG3CF/gxMsJpEeay/emfy1fqOcslTzVkFtxTzi/XnShi
         KI51lVYTqNsIwtRUVUCpqbJmiX5Xu6loinmpu3NspHqU6X3BZurRHU0ErNNS52tINA7X
         bCz7To6xPf3XmhdQSJ3PQrvmLQ4yXsi42AnJY2Si48m1ZjV6qwJKXrp63UxEjA2gYAbb
         tK5Q==
X-Gm-Message-State: AAQBX9cLXiP9lTUkapwecpsk5TFJOrmSDmRr0iQJKYNg3cxr31wcuuxJ
        xhqF7SxCP/UD9901bOKMiTT7SdecFd7Puw==
X-Google-Smtp-Source: AKy350bLeSZGq3moVR4LrSsEzlj0jaMBZaRiWn7a5RGU2JTl7qCe8vCXjvk6Z6A0vLQKcPGjhis6KQ==
X-Received: by 2002:a2e:9d15:0:b0:28e:da11:6191 with SMTP id t21-20020a2e9d15000000b0028eda116191mr992955lji.22.1680633379505;
        Tue, 04 Apr 2023 11:36:19 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id r10-20020a2e80ca000000b00295b2e08b90sm2392758ljg.65.2023.04.04.11.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:36:19 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 605DA895; Tue,  4 Apr 2023 20:36:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633378; bh=b3t9TDGDVd6dul8YsZ3WiIeS5vzUCYXD0uOdsIM+ZyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mF5Yxgj3MriTSke6bANNfetY2KVleBdPIkUdUBywbzy6GjgkLZxNbddZx802wHTBb
         asTVECYADfBjY7zq0sxQI65nVEgaLLLYAh4ynn9HmRDfmA1yln8+goFMuLTyFVDN/j
         XqSyHNoY5BUN3X9K+XuJUU1CH/1M5i9GkGWU1F3o=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id C048911C0;
        Tue,  4 Apr 2023 20:25:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632756; bh=b3t9TDGDVd6dul8YsZ3WiIeS5vzUCYXD0uOdsIM+ZyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hP2nK/axmdyMFQiRt+AFAlLK7CG9nHLCW+dDHETsWtlrwBeSx7/NnpJLko6AF6xR7
         jpSCefj6woPVOK2vx4IoMorMqeneJ1oyqwE6bxyrRvwDrXGS5ak2dQuU79TFgFMmfM
         aqer0NcPKy369MWSA6cA2E/8ehTMd2HMMzkCDJGY=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 17/19] ata: libata: add ATA feature control sub-page translation
Date:   Tue,  4 Apr 2023 20:24:22 +0200
Message-Id: <20230404182428.715140-18-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Add support for the ATA feature control sub-page of the control mode
page to enable/disable the command duration limits feature using the
cdl_ctrl field of the ATA feature control sub-page.

Both mode sense and mode select translation are supported. For mode
sense, the ata device flag ATA_DFLAG_CDL_ENABLED is used to cache the
status of the command duration limits feature. Enabling this feature is
done using a SET FEATURES command with a cdl action set to 1 when the
page cdl_ctrl field value is 0x2 (T2A and T2B pages supported). If this
field is 0, CDL is disabled using the SET FEATURES command with a cdl
action set to 0.

Since a device CDL and NCQ priority features should not be used
simultaneously, ata_mselect_control_ata_feature() returns an error when
attempting to enable CDL with the device priority feature enabled.
Conversely, the function ata_ncq_prio_enable_store() used to enable the
use of the device NCQ priority feature through sysfs is modified to
return an error if the device CDL feature is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c |  40 ++++++++-
 drivers/ata/libata-sata.c |  11 ++-
 drivers/ata/libata-scsi.c | 167 ++++++++++++++++++++++++++++++++------
 include/linux/ata.h       |   3 +
 include/linux/libata.h    |   1 +
 5 files changed, 193 insertions(+), 29 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 78e53f4fa741..62e100fa90e2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2371,13 +2371,15 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
+	bool cdl_enabled;
 	u64 val;
 
 	if (ata_id_major_version(dev->id) < 12)
 		goto not_supported;
 
 	if (!ata_log_supported(dev, ATA_LOG_IDENTIFY_DEVICE) ||
-	    !ata_identify_page_supported(dev, ATA_LOG_SUPPORTED_CAPABILITIES))
+	    !ata_identify_page_supported(dev, ATA_LOG_SUPPORTED_CAPABILITIES) ||
+	    !ata_identify_page_supported(dev, ATA_LOG_CURRENT_SETTINGS))
 		goto not_supported;
 
 	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
@@ -2396,6 +2398,40 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 		ata_dev_warn(dev,
 			"Command duration guideline is not supported\n");
 
+	/*
+	 * If CDL is marked as enabled, make sure the feature is enabled too.
+	 * Conversely, if CDL is disabled, make sure the feature is turned off.
+	 */
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_CURRENT_SETTINGS,
+				     ap->sector_buf, 1);
+	if (err_mask)
+		goto not_supported;
+
+	val = get_unaligned_le64(&ap->sector_buf[8]);
+	cdl_enabled = val & BIT_ULL(63) && val & BIT_ULL(21);
+	if (dev->flags & ATA_DFLAG_CDL_ENABLED) {
+		if (!cdl_enabled) {
+			/* Enable CDL on the device */
+			err_mask = ata_dev_set_feature(dev, SETFEATURES_CDL, 1);
+			if (err_mask) {
+				ata_dev_err(dev,
+					    "Enable CDL feature failed\n");
+				goto not_supported;
+			}
+		}
+	} else {
+		if (cdl_enabled) {
+			/* Disable CDL on the device */
+			err_mask = ata_dev_set_feature(dev, SETFEATURES_CDL, 0);
+			if (err_mask) {
+				ata_dev_err(dev,
+					    "Disable CDL feature failed\n");
+				goto not_supported;
+			}
+		}
+	}
+
 	/*
 	 * Command duration limits is supported: cache the CDL log page 18h
 	 * (command duration descriptors).
@@ -2412,7 +2448,7 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 	return;
 
 not_supported:
-	dev->flags &= ~ATA_DFLAG_CDL;
+	dev->flags &= ~(ATA_DFLAG_CDL | ATA_DFLAG_CDL_ENABLED);
 }
 
 static int ata_dev_config_lba(struct ata_device *dev)
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index f3e7396e3191..57cb33060c9d 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -907,10 +907,17 @@ static ssize_t ata_ncq_prio_enable_store(struct device *device,
 		goto unlock;
 	}
 
-	if (input)
+	if (input) {
+		if (dev->flags & ATA_DFLAG_CDL_ENABLED) {
+			ata_dev_err(dev,
+				"CDL must be disabled to enable NCQ priority\n");
+			rc = -EINVAL;
+			goto unlock;
+		}
 		dev->flags |= ATA_DFLAG_NCQ_PRIO_ENABLED;
-	else
+	} else {
 		dev->flags &= ~ATA_DFLAG_NCQ_PRIO_ENABLED;
+	}
 
 unlock:
 	spin_unlock_irq(ap->lock);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9315a4c01276..8dde1cede5ca 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -58,6 +58,8 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 #define CDL_T2A_SUB_MPAGE		0x07
 #define CDL_T2B_SUB_MPAGE		0x08
 #define CDL_T2_SUB_MPAGE_LEN		232
+#define ATA_FEATURE_SUB_MPAGE		0xf2
+#define ATA_FEATURE_SUB_MPAGE_LEN	16
 
 static const u8 def_rw_recovery_mpage[RW_RECOVERY_MPAGE_LEN] = {
 	RW_RECOVERY_MPAGE,
@@ -2286,6 +2288,31 @@ static unsigned int ata_msense_control_spgt2(struct ata_device *dev, u8 *buf,
 	return CDL_T2_SUB_MPAGE_LEN;
 }
 
+/*
+ * Simulate MODE SENSE control mode page, sub-page f2h
+ * (ATA feature control mode page).
+ */
+static unsigned int ata_msense_control_ata_feature(struct ata_device *dev,
+						   u8 *buf)
+{
+	/* PS=0, SPF=1 */
+	buf[0] = CONTROL_MPAGE | (1 << 6);
+	buf[1] = ATA_FEATURE_SUB_MPAGE;
+
+	/*
+	 * The first four bytes of ATA Feature Control mode page are a header.
+	 * The PAGE LENGTH field is the size of the page excluding the header.
+	 */
+	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
+
+	if (dev->flags & ATA_DFLAG_CDL)
+		buf[4] = 0x02; /* Support T2A and T2B pages */
+	else
+		buf[4] = 0;
+
+	return ATA_FEATURE_SUB_MPAGE_LEN;
+}
+
 /**
  *	ata_msense_control - Simulate MODE SENSE control mode page
  *	@dev: ATA device of interest
@@ -2309,10 +2336,13 @@ static unsigned int ata_msense_control(struct ata_device *dev, u8 *buf,
 	case CDL_T2A_SUB_MPAGE:
 	case CDL_T2B_SUB_MPAGE:
 		return ata_msense_control_spgt2(dev, buf, spg);
+	case ATA_FEATURE_SUB_MPAGE:
+		return ata_msense_control_ata_feature(dev, buf);
 	case ALL_SUB_MPAGES:
 		n = ata_msense_control_spg0(dev, buf, changeable);
 		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
 		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
+		n += ata_msense_control_ata_feature(dev, buf + n);
 		return n;
 	default:
 		return 0;
@@ -2391,7 +2421,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	spg = scsicmd[3];
 
 	/*
-	 * Supported subpages: all subpages and sub-pages 07h and 08h of
+	 * Supported subpages: all subpages and sub-pages 07h, 08h and f2h of
 	 * the control page.
 	 */
 	if (spg) {
@@ -2400,6 +2430,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 			break;
 		case CDL_T2A_SUB_MPAGE:
 		case CDL_T2B_SUB_MPAGE:
+		case ATA_FEATURE_SUB_MPAGE:
 			if (dev->flags & ATA_DFLAG_CDL && pg == CONTROL_MPAGE)
 				break;
 			fallthrough;
@@ -3708,20 +3739,11 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 	return 0;
 }
 
-/**
- *	ata_mselect_control - Simulate MODE SELECT for control page
- *	@qc: Storage for translated ATA taskfile
- *	@buf: input buffer
- *	@len: number of valid bytes in the input buffer
- *	@fp: out parameter for the failed field on error
- *
- *	Prepare a taskfile to modify caching information for the device.
- *
- *	LOCKING:
- *	None.
+/*
+ * Simulate MODE SELECT control mode page, sub-page 0.
  */
-static int ata_mselect_control(struct ata_queued_cmd *qc,
-			       const u8 *buf, int len, u16 *fp)
+static int ata_mselect_control_spg0(struct ata_queued_cmd *qc,
+				    const u8 *buf, int len, u16 *fp)
 {
 	struct ata_device *dev = qc->dev;
 	u8 mpage[CONTROL_MPAGE_LEN];
@@ -3759,6 +3781,83 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 	return 0;
 }
 
+/*
+ * Translate MODE SELECT control mode page, sub-pages f2h (ATA feature mode
+ * page) into a SET FEATURES command.
+ */
+static unsigned int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
+						    const u8 *buf, int len,
+						    u16 *fp)
+{
+	struct ata_device *dev = qc->dev;
+	struct ata_taskfile *tf = &qc->tf;
+	u8 cdl_action;
+
+	/*
+	 * The first four bytes of ATA Feature Control mode page are a header,
+	 * so offsets in mpage are off by 4 compared to buf.  Same for len.
+	 */
+	if (len != ATA_FEATURE_SUB_MPAGE_LEN - 4) {
+		*fp = min(len, ATA_FEATURE_SUB_MPAGE_LEN - 4);
+		return -EINVAL;
+	}
+
+	/* Check cdl_ctrl */
+	switch (buf[0] & 0x03) {
+	case 0:
+		/* Disable CDL */
+		cdl_action = 0;
+		dev->flags &= ~ATA_DFLAG_CDL_ENABLED;
+		break;
+	case 0x02:
+		/* Enable CDL T2A/T2B: NCQ priority must be disabled */
+		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
+			ata_dev_err(dev,
+				"NCQ priority must be disabled to enable CDL\n");
+			return -EINVAL;
+		}
+		cdl_action = 1;
+		dev->flags |= ATA_DFLAG_CDL_ENABLED;
+		break;
+	default:
+		*fp = 0;
+		return -EINVAL;
+	}
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_SET_FEATURES;
+	tf->feature = SETFEATURES_CDL;
+	tf->nsect = cdl_action;
+
+	return 1;
+}
+
+/**
+ *	ata_mselect_control - Simulate MODE SELECT for control page
+ *	@qc: Storage for translated ATA taskfile
+ *	@buf: input buffer
+ *	@len: number of valid bytes in the input buffer
+ *	@fp: out parameter for the failed field on error
+ *
+ *	Prepare a taskfile to modify caching information for the device.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static int ata_mselect_control(struct ata_queued_cmd *qc, u8 spg,
+			       const u8 *buf, int len, u16 *fp)
+{
+	switch (spg) {
+	case 0:
+		return ata_mselect_control_spg0(qc, buf, len, fp);
+	case ATA_FEATURE_SUB_MPAGE:
+		return ata_mselect_control_ata_feature(qc, buf, len, fp);
+	default:
+		return -EINVAL;
+	}
+}
+
 /**
  *	ata_scsi_mode_select_xlat - Simulate MODE SELECT 6, 10 commands
  *	@qc: Storage for translated ATA taskfile
@@ -3776,7 +3875,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	const u8 *cdb = scmd->cmnd;
 	u8 pg, spg;
 	unsigned six_byte, pg_len, hdr_len, bd_len;
-	int len;
+	int len, ret;
 	u16 fp = (u16)-1;
 	u8 bp = 0xff;
 	u8 buffer[64];
@@ -3861,13 +3960,29 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	}
 
 	/*
-	 * No mode subpages supported (yet) but asking for _all_
-	 * subpages may be valid
+	 * Supported subpages: all subpages and ATA feature sub-page f2h of
+	 * the control page.
 	 */
-	if (spg && (spg != ALL_SUB_MPAGES)) {
-		fp = (p[0] & 0x40) ? 1 : 0;
-		fp += hdr_len + bd_len;
-		goto invalid_param;
+	if (spg) {
+		switch (spg) {
+		case ALL_SUB_MPAGES:
+			/* All subpages is not supported for the control page */
+			if (pg == CONTROL_MPAGE) {
+				fp = (p[0] & 0x40) ? 1 : 0;
+				fp += hdr_len + bd_len;
+				goto invalid_param;
+			}
+			break;
+		case ATA_FEATURE_SUB_MPAGE:
+			if (qc->dev->flags & ATA_DFLAG_CDL &&
+			    pg == CONTROL_MPAGE)
+				break;
+			fallthrough;
+		default:
+			fp = (p[0] & 0x40) ? 1 : 0;
+			fp += hdr_len + bd_len;
+			goto invalid_param;
+		}
 	}
 	if (pg_len > len)
 		goto invalid_param_len;
@@ -3880,14 +3995,16 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		}
 		break;
 	case CONTROL_MPAGE:
-		if (ata_mselect_control(qc, p, pg_len, &fp) < 0) {
+		ret = ata_mselect_control(qc, spg, p, pg_len, &fp);
+		if (ret < 0) {
 			fp += hdr_len + bd_len;
 			goto invalid_param;
-		} else {
-			goto skip; /* No ATA command to send */
 		}
+		if (!ret)
+			goto skip; /* No ATA command to send */
 		break;
-	default:		/* invalid page code */
+	default:
+		/* Invalid page code */
 		fp = bd_len + hdr_len;
 		goto invalid_param;
 	}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index b01e2cebe1fe..a59b17d6ad11 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -330,6 +330,7 @@ enum {
 
 	/* Identify device log pages: */
 	ATA_LOG_SUPPORTED_CAPABILITIES	= 0x03,
+	ATA_LOG_CURRENT_SETTINGS  = 0x04,
 	ATA_LOG_SECURITY	  = 0x06,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
@@ -419,6 +420,8 @@ enum {
 	SETFEATURES_SATA_ENABLE = 0x10, /* Enable use of SATA feature */
 	SETFEATURES_SATA_DISABLE = 0x90, /* Disable use of SATA feature */
 
+	SETFEATURES_CDL		= 0x0d, /* Enable/disable cmd duration limits */
+
 	/* SETFEATURE Sector counts for SATA features */
 	SATA_FPDMA_OFFSET	= 0x01,	/* FPDMA non-zero buffer offsets */
 	SATA_FPDMA_AA		= 0x02, /* FPDMA Setup FIS Auto-Activate */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2b17d6c99a37..d7fe735e6322 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -106,6 +106,7 @@ enum {
 	ATA_DFLAG_INIT_MASK	= (1 << 20) - 1,
 
 	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 20), /* Priority cmds sent to dev */
+	ATA_DFLAG_CDL_ENABLED	= (1 << 21), /* cmd duration limits is enabled */
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
-- 
2.39.2

