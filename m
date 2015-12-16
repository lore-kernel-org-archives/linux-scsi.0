From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 08/17] lpfc: Fix RDP Speed reporting.
Date: Wed, 16 Dec 2015 18:11:59 -0500
Message-ID: <5671efbf.h8YAdmlPeIEJ3AcO%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34861 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252AbbLPXMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:18 -0500
Received: by mail-pa0-f41.google.com with SMTP id jx14so2182282pad.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:18 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id e14sm11414352pap.24.2015.12.16.15.12.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix RDP Speed reporting.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3394648..f7a2967 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4730,28 +4730,25 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 	desc->tag = cpu_to_be32(RDP_PORT_SPEED_DESC_TAG);
 
-	switch (phba->sli4_hba.link_state.speed) {
-	case LPFC_FC_LA_SPEED_1G:
+	switch (phba->fc_linkspeed) {
+	case LPFC_LINK_SPEED_1GHZ:
 		rdp_speed = RDP_PS_1GB;
 		break;
-	case LPFC_FC_LA_SPEED_2G:
+	case LPFC_LINK_SPEED_2GHZ:
 		rdp_speed = RDP_PS_2GB;
 		break;
-	case LPFC_FC_LA_SPEED_4G:
+	case LPFC_LINK_SPEED_4GHZ:
 		rdp_speed = RDP_PS_4GB;
 		break;
-	case LPFC_FC_LA_SPEED_8G:
+	case LPFC_LINK_SPEED_8GHZ:
 		rdp_speed = RDP_PS_8GB;
 		break;
-	case LPFC_FC_LA_SPEED_10G:
+	case LPFC_LINK_SPEED_10GHZ:
 		rdp_speed = RDP_PS_10GB;
 		break;
-	case LPFC_FC_LA_SPEED_16G:
+	case LPFC_LINK_SPEED_16GHZ:
 		rdp_speed = RDP_PS_16GB;
 		break;
-	case LPFC_FC_LA_SPEED_32G:
-		rdp_speed = RDP_PS_32GB;
-		break;
 	default:
 		rdp_speed = RDP_PS_UNKNOWN;
 		break;
-- 
1.7.11.7

