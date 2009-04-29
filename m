From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/1] mpt fusion: hotplug event MPTSAS_DEL_DEVICE fix
Date: Wed, 29 Apr 2009 14:50:46 +0530
Message-ID: <20090429092046.GA15870@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3mo2-old.postini.com ([64.18.14.205]:48348 "EHLO
	chip3mo2-old.postini.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751AbZD2Jkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 05:40:43 -0400
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
index b1bd68a..34e0645 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4029,6 +4029,9 @@ mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 		break;
 
 	case MPTSAS_DEL_DEVICE:
+		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+		    hot_plug_info->sas_address);
+		mptsas_del_end_device(ioc, phy_info);
 		break;
 
 	case MPTSAS_DEL_PHYSDISK:
