Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD5DC63777
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ACB52224E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgKTIhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:37:06 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:42786 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727122AbgKTIhF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 03:37:05 -0500
Received: from localhost.localdomain (unknown [124.16.141.242])
        by APP-05 (Coremail) with SMTP id zQCowAA3PJQjgLdfJUBbAQ--.19842S2;
        Fri, 20 Nov 2020 16:36:52 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     jinpu.wang@cloud.ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: remove casting kcalloc
Date:   Fri, 20 Nov 2020 08:36:48 +0000
Message-Id: <20201120083648.9319-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowAA3PJQjgLdfJUBbAQ--.19842S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr13Ary7Jr4ftF13Kr45Jrb_yoWftrc_ur
        W7trn7Kr1UCr4fCa47C3Wjva4q9F48XF1xW3WaqrZ3uas3Gr45Xa9rZr13ZF4Uua1xA3yD
        Zw18J3WxZryxGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GFyl42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIJ5rUUUUU
X-Originating-IP: [124.16.141.242]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiAw8GA13qZh0GegAAs5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove casting the values returned by kcalloc.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/scsi/pm8001/pm8001_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3cf3e58b6979..ac0e598b8ac2 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1187,8 +1187,8 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 		goto err_out;
 
 	/* Memory region for ccb_info*/
-	pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
-		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
+	pm8001_ha->ccb_info =
+		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
 	if (!pm8001_ha->ccb_info) {
 		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
 			("Unable to allocate memory for ccb\n"));
-- 
2.17.1

