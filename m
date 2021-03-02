Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8F1C4321A
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E528464F1E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581462AbhCBS51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:57:27 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17300 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346410AbhCBNa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614692439; x=1646228439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HuKopAmtZwRPVpGHpcGACb+Y7NLgWAIBGyq4VY5jfiY=;
  b=J3jGcCUd7r92zMNI2AiQP7EEL5Kunc9TaSPBe+TPMe/JdJCicIM8CoUv
   Olu6KWDybAmuAzO2it/32eZ/XvcJ5e03mzxO4pnwpqqBSKbl4Ruv0b/GL
   hocQXqqyMQXmsPyhCbPyUZhCpv/jVaNRTL+HZLqB685fc8LOP3dqfeCGg
   FJ7MWZffVJjr7tOnCm83gp7EsU8wrssHWEawVrr/U+K+jUhiCVgGHKn3y
   GEIf6RT6mCN+stbxAkoFFPTuDUCVnhHp1zLxxnrNm02Fs/VaS2suN+GSH
   REC+VM/LjRFOnX682VcutMcdLq3awrU6txhnR1n/2dZ29D+bHDqrPvC4w
   w==;
IronPort-SDR: nHQhqJh9+44d7Sj5A4ye366SBZo93g3fqgyHNmbkY9SwQKdGAjr0Qdy6xm6jBjcR8DpyhRXQkm
 h38mRG02FVz8JTTjSxGO2PffLKZMCTiTBBdu1nnUTTKiZVnu35IZRSR3MO6LqmoQVR3Eyq01xG
 d6EAz0g4CsvIGl0S4PThOyObPqbO/NI9qNBZF71T7NCIeh2XAIrPHoQbVj1PzSZlp6GNuUmug1
 r1pwiEBgPc6B51RRhVRvRpyF4sdtJ+LONz5wZn+xQFgA8W1XsEBscRivUYm8Lwk40dxXcYQT1Z
 TDQ=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="265440466"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:33:12 +0800
IronPort-SDR: OLnR+3crMIW9uPhMecK2f+rmMvvCPCKFEbgciLaTeesxQ4/I5CUzZP4ZgtH8HWv1BatI5tAxoa
 hD+RuKqtKZr5kdvga7pIWKPo8IHIKFlpuSNMMAJSzuT1aYTMUsdKO3l8ii10GAFmS2Ny+7yoA0
 3tHN3OTATxbXbTRjYspFmz+tEHpnSuXp5hSy4fXUcrDKoOTVyM2/BK1dPRGFXMdx4jRU8uzc0m
 a1MbQk2T6GJ2F1i2UqeSdsRk4qtSQmSXM/KOXHu3tExkJC+ncqwNV/Gjmae6IQFmVlNXHbMxap
 OxGTgWztbTSJ7XErT2DGcDqT
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:07:16 -0800
IronPort-SDR: meUvMjd0HbYVRjQvVDPKmc7dndQndmcu/+LSOSAqBi9D6drh0Je4M4Ih1Y4YH7ddhDK1/OPCP/
 CeeDKgE91Z9yH4NopwRoUWjHL4sTCl3JGoxwYyCCz12dEKwgwHn4bN7V2ZOZn14aouma6ie7Na
 Te2QBAdWv4RDDvtNoUe6xJ+awJ3TQOujxhA8n4rxkehfJqH6shzoIT7Vj1BloYza6hggP39mvx
 8e6691eSup5hx635SvC8VEsZyfSrQ/dnlCL8XaBRnR+gBlRzqKq0oIcYfhZAgDMEXn4I5NumwC
 m3s=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:25:57 -0800
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
Subject: [PATCH v5 01/10] scsi: ufshpb: Cache HPB Control mode on init
Date:   Tue,  2 Mar 2021 15:24:54 +0200
Message-Id: <20210302132503.224670-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
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

