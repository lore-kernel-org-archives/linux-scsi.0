Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB60C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Oct 2021 12:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 622F26054F
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Oct 2021 12:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJaMjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Oct 2021 08:39:37 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61936 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhJaMjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2021 08:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635683825; x=1667219825;
  h=from:to:cc:subject:date:message-id;
  bh=WST+ZJjjkk2uWz+yUQQEmMKVyNSyU9zWN6oFNekvMxg=;
  b=fkB1LiC/XHnbqM0KL0U/brqoNHQKkn9pwucNH7Z2X+XNAwqiaUOlcJoS
   vWCh8wRgHPN07NWzF52TOOmB4V6t0I492q/7Q+TW1OT9z0QeHxexTJ/Ea
   P3L9+MZ47wqovM5/vGygElK1azZ9XAXcRV/q14h0Hn2lPIypN8drre4Q2
   8Cwf9Akyh+EnUd+cluLQmxeOG6oZvzGFl9Zgfq2wLg2p/MlaCYNun5DqR
   tWLxF/loxaINrFihgsH5clC/EsZ51+LJFvsT99qthvL7XGB2VVhBHUElg
   BZOtHqFxPbJ4D9icWU2V0xgazMqFSj+UQQHERgYWZfZ/FkQE7rhGlizXU
   g==;
X-IronPort-AV: E=Sophos;i="5.87,197,1631548800"; 
   d="scan'208";a="189075297"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 31 Oct 2021 20:37:05 +0800
IronPort-SDR: D51smixvpYaM31vCRujN/izq09Z++JMMFdCRvqfcIczaImlPMosbW6k8iZKOowM5D7F7X7gzTt
 BTg2gg/UYqtXvsnaVi/3o3uAmVrpQgSgGigA0DpbUvz3Zk+buBzXrCrNr0Kj3GCt66ci/pzMsh
 BOiS6u3GhKrHEMFu2Z5k7JcarDkEqdEl7loUIke1NE4sgt59vQRvnIhrHqCXJ+oi/wIIdHZX3Q
 Bueh8XeHiUsVlwXLYxDxO3elZjdjrSJimwzo2EPYREYjlHyC0k2QORIfdBJpg4mNXIzglJVarf
 t9rZNgejlQJIdaL6faqhz/gu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2021 05:12:28 -0700
IronPort-SDR: q0L7WEqtrUkZMxhlfWVjGZBIZxDXL7gWBYbQD8yCov5C1cccCC/e1q5pDlgmKrKAUhtcAGV9F8
 CfsiGIcKvfU/+ZfG1roIznCmTWjQADtulWhxDZVPZZwz0mAKl79JOjUH3RcQi5JDXNxK5aPmuE
 ffnNqhvWdI98ilCRYy6uZNuvC4czi4WEUBQS9N0NFg4ovkJfdO1mR+pERoVDqQONX9xNRjc7X8
 YL+vTCITUGSK83cLtlaC9v8NUFlacODOFBkXko6colGeQZkAIsrYRZAxCOLyrU9RN/LXR+6oI7
 iKQ=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.30.255])
  by uls-op-cesaip02.wdc.com with ESMTP; 31 Oct 2021 05:37:02 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufshpb: Properly handle max-single-cmd
Date:   Sun, 31 Oct 2021 14:36:54 +0200
Message-Id: <20211031123654.17719-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The spec recommends that for transfer length larger than the
max-single-cmd attribute (bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD) it is
possible to couple pre-reqs with the HPB-READ command.  Being a
recommendation, using pre-reqs can be perceived merely as a mean of
optimization.  A common practice was to send pre-reqs for chunks within
some interval, and leave the READ10 untouched if larger.

Anyway, now that the pre-reqs flows have been opt-out, all the commands
are single commands.  So properly handle this attribute and do not send
HPB-READ for transfer lengths larger than max-single-cmd.

Fixes: 09d9e4d04187 (scsi: ufs: ufshpb: Remove HPB2.0 flows)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 29 +++++++++++++++--------------
 drivers/scsi/ufs/ufshpb.h |  1 -
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 026a133149dc..40e62d9e2c89 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -394,8 +394,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	if (!ufshpb_is_supported_chunk(hpb, transfer_len))
 		return 0;
 
-	WARN_ON_ONCE(transfer_len > HPB_MULTI_CHUNK_HIGH);
-
 	if (hpb->is_hcm) {
 		/*
 		 * in host control mode, reads are the main source for
@@ -1572,7 +1570,7 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	if (ufshpb_is_legacy(hba))
 		hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
 	else
-		hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
+		hpb->pre_req_max_tr_len = hpb_dev_info->max_hpb_single_cmd;
 
 	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
@@ -2582,7 +2580,7 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
 	int version, ret;
-	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
+	int max_single_cmd;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
 
@@ -2598,21 +2596,24 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	if (version == HPB_SUPPORT_LEGACY_VERSION)
 		hpb_dev_info->is_legacy = true;
 
-	pm_runtime_get_sync(hba->dev);
-	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
-	pm_runtime_put_sync(hba->dev);
-
-	if (ret)
-		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
-			__func__);
-	hpb_dev_info->max_hpb_single_cmd = max_hpb_single_cmd;
-
 	/*
 	 * Get the number of user logical unit to check whether all
 	 * scsi_device finish initialization
 	 */
 	hpb_dev_info->num_lu = desc_buf[DEVICE_DESC_PARAM_NUM_LU];
+
+	if (hpb_dev_info->is_legacy)
+		return;
+
+	pm_runtime_get_sync(hba->dev);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_single_cmd);
+	pm_runtime_put_sync(hba->dev);
+
+	if (ret)
+		hpb_dev_info->max_hpb_single_cmd = HPB_LEGACY_CHUNK_HIGH;
+	else
+		hpb_dev_info->max_hpb_single_cmd = min(max_single_cmd + 1, HPB_MULTI_CHUNK_HIGH);
 }
 
 void ufshpb_init(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index f15d8fdbce2e..b475dbd78988 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -31,7 +31,6 @@
 
 /* hpb support chunk size */
 #define HPB_LEGACY_CHUNK_HIGH			1
-#define HPB_MULTI_CHUNK_LOW			7
 #define HPB_MULTI_CHUNK_HIGH			255
 
 /* hpb vender defined opcode */
-- 
2.17.1

