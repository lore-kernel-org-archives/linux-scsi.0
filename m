From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2/2] bfa: remove unused bfa_get_pciids() and struct bfa_pciid_s
Date: Wed, 31 Oct 2012 20:29:01 +0100
Message-ID: <2396163.ZDN5z3Ipj1@eto>
References: <3374605.SkInhuzxbT@eto>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:50338 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab2JaT3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2012 15:29:03 -0400
In-Reply-To: <3374605.SkInhuzxbT@eto>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna C Gudipati <kgudipat@brocade.com>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/scsi/bfa/bfa.h      |  9 ---------
 drivers/scsi/bfa/bfa_core.c | 18 ------------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 4ad7e36..0ef77dc 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -147,14 +147,6 @@ bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
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
@@ -398,7 +390,6 @@ int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
 	(((&(_bfa)->modules.dconf_mod)->min_cfg)		\
 	 ? BFA_LUNMASK_MINCFG : ((bfa_get_lun_mask(_bfa))->status))
 
-void bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids);
 void bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg);
 void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
 void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index b7c326f..c3f3b25 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1856,24 +1856,6 @@ bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q)
 }
 
 /*
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
-	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
-	*pciids = __pciids;
-}
-
-/*
  * Use this function query the default struct bfa_iocfc_cfg_s value (compiled
  * into BFA layer). The OS driver can then turn back and overwrite entries that
  * have been configured by the user.
-- 
1.7.7

