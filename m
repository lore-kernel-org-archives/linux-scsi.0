Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA9CC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 09:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E603420768
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 09:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635920AbgDOJMj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 05:12:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408349AbgDOJMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 05:12:13 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 30489A6CD76B3349AA29;
        Wed, 15 Apr 2020 17:12:11 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 17:12:00 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 3/3] scsi: fnic: make vnic_wq_get_ctrl and vnic_wq_alloc_ring static
Date:   Wed, 15 Apr 2020 17:38:09 +0800
Message-ID: <20200415093809.9365-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200415093809.9365-1-yanaijie@huawei.com>
References: <20200415093809.9365-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/fnic/vnic_wq.c:28:5: warning: symbol 'vnic_wq_get_ctrl' was
not declared. Should it be static?
drivers/scsi/fnic/vnic_wq.c:40:5: warning: symbol 'vnic_wq_alloc_ring'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/vnic_wq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_wq.c b/drivers/scsi/fnic/vnic_wq.c
index 015af2cdabaf..442972c04e65 100644
--- a/drivers/scsi/fnic/vnic_wq.c
+++ b/drivers/scsi/fnic/vnic_wq.c
@@ -25,7 +25,7 @@
 #include "vnic_wq.h"
 
 
-int vnic_wq_get_ctrl(struct vnic_dev *vdev, struct vnic_wq *wq,
+static int vnic_wq_get_ctrl(struct vnic_dev *vdev, struct vnic_wq *wq,
 		unsigned int index, enum vnic_res_type res_type)
 {
 	wq->ctrl = vnic_dev_get_res(vdev, res_type, index);
@@ -37,7 +37,7 @@ int vnic_wq_get_ctrl(struct vnic_dev *vdev, struct vnic_wq *wq,
 }
 
 
-int vnic_wq_alloc_ring(struct vnic_dev *vdev, struct vnic_wq *wq,
+static int vnic_wq_alloc_ring(struct vnic_dev *vdev, struct vnic_wq *wq,
 		unsigned int desc_count, unsigned int desc_size)
 {
 	return vnic_dev_alloc_desc_ring(vdev, &wq->ring, desc_count, desc_size);
-- 
2.21.1

