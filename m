Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8BFC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62FF364EB8
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhBRQ5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:57:52 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2071 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbhBRN0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:26:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654800; x=1645190800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GGiQnfmLQo8dIg2skv/t5+JKGNT/ObkSr0cIYyWrUzQ=;
  b=Z7Q0JMq1wI4fx31SWw3XpKuI3hNrQC4X37csrUPGudZzO0sn0lZMETTj
   2Q4ytT4vHeMoLzQ14dNLyqNp7EVhuEJZ74woMyDiO+E0FPdcvhjYIKJpQ
   hfogxF2wV0gO7xdi4HHHkSx2Pv+zL0NoSPFVowAtbAxcw3jUuPM0aCa67
   PynnDgN0yiIYKq62QcGT8gOB7IuIvMIlphW/UREv68MCVXYY5EUXh/EHG
   UdxEJDi4NWjlf7xfnrTTYaUKmnWCl9AXvbi2PEY0uLr93JQcF49eJxZ95
   dTKO/zmDcY28oKmYJ9bsc5Pryhndgm/418upeNPqNLcb7U8K/2SlQOLqH
   g==;
IronPort-SDR: qavi5vJWZr8EI/g4jjBZfatZ27XMgIHMPTjhLSnkS2yHD1ZsFLW8fWDQ1lTJnv5CqfW0dmHA69
 DdzXUiC3VLOvK4ikV2kmg+CCaHSMA4Qhg/EvENoC9bJo8EYRI+UPl5HA2vMpA5QN+WjD+k1BHD
 LtsdWAJJdnTck0PGWhS9vWp+0sYjyy428653LcPFQcNCbtL/f9pTyjmowT/lHMS727bvD3d85U
 wdBljYovcIGaosiWLMNRsRyFHRwawjsXhz8Rrj3sqMivnsQYPgdTHpjQjaeYoAIlXQuYiKXTIL
 t7M=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="164746392"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:20:14 +0800
IronPort-SDR: QQo8CDMWhrEjaPs4yKdBu5QpQU88qx41VZmT/0wYMJMWRkoAJlHnFfB26m8QYwQOEDL3SwfIfJ
 fkudOFdnw030mEEzprfBE+zvoPXjmVzQJyyzVgUx7muutUNuYRxS42f/4Uvtr1fy0aatjUMKOi
 5vCnTqHq69zqlIH83HdAs68KyHPc74D9yV447foEgQ8pZlEg1FnmLZ7/NG2QaHYeBJ/SXA2ThI
 ZhWV+Yy6YC8n9zYIjmMxUcS9ZYPFEWdcr5naisaqgphtOddbrqhf/Fu+oi1KWnU1F0SLbgGnrR
 30/+S2SetLJ8Y+0vmPcHeNIY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:03:40 -0800
IronPort-SDR: zciRZvXO8859SfE+LG2hlno/Hn2q2UMteYKVnt+GrJBVkPTQlwvsQiyp1TwH5UDTW6dEun8T6Q
 B2iSeurFhoCsYRZeYJQiqXnSvhS7x2fgKPsp/mGqMeUNpBwRelCcDd/XXtCnvQEmcFeLD8QM+R
 nxwp5/cZS9PSPHBY4QECN/Diiv63FeirATbIy2JilFLuE2Wbxw7z278BYfijbRfcnJZheUtEcb
 grJiC3gBb8ize+yWM2yxzkweq2TZnA9KoibYP0NGMRi5wh9ZY+bwweqQlohuxOTES3qL6Crjqn
 PI0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:20:10 -0800
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
Subject: [PATCH v3 1/9] scsi: ufshpb: Cache HPB Control mode on init
Date:   Thu, 18 Feb 2021 15:19:24 +0200
Message-Id: <20210218131932.106997-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
index 49bfebf366c7..1a8dcdaa357a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -655,6 +655,7 @@ struct ufs_hba_variant_params {
  * @slave_conf_cnt: counter to check all lu finished initialization
  * @hpb_disabled: flag to check if HPB is disabled
  * @max_hpb_single_cmd: maximum size of single HPB command
+ * @control_mode: either host or device
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -663,6 +664,7 @@ struct ufshpb_dev_info {
 	atomic_t slave_conf_cnt;
 	bool hpb_disabled;
 	int max_hpb_single_cmd;
+	u8 control_mode;
 };
 #endif
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index e97a78400f68..f9140f3a4eed 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1522,6 +1522,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				 % (hpb->srgn_mem_size / HPB_ENTRY_SIZE);
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2205,11 +2208,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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
index eb8366d47d8a..f55a71b250eb 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -223,6 +223,8 @@ struct ufshpb_lu {
 	u32 entries_per_srgn_shift;
 	u32 pages_per_srgn;
 
+	bool is_hcm;
+
 	struct ufshpb_stats stats;
 	struct ufshpb_params params;
 
-- 
2.25.1

