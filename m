From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 8/9] mpt2sas: Support dev remove when phy status is MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT
Date: Mon, 14 Sep 2009 11:07:23 +0530
Message-ID: <20090914053709.GJ31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:41703 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZINGAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 02:00:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Add support to process device removal events when the phy status is set to
MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5ea6431..5c1fc3f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4067,15 +4067,16 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		}
 		if (ioc->shost_recovery)
 			return;
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
+		phy_number = event_data->StartPhyNum + i;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if ((event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT) && (reason_code !=
+		    MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING))
 			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
-		phy_number = event_data->StartPhyNum + i;
-		reason_code = event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		link_rate_ = event_data->PHY[i].LinkRate >> 4;
 		switch (reason_code) {
 		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
