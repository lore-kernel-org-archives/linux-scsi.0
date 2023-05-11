Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA5DC7EE26
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbjEKBZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbjEKBZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:25:08 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247C93C20;
        Wed, 10 May 2023 18:25:06 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f00d41df22so44298621e87.1;
        Wed, 10 May 2023 18:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768304; x=1686360304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOSE6cYqFg1YkRR4oOZHRgSU+isnAhSMv3cZlSpDkJM=;
        b=PLqEKYIwaNcsk4jyt7qVjU5miH2pZLZTCG1LHRsQjPiYfvsLevZ/hUvrAuFnuKgZ+q
         F5y389a6XBcA8vE4PQLF3AWUaJ0UOZjIF4PunjkY239rplZk9hlTTNo53/gh8U9xvgPW
         A+GVhLgYGW42w+Hw5YKiMjF591exOzqfoCy+X7XoTMyRg9VZF7pY+TtY3efj/w7EnsnB
         c+fG1juzhLu7QatAlW4UkPcR3tjyBXmweMHKYcb0B6OjaKcQ5L18skKppnEhTOPDXSTK
         MLtAQWpJbpZSyZ1ZBL+T0BbBcTqDG7+Shly52f4WnP0UPa0wKVkmVZvCUVAIYt6pvVh+
         MaSA==
X-Gm-Message-State: AC+VfDxxk7V3E+NM8abVFbdcCmfW1GqCPlLulwaJNG+0QYpI0/gSfk/p
        3iTCeUCVZ/LBb38VY+irGI9SZLH/xgJKJc87
X-Google-Smtp-Source: ACHHUZ7CU8xsXKxMDHiYasgKW2n3aVOnahxOLd7ob2vILd2MJZht2ElKu9KDpQUyyQ7zW67vAtjyTQ==
X-Received: by 2002:a05:6512:3053:b0:4ec:8cc6:55d9 with SMTP id b19-20020a056512305300b004ec8cc655d9mr2871848lfb.9.1683768304189;
        Wed, 10 May 2023 18:25:04 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id n11-20020a056512388b00b004efff420b0asm911746lft.108.2023.05.10.18.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:25:03 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 18A783C7; Thu, 11 May 2023 03:25:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768303; bh=XiPF15aHu5gPxQR75Ml1aFfyYFCV7mGoyzjuq4uMRpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJp2OUnEy3cawRv7nzw2D1JeTkPubvkEyFI+n0mPaJJu+hMbRM2g62+dvF6d/gj0A
         NP84IjtDD4ajomOe0fGzsVuhXYMSaEoiRN0r5mw+qDDGaDURPpESwlYQRvSr+G9dnp
         X6R/X/wYMfkrbjzO/5v2I8NU4+TayXrfAy3c1094=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 0FF407DA;
        Thu, 11 May 2023 03:15:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767737; bh=XiPF15aHu5gPxQR75Ml1aFfyYFCV7mGoyzjuq4uMRpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bM02N3/YTmAHrX+e3Xe6Zlbmv7JhT4Vwb5UDPp1XO4qWroL47ySMwzyiufl7echaN
         5SOM5n6igtJDD/nv+L9RQOP6KRuzMjyZnRHJdCdnrrXrzuK8UMQEHsNGoP+e4q/HP6
         vEZUhrzl7fgI6aP7gJxtpbrNCP1WHoPTSdniFVL0=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 16/19] ata: libata-scsi: add support for CDL pages mode sense
Date:   Thu, 11 May 2023 03:13:49 +0200
Message-Id: <20230511011356.227789-17-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

Modify ata_scsiop_mode_sense() and ata_msense_control() to support mode
sense access to the T2A and T2B sub-pages of the control mode page.
ata_msense_control() is modified to support sub-pages. The T2A sub-page
is generated using the read descriptors of the command duration limits
log page 18h. The T2B sub-page is generated using the write descriptors
of the same log page. With the addition of these sub-pages, getting all
sub-pages of the control mode page is also supported by increasing the
value of ATA_SCSI_RBUF_SIZE from 576B up to 2048B to ensure that all
sub-pages fit in the fill buffer.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-scsi.c | 150 ++++++++++++++++++++++++++++++++------
 1 file changed, 128 insertions(+), 22 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4245242664d9..4a4c6405d52e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -37,7 +37,7 @@
 #include "libata.h"
 #include "libata-transport.h"
 
-#define ATA_SCSI_RBUF_SIZE	576
+#define ATA_SCSI_RBUF_SIZE	2048
 
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
 static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
@@ -55,6 +55,9 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 #define CONTROL_MPAGE_LEN		12
 #define ALL_MPAGES			0x3f
 #define ALL_SUB_MPAGES			0xff
+#define CDL_T2A_SUB_MPAGE		0x07
+#define CDL_T2B_SUB_MPAGE		0x08
+#define CDL_T2_SUB_MPAGE_LEN		232
 
 static const u8 def_rw_recovery_mpage[RW_RECOVERY_MPAGE_LEN] = {
 	RW_RECOVERY_MPAGE,
@@ -2196,10 +2199,98 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 	return sizeof(def_cache_mpage);
 }
 
+/*
+ * Simulate MODE SENSE control mode page, sub-page 0.
+ */
+static unsigned int ata_msense_control_spg0(struct ata_device *dev, u8 *buf,
+					    bool changeable)
+{
+	modecpy(buf, def_control_mpage,
+		sizeof(def_control_mpage), changeable);
+	if (changeable) {
+		/* ata_mselect_control() */
+		buf[2] |= (1 << 2);
+	} else {
+		bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
+
+		/* descriptor format sense data */
+		buf[2] |= (d_sense << 2);
+	}
+
+	return sizeof(def_control_mpage);
+}
+
+/*
+ * Translate an ATA duration limit in microseconds to a SCSI duration limit
+ * using the t2cdlunits 0xa (10ms). Since the SCSI duration limits are 2-bytes
+ * only, take care of overflows.
+ */
+static inline u16 ata_xlat_cdl_limit(u8 *buf)
+{
+	u32 limit = get_unaligned_le32(buf);
+
+	return min_t(u32, limit / 10000, 65535);
+}
+
+/*
+ * Simulate MODE SENSE control mode page, sub-pages 07h and 08h
+ * (command duration limits T2A and T2B mode pages).
+ */
+static unsigned int ata_msense_control_spgt2(struct ata_device *dev, u8 *buf,
+					     u8 spg)
+{
+	u8 *b, *cdl = dev->cdl, *desc;
+	u32 policy;
+	int i;
+
+	/*
+	 * Fill the subpage. The first four bytes of the T2A/T2B mode pages
+	 * are a header. The PAGE LENGTH field is the size of the page
+	 * excluding the header.
+	 */
+	buf[0] = CONTROL_MPAGE;
+	buf[1] = spg;
+	put_unaligned_be16(CDL_T2_SUB_MPAGE_LEN - 4, &buf[2]);
+	if (spg == CDL_T2A_SUB_MPAGE) {
+		/*
+		 * Read descriptors map to the T2A page:
+		 * set perf_vs_duration_guidleine.
+		 */
+		buf[7] = (cdl[0] & 0x03) << 4;
+		desc = cdl + 64;
+	} else {
+		/* Write descriptors map to the T2B page */
+		desc = cdl + 288;
+	}
+
+	/* Fill the T2 page descriptors */
+	b = &buf[8];
+	policy = get_unaligned_le32(&cdl[0]);
+	for (i = 0; i < 7; i++, b += 32, desc += 32) {
+		/* t2cdlunits: fixed to 10ms */
+		b[0] = 0x0a;
+
+		/* Max inactive time and its policy */
+		put_unaligned_be16(ata_xlat_cdl_limit(&desc[8]), &b[2]);
+		b[6] = ((policy >> 8) & 0x0f) << 4;
+
+		/* Max active time and its policy */
+		put_unaligned_be16(ata_xlat_cdl_limit(&desc[4]), &b[4]);
+		b[6] |= (policy >> 4) & 0x0f;
+
+		/* Command duration guideline and its policy */
+		put_unaligned_be16(ata_xlat_cdl_limit(&desc[16]), &b[10]);
+		b[14] = policy & 0x0f;
+	}
+
+	return CDL_T2_SUB_MPAGE_LEN;
+}
+
 /**
  *	ata_msense_control - Simulate MODE SENSE control mode page
  *	@dev: ATA device of interest
  *	@buf: output buffer
+ *	@spg: sub-page code
  *	@changeable: whether changeable parameters are requested
  *
  *	Generate a generic MODE SENSE control mode page.
@@ -2208,17 +2299,24 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
  *	None.
  */
 static unsigned int ata_msense_control(struct ata_device *dev, u8 *buf,
-					bool changeable)
+				       u8 spg, bool changeable)
 {
-	modecpy(buf, def_control_mpage, sizeof(def_control_mpage), changeable);
-	if (changeable) {
-		buf[2] |= (1 << 2);	/* ata_mselect_control() */
-	} else {
-		bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
-
-		buf[2] |= (d_sense << 2);	/* descriptor format sense data */
+	unsigned int n;
+
+	switch (spg) {
+	case 0:
+		return ata_msense_control_spg0(dev, buf, changeable);
+	case CDL_T2A_SUB_MPAGE:
+	case CDL_T2B_SUB_MPAGE:
+		return ata_msense_control_spgt2(dev, buf, spg);
+	case ALL_SUB_MPAGES:
+		n = ata_msense_control_spg0(dev, buf, changeable);
+		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
+		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
+		return n;
+	default:
+		return 0;
 	}
-	return sizeof(def_control_mpage);
 }
 
 /**
@@ -2291,13 +2389,24 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 
 	pg = scsicmd[2] & 0x3f;
 	spg = scsicmd[3];
+
 	/*
-	 * No mode subpages supported (yet) but asking for _all_
-	 * subpages may be valid
+	 * Supported subpages: all subpages and sub-pages 07h and 08h of
+	 * the control page.
 	 */
-	if (spg && (spg != ALL_SUB_MPAGES)) {
-		fp = 3;
-		goto invalid_fld;
+	if (spg) {
+		switch (spg) {
+		case ALL_SUB_MPAGES:
+			break;
+		case CDL_T2A_SUB_MPAGE:
+		case CDL_T2B_SUB_MPAGE:
+			if (dev->flags & ATA_DFLAG_CDL && pg == CONTROL_MPAGE)
+				break;
+			fallthrough;
+		default:
+			fp = 3;
+			goto invalid_fld;
+		}
 	}
 
 	switch(pg) {
@@ -2310,13 +2419,13 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 		break;
 
 	case CONTROL_MPAGE:
-		p += ata_msense_control(args->dev, p, page_control == 1);
+		p += ata_msense_control(args->dev, p, spg, page_control == 1);
 		break;
 
 	case ALL_MPAGES:
 		p += ata_msense_rw_recovery(p, page_control == 1);
 		p += ata_msense_caching(args->id, p, page_control == 1);
-		p += ata_msense_control(args->dev, p, page_control == 1);
+		p += ata_msense_control(args->dev, p, spg, page_control == 1);
 		break;
 
 	default:		/* invalid page code */
@@ -2335,10 +2444,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 			memcpy(rbuf + 4, sat_blk_desc, sizeof(sat_blk_desc));
 		}
 	} else {
-		unsigned int output_len = p - rbuf - 2;
-
-		rbuf[0] = output_len >> 8;
-		rbuf[1] = output_len;
+		put_unaligned_be16(p - rbuf - 2, &rbuf[0]);
 		rbuf[3] |= dpofua;
 		if (ebd) {
 			rbuf[7] = sizeof(sat_blk_desc);
@@ -3637,7 +3743,7 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 	/*
 	 * Check that read-only bits are not modified.
 	 */
-	ata_msense_control(dev, mpage, false);
+	ata_msense_control_spg0(dev, mpage, false);
 	for (i = 0; i < CONTROL_MPAGE_LEN - 2; i++) {
 		if (i == 0)
 			continue;
-- 
2.40.1

