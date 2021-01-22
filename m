Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF8AC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 09:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6637E239D1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 09:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbhAVJ2E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 04:28:04 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:53609 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbhAVJSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 04:18:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UMW2Lur_1611306989;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMW2Lur_1611306989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Jan 2021 17:16:43 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH 2/2] scsi: qla4xxx: remove redundant NULL check
Date:   Fri, 22 Jan 2021 17:16:27 +0800
Message-Id: <1611306987-103954-2-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611306987-103954-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611306987-103954-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings reported by coccicheck:
./drivers/scsi/qla4xxx/ql4_os.c:4171:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:4192:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:4211:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:6396:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:6551:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla4xxx/ql4_os.c:7840:2-7: WARNING: NULL check before
some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
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
1.8.3.1

