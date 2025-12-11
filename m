Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD731CDFCA
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 01:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765417406; cv=none; b=uNq2mN7DwQbjaP60EhEdscKADVBBYgUWr9sLyimx0yBG8067hdqE/nfZcX9cSD8y7CpCg7JS8ABo2hx/gsHeTM2OISM8kjXyhLTVhQsDKa9SnyffhBynV9OMZ6HPVsHmG5ltwM0YNYBMVM/lgvCnvw/ozR7G6O1fJY77E3RHVqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765417406; c=relaxed/simple;
	bh=xrWDGO8Bu+TNV0i2MKifgX+FrHrf+hXPL09zGZFhmY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RTxWbCSnhyT2Ve96WnSqIRbYCwvV6qMLYOlkKhkrSovUhJYXYMgWSmDWJ22GTgEWr0Mt+zmRhvRgSwv74qjXOiFXrUORnqCITdRl5PFO0fGEnFv5l/6qSeB9umR3jkqY67MOVzo8M+17r423FolmUoUuvxo9Gxf86Rw3WanNCDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hClWqQpU; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hClWqQpU"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7ba55660769so329488b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 17:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765417404; x=1766022204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H67pqGEvrZPQpldVYXefn/pIpv1C8G/3O8zvSEm0qzo=;
        b=hClWqQpU6mw75UYM2B9TqbgrAw8mLmN/JfIF5ywEnbgfXT6kjwkVYdhGm8e9QvVT2R
         l2NA+PgpvsQEDIhXtwQb9AWiuZhsrzgRy9YFYrcXgtvliFpU9KlgJ72NZutOUF6VuN4A
         CiihARP6PRqHbzzMFsLoM/C1miwUycG/nXFvIHNzwYEG3i8cDLfVFzgqvXfBgjb/UhIu
         olKhkhqGPQ9cGdsIUGm5Frb9bisytiidCHPgOtt6Hp7FEUgzcg4WtgZMWXuZEV3ujDRr
         rJA6qKjqs1AYSI+p94y+/r2QfRIc0yk0sOUhHuWfGQUAX+r1eVTKjSt6rIsui3/25cPh
         fzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765417404; x=1766022204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H67pqGEvrZPQpldVYXefn/pIpv1C8G/3O8zvSEm0qzo=;
        b=UbCXkXP+pPDViP0jdt+bkDcri/UUOfwUKcK5Csffagwu9DMWDzPjL8kfWbpRxJPkdW
         UFLmRm3hTqXjqhcub5QMSQtcOvT1j6MbUeRuikbQm5DBxH7bG8Sh93n0pIwfEfs7GUHm
         f0dFXo3mbh02XX4ipvDQQkwEkLlZjMhPxTqLGf2ELO9YNpvVeOQJmAksiV37ID/J+g9Z
         7YPWGbCYzTZSSB5N7tovnxM+wwy+ydL4CxOqlaPv4pw+JXRfKGagYUFNDtho/vpAirBB
         O4RrnLOEb/aXmpxVJIfa39twX4k4JVy+YsDDLIhgUH5AaIog2vlDUTAj2p98k2WaJrzm
         6Yxg==
X-Gm-Message-State: AOJu0Yy88BIvf2nQKBZ25IxwPTQ//EbOh6mKVgYjy69o13EH7gQWP2gG
	hASofDXMDWOcB6na5HsglOhMu+7KkFYCCxdPrYsVgfRLkJrHTYRun140hYt3N+Xouhs3dQ==
X-Gm-Gg: ASbGncu8geIOGyr3cfPsHrjsACcrutEusxFhHZtZ1fy3McSbyPEWoHtnQzUJoI2uP08
	s2c8X33JS2CaIw5MFr4C9/9Hzp4l8GPv5fOV2hdxY+wL4j2WEiocI9mGYhvBfnml+HVhsO0R34l
	Yf68VVEbTh7X9YFFGTwFOyBk3wpR6hhrbDbrKfGOc2z9fE0DcJkm+ZTP4h0Z3Qh/djib+9JzRUr
	5qw+LoFVJUz8fQ/ayIVXSblW2lmXAw3YXi/e4PfFbZ11ST/Z0KVRPWvjNTI4kNeqGV5WgKgLaoG
	f3EnVtRQsZOeNj/YDBUzwWcseh5afyqysPjUPzb9vB5LDS6uWsVvP0hDG60/wlhrCRWeBHe/CjN
	KP0uofsGCBT7p3RjvCaUcWBegqd3rFMG9QQvzpPEjOo1BS40H+dBW7wCeLVsI+ZOqQL8Y7/tUL3
	Oho5hiSLjfXABOmw5zEwCrkjunqSVDgNEaelYq6flRZJTPGYctW8tHkGFRs+Pv5uNmDNwhePX8L
	1PN
X-Google-Smtp-Source: AGHT+IHKm1B8+dqiSRwtDCu77EUWtjs/Dq+WIel9xHlliXpCPULzDgiEIpwgAeJ52Gced4FhgIjKbA==
X-Received: by 2002:a05:7022:984:b0:119:e56b:91f6 with SMTP id a92af1059eb24-11f296b3ed0mr3384387c88.39.1765417404301;
        Wed, 10 Dec 2025 17:43:24 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e1bb3b4sm3273748c88.4.2025.12.10.17.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 17:43:24 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH] scsi: remove several unused functions
Date: Wed, 10 Dec 2025 17:42:44 -0800
Message-ID: <20251211014246.38423-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
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
 drivers/scsi/nsp32.c                  | 14 -----
 drivers/scsi/ses.c                    | 19 ------
 6 files changed, 183 deletions(-)

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
index abc4ce9eae74..fd6dc06e1f20 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -427,20 +427,6 @@ static void nsp32_build_reject(struct scsi_cmnd *SCpnt)
 /*
  * timer
  */
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
 
 
 /*
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2c61624cb4b0..ddc1e6662f3f 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -446,25 +446,6 @@ struct ses_host_edev {
 	struct enclosure_device *edev;
 };
 
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

