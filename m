Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B96AC35240
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5215720838
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nhSHxYZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBBHmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 02:42:06 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6569 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgBBHmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 02:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580629326; x=1612165326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bHc+Jw1mnzdI08P+HjK+2LM4U1g7w+7hIcYFHLqcN+M=;
  b=nhSHxYZL5lcg0T+CbXirjjo38pAMUutLyAZ0q9bVCZzysvILLZksxoAn
   T17bqJrBgff6StCAxjc9Mb81V9gDLPozHSsMppKXFeBylGkq3S01//VaU
   lRsBnKxN8uqFBf4XOxbCuknzzkEnzj8vmh/V2WOFlT4xDp/d1y4qplYaj
   /Ps3ARxGv64AnZMaJZtRLrhUd/E33YZABihio20nn6Jrt82ZjlLd+E3Hl
   JtAp7ULZaCCxpCVh0bhMy4lLcaiN0HggxYg1JTEAyWwgF9BGtsnrqK3va
   0byJ/as7gQGAqxLO7jIOG3FNYW8lifu5Kk5FoeQAWrsAXeNBvtweXkJsi
   Q==;
IronPort-SDR: 9mtTgpORPEBHum22fanWPZxDrFaCQTuNsQ3zNcTaSFq3YEUgYg6GQUuTaRKFE4xUSCpm/AZniQ
 64JQjc6yRzYKLN3p8V3N4j5jBjYtGTp5CeMqW2aDEAMSG6wk16IsJBgZ8Vz0E/druoM4MAa9oH
 6i72wJQpQOQt+dEpR85QFuGkoOil4geu0l7LeHP9vT++5lnrfejd0jflu7vwMjxyJMWhDY7Lki
 QVYBUqRAvxELtsEfRRJtwGPbmH9qFZq7eOn6gIMO+/VLzSOaTCjnSF+xKtGxdtzBQXALDtK0ZF
 oaY=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="130383379"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 15:42:06 +0800
IronPort-SDR: NVUrWjLW519BWaTvhGXdF3WKiceC2bUHKs9yJrXhMqhsiYhGQVGn7yBflAPG8at9N/XVsfLCLs
 ueSlutf/Sd7IEwbcGltvsRHkqeHha/NoqvjlNSUH66lqJes/BJpL1PltOKPPdWqBoWa/hHsHFj
 TrWWBESg8kY3jXVVyByC0OVczTqqI8S6h4bcmfSeBHYxFWiDb8Pu61C9yAr3pe4iUkpzBesNTe
 HEKAzSLg7VoLTxF+K0P4qnP95n7rdmjiu2+avmVQqhakynZzZkxNwNBvltjNO0LqhBPsF7RAtz
 qh80FgeMuT9n7b9klUqdO2EL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 23:35:12 -0800
IronPort-SDR: 3oyFRByKiRDBgSe9mpaN+GpNE1fHDiQOX0xRM04Fv+kbTjo9XFnK4Zyj6HiZVPr+LcD2drWTtf
 4hFwPs1bNZOJ4mcPhbm1rFv61e4/Xb1rLfbBlMxKozw4ABXdgsdTWxO94b1yGk3x2+NE/VHHEy
 KaUkdqidN00za7wKeLxKWbgUNELxm5YzKmF6GvsVM2Bn4s+5avMDM/d2pCHyf7usWgj5BDEC7M
 aG3YGj64hafO83k+fA1F8I+PCxJjwcZEfKrKJ68dNaGCr6xGER6TpQ/UdbTPNUxAPYofPyz/6n
 qkQ=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Feb 2020 23:42:04 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Avi Shchislowski <avi.shchislowski@sandisk.com>,
        Uri Yanai <uri.yanai@wdc.com>
Subject: [PATCH 3/5] scsi: ufs: enable thermal exception event
Date:   Sun,  2 Feb 2020 09:41:51 +0200
Message-Id: <1580629313-20078-4-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Avi Shchislowski <avi.shchislowski@sandisk.com>

The host might need to be aware of the device's temperature, when it's
too high or too low. Should such event occur, the device is expected
to notify it to the host by using the exception event mechanism.

E.g. when TOO_HIGH_TEMP in wExceptionEventStatus is raised, it is
recommended to perform thermal throttling or other cooling activities
for lowering the device Tcase temperature. Similarly, when
TOO_LOW_TEMP is raised, it is recommended to take an applicable
actions to increase the device’s Tcase temperature.

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
---
 drivers/scsi/ufs/ufs-thermal.c | 28 ++++++++++++++++++++++++----
 drivers/scsi/ufs/ufs-thermal.h |  6 ++++++
 drivers/scsi/ufs/ufs.h         |  6 +++++-
 drivers/scsi/ufs/ufshcd.c      |  4 ++++
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-thermal.c b/drivers/scsi/ufs/ufs-thermal.c
index 469c1ed..dfa5d68 100644
--- a/drivers/scsi/ufs/ufs-thermal.c
+++ b/drivers/scsi/ufs/ufs-thermal.c
@@ -19,11 +19,32 @@ enum {
 
 /**
  *struct ufs_thermal - thermal zone related data
- * @tzone: thermal zone device data
+ * @trip: trip array
  */
 static struct ufs_thermal {
 	struct thermal_zone_device *zone;
-} thermal;
+	int trip[UFS_THERM_MAX_TRIPS];
+} thermal = {
+		.trip = {
+			[UFS_THERM_MAX_TEMP] = 170 * 1000,
+			[UFS_THERM_MIN_TEMP] = -79 * 1000
+		}
+};
+
+void ufs_thermal_exception_event_handler(struct ufs_hba *hba,
+		u32 exception_status)
+{
+	if (WARN_ON_ONCE(!hba->thermal_features))
+		return;
+
+	if (exception_status & MASK_EE_TOO_HIGH_TEMP) {
+		thermal_notify_framework(thermal.zone, UFS_THERM_HIGH_TEMP);
+		dev_info(hba->dev, "High temperature raised\n");
+	} else if (exception_status & MASK_EE_TOO_LOW_TEMP) {
+		thermal_notify_framework(thermal.zone, UFS_THERM_LOW_TEMP);
+		dev_info(hba->dev, "Low temperature raised\n");
+	}
+}
 
 static  struct thermal_zone_device_ops ufs_thermal_ops = {
 	.get_temp = NULL,
@@ -33,8 +54,7 @@ enum {
 
 static int ufs_thermal_enable_ee(struct ufs_hba *hba)
 {
-	/* later */
-	return -EINVAL;
+	return ufshcd_enable_ee(hba, MASK_EE_URGENT_TEMP);
 }
 
 static void ufs_thermal_zone_unregister(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufs-thermal.h b/drivers/scsi/ufs/ufs-thermal.h
index 7c0fcbe..285049e 100644
--- a/drivers/scsi/ufs/ufs-thermal.h
+++ b/drivers/scsi/ufs/ufs-thermal.h
@@ -11,9 +11,15 @@
 #ifdef CONFIG_THERMAL_UFS
 void ufs_thermal_remove(struct ufs_hba *hba);
 int ufs_thermal_probe(struct ufs_hba *hba);
+void ufs_thermal_exception_event_handler(struct ufs_hba *hba,
+		u32 exception_status);
 #else
 static inline void ufs_thermal_remove(struct ufs_hba *hba) {}
 static inline int ufs_thermal_probe(struct ufs_hba *hba) {return 0; }
+void ufs_thermal_exception_event_handler(struct ufs_hba *hba,
+		u32 exception_status)
+{
+}
 #endif /* CONFIG_THERMAL_UFS */
 
 #endif /* UFS_THERMAL_H */
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index eb729cc..8fc0b0c 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -363,7 +363,9 @@ enum power_desc_param_offset {
 /* Exception event mask values */
 enum {
 	MASK_EE_STATUS		= 0xFFFF,
-	MASK_EE_URGENT_BKOPS	= (1 << 2),
+	MASK_EE_URGENT_BKOPS	= BIT(2),
+	MASK_EE_TOO_HIGH_TEMP	= BIT(3),
+	MASK_EE_TOO_LOW_TEMP	= BIT(4),
 };
 
 /* Background operation status */
@@ -375,6 +377,8 @@ enum bkops_status {
 	BKOPS_STATUS_MAX		 = BKOPS_STATUS_CRITICAL,
 };
 
+#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
+
 /* UTP QUERY Transaction Specific Fields OpCode */
 enum query_opcode {
 	UPIU_QUERY_OPCODE_NOP		= 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f25b93c..45fb52d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -42,6 +42,7 @@
 #include <linux/nls.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/thermal.h>
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -5183,6 +5184,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & MASK_EE_URGENT_BKOPS)
 		ufshcd_bkops_exception_event_handler(hba);
 
+	if (status & MASK_EE_URGENT_TEMP)
+		ufs_thermal_exception_event_handler(hba, status);
+
 out:
 	ufshcd_scsi_unblock_requests(hba);
 	pm_runtime_put_sync(hba->dev);
-- 
1.9.1

