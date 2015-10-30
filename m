From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH 2/8] pm80xx: add support for PMC Sierra 8070 and PMC Sierra 8072 SAS controllers
Date: Fri, 30 Oct 2015 10:53:25 -0400
Message-ID: <1446216811-2248-3-git-send-email-brood@attotech.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34793 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbJ3Oxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:53:37 -0400
Received: by qkcn129 with SMTP id n129so31673807qkc.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:53:36 -0700 (PDT)
In-Reply-To: <1446216811-2248-1-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

These SAS controllers support speeds up to 12Gb.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
 drivers/scsi/pm8001/pm8001_defs.h | 2 ++
 drivers/scsi/pm8001/pm8001_init.c | 4 +++-
 drivers/scsi/pm8001/pm8001_sas.h  | 4 +++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index f14ec6e..199527d 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -51,6 +51,8 @@ enum chip_flavors {
 	chip_8076,
 	chip_8077,
 	chip_8006,
+	chip_8070,
+	chip_8072
 };
 
 enum phy_speed {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 8c094fd..2106ac3 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -58,6 +58,8 @@ static const struct pm8001_chip_info pm8001_chips[] = {
 	[chip_8076] = {0,  16, &pm8001_80xx_dispatch,},
 	[chip_8077] = {0,  16, &pm8001_80xx_dispatch,},
 	[chip_8006] = {0,  16, &pm8001_80xx_dispatch,},
+	[chip_8070] = {0,  8, &pm8001_80xx_dispatch,},
+	[chip_8072] = {0,  16, &pm8001_80xx_dispatch,},
 };
 static int pm8001_id;
 
@@ -1234,7 +1236,7 @@ MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
 MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
 MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
 MODULE_DESCRIPTION(
-		"PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077 "
+		"PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077/8070/8072 "
 		"SAS/SATA controller driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index e2e97db..9fa9705 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -106,7 +106,9 @@ do {						\
 #define DEV_IS_EXPANDER(type)	((type == SAS_EDGE_EXPANDER_DEVICE) || (type == SAS_FANOUT_EXPANDER_DEVICE))
 #define IS_SPCV_12G(dev)	((dev->device == 0X8074)		\
 				|| (dev->device == 0X8076)		\
-				|| (dev->device == 0X8077))
+				|| (dev->device == 0X8077)		\
+				|| (dev->device == 0X8070)		\
+				|| (dev->device == 0X8072))
 
 #define PM8001_NAME_LENGTH		32/* generic length of strings */
 extern struct list_head hba_list;
-- 
2.4.3

