Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CFCC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Dec 2020 09:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E533A230FF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Dec 2020 09:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgLYJCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Dec 2020 04:02:30 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:39872 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbgLYJC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Dec 2020 04:02:29 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Dec 2020 04:02:28 EST
Received: from localhost.localdomain (unknown [124.16.141.241])
        by APP-03 (Coremail) with SMTP id rQCowABnb8OQqOVfvmWoAA--.14888S2;
        Fri, 25 Dec 2020 16:53:36 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Remove redundant NULL check
Date:   Fri, 25 Dec 2020 08:53:33 +0000
Message-Id: <20201225085333.65091-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowABnb8OQqOVfvmWoAA--.14888S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XrWfGr43Xr4UXF13WFWkCrg_yoWkWFXEvr
        WjqryIqr1UWwn7WF18GFy5Aan7uFy2gF1vvr4YvFyrAr4UXwnrCrnxXF4Ygw1Yq3y7Kan8
        Aw48X3yvyw1jkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbc8YjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr
        1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GFyl42xK
        82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4knYUUUUU
X-Originating-IP: [124.16.141.241]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQkBA102Z0oJYwAAsu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix warnings reported by coccicheck:
./drivers/scsi/qla2xxx/qla_os.c:4636:2-7: WARNING: NULL check before some freeing functions is not needed.
./drivers/scsi/qla2xxx/qla_os.c:4651:3-8: WARNING: NULL check before some freeing functions is not needed.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f80abe28f35a..bc7bff3539b4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4632,8 +4632,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
 		dma_free_coherent(&ha->pdev->dev,
 		    EFT_SIZE, ha->eft, ha->eft_dma);
 
-	if (ha->fw_dump)
-		vfree(ha->fw_dump);
+	vfree(ha->fw_dump);
 
 	ha->fce = NULL;
 	ha->fce_dma = 0;
@@ -4647,8 +4646,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
 	ha->fw_dump_len = 0;
 
 	for (j = 0; j < 2; j++, fwdt++) {
-		if (fwdt->template)
-			vfree(fwdt->template);
+		vfree(fwdt->template);
 		fwdt->template = NULL;
 		fwdt->length = 0;
 	}
-- 
2.17.1

