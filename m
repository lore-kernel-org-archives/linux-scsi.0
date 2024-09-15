Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989661CF93;
	Sun, 15 Sep 2024 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726405012; cv=none; b=nm3LvU9IcxfFlPDens1X2iTLX9lZlBB6GBDnqJP/9duudPeS80AMa/u4PK1KGPapfa5BHAB80VyBDmz2DNwC8LUfFAsvaj8nLmANGiuH7LDDBmMI0EsMQnKdWNnMgeFdFiHn64+xN5ylPdwZ6dsawwOoFpx50MpzGH+ivWtMXoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726405012; c=relaxed/simple;
	bh=NMWDb3XblC6zTta47blxYZ4COB1rS+nAcwpZwwZsYH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBVY2cbmzmmXvPxO1OWUTgnx8twqxFkv0pvgvWDYVuxvYUts4nzfzsODWPzBDeUeSarFp5avetxon1zY2QKzNkZqUNvv0v4LYRmxStBGvhLyu6sYG7jW1qjzFn+XMGSmUYoqV1SMkoyS9l8gEduCfhHdg0b0HpulnG7V6ED8fnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=auB5Efjk; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="auB5Efjk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=kxmBdvtcdtZPJkbPCzOmFPqfCK3K6y8Z41XrFg3oUv8=; b=auB5EfjktrIwyuNd
	nHlMPDWHFjo1HrQUoWPYi0w2pHHPJL39isuhvMKEitD5iuDSKwzDEiax/yriPFUFW7uZvyLmmKt3U
	rLF6S4yY89OQL5NPTgybWNf/pORgYjJwq4QL0NdL2Ze9WgGA17oIDBuXjV5XaU0lCWt2YSf201l0s
	DCPvbe4UwFRr7QltNB+aF+bhieNBGZNDN0yoeq753LUe1FS6QTz7p9k282Wyf/KadykIGYrEYC0Vq
	HAa9bHPSkHFXY1fZBVFyi6PERvyipJ1A0WOEkrJHP4QyCGKrPSvG9RkZQfk0nTYkGiVasmR6dTozW
	lcadHx3JKGER+yAJqw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sponz-005pGt-28;
	Sun, 15 Sep 2024 12:56:43 +0000
From: linux@treblig.org
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/5] scsi: bfa: Remove unused bfa_core code
Date: Sun, 15 Sep 2024 13:56:29 +0100
Message-ID: <20240915125633.25036-2-linux@treblig.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240915125633.25036-1-linux@treblig.org>
References: <20240915125633.25036-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

bfa_get_pciids and bfa_cfg_get_min aren't called anywhere;
remove them together with the bfa_pciid_s used by bfa_get_pciids.

(Build tested, I don't have the card)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa.h      | 10 ----------
 drivers/scsi/bfa/bfa_core.c | 35 -----------------------------------
 2 files changed, 45 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 4cb9249e583c..a6b8c4ddea19 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -138,14 +138,6 @@ bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
 	} while (0)
 
 
-/*
- * PCI devices supported by the current BFA
- */
-struct bfa_pciid_s {
-	u16	device_id;
-	u16	vendor_id;
-};
-
 extern char     bfa_version[];
 
 struct bfa_iocfc_regs_s {
@@ -408,9 +400,7 @@ int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
 	(((&(_bfa)->modules.dconf_mod)->min_cfg)		\
 	 ? BFA_LUNMASK_MINCFG : ((bfa_get_lun_mask(_bfa))->status))
 
-void bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids);
 void bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg);
-void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
 void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
 			struct bfa_meminfo_s *meminfo,
 			struct bfa_s *bfa);
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 3438d0b8ba06..a99a101b95ef 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1933,24 +1933,6 @@ bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q)
 	}
 }
 
-/*
- * Return the list of PCI vendor/device id lists supported by this
- * BFA instance.
- */
-void
-bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
-{
-	static struct bfa_pciid_s __pciids[] = {
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G2P},
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G1P},
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT_FC},
-	};
-
-	*npciids = ARRAY_SIZE(__pciids);
-	*pciids = __pciids;
-}
-
 /*
  * Use this function query the default struct bfa_iocfc_cfg_s value (compiled
  * into BFA layer). The OS driver can then turn back and overwrite entries that
@@ -1987,20 +1969,3 @@ bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg)
 	cfg->drvcfg.delay_comp = BFA_FALSE;
 
 }
-
-void
-bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg)
-{
-	bfa_cfg_get_default(cfg);
-	cfg->fwcfg.num_ioim_reqs   = BFA_IOIM_MIN;
-	cfg->fwcfg.num_tskim_reqs  = BFA_TSKIM_MIN;
-	cfg->fwcfg.num_fcxp_reqs   = BFA_FCXP_MIN;
-	cfg->fwcfg.num_uf_bufs     = BFA_UF_MIN;
-	cfg->fwcfg.num_rports      = BFA_RPORT_MIN;
-	cfg->fwcfg.num_fwtio_reqs = 0;
-
-	cfg->drvcfg.num_sgpgs      = BFA_SGPG_MIN;
-	cfg->drvcfg.num_reqq_elems = BFA_REQQ_NELEMS_MIN;
-	cfg->drvcfg.num_rspq_elems = BFA_RSPQ_NELEMS_MIN;
-	cfg->drvcfg.min_cfg	   = BFA_TRUE;
-}
-- 
2.46.0

