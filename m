Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229D6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 12:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBEC961288
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 12:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbhKHMLa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 07:11:30 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36512 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbhKHMLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 07:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636373314; x=1667909314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=y9dAdITeyho9JZ1fdEyHwV0AKFYcnTmIurhlclr4oDg=;
  b=PbaHruflHsnWHQjwahcPdNSoP3o37y0QX4p79/Fpn5nmvdwiwr3sGq7T
   ec7hu3Vh6yku5miVvPCRO4JemJqFL1gGRh7I84gCXq7zMcaNoZDpzhfMf
   bMjgWuX50DLQbbtrR+ikUcSH34+Aq/VxgFeL44UA2+UcRvmsS296ni9nQ
   EdsWZ3fzCVySWSLB0TJbrOYkpYSQCtyCy3dfASijfH+5ibsw05MtYY3du
   fINRsfxK/qdyL2IIZ+JJSwcAtHoQoQWuHA4FXD8jOrLjDWWW/EublcTeU
   xPN0r5vffwr1soPPcVexILduxkD5I7wm7EiqMzqWNSwurSX97aGkEaBV/
   g==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="288933027"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2021 20:08:31 +0800
IronPort-SDR: 58FB5O1OXNrfzMxLS45F6d15rZ/Pn7Zxp01iXaoVZdkurvYu84sANDH4ZYLT1hyVUhfXRWCrzt
 4ty7uKDT8J1P8klWD+Vxy1qFJHYIhoz+i/PMVhGfYiY3b86mjXkzsoot0aua7O2DUKU3bsS3sW
 0diYsY6ggTtue8wqULB1SnIRZb6IWcPAqg6AdJ5S+If+E/QCBoAbtmamEbJ+aFe0n1O4Ykw3aL
 JCRyk6hMahB/9pCRxp+3HmW+EywfVQKyLamvprof5kF4lCUeJIyoGMmTUvkmpFY7QsM/aM9raT
 j7M1x2qLKMl2KNAsPcL9dz3a
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 03:42:11 -0800
IronPort-SDR: 7CebQx7aIiRd3kBjxMLuIyQ7jqLicBpcCK/Oa92jA5UZiX2kpJ4sik+PDxevCw3jUFw3894Gs8
 D69oKov6mxdAoj/4CclV78Vhm/CGJAwZujNtJT5Gt6xW6s178AGQ2EYCDXQTuMh7v0doGIvLMD
 BvB578mzM3BJEyiC3RXHv8V33H6DJCEuGyjmwuhgQIWE0lddSTqVapbUQUFkPhF+8vkbLDlBuS
 ZCmUX2ZWuMKagZNs9XR3IMkhf8PkxEAwEkzwa4vyloUy6fa7lj0DagtQzYMSpfzG8vW7FUeVtK
 0PA=
WDCIronportException: Internal
Received: from c8jqy33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.157])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2021 04:08:28 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/2] scsi: ufs: Inline eh-in-progress states
Date:   Mon,  8 Nov 2021 14:08:03 +0200
Message-Id: <20211108120804.10405-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211108120804.10405-1-avri.altman@wdc.com>
References: <20211108120804.10405-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve the static type checking.
while at it, do not allow user-space access if eh-in-progress.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ------------
 drivers/scsi/ufs/ufshcd.h | 26 +++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 470affdec426..3869bb57769b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -140,11 +140,6 @@ static const char *const ufshcd_state_name[] = {
 	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_non_fatal",
 };
 
-/* UFSHCD error handling flags */
-enum {
-	UFSHCD_EH_IN_PROGRESS = (1 << 0),
-};
-
 /* UFSHCD UIC layer error flags */
 enum {
 	UFSHCD_UIC_DL_PA_INIT_ERROR = (1 << 0), /* Data link layer error */
@@ -156,13 +151,6 @@ enum {
 	UFSHCD_UIC_PA_GENERIC_ERROR = (1 << 6), /* Generic PA error */
 };
 
-#define ufshcd_set_eh_in_progress(h) \
-	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
-#define ufshcd_eh_in_progress(h) \
-	((h)->eh_flags & UFSHCD_EH_IN_PROGRESS)
-#define ufshcd_clear_eh_in_progress(h) \
-	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
-
 struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
 	[UFS_PM_LVL_0] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
 	[UFS_PM_LVL_1] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4ceb3c7e65b4..c5d98052a20a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -992,9 +992,33 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
 
+/* UFSHCD error handling flags */
+enum {
+	UFSHCD_EH_IN_PROGRESS = (1 << 0),
+};
+
+static inline void ufshcd_set_eh_in_progress(struct ufs_hba *hba)
+{
+	lockdep_assert_held(hba->host->host_lock);
+
+	hba->eh_flags |= UFSHCD_EH_IN_PROGRESS;
+}
+
+static inline void ufshcd_clear_eh_in_progress(struct ufs_hba *hba)
+{
+	lockdep_assert_held(hba->host->host_lock);
+
+	hba->eh_flags &= ~UFSHCD_EH_IN_PROGRESS;
+}
+
+static inline bool ufshcd_eh_in_progress(struct ufs_hba *hba)
+{
+	return hba->eh_flags & UFSHCD_EH_IN_PROGRESS;
+}
+
 static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 {
-	return !hba->shutting_down;
+	return !hba->shutting_down && !ufshcd_eh_in_progress(hba);
 }
 
 #define ufshcd_writel(hba, val, reg)	\
-- 
2.17.1

