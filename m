From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] mpt3sas: remove unused variables
Date: Mon, 3 Dec 2012 08:18:17 -0500
Message-ID: <CAPgLHd-jvCXptQGr6gtRiJE2av226aDOqY_Vox3RDT4iMbqX8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45417 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LCNSS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 08:18:18 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1471538qcr.19
        for <linux-scsi@vger.kernel.org>; Mon, 03 Dec 2012 05:18:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variables 'chain_flags' and  'phy_number' are initialized but
never used otherwise, so remove those unused variables.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 2 --
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 04f8010..d07a3b4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1310,7 +1310,6 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 	void *sg_local, *chain;
 	u32 chain_offset;
 	u32 chain_length;
-	u32 chain_flags;
 	int sges_left;
 	u32 sges_in_segment;
 	u8 simple_sgl_flags;
@@ -1357,7 +1356,6 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	/* initializing the chain flags and pointers */
-	chain_flags = MPI2_SGE_FLAGS_CHAIN_ELEMENT << MPI2_SGE_FLAGS_SHIFT;
 	chain_req = _base_get_chain_buffer_tracker(ioc, smid);
 	if (!chain_req)
 		return -1;

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 05f8045..59cbb79 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2755,13 +2755,11 @@ _scsih_block_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
 	int i;
 	u16 handle;
 	u16 reason_code;
-	u8 phy_number;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
-		phy_number = event_data->StartPhyNum + i;
 		reason_code = event_data->PHY[i].PhyStatus &
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)


