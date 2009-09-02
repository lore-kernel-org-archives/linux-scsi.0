From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/6] mptsas : Sanity check for phyinfo is added
Date: Wed, 2 Sep 2009 11:43:36 +0530
Message-ID: <20090902061328.GB20211@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:37561 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZIBGgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 02:36:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


Check for phyinfo->phy before calling sas_port_delete_phy.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 21bd78e..f744f0f 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -852,7 +852,13 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		port_details->num_phys--;
 		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
-		sas_port_delete_phy(port_details->port, phy_info->phy);
+		if (phy_info->phy) {
+			devtprintk(ioc, dev_printk(KERN_DEBUG,
+				&phy_info->phy->dev, MYIOC_s_FMT
+				"delete phy %d, phy-obj (0x%p)\n", ioc->name,
+				phy_info->phy_id, phy_info->phy));
+			sas_port_delete_phy(port_details->port, phy_info->phy);
+		}
 		phy_info->port_details = NULL;
 	}
 
