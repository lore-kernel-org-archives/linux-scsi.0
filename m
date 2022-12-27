Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF3AC10F1B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Dec 2022 08:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiL0IRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Dec 2022 03:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiL0IRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2022 03:17:32 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798252604;
        Tue, 27 Dec 2022 00:17:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VYCh-M8_1672129042;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VYCh-M8_1672129042)
          by smtp.aliyun-inc.com;
          Tue, 27 Dec 2022 16:17:29 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     james.smart@broadcom.com
Cc:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: lpfc: lpfc_bsg: Remove set but unused variable 'offset'
Date:   Tue, 27 Dec 2022 16:16:34 +0800
Message-Id: <20221227081634.52182-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable offset is not effectively used in the function, so delete it.

drivers/scsi/lpfc/lpfc_bsg.c:2806:11: warning: variable 'offset' set but not used.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3559
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 852b025e2fec..dd304f899f78 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2803,7 +2803,7 @@ diag_cmd_data_alloc(struct lpfc_hba *phba,
 {
 	struct lpfc_dmabufext *mlist = NULL;
 	struct lpfc_dmabufext *dmp;
-	int cnt, offset = 0, i = 0;
+	int cnt, i = 0;
 	struct pci_dev *pcidev;
 
 	pcidev = phba->pcidev;
@@ -2854,7 +2854,6 @@ diag_cmd_data_alloc(struct lpfc_hba *phba,
 		bpl++;
 
 		i++;
-		offset += cnt;
 		size -= cnt;
 	}
 
-- 
2.20.1.7.g153144c

