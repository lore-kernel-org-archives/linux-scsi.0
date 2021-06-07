Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972F9C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735F86121E
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGGQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:16:23 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10219 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFGGQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046473; x=1654582473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o1RBvppYbzo9lDI/z75bmk4RKInfGwbwTZ8ujyGC3aw=;
  b=RoZAs8uCHx+3/cBE0Qw6EXjRifINxhCQvVidO9SmwBGXRU47CuubHCRp
   zNIpx8NpmP7fvV0f+S5vobUEytCemAxIGO1Q+2IFr5ZZossqKfgbEn3x7
   prloZUGX051gDXVkp7I8lE+OYp3YUomc7vamsf5VkH4hw5LRkj6xSWkM3
   CY3vc0xAxPV25++IIQ4G2xANy3h+iz3FXP728zsA9+CN2HCvuHLrHmGkA
   gAXUSv3FB4js7FkgE6EYnI4iLyEVnPYIvXT+JotAWpAqSux801lpVsqc1
   2ljjSQ2C1qeVycPZsI+ZqrsFjmnB9R3i2MSIgKILRyZ0XBlVN9y7Wup0Z
   Q==;
IronPort-SDR: JC07m2JjR9tmqo+I2qj1o981+/phkEFBixBLSVQdG6f+78P2t+c9tc7+Kb4vX7xoD6yr6CycE4
 2BVcxjoJE6NjSn8sQFeysOV05Nw0w1N4N0HIDPGWMHL8gUkiCCbX60nbmsYQDHEzXzclHBToJC
 aWlQUO+lf5/KY/XvGhXre4m0oIQmEQHS4xdwpOAgyE/wMi/nHVzTrVPujOc83Gptb6xUsWXRFr
 JqxWJraoSJV35M23HpsRMVZaOFDDl0bIUJpHOb0ZbG4/3/5WAhnFM+0+FhyAPu5S/HQVfadcL5
 OZA=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="274818153"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:14:33 +0800
IronPort-SDR: rcAT6/V8oUJkdO02OacMW7NVJqTdlhGg4GKrUgNzkKQdoaQDD2Y2aW0x9nUhsT386kSIvsQgdv
 eg+pol60/fgGASoEM/X7M2K/TcNjrw0GLavDFGAEZQMVnqhb5fD710x+pMs9Q/L2euZYmg1tCo
 RmaAcnWJl43eQMF7t73K8XDMdG0AntdUwBZaZ61kE9GRMj1XTI61nzLXAHhecB9EES4O7OpUlL
 JckiLz7Ei9l1UzOft7vkZkpmqHso1IHHKm5SSbnkHfKdXotA1s9SAA0TIIVU6J983LNg8bDtSH
 IRTbviuk18ejEPcH9J20Y5vZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:52:14 -0700
IronPort-SDR: 2s17Djd8Ysi0bpPd0spPJ194ckYRbvj4+ZoXsTqLOQ5Yx6zD/AuVixJn+XWh//PwanHN9moC13
 XyphAhlDNQij241IY4rEcl1Nyg3tsbxxAVnxP/+0lAC+HJNE5oAZVYwQSCuxZzErviCVqv3MTZ
 77L0gqKQtco8Vk09vibHTBfmXYhjuoYas45hIQiozOVQ92y7T2/MwRPSWh4VzVVW1x0oO9moLF
 4cRPWD1IXCptHV4ddEQEntJVX+JRge53brS4D9Nc+pGQckdXcDTk1vt3EAlmv11IuaC3rHZdzb
 6h8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:14:28 -0700
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
Subject: [PATCH v10 01/12] scsi: ufshpb: Cache HPB Control mode on init
Date:   Mon,  7 Jun 2021 09:13:50 +0300
Message-Id: <20210607061401.58884-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index d902414e4a6f..ccb1bccf6380 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -654,6 +654,7 @@ struct ufs_hba_variant_params {
  * @hpb_disabled: flag to check if HPB is disabled
  * @max_hpb_single_cmd: maximum size of single HPB command
  * @is_legacy: flag to check HPB 1.0
+ * @control_mode: either host or device
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -663,6 +664,7 @@ struct ufshpb_dev_info {
 	bool hpb_disabled;
 	int max_hpb_single_cmd;
 	bool is_legacy;
+	u8 control_mode;
 };
 #endif
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 1e60772be40c..d45343a00e9f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1614,6 +1614,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				 % (hpb->srgn_mem_size / HPB_ENTRY_SIZE);
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2305,11 +2308,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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

