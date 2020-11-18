Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1498C5519F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 07:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 431DD246AB
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 07:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgKRHbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 02:31:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7949 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRHbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 02:31:19 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CbZHF5ptszhbS8;
        Wed, 18 Nov 2020 15:31:05 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 15:31:10 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] scsi: lpfc: Mark lpfc_nvmet_prep_abort_wqe with static keyword
Date:   Wed, 18 Nov 2020 15:42:56 +0800
Message-ID: <1605685376-12415-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/lpfc/lpfc_nvmet.c:3340:1: warning: symbol 'lpfc_nvmet_prep_abort_wqe' was not declared. Should it be static?

Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c8b9434..a71df87 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3336,7 +3336,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
  *
  * This function is called with hbalock held.
  **/
-void
+static void
 lpfc_nvmet_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
 {
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
-- 
2.6.2

