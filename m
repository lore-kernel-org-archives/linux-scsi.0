Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC54C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B52864EE3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhBZIgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:36:04 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:39220 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhBZIfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328544; x=1645864544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HuKopAmtZwRPVpGHpcGACb+Y7NLgWAIBGyq4VY5jfiY=;
  b=pxtjNZomnxgnoKB48sv1tIwy17TdXL24xt1trVud+AIvih+UH0JvLz4B
   5caKcyv19V06ZJK8iJ2T80ojH+abWNYs7EqvZGEq6cPC8skcfCKxxE/zv
   UpkoEm3PsJc6dK/H45J2YwhFKidy8Kaa5vfrEhtCDGfJQuQhW1NjtA8QT
   Pz7C6a7DgRW3RVBMErAMfjhAA8R20eZhKcGC1VTQNfMdV2sv4/nMkYlk8
   G4Rep+QA4qhXB+ru5P41AM+b+XhczYf3RFq/vKykx4lM4DJeVa5FetYeh
   z40CCj6+sgKcZKn95CUF9A2rRSNhHNMvEFX8FcCHMiUWI/Z6+IEK+wIMa
   w==;
IronPort-SDR: /xgVILq5vLN2WlCCY+NYy0cI1dsJ8foniQer4mDrOnynKjBDhn2Tjmrv+jv0mr+ubBOHUa4xFo
 4IjWFJ9zdAiAi8LO59PT2Uf7JQWSdk+nuBiPUrKqTuRPZOWgjJyu/ZCKmJXJlCpaUT9ItMpjlQ
 smkjm4R14vIohajtQT6FBr9CNmDhl8qTKpIrrhYBIttcoHzm11EIfCK6SXRpsJanv+ttFwNhN5
 0nKJUFVI4kUHffPmXueC7SMV3Hh8iuhiK6HVlhMnHoxWJlkfjVmjQA3rKlSVYHBYh3c7COmlPL
 xk0=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="162040949"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:33:46 +0800
IronPort-SDR: 52PAIyz0AtIuVd84ny3LYsRuroo5xSCXt3hdwtDDzSbrjk7LyDstYzxQ94Rz3TFePiMei/Kl4g
 Zk3mDFPN3R3k8H2gPxiYWsqbwm2r1ZDc0yx7V88SXtI8gnqw5lhJaDM7CjTlmSlvrbL1JIFm3v
 s8Lfu52zGr9a0vD18OjgJiD6hfDex75ykjD9rMfRvSm/AhhYx11Vr+hkslJdkKGUXw/ES1HE0Y
 UtjkqZ/UlDO7odQfQLqUkGCPDukFOVjVpsUgmHSnpHqkUO6oa6OR7zYwoa505dfcMWpoJUHV25
 sR5hRb/b26scu/HqJ1sC1sVs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:15:07 -0800
IronPort-SDR: aMA30q+zpn9MybJj3SdjBgJPrbvF8vw+MCeqrOuAQohi4OoK7LzoFkTAXJUy97kwc98PBYm7zR
 ov5m6HQeNCd8EDTnpfSD2w8N/+RCHdn2MfXda6NwMXuSgsTDS7yJKpll9prgX/wGNKk+GgAYO2
 XN+Jodn+OOxewrNnSckVI31Qaxk0vWbmQ7KVdg11Kqi/IBawCFCxg7CIiXyTkCUIjmZ+DDhE0/
 8dhCMd967S3x+D5jwJBXXG9tONiwPruoeyWy/5g+XKMvowCi5HyoxBGVUxKyxnlwRmKohepo97
 3GQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:33:42 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 1/9] scsi: ufshpb: Cache HPB Control mode on init
Date:   Fri, 26 Feb 2021 10:32:52 +0200
Message-Id: <20210226083300.30934-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We will use it later, when we'll need to differentiate between device
and host control modes.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.h | 2 ++
 drivers/scsi/ufs/ufshpb.c | 8 +++++---
 drivers/scsi/ufs/ufshpb.h | 2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 3ea7e88f5bff..2d589ee18875 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -656,6 +656,7 @@ struct ufs_hba_variant_params {
  * @hpb_disabled: flag to check if HPB is disabled
  * @max_hpb_single_cmd: maximum size of single HPB command
  * @is_legacy: flag to check HPB 1.0
+ * @control_mode: either host or device
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -665,6 +666,7 @@ struct ufshpb_dev_info {
 	bool hpb_disabled;
 	int max_hpb_single_cmd;
 	bool is_legacy;
+	u8 control_mode;
 };
 #endif
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index f89714a9785c..d9ea0cddc3c4 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1624,6 +1624,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				 % (hpb->srgn_mem_size / HPB_ENTRY_SIZE);
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2308,11 +2311,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
 	int version, ret;
-	u8 hpb_mode;
 	u32 max_hpb_sigle_cmd = 0;
 
-	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_mode == HPB_HOST_CONTROL) {
+	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
 		dev_err(hba->dev, "%s: host control mode is not supported.\n",
 			__func__);
 		hpb_dev_info->hpb_disabled = true;
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 88f424250dd9..14b7ba9bda3a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -227,6 +227,8 @@ struct ufshpb_lu {
 	u32 entries_per_srgn_shift;
 	u32 pages_per_srgn;
 
+	bool is_hcm;
+
 	struct ufshpb_stats stats;
 	struct ufshpb_params params;
 
-- 
2.25.1

