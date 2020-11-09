Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32477C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 09:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1DAA20702
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 09:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgKIJKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 04:10:16 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7159 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729835AbgKIJKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 04:10:15 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CV4vd09Wzz15RcB;
        Mon,  9 Nov 2020 17:10:05 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 17:10:04 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH] scsi: qedi: fix missing destroy_workqueue() on error in __qedi_probe
Date:   Mon, 9 Nov 2020 17:15:18 +0800
Message-ID: <20201109091518.55941-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the missing destroy_workqueue() before return from
__qedi_probe in the error handling case when fails to
create workqueue qedi->offload_thread.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/scsi/qedi/qedi_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 61fab01d2d52..f5fc7f518f8a 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2766,7 +2766,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
 			rc = -ENODEV;
-			goto free_cid_que;
+			goto free_tmf_thread;
 		}
 
 		INIT_DELAYED_WORK(&qedi->recovery_work, qedi_recovery_handler);
@@ -2790,6 +2790,8 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 
 	return 0;
 
+free_tmf_thread:
+	destroy_workqueue(qedi->tmf_thread);
 free_cid_que:
 	qedi_release_cid_que(qedi);
 free_uio:
-- 
2.23.0

