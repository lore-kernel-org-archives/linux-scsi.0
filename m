Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EAF1C68A0;
	Sun, 15 Sep 2024 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726405012; cv=none; b=X7IT29gJz/HWEmm9MYb/X33JLjlLPPUfIH3/3U7BREL4s1SItVR9XaduyM9KanU7aX65KPI4K4tZO5WFg8dNlpb3ZoMDrcIrVT+1Ti0JQBdjdxpsf3ipnD3CVaYtG83qdR4QSaeEPhRWsxdXaCilyjURCH6Nx4rtzZJbeNeUNi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726405012; c=relaxed/simple;
	bh=naui/3/tJAy0XvQQYtXAbEnz4WLQutkbZ1JeUb3EiNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbtwXeGDs0KooxuVtW87UiTPQG+i+9mVtHBt4+AWyD1c15Lk9ouIHIZ6ozv03OWaCqzLXviytMtljjmok11Q4/cNLdZqTFcZWXFu8I3cLtJkVAAnjkx8G+pLaKvcEs+299aJ8HuAXRQFuSl3i3HqOn6sjaJkxbhUZLmEiPygDRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=XR597tKH; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="XR597tKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=2NRBnu2zBzDYZPkYvNeYBgLG3fuIGOLJfxH+/H+E2Es=; b=XR597tKHCwiLogOu
	QvZFIvfz+Mw9y2rMmAXoAd14ujaA1zwQ8DqUIGl0+OlwCABZlYjJUbE+ScxpUnePHHqr/hw6Zm1Le
	ol7cL4Pv4dDl9RaEbLmFkYk4qPXyo3w7y0TMkifZ4S+MCy5QHI8vzaM5t07TVFLorR/FGqyr1t/1M
	KXNi6I2U+L5Z0UpEGHjezpdDGbC2bqpZ3Y4gjsW0DA/BmvBtGaZMLCnfCiWLj1nqk2VasTE0Uw6Q/
	yMPP+IA2lfR4TwQ5a1EfYf7/2OsfJmAMsYdJAlLhhqfUDtJwKHMK2JOKqXUx+25h5MxxkYPSRM8ZV
	EJwu6C1/+ACdtLV3XA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1spoo1-005pGt-1u;
	Sun, 15 Sep 2024 12:56:45 +0000
From: linux@treblig.org
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 3/5] scsi: bfa: Remove unused bfa_ioc code
Date: Sun, 15 Sep 2024 13:56:31 +0100
Message-ID: <20240915125633.25036-4-linux@treblig.org>
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

These functions aren't called anywhere, remove them.

Build tested only.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa_ioc.c | 21 ---------------------
 drivers/scsi/bfa/bfa_ioc.h |  2 --
 2 files changed, 23 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index ea2f107f564c..aa68d61a2d0d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2254,33 +2254,12 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 	return status;
 }
 
-/*
- * Enable/disable IOC failure auto recovery.
- */
-void
-bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
-{
-	bfa_auto_recover = auto_recover;
-}
-
-
-
 bfa_boolean_t
 bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
 {
 	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op);
 }
 
-bfa_boolean_t
-bfa_ioc_is_initialized(struct bfa_ioc_s *ioc)
-{
-	u32 r32 = bfa_ioc_get_cur_ioc_fwstate(ioc);
-
-	return ((r32 != BFI_IOC_UNINIT) &&
-		(r32 != BFI_IOC_INITING) &&
-		(r32 != BFI_IOC_MEMTEST));
-}
-
 bfa_boolean_t
 bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 {
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 3ec10503caff..d70332e9ad6d 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -919,7 +919,6 @@ void bfa_ioc_ct2_poweron(struct bfa_ioc_s *ioc);
 
 void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
 		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod);
-void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
 void bfa_ioc_detach(struct bfa_ioc_s *ioc);
 void bfa_ioc_suspend(struct bfa_ioc_s *ioc);
 void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
@@ -934,7 +933,6 @@ bfa_status_t bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type,
 void bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *msg);
 void bfa_ioc_error_isr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
-bfa_boolean_t bfa_ioc_is_initialized(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_acq_addr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
-- 
2.46.0

