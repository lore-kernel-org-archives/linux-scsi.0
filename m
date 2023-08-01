Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39D1C001DF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 02:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjHACSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 22:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjHACSh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 22:18:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6FC1BEB
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 19:18:36 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RFJbk03cxztRkT;
        Tue,  1 Aug 2023 10:15:13 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 1 Aug
 2023 10:18:33 +0800
From:   Ruan Jinjie <ruanjinjie@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] scsi: megaraid_sas: Remove unnecessary ternary operators
Date:   Tue, 1 Aug 2023 10:17:58 +0800
Message-ID: <20230801021758.3349270-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ther are a little ternary operators, the true or false judgement
of which is unnecessary in C language semantics.

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 050eed8e2684..deadf8b237f1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2095,7 +2095,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	if ((instance->tgt_prop) && (instance->nvme_page_size))
 		ret_target_prop = megasas_get_target_prop(instance, sdev);
 
-	is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+	is_target_prop = ret_target_prop == DCMD_SUCCESS;
 	megasas_set_static_target_properties(sdev, is_target_prop);
 
 	/* This sdev property may change post OCR */
@@ -3446,7 +3446,7 @@ enable_sdev_max_qd_store(struct device *cdev,
 
 	shost_for_each_device(sdev, shost) {
 		ret_target_prop = megasas_get_target_prop(instance, sdev);
-		is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+		is_target_prop = ret_target_prop == DCMD_SUCCESS;
 		megasas_set_fw_assisted_qd(sdev, is_target_prop);
 	}
 	mutex_unlock(&instance->reset_mutex);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8a83f3fc2b86..aec9dd818cc1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2832,7 +2832,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	} else {
 		if (MR_BuildRaidContext(instance, &io_info, rctx,
 					local_map_ptr, &raidLUN))
-			fp_possible = (io_info.fpOkForIo > 0) ? true : false;
+			fp_possible = io_info.fpOkForIo > 0;
 	}
 
 	megasas_get_msix_index(instance, scp, cmd, io_info.data_arms);
@@ -5115,7 +5115,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				    (instance->nvme_page_size))
 					ret_target_prop = megasas_get_target_prop(instance, sdev);
 
-				is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+				is_target_prop = ret_target_prop == DCMD_SUCCESS;
 				megasas_set_dynamic_target_properties(sdev, is_target_prop);
 			}
 
-- 
2.34.1

