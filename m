Return-Path: <SRS0=1Iot=CB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27278C433E3
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Aug 2020 09:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A2620768
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Aug 2020 09:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgHWJPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Aug 2020 05:15:11 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:24886 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbgHWJPK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Aug 2020 05:15:10 -0400
Received: from localhost.localdomain (unknown [210.32.144.184])
        by mail-app4 (Coremail) with SMTP id cS_KCgBn3nmNM0JfBb47AQ--.54780S4;
        Sun, 23 Aug 2020 17:14:56 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Sun, 23 Aug 2020 17:14:53 +0800
Message-Id: <20200823091453.4782-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBn3nmNM0JfBb47AQ--.54780S4
X-Coremail-Antispam: 1UD129KBjvdXoWruFy5WF48tr1UXrWrZF1rCrg_yoW3ArX_Gr
        4xJFn2gry8GrZ7Ga4UCrs0yr9F9FWrXF1xCF1Yvas3uayrur45WF45ZF45AF1UXw4xG3Wj
        qw1kGa1fZr13tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIkFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
        Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x0JUhNVgUUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoSBlZdtPnBhABBse
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When pm8001_tag_alloc() fails, task should be freed just
like what we've done in the subsequent error paths.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 337e79d6837f..9889bab7d31c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -818,7 +818,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
-- 
2.17.1

