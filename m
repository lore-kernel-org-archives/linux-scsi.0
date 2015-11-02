From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH v2 4/9] pm80xx: add support for ATTO devices during SAS address initiailization
Date: Mon,  2 Nov 2015 15:39:23 -0500
Message-ID: <1446496763-1930-1-git-send-email-brood@attotech.com>
References: <CAD+HZHWhNFDq4z_MLaSNyY9jV-9Ub2ywtuT7wraRGo=FiNFRqA@mail.gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34039 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbKBUj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 15:39:27 -0500
Received: by qkcn129 with SMTP id n129so63474613qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 12:39:27 -0800 (PST)
In-Reply-To: <CAD+HZHWhNFDq4z_MLaSNyY9jV-9Ub2ywtuT7wraRGo=FiNFRqA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com, hare@suse.de
Cc: Benjamin Rood <brood@attotech.com>

ATTO SAS controllers retrieve the SAS address from the NVRAM in a location
different from non-ATTO PMC Sierra SAS controllers.  This patch makes the
necessary adjustments in order to retrieve the SAS address on these types
of adapters.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
Changes from v1 -> v2:
	-Fixed indentation issues noted by Hannes and Jack

 drivers/scsi/pm8001/pm8001_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index feaf504..861416f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -636,6 +636,11 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			payload.minor_function = 0;
 			payload.length = 128;
 		}
+	} else if ((pm8001_ha->chip_id == chip_8070 ||
+			pm8001_ha->chip_id == chip_8072) &&
+			pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
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
+				pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
+			pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x010 + i];
 		} else
 			pm8001_ha->sas_addr[j] =
 					payload.func_specific[0x804 + i];
-- 
2.4.3

