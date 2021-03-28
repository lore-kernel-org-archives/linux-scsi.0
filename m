Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B95C433C1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 08:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7054C61950
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 08:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhC1IQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 04:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhC1IQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Mar 2021 04:16:20 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20050C061762;
        Sun, 28 Mar 2021 01:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=7u9Bgk9oEJ
        z1bBIjfI12UBnidj1IuNItVEUVU4M2CdE=; b=hd+WDkqbWzLawkk/MHeknDiIgL
        JO4Q6yCCBnFs5DGcWBgqwetl9+0B59Zku8kzl65bSZU/WfkpPDR5VeZ93tg+pZfA
        mXVhxMvkgp+TRnusvYNZQc78fWJyR1ukOT4LH4IwTARCStip5Oy3pWjSRnFcn/ou
        obEKF/t3wkeBArMyk=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHDk5HO2BgDdNcAA--.3711S4;
        Sun, 28 Mar 2021 16:16:07 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] scsi/bnx2fc/bnx2fx_fcore: Fix a double free in bnx2fc_rcv
Date:   Sun, 28 Mar 2021 01:16:03 -0700
Message-Id: <20210328081603.5428-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAHDk5HO2BgDdNcAA--.3711S4
X-Coremail-Antispam: 1UD129KBjvJXoW7XFyxXFWUWr45ur15JFy5Jwb_yoW8Jr4xpa
        n2q3W5CFs5Cw4jkr4jq3yUGw15Ca4rJr9xKayxKan8CayfJr1FyF95tay0qr45GFWrCw42
        qrn5tFyY9a1qqF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUeFALDUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In bnx2fc_rcv, it calls skb_share_check(skb,GFP_ATOMIC) to clone
the skb. But if skb_clone() failed, skb_share_check() will free
the skb in the first time and return NULL. Then skb_share_check()
returns NULL and goto err.

Unfortunately, the same skb is freed in the second time in err.

I think moving skb = tmp_skb in front of if(!tmp_err) goto err
is a good solution, because freeing a NULL skb is safe.

Fixes: 01a4cc4d0cd6a ("bnx2fc: do not add shared skbs to the fcoe_rx_list")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 16bb6d2f98de..2e213d336ebe 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -445,11 +445,11 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	tmp_skb = skb_share_check(skb, GFP_ATOMIC);
+	skb = tmp_skb;
+
 	if (!tmp_skb)
 		goto err;
 
-	skb = tmp_skb;
-
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
 		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
 		goto err;
-- 
2.25.1


