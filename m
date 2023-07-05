Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2068EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jul 2023 02:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjGEClX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Jul 2023 22:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjGEClW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jul 2023 22:41:22 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292F010E2;
        Tue,  4 Jul 2023 19:41:21 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QwkSF2VrPz4f3rBD;
        Wed,  5 Jul 2023 10:41:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgCH77JM2KRkLaXuNA--.10762S4;
        Wed, 05 Jul 2023 10:41:17 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     mhartmay@linux.ibm.com, bblock@linux.ibm.com, bvanassche@acm.org,
        hch@lst.de, axboe@kernel.dk, yukuai3@huawei.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai1@huaweicloud.com
Subject: [PATCH] scsi/sg: fix checking return value of blk_get_queue()
Date:   Wed,  5 Jul 2023 10:40:01 +0800
Message-Id: <20230705024001.177585-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCH77JM2KRkLaXuNA--.10762S4
X-Coremail-Antispam: 1UD129KBjvdXoW7JryUWryDCF1fWw48Kr4UArb_yoWkuwb_ua
        yIk347Wr4vgr1IkF15Jr13Za4vva1qgFW09FW0qa4fGr47Wrn3KF40vr15Aw47Ww409ryk
        Cwn09ws5Ar129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbzxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
        6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
        AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
        0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4
        v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Commit fcaa174a9c99 ("scsi/sg: don't grab scsi host module reference")
make a mess how blk_get_queue() is called, blk_get_queue() returns true
on success while the caller expects it returns 0 on success.

Fix this problem and also add a corresponding error message on failure.

Fixes: fcaa174a9c99 ("scsi/sg: don't grab scsi host module reference")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Closes: https://lore.kernel.org/all/87lefv622n.fsf@linux.ibm.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/scsi/sg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 89fa046c7158..0d8afffd1683 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1497,9 +1497,10 @@ sg_add_device(struct device *cl_dev)
 	int error;
 	unsigned long iflags;
 
-	error = blk_get_queue(scsidp->request_queue);
-	if (error)
-		return error;
+	if (!blk_get_queue(scsidp->request_queue)) {
+		pr_warn("%s: get scsi_device queue failed\n", __func__);
+		return -ENODEV;
+	}
 
 	error = -ENOMEM;
 	cdev = cdev_alloc();
-- 
2.39.2

