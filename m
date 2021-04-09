Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F77C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F72A61177
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhDIMFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 08:05:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15656 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbhDIMFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 08:05:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGxZR0rgHzpWs6;
        Fri,  9 Apr 2021 20:02:07 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.176.196) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 20:04:47 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <njavali@marvell.com>, <mrangankar@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qiheng Lin <linqiheng@huawei.com>
Subject: [PATCH -next] scsi: qla4xxx: remove unneeded if-null-free check
Date:   Fri, 9 Apr 2021 20:03:45 +0800
Message-ID: <20210409120345.6447-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.176.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eliminate the following coccicheck warning:

drivers/scsi/qla4xxx/ql4_os.c:4175:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:4196:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:4215:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:6400:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:6402:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:6555:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:6557:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:7838:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/scsi/qla4xxx/ql4_os.c:7840:2-7: WARNING:
 NULL check before some freeing functions is not needed.

Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 867730ed21f7..ad3afe30f617 100644
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
2.31.1

