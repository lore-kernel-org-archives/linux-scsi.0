Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0194C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D57B619B9
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhCaHkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:40:23 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44523 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhCaHkK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176410; x=1648712410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xR7BmbkW2ps4Me2oZXCQOwYznBQj5YfqtZ49LQFVlVk=;
  b=NDkJi0UYP7QQl2cs8HVak7jx7PPLoNAXKVKIdHE5+K8tW29NqpUAVazu
   IL7M5KAwUGoojB9eTD+lgBgSD9MS2YZdiXvxsmq/WQf4Ik9Rvgudb/kdX
   TMt7cvody+WzCGUKnvgWb5IddQZ1biwNMB1sJLkhAMpES3iAaeHwrSu5F
   gYgknGdIUCMDsFnCBGKo7lm/XfcjcUsQRDu+5E2svEDh/4XQIQG7vR5NR
   8ZetGkj2G9jNT3V7nMfHXRdLkEjujQMMuz0MW54HcQQrVXuy6o2wjHqrc
   jAWUfw7sJup6Y7EOXlg9SPu6BXj7NONfzVPQ/hXhxUuGWPDNM+BKIgemm
   w==;
IronPort-SDR: d5hlt+bT/57y9CJ6wDipTxOin28pJq6isAlGbq/gJM0rKPj+38yzKZG2UoJsfuq/siGDZ2cq6W
 aIoWH/s5OIUQYoRfmsw0YfsJUsYrVEBG8U+mmLq+Gu86JSOntz7dtSawqLLq5HZmZe81f2s/pZ
 LfSryb5z1pVAkol++OmKjJv4tdLmbcw8NiODgodwnhf0XTyLiNucrYUXEKZAE9xkQBPCEBMzmo
 6PMEjRPsgs36lEyT4f4+rjuRtFZ6kXgAFFWGIfnA0yj8ltbYTzD52QOXzsR7O/aeEBLuvl3um0
 ujY=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="163422235"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:40:09 +0800
IronPort-SDR: ljXb5pPMfMYTyllauoCVn7+xEQeBa360pzoaDHYqqyMBEyw5kG9oqgw05MhTS7wWQWZEzWI2fK
 s/BP7ghn/g3Yv9FOkoMu1DHHyUbFjmn6lIFZ9S11Oq95EmdN9ptY8vQzgh8vnbO9N8d0/NVTyC
 /3W8WIl0JKk4upFPYBhaIDY4oAQIpmFJmP+gZHCNS69/ArrQIFAu/auEI/WE0BInWjkn4iu/vw
 JWgvOrauTmjFlQtpmpNM95KtrT1fr4NK2dr52YxInEBZi8hdlbRsS1njMat+s5HFBA12wOonRG
 xi+Y4L/ARUVq4AskmqJ/IaRR
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:20:22 -0700
IronPort-SDR: q1/3aMUa2Cvb2QpLUU8z5ZLD8D555kj5XgX39+xcEwPfaJfu+xByli25WCpKBVZ3NQY2AoaW6M
 JsV73Jg4+B7EOBMCl8bPu0wQ3EEIuCEt4Dt02M5j6Mzuag2anJrpfmvk4nsheeHbsusIJEYW6/
 CoCDx9mdK/3oIq45Nl5prFz1Uh3vSc5y4wNIpn2nwALiqf4xZwYx5uu38BYA3+LOBg6DFw6qQu
 usC8Mu+uDho8nmxjTlCYGbz43UYpyeU4BC1tRgEh8U3Hhg7f++lpwQUGBHEjYc/oPEZk5mzAHK
 Z+I=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:40:05 -0700
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
Subject: [PATCH v7 01/11] scsi: ufshpb: Cache HPB Control mode on init
Date:   Wed, 31 Mar 2021 10:39:42 +0300
Message-Id: <20210331073952.102162-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
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

