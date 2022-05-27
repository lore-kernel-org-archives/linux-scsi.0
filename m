Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F05C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 May 2022 09:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350728AbiE0J7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 May 2022 05:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiE0J7l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2022 05:59:41 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95365ED8C2;
        Fri, 27 May 2022 02:59:40 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 27 May
 2022 17:59:39 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 27 May
 2022 17:59:38 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: lpfc: drop the useless LIST_HEAD in lpfc_hba_down_post_s4()
Date:   Fri, 27 May 2022 17:59:36 +0800
Message-ID: <1653645577-28892-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2cc2d55b0f76..177c5d5d33bb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1083,7 +1083,6 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	struct lpfc_async_xchg_ctx *ctxp, *ctxp_next;
 	struct lpfc_sli4_hdw_queue *qp;
 	LIST_HEAD(aborts);
-	LIST_HEAD(nvme_aborts);
 	LIST_HEAD(nvmet_aborts);
 	struct lpfc_sglq *sglq_entry = NULL;
 	int cnt, idx;
-- 
2.7.4

