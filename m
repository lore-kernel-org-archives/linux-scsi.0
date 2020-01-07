Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BE1C32771
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 01:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351702072E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 01:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgAGBuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 20:50:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727326AbgAGBuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jan 2020 20:50:13 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 93F2980698AF33B79D63;
        Tue,  7 Jan 2020 09:50:09 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 09:50:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: lpfc: Make lpfc_defer_acc_rsp static
Date:   Tue, 7 Jan 2020 09:49:56 +0800
Message-ID: <20200107014956.41748-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix sparse warning:

drivers/scsi/lpfc/lpfc_nportdisc.c:344:1: warning:
 symbol 'lpfc_defer_acc_rsp' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 1c46e3a..a024e5a 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -340,7 +340,7 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
  * This routine is only called if we are SLI4, acting in target
  * mode and the remote NPort issues the PLOGI after link up.
  **/
-void
+static void
 lpfc_defer_acc_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
-- 
2.7.4


