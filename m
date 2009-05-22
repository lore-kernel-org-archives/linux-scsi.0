From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 14/24] mpt fusion: [2.6.30-rc6] Deleted functions for Firmware event implementation using seperate WQ
Date: Fri, 22 May 2009 16:34:54 +0530
Message-ID: <20090522110447.GH16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:56027 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbZEVLZ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:25:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Fuctions which are not used are removed by this patch.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 10abd62..29a8fe2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3035,30 +3035,6 @@ mptsas_find_phyinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
 	return phy_info;
 }
 
-static struct mptsas_phyinfo *
-mptsas_find_phyinfo_by_target(MPT_ADAPTER *ioc, u8 channel, u8 id)
-{
-	struct mptsas_portinfo *port_info;
-	struct mptsas_phyinfo *phy_info = NULL;
-	int i;
-
-	mutex_lock(&ioc->sas_topology_mutex);
-	list_for_each_entry(port_info, &ioc->sas_topology, list) {
-		for (i = 0; i < port_info->num_phys; i++) {
-			if (!mptsas_is_end_device(
-				&port_info->phy_info[i].attached))
-				continue;
-			if (port_info->phy_info[i].attached.id != id)
-				continue;
-			if (port_info->phy_info[i].attached.channel != channel)
-				continue;
-			phy_info = &port_info->phy_info[i];
-			break;
-		}
-	}
-	mutex_unlock(&ioc->sas_topology_mutex);
-	return phy_info;
-}
 
 static struct mptsas_phyinfo *
 mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 channel, u8 id)
