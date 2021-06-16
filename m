Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3E4C48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FD56128B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhFPLac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:30:32 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4725 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhFPLac (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842907; x=1655378907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vDksMCPROdbgzbzogxqTNaIIhU8JtS4xpZaUcJ4bey0=;
  b=oQl2pwixA4lHYViow8hSLnIhErYW/z5D+KIvGRaBGpBniiP1Arm5vSvp
   /QS9Fv8amdLJYp8iTkDydBJ5IPH/tM9qTtphAaPGdbrGtq0Of9/6GjNhi
   35/OSkAaVKhfz0XAHzp9LbIrEu1AMw3V2qSwvlgguvnPwRdO77BSpQ//1
   p9s+D2KovF1NpZqc7mRRJvDotkJSjtR+Fa/vrvmZfdNk+ydpV/C3Y3kJS
   IFBg5Jngllqt/lXErrHXWBsmFcZHld14khMxBJ+/TcpFJUCjrzPMfPoPP
   jUKJdAd1oig1+eZnmn9LgyLpTOTlVpHkSzf5ThzcFEYiT+kmuVl2W3+NQ
   A==;
IronPort-SDR: yCmXQd5wjhaEVJWdruSvhbJBvEXhC+Btb4+F4aXh6k5zZYB6HX6xC9LeXtbTzCoVKe+knOguhs
 DRuZVBJyg6BhFcQza6Jgck08nVj4PigtQriJdvZGuKImBjx96zogBWB8k1IlWuIkfSPfzqcqVA
 Zg9AKgFI2h8jJKSo5HQnedW9F2hARn8mw86K/8VMvssqB/DMLj5Jd+OsdZKQR7QZKuFccloo0M
 tAbby7fC59vNSVeGCyhHywgkOfNXJISyybFI4hLeOOsylCERAtcDLxz3h7p6AXrm3RzM9bk05T
 Izw=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="172653640"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:28:26 +0800
IronPort-SDR: d2/9KKYyTCaAbSEShE3vMf9nI0wNArUFXIrqmIbIk0zuZhDhH335MbGTxmgmcDLq/6LYaEpCQH
 V2Mb4V1wXpkpx91fCi29BesLL84SS/QEjqSzEMon+QZ4EYZVLd0OJLaWi1dqQ3S1TfJeh+envQ
 9jlhxQS1qyr784rITAl4Q6YCOtYNA/T1JGkSOVYlmtD033j2TfW5cGnNw5uzHNagPWXn3Mazu8
 JDDpot8mhLEAJaQYQWJN0RFk/7oBg0qKbkYi9/1DSt+erXICnAL5FThNV+dIhJTe4zwlad51Zp
 FGMf/tctJeaV2zXkaI+Rz3WK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:07:16 -0700
IronPort-SDR: A2vqhEIDRK/0wFXZ118GlQpZQgZZs/qOlE4ofgSyvVowxTZ6QvEEg92v7E6CElBmuZnkuLB6AY
 tktGWgA7CehWbs4p5omXKjeknfgQ09sm6T8az6slQsyet4undwJrOBbX0gSQxBm6dTCB7hDAZr
 wG4Gwnr3VbKsJ/tQAWbPzRZ1Mm1eS8KHWz+dc5oadctnhHEGH1OZLqrtd5XnUmQL3cezt6LrJS
 /ifSNQY3FP590509Eg2F++diIStI4Dg2U9ZvZv3iAL+CGufaiiSNupO/PWCrXA1n0bNG8i8Q0u
 1/c=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:22 -0700
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
Subject: [PATCH v11 01/12] scsi: ufshpb: Cache HPB Control mode on init
Date:   Wed, 16 Jun 2021 14:27:49 +0300
Message-Id: <20210616112800.52963-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
index 69c2450ef650..61f4fcf6bc07 100644
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

