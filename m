Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B05C8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7074A2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgD3MSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:18:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50036 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbgD3MSE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 08:18:04 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D86A06C30710E0D82DAD;
        Thu, 30 Apr 2020 20:18:02 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 20:17:53 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: fnic: use true,false for fnic->internal_reset_inprogress
Date:   Thu, 30 Apr 2020 20:17:18 +0800
Message-ID: <20200430121718.14970-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

drivers/scsi/fnic/fnic_scsi.c:2627:5-36: WARNING: Comparison of 0/1 to
bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b60795893994..27535c90b248 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2624,8 +2624,8 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	unsigned long flags;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (fnic->internal_reset_inprogress == 0) {
-		fnic->internal_reset_inprogress = 1;
+	if (!fnic->internal_reset_inprogress) {
+		fnic->internal_reset_inprogress = true;
 	} else {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2654,7 +2654,7 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	}
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	fnic->internal_reset_inprogress = 0;
+	fnic->internal_reset_inprogress = false;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 	return ret;
 }
-- 
2.21.1

