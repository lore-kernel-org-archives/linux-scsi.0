From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 1/2] bfa: fix system crash when reading sysfs fc_host statistics
Date: Fri, 21 May 2010 14:39:45 -0700
Message-ID: <1274477985-14124-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:45008 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab0EUVjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2010 17:39:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, rvadivel@brocade.com, vravindr@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- The port data structure related to fc_host statistics collection
	  is not initialized. This causes system crash when reading the fc_host
	  statistics. The fix is to initialize port structure during driver attach.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 0c08e18..3a7b3f8 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -84,11 +84,32 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->meminfo(cfg, &km_len, &dm_len);
 
+	dm_len += bfa_port_meminfo();
 
 	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_len = km_len;
 	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_len = dm_len;
 }
 
+static void
+bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi)
+{
+	struct bfa_port_s       *port = &bfa->modules.port;
+	uint32_t                dm_len;
+	uint8_t                 *dm_kva;
+	uint64_t                dm_pa;
+
+	dm_len = bfa_port_meminfo();
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa  = bfa_meminfo_dma_phys(mi);
+
+	memset(port, 0, sizeof(struct bfa_port_s));
+	bfa_port_attach(port, &bfa->ioc, bfa, bfa->trcmod, bfa->logm);
+	bfa_port_mem_claim(port, dm_kva, dm_pa);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva + dm_len;
+	bfa_meminfo_dma_phys(mi) = dm_pa + dm_len;
+}
+
 /**
  * Use this function to do attach the driver instance with the BFA
  * library. This function will not trigger any HW initialization
@@ -140,6 +161,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->attach(bfa, bfad, cfg, meminfo, pcidev);
 
+	bfa_com_port_attach(bfa, meminfo);
 }
 
 /**
-- 
1.7.1.96.gc06ee

