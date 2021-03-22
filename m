Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF0EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1ACA61967
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCVIL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:11:29 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12210 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhCVILU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400680; x=1647936680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/BWKyqbb5b9YNlkuA43uMDV7ABc+VNdO2ypJNrR2us=;
  b=MogD9Mt+WF/SWPQTJ6arZ6UKv9++ZG0RzNf/KE7EvtOqIfsaZk1PNmai
   XT2uxB1eGSmfbzsUdS87sJm1CuwPwprLr/Mx8XHrXVIyOghhbfL802Qtc
   BTYAbsBVzVHaf9hDLW5lHN8BPhUAZprI4UBFaQ3JDTd8yXkeIiiUSNUuw
   TLNaYalY4EpgbQ+T6PUMtse1Q1TSEmkRHiatkE0herCyUPr937WeExHBP
   fWSPk0HPEVMCpWAYhyercoqu5oF41W1ad3EcCv5mm5s/TKlx5zg3G5Hnq
   VWUYOrtdA9A30pXCOoRV3ViDTbWippXmJj+ywDcOG5q4oRLKGd5A5DGRR
   g==;
IronPort-SDR: 9eQJMWbeBijBQd8lZoXUil5cEEknS/Y09sM7u4xqsdTIfSJo7h4EWiTWLZ93zoXfIzeZS1oo87
 gFw9TXPg4bRLOIKGhO6DDZEotqy6Q4FwBLCYMzekVhwl0mKovFzur+CxfWHkXiAiatZBC/ZYCE
 LQ2a8nbsNdycXljAAz67ya8lLrBJAzeRqHMflUFR6UVm1mRli3hn2XnrUHwE4bpt/w++m65K/S
 N7n48NAkYlITeZGh1itMOvLC+1+UkZ3UZLPLDVqILjMo8/F7ZnDUwh4sONPXdk36/GjubCFkFI
 A3Y=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="162682959"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:11:20 +0800
IronPort-SDR: gZM49Lb7UJBtaHEb+L4rU6gSL7ysabYywnwUtGcamclE9JCBWNGj4LHHmMjL1GQsUWulaqzVdB
 3Sb3eA8o1Hbss4YHlXuSviCtNNraH0Dy03yzoTKsLC5bPhW/ta9BWeYMCNU5VG/zGFPo4+qt65
 rbbfIqHWAEMThYZYbCI2JGNB0Tfh6CN8vo/N6zUP99wpqRxYdr4OAy9f5m2Yr0SpBZEvg+iro/
 Tc9FThtQLBMGxTuHncfHISocteZBDu8v111cL9oEFyND9zQrYk9LsLYZFOb0JvgjTmDKNqy6cE
 yC+hw75qPlHOTm5h8RCy4hwf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:51:49 -0700
IronPort-SDR: yQRtS1XX2u9iuBHIC5U4bv2u6GtTPupFb6bmNy+UK6RmZ3lryWv5hE6eHPE1cSZ8/68vRsPuzT
 xa7LN98fryUk+2/6itmBMxK1UxYwyQsb6W+3d2FhZ12j3CFYWYpyAJ5MVcX93Ilswhr70Bf3J8
 Ar1G4X3itRSr6H/AU+fcTfFI2SnzUeBxcQNDO6aH2Et5Xem+iEEGKFq5ChCl3we3RBh4aGzUCc
 lk/H14oLq2E+UegXxZbLIcmHF5zW2vZtveUaad7PPeKzix59dBxIINAh8nvquVu10041I4LJUE
 +6M=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:11:16 -0700
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
Subject: [PATCH v6 01/10] scsi: ufshpb: Cache HPB Control mode on init
Date:   Mon, 22 Mar 2021 10:10:35 +0200
Message-Id: <20210322081044.62003-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
index 8aca8f327981..a578927d9c59 100644
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
index 3ac8b0a9e8d3..fb10afcbb49f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1616,6 +1616,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				 % (hpb->srgn_mem_size / HPB_ENTRY_SIZE);
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2309,11 +2312,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
 	int version, ret;
-	u8 hpb_mode;
 	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
 
-	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_mode == HPB_HOST_CONTROL) {
+	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
 		dev_err(hba->dev, "%s: host control mode is not supported.\n",
 			__func__);
 		hpb_dev_info->hpb_disabled = true;
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index b1128b0ce486..7df30340386a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -228,6 +228,8 @@ struct ufshpb_lu {
 	u32 entries_per_srgn_shift;
 	u32 pages_per_srgn;
 
+	bool is_hcm;
+
 	struct ufshpb_stats stats;
 	struct ufshpb_params params;
 
-- 
2.25.1

