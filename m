Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895CAC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 10:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5990661074
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 10:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhEXKZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 06:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhEXKZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 06:25:02 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2475C061574;
        Mon, 24 May 2021 03:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=jHeBSrLolQ
        CA4SytVaIn4xVOwyyRaTWTfTNw9hbAPns=; b=uz7Z9N36xvE+Kn769Uq2gHSnkm
        4u9SS9NXzl+vnnuf59U1hV2Ibv6E8RFMIzkmNDB6hPbG0HMbZH+C2ALKORrlOrBo
        jp0GMy8uyhd6cpE/VFkO4hy0m2xVQd5MTMsk+IyIuJ1P0aoapRDXnYdzTMoEk5XG
        ZrIgUy3AbozQZViDk=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygA3PMCcfqtgbpcKAA--.3527S4;
        Mon, 24 May 2021 18:23:24 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, mlombard@redhat.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] scsi/bnx2fc/bnx2fx_fcore: Fix a double free in bnx2fc_rcv
Date:   Mon, 24 May 2021 03:23:20 -0700
Message-Id: <20210524102320.10122-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygA3PMCcfqtgbpcKAA--.3527S4
X-Coremail-Antispam: 1UD129KBjvJXoW7XFyxXFWUWr45ur15JFy5Jwb_yoW8Jr48pa
        n2g3Z3AF4kCw1Ykw4Ut3yUCF15ua4rGr9xGa4xKan8CayfJr1FyFykta4Fqw45CFWrCw42
        qrn5tryY9a1qqF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In bnx2fc_rcv, it calls skb_share_check(skb,GFP_ATOMIC) to clone
the skb. But if skb_clone() failed, skb_share_check() will free
the skb in the first time and return NULL. Then skb_share_check()
returns NULL and goto err.

Unfortunately, the same skb is freed in the second time in the err.

As kfree_skb() free a null pointer is a safe operation, my patch
put "skb = tmp_skb;" ahead of the "if(!tmp_skb) goto err;". So that
if skb_share_check() failed, skb will be a null pointer.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8863a74e6c57..89c277cb93b2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -445,11 +445,10 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	tmp_skb = skb_share_check(skb, GFP_ATOMIC);
+	skb = tmp_skb;
 	if (!tmp_skb)
 		goto err;
 
-	skb = tmp_skb;
-
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
 		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
 		goto err;
-- 
2.25.1


