Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659A3C2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 09:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9842082E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 09:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408361AbgDOJMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 05:12:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408347AbgDOJMK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 05:12:10 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1E9E24F0DF89DDA865DB;
        Wed, 15 Apr 2020 17:12:06 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 17:11:59 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 1/3] scsi: fnic: make some symbols static
Date:   Wed, 15 Apr 2020 17:38:07 +0800
Message-ID: <20200415093809.9365-1-yanaijie@huawei.com>
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

Fix the following sparse warning:

drivers/scsi/fnic/vnic_dev.c:257:5: warning: symbol 'vnic_dev_cmd1' was
not declared. Should it be static?
drivers/scsi/fnic/vnic_dev.c:319:5: warning: symbol 'vnic_dev_cmd2' was
not declared. Should it be static?
drivers/scsi/fnic/vnic_dev.c:414:5: warning: symbol
'vnic_dev_init_devcmd1' was not declared. Should it be static?
drivers/scsi/fnic/vnic_dev.c:425:5: warning: symbol
'vnic_dev_init_devcmd2' was not declared. Should it be static?
drivers/scsi/fnic/vnic_dev.c:495:6: warning: symbol
'vnic_dev_deinit_devcmd2' was not declared. Should it be static?
drivers/scsi/fnic/vnic_dev.c:506:5: warning: symbol
'vnic_dev_cmd_no_proxy' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/vnic_dev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 1b88a3b53eee..a2beee6e09f0 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -254,7 +254,7 @@ void vnic_dev_free_desc_ring(struct vnic_dev *vdev, struct vnic_dev_ring *ring)
 	}
 }
 
-int vnic_dev_cmd1(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd, int wait)
+static int vnic_dev_cmd1(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd, int wait)
 {
 	struct vnic_devcmd __iomem *devcmd = vdev->devcmd;
 	int delay;
@@ -316,7 +316,7 @@ int vnic_dev_cmd1(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd, int wait)
 	return -ETIMEDOUT;
 }
 
-int vnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
+static int vnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 		int wait)
 {
 	struct devcmd2_controller *dc2c = vdev->devcmd2;
@@ -411,7 +411,7 @@ int vnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 }
 
 
-int vnic_dev_init_devcmd1(struct vnic_dev *vdev)
+static int vnic_dev_init_devcmd1(struct vnic_dev *vdev)
 {
 	vdev->devcmd = vnic_dev_get_res(vdev, RES_TYPE_DEVCMD, 0);
 	if (!vdev->devcmd)
@@ -422,7 +422,7 @@ int vnic_dev_init_devcmd1(struct vnic_dev *vdev)
 }
 
 
-int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
+static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 {
 	int err;
 	unsigned int fetch_index;
@@ -492,7 +492,7 @@ int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 }
 
 
-void vnic_dev_deinit_devcmd2(struct vnic_dev *vdev)
+static void vnic_dev_deinit_devcmd2(struct vnic_dev *vdev)
 {
 	vnic_dev_free_desc_ring(vdev, &vdev->devcmd2->results_ring);
 	vnic_wq_disable(&vdev->devcmd2->wq);
@@ -503,7 +503,7 @@ void vnic_dev_deinit_devcmd2(struct vnic_dev *vdev)
 }
 
 
-int vnic_dev_cmd_no_proxy(struct vnic_dev *vdev,
+static int vnic_dev_cmd_no_proxy(struct vnic_dev *vdev,
 	enum vnic_devcmd_cmd cmd, u64 *a0, u64 *a1, int wait)
 {
 	int err;
-- 
2.21.1

