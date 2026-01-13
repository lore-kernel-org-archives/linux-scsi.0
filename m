Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237282FCC0E
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 22:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343253; cv=none; b=HDUOTTYcKo7umXIBU8z7B/tXCkBhtXg7d2vcahgzGzlAYb/2qIU9wMAlkNCk5eQ6KNZpgc6X/pM/TF6gX4gxAHY5S13yEKCIW3nIRx1pRJhTT8ZelBDLTLPq0VhToBVGOP/hy4ZWWA+iXBGZt6dutJjzBnjZZasNIyowUULk+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343253; c=relaxed/simple;
	bh=LbBRiMweJYqFJr3AgNE0/zqs5E9DF9TaC2Klh1QFFlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mIvj95+25Wirfbr0OOXLy3NxAI+c1FJyghYVtgKm+r6Hix2wIdgqVRMjIUMcyWTXpLNklt6rC8VSp4tW0MURs/XilU3HiNFJcZyGnaCP0qYBEGPLqPnBj9uakrp0PH4OQa4TcqQ1J7DuAEOg2n+yrDqMLYl4E3LfaIP/uN2MNnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=oMld6nUk; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="oMld6nUk"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa9so3829624f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 14:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1768343250; x=1768948050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CbH9q44ueqbfObK6wzfPrCW8uY3tTQugl8twX0nt2wY=;
        b=oMld6nUk8XE1SBSSUlgiI200r5PFRpsUPe9HT4bB/6ouTcJumS7/Ae0QheAVYIvDlH
         agToAyRQyx/+KwVUq8Ps2ZBePBO95lmgvsB/3xVAAKpxPCrkyDohEYSu4Yvhh1+RriqT
         +sB3v2aVJgbXS+5DVClj9VGJ81G7LL/NUOAfTazToRy8N8U6VML2izDEgwygwk9QvEuf
         eQFFWpk9mt1gd1X6kzG0Oip8rixhP9evm3xMiIc6bRmbz6E40oybbUQoRJ5zIkkbOS5H
         FUGfFnpAIlnS/3cnEkdS8bFed1Vz8bs9ZI2ajXdrSamuYPI+MJMu5vI8xYEj0YGIOjh2
         XxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768343250; x=1768948050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbH9q44ueqbfObK6wzfPrCW8uY3tTQugl8twX0nt2wY=;
        b=i2DU9j/tcMw3cL1aFeQjK2MsUU0o2BWCNF/jr0yPu33yKaWcHeaoh68sfwMU7LgKsc
         GsytkCTwcZV02EWxoHGlj7WoDKrNaJR8Ib3rws+Tc/skI0eDX/v8SZYRPJwH98Om23CQ
         Fq66eXB5xBkmTRmE6HcX/9H8zn7BGlm99iRRJVesHm/Nj3oVXviAzeKV1u2jMKypUP/U
         ktB/tcOycVoFVeEduCFOA4Q+3DP8REhDxONJkrFJj79xQFBWnPDS8itiBQPI4dQHOka8
         focn6bCkkjJec2BY56Rg4YDUPMytIhXOVz/n/IBjGFD0OxlvN0j0JFYsTcqpe5cueS6A
         PxFg==
X-Forwarded-Encrypted: i=1; AJvYcCWGGVRtkv/LEzcC4tIXrfd6vY5iVnD/NavQ4bLB3d9v51vu8Pj0HEJfpRlPNQazv05g0JBrywmqraND@vger.kernel.org
X-Gm-Message-State: AOJu0YycAl1QLEhDb3WvIEo/YObo/ESm0QhflIIAZbrZkizOiR4XAD7q
	f+cEqL0cQbMqF+9rjxA45zgXqgGFE04/g0mGziEitJ6zFPUf9+crw/mQ0WGtoH9OsbY57RbRxSw
	WgBYrrvg=
X-Gm-Gg: AY/fxX7lKpOCnXZv7ud27L/B+3gu5JMVp19DTX5fnKSmmDYqjK+ASnqmIQ5d75D2pvT
	BEWB6ac5CtT9JsopqwH2zEdu7d3t899VI7HLuWM7Fv+zgyaj4g//bnSADVGOLlGptM5YpPzIHcc
	TAfWoGcbPU9V2Dcf+vqjPFMQ+cBczI1Yqz5Eh3oI0Qr321Fu3pRUK1Z/G4bEBcANjdcNAicpL7C
	lYvM5Qx9ORy4bsQ/FzWGlSnPP8ONQ8MBAvgFk/2BYZLmc4fpYPds4x9ipgu0Lnmyd5YIeDYJ95U
	Q8NwWpFNDq0B1UBunZ95+mW0D/vCfM1Wh4n2i/9wf3nv6utjz+6ZBXf2wycv4PTbUgJksHf7zl7
	b7B+NpzsiGaDWOlNJ+ZzK0QtIm7J1Nto/FsaeVf+0shyULvG7uvrRszTRil0FwZ8sazVPGfXWlp
	HxX5Tm0ZclZ5D5nE85XrQr6dIBoA03SBH+bQciPw3vlYc6QkIfMX4kT2Sdw4cDvcTqg3CJrTGTd
	Kg7zpbKgg==
X-Received: by 2002:a05:6000:22c4:b0:432:84ef:713a with SMTP id ffacd0b85a97d-4342c4ef268mr511021f8f.12.1768343250009;
        Tue, 13 Jan 2026 14:27:30 -0800 (PST)
Received: from bell.fritz.box (p200300faaf0ab900a5609f31ade21a74.dip0.t-ipconnect.de. [2003:fa:af0a:b900:a560:9f31:ade2:1a74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe83bsm46756852f8f.38.2026.01.13.14.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 14:27:29 -0800 (PST)
From: Mathias Krause <minipli@grsecurity.net>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-scsi@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>,
	James Smart <jsmart2021@gmail.com>
Subject: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
Date: Tue, 13 Jan 2026 23:27:16 +0100
Message-ID: <20260113222716.2454544-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using set_memory_wc() to enable write-combining for the DPP portion of
the MMIO mapping is wrong as set_memory_*() is meant to operate on RAM
only, not MMIO mappings. In fact, as used currently triggers a BUG_ON()
with enabled CONFIG_DEBUG_VIRTUAL.

Simply map the DPP region separately and in addition to the already
existing mappings, avoiding any possible negative side effects for
these.

Fixes: 1351e69fc6db ("scsi: lpfc: Add push-to-adapter support to sli4")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Cc: James Smart <jsmart2021@gmail.com>
---
!!! WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING !!!

I don't have any hardware to test this on. I just got the report from a
customer of ours regarding the CONFIG_DEBUG_VIRTUAL BUG_ON(). As I don't
have any spec for the hardware either, I assumed a few things, like:
1/ DPP regions are only supported on SIL4 devices.
2/ DPP may be shared with other registers (doorbells?) in the same BAR.

That's why I fixed the bug by creating a dedicated mapping for the DPP
region instead of making the existing one ioremap_wc(). I simply
assumed, the fact that 'dpp_offset' needs to be queried instead of
blindly assumed to be zero allows the DPP region to be shared with other
registers that may be harmed by a WC mapping (slow reads, etc.).

Again, as I don't have any hardware, I can't do any performance
benchmarks either but the dedicated mapping should avoid past[1] latency
issues observed.

[1] https://lore.kernel.org/all/e1da721e-8ec4-9e57-9fb2-9141514e8785@gmail.com/

 drivers/scsi/lpfc/lpfc_init.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 52 +++++++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli4.h |  3 ++
 3 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b1460b16dd91..c6bb45c3d4c4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12034,6 +12034,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 73d77cfab5f8..76e32891ee20 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15981,6 +15981,46 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 	return NULL;
 }
 
+static phys_addr_t
+lpfc_dual_chute_pci_bar_addr(struct lpfc_hba *phba, uint16_t pci_barset)
+{
+	if (!phba->pcidev)
+		return PHYS_ADDR_MAX;
+
+	switch (pci_barset) {
+	case WQ_PCI_BAR_0_AND_1:
+		return phba->pci_bar0_map;
+	case WQ_PCI_BAR_2_AND_3:
+		return phba->pci_bar1_map;
+	case WQ_PCI_BAR_4_AND_5:
+		return phba->pci_bar2_map;
+	default:
+		break;
+	}
+	return PHYS_ADDR_MAX;
+}
+
+static __maybe_unused void __iomem *
+lpfc_dpp_wc_map(struct lpfc_hba *phba, uint16_t pci_barset, uint32_t dpp_offset,
+		uint32_t size)
+{
+	if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
+		void __iomem *dpp_map;
+		phys_addr_t dpp_addr;
+
+		dpp_addr = lpfc_dual_chute_pci_bar_addr(phba, pci_barset);
+		if (dpp_addr == PHYS_ADDR_MAX)
+			return NULL;
+
+		dpp_addr += dpp_offset;
+		dpp_map = ioremap_wc(dpp_addr, size);
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
@@ -16944,9 +16984,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17132,14 +17169,17 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 
 #ifdef CONFIG_X86
 			/* Enable combined writes for DPP aperture */
-			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
-			rc = set_memory_wc(pg_addr, 1);
-			if (rc) {
+			bar_memmap_p = lpfc_dpp_wc_map(phba, pci_barset,
+						       dpp_offset,
+						       wq->entry_size);
+			if (!bar_memmap_p) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3272 Cannot setup Combined "
 					"Write on WQ[%d] - disable DPP\n",
 					wq->queue_id);
 				phba->cfg_enable_dpp = 0;
+			} else {
+				wq->dpp_regaddr = bar_memmap_p;
 			}
 #else
 			phba->cfg_enable_dpp = 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index fd6dab157887..bcd12b59fa92 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
 	void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
 					   * dpp registers
 					   */
+	void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
+					   * dpp registers with write combining
+					   */
 	union {
 		struct {
 			/* IF Type 0, BAR 0 PCI cfg space reg mem map */
-- 
2.47.3

