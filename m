Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B16C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 08:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1B2215A4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 08:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgIIIUc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:20:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11289 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbgIIIUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Sep 2020 04:20:31 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 25B2D1291ED494492324;
        Wed,  9 Sep 2020 16:20:30 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 16:20:23 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <james.smart@broadcom.com>,
        <dick.kennedy@broadcom.com>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: lpfc: Remove set but not used 'qp'
Date:   Wed, 9 Sep 2020 16:27:16 +0800
Message-ID: <20200909082716.37787-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/lpfc/lpfc_debugfs.c: In function ‘lpfc_debugfs_hdwqstat_data’:
drivers/scsi/lpfc/lpfc_debugfs.c:1699:30: warning: variable ‘qp’ set but
not used [-Wunused-but-set-variable]
  struct lpfc_sli4_hdw_queue *qp;
                                ^
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index d6c07eeedd69..c9a327b13e5c 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1696,7 +1696,6 @@ static int
 lpfc_debugfs_hdwqstat_data(struct lpfc_vport *vport, char *buf, int size)
 {
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_sli4_hdw_queue *qp;
 	struct lpfc_hdwq_stat *c_stat;
 	int i, j, len;
 	uint32_t tot_xmt;
@@ -1726,8 +1725,6 @@ lpfc_debugfs_hdwqstat_data(struct lpfc_vport *vport, char *buf, int size)
 		goto buffer_done;
 
 	for (i = 0; i < phba->cfg_hdw_queue; i++) {
-		qp = &phba->sli4_hba.hdwq[i];
-
 		tot_rcv = 0;
 		tot_xmt = 0;
 		tot_cmpl = 0;
-- 
2.16.2.dirty

