Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85118C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Dec 2020 08:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 494C2230FF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Dec 2020 08:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgLYIpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Dec 2020 03:45:05 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:43554 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbgLYIpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Dec 2020 03:45:05 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Dec 2020 03:45:04 EST
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app3 (Coremail) with SMTP id cC_KCgBHSQxJpOVfUMgHAA--.32869S4;
        Fri, 25 Dec 2020 16:35:25 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
Date:   Fri, 25 Dec 2020 16:35:20 +0800
Message-Id: <20201225083520.22015-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgBHSQxJpOVfUMgHAA--.32869S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WF15Wr17uFW3tw45CFWktFb_yoW8XF4xpF
        yfKa4rAFyxJ3WUXr4UJa1ru3W5uayxAa48WrWjg39rXFy3CFyktF18try3XrWkXr97AF4x
        ZFn8A3WI9F1DKw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgYEBlZdtRrnPgADs4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When ioread32() returns 0xFFFFFFFF, we should execute
cleanup functions like other error handling paths before
returning.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/scsi/fnic/vnic_dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index a2beee6e09f0..5988c300cc82 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -444,7 +444,8 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	fetch_index = ioread32(&vdev->devcmd2->wq.ctrl->fetch_index);
 	if (fetch_index == 0xFFFFFFFF) { /* check for hardware gone  */
 		pr_err("error in devcmd2 init");
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_free_wq;
 	}
 
 	/*
@@ -460,7 +461,7 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	err = vnic_dev_alloc_desc_ring(vdev, &vdev->devcmd2->results_ring,
 			DEVCMD2_RING_SIZE, DEVCMD2_DESC_SIZE);
 	if (err)
-		goto err_free_wq;
+		goto err_disable_wq;
 
 	vdev->devcmd2->result =
 		(struct devcmd2_result *) vdev->devcmd2->results_ring.descs;
@@ -481,8 +482,9 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 
 err_free_desc_ring:
 	vnic_dev_free_desc_ring(vdev, &vdev->devcmd2->results_ring);
-err_free_wq:
+err_disable_wq:
 	vnic_wq_disable(&vdev->devcmd2->wq);
+err_free_wq:
 	vnic_wq_free(&vdev->devcmd2->wq);
 err_free_devcmd2:
 	kfree(vdev->devcmd2);
-- 
2.17.1

