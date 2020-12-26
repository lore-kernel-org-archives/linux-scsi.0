Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55469C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Dec 2020 06:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 126AA20897
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Dec 2020 06:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgLZGQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Dec 2020 01:16:05 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:55274 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbgLZGQF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Dec 2020 01:16:05 -0500
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app3 (Coremail) with SMTP id cC_KCgDnzw7o1OZfuQsQAA--.59743S4;
        Sat, 26 Dec 2020 14:15:08 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] scsi: scsi_debug: Fix memleak in scsi_debug_init
Date:   Sat, 26 Dec 2020 14:15:03 +0800
Message-Id: <20201226061503.20050-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDnzw7o1OZfuQsQAA--.59743S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4rur4fXFWxtw15urW3ZFb_yoWDtwc_Ww
        4rtryxGr1Yqw4Iv393W348XwnF9F4rWan5uF1SqryIva17X3yqgFW8Zr1UCw45uw429r17
        Kws8Zrna9r17AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJw
        CI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgYEBlZdtRrnPgAJsy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When sdeb_zbc_model does not match BLK_ZONED_NONE,
BLK_ZONED_HA or BLK_ZONED_HM, we should free sdebug_q_arr
to prevent memleak. Also there is no need to execute
sdebug_erase_store() on failure of sdeb_zbc_model_str().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---

Changelog:

v2: - Add missed assignment statement for ret.
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24c0f7ec0351..4a08c450b756 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6740,7 +6740,7 @@ static int __init scsi_debug_init(void)
 		k = sdeb_zbc_model_str(sdeb_zbc_model_s);
 		if (k < 0) {
 			ret = k;
-			goto free_vm;
+			goto free_q_arr;
 		}
 		sdeb_zbc_model = k;
 		switch (sdeb_zbc_model) {
@@ -6753,7 +6753,8 @@ static int __init scsi_debug_init(void)
 			break;
 		default:
 			pr_err("Invalid ZBC model\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_q_arr;
 		}
 	}
 	if (sdeb_zbc_model != BLK_ZONED_NONE) {
-- 
2.17.1

