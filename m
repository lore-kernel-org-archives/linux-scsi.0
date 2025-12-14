Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21541448D5
	for <linux-scsi@vger.kernel.org>; Sun, 14 Dec 2025 08:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765700129; cv=none; b=o3LG1IR1dDIDe/VzYx92OVW8F5CxUvG0zUoJtKpWGcjCDe4RBMJFEbSjnLQKuEIT0onkFGBrjo3k/uTnalIvFoTXWQv7U/oaLM9wS3Ri0m5HTD/oHBeu7hiZPwFxh5HlMm3TxtlZZkOhP7gqGRvvX9DGeIhaRFi8ujY6UAJOen4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765700129; c=relaxed/simple;
	bh=Ga/ZJy85S+Kz6UoPu2oJOAgezpIKZSLLqS8f8WgKlSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5LC4rKdQ1ikbPgRz3Qxhy0oDjRyc8V3wGZ1+h0wVToodAxnYrHq5mmeeZ+4uY9IPMqhaIzYfnUrzYTLU4FfUdVoKGGCosIYqWcgLk0zhrsA7iq5KKxDDBESHsQqHch8rW/HbCMIKTs5ZqwBdpMZca7bwrCt5ZsUjZI42R6DCno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtF7qMKK; arc=none smtp.client-ip=74.125.82.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtF7qMKK"
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-11b6bc976d6so3136743c88.0
        for <linux-scsi@vger.kernel.org>; Sun, 14 Dec 2025 00:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765700127; x=1766304927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jk8B1lzXwlpNuG7vz/ZfeXroaLuX/7f2+BUjmvhmzVI=;
        b=BtF7qMKKq7c84gSx2894oFgmiHAv/4tSYBgHEHuJ8dqHwFiE+8DPiHEn+Xa4nX0CqQ
         LGgDGJIqFFRazP9YrrTVwE9tzQV5PRf1/jLZmg73xDzvgnuAa59NuPG9nSJQzCd31gpW
         OkIqJcIV2dGKIABKAN2HNdsrBI3TgUdeDwmEMewjY5e5M7jgrqMTUj7WxZne4rHVDnpa
         +jvoq5cT7uwn6bldHsjDQCRFcwrox80uaPUkCTQbh9nt15TpbeSRu3tuXMKRVw4o+ECP
         pxbhC/aaMsVro15wNcEYo7bGpDFAH162hN2t8DIn+lAUz/VcPCcRCCjvOcbWH4gZ7bsS
         mKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765700127; x=1766304927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jk8B1lzXwlpNuG7vz/ZfeXroaLuX/7f2+BUjmvhmzVI=;
        b=G0SeZTH2yO1uMBDNZKY8WlMHwaEihBYM6GNtupODWKwp6BTVkoTQ1XGDkKBmxPbk2k
         DfGpNHOYnPH7rRLRsmJiA5fcsbA3mx6x784mtkt8O3tlV/MMu1/tM2lpovVlNTjBX5eC
         /B8KV/fPlWLFW2CJwjdshxq3ONxlmGrMtrXeMDKfY7wPxcubzsHzCGhXldL/8Cok5kH3
         WND2D4/KmfKXbTrDbtHRsDwItfpxcm8g0nxs1NZLAfYIMDTmnT1utC0MTMJZ2cTItjRk
         zETmvwgVIffC7fxnGJjVJCObDIr2pPo9W0WvAlsJA1A3lu72BS/dog1hot1wn/PdEOwp
         MEcg==
X-Gm-Message-State: AOJu0YyXgiDfQJVRncbiIRhj0PkfbBTkth6PJmdMVBUwlq4kvZZ9/Ofi
	+/jkIycrtjZJGFitrf9W4eVRTVz+OTZ31pGZ9HRfjY1mmtLiBpE9M6vuXM7dY9g+O44=
X-Gm-Gg: AY/fxX4fsHvX0KGQcMPFy8sa6QU8pKrp1ic5BdhRN2X8BADYHgtacjbwzG6BpaB1wIb
	q7Xsg1mfS3eSKe59//m5959W4K0hOA3riC0AJJ2ZBLaUspYdHIyF8PAiXkPVjJLSBre3/gjk+Ia
	R7n6g0y/h32quDd53KayMPMeE4XMVFGPhdPYAuanVSE2csDjEEPs634DbVHKaxsBJyHx1czfcZv
	5nZAlKurl0SjC9s4dw86qxxP6YVAp5rHAFz08XR2IO/PeWN+PRUrDfExNVabSfDtQMItNunTwpV
	RR8ll8NudHAbC6HLWK48hjBBqKQK0olhQBQvfyncBc3TqauORlzF758XzdwKRw2G8rpMsiu/brK
	oymJhiensRUun9LX4l+RduCBxxVbbme8DRFVPg1tjB186QUSzdqHnq4/fCWuIo/bzKC5+YThjl9
	SQP7gMIYRCOVPQMaTwbSYth6keOD1Y7FALXZ+qXhjiQsavJ3Oct+RgWGHuwc2IYzXAf6PTOWUFC
	bKs/BQaki6jFuuz3pY=
X-Google-Smtp-Source: AGHT+IHcp1Xd6rC3o5ZB3CTDNkRWOpZl6RDo/o0SqahmYzwOqC43pOsTCfFUJBNHKrYRj23+etkQ8A==
X-Received: by 2002:a05:7023:b05:b0:11b:9386:a383 with SMTP id a92af1059eb24-11f34e91e57mr5258269c88.22.1765700126625;
        Sun, 14 Dec 2025 00:15:26 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2ffac2sm34467037c88.11.2025.12.14.00.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 00:15:26 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH v2] scsi: remove several unused functions
Date: Sun, 14 Dec 2025 00:15:11 -0800
Message-ID: <20251214081511.59634-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211014246.38423-1-enelsonmoore@gmail.com>
References: <20251211014246.38423-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c   | 89 ---------------------------
 drivers/scsi/aic7xxx/aic79xx_inline.h | 10 ---
 drivers/scsi/aic7xxx/aic79xx_osm.c    | 16 -----
 drivers/scsi/aic7xxx/aic7xxx_core.c   | 35 -----------
 drivers/scsi/nsp32.c                  | 19 ------
 drivers/scsi/ses.c                    | 24 --------
 6 files changed, 193 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 6b87ea004e53..a6f1c23f5a38 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -659,28 +659,12 @@ ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr)
 	ahd_outb(ahd, SCBPTR+1, (scbptr >> 8) & 0xFF);
 }
 
-#if 0 /* unused */
-static u_int
-ahd_get_hnscb_qoff(struct ahd_softc *ahd)
-{
-	return (ahd_inw_atomic(ahd, HNSCB_QOFF));
-}
-#endif
-
 static void
 ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outw_atomic(ahd, HNSCB_QOFF, value);
 }
 
-#if 0 /* unused */
-static u_int
-ahd_get_hescb_qoff(struct ahd_softc *ahd)
-{
-	return (ahd_inb(ahd, HESCB_QOFF));
-}
-#endif
-
 static void
 ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value)
 {
@@ -705,15 +689,6 @@ ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value)
 	ahd_outw(ahd, SNSCB_QOFF, value);
 }
 
-#if 0 /* unused */
-static u_int
-ahd_get_sescb_qoff(struct ahd_softc *ahd)
-{
-	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
-	return (ahd_inb(ahd, SESCB_QOFF));
-}
-#endif
-
 static void
 ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value)
 {
@@ -721,15 +696,6 @@ ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value)
 	ahd_outb(ahd, SESCB_QOFF, value);
 }
 
-#if 0 /* unused */
-static u_int
-ahd_get_sdscb_qoff(struct ahd_softc *ahd)
-{
-	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
-	return (ahd_inb(ahd, SDSCB_QOFF) | (ahd_inb(ahd, SDSCB_QOFF + 1) << 8));
-}
-#endif
-
 static void
 ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value)
 {
@@ -3560,33 +3526,6 @@ ahd_clear_intstat(struct ahd_softc *ahd)
 uint32_t ahd_debug = AHD_DEBUG_OPTS;
 #endif
 
-#if 0
-void
-ahd_print_scb(struct scb *scb)
-{
-	struct hardware_scb *hscb;
-	int i;
-
-	hscb = scb->hscb;
-	printk("scb:%p control:0x%x scsiid:0x%x lun:%d cdb_len:%d\n",
-	       (void *)scb,
-	       hscb->control,
-	       hscb->scsiid,
-	       hscb->lun,
-	       hscb->cdb_len);
-	printk("Shared Data: ");
-	for (i = 0; i < sizeof(hscb->shared_data.idata.cdb); i++)
-		printk("%#02x", hscb->shared_data.idata.cdb[i]);
-	printk("        dataptr:%#x%x datacnt:%#x sgptr:%#x tag:%#x\n",
-	       (uint32_t)((ahd_le64toh(hscb->dataptr) >> 32) & 0xFFFFFFFF),
-	       (uint32_t)(ahd_le64toh(hscb->dataptr) & 0xFFFFFFFF),
-	       ahd_le32toh(hscb->datacnt),
-	       ahd_le32toh(hscb->sgptr),
-	       SCB_GET_TAG(scb));
-	ahd_dump_sglist(scb);
-}
-#endif  /*  0  */
-
 /************************* Transfer Negotiation *******************************/
 /*
  * Allocate per target mode instance (ID we respond to as a target)
@@ -9889,34 +9828,6 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 		ahd_unpause(ahd);
 }
 
-#if 0
-void
-ahd_dump_scbs(struct ahd_softc *ahd)
-{
-	ahd_mode_state saved_modes;
-	u_int	       saved_scb_index;
-	int	       i;
-
-	saved_modes = ahd_save_modes(ahd);
-	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	saved_scb_index = ahd_get_scbptr(ahd);
-	for (i = 0; i < AHD_SCB_MAX; i++) {
-		ahd_set_scbptr(ahd, i);
-		printk("%3d", i);
-		printk("(CTRL 0x%x ID 0x%x N 0x%x N2 0x%x SG 0x%x, RSG 0x%x)\n",
-		       ahd_inb_scbram(ahd, SCB_CONTROL),
-		       ahd_inb_scbram(ahd, SCB_SCSIID),
-		       ahd_inw_scbram(ahd, SCB_NEXT),
-		       ahd_inw_scbram(ahd, SCB_NEXT2),
-		       ahd_inl_scbram(ahd, SCB_SGPTR),
-		       ahd_inl_scbram(ahd, SCB_RESIDUAL_SGPTR));
-	}
-	printk("\n");
-	ahd_set_scbptr(ahd, saved_scb_index);
-	ahd_restore_modes(ahd, saved_modes);
-}
-#endif  /*  0  */
-
 /**************************** Flexport Logic **********************************/
 /*
  * Read count 16bit words from 16bit word address start_addr from the
diff --git a/drivers/scsi/aic7xxx/aic79xx_inline.h b/drivers/scsi/aic7xxx/aic79xx_inline.h
index 09335a3c8691..dca13159b2ce 100644
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h
+++ b/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -144,16 +144,6 @@ static inline uint8_t *ahd_get_sense_buf(struct ahd_softc *ahd,
 static inline uint32_t ahd_get_sense_bufaddr(struct ahd_softc *ahd,
 					      struct scb *scb);
 
-#if 0 /* unused */
-
-#define AHD_COPY_COL_IDX(dst, src)				\
-do {								\
-	dst->hscb->scsiid = src->hscb->scsiid;			\
-	dst->hscb->lun = src->hscb->lun;			\
-} while (0)
-
-#endif
-
 static inline uint8_t *
 ahd_get_sense_buf(struct ahd_softc *ahd, struct scb *scb)
 {
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index c3d1b9dd24ae..82a5c0d4e3f9 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -411,22 +411,6 @@ ahd_inb(struct ahd_softc * ahd, long port)
 	return (x);
 }
 
-#if 0 /* unused */
-static uint16_t
-ahd_inw_atomic(struct ahd_softc * ahd, long port)
-{
-	uint8_t x;
-
-	if (ahd->tags[0] == BUS_SPACE_MEMIO) {
-		x = readw(ahd->bshs[0].maddr + port);
-	} else {
-		x = inw(ahd->bshs[(port) >> 8].ioport + ((port) & 0xFF));
-	}
-	mb();
-	return (x);
-}
-#endif
-
 void
 ahd_outb(struct ahd_softc * ahd, long port, uint8_t val)
 {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index a396f048a031..d55e2a321a7c 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2072,41 +2072,6 @@ ahc_clear_intstat(struct ahc_softc *ahc)
 uint32_t ahc_debug = AHC_DEBUG_OPTS;
 #endif
 
-#if 0 /* unused */
-static void
-ahc_print_scb(struct scb *scb)
-{
-	int i;
-
-	struct hardware_scb *hscb = scb->hscb;
-
-	printk("scb:%p control:0x%x scsiid:0x%x lun:%d cdb_len:%d\n",
-	       (void *)scb,
-	       hscb->control,
-	       hscb->scsiid,
-	       hscb->lun,
-	       hscb->cdb_len);
-	printk("Shared Data: ");
-	for (i = 0; i < sizeof(hscb->shared_data.cdb); i++)
-		printk("%#02x", hscb->shared_data.cdb[i]);
-	printk("        dataptr:%#x datacnt:%#x sgptr:%#x tag:%#x\n",
-		ahc_le32toh(hscb->dataptr),
-		ahc_le32toh(hscb->datacnt),
-		ahc_le32toh(hscb->sgptr),
-		hscb->tag);
-	if (scb->sg_count > 0) {
-		for (i = 0; i < scb->sg_count; i++) {
-			printk("sg[%d] - Addr 0x%x%x : Length %d\n",
-			       i,
-			       (ahc_le32toh(scb->sg_list[i].len) >> 24
-				& SG_HIGH_ADDR_BITS),
-			       ahc_le32toh(scb->sg_list[i].addr),
-			       ahc_le32toh(scb->sg_list[i].len));
-		}
-	}
-}
-#endif
-
 /************************* Transfer Negotiation *******************************/
 /*
  * Allocate per target mode instance (ID we respond to as a target)
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index abc4ce9eae74..c82b6a2026f1 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -424,25 +424,6 @@ static void nsp32_build_reject(struct scsi_cmnd *SCpnt)
 	data->msgout_len = pos;
 }
 
-/*
- * timer
- */
-#if 0
-static void nsp32_start_timer(struct scsi_cmnd *SCpnt, int time)
-{
-	unsigned int base = SCpnt->host->io_port;
-
-	nsp32_dbg(NSP32_DEBUG_INTR, "timer=%d", time);
-
-	if (time & (~TIMER_CNT_MASK)) {
-		nsp32_dbg(NSP32_DEBUG_INTR, "timer set overflow");
-	}
-
-	nsp32_write2(base, TIMER_SET, time & TIMER_CNT_MASK);
-}
-#endif
-
-
 /*
  * set SCSI command and other parameter to asic, and start selection phase
  */
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2c61624cb4b0..68f426cc3d6f 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -441,30 +441,6 @@ static struct enclosure_component_callbacks ses_enclosure_callbacks = {
 	.show_id		= ses_show_id,
 };
 
-struct ses_host_edev {
-	struct Scsi_Host *shost;
-	struct enclosure_device *edev;
-};
-
-#if 0
-int ses_match_host(struct enclosure_device *edev, void *data)
-{
-	struct ses_host_edev *sed = data;
-	struct scsi_device *sdev;
-
-	if (!scsi_is_sdev_device(edev->edev.parent))
-		return 0;
-
-	sdev = to_scsi_device(edev->edev.parent);
-
-	if (sdev->host != sed->shost)
-		return 0;
-
-	sed->edev = edev;
-	return 1;
-}
-#endif  /*  0  */
-
 static int ses_process_descriptor(struct enclosure_component *ecomp,
 				   unsigned char *desc, int max_desc_len)
 {
-- 
2.43.0

