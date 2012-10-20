From: Tom Rini <trini@ti.com>
Subject: [PATCH] [SCSI] mvsas: Fix warning in mvs_update_phyinfo
Date: Sat, 20 Oct 2012 14:11:04 -0700
Message-ID: <1350767464-3012-1-git-send-email-trini@ti.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:50099 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2JTVLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Oct 2012 17:11:12 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so761596dak.19
        for <linux-scsi@vger.kernel.org>; Sat, 20 Oct 2012 14:11:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>

In mvs_update_phyinfo we were comparing phy->identify.device_type
against enum sas_dev_type instead of enum sas_device_type

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Tom Rini <trini@ti.com>
---
 drivers/scsi/mvsas/mv_sas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a3776d6..9f91359 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1153,10 +1153,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
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
-- 
1.7.9.5

