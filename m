Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D66DC3A5A1
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 01:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6502120815
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 01:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfHZBJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Aug 2019 21:09:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4775 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbfHZBJb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Aug 2019 21:09:31 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6F0BD30CD9247715D6D3;
        Mon, 26 Aug 2019 09:09:27 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 26 Aug 2019
 09:09:17 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <agross@kernel.org>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH v2] scsi: ufs: remove set but not used variable 'val'
Date:   Mon, 26 Aug 2019 09:15:49 +0800
Message-ID: <1566782149-63502-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/ufs/ufs-qcom.c: In function ufs_qcom_pwr_change_notify:
drivers/scsi/ufs/ufs-qcom.c:808:6: warning: variable val set but not used [-Wunused-but-set-variable]

Fixes: 1e1e465c6d23 ("scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from host")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4473f33..02cdcef 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -800,7 +800,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 				struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
-	u32 val;
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct ufs_dev_params ufs_qcom_cap;
 	int ret = 0;
@@ -869,8 +868,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 			ret = -EINVAL;
 		}

-		val = ~(MAX_U32 << dev_req_params->lane_tx);
-
 		/* cache the power mode parameters to use internally */
 		memcpy(&host->dev_req_params,
 				dev_req_params, sizeof(*dev_req_params));
--
2.7.4

