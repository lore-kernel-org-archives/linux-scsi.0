Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E8BC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 11:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AE8B20757
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 11:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbgDBLP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 07:15:56 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:56012 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728803AbgDBLPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Apr 2020 07:15:55 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2020 07:15:55 EDT
Received: from ubuntu.localdomain (unknown [223.104.3.153])
        by APP-05 (Coremail) with SMTP id zQCowAAnLGyxx4VeS_XwAQ--.24489S2;
        Thu, 02 Apr 2020 19:08:33 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     kxie@chelsio.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: cxgb4i: Remove unneeded null check
Date:   Thu,  2 Apr 2020 19:08:32 +0800
Message-Id: <20200402110832.12712-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowAAnLGyxx4VeS_XwAQ--.24489S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtF4UXF1kuryDGr4UWr4UArb_yoWDGrX_K3
        yqgF429r4UWr4jyr48K3Z5Jr9Fvw4rZa4kuw4Sq3ZY9wn5AryfX3yUZFWDA345urWkAF15
        Gr47Xr18CrnxJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbFAYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I
        3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxV
        WUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAF
        wI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcI
        k0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
        Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8v_M3UUUUU==
X-Originating-IP: [223.104.3.153]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCwMOA1z4jLRprQAAsd
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In do_abort_rpl_rss, the null check of 'clk'
is unneeded to be done twice.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index bc1086ae6835..8ce8592f6a64 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1127,10 +1127,9 @@ static void do_abort_rpl_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 	if (!csk)
 		goto rel_skb;
 
-	if (csk)
-		pr_info_ipaddr("csk 0x%p,%u,0x%lx,%u, status %u.\n",
-			       (&csk->saddr), (&csk->daddr), csk,
-			       csk->state, csk->flags, csk->tid, rpl->status);
+	pr_info_ipaddr("csk 0x%p,%u,0x%lx,%u, status %u.\n",
+		       (&csk->saddr), (&csk->daddr), csk,
+		       csk->state, csk->flags, csk->tid, rpl->status);
 
 	if (rpl->status == CPL_ERR_ABORT_FAILED)
 		goto rel_skb;
-- 
2.17.1

