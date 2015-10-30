From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH 6/8] pm80xx: do not examine registers for iButton feature if ATTO adapter
Date: Fri, 30 Oct 2015 10:53:29 -0400
Message-ID: <1446216811-2248-7-git-send-email-brood@attotech.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:33505 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642AbbJ3Oxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:53:43 -0400
Received: by qgeo38 with SMTP id o38so63665091qge.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:53:42 -0700 (PDT)
In-Reply-To: <1446216811-2248-1-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

ATTO adapters do not support this feature.  If the firmware fails to be
ready, it should not check the examined registers in order to examine
the state of the feature in order to prevent undefined behavior.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 29c548b..eb4fee6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1267,6 +1267,8 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 		/* check iButton feature support for motherboard controller */
 		if (pm8001_ha->pdev->subsystem_vendor !=
 			PCI_VENDOR_ID_ADAPTEC2 &&
+			pm8001_ha->pdev->subsystem_vendor !=
+			PCI_VENDOR_ID_ATTO &&
 			pm8001_ha->pdev->subsystem_vendor != 0) {
 			ibutton0 = pm8001_cr32(pm8001_ha, 0,
 					MSGU_HOST_SCRATCH_PAD_6);
-- 
2.4.3

