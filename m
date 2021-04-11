Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B10C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B449611C2
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbhDKG2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:19 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47893 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhDKG2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122498; x=1649658498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N8NWw71q4aSE7f87UU28NQUoPYbfY8JCnxG3yVRDbPA=;
  b=eSgfZRVjuyDi7bREdEqEfz8IiKv30Hy04ncVC8DvR4J2qetPOTuJ8yFi
   YYHHl/ksRdGzps+weepq1TAQPGjZL2xK0uDHs3h9IjIGKuohZx90Gz8u8
   paiTQ/IpWysdcMx3I1EAqjrt4tR/OqmWMSdK9JHLOEiQRmgTYafSEjUyJ
   obqxJKkNr0SKJ+t7W1RC/2fv64lPIT2TdTN+qcR0to6VVpVCRywqePw10
   HNat0Ph3p4s83KKG5KB3ddGmkt/tskc3XnkavdBbVTkxkvFwdve5xdtRq
   R2CypPD49ziqwrQIiav8qXNJtdROOjRjddfzESHNx7VEmpxR/o63S1gnP
   w==;
IronPort-SDR: CSi6FTE5CgSWU5QwWTKk53p8MvG0cyWXKbb8N1QM8GCdsE5IJu4bVh4fy3KKlPsVLxXtOLVnh4
 EcR0nMbiih0QovRnfPpcfaLKZfRGlC2QRIJCD5CZmywT3T3BZig8kRYla9WQptuG9NMIEOU79t
 nLmv7i0ITDn8Oho0MOq+hYmbsgXbYHmVibcgJiALEUt0bA35fxyfVCeOo650q+zXVjPQC2acZ8
 vHpnyn2Nrlod2hxASUIylbHedMXoCufNnwmJw+toBCrDLcIQHCiOifJwi2X1/ej4UC+im0nvhV
 ByE=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="268668860"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:01 +0800
IronPort-SDR: KtQUvaW92ZHOzz50GJqIqI2YZFKUiP6inkyJ6ZawZh7LEdDnzof4ci+9cAvFPjtLlqSBbxK1vE
 ntQrPEQ6c0a6MdmOLVFpeZCfPzR+9Wmkg9Vs2kWX/+yDdWGmNGl53fHr1LfMRaZ9QCJfcXHKvQ
 x3xZ9A9K4Rpc8aWtA5ok1ilHvKIQqtirAh92dtLyg3D6Q5vmtx3U5EOlEProGAGymW9WCc/oIT
 S5mimEyJLW+S9SvdAqbymW6QXPN5YmpRNnJI1smTQOA47kMqkJ4O78wiKj8aaj8QAI1iekzrqO
 cNzD7C8pIurvUb+0XWOliwuk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:08:54 -0700
IronPort-SDR: 4g2SHL03z4wlJcO8d4k29dRsNDoDzcvYS89DYTdlA4teTExZCOC9ompE1U/Pdzce2+WL3yqXHy
 NGTepYpOzUXMY/P2EgRKH/rnlT6leXuFU4ccNPBtKZs6D3xyW8KJK9CWcg8s++tDGNNLv5aNmp
 sU2mR7iB4+qRacCqDJTJJAjJ4HMX2aIgHIhankyoHTYUrTSpHdvfbVp0TvAlDqWGbvBqIPV5iR
 wRZ2quVlGbmoDcuou1l6g/K0U6NQZSTYu453/KmscY195641qn4boRp0B/kFr2HiqXPvpwRgDE
 5Yk=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:27:42 -0700
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
Subject: [PATCH v8 01/11] scsi: ufshpb: Cache HPB Control mode on init
Date:   Sun, 11 Apr 2021 09:27:11 +0300
Message-Id: <20210411062721.10099-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
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
index 4dbe9bc60e85..c01f75963750 100644
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
index 86805af9abe7..5285a50b05dd 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1615,6 +1615,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
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

