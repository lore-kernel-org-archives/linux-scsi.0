Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F8BA21
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770922139; cv=none; b=YWteZClfYErxHs1PZTFcZD3XzItHZCDhdvRjbtWvTzekKUhVSXapImWm+cXsKfSyUmNwS19T1v53XBPttw7mxeFhVnPLIyn2/MzZ7WmK4lB4A3DrcsE7ZmXsER23k02mDS3V7deLYUN8ASZ/KsfDf6wKlWjk05miln94h+x/r1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770922139; c=relaxed/simple;
	bh=hl593n2tB11QYj8d3hZjHYBD8HFsXePVHtcQk9s/X3k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c2Ht7FePMf76mXUeu/XRemNf0HhD/ubzs3MXOIhVzgQBOhZ+8zTLdshN/3LRmRXKrV1HvmIw5GTFbFPZ5X3OBBTI/js0gFS5204BwxrOgW6UA1lOslIO8GrDo1wEXIQbssheyfZBImtxdxGGgkd8290NXgoe2uEOT7R/UcmZHxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I2oEhK1H; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2oEhK1H"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8966bd9da41so1651286d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 10:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770922137; x=1771526937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RXm1B0Xuql4p1QqqnGd0+EHzvw//x2CT7fu1vIRqwO4=;
        b=I2oEhK1HF1frrxsqigWlJwd0Z0m/VARh9bk0nohrYtzuDJOG91rSl/UzTpAwuJMq5S
         j4Jp346CI7ZKNPxV5PKrcrp42Sb3a7jcvIt03fTKeUKemB6BkrQx2rnK3IgmVGYGHvT6
         caQiZ/IHiSnhbdicb7Df422m+jXWWX1TgXdYDdwHVyffFnl5oxZ5tOOChi/EFIGRouCu
         E6Rh4+UnjcVsLTRG+MqMkVLXt7CroKeMqclWYDsWWMd/GvN3kT90WnS0HJGkeOZluc1z
         qwNsArd4bTxpIvA1r/PZZNyjGWp3tS1LCjqa4YM8MPLEN8tteESdXrAJfBUAWq3x3/oq
         AvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770922137; x=1771526937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXm1B0Xuql4p1QqqnGd0+EHzvw//x2CT7fu1vIRqwO4=;
        b=XWcJ25Y5VMP+gounLq7NzdoM9CchduM7cvar/NfMUAqGra03LLqCtE5YyqJSz2BDIx
         UMSmokwpa7sRfI+uPm2rPD7ndmsKQWdhOm/tfEOEc+U+7L+SEsdNS6siiJXBfUuHuKmh
         bBvQTkn3IJHbkt+W891PpYXXIJ1l8G7EuAwdM+OxcxBH97D/SsKazKOcYd5hy9SR8uWL
         3FNIrPeZLW7kfZXx3BrcPAVuaz3pg6GMh/UvtZ5pdpX6gxHthlKj3r9WAXv+Kf1D9fDN
         HORqpIfgbOTJihrcICazuc3uVHRKhFHrb6WAfYeFV4K1jAAYw1JtWXrK/mpqDBdlYctN
         L9+g==
X-Gm-Message-State: AOJu0YwN8KsVn+zs/ysCg3HGhPH7yleVGEt4I16aV1lsxSwJOts9Dlct
	4NBVhG5yS6+MvcmsGA1PjcAoicyIpuv/zwW8x1gZ+dCZJErxGRtXNUj7pqt7y9F9
X-Gm-Gg: AZuq6aKH7Sul3u+EJ9qEsFretJl8Awyfupd2skB/NjKO1Dp/Ic3pSdfkK/sIhCo0dzz
	nHcr20d9jlGE2XtxW9MpxeoelC/NeDEhUFsq8cMHtf+2YpXFfmd0sfws8tqomGd3XS3cjML4m71
	HmAG0jNaURpoyrGcBDPOBKj0H9J9wiJfrhtgysSsyPUC+ttNSjzd9KkwqNlSeOaawsxhMAiCSBR
	We7L28kXfKfbARFxidIcnbWTYBhIjLJxvAYTUCvdxDVI9sSH2WTECfLLmJnymg1ajYL38bG7Sd5
	pvDoXuRMdnVaKfnN/ZKxorSfYPP5WicFi3HiMG6XM0yPgxDmr540azLbPjhtv6hwKkizdm2oGqL
	RHX9T9rISKX1RzjfaZoo0E9rD0jQahrpYtpi7zDgb85JanDhII0r1opsAud4cPnrcrji1BsgLDH
	rLJKi9UxQSQxoW0RbGAKBUV3C47LLy/avng2G13b/M+c5Ape/M6+nY5A83WqofLDPX/tN+yVSEv
	emgVRZqIaF/GvK5uG61aQ==
X-Received: by 2002:a05:6214:246a:b0:895:bc65:4b0a with SMTP id 6a1803df08f44-897347a429cmr1437366d6.43.1770922136827;
        Thu, 12 Feb 2026 10:48:56 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b1c8505sm393283785a.25.2026.02.12.10.48.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 10:48:56 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Mathias Krause <minipli@grsecurity.net>,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 1/1] scsi: lpfc: Properly set WC for DPP mapping
Date: Thu, 12 Feb 2026 11:23:27 -0800
Message-Id: <20260212192327.141104-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mathias Krause <minipli@grsecurity.net>

Using set_memory_wc() to enable write-combining for the DPP portion of
the MMIO mapping is wrong as set_memory_*() is meant to operate on RAM
only, not MMIO mappings. In fact, as used currently triggers a BUG_ON()
with enabled CONFIG_DEBUG_VIRTUAL.

Simply map the DPP region separately and in addition to the already
existing mappings, avoiding any possible negative side effects for
these.

Fixes: 1351e69fc6db ("scsi: lpfc: Add push-to-adapter support to sli4")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 36 +++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli4.h |  3 +++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a116a16c4a6f..b5e53c7d33e7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12039,6 +12039,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 734af3d039f8..690763e0aa55 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15981,6 +15981,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 	return NULL;
 }
 
+static __maybe_unused void __iomem *
+lpfc_dpp_wc_map(struct lpfc_hba *phba, uint8_t dpp_barset)
+{
+
+	/* DPP region is supposed to cover 64-bit BAR2 */
+	if (dpp_barset != WQ_PCI_BAR_4_AND_5) {
+		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
+			     "3273 dpp_barset x%x != WQ_PCI_BAR_4_AND_5\n",
+			     dpp_barset);
+		return NULL;
+	}
+
+	if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
+		void __iomem *dpp_map;
+
+		dpp_map = ioremap_wc(phba->pci_bar2_map,
+				     pci_resource_len(phba->pcidev,
+						      PCI_64BIT_BAR4));
+
+		if (dpp_map)
+			phba->sli4_hba.dpp_regs_memmap_wc_p = dpp_map;
+	}
+
+	return phba->sli4_hba.dpp_regs_memmap_wc_p;
+}
+
 /**
  * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
  * @phba: HBA structure that EQs are on.
@@ -16944,9 +16970,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17132,14 +17155,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 
 #ifdef CONFIG_X86
 			/* Enable combined writes for DPP aperture */
-			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
-			rc = set_memory_wc(pg_addr, 1);
-			if (rc) {
+			bar_memmap_p = lpfc_dpp_wc_map(phba, dpp_barset);
+			if (!bar_memmap_p) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3272 Cannot setup Combined "
 					"Write on WQ[%d] - disable DPP\n",
 					wq->queue_id);
 				phba->cfg_enable_dpp = 0;
+			} else {
+				wq->dpp_regaddr = bar_memmap_p + dpp_offset;
 			}
 #else
 			phba->cfg_enable_dpp = 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index ee58383492b2..b6d90604bb61 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
 	void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
 					   * dpp registers
 					   */
+	void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
+					    * dpp registers with write combining
+					    */
 	union {
 		struct {
 			/* IF Type 0, BAR 0 PCI cfg space reg mem map */
-- 
2.38.0

