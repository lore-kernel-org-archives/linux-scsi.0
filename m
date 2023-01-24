Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEC5C25B50
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbjAXTFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbjAXTEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:04:10 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1B14F34A;
        Tue, 24 Jan 2023 11:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587040; x=1706123040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wrwtx3mr1Ry/N2tv/cKR0V38n6uOJgV5e5aDZynmUk4=;
  b=KAJ49CzXXB6rnhCaPvFPg2Ux4WM3Zi6ihju4ZgrqIDPMm/p4kEPeQlwM
   I9AeB3Fo+NALwCiClm1eFAK6v3Wkz1SfkccPLzYxBNLPvAhWoh5a94q/p
   SPsgk760Dp3PdL2UL8/pzTxktrnJyRyTDRMtywY3ea9319MKuIAmyOpgs
   V6TwGObzVDiiNuAxfRU+72I4koJeq5xR8IJydH639fXMyJD4yiLEQuDOE
   WiNF4EK8RyiWI+3P9B9iS81RCkGnzLTeOe8A2gIads401W67WMLoGXF6S
   dsQC2WoNVkhYwN1T+61n6lZiDTlr7By3JFW2Hj8U9xn/AzWOvSs9bRjlc
   g==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472978"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:59 +0800
IronPort-SDR: W4H0Lb+i0tNAm3vQBFRPaiu7mZhxmJq0MaZrLAkfiFdfWGBLBNeh8o60s/TQROd3qgKFK4/gNN
 0+3CEMlE2lcI80w5LKXUCkrH3QIqVEsl+BG6RgjzWPyWaoJ+PMLsMIhIx9Zuk8//1cG3WoC3tD
 Y2scL2HIz8hfm/MAELrneK+Hh3CockD24TglvnoDyHJ/hT4pXPMiC+7KR5WQ3J8S6UcwX7XLqR
 G5b+kwOWJ7qFr50cYiCf14NDVIKKad5Zsc4RR2qLjqDKEvikcxLDwC8z1xjDDQHpSv/8x76lSt
 Jlc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:48 -0800
IronPort-SDR: Jtc13l0aiaSNyyowGrm0lJy4As+5EhRg9qLUCBMBHvnDeWLehLJvHF2EM0hurkidAEtZ3pk8fM
 7LmkYk+6M9Zlp8wlPKe1dcH9lvj/Z8KB4vOrd9TWk/JaMVCatefpptFFX2sCvBFdLfSULh73wu
 GOXs56/az+9Ut6M9PQS9918cxl8YeYXF923gS+xcqaza4LzkaVPg2Ylt1u2hAnr+1mMdgDGvVd
 y4ZdVxTSbyxbnvPmlPjbMD2x5WTr+gbhUjdVjFd6zMHr6ggcbjZciz/q1N4w98cUjoP7BgwcfF
 UxI=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:58 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 14/18] ata: libata-scsi: add support for CDL pages mode sense
Date:   Tue, 24 Jan 2023 20:03:00 +0100
Message-Id: <20230124190308.127318-15-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Modify ata_scsiop_mode_sense() and ata_msense_control() to support mode
sense access to the T2A and T2B sub-pages of the control mode page.
ata_msense_control() is modified to support sub-pages. The T2A sub-page
is generated using the read descriptors of the command duration limits
log page 18h. The T2B sub-page is generated using the write descriptors
of the same log page. With the addition of these sub-pages, getting all
sub-pages of the control mode page is also supported by increasing the
value of ATA_SCSI_RBUF_SIZE from 576B up to 2048B to ensure that all
sub-pages fit in the fill buffer.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-scsi.c | 150 ++++++++++++++++++++++++++++++++------
 1 file changed, 128 insertions(+), 22 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2a0a04c9e658..9315a4c01276 100644
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
2.39.1

