From: Kyle McMartin <kyle@infradead.org>
Subject: [PATCH trivial] mvsas: fix build warning about enum comparisons
Date: Tue, 7 May 2013 12:57:04 -0400
Message-ID: <20130507165704.GB20643@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42343
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab3EGQ5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 12:57:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: yuxiangl@marvell.com, JBottomley@Parallels.com

device_type is a sas_device_type, not a sas_dev_type.

  1 drivers/scsi/mvsas/mv_sas.c: In function 'mvs_update_phyinfo':                                                                             
  2 drivers/scsi/mvsas/mv_sas.c:1162:34: warning: comparison between
'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]           
  3     if (phy->identify.device_type == SAS_END_DEV)                                                                                          
  4                                   ^                                                                                                        
  5 drivers/scsi/mvsas/mv_sas.c:1165:39: warning: comparison between
'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]           
  6     else if (phy->identify.device_type != NO_DEVICE) 

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1159,10 +1159,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 			phy->identify.device_type =
 				phy->att_dev_info & PORT_DEV_TYPE_MASK;
 
-			if (phy->identify.device_type == SAS_END_DEV)
+			if (phy->identify.device_type == SAS_END_DEVICE)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SSP;
-			else if (phy->identify.device_type != NO_DEVICE)
+			else if (phy->identify.device_type != SAS_PHY_UNUSED)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SMP;
 			if (oob_done)
