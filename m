Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE7FC77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjDFL70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbjDFL7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:59:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C71AAD32;
        Thu,  6 Apr 2023 04:56:18 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l15so730206ejq.10;
        Thu, 06 Apr 2023 04:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680782177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/OcewK0bDWFYeG3Wrabz2NQmGC8Mjcvzbl8fBeip338=;
        b=uTaEOh1myyQ2LD1scx1XyB4cqoZT1MdjBNXctTVnac2nCyz6ZIhuv3Yyt22FaKATS/
         lOpm2MMPZD65Nqk0Ja4J3YZpIa1Al5W9+3MWFSx7QxlZfb8Ib7loApdQmPjMJ6Gr6a+Q
         +0tD3wNdIs4M9GAQBP6RBsPiESwf8WoFX+Xr2uYeEQxNZTHafDNaDQTh/F2qTjMHPEUu
         pDLMUPt1HKRurw+qY8Rnj1MWUgjh9neS7md8cJhqlcsv1+7Fsl1C+Oz/eQe7Ko5HWQXl
         agKOQvwhH50dRq3BROrbxA66bEu+W2K8a9WmRsjR3pzq44f8KCpQf4F+ULY21B8lo9wZ
         MEIw==
X-Gm-Message-State: AAQBX9e6KoQA9OQgDkTbvwA4Fxyv1tD/ZcJcWfHmHScshlaFvP+O0BqR
        h4sUbAJewl5y3dNk398E7H98YjRSfU9UQQ==
X-Google-Smtp-Source: AKy350Y+y4sXc+mmGlUdaYrFihOOgublI9aqqDItHlZxCfbEHzKEJ9lWTMG1t22veWSnUtKlSIgr2A==
X-Received: by 2002:ac2:4951:0:b0:4eb:10b:a8ed with SMTP id o17-20020ac24951000000b004eb010ba8edmr2472184lfi.64.1680781140242;
        Thu, 06 Apr 2023 04:39:00 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id m19-20020ac24253000000b004db3eff4b12sm229426lfl.171.2023.04.06.04.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:39:00 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 228BC666; Thu,  6 Apr 2023 13:38:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781139; bh=6zjGJ1IXngNznUcYME6kpKq2kcXvA4nnQijvYZySgxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5Tv5VWB4gvrYRw099tx6iqZURiefI3+O/+LSt1oZHwcis9r53ONszlCBmIMQ5x8E
         bovCHTclpNDKZF/Qkk0wy5I+bCG99XYV/fALngSo7No2KNM7v3ZiI7wmvtPQVu1ht7
         Bnwave+LsubaUSEYhf5sIPmCauil42wXid2iSX98=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 39737957;
        Thu,  6 Apr 2023 13:33:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780792; bh=6zjGJ1IXngNznUcYME6kpKq2kcXvA4nnQijvYZySgxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzQSWxGTZjR1K2tLP+CNDEdH0IoW+0xFrBzjAr7PZCQM9LrGArfyhgSNwXBpdmBcy
         YTtUGP2CIrfrn08adg5EYfOcye6WTdmqc17HPC0BY/93uzEV5aT9lTx2R7DS8oy9Dd
         FIx0dNFOVjgUsZXj6uHPqkBVKCF5m6j8YLJCLe3M=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 08/19] scsi: detect support for command duration limits
Date:   Thu,  6 Apr 2023 13:32:37 +0200
Message-Id: <20230406113252.41211-9-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the function scsi_cdl_check() to detect if a device supports
command duration limits (CDL). Support for the READ 16, WRITE 16,
READ 32 and WRITE 32 commands are checked using the function
scsi_report_opcode() to probe the rwcdlp and cdlp bits as they indicate
the mode page defining the command duration limits descriptors that
apply to the command being tested.

If any of these commands support CDL, the field cdl_supported of
struct scsi_device is set to 1 to indicate that the device supports CDL.

Support for CDL for a device is advertizes through sysfs using the new
cdl_supported device attribute. This attribute value is 1 for a device
supporting CDL and 0 otherwise.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/ABI/testing/sysfs-block-device |  9 +++
 drivers/scsi/scsi.c                          | 81 ++++++++++++++++++++
 drivers/scsi/scsi_scan.c                     |  3 +
 drivers/scsi/scsi_sysfs.c                    |  2 +
 include/scsi/scsi_device.h                   |  3 +
 5 files changed, 98 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
index 7ac7b19b2f72..ee3610a25845 100644
--- a/Documentation/ABI/testing/sysfs-block-device
+++ b/Documentation/ABI/testing/sysfs-block-device
@@ -95,3 +95,12 @@ Description:
 		This file does not exist if the HBA driver does not implement
 		support for the SATA NCQ priority feature, regardless of the
 		device support for this feature.
+
+
+What:		/sys/block/*/device/cdl_supported
+Date:		Mar, 2023
+KernelVersion:	v6.4
+Contact:	linux-scsi@vger.kernel.org
+Description:
+		(RO) Indicates if the device supports the command duration
+		limits feature found in some ATA and SCSI devices.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 62d9472e08e9..c03814ce23ca 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -570,6 +570,87 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 }
 EXPORT_SYMBOL(scsi_report_opcode);
 
+#define SCSI_CDL_CHECK_BUF_LEN	64
+
+static bool scsi_cdl_check_cmd(struct scsi_device *sdev, u8 opcode, u16 sa,
+			       unsigned char *buf)
+{
+	int ret;
+	u8 cdlp;
+
+	/* Check operation code */
+	ret = scsi_report_opcode(sdev, buf, SCSI_CDL_CHECK_BUF_LEN, opcode, sa);
+	if (ret <= 0)
+		return false;
+
+	if ((buf[1] & 0x03) != 0x03)
+		return false;
+
+	/* See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES */
+	cdlp = (buf[1] & 0x18) >> 3;
+	if (buf[0] & 0x01) {
+		/* rwcdlp == 1 */
+		switch (cdlp) {
+		case 0x01:
+			/* T2A page */
+			return true;
+		case 0x02:
+			/* T2B page */
+			return true;
+		}
+	} else {
+		/* rwcdlp == 0 */
+		switch (cdlp) {
+		case 0x01:
+			/* A page */
+			return true;
+		case 0x02:
+			/* B page */
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * scsi_cdl_check - Check if a SCSI device supports Command Duration Limits
+ * @sdev: The device to check
+ */
+void scsi_cdl_check(struct scsi_device *sdev)
+{
+	bool cdl_supported;
+	unsigned char *buf;
+
+	buf = kmalloc(SCSI_CDL_CHECK_BUF_LEN, GFP_KERNEL);
+	if (!buf) {
+		sdev->cdl_supported = 0;
+		return;
+	}
+
+	/* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
+	cdl_supported =
+		scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
+		scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
+		scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
+		scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
+	if (cdl_supported) {
+		/*
+		 * We have CDL support: force the use of READ16/WRITE16.
+		 * READ32 and WRITE32 will be used for devices that support
+		 * the T10_PI_TYPE2_PROTECTION protection type.
+		 */
+		sdev->use_16_for_rw = 1;
+		sdev->use_10_for_rw = 0;
+
+		sdev->cdl_supported = 1;
+	} else {
+		sdev->cdl_supported = 0;
+	}
+
+	kfree(buf);
+}
+
 /**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d217be323cc6..aa13feb17c62 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1087,6 +1087,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (sdev->scsi_level >= SCSI_3)
 		scsi_attach_vpd(sdev);
 
+	scsi_cdl_check(sdev);
+
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 	sdev->sdev_bflags = *bflags;
@@ -1624,6 +1626,7 @@ void scsi_rescan_device(struct device *dev)
 	device_lock(dev);
 
 	scsi_attach_vpd(sdev);
+	scsi_cdl_check(sdev);
 
 	if (sdev->handler && sdev->handler->rescan)
 		sdev->handler->rescan(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ee28f73af4d4..4994148e685b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -670,6 +670,7 @@ sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr (cdl_supported, "%d\n");
 
 static ssize_t
 sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
@@ -1300,6 +1301,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_preferred_path.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
+	&dev_attr_cdl_supported.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
 	REF_EVT(capacity_change_reported),
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c93c5aaf637e..6b8df9e253a0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -218,6 +218,8 @@ struct scsi_device {
 	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
 	unsigned no_vpd_size:1;		/* No VPD size reported in header */
 
+	unsigned cdl_supported:1;	/* Command duration limits supported */
+
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
 
@@ -364,6 +366,7 @@ extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
+void scsi_cdl_check(struct scsi_device *sdev);
 
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
-- 
2.39.2

