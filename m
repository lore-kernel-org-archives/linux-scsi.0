Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9DBC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B0261132
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhEXLXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:23:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43182 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhEXLXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855347; x=1653391347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g8YJqqHhsUD1hXtF423Hwl8dEqD1b09rkmtdLn0wQjY=;
  b=KVSfCJrZ5IshgOUNunGDI8TZeOQ2ORGqE4BkWPcAvf8CfmtDU8I7Mjvv
   0ZBFuqf9DQ90dznFYNElCUJUTWgXliubD7brVJOxKuqN5WyOtEXXuI6xM
   jpn/RbOiKHyaQrHpLt7CR3MGpjT1deELa6XJmVrXN1AS7wHV69ci3IBJb
   XOo6mfak/F3/jYigZ97+YYpbVpAVw8e7XCf97vy8Srgwo/ORw2Db8XzWR
   8Az+MuziiXOOg+RBa8qZrw/rGv9araUNKsI2SEzsn/brTeyDc2c6w7FnE
   JtvUiWRuRUq+QkVyNZgHAbj3g9YDz2NfZ+mS5CnqZySMApnFyXynOFx+e
   A==;
IronPort-SDR: YqwU85lWoQVcq1METLHpyMlsJv8Ov8DHDkGyHovuEYiToyg03f1ERYM1NR8ywiNyCu06/jCWmM
 Tqo727sV3Wmk+EAwlrqy/iYX832E/P8WZunBq6Nb26Hv398AQHr0btzaKuTtJiagfNu9qHMl+K
 X5PGBsDOMolp1487hj3aOlKNlYPNxfLdScj1zFBuCVjTeLFWWRZmFSp2m0H1vd/kTyPBoz+CrO
 B1Pp4ZgVqFtpfP243l95gMk1DCpdkD272eMqa5tr5cFtRVc+9BFHqBv6ZwQmACrHy1Np7M5Pw5
 Xr4=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="273140489"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:22:26 +0800
IronPort-SDR: 7dh3y282h0/WQU8AUc0b4+T7B9qpZUuLHlvm1Tuh23U5yaSokWTQdhqoRkh55PJ8UR8JjdSI2V
 JYXcYK8NO+8j3wZnubtW6eTCNau0p1GetMNbOyTQGuAKGOq2k10B1jdBQ9lRcXJ02qct4vwtDU
 ItF5fHjN4YzTBinHNvJTT7szB6ZmsddWkr9UCotAREym47OZd3hXSTmotyYcc2NDQZRjTWiKLB
 PY9Z2BcqK0e5jP53tS3agcIl6I5P/9aQMPvl13Gx34OmyHE92Yz3k03FyKGHXrczP3whcXa1Lo
 1cEYXaVqNIAWJl8wnUFuew6g
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:00:35 -0700
IronPort-SDR: bbmMT2uGy3ldJbSRANP4fr8OpDH0ormeYVw1XTE3YFQfJaYap4/PiGDUvOf4HHKTihawp9GtwK
 zMsgbXwR3kMl7MqjBxvh1joFvBhCuU1Tz8xKqy86OFUL3YpTKxTwwYhx7oqojSTNF0CKAqTanC
 pUq45k3QpB7Jsv8ZNC7EkZ9J3Ala3KbFluWFQC5BzbnkW/Y6pj2op3/UUtDsdj0WPn64HlBUWd
 Qm8v7LIz9iV2HzTKrivNyqV0eosYdDKL6odN/kLP0P7bLveN/Gglnhf0BADTOIUfcP5VJk+I/4
 Jik=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:22:16 -0700
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
Subject: [PATCH v9 01/12] scsi: ufshpb: Cache HPB Control mode on init
Date:   Mon, 24 May 2021 14:19:02 +0300
Message-Id: <20210524111913.61303-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
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
index b6b294297a59..dfce84b17561 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -673,6 +673,7 @@ struct ufs_hba_monitor {
  * @hpb_disabled: flag to check if HPB is disabled
  * @max_hpb_single_cmd: maximum size of single HPB command
  * @is_legacy: flag to check HPB 1.0
+ * @control_mode: either host or device
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -682,6 +683,7 @@ struct ufshpb_dev_info {
 	bool hpb_disabled;
 	int max_hpb_single_cmd;
 	bool is_legacy;
+	u8 control_mode;
 };
 #endif
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 85801e35a53b..08290ab34f58 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1612,6 +1612,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				 % (hpb->srgn_mem_size / HPB_ENTRY_SIZE);
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2303,11 +2306,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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

