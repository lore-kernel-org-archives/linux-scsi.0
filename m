Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93781C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AEFE6108B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbhGLJx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:53:57 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4433 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240930AbhGLJx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083469; x=1657619469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=amOe7Gjyt1Hh4vZjAlxnOwqPeqfJ7P/2zsBae3fm2cQ=;
  b=rqY+lFcT6PZf2Wh4yzz5bEgOogTkgqGmvr/D50B0hYwCVckRIfXjjRj2
   8XCIXQVwyThR00Mi15HANmvrTf/1mo2tQ8pK/mBlhjj6kEcoHk87rY6tH
   /PnG1o5v3EDxzrd1DSmM0d+rRAhvbLbbY54EPZ3CDWcS4fD86V72IWC/7
   DQJovjNOvRvEMw9WeF0fWQq+qL76lda15NSUdg7VpLPSPgvx2qFQkITJT
   jvMrWsqsDeQY8cNRc4KGQfNeV6OOL+u4Qa0CLJe8l4cLLCUD2GPR0YEq/
   cgJqQweX5HsposoS0fQSWmw86vo3HqcdBkgvwZQzwYHvSB/uhhNLpM0fc
   A==;
IronPort-SDR: zV3ddZr7x68K0hFd8Sl/U2OTR7WPjeRYRjDw784pjXNKw1fxq2BPAqeKoxqTaPLIMEW2P8pJMM
 JCAtCfM0kwOWnfKrubv8GKAXzXnwPzI5qki6J70kgf75m0Ekcq+qge7CDFZK+nuLvu170ItGTP
 kldMLcI8K6H5lq9yFJ/duH2s7kmrRl1p9TJpsWjF5U0G68WeA4LgOuZZLeCGrX6wO62HzuBzLD
 pDgFM3e2JSDhd4yMSYE5BlC/cQ+HnfTdGp4nILpkSwyvTOyhgKm7KTBrJLv34EJ5Y/A95yixqD
 FM0=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="173586753"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:51:08 +0800
IronPort-SDR: +CKcCqKCHC1juuCDBouj+Pexe9gfqPNtuOm1WFqcoXo+l/ccRN3Z95uh5TkhjeWEzWbey7mj9W
 TLIAzdtNLNM6xolOga55JWYrRxmd4dtjYu7aWQVTkVisn26LKn+LkWtpmiUfWDecn1gMtOlMrM
 EBJ/lbQx2t84tkfBvEA65z0usO9M2OpOhWB88DuvqwizICBMU3sjhYugw9xumt0I/NldS0UfAB
 fU66rF6TqKcpQkgoYrKsCW4rBXV9jnJcTueQJcItUhvn0hsMsRjqZL98i8OljG4yAmRo4G2xm2
 LZ6V0+zmeyiXU5klzdJsGBSJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:29:16 -0700
IronPort-SDR: Hvt3VZoO4YZpiRP0KwufuGdATWZrcjByULYpOKyf6kwFFwbN7cIdEldmCzOCTjbqR0TOK32Pcw
 s9qIlvLhTpCs6KeOvhe96QEyeYQqYxy+PNE6rqLVxsY3R+6oRlVgkojTQ2iHSk0TDTsq25EyPU
 5yWZLg+ctwe69a6KRV1qcD07C1vw+QUOP79G9r4tz6JOyx2oWVFQ9feEjjBp2MhZ2r4WYMSCRW
 kOgpa22pBVvWTQw8o/kYjfPGdx8HBY9RymiP+WuZRe06/iMCBNIeByoN2IpgXWXZ/C5bUTD6mK
 JW8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:51:04 -0700
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
Subject: [PATCH v12 01/12] scsi: ufshpb: Cache HPB Control mode on init
Date:   Mon, 12 Jul 2021 12:50:28 +0300
Message-Id: <20210712095039.8093-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We will use it later, when we'll need to differentiate between device
and host control modes.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.h | 2 ++
 drivers/scsi/ufs/ufshpb.c | 8 +++++---
 drivers/scsi/ufs/ufshpb.h | 2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 90aad8393572..0b4496c1af64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -652,6 +652,7 @@ struct ufs_hba_variant_params {
  * @hpb_disabled: flag to check if HPB is disabled
  * @max_hpb_single_cmd: device reported bMAX_DATA_SIZE_FOR_SINGLE_CMD value
  * @is_legacy: flag to check HPB 1.0
+ * @control_mode: either host or device
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -661,6 +662,7 @@ struct ufshpb_dev_info {
 	bool hpb_disabled;
 	u8 max_hpb_single_cmd;
 	bool is_legacy;
+	u8 control_mode;
 };
 #endif
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index f417fb89174f..c6fa9cee683a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1608,6 +1608,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				 % (hpb->srgn_mem_size / HPB_ENTRY_SIZE);
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2301,11 +2304,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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
index 1e8d6e1d909e..dc168ba08a09 100644
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

