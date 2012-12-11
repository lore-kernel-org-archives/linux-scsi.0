From: <sreekanth.reddy@lsi.com>
Subject: [PATCH -next] [SCSI] mpt3sas: remove unused variables
Date: Wed, 12 Dec 2012 02:26:51 +0530
Message-ID: <20121211205651.GA5312@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54549 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab2LKJ6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Dec 2012 04:58:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, yongjun_wei@trendmicro.com.cn, sreekanth.reddy@lsi.com, weiyj.lk@gmail.com
Cc: Nagalakshmi.Nandigama@lsi.com

The variable 'chain_flags' and 'phy_number' are initialized but never used otherwise,
So remove those unused variables.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 764f3fe..157746d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1309,7 +1309,6 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 	void *sg_local, *chain;
 	u32 chain_offset;
 	u32 chain_length;
-	u32 chain_flags;
 	int sges_left;
 	u32 sges_in_segment;
 	u8 simple_sgl_flags;
@@ -1355,8 +1354,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 		sges_in_segment--;
 	}
 
-	/* initializing the chain flags and pointers */
-	chain_flags = MPI2_SGE_FLAGS_CHAIN_ELEMENT << MPI2_SGE_FLAGS_SHIFT;
+	/* initializing the pointers */
 	chain_req = _base_get_chain_buffer_tracker(ioc, smid);
 	if (!chain_req)
 		return -1;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ac9dbc2..61a1a45 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2754,13 +2754,11 @@ _scsih_block_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
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
