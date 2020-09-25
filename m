Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BF1C4727F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C38672311B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgIYGID (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:08:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40416 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727240AbgIYGID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 02:08:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6D1260DFD6FBC84E4AB;
        Fri, 25 Sep 2020 14:08:00 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 14:07:51 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <kartilak@cisco.com>, <sebaddel@cisco.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] scsi: snic: Remove unnecessary condition to simplify the code
Date:   Fri, 25 Sep 2020 14:07:54 +0800
Message-ID: <20200925060754.156599-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ret is always zero or an error in this code path. So the assignment to
ret is redundant, and the code jumping to a label is unneed.
Let's remove them to simplify the code. No functional changes.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/snic/snic_scsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index b3650c989ed4..0c2f31b8ea05 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1387,10 +1387,6 @@ snic_issue_tm_req(struct snic *snic,
 	}
 
 	ret = snic_queue_itmf_req(snic, tmreq, sc, tmf, req_id);
-	if (ret)
-		goto tmreq_err;
-
-	ret = 0;
 
 tmreq_err:
 	if (ret) {
-- 
2.17.1

