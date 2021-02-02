Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FD8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EF164E9A
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhBBLs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:48:28 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12405 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhBBLs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:48:26 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DVNM02jxmzjChK;
        Tue,  2 Feb 2021 19:46:36 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 19:47:35 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <njavali@marvell.com>, <mrangankar@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: qla4xxx: fix unnecessary NULL check warnings
Date:   Tue, 2 Feb 2021 19:47:14 +0800
Message-ID: <1612266434-9984-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove NULL checks before vfree() to fix these warnings:
./drivers/scsi/qla4xxx/ql4_os.c:6555:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:6557:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:6400:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:6402:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:4175:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:4196:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:4215:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:7838:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:7840:2-7: WARNING: NULL check before some
freeing functions is not needed.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a4b014e..73b89fd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4171,8 +4171,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
 				  ha->queues_dma);
 
-	if (ha->fw_dump)
-		vfree(ha->fw_dump);
+	vfree(ha->fw_dump);
 
 	ha->queues_len = 0;
 	ha->queues = NULL;
@@ -4192,8 +4191,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 
 	dma_pool_destroy(ha->chap_dma_pool);
 
-	if (ha->chap_list)
-		vfree(ha->chap_list);
+	vfree(ha->chap_list);
 	ha->chap_list = NULL;
 
 	dma_pool_destroy(ha->fw_ddb_dma_pool);
@@ -4211,8 +4209,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		iounmap(ha->reg);
 	}
 
-	if (ha->reset_tmplt.buff)
-		vfree(ha->reset_tmplt.buff);
+	vfree(ha->reset_tmplt.buff);
 
 	pci_release_regions(ha->pdev);
 }
@@ -6396,10 +6393,8 @@ static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
 	}
 
 exit_check:
-	if (fw_tddb)
-		vfree(fw_tddb);
-	if (tmp_tddb)
-		vfree(tmp_tddb);
+	vfree(fw_tddb);
+	vfree(tmp_tddb);
 	return ret;
 }
 
@@ -6551,10 +6546,8 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 	}
 
 exit_check:
-	if (fw_tddb)
-		vfree(fw_tddb);
-	if (tmp_tddb)
-		vfree(tmp_tddb);
+	vfree(fw_tddb);
+	vfree(tmp_tddb);
 	return ret;
 }
 
@@ -7834,10 +7827,8 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		ret = -ESRCH;
 
 exit_ddb_logout:
-	if (flash_tddb)
-		vfree(flash_tddb);
-	if (tmp_tddb)
-		vfree(tmp_tddb);
+	vfree(flash_tddb);
+	vfree(tmp_tddb);
 	if (fw_ddb_entry)
 		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
 
-- 
2.7.4

