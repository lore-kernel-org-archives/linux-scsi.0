Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90241C43463
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 13:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 620F52076E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 13:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgIUNLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 09:11:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13806 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727446AbgIUNKw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:52 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DE11319AC4F8DDEF2E50;
        Mon, 21 Sep 2020 21:10:49 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:39 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next] scsi: fnic: simplify the return expression of vnic_cq_alloc()
Date:   Mon, 21 Sep 2020 21:11:03 +0800
Message-ID: <20200921131103.93132-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/scsi/fnic/vnic_cq.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_cq.c b/drivers/scsi/fnic/vnic_cq.c
index c5db32eda..97f04d3f8 100644
--- a/drivers/scsi/fnic/vnic_cq.c
+++ b/drivers/scsi/fnic/vnic_cq.c
@@ -31,8 +31,6 @@ void vnic_cq_free(struct vnic_cq *cq)
 int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsigned int index,
 	unsigned int desc_count, unsigned int desc_size)
 {
-	int err;
-
 	cq->index = index;
 	cq->vdev = vdev;
 
@@ -42,11 +40,7 @@ int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsigned int index,
 		return -EINVAL;
 	}
 
-	err = vnic_dev_alloc_desc_ring(vdev, &cq->ring, desc_count, desc_size);
-	if (err)
-		return err;
-
-	return 0;
+	return vnic_dev_alloc_desc_ring(vdev, &cq->ring, desc_count, desc_size);
 }
 
 void vnic_cq_init(struct vnic_cq *cq, unsigned int flow_control_enable,
-- 
2.23.0

