Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0909C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6623764ECB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhBBIbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:31:41 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:61777 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbhBBIbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612255195; x=1643791195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AjtmRJZexTaXO2vUjsyEA72SNrDJfixMJbAY5nTV0w=;
  b=QOWix0hAJEQm9gX88DiFxeWHbdSpJaIxjuc7UzELc2TyxgIoQHZVI4Fo
   rw1fviMXJOgmT0TmbX4Bsx7Owob3HBQqTQbto2yS83WUF6RPUeNRyVWer
   clW4nNYMa4r02YJuO5hvRlOm+tdL+bnI5/2KWBerobYJcYeTWNCsK2n4V
   sqjV00NC0lAuKcW+9xnKJWPnQ1vQciic4w2MsNSAJldH2K46DW7KUw+jW
   GaEHq7steODC6fqWdamKoZxFQ3GPUIUdeJ6Hrn3CJ9HOyj8zgmYBKKAHJ
   QeeTLwy0iZ4EOKk9VmUhdLlRjmPZHiSkENrznFSi7ojHInTc2MwwZaNKE
   A==;
IronPort-SDR: 7C8Wq3wFK85m8kcXA7SCIkJEptolEYXv01sbsmTaBciR8mCNXa6VJd+nZ8qRrXjHRlutJceRx3
 H/cm75/jHr3lEjiWfLEx9mYiupuI/2ZiJXCSy2YgG2pq7l7RnhLoxHWdQ6XgIEtkeUmoSDFwEb
 ReS0fKM75rdn2ZMRrNmrcbglCBIcBIhiRpbFfXOd+kuCCUlmXfXVv48TYQ2gt+JoCoFq7cku+t
 At7Z1dmTt4gqdrJFOgj7ZP9QcG810lJD7xQP97FSUnEeEhZBXNvisu+pA1oquX9RAF1dUluOu1
 kms=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="262976940"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:38:16 +0800
IronPort-SDR: l8nHQoPpfV+UUfQ5x4CV/s9K5av4esijLsz32V2JoQ6I6iqpF34k7jp0jJkCAAwYgpdpplekDa
 b+mAPSS6jV1wm4oN0N8oZOJvivNlXU/vs8Jt7QJi17LPkPEDVLEt+rvtuN5++rzh2HeB4fEphV
 FkWcmRpKs+TcQFt2EDhZVgMqR7S9rCrr/rDg4meUKpibHR9kUwmvsIrJdWTzvVg8YzpMth8m9l
 4kbJGiTJ12a8owN2Ypziwmk9iJNWvdybxi+DLShjPj34+zIGeOykrSo0aGq3prneCXXhbkQoZ4
 fnkohmWPpEMpw/QBOyUcDX+f
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:12:40 -0800
IronPort-SDR: 8xhIZr8DTJ/b700KnocG2yBamqsRnjF2btetWxLAFz0uQ7Evw5Whiqb0CR3blDgeu+HsqyX+yi
 6gKsbmUP2qCv7k8hFoa2cSCbI6p9bOr6Gj5EyqbyrhAaSu9oOFzDtpMXJBvmXygYdMVI0TSCWn
 3l4DE8nUvQclf3aAoNGaQAANc9dnZswCnBSsFWOgOzjxS7kHSYNqCbfzepxbwFSVIAGfmm7CrF
 uRV3xwXR7QbLKVC1763bmFggGqO5DZhuw/LLAct0mPI3QeaeGhVIH98ERWW8Ang8QKutQlmGdK
 Jdw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:30:28 -0800
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
Subject: [PATCH v2 1/9] scsi: ufshpb: Cache HPB Control mode on init
Date:   Tue,  2 Feb 2021 10:29:59 +0200
Message-Id: <20210202083007.104050-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
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
index 961fc5b77943..7aeb83b10c37 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -654,6 +654,7 @@ struct ufs_hba_variant_params {
  * @srgn_size: device reported HPB sub-region size
  * @slave_conf_cnt: counter to check all lu finished initialization
  * @hpb_disabled: flag to check if HPB is disabled
+ * @control_mode: either host or device
  */
 struct ufshpb_dev_info {
 	int num_lu;
@@ -661,6 +662,7 @@ struct ufshpb_dev_info {
 	int srgn_size;
 	atomic_t slave_conf_cnt;
 	bool hpb_disabled;
+	u8 control_mode;
 };
 #endif
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 73e7b3ed04a4..46f6a7104e7e 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1128,6 +1128,9 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 				(hpb->srgn_mem_size / HPB_ENTRY_SIZE));
 
 	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL)
+		hpb->is_hcm = true;
 }
 
 static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -1694,10 +1697,9 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
 	int version;
-	u8 hpb_mode;
 
-	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_mode == HPB_HOST_CONTROL) {
+	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
+	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
 		dev_err(hba->dev, "%s: host control mode is not supported.\n",
 			__func__);
 		hpb_dev_info->hpb_disabled = true;
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 2c43a03b66b6..afeb6365daf8 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -186,6 +186,8 @@ struct ufshpb_lu {
 	u32 entries_per_srgn_shift;
 	u32 pages_per_srgn;
 
+	bool is_hcm;
+
 	struct ufshpb_stats stats;
 
 	struct kmem_cache *map_req_cache;
-- 
2.25.1

