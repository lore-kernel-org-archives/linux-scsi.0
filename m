From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 24/24] mpt fusion: [2.6.30-rc6] hotplug event MPTSAS_DEL_DEVICE fix
Date: Fri, 22 May 2009 16:42:28 +0530
Message-ID: <20090522111220.GR16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:33905 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZEVLdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:33:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


This is a fix for hotplug remove event.
Added code which will remove device on receiving MPTSAS_DEL_DEVICE event.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5562894..5b88a25 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4028,6 +4028,9 @@ mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 		break;
 
 	case MPTSAS_DEL_DEVICE:
+		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+		    hot_plug_info->sas_address);
+		mptsas_del_end_device(ioc, phy_info);
 		break;
 
 	case MPTSAS_DEL_PHYSDISK:
