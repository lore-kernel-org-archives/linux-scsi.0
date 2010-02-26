From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 04/32] bfa: Enable IOC auto-recovery and IOC type fix.
Date: Thu, 25 Feb 2010 17:51:00 -0800
Message-ID: <1267149060-24159-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:59512 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941Ab0BZBwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:52:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- bfa_ioc.c:
		- Enable IOC auto-recovery by default.
		- When CNA is in FC mode, return IOC type as FC (not FCoE)

	- bfa_iocfc.c:
		- Set fcmode before pci initialization/setup.
---
 drivers/scsi/bfa/bfa_ioc.c   |    6 +++---
 drivers/scsi/bfa/bfa_iocfc.c |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 397d7e9..569b35d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -56,7 +56,7 @@ BFA_TRC_FILE(HAL, IOC);
 #define BFA_FLASH_CHUNK_NO(off)         (off / BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_FLASH_OFFSET_IN_CHUNK(off)  (off % BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_FLASH_CHUNK_ADDR(chunkno)   (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
-bfa_boolean_t   bfa_auto_recover = BFA_FALSE;
+bfa_boolean_t   bfa_auto_recover = BFA_TRUE;
 
 /*
  * forward declarations
@@ -1642,7 +1642,7 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
 void
 bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
 {
-	bfa_auto_recover = BFA_FALSE;
+	bfa_auto_recover = auto_recover;
 }
 
 
@@ -2082,7 +2082,7 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 	ioc_attr->state = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
 	ioc_attr->port_id = ioc->port_id;
 
-	if (!ioc->ctdev)
+	if (!ioc->ctdev || ioc->fcmode)
 		ioc_attr->ioc_type = BFA_IOC_TYPE_FC;
 	else if (ioc->ioc_mc == BFI_MC_IOCFC)
 		ioc_attr->ioc_type = BFA_IOC_TYPE_FCoE;
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index d7ab792..b5e7224 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -619,8 +619,6 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 	bfa_ioc_attach(&bfa->ioc, bfa, &bfa_iocfc_cbfn, &bfa->timer_mod,
 		bfa->trcmod, bfa->aen, bfa->logm);
-	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
-	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
 
 	/**
 	 * Choose FC (ssid: 0x1C) v/s FCoE (ssid: 0x14) mode.
@@ -628,6 +626,9 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	if (0)
 		bfa_ioc_set_fcmode(&bfa->ioc);
 
+	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
+	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
+
 	bfa_iocfc_init_mem(bfa, bfad, cfg, pcidev);
 	bfa_iocfc_mem_claim(bfa, cfg, meminfo);
 	bfa_timer_init(&bfa->timer_mod);
-- 
1.6.5.3

