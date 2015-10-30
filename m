From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH 4/8] pm80xx: add support for ATTO devices during SAS address initiailization
Date: Fri, 30 Oct 2015 10:53:27 -0400
Message-ID: <1446216811-2248-5-git-send-email-brood@attotech.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:34813 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbbJ3Oxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:53:40 -0400
Received: by qgem9 with SMTP id m9so63091147qge.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:53:39 -0700 (PDT)
In-Reply-To: <1446216811-2248-1-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

ATTO SAS controllers retrieve the SAS address from the NVRAM in a location
different from non-ATTO PMC Sierra SAS controllers.  This patch makes the
necessary adjustments in order to retrieve the SAS address on these types
of adapters.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index feaf504..fdbfab6 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -636,6 +636,11 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			payload.minor_function = 0;
 			payload.length = 128;
 		}
+	} else if ((pm8001_ha->chip_id == chip_8070 ||
+			pm8001_ha->chip_id == chip_8072) &&
+		pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
+		payload.minor_function = 4;
+		payload.length = 4096;
 	} else {
 		payload.minor_function = 1;
 		payload.length = 4096;
@@ -662,6 +667,11 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			else if (deviceid == 0x0042)
 				pm8001_ha->sas_addr[j] =
 					payload.func_specific[0x010 + i];
+		} else if ((pm8001_ha->chip_id == chip_8070 ||
+				pm8001_ha->chip_id == chip_8072) &&
+		pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
+			pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x010 + i];
 		} else
 			pm8001_ha->sas_addr[j] =
 					payload.func_specific[0x804 + i];
-- 
2.4.3

